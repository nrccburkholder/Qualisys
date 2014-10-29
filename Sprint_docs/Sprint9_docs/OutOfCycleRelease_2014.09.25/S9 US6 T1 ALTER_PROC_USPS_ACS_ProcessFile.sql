/*
S9.US6	Add litho code & Deploy USPS ACS Service	
		As an Operations Associate, I want the system to automatically process Address Change Service data from the USPS, so that I do not have to do this work manually
T6.1	Modify the matching procedure so it logs litho along with everything else. 

Dave Gilsdorf

ALTER TABLE dbo.USPS_ACS_ExtractFile_PartialMatch
ALTER PROCEDURE dbo.USPS_ACS_ProcessFile
alter procedure dbo.usps_acs_selectpartialmatches
*/
use qp_prod
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'strLithocode' )
	ALTER TABLE dbo.USPS_ACS_ExtractFile_PartialMatch ADD strLithocode varchar(10)
GO
ALTER PROCEDURE dbo.USPS_ACS_ProcessFile
@USPS_ACS_ExtractFileLog_ID int
as

--declare @USPS_ACS_ExtractFileLog_ID int
--set @USPS_ACS_ExtractFileLog_ID=2

declare @daysBack int, @headerDate datetime

select @daysBack=numParam_Value 
from qualpro_params 
where strParam_nm='USPS_ACS_SentMailingRange'


select @headerDate=headerDate 
from USPS_ACS_ExtractFileLog 
where USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

if exists (select * from qualpro_params where strParam_nm='EnvName' and strParam_Value <> 'Production')
	set @headerdate=getdate()  -- for non production environments only 

create table #studylist (study_id int, sampleset_id int, flag tinyint)

-- list of studies that have surveys that use the USPS Address Change Service and have mailed items within the last @daysBack days
insert into #studylist
select distinct sd.study_id, ss.sampleset_id, 0 as flag
from survey_def sd
inner join sampleset ss on sd.survey_id=ss.survey_id 
inner join samplepop sp on ss.sampleset_id=sp.sampleset_id
inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where sd.UseUSPSAddrChangeService=1
and sm.datmailed between dateadd(day,-@daysBack,@headerDate) and @headerDate
and ms.intsequence=1 -- only the first mailpiece will have address correction requests

create table #pop (study_id int
	, pop_id int
	, strLithocode varchar(10)
	, Fname varchar(42)
	, Lname varchar(42)
	, addr  varchar(60)
	, addr2  varchar(42)
	, city  varchar(42)
	, st  varchar(2)
	, zip5 varchar(5)
	, zip4 varchar(4)
	)

declare @study varchar(10), @SQL varchar(max)
select top 1 @study=study_id from #StudyList where flag=0
while @@rowcount>0
begin
	set @SQL = 'insert into #pop (study_id, pop_id, strLithocode, fname, lname, addr, addr2, city, st, zip5, zip4)
	select '+@study+', p.pop_id, min(sm.strLithocode), p.Fname, p.Lname, p.addr, p.addr2, p.city, p.st, p.zip5, p.zip4
	from s'+@study+'.population p
	inner join samplepop sp on p.pop_id=sp.pop_id and sp.study_id='+@study+'
	inner join #studylist sl on sp.study_id=sl.study_id and sp.sampleset_id=sl.sampleset_id
	inner join scheduledmailing scm on sp.samplepop_id=scm.samplepop_id
	inner join sentmailing sm on scm.sentmail_id=sm.sentmail_id
	inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
	where sm.datmailed >= dateadd(day,-'+convert(varchar,@daysback)+',getdate())
	and ms.intsequence=1 
	group by p.pop_id, p.Fname, p.Lname, p.addr, p.addr2, p.city, p.st, p.zip5, p.zip4'
	
	exec (@SQL)	
	
	update #studyList set flag=1 where study_id=@study
	select top 1 @study=study_id from #StudyList where flag=0
end

create index tmp_ndx on #pop (lname, st, zip5)

select p.study_id, p.pop_id, p.strLithocode, w.USPS_ACS_ExtractFile_Work_ID, w.USPS_ACS_ExtractFile_ID, w.addressnew, w.address2new, w.citynew, w.statenew, w.zip5new, w.Plus4ZipNew, convert(varchar(20),null) as [Status]
, case when p.fname=w.fname 
		and p.addr like '%'+w.StreetNameOld+'%'
		and isnull(p.addr2,'') like '%'+SecondaryNumberOld+'%' 
		and p.city=w.cityold then 1 else 0 
	end as FullMatch
, p.fname as popFname, p.lname as popLname, p.addr as popAddr, p.addr2 as popAddr2, p.city as popCity, p.st as popSt, p.zip5 as popZip5
, w.fname as uspsFname, w.lname as uspsLname, w.primarynumberold, w.streetnameold, w.secondarynumberold, w.cityold, w.stateold, w.zip5old
into #matches
from #pop p 
inner join USPS_ACS_extractfile_work w 
	on p.lname=w.lname 
		and p.st=w.stateold
		and p.zip5=w.zip5old
		and p.addr like '%'+w.PrimaryNumberOld+'%'
inner join USPS_ACS_extractfile f on w.USPS_ACS_ExtractFile_ID=f.USPS_ACS_ExtractFile_ID 
where f.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

-- 1 match:
update #matches 
set [Status]='Completed'
from #matches 
where USPS_ACS_ExtractFile_ID in (	select USPS_ACS_ExtractFile_ID
									from #matches m
									group by USPS_ACS_ExtractFile_ID
									having count(*)=1)

-- >1 match:
update #matches 
set [Status]='MultipleMatches'
from #matches 
where USPS_ACS_ExtractFile_ID in (	select USPS_ACS_ExtractFile_ID
									from #matches m
									group by USPS_ACS_ExtractFile_ID
									having count(*)>1)

-- if any of the MultipleMatches has one and only one FullMatch, delete the partial match(es) and set the [Status] to Completed
if @@rowcount>0
begin
	update #matches 
	set [Status]='1 full match'
	where USPS_ACS_ExtractFile_Work_ID in (	select min(USPS_ACS_ExtractFile_Work_ID) as USPS_ACS_ExtractFile_Work_ID
											from #matches
											where FullMatch=1
											and [Status]='MultipleMatches'
											group by USPS_ACS_ExtractFile_ID
											having count(*)=1 )
	delete #matches
	where [Status]='MultipleMatches'
	and USPS_ACS_ExtractFile_ID in (select USPS_ACS_ExtractFile_ID from #matches where [Status]='1 full match')
	
	update #matches set [Status]='Completed' where [Status]='1 full match'
end

update #matches set [Status]='PartialMatch' where [Status]='Completed' and fullmatch=0

-- 0 match:
update ef 
set [Status]='Not_Found', DateModified=getdate()
from USPS_ACS_extractfile ef
where ef.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID
and [Status]='New'
and USPS_ACS_ExtractFile_ID not in (select USPS_ACS_ExtractFile_ID from #matches)

update ef
set [Status]=m.[Status], DateModified=getdate()
from USPS_ACS_extractfile ef
inner join #matches m on ef.USPS_ACS_ExtractFile_ID=m.USPS_ACS_ExtractFile_ID

insert into USPS_ACS_ExtractFile_PartialMatch (Study_id,Pop_id,strLithocode,[Status],FullMatch,popFname,popLname,popAddr,popAddr2,popCity,popSt,popZip5,
	USPS_ACS_ExtractFile_Work_ID,USPS_ACS_ExtractFile_ID,FName,LName,
	PrimaryNumberOld,PreDirectionalOld,StreetNameOld,StreetSuffixOld,PostDirectionalOld,UnitDesignatorOld,SecondaryNumberOld,CityOld,StateOld,Zip5Old,
	PrimaryNumberNew,PreDirectionalNew,StreetNameNew,StreetSuffixNew,PostDirectionalNew,UnitDesignatorNew,SecondaryNumberNew,CityNew,StateNew,Zip5New,Plus4ZipNew,AddressNew,Address2New)
select m.Study_id,m.Pop_id,m.strLithocode,m.[Status],m.FullMatch,m.popFname,m.popLname,m.popAddr,m.popAddr2,m.popCity,m.popSt,m.popZip5,
	w.USPS_ACS_ExtractFile_Work_ID,w.USPS_ACS_ExtractFile_ID,w.FName,w.LName,
	w.PrimaryNumberOld,w.PreDirectionalOld,w.StreetNameOld,w.StreetSuffixOld,w.PostDirectionalOld,w.UnitDesignatorOld,w.SecondaryNumberOld,w.CityOld,w.StateOld,w.Zip5Old,
	w.PrimaryNumberNew,w.PreDirectionalNew,w.StreetNameNew,w.StreetSuffixNew,w.PostDirectionalNew,w.UnitDesignatorNew,w.SecondaryNumberNew,w.CityNew,w.StateNew,w.Zip5New,w.Plus4ZipNew,w.AddressNew,w.Address2New
from #matches m
inner join USPS_ACS_extractfile_work w on m.USPS_ACS_ExtractFile_Work_ID=w.USPS_ACS_ExtractFile_Work_ID
where m.[status] in ('PartialMatch','MultipleMatches')

select top 1 @study=study_id from #Matches where [status]='Completed'
while @@rowcount>0
begin
	set @SQL = 'update p
	set addr=left(m.AddressNew,60), addr2=m.Address2New, City=m.CityNew, St=m.StateNew, zip5=m.Zip5New, zip4=m.Plus4ZipNew
	, AddrStat=NULL, AddrErr=NULL, Del_Pt=NULL
	from s'+@study+'.population p
	inner join #matches m on p.pop_id=m.pop_id and m.study_id='+@study+'
	where [status]=''Completed'''
	
	exec (@SQL)	
	
	update #matches set [status]='updated' where study_id=@study and [status]='Completed'
	select top 1 @study=study_id from #Matches where [status]='Completed'
end

delete W
from USPS_ACS_extractfile_work w 
inner join USPS_ACS_extractfile f on w.USPS_ACS_ExtractFile_ID=f.USPS_ACS_ExtractFile_ID 
where f.USPS_ACS_ExtractFileLog_ID=@USPS_ACS_ExtractFileLog_ID

drop table #pop
drop table #studyList
drop table #matches
go
ALTER PROCEDURE [dbo].[USPS_ACS_SelectPartialMatches]
@MarkNotified as bit = 0

AS
BEGIN
	SELECT [USPS_ACS_ExtractFile_PartialMatch_id]
      ,pm.[Study_id]
      ,pm.[Pop_id]
      ,PM.[strLithocode]
      ,pm.[Status]
      ,pm.[FullMatch]
      ,pm.[popFname]
      ,pm.[popLname]
      ,pm.[popAddr]
      ,pm.[popAddr2]
      ,pm.[popCity]
      ,pm.[popSt]
      ,pm.[popZip5]
      ,pm.[USPS_ACS_ExtractFile_Work_ID]
      ,pm.[USPS_ACS_ExtractFile_ID]
      ,pm.[FName]
      ,pm.[LName]
      ,pm.[PrimaryNumberOld]
      ,pm.[PreDirectionalOld]
      ,pm.[StreetNameOld]
      ,pm.[StreetSuffixOld]
      ,pm.[PostDirectionalOld]
      ,pm.[UnitDesignatorOld]
      ,pm.[SecondaryNumberOld]
      ,pm.[CityOld]
      ,pm.[StateOld]
      ,pm.[Zip5Old]
      ,pm.[PrimaryNumberNew]
      ,pm.[PreDirectionalNew]
      ,pm.[StreetNameNew]
      ,pm.[StreetSuffixNew]
      ,pm.[PostDirectionalNew]
      ,pm.[UnitDesignatorNew]
      ,pm.[SecondaryNumberNew]
      ,pm.[CityNew]
      ,pm.[StateNew]
      ,pm.[Zip5New]
      ,pm.[Plus4ZipNew]
      ,pm.[AddressNew]
      ,pm.[Address2New]
	INTO #PartialMatches
	FROM [dbo].[USPS_ACS_ExtractFile_PartialMatch] pm
	INNER JOIN [dbo].[USPS_ACS_ExtractFile] ef on ef.usps_acs_extractfile_id = pm.usps_acs_extractfile_id
	WHERE ef.IsNotified = 0

	-- set IsNotified to 1 for each partial match returned
	if @MarkNotified = 1
	begin
		Update ef
			SET IsNotified = 1
		FROM USPS_ACS_ExtractFile ef
		INNER JOIN #PartialMatches pm ON pm.USPS_ACS_ExtractFile_ID = ef.USPS_ACS_ExtractFile_ID
	end

	SELECT *
	FROM #PartialMatches

	DROP TABLE #PartialMatches

END
go
commit tran