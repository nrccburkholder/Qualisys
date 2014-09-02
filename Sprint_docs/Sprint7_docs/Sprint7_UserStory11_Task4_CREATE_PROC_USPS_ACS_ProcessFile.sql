use qp_prod
go
if exists (select * from sys.tables where name = 'USPS_ACS_ExtractFile_PartialMatch')
	drop table dbo.USPS_ACS_ExtractFile_PartialMatch
go
create table dbo.USPS_ACS_ExtractFile_PartialMatch (USPS_ACS_ExtractFile_PartialMatch_id int identity(1,1),
	Study_id int,
	Pop_id int,
	[Status] varchar(20),
	FullMatch bit,
	popFname varchar(42),
	popLname varchar(42),
	popAddr varchar(60),
	popAddr2 varchar(42),
	popCity varchar(42),
	popSt varchar(2),
	popZip5 varchar(5),
	[USPS_ACS_ExtractFile_Work_ID] [int] NOT NULL,
	[USPS_ACS_ExtractFile_ID] [int] NULL,
	[FName] [varchar](15) NULL,
	[LName] [varchar](20) NULL,
	[PrimaryNumberOld] [varchar](10) NULL,
	[PreDirectionalOld] [varchar](2) NULL,
	[StreetNameOld] [varchar](28) NULL,
	[StreetSuffixOld] [varchar](4) NULL,
	[PostDirectionalOld] [varchar](2) NULL,
	[UnitDesignatorOld] [varchar](4) NULL,
	[SecondaryNumberOld] [varchar](10) NULL,
	[CityOld] [varchar](28) NULL,
	[StateOld] [varchar](2) NULL,
	[Zip5Old] [varchar](5) NULL,
	[PrimaryNumberNew] [varchar](10) NULL,
	[PreDirectionalNew] [varchar](2) NULL,
	[StreetNameNew] [varchar](28) NULL,
	[StreetSuffixNew] [varchar](4) NULL,
	[PostDirectionalNew] [varchar](2) NULL,
	[UnitDesignatorNew] [varchar](4) NULL,
	[SecondaryNumberNew] [varchar](10) NULL,
	[CityNew] [varchar](28) NULL,
	[StateNew] [varchar](2) NULL,
	[Zip5New] [varchar](5) NULL,
	[Plus4ZipNew] [varchar](4) NULL,
	[AddressNew] [varchar](66) NULL,
	[Address2New] [varchar](14) NULL,
 CONSTRAINT [PK_USPS_ACS_ExtractFile_PartialMatch_id] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_PartialMatch_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
if exists (select * from sys.procedures where name = 'USPS_ACS_ProcessFile')
	drop procedure dbo.USPS_ACS_ProcessFile
go
create procedure dbo.USPS_ACS_ProcessFile
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
	set @SQL = 'insert into #pop (study_id, pop_id, fname, lname, addr, addr2, city, st, zip5, zip4)
	select '+@study+', p.pop_id, p.Fname, p.Lname, p.addr, p.addr2, p.city, p.st, p.zip5, p.zip4
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

select p.study_id, p.pop_id, w.USPS_ACS_ExtractFile_Work_ID, w.USPS_ACS_ExtractFile_ID, w.addressnew, w.address2new, w.citynew, w.statenew, w.zip5new, w.Plus4ZipNew, convert(varchar(20),null) as [Status]
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

insert into USPS_ACS_ExtractFile_PartialMatch (Study_id,Pop_id,[Status],FullMatch,popFname,popLname,popAddr,popAddr2,popCity,popSt,popZip5,
	USPS_ACS_ExtractFile_Work_ID,USPS_ACS_ExtractFile_ID,FName,LName,
	PrimaryNumberOld,PreDirectionalOld,StreetNameOld,StreetSuffixOld,PostDirectionalOld,UnitDesignatorOld,SecondaryNumberOld,CityOld,StateOld,Zip5Old,
	PrimaryNumberNew,PreDirectionalNew,StreetNameNew,StreetSuffixNew,PostDirectionalNew,UnitDesignatorNew,SecondaryNumberNew,CityNew,StateNew,Zip5New,Plus4ZipNew,AddressNew,Address2New)
select m.Study_id,m.Pop_id,m.[Status],m.FullMatch,m.popFname,m.popLname,m.popAddr,m.popAddr2,m.popCity,m.popSt,m.popZip5,
	w.USPS_ACS_ExtractFile_Work_ID,w.USPS_ACS_ExtractFile_ID,w.FName,w.LName,
	w.PrimaryNumberOld,w.PreDirectionalOld,w.StreetNameOld,w.StreetSuffixOld,w.PostDirectionalOld,w.UnitDesignatorOld,w.SecondaryNumberOld,w.CityOld,w.StateOld,w.Zip5Old,
	w.PrimaryNumberNew,w.PreDirectionalNew,w.StreetNameNew,w.StreetSuffixNew,w.PostDirectionalNew,w.UnitDesignatorNew,w.SecondaryNumberNew,w.CityNew,w.StateNew,w.Zip5New,w.Plus4ZipNew,w.AddressNew,w.Address2New
from #matches m
inner join USPS_ACS_extractfile_work w on m.USPS_ACS_ExtractFile_Work_ID=w.USPS_ACS_ExtractFile_Work_ID
where m.[status]='PartialMatch'

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