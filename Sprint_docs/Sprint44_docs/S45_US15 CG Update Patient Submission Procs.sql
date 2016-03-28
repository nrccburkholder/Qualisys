/*

	S45 US 15 CG: Update Patient Submission Procs
	As a CG-CAHPS vendor, we need to update the existing submission file sprocs for patient data, so that we can submit files.

	12.3 - Make necessary changes to identified procedures to contain new Layout specifications

	ALTER PROC GetCGCAHPSdata2
	ALTER PROC GetCGCAHPSdata2_sub_Adult12MonthA
	ALTER PROC GetCGCAHPSdata2_sub_Adult12MonthB
	ALTER PROC GetCGCAHPSdata2_sub_Adult12MonthPCMHa
	ALTER PROC GetCGCAHPSdata2_sub_Adult12MonthPCMHb
	ALTER PROC GetCGCAHPSdata2_sub_Adult6MonthA
	ALTER PROC GetCGCAHPSdata2_sub_Adult6MonthB
	ALTER PROC GetCGCAHPSdata2_sub_Adult6MonthPCMHa
	ALTER PROC GetCGCAHPSdata2_sub_Adult6MonthPCMHb
	ALTER PROC GetCGCAHPSdata2_sub_AdultVisitA
	ALTER PROC GetCGCAHPSdata2_sub_AdultVisitB
	ALTER PROC GetCGCAHPSdata2_sub_Child12MonthPCMHa
	ALTER PROC GetCGCAHPSdata2_sub_Child12MonthPCMHb
	ALTER PROC GetCGCAHPSdata2_sub_Child6Montha
	ALTER PROC GetCGCAHPSdata2_sub_Child6Monthb
	ALTER PROC GetCGCAHPSdata2_sub_Child6MonthPCMHa
	ALTER PROC GetCGCAHPSdata2_sub_Child6MonthPCMHb
	CREATE procedure GetCGCAHPSdata2_sub_Adult6Month30A
	CREATE procedure GetCGCAHPSdata2_sub_Adult6Month30B
	CREATE procedure GetCGCAHPSdata2_sub_Child6Month30a
	CREATE procedure GetCGCAHPSdata2_sub_Child6Month30b
	CREATE procedure GetCGCAHPSdata2_sub_Child12MonthA
	CREATE procedure GetCGCAHPSdata2_sub_Child12MonthB

	Dave Gilsdorf
*/
use qp_comments
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2')
	drop procedure GetCGCAHPSdata2
go
create PROCEDURE dbo.GetCGCAHPSdata2
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10),
 @ReturnGrid bit = 0
AS
/**
12/14/2010 dmp
Modified GetMNCMData_Quello SP to create GetCGCAHPSData SP.
Changes to MNCM proc:
**Turned on NOCOUNT so users won't have to delete those lines from the results
**Change source metafield serviceind_3 to cg_siteid
**Change source metafield serviceind_4 to cg_groupid
**Change source metafield drspec to cg_physspec
**Change source field gender to cg_physsex
**Change source metafield servicedate to datsampleencounterdate.
  Some CG-CAHPS surveys sample using DischargeDate instead of ServiceDate.
**Set disposition to 38 (max attempts) if MNCMDisposition is null. Have to do this because some
  of these records were sampled before the surveys were set to survey type MNCM, so have nulls.
**Some older surveys use(d) Q039161 instead of Q040716 for the how-helped question. Need to be able
  to accomodate either core or both.
  So, added a check of INFORMATION_SCHEMA.COLUMNS to see which column(s) exist in the view
  and code to create dynamic SQL variable to pull from the correct field.
**Changed join to study_results_view from inner to left outer,
  as we should be including records for everyone who was sampled.
  Also added code to create temp table and get mailing step info before the select to get
  the file data. We lose the non-returns if we join sentmailing to study_results,
  and other joins using big_table caused duplicate records for the two mail steps.

01/12/2012 dmp
**Changed else for Q4 to get rid of leading zeroes where original value > 10000

01/16/2012 dmp
**Changed group and site IDs to be right aligned to match group and practice site files

01/22/2011 dmp
**Added isNumeric and length checks to zip5 to replace bad data with 99999 (value for missing)

02/20/2013 dbg
modified getcgchapsdata to create getcgcahpsdata2 - which exports questions related to version 2.0 of the CG CAHPS survey
changed the structure of the proc to (hopefully) make it more readable.

04/26/2013 dbg
added WCHQClinicID column to the CGCAHPSPracticeSite table and added @useWiscID as a parameter to this procedure.
if @useWiscID=1, replace CGPracticeSiteID value with the value in WCHQClinicID. Wisconsin has their own clinic IDs they want to use.
Everybody else just uses CGPracticeSiteID (which are the same values as the associated SampleUnit_ids)

06/05/2013 dbg
split the population of #results into fields from Big_Table vs. fields from Survey_results
all surveys get the same fields from Big_Table, but Survey_Results are different depending on the type of survey.
type of survey is identified by looking for specific cores as the survey's Q1
the original CGCAHPS Q1 is Q039113
the Adult 12 month survey Q1 is Q046385
the Adult 12 month with PCMH Q1 is Q044121
the Child 12 month with PCMH Q1 is Q046265
Based on which type of survey is being exported, different sub-procedures are called to append the appropriate fields onto #results

01/20/2014 drm
INC0029376 Added values 101 through 113.

03/03/2014 drm
INC0031083 Removed check for number of steps.

03/04/2015 DRM
Added ProviderType
Took values 101 through 113 back out for cg_physspec

03/05/2014 DRM
Added 6 mo surveys

03/26/2015 DRM
Pull practicesiteid and groupid from CGCAHPSPracticeSite instead of big table

**/
---- testing code
--declare  @survey_id int,
-- @begindate varchar(10),
-- @enddate varchar(10),
-- @useWiscID bit

--set @survey_id = 13499
--set @begindate =  '1/1/12'
--set @enddate ='6/1/13'
--set @useWiscID = 0
-- end testing code
DECLARE @study VARCHAR(10)
DECLARE @survey VARCHAR(10)
DECLARE @SQL VARCHAR(max)

SELECT @survey = Cast(@survey_id AS VARCHAR)

SELECT @study = Cast(study_id AS VARCHAR)
FROM   qualisys.qp_prod.dbo.survey_def       WHERE  survey_id = @survey_id

IF NOT EXISTS(SELECT *
              FROM   information_schema.tables
              WHERE  table_name = 'big_table_view'
                     AND table_schema = 's' + @study)
  BEGIN
      PRINT 'Table s'+@study+'.big_table_view does not exist.  Exiting...'
      RETURN
  END

IF Isdate(@begindate) = 0
  BEGIN
      PRINT 'Please enter a valid begin date.  Exiting...'
      RETURN
  END

IF Isdate(@enddate) = 0
  BEGIN
      PRINT 'Please enter a valid end date.  Exiting...'
      RETURN
  END


/*
drop table #tmp_mncm_mailsteps 
drop table #mncm_units 
declare @survey_id int=16000, @study varchar(4), @begindate char(10)='1/1/2015', @enddate char(10)='12/31/2015', @survey char(5)
select @study=study_id, @survey=survey_id
from clientstudysurvey where survey_id=@survey_id
--*/

PRINT 'starting meth step check'
print 'getting mail step for returns'
--Get the mail step sequence (1 or 2) for the returns. Have to do it here so we only
--have mailing step data for the returns to avoid duplicate records
create table #tmp_mncm_mailsteps (survey_id int, samplepop_id int, mailstep int, intsequence int, bitMNCM bit, sampleunit_id int, datReturned datetime, ReceiptType_id int)
create table #mncm_units (sampleunit_id int, bitMNCM bit, survey_id int, surveytype_id int, subtype_id int)

INSERT INTO #tmp_mncm_mailsteps
select ms.survey_id, sp.samplepop_id, ms.mailingstep_id, ms.intsequence, su.bitMNCM, su.sampleunit_id, qf.datReturned, qf.ReceiptType_id
from qualisys.qp_prod.dbo.sampleunit su
INNER JOIN qualisys.qp_prod.dbo.selectedsample sel ON su.sampleunit_id = sel.sampleunit_id
inner join qualisys.qp_prod.dbo.samplepop sp on sel.sampleset_id=sp.sampleset_id and sel.pop_id=sp.pop_id
INNER JOIN qualisys.qp_prod.dbo.scheduledmailing scm ON sp.samplepop_id=scm.samplepop_id
INNER JOIN qualisys.qp_prod.dbo.questionform qf ON scm.sentmail_id=qf.sentmail_id
inner join qualisys.qp_prod.dbo.mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where sel.sampleEncounterDate BETWEEN @begindate and @enddate
and ms.survey_id = @survey_id -- 16384
and su.CAHPSType_id=4

insert into #mncm_units (sampleunit_id, bitMNCM, survey_id, surveytype_id, subtype_id)
select distinct  ms.sampleunit_id, ms.bitMNCM, ms.survey_id, 4, st.subtype_id
from #tmp_mncm_mailsteps ms
inner join qualisys.qp_prod.dbo.surveysubtype sst on ms.survey_id=sst.survey_id
inner join qualisys.qp_prod.dbo.subtype st on sst.subtype_id=st.subtype_id
where st.subtypecategory_id=2 -- 2=Questionnaire Type

-- now that we've used #tmp_mncm_mailsteps to populate #mncm_units, we can remove any mailsteps that weren't returned.
delete from #tmp_mncm_mailsteps where datReturned is null

-- DRM 03/03/2014   Remove check for number of steps as per INC0031083
-- Make sure the methodology contains only two steps
--IF EXISTS (SELECT * FROM #tmp_mncm_mailsteps where bitMNCM=1 and intsequence not in (1,2))
--  BEGIN
--      PRINT 'Problem with intsequence.  Exiting...'
--   select * from #tmp_mncm_mailsteps where bitMNCM=1
--      RETURN
--  END

if not exists (SELECT * FROM #mncm_units where bitMNCM=1)
  BEGIN
      PRINT 'There are no CGCAHPS assigned units.  Exiting...'
      RETURN
  END

/*
drop table #big_table 
drop table #Study_results  
declare @sql varchar(max), @begindate char(10)='01/01/2015', @enddate char(10)='12/31/2015', @study char(4), @survey char(5), @survey_id int=16000
select @study=study_id, @survey=survey_id
from clientstudysurvey where survey_id=@survey_id
--*/
declare @fieldlist varchar(max)='bt.TableName,'
CREATE TABLE #Big_Table (TableName varchar(16))
set @SQL = 'alter table #big_table add '

select @fieldlist = @fieldlist + 'bt.' + sc.name +','
, @sql = @sql + sc.name + ' ' + st.name + case when st.name in ('char','varchar','nvarchar') then '('+convert(varchar,sc.max_length)+')' else '' end + '
,'
from sys.schemas ss
inner join sys.views sv on ss.schema_id=sv.schema_id
inner join sys.columns sc on sv.object_id=sc.object_id
inner join sys.types st on sc.system_type_id=st.system_type_id
where ss.name = 's' + @study
and sv.name = 'big_table_view'
and sc.name <> 'tablename'

if charindex('bt.drid,',@fieldlist)=0
begin
	set @SQL = @SQL+'drid varchar(42),'
	set @fieldlist = @fieldlist + 'NULL as drid,'
end
if charindex('bt.drnpi,',@fieldlist)=0
begin
	set @SQL = @sql+'drnpi varchar(10),'
	set @fieldlist = @fieldlist + 'NULL as drnpi,'
end

set @sql = left(@sql,len(@sql)-1) 
set @fieldlist = left(@fieldlist,len(@fieldlist)-1)
exec (@SQL)

set @SQL = 'INSERT INTO #Big_Table ('+replace(replace(@fieldlist,'bt.',''),'NULL as ','')+')
SELECT '+@fieldlist+ '
FROM s'+@study+'.big_table_view bt
inner join #mncm_units mu on bt.sampleunit_id=mu.sampleunit_id
where bt.datSampleEncounterDate between '''+@begindate+''' and '''+@enddate+''''

exec (@SQL)

set @fieldlist='sr.TableName,'
CREATE TABLE #Study_Results (TableName varchar(20))
set @SQL = 'alter table #Study_Results add '

select @fieldlist = @fieldlist + 'sr.' + sc.name +','
, @sql = @sql + sc.name + ' ' + st.name + case when st.name in ('char','varchar','nvarchar') then '('+convert(varchar,sc.max_length)+')' else '' end + '
,'
from sys.schemas ss
inner join sys.views sv on ss.schema_id=sv.schema_id
inner join sys.columns sc on sv.object_id=sc.object_id
inner join sys.types st on sc.system_type_id=st.system_type_id
where ss.name = 's' + @study
and sv.name = 'study_results_view'
and sc.name <> 'tablename'

if charindex('sr.Q039161,',@fieldlist)=0
begin
	set @SQL = @SQL+'Q039161 int,'
	set @fieldlist = @fieldlist + 'NULL as Q039161,'
end
if charindex('sr.Q040716,',@fieldlist)=0
begin
	set @SQL = @sql+'Q040716 int,'
	set @fieldlist = @fieldlist + 'NULL as Q040716,'
end

set @sql = left(@sql,len(@sql)-1) 
set @fieldlist = left(@fieldlist,len(@fieldlist)-1)
exec (@SQL)

set @SQL = 'INSERT INTO #Study_Results ('+replace(replace(@fieldlist,'sr.',''),'NULL as ','')+')
SELECT '+@fieldlist+ '
FROM s'+@study+'.Study_Results_view sr
inner join #Big_Table bt on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id'
exec (@SQL)


create table #results (
 samplepop_id int,
 sampleunit_id int,
 SurveyType char(2), -- 33, 15, 16 or 18
 RecordID char(10), -- bt.samplepop_id
 PracticeSiteID char(10), -- cg_siteID
 GroupID char(10), -- cg_group_id
 DocID char(10), -- isnull(drnpi, isnull(drid, left(isnull(drlastname, ''),10)))
 DrFirst char(20), -- drfirstname
 DrLast char(20), -- drlastname
--DRM 03/04/2015 Added ProviderType
 ProviderType char(3), -- providertype if it exists, else cg_physspec if > 100
 DrSpecialty char(3), -- cg_physspec
 DOV char(8), -- datsampleencounterdate
 Disposition char(1), -- mncmdisposition
 CompletionMode char(1), -- ReceiptType_id
 CompletionDate char(8), -- datreturned
 CompletionRound char(2), -- tmm.intsequence
 SurveyLanguage char(1), -- bt.langid
 BirthYear char(4), -- year(dob)
 Gender char(1), -- sex
 Zip char(5) -- zip5
 )
 -- declare @sql varchar(max)
set @SQL = ''
select @sql = @SQL + field_nm + ', '
from (select 'samplepop_id' as field_nm
 union select 'sampleunit_id'
 --union select 'cg_siteid'
 --union select 'cg_groupid'
 union select 'drnpi'
 union select 'drid'
union select 'drlastname'
 union select 'drfirstname'
 union select 'cg_physspec'
 union select 'datsampleencounterdate'
 union select 'mncmdisposition'
 union select 'langid'
 union select 'dob'
 union select 'sex'
 union select 'zip5') list
left outer join ( select name as col_nm
     from tempdb.sys.columns
     where object_id = object_id('tempdb..#Big_Table')
    ) sv on field_nm=col_nm
where col_nm is null

if len(@SQL)>0
begin
 print 'ERROR: the study''s metadata doesn''t include these required fields: ' + @SQL
 drop table #Big_Table
 drop table #Study_Results
 RETURN
end

insert into #results (
 SamplePop_id, SampleUnit_id, SurveyType, RecordID, PracticeSiteID, GroupID, DocID, DrFirst, DrLast, DrSpecialty,
 DOV, Disposition, CompletionMode, CompletionDate, CompletionRound, SurveyLanguage, BirthYear, Gender, Zip
 )
SELECT DISTINCT 
	bt.samplepop_id, 
    bt.sampleunit_id, 
    0 AS SurveyType, 
    RIGHT(Space(3) + Cast(bt.samplepop_id AS VARCHAR), 10) AS RecordID, 
    --right(space(10) + isnull(cg_siteid,''), 10) as PracticeSiteID, 
    --right(space(10) + isnull(cg_groupid,''), 10) as GroupID, 
    '' AS PracticeSiteID, 
    '' AS GroupID,
    RIGHT(Space(10) + Isnull(CONVERT(VARCHAR, drnpi), Isnull(CONVERT(VARCHAR, drid), LEFT(Isnull(drlastname, ''), 10))), 10) AS DocID, 
    RIGHT(Space(20) + Isnull(drfirstname, ''), 20) AS DrFirst, 
    RIGHT(Space(20) + Isnull(drlastname, ''), 20) AS DrLast, 
    CASE WHEN Rtrim(Isnull(cg_physspec, '')) IN ('','0') THEN 'M  ' 
         WHEN (Isnumeric(cg_physspec) = 1 AND RIGHT('000' + cg_physspec, 3) BETWEEN '001' AND '037') THEN RIGHT('000' + cg_physspec, 3) 
		 ELSE 'M  ' END AS DrSpecialty, 
    CASE 
        WHEN datsampleencounterdate IS NULL THEN 'M       ' 
        ELSE Replace(CONVERT(VARCHAR(10), datsampleencounterdate, 101), '/', '') 
    END AS DOV, 
    RIGHT('  ' + Rtrim(Isnull(mncmdisposition, '9')), 1) AS Disposition, 
	CASE WHEN mncmdisposition IN ('1','2','3','4') then case tmm.ReceiptType_id 
	                                                          when 17 then '1' -- mail
															  when 12 then '2' -- phone
															  when 13 then '5' -- web 
													      end 
	     ElSE '7' -- not applicable 
	end as CompletionMode, 
    CASE 
        WHEN sr.datreturned IS NULL THEN 'M       '
		when mncmdisposition in ('1','2','3','4') then Replace(CONVERT(VARCHAR(10), sr.datreturned, 101), '/', '') 
		else 'M       '
    END AS CompletionDate, 
    CASE WHEN mncmdisposition in ('1','2') THEN RIGHT('0' + Cast(tmm.intsequence AS VARCHAR(1)), 2) ELSE 'NC' END AS CompletionRound, 
    CASE 
        WHEN (mncmdisposition IN ('1','2','3','4') AND bt.langid IN (2,8,18,19)) THEN '2' 
        WHEN (mncmdisposition IN ('1','2','3','4') AND bt.langid = 1) THEN '1' 
        ELSE '3' 
    END AS SurveyLanguage, 
	isnull(convert(varchar,year(dob)),'M') as BirthYear, 
    CASE sex WHEN 'M' THEN '1' WHEN 'F' THEN '2' ELSE 'M' END AS Gender, 
    CASE WHEN Isnumeric(zip5) <> 1 OR Len(zip5) < 5 THEN 'M' ELSE zip5 END AS Zip 
from #Big_Table bt
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 left outer join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id

--DRM 03/26/2015 Pull practicesiteid and groupid from CGCAHPSPracticeSite instead of big table
update r
set PracticeSiteID = right(space(10) + coalesce(ps.AssignedID,convert(varchar,ps.PracticeSite_ID),''), 10),
 GroupID = right(space(10) + coalesce(sg.AssignedID,convert(varchar,ps.SiteGroup_ID),''), 10)
from #results r 
inner join qualisys.qp_prod.dbo.sampleunit su on r.sampleunit_id = su.sampleunit_id
inner join qualisys.qp_prod.dbo.practicesite ps on su.SUFacility_id= ps.PracticeSite_ID 
inner join Qualisys.QP_Prod.dbo.SiteGroup sg on sg.SiteGroup_ID = ps.SiteGroup_ID


--DRM 03/04/2015 Added ProviderType
if exists (select name as col_nm
   from tempdb.sys.columns
   where object_id = object_id('tempdb..#Big_Table')
   and name = 'cg_ProvType')
begin
 -- cg_ProvType is fine if it’s between 101 and 116 or 998, otherwise it’s missing.
 update r
 set ProviderType =  case
        when rtrim(isnull(bt.cg_ProvType,'')) in ('', '0') then 'M  '
        when (isnumeric(bt.cg_ProvType) = 1 and right('000' + bt.cg_ProvType, 3) between '101' and '116') then right('000' + bt.cg_ProvType, 3)
		when (isnumeric(bt.cg_ProvType) = 1 and bt.cg_provType = '998') then '998'
        else 'M  '
      end
 from #results r 
 inner join #big_table bt 
	on bt.samplepop_id = r.samplepop_id and bt.sampleunit_id = r.sampleunit_id
end
else
	update #results set ProviderType = 'M  '


-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitMNCM = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey


-- call the appropriate sub procedure based on the type of survey we're dealing with.
-- each survey has a unique core for question 1.
-- the original procedure assumed Q039113 was Q1
-- Adult 12 month uses Q046385 as Q1
-- Adult 12 month with PCMH uses Q044121 as Q1
-- Child 12 month with PCMH uses Q046265 as Q1

-- find out which of these 4 cores have fields in #Study_Results
create table #surveyQ1 (ID int identity(1,1), field_nm varchar(15), bitFlag bit)
insert into #surveyQ1 (field_nm, bitFlag)
select name, 0
from tempdb.sys.columns sc
where object_id=object_id('tempdb..#Study_Results')
and name in ('Q044121','Q044127','Q050344','Q050541','Q050226','Q039113','Q046265','Q050483','Q050500','Q050629','Q046278')

-- remove any qstncore from #SurveyQ1 if no one was asked the question
-- declare @sql varchar(max)
declare @i int
select top 1 @i=ID, @SQL=field_nm from #SurveyQ1 where bitFlag=0
while @@rowcount>0
begin
	set @SQL = '
	if exists (select * from #Study_Results where '+@SQL+' is not null)
		update #SurveyQ1 set bitFlag=1 where ID='+convert(varchar,@i)+'
	else
		delete from #surveyQ1 where ID='+convert(varchar,@i)
	print @SQL
	exec (@SQL)
	select top 1 @i=ID, @SQL=field_nm from #SurveyQ1 where bitFlag=0
end


--DRM 03/05/2014 Added 6 mo surveys
-- q050344 6 Mo Adult
-- q050541 6 Mo Adult PCMH
-- q050483 6 Mo Child
-- q050629 6 Mo Child PCMH


-- checking for the mere existence of the field isn't sufficient, as a single study could contain more than one of these surveys
-- if the core we're looking for exists in the view, check to see if any of the records for the survey we're exporting has responses
-- if so, run the sub procedure associated with the survey type
if exists (select * from #surveyQ1 where field_nm='q039113')
 begin
  print 'AdultVisit2.0'
  exec dbo.GetCGCAHPSdata2_sub_AdultVisitA
  exec dbo.GetCGCAHPSdata2_sub_AdultVisitB @survey_id, @begindate, @enddate
  goto subdone
 end

if exists (select * from #surveyQ1 where field_nm='q044127')
 begin
  print 'Adult12Month2.0PCMH'
  exec dbo.GetCGCAHPSdata2_sub_Adult12MonthPCMHa
  exec dbo.GetCGCAHPSdata2_sub_Adult12MonthPCMHb @survey_id, @begindate, @enddate
  goto subdone
 end

if exists (select * from #surveyQ1 where field_nm='q044121')
 begin
  print 'Adult12Month2.0'
  exec dbo.GetCGCAHPSdata2_sub_Adult12MonthA
  exec dbo.GetCGCAHPSdata2_sub_Adult12MonthB @survey_id, @begindate, @enddate
  goto subdone
 end


if exists (select * from #surveyQ1 where field_nm='q046278')
 begin
  print 'Child12Month2.0PCMH'
  exec dbo.GetCGCAHPSdata2_sub_Child12MonthPCMHa
  exec dbo.GetCGCAHPSdata2_sub_Child12MonthPCMHb @survey_id, @begindate, @enddate
  goto subdone
 end

 -- TSB 03/08/2016 - added Child 12 Month 2.0
if exists (select * from #surveyQ1 where field_nm='q046265')
begin
  print 'Child12Month2.0'
  exec dbo.GetCGCAHPSdata2_sub_Child12MonthA
  exec dbo.GetCGCAHPSdata2_sub_Child12MonthB @survey_id, @begindate, @enddate
  goto subdone
end


-- DBG 03/07/2016 - added Adult 6 Month 3.0
if exists (select * from #surveyQ1 where field_nm='q050226')
begin
	print 'Adult6Month3.0'
	exec dbo.GetCGCAHPSdata2_sub_Adult6Month30a
	exec dbo.GetCGCAHPSdata2_sub_Adult6Month30b @survey_id, @begindate, @enddate
	goto subdone
end

--DRM 03/05/2014 Added 6 mo surveys
-- q050344 6 Mo Adult
if exists (select * from #surveyQ1 where field_nm='q050541')
begin
	print 'Adult6Month2.0PCMH'
	exec dbo.GetCGCAHPSdata2_sub_Adult6MonthPCMHa
	exec dbo.GetCGCAHPSdata2_sub_Adult6MonthPCMHb @survey_id, @begindate, @enddate
	goto subdone
end

if exists (select * from #surveyQ1 where field_nm='q050344')
begin
	print 'Adult6Month2.0'
	exec dbo.GetCGCAHPSdata2_sub_Adult6MonthA
	exec dbo.GetCGCAHPSdata2_sub_Adult6MonthB @survey_id, @begindate, @enddate
	goto subdone
end


--DRM 03/05/2014 Added 6 mo surveys
-- q050483 6 Mo Child
-- q050629 6 Mo Child PCMH
if exists (select * from #surveyQ1 where field_nm='q050629')
begin
	print 'Child6Month2.0PCMH'
	exec dbo.GetCGCAHPSdata2_sub_Child6MonthPCMHa
	exec dbo.GetCGCAHPSdata2_sub_Child6MonthPCMHb @survey_id, @begindate, @enddate
	goto subdone
end

if exists (select * from #surveyQ1 where field_nm='q050500')
begin
	print 'Child6Month2.0'
	exec dbo.GetCGCAHPSdata2_sub_Child6Montha
	exec dbo.GetCGCAHPSdata2_sub_Child6Monthb @survey_id, @begindate, @enddate
	goto subdone
end

-- DBG 03/07/2016 - added Child 6 Month 3.0
if exists (select * from #surveyQ1 where field_nm='q050483')
begin
	print 'Child6Month3.0'
	exec dbo.GetCGCAHPSdata2_sub_Child6Month30a
	exec dbo.GetCGCAHPSdata2_sub_Child6Month30b @survey_id, @begindate, @enddate
	goto subdone
end




PRINT 'ERROR! none of the sub-procedures were executed, indicating the specific survey type (Adult/Child, with/without PCMH) couldn''t be determined, or there are no returns for the specified time period.'
drop table #Big_Table
drop table #Study_Results
RETURN

subdone:

set @FieldList = ''
select @FieldList=@FieldList + name + '+'
from tempdb.sys.columns
where object_id = object_id('tempdb..#results')
and name not in ('sampleunit_id','samplepop_id')
order by column_id;

set @FieldList=left(@FieldList,len(@FieldList)-1)

set @SQL = 'if exists (	select *
			from (select *,' + @fieldlist + ' as SubmissionRow
			from #results) x
			where SubmissionRow is null)
begin
	select ' + replace(@fieldlist,'+',',') + '
	from (select *,' + @fieldlist + ' as SubmissionRow
	from #results) x
	where SubmissionRow is null

	 RAISERROR (''Some submission fields have NULL values.'', -- Message text.
               16, -- Severity.
               1 -- State.
               ); 
end'
exec (@SQL)

if @@error=0
begin
	if @ReturnGrid=1
		select * from #results
	else
	begin
		set @sql='select ' + @fieldlist + ' from #results'
		exec (@SQL)
	end
end
/*
select * from #results
select * from #tmp_mncm_mailsteps
select * from #tmp_mncm_mailsteps where samplepop_id = 107851568
select bt.samplepop_id, tmm.*
from #Big_Table bt
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 left outer join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
*/
drop table #surveyQ1
drop table #results
drop table #tmp_mncm_mailsteps
drop table #Big_Table
drop table #Study_Results
drop table #mncm_units
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult12MonthA')
	drop procedure GetCGCAHPSdata2_sub_Adult12MonthA
go
create procedure dbo.GetCGCAHPSdata2_sub_Adult12MonthA
as
alter table #results add
	Q1   char(1),	-- Q044121 (was Q046385)
	Q2   char(1),	-- Q044122 (was Q044423)
	Q3   char(1),	-- Q044123 (was Q044424)
	Q4   char(1),	-- Q044124 (was Q044425)
	Q5   char(1),	-- Q044125 (was Q044426)
	Q6   char(1),	-- Q044126 (was Q044427)
	Q7   char(1),	-- Q044129 (was Q044428)
	Q8   char(1),	-- Q044130 (was Q044429)
	Q9   char(1),	-- Q044139 (was Q044430)
	Q10  char(1),	-- Q044140 (was Q044431)
	Q11  char(1),	-- Q044141 (was Q044432)
	Q12  char(1),	-- Q044142 (was Q044433)
	Q13  char(1),	-- Q044148 (was Q044434)
	Q14  char(1),	-- Q044150 (was Q044435)
	Q15  char(1),	-- Q044152 (was Q044436)
	Q16  char(1),	-- Q044155 (was Q044437)
	Q17  char(1),	-- Q044157 (was Q044438)
	Q18  char(1),	-- Q044158 (was Q044439)
	Q19  char(1),	-- Q044161 (was Q044440)
	Q20  char(1),	-- Q044162 (was Q044441)
	Q21  char(1),	-- Q044168 (was Q044442)
	Q22  char(1),	-- Q044169 (was Q044443)
	Q23  char(2),	-- Q044181 (was Q044444)
	Q24  char(1),	-- Q044201 (was Q044445)
	Q25  char(1),	-- Q044202 (was Q044446)
	Q26  char(1),	-- Q044203 (was Q044447)
	Q27  char(1),	-- Q044204 (was Q046689)
	Q28  char(1),	-- Q044226 (was Q044452)
	Q29  char(1),	-- Q044227 (was Q044453)
	Q30  char(1),	-- Q044228 (was Q044454)
	Q31  char(1),	-- Q044229 (was Q044455)
	Q32a char(1),	-- Q044230a (was Q044456a)
	Q32b char(1),	-- Q044230b (was Q044456b)
	Q32c char(1),	-- Q044230c (was Q044456c)
	Q32d char(1),	-- Q044230d (was Q044456d)
	Q32e char(1),	-- Q044230e (was Q044456e)
	Q32f char(1),	-- Q044230f (was Q044456f)
	Q33  char(1),	-- Q044234 (was Q044457)
	Q34a char(1),	-- Q044235a (was Q044458a)
	Q34b char(1),	-- Q044235b (was Q044458b)
	Q34c char(1),	-- Q044235c (was Q044458c)
	Q34d char(1),	-- Q044235d (was Q044458d)
	Q34e char(1) 	-- Q044235e (was Q044458e)
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult12MonthB')
	drop procedure GetCGCAHPSdata2_sub_Adult12MonthB
go
--DRM 06/18/2013 Added check for empty results.  This was causing a problem for empty returns.
--DRM 01/20/2014 Added left pad on Q23.
--DRM 03/06/2014 Added phone and web surveys to check at end of proc.
create procedure dbo.GetCGCAHPSdata2_sub_Adult12MonthB
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as

update #results set surveytype=15

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q044121,-9) when -9 then 'M' when -8 then 'H' else cast(Q044121%10000 as varchar) end,
 Q2   = case isnull(Q044122,-9) when -9 then 'M' when -8 then 'H' else cast(Q044122%10000 as varchar) end,
 Q3   = case isnull(Q044123,-9) when -9 then 'M' when -8 then 'H' else cast(Q044123%10000 as varchar) end,
 Q4   = case isnull(Q044124,-9) when -9 then 'M' when -8 then 'H' else cast(Q044124%10000 as varchar) end,
 Q5   = case isnull(Q044125,-9) when -9 then 'M' when -8 then 'H' else cast(Q044125%10000 as varchar) end,
 Q6   = case isnull(Q044126,-9) when -9 then 'M' when -8 then 'H' else cast(Q044126%10000 as varchar) end,
 Q7   = case isnull(Q044129,-9) when -9 then 'M' when -8 then 'H' else cast(Q044129%10000 as varchar) end,
 Q8   = case isnull(Q044130,-9) when -9 then 'M' when -8 then 'H' else cast(Q044130%10000 as varchar) end,
 Q9   = case isnull(Q044139,-9) when -9 then 'M' when -8 then 'H' else cast(Q044139%10000 as varchar) end,
 Q10  = case isnull(Q044140,-9) when -9 then 'M' when -8 then 'H' else cast(Q044140%10000 as varchar) end,
 Q11  = case isnull(Q044141,-9) when -9 then 'M' when -8 then 'H' else cast(Q044141%10000 as varchar) end,
 Q12  = case isnull(Q044142,-9) when -9 then 'M' when -8 then 'H' else cast(Q044142%10000 as varchar) end,
 Q13  = case isnull(Q044148,-9) when -9 then 'M' when -8 then 'H' else cast(Q044148%10000 as varchar) end,
 Q14  = case isnull(Q044150,-9) when -9 then 'M' when -8 then 'H' else cast(Q044150%10000 as varchar) end,
 Q15  = case isnull(Q044152,-9) when -9 then 'M' when -8 then 'H' else cast(Q044152%10000 as varchar) end,
 Q16  = case isnull(Q044155,-9) when -9 then 'M' when -8 then 'H' else cast(Q044155%10000 as varchar) end,
 Q17  = case isnull(Q044157,-9) when -9 then 'M' when -8 then 'H' else cast(Q044157%10000 as varchar) end,
 Q18  = case isnull(Q044158,-9) when -9 then 'M' when -8 then 'H' else cast(Q044158%10000 as varchar) end,
 Q19  = case isnull(Q044161,-9) when -9 then 'M' when -8 then 'H' else cast(Q044161%10000 as varchar) end,
 Q20  = case isnull(Q044162,-9) when -9 then 'M' when -8 then 'H' else cast(Q044162%10000 as varchar) end,
 Q21  = case isnull(Q044168,-9) when -9 then 'M' when -8 then 'H' else cast(Q044168%10000 as varchar) end,
 Q22  = case isnull(Q044169,-9) when -9 then 'M' when -8 then 'H' else cast(Q044169%10000 as varchar) end,
 Q23  = case isnull(Q044181,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q044181%10000 as varchar),2) end,
 Q24  = case isnull(Q044201,-9) when -9 then 'M' when -8 then 'H' else cast(Q044201%10000 as varchar) end,
 Q25  = case isnull(Q044202,-9) when -9 then 'M' when -8 then 'H' else cast(Q044202%10000 as varchar) end,
 Q26  = case isnull(Q044203,-9) when -9 then 'M' when -8 then 'H' else cast(Q044203%10000 as varchar) end,
 Q27  = case isnull(Q044204,-9) when -9 then 'M' when -8 then 'H' else cast(Q044204%10000 as varchar) end,
 Q28  = case isnull(Q044226,-9) when -9 then 'M' when -8 then 'H' else cast(Q044226%10000 as varchar) end,
 Q29  = case isnull(Q044227,-9) when -9 then 'M' when -8 then 'H' else cast(Q044227%10000 as varchar) end,
 Q30  = case isnull(Q044228,-9) when -9 then 'M' when -8 then 'H' else cast(Q044228%10000 as varchar) end,
 Q31  = case isnull(Q044229,-9) when -9 then 'M' when -8 then 'H' else cast(Q044229%10000 as varchar) end,
 Q32a = case isnull(Q044230a,-9) when -9 then 0 else 1 end,
 Q32b = case isnull(Q044230b,-9) when -9 then 0 else 1 end,
 Q32c = case isnull(Q044230c,-9) when -9 then 0 else 1 end,
 Q32d = case isnull(Q044230d,-9) when -9 then 0 else 1 end,
 Q32e = case isnull(Q044230e,-9) when -9 then 0 else 1 end,
 Q32f = case isnull(Q044230f,-9) when -9 then 0 else 1 end,
 Q33  = case isnull(Q044234 ,-9) when -9 then 'M' when -8 then 'H' else cast(Q044234%10000 as varchar) end,
 Q34a = case isnull(Q044235a,-9) when -9 then 0 else 1 end,
 Q34b = case isnull(Q044235b,-9) when -9 then 0 else 1 end,
 Q34c = case isnull(Q044235c,-9) when -9 then 0 else 1 end,
 Q34d = case isnull(Q044235d,-9) when -9 then 0 else 1 end,
 Q34e = case isnull(Q044235e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- Adult 12-month:
-- Q1 = core 46385
-- If Q1 = 2 (“No”) Questions 2-25 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-25 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2  = 'S'  where Q2  = 'M'  and (Q1='2')
 update #results set Q3  = 'S'  where Q3  = 'M'  and (Q1='2')
 update #results set Q4  = 'S'  where Q4  = 'M'  and (Q1='2')
 update #results set Q5  = 'S'  where Q5  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6  = 'S'  where Q6  = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q7  = 'S'  where Q7  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q8  = 'S'  where Q8  = 'M'  and (Q1='2' or Q4='1' or Q7='2')
 update #results set Q9  = 'S'  where Q9  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q10 = 'S'  where Q10 = 'M'  and (Q1='2' or Q4='1' or Q9='2')
 update #results set Q11 = 'S'  where Q11 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q12 = 'S'  where Q12 = 'M'  and (Q1='2' or Q4='1' or Q11='2')
 update #results set Q13 = 'S'  where Q13 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q14 = 'S'  where Q14 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q15 = 'S'  where Q15 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16 = 'S'  where Q16 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q17 = 'S'  where Q17 = 'M'  and (Q1='2' or Q4='1' or Q16='2')
 update #results set Q18 = 'S'  where Q18 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19 = 'S'  where Q19 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q20 = 'S'  where Q20 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21 = 'S'  where Q21 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q22 = 'S'  where Q22 = 'M'  and (Q1='2' or Q4='1' or Q21='2')
 update #results set Q23 = 'S ' where Q23 = 'M ' and (Q1='2' or Q4='1')
 update #results set Q24 = 'S'  where Q24 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25 = 'S'  where Q25 = 'M'  and (Q1='2' or Q4='1')

-- If Q33 = 2 (“No”) Skip to end of the survey
-- Questions 34a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q33).
 -- If they answered Q33 “No”, invoking the skip, then mark the question appropriately skipped.
    update #results set Q34a='S',Q34b='S',Q34c='S',Q34d='S',Q34e='S' where Q33  = '2' and Q34a+Q34b+Q34c+Q34d+Q34e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 ='  ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32a=' ',
 Q32b=' ',
 Q32c=' ',
 Q32d=' ',
 Q32e=' ',
 Q32f=' ',
 Q33 =' ',
 Q34a=' ',
 Q34b=' ',
 Q34c=' ',
 Q34d=' ',
 Q34e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult12MonthPCMHa')
	drop procedure GetCGCAHPSdata2_sub_Adult12MonthPCMHa
go
create procedure dbo.GetCGCAHPSdata2_sub_Adult12MonthPCMHa
as
alter table #results add
	Q1   char(1), -- Q044121
	Q2   char(1), -- Q044122
	Q3   char(1), -- Q044123
	Q4   char(1), -- Q044124
	Q5   char(1), -- Q044125
	Q6   char(1), -- Q044126
	Q7   char(1), -- Q044127
	Q8   char(1), -- Q044129
	Q9   char(1), -- Q044130
	Q10  char(1), -- Q044134
	Q11  char(1), -- Q044135
	Q12  char(1), -- Q044136
	Q13  char(1), -- Q044139
	Q14  char(1), -- Q044140
	Q15  char(1), -- Q044141
	Q16  char(1), -- Q044142
	Q17  char(1), -- Q044147
	Q18  char(1), -- Q044148
	Q19  char(1), -- Q044150
	Q20  char(1), -- Q044152
	Q21  char(1), -- Q044155
	Q22  char(1), -- Q044157
	Q23  char(1), -- Q044158
	Q24  char(1), -- Q044161
	Q25  char(1), -- Q044162
	Q26  char(1), -- Q044168
	Q27  char(1), -- Q044169
	Q28  char(1), -- Q044171
	Q29  char(1), -- Q044172
	Q30  char(1), -- Q044173
	Q31  char(1), -- Q044174
	Q32  char(2), -- Q044181
	Q33  char(1), -- Q044164
	Q34  char(1), -- Q044165
	Q35  char(1), -- Q044190
	Q36  char(1), -- Q044191
	Q37  char(1), -- Q044175
	Q38  char(1), -- Q044176
	Q39  char(1), -- Q044188
	Q40  char(1), -- Q044187
	Q41  char(1), -- Q044166
	Q42  char(1), -- Q044201
	Q43  char(1), -- Q044202
	Q44  char(1), -- Q044203
	Q45  char(1), -- Q044204
	Q46  char(1), -- Q044226
	Q47  char(1), -- Q044227
	Q48  char(1), -- Q044228
	Q49  char(1), -- Q044229
	Q50a char(1), -- Q044230a
	Q50b char(1), -- Q044230b
	Q50c char(1), -- Q044230c
	Q50d char(1), -- Q044230d
	Q50e char(1), -- Q044230e
	Q50f char(1), -- Q044230f
	Q51  char(1), -- Q048664 / 44234  <-- some surveys use 48664 and 48665. Others use 44234 and 44235
	Q52a char(1), -- Q048665a / 44235a
	Q52b char(1), -- Q048665b / 44235b
	Q52c char(1), -- Q048665c / 44235c
	Q52d char(1), -- Q048665d / 44235d
	Q52e char(1)  -- Q048665e / 44235e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult12MonthPCMHb')
	drop procedure GetCGCAHPSdata2_sub_Adult12MonthPCMHb
go
--DRM 06/18/2013 Added check for empty results.  This was causing a problem for empty returns.
--DRM 01/20/2014 Added left pad on Q32.
--DRM 03/06/2014 Added phone and web surveys to check at end of proc.
create procedure [dbo].[GetCGCAHPSdata2_sub_Adult12MonthPCMHb]
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
begin
update #results set surveytype=16

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(q044121,-9) when -9 then 'M' when -8 then 'H' else cast(Q044121%10000 as varchar) end,
 Q2   = case isnull(q044122,-9) when -9 then 'M' when -8 then 'H' else cast(Q044122%10000 as varchar) end,
 Q3   = case isnull(q044123,-9) when -9 then 'M' when -8 then 'H' else cast(Q044123%10000 as varchar) end,
 Q4   = case isnull(q044124,-9) when -9 then 'M' when -8 then 'H' else cast(Q044124%10000 as varchar) end,
 Q5   = case isnull(q044125,-9) when -9 then 'M' when -8 then 'H' else cast(Q044125%10000 as varchar) end,
 Q6   = case isnull(q044126,-9) when -9 then 'M' when -8 then 'H' else cast(Q044126%10000 as varchar) end,
 Q7   = case isnull(q044127,-9) when -9 then 'M' when -8 then 'H' else cast(Q044127%10000 as varchar) end,
 Q8   = case isnull(q044129,-9) when -9 then 'M' when -8 then 'H' else cast(Q044129%10000 as varchar) end,
 Q9   = case isnull(q044130,-9) when -9 then 'M' when -8 then 'H' else cast(Q044130%10000 as varchar) end,
 Q10  = case isnull(q044134,-9) when -9 then 'M' when -8 then 'H' else cast(Q044134%10000 as varchar) end,
 Q11  = case isnull(q044135,-9) when -9 then 'M' when -8 then 'H' else cast(Q044135%10000 as varchar) end,
 Q12  = case isnull(q044136,-9) when -9 then 'M' when -8 then 'H' else cast(Q044136%10000 as varchar) end,
 Q13  = case isnull(q044139,-9) when -9 then 'M' when -8 then 'H' else cast(Q044139%10000 as varchar) end,
 Q14  = case isnull(q044140,-9) when -9 then 'M' when -8 then 'H' else cast(Q044140%10000 as varchar) end,
 Q15  = case isnull(q044141,-9) when -9 then 'M' when -8 then 'H' else cast(Q044141%10000 as varchar) end,
 Q16  = case isnull(q044142,-9) when -9 then 'M' when -8 then 'H' else cast(Q044142%10000 as varchar) end,
 Q17  = case isnull(q044147,-9) when -9 then 'M' when -8 then 'H' else cast(Q044147%10000 as varchar) end,
 Q18  = case isnull(q044148,-9) when -9 then 'M' when -8 then 'H' else cast(Q044148%10000 as varchar) end,
 Q19  = case isnull(q044150,-9) when -9 then 'M' when -8 then 'H' else cast(Q044150%10000 as varchar) end,
 Q20  = case isnull(q044152,-9) when -9 then 'M' when -8 then 'H' else cast(Q044152%10000 as varchar) end,
 Q21  = case isnull(q044155,-9) when -9 then 'M' when -8 then 'H' else cast(Q044155%10000 as varchar) end,
 Q22  = case isnull(q044157,-9) when -9 then 'M' when -8 then 'H' else cast(Q044157%10000 as varchar) end,
 Q23  = case isnull(q044158,-9) when -9 then 'M' when -8 then 'H' else cast(Q044158%10000 as varchar) end,
 Q24  = case isnull(q044161,-9) when -9 then 'M' when -8 then 'H' else cast(Q044161%10000 as varchar) end,
 Q25  = case isnull(q044162,-9) when -9 then 'M' when -8 then 'H' else cast(Q044162%10000 as varchar) end,
 Q26  = case isnull(q044168,-9) when -9 then 'M' when -8 then 'H' else cast(Q044168%10000 as varchar) end,
 Q27  = case isnull(q044169,-9) when -9 then 'M' when -8 then 'H' else cast(Q044169%10000 as varchar) end,
 Q28  = case isnull(q044171,-9) when -9 then 'M' when -8 then 'H' else cast(Q044171%10000 as varchar) end,
 Q29  = case isnull(q044172,-9) when -9 then 'M' when -8 then 'H' else cast(Q044172%10000 as varchar) end,
 Q30  = case isnull(q044173,-9) when -9 then 'M' when -8 then 'H' else cast(Q044173%10000 as varchar) end,
 Q31  = case isnull(q044174,-9) when -9 then 'M' when -8 then 'H' else cast(Q044174%10000 as varchar) end,
--DRM 01/20/2014 Added left pad on Q32.
 Q32  = case isnull(q044181,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(q044181%10000 as varchar),2) end,
-- Q32  = case isnull(q044181,-9) when -9 then 'M ' when -8 then 'H ' else Q044181%10000 end,
 Q33  = case isnull(q044164,-9) when -9 then 'M' when -8 then 'H' else cast(Q044164%10000 as varchar) end,
 Q34  = case isnull(q044165,-9) when -9 then 'M' when -8 then 'H' else cast(Q044165%10000 as varchar) end,
 Q35  = case isnull(q044190,-9) when -9 then 'M' when -8 then 'H' else cast(Q044190%10000 as varchar) end,
 Q36  = case isnull(q044191,-9) when -9 then 'M' when -8 then 'H' else cast(Q044191%10000 as varchar) end,
 Q37  = case isnull(q044175,-9) when -9 then 'M' when -8 then 'H' else cast(Q044175%10000 as varchar) end,
 Q38  = case isnull(q044176,-9) when -9 then 'M' when -8 then 'H' else cast(Q044176%10000 as varchar) end,
 Q39  = case isnull(q044188,-9) when -9 then 'M' when -8 then 'H' else cast(Q044188%10000 as varchar) end,
 Q40  = case isnull(q044187,-9) when -9 then 'M' when -8 then 'H' else cast(Q044187%10000 as varchar) end,
 Q41  = case isnull(q044166,-9) when -9 then 'M' when -8 then 'H' else cast(Q044166%10000 as varchar) end,
 Q42  = case isnull(q044201,-9) when -9 then 'M' when -8 then 'H' else cast(Q044201%10000 as varchar) end,
 Q43  = case isnull(q044202,-9) when -9 then 'M' when -8 then 'H' else cast(Q044202%10000 as varchar) end,
 Q44  = case isnull(q044203,-9) when -9 then 'M' when -8 then 'H' else cast(Q044203%10000 as varchar) end,
 Q45  = case isnull(q044204,-9) when -9 then 'M' when -8 then 'H' else cast(Q044204%10000 as varchar) end,
 Q46  = case isnull(q044226,-9) when -9 then 'M' when -8 then 'H' else cast(Q044226%10000 as varchar) end,
 Q47  = case isnull(q044227,-9) when -9 then 'M' when -8 then 'H' else cast(Q044227%10000 as varchar) end,
 Q48  = case isnull(q044228,-9) when -9 then 'M' when -8 then 'H' else cast(Q044228%10000 as varchar) end,
 Q49  = case isnull(q044229,-9) when -9 then 'M' when -8 then 'H' else cast(Q044229%10000 as varchar) end,
 Q50a = case isnull(q044230a,-9) when -9 then 0 else 1 end,
 Q50b = case isnull(q044230b,-9) when -9 then 0 else 1 end,
 Q50c = case isnull(q044230c,-9) when -9 then 0 else 1 end,
 Q50d = case isnull(q044230d,-9) when -9 then 0 else 1 end,
 Q50e = case isnull(q044230e,-9) when -9 then 0 else 1 end,
 Q50f = case isnull(q044230f,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 44234 and 44235 for Q51 and Q52.
-- others use cores 48664 and 48665.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @sql nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (44234,44235))
 set @SQL =
 N'update r set
  Q51  = case isnull(q044234,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q044234%10000 as varchar) end,
  Q52a = case isnull(q044235a,-9) when -9 then 0 else 1 end,
  Q52b = case isnull(q044235b,-9) when -9 then 0 else 1 end,
  Q52c = case isnull(q044235c,-9) when -9 then 0 else 1 end,
  Q52d = case isnull(q044235d,-9) when -9 then 0 else 1 end,
  Q52e = case isnull(q044235e,-9) when -9 then 0 else 1 end'
else
 set @SQL =
 N'update r set
  Q51  = case isnull(q048664,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048664%10000 as varchar) end,
  Q52a = case isnull(q048665a,-9) when -9 then 0 else 1 end,
  Q52b = case isnull(q048665b,-9) when -9 then 0 else 1 end,
  Q52c = case isnull(q048665c,-9) when -9 then 0 else 1 end,
  Q52d = case isnull(q048665d,-9) when -9 then 0 else 1 end,
  Q52e = case isnull(q048665e,-9) when -9 then 0 else 1 end'

set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Adult 12-month w/ PCMH:
-- Q1 = core 44121
-- If Q1 = 2 (“No”) Questions 2-43 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-43 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
 update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
 update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
 update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q8='2')
 update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1' or Q11='2')
 update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1' or Q13='2')
 update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1' or Q15='2')
 update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1' or Q21='2')
 update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q24  = 'S'  where Q24  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25  = 'S'  where Q25  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1' or Q26='2')
 update #results set Q28  = 'S'  where Q28  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q29  = 'S'  where Q29  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q30  = 'S'  where Q30  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q31  = 'S'  where Q31  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q32  = 'S ' where Q32  = 'M ' and (Q1='2' or Q4='1')
 update #results set Q33  = 'S'  where Q33  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q34  = 'S'  where Q34  = 'M'  and (Q1='2' or Q4='1' or Q33='2')
 update #results set Q35  = 'S'  where Q35  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q36  = 'S'  where Q36  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q37  = 'S'  where Q37  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q38  = 'S'  where Q38  = 'M'  and (Q1='2' or Q4='1' or Q37='2')
 update #results set Q39  = 'S'  where Q39  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q40  = 'S'  where Q40  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q41  = 'S'  where Q41  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q42  = 'S'  where Q42  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q43  = 'S'  where Q43  = 'M'  and (Q1='2' or Q4='1')


-- If Q51 = 2 (“No”) Skip to end of the survey
-- Questions 52a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q51).
 -- If they answered Q51 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q52a='S',Q52b='S',Q52c='S',Q52d='S',Q52e='S' where Q51 = '2' and Q52a+Q52b+Q52c+Q52d+Q52e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 ='  ',
 Q33 =' ',
 Q34 =' ',
 Q35 =' ',
 Q36 =' ',
 Q37 =' ',
 Q38 =' ',
 Q39 =' ',
 Q40 =' ',
 Q41 =' ',
 Q42 =' ',
 Q43 =' ',
 Q44 =' ',
 Q45 =' ',
 Q46 =' ',
 Q47 =' ',
 Q48 =' ',
 Q49 =' ',
 Q50a=' ',
 Q50b=' ',
 Q50c=' ',
 Q50d=' ',
 Q50e=' ',
 Q50f=' ',
 Q51 =' ',
 Q52a=' ',
 Q52b=' ',
 Q52c=' ',
 Q52d=' ',
 Q52e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
end
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6MonthA')
	drop procedure GetCGCAHPSdata2_sub_Adult6MonthA
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Adult6MonthA
as
alter table #results add
 Q1   char(1), -- Q050344
 Q2   char(1), -- Q050176
 Q3   char(1), -- Q050177
 Q4   char(1), -- Q050178
 Q5   char(1), -- Q050179
 Q6   char(1), -- Q050180
 Q7   char(1), -- Q050181
 Q8   char(1), -- Q050182
 Q9   char(1), -- Q050183
 Q10  char(1), -- Q050184
 Q11  char(1), -- Q050185
 Q12  char(1), -- Q050186
 Q13  char(1), -- Q050189
 Q14  char(1), -- Q050190
 Q15  char(1), -- Q050191
 Q16  char(1), -- Q050192
 Q17  char(1), -- Q050193
 Q18  char(1), -- Q050194
 Q19  char(1), -- Q050196
 Q20  char(1), -- Q050197
 Q21  char(1), -- Q050198
 Q22  char(1), -- Q050199
 Q23  char(2), -- Q050215
 Q24  char(1), -- Q050216
 Q25  char(1), -- Q050217
 Q26  char(1), -- Q050234
 Q27  char(1), -- Q050235
 Q28  char(1), -- Q050241
 Q29  char(1), -- Q050699
 Q30  char(1), -- Q050243
 Q31  char(1), -- Q050253
 Q32a char(1), -- Q050255a
 Q32b char(1), -- Q050255b
 Q32c char(1), -- Q050255d - Q050255j
 Q32d char(1), -- Q050255k - Q050255n
 Q32e char(1), -- Q050255c
 Q32f char(1), -- Always '0'
 Q33  char(1), -- Q050256
 Q34a char(1), -- Q050257a
 Q34b char(1), -- Q050257b
 Q34c char(1), -- Q050257c
 Q34d char(1), -- Q050257d
 Q34e char(1)  -- Q050257e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6MonthB')
	drop procedure GetCGCAHPSdata2_sub_Adult6MonthB
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Adult6MonthB
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as

update #results set surveytype=15

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q050344,-9) when -9 then 'M' when -8 then 'H' else cast(Q050344%10000 as varchar) end,
 Q2   = case isnull(Q050176,-9) when -9 then 'M' when -8 then 'H' else cast(Q050176%10000 as varchar) end,
 Q3   = case isnull(Q050177,-9) when -9 then 'M' when -8 then 'H' else cast(Q050177%10000 as varchar) end,
 Q4   = case isnull(Q050178,-9) when -9 then 'M' when -8 then 'H' else cast(Q050178%10000 as varchar) end,
 Q5   = case isnull(Q050179,-9) when -9 then 'M' when -8 then 'H' else cast(Q050179%10000 as varchar) end,
 Q6   = case isnull(Q050180,-9) when -9 then 'M' when -8 then 'H' else cast(Q050180%10000 as varchar) end,
 Q7   = case isnull(Q050181,-9) when -9 then 'M' when -8 then 'H' else cast(Q050181%10000 as varchar) end,
 Q8   = case isnull(Q050182,-9) when -9 then 'M' when -8 then 'H' else cast(Q050182%10000 as varchar) end,
 Q9   = case isnull(Q050183,-9) when -9 then 'M' when -8 then 'H' else cast(Q050183%10000 as varchar) end,
 Q10  = case isnull(Q050184,-9) when -9 then 'M' when -8 then 'H' else cast(Q050184%10000 as varchar) end,
 Q11  = case isnull(Q050185,-9) when -9 then 'M' when -8 then 'H' else cast(Q050185%10000 as varchar) end,
 Q12  = case isnull(Q050186,-9) when -9 then 'M' when -8 then 'H' else cast(Q050186%10000 as varchar) end,
 Q13  = case isnull(Q050189,-9) when -9 then 'M' when -8 then 'H' else cast(Q050189%10000 as varchar) end,
 Q14  = case isnull(Q050190,-9) when -9 then 'M' when -8 then 'H' else cast(Q050190%10000 as varchar) end,
 Q15  = case isnull(Q050191,-9) when -9 then 'M' when -8 then 'H' else cast(Q050191%10000 as varchar) end,
 Q16  = case isnull(Q050192,-9) when -9 then 'M' when -8 then 'H' else cast(Q050192%10000 as varchar) end,
 Q17  = case isnull(Q050193,-9) when -9 then 'M' when -8 then 'H' else cast(Q050193%10000 as varchar) end,
 Q18  = case isnull(Q050194,-9) when -9 then 'M' when -8 then 'H' else cast(Q050194%10000 as varchar) end,
 Q19  = case isnull(Q050196,-9) when -9 then 'M' when -8 then 'H' else cast(Q050196%10000 as varchar) end,
 Q20  = case isnull(Q050197,-9) when -9 then 'M' when -8 then 'H' else cast(Q050197%10000 as varchar) end,
 Q21  = case isnull(Q050198,-9) when -9 then 'M' when -8 then 'H' else cast(Q050198%10000 as varchar) end,
 Q22  = case isnull(Q050199,-9) when -9 then 'M' when -8 then 'H' else cast(Q050199%10000 as varchar) end,
 Q23  = case isnull(Q050215,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050215%10000 as varchar),2) end,
 Q24  = case isnull(Q050216,-9) when -9 then 'M' when -8 then 'H' else cast(Q050216%10000 as varchar) end,
 Q25  = case isnull(Q050217,-9) when -9 then 'M' when -8 then 'H' else cast(Q050217%10000 as varchar) end,
 Q26  = case isnull(Q050234,-9) when -9 then 'M' when -8 then 'H' else cast(Q050234%10000 as varchar) end,
 Q27  = case isnull(Q050235,-9) when -9 then 'M' when -8 then 'H' else cast(Q050235%10000 as varchar) end,
 Q28  = case isnull(Q050241,-9) when -9 then 'M' when -8 then 'H' when 8 then 'S' when 9 then 'S' when 10 then 'S' else cast(Q050241%10000 as varchar) end,
 Q29  = case isnull(Q050699,-9) when -9 then 'M' when -8 then 'H' else cast(Q050699%10000 as varchar) end,
 Q30  = case isnull(Q050243,-9) when -9 then 'M' when -8 then 'H' else cast(Q050243%10000 as varchar) end,
 Q31  = case isnull(Q050253,-9) when -9 then 'M' when -8 then 'H' else cast(Q050253%10000 as varchar) end,
 Q32a = case isnull(q050255a,-9) when -9 then 0 else 1 end,
 Q32b = case isnull(q050255b,-9) when -9 then 0 else 1 end,
 Q32c = case when (q050255d=1 or q050255e=1 or q050255f=1 or q050255g=1 or q050255h=1 or q050255i=1 or q050255j=1) then 1 else 0 end,
 Q32d = case when (q050255k=1 or q050255l=1 or q050255m=1 or q050255n=1) then 1 else 0 end,
 Q32e = case isnull(q050255c,-9) when -9 then 0 else 1 end,
 Q32f = 0,
 Q33  = case isnull(q050256,-9) when -9 then 'M' when -8 then 'H' else cast(Q050256%10000 as varchar) end,
 Q34a = case isnull(q050257a,-9) when -9 then 0 else 1 end,
 Q34b = case isnull(q050257b,-9) when -9 then 0 else 1 end,
 Q34c = case isnull(q050257c,-9) when -9 then 0 else 1 end,
 Q34d = case isnull(q050257d,-9) when -9 then 0 else 1 end,
 Q34e = case isnull(q050257e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- Adult 12-month:
-- Q1 = core 46385
-- If Q1 = 2 (“No”) Questions 2-25 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-25 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2  = 'S'  where Q2  = 'M'  and (Q1='2')
 update #results set Q3  = 'S'  where Q3  = 'M'  and (Q1='2')
 update #results set Q4  = 'S'  where Q4  = 'M'  and (Q1='2')
 update #results set Q5  = 'S'  where Q5  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6  = 'S'  where Q6  = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q7  = 'S'  where Q7  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q8  = 'S'  where Q8  = 'M'  and (Q1='2' or Q4='1' or Q7='2')
 update #results set Q9  = 'S'  where Q9  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q10 = 'S'  where Q10 = 'M'  and (Q1='2' or Q4='1' or Q9='2')
 update #results set Q11 = 'S'  where Q11 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q12 = 'S'  where Q12 = 'M'  and (Q1='2' or Q4='1' or Q11='2')
 update #results set Q13 = 'S'  where Q13 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q14 = 'S'  where Q14 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q15 = 'S'  where Q15 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16 = 'S'  where Q16 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q17 = 'S'  where Q17 = 'M'  and (Q1='2' or Q4='1' or Q16='2')
 update #results set Q18 = 'S'  where Q18 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19 = 'S'  where Q19 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q20 = 'S'  where Q20 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21 = 'S'  where Q21 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q22 = 'S'  where Q22 = 'M'  and (Q1='2' or Q4='1' or Q21='2')
 update #results set Q23 = 'S ' where Q23 = 'M ' and (Q1='2' or Q4='1')
 update #results set Q24 = 'S'  where Q24 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25 = 'S'  where Q25 = 'M'  and (Q1='2' or Q4='1')

-- If Q33 = 2 (“No”) Skip to end of the survey
-- Questions 34a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q33).
 -- If they answered Q33 “No”, invoking the skip, then mark the question appropriately skipped.
    update #results set Q34a='S',Q34b='S',Q34c='S',Q34d='S',Q34e='S' where Q33  = '2' and Q34a+Q34b+Q34c+Q34d+Q34e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 ='  ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32a=' ',
 Q32b=' ',
 Q32c=' ',
 Q32d=' ',
 Q32e=' ',
 Q32f=' ',
 Q33 =' ',
 Q34a=' ',
 Q34b=' ',
 Q34c=' ',
 Q34d=' ',
 Q34e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6MonthPCMHa')
	drop procedure GetCGCAHPSdata2_sub_Adult6MonthPCMHa
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Adult6MonthPCMHa
as
alter table #results add
 Q1   char(1), -- Q050344
 Q2   char(1), -- Q050176
 Q3   char(1), -- Q050177
 Q4   char(1), -- Q050178
 Q5   char(1), -- Q050179
 Q6   char(1), -- Q050180
 Q7   char(1), -- Q050541
 Q8   char(1), -- Q050181
 Q9   char(1), -- Q050182
 Q10  char(1), -- Q050542
 Q11  char(1), -- Q050543
 Q12  char(1), -- Q050544
 Q13  char(1), -- Q050183
 Q14  char(1), -- Q050184
 Q15  char(1), -- Q050185
 Q16  char(1), -- Q050186
 Q17  char(1), -- Q050545
 Q18  char(1), -- Q050189
 Q19  char(1), -- Q050190
 Q20  char(1), -- Q050191
 Q21  char(1), -- Q050192
 Q22  char(1), -- Q050193
 Q23  char(1), -- Q050194
 Q24  char(1), -- Q050196
 Q25  char(1), -- Q050197
 Q26  char(1), -- Q050198
 Q27  char(1), -- Q050199
 Q28  char(1), -- Q050546
 Q29  char(1), -- Q050547
 Q30  char(1), -- Q050548
 Q31  char(1), -- Q050549
 Q32  char(2), -- Q050215
 Q33  char(1), -- Q050550
 Q34  char(1), -- Q050551
 Q35  char(1), -- Q050552
 Q36  char(1), -- Q050553
 Q37  char(1), -- Q050554
 Q38  char(1), -- Q050555
 Q39  char(1), -- Q050556
 Q40  char(1), -- Q050557
 Q41  char(1), -- Q050558
 Q42  char(1), -- Q050216
 Q43  char(1), -- Q050217
 Q44  char(1), -- Q050234
 Q45  char(1), -- Q050235
 Q46  char(1), -- Q050241
 Q47  char(1), -- Q050699
 Q48  char(1), -- Q050243
 Q49  char(1), -- Q050253
 Q50a char(1), -- Q050255a
 Q50b char(1), -- Q050255b
 Q50c char(1), -- Q050255d - Q050255j
 Q50d char(1), -- Q050255k - Q050255n
 Q50e char(1), -- Q050255c
 Q50f char(1), -- Always '0'
 Q51  char(1), -- Q050256
 Q52a char(1), -- Q050257a
 Q52b char(1), -- Q050257b
 Q52c char(1), -- Q050257c
 Q52d char(1), -- Q050257d
 Q52e char(1)  -- Q050257e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6MonthPCMHb')
	drop procedure GetCGCAHPSdata2_sub_Adult6MonthPCMHb
go
--DRM 03/04/2015 Created.
create procedure [dbo].[GetCGCAHPSdata2_sub_Adult6MonthPCMHb]
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
begin
update #results set surveytype=16

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q050344,-9) when -9 then 'M' when -8 then 'H' else cast(Q050344%10000 as varchar) end,
 Q2   = case isnull(Q050176,-9) when -9 then 'M' when -8 then 'H' else cast(Q050176%10000 as varchar) end,
 Q3   = case isnull(Q050177,-9) when -9 then 'M' when -8 then 'H' else cast(Q050177%10000 as varchar) end,
 Q4   = case isnull(Q050178,-9) when -9 then 'M' when -8 then 'H' else cast(Q050178%10000 as varchar) end,
 Q5   = case isnull(Q050179,-9) when -9 then 'M' when -8 then 'H' else cast(Q050179%10000 as varchar) end,
 Q6   = case isnull(Q050180,-9) when -9 then 'M' when -8 then 'H' else cast(Q050180%10000 as varchar) end,
 Q7   = case isnull(Q050541,-9) when -9 then 'M' when -8 then 'H' else cast(Q050541%10000 as varchar) end,
 Q8   = case isnull(Q050181,-9) when -9 then 'M' when -8 then 'H' else cast(Q050181%10000 as varchar) end,
 Q9   = case isnull(Q050182,-9) when -9 then 'M' when -8 then 'H' else cast(Q050182%10000 as varchar) end,
 Q10  = case isnull(Q050542,-9) when -9 then 'M' when -8 then 'H' else cast(Q050542%10000 as varchar) end,
 Q11  = case isnull(Q050543,-9) when -9 then 'M' when -8 then 'H' else cast(Q050543%10000 as varchar) end,
 Q12  = case isnull(Q050544,-9) when -9 then 'M' when -8 then 'H' else cast(Q050544%10000 as varchar) end,
 Q13  = case isnull(Q050183,-9) when -9 then 'M' when -8 then 'H' else cast(Q050183%10000 as varchar) end,
 Q14  = case isnull(Q050184,-9) when -9 then 'M' when -8 then 'H' else cast(Q050184%10000 as varchar) end,
 Q15  = case isnull(Q050185,-9) when -9 then 'M' when -8 then 'H' else cast(Q050185%10000 as varchar) end,
 Q16  = case isnull(Q050186,-9) when -9 then 'M' when -8 then 'H' else cast(Q050186%10000 as varchar) end,
 Q17  = case isnull(Q050545,-9) when -9 then 'M' when -8 then 'H' else cast(Q050545%10000 as varchar) end,
 Q18  = case isnull(Q050189,-9) when -9 then 'M' when -8 then 'H' else cast(Q050189%10000 as varchar) end,
 Q19  = case isnull(Q050190,-9) when -9 then 'M' when -8 then 'H' else cast(Q050190%10000 as varchar) end,
 Q20  = case isnull(Q050191,-9) when -9 then 'M' when -8 then 'H' else cast(Q050191%10000 as varchar) end,
 Q21  = case isnull(Q050192,-9) when -9 then 'M' when -8 then 'H' else cast(Q050192%10000 as varchar) end,
 Q22  = case isnull(Q050193,-9) when -9 then 'M' when -8 then 'H' else cast(Q050193%10000 as varchar) end,
 Q23  = case isnull(Q050194,-9) when -9 then 'M' when -8 then 'H' else cast(Q050194%10000 as varchar) end,
 Q24  = case isnull(Q050196,-9) when -9 then 'M' when -8 then 'H' else cast(Q050196%10000 as varchar) end,
 Q25  = case isnull(Q050197,-9) when -9 then 'M' when -8 then 'H' else cast(Q050197%10000 as varchar) end,
 Q26  = case isnull(Q050198,-9) when -9 then 'M' when -8 then 'H' else cast(Q050198%10000 as varchar) end,
 Q27  = case isnull(Q050199,-9) when -9 then 'M' when -8 then 'H' else cast(Q050199%10000 as varchar) end,
 Q28  = case isnull(Q050546,-9) when -9 then 'M' when -8 then 'H' else cast(Q050546%10000 as varchar) end,
 Q29  = case isnull(Q050547,-9) when -9 then 'M' when -8 then 'H' else cast(Q050547%10000 as varchar) end,
 Q30  = case isnull(Q050548,-9) when -9 then 'M' when -8 then 'H' else cast(Q050548%10000 as varchar) end,
 Q31  = case isnull(Q050549,-9) when -9 then 'M' when -8 then 'H' else cast(Q050549%10000 as varchar) end,
 Q32  = case isnull(Q050215,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050215%10000 as varchar),2) end,
 Q33  = case isnull(Q050550,-9) when -9 then 'M' when -8 then 'H' else cast(Q050550%10000 as varchar) end,
 Q34  = case isnull(Q050551,-9) when -9 then 'M' when -8 then 'H' else cast(Q050551%10000 as varchar) end,
 Q35  = case isnull(Q050552,-9) when -9 then 'M' when -8 then 'H' else cast(Q050552%10000 as varchar) end,
 Q36  = case isnull(Q050553,-9) when -9 then 'M' when -8 then 'H' else cast(Q050553%10000 as varchar) end,
 Q37  = case isnull(Q050554,-9) when -9 then 'M' when -8 then 'H' else cast(Q050554%10000 as varchar) end,
 Q38  = case isnull(Q050555,-9) when -9 then 'M' when -8 then 'H' else cast(Q050555%10000 as varchar) end,
 Q39  = case isnull(Q050556,-9) when -9 then 'M' when -8 then 'H' else cast(Q050556%10000 as varchar) end,
 Q40  = case isnull(Q050557,-9) when -9 then 'M' when -8 then 'H' else cast(Q050557%10000 as varchar) end,
 Q41  = case isnull(Q050558,-9) when -9 then 'M' when -8 then 'H' else cast(Q050558%10000 as varchar) end,
 Q42  = case isnull(Q050216,-9) when -9 then 'M' when -8 then 'H' else cast(Q050216%10000 as varchar) end,
 Q43  = case isnull(Q050217,-9) when -9 then 'M' when -8 then 'H' else cast(Q050217%10000 as varchar) end,
 Q44  = case isnull(Q050234,-9) when -9 then 'M' when -8 then 'H' else cast(Q050234%10000 as varchar) end,
 Q45  = case isnull(Q050235,-9) when -9 then 'M' when -8 then 'H' else cast(Q050235%10000 as varchar) end,
 Q46  = case isnull(Q050241,-9) when -9 then 'M' when -8 then 'H' when 8 then 'S' when 9 then 'S' when 10 then 'S' else cast(Q050241%10000 as varchar) end,
 Q47  = case isnull(Q050699,-9) when -9 then 'M' when -8 then 'H' else cast(Q050699%10000 as varchar) end,
 Q48  = case isnull(Q050243,-9) when -9 then 'M' when -8 then 'H' else cast(Q050243%10000 as varchar) end,
 Q49  = case isnull(Q050253,-9) when -9 then 'M' when -8 then 'H' else cast(Q050253%10000 as varchar) end,
 Q50a = case isnull(q050255a,-9) when -9 then 0 else 1 end,
 Q50b = case isnull(q050255b,-9) when -9 then 0 else 1 end,
 Q50c = case when (q050255d=1 or q050255e=1 or q050255f=1 or q050255g=1 or q050255h=1 or q050255i=1 or q050255j=1) then 1 else 0 end,
 Q50d = case when (q050255k=1 or q050255l=1 or q050255m=1 or q050255n=1) then 1 else 0 end,
 Q50e = case isnull(q050255c,-9) when -9 then 0 else 1 end,
 Q50f = 0,
 Q51  = case isnull(q050256,-9) when -9 then 'M' when -8 then 'H' else cast(Q050256%10000 as varchar) end,
 Q52a = case isnull(q050257a,-9) when -9 then 0 else 1 end,
 Q52b = case isnull(q050257b,-9) when -9 then 0 else 1 end,
 Q52c = case isnull(q050257c,-9) when -9 then 0 else 1 end,
 Q52d = case isnull(q050257d,-9) when -9 then 0 else 1 end,
 Q52e = case isnull(q050257e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 44234 and 44235 for Q51 and Q52.
-- others use cores 48664 and 48665.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @sql nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (44234,44235))
 set @SQL =
 N'update r set
  Q51  = case isnull(q044234,-9) when -9 then ''M'' when -8 then ''H'' else  as varchar)044234%10000 as varchar) end,
  Q52a = case isnull(q044235a,-9) when -9 then 0 else 1 end,
  Q52b = case isnull(q044235b,-9) when -9 then 0 else 1 end,
  Q52c = case isnull(q044235c,-9) when -9 then 0 else 1 end,
  Q52d = case isnull(q044235d,-9) when -9 then 0 else 1 end,
  Q52e = case isnull(q044235e,-9) when -9 then 0 else 1 end'
else
 set @SQL =
 N'update r set
  Q51  = case isnull(q048664,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048664%10000 as varchar) end,
  Q52a = case isnull(q048665a,-9) when -9 then 0 else 1 end,
  Q52b = case isnull(q048665b,-9) when -9 then 0 else 1 end,
  Q52c = case isnull(q048665c,-9) when -9 then 0 else 1 end,
  Q52d = case isnull(q048665d,-9) when -9 then 0 else 1 end,
  Q52e = case isnull(q048665e,-9) when -9 then 0 else 1 end'

set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Adult 12-month w/ PCMH:
-- Q1 = core 44121
-- If Q1 = 2 (“No”) Questions 2-43 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-43 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
 update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
 update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
 update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q8='2')
 update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1' or Q11='2')
 update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1' or Q13='2')
 update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1' or Q15='2')
 update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1' or Q21='2')
 update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q24  = 'S'  where Q24  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25  = 'S'  where Q25  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1' or Q26='2')
 update #results set Q28  = 'S'  where Q28  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q29  = 'S'  where Q29  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q30  = 'S'  where Q30  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q31  = 'S'  where Q31  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q32  = 'S ' where Q32  = 'M ' and (Q1='2' or Q4='1')
 update #results set Q33  = 'S'  where Q33  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q34  = 'S'  where Q34  = 'M'  and (Q1='2' or Q4='1' or Q33='2')
 update #results set Q35  = 'S'  where Q35  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q36  = 'S'  where Q36  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q37  = 'S'  where Q37  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q38  = 'S'  where Q38  = 'M'  and (Q1='2' or Q4='1' or Q37='2')
 update #results set Q39  = 'S'  where Q39  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q40  = 'S'  where Q40  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q41  = 'S'  where Q41  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q42  = 'S'  where Q42  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q43  = 'S'  where Q43  = 'M'  and (Q1='2' or Q4='1')


-- If Q51 = 2 (“No”) Skip to end of the survey
-- Questions 52a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q51).
 -- If they answered Q51 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q52a='S',Q52b='S',Q52c='S',Q52d='S',Q52e='S' where Q51 = '2' and Q52a+Q52b+Q52c+Q52d+Q52e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 ='  ',
 Q33 =' ',
 Q34 =' ',
 Q35 =' ',
 Q36 =' ',
 Q37 =' ',
 Q38 =' ',
 Q39 =' ',
 Q40 =' ',
 Q41 =' ',
 Q42 =' ',
 Q43 =' ',
 Q44 =' ',
 Q45 =' ',
 Q46 =' ',
 Q47 =' ',
 Q48 =' ',
 Q49 =' ',
 Q50a=' ',
 Q50b=' ',
 Q50c=' ',
 Q50d=' ',
 Q50e=' ',
 Q50f=' ',
 Q51 =' ',
 Q52a=' ',
 Q52b=' ',
 Q52c=' ',
 Q52d=' ',
 Q52e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
end
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_AdultVisitA')
	drop procedure GetCGCAHPSdata2_sub_AdultVisitA
go
create procedure dbo.GetCGCAHPSdata2_sub_AdultVisitA
as
alter table #results add
	Q1   char(1), -- Q039113
	Q2   char(1), -- Q039114
	Q3   char(1), -- Q039115
	Q4   char(1), -- Q039116
	Q5   char(1), -- Q039117
	Q6   char(1), -- Q039118
	Q7   char(1), -- Q039119
	Q8   char(1), -- Q039120
	Q9   char(1), -- Q039121
	Q10  char(1), -- Q039122
	Q11  char(1), -- Q039123
	Q12  char(1), -- Q039124
	Q13  char(1), -- Q039125
	Q14  char(1), -- Q039126
	Q15  char(1), -- Q039127
	Q16  char(1), -- Q039130
	Q17  char(1), -- Q039131
	Q18  char(1), -- Q039132
	Q19  char(1), -- Q039133
	Q20  char(1), -- Q039134
	Q21  char(1), -- Q039135
	Q22  char(1), -- Q039136
	Q23  char(1), -- Q039128
	Q24  char(1), -- Q039129
	Q25  char(2), -- Q039137
	Q26  char(1), -- Q039138
	Q27  char(1), -- Q039139
	Q28  char(1), -- Q039140
	Q29  char(1), -- Q039151
	Q30  char(1), -- Q046688
	Q31  char(1), -- Q039156
	Q32  char(1), -- Q039157
	Q33  char(1), -- Q039158
	Q34  char(1), -- Q039159
	Q35a char(1), -- Q039160a
	Q35b char(1), -- Q039160b
	Q35c char(1), -- Q039160c
	Q35d char(1), -- Q039160d
	Q35e char(1), -- Q039160e
	Q35f char(1), -- Q039160f
	Q36  char(1), -- Q040716
	Q37a char(1), -- Q039162a
	Q37b char(1), -- Q039162b
	Q37c char(1), -- Q039162c
	Q37d char(1), -- Q039162d
	Q37e char(1)  -- Q039162e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_AdultVisitB')
	drop procedure GetCGCAHPSdata2_sub_AdultVisitB
go
--DRM 06/18/2013 Added check for empty results.  This was causing a problem for empty returns.
--DRM 01/20/2014 Added left pad on Q25.
--DRM 03/06/2014 Added phone and web surveys to check at end of proc.
create procedure [dbo].[GetCGCAHPSdata2_sub_AdultVisitB]
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=33

update r set
 Q1   = case isnull(q039113,-9) when -9 then 'M' when -8 then 'H' else cast(Q039113%10000 as varchar) end,
 Q2   = case isnull(q039114,-9) when -9 then 'M' when -8 then 'H' else cast(Q039114%10000 as varchar) end,
 Q3   = case isnull(q039115,-9) when -9 then 'M' when -8 then 'H' else cast(Q039115%10000 as varchar) end,
 Q4   = case isnull(q039116,-9) when -9 then 'M' when -8 then 'H' else cast(Q039116%10000 as varchar) end,
 Q5   = case isnull(q039117,-9) when -9 then 'M' when -8 then 'H' else cast(Q039117%10000 as varchar) end,
 Q6   = case isnull(q039118,-9) when -9 then 'M' when -8 then 'H' else cast(Q039118%10000 as varchar) end,
 Q7   = case isnull(q039119,-9) when -9 then 'M' when -8 then 'H' else cast(Q039119%10000 as varchar) end,
 Q8   = case isnull(q039120,-9) when -9 then 'M' when -8 then 'H' else cast(Q039120%10000 as varchar) end,
 Q9   = case isnull(q039121,-9) when -9 then 'M' when -8 then 'H' else cast(Q039121%10000 as varchar) end,
 Q10  = case isnull(q039122,-9) when -9 then 'M' when -8 then 'H' else cast(Q039122%10000 as varchar) end,
 Q11  = case isnull(q039123,-9) when -9 then 'M' when -8 then 'H' else cast(Q039123%10000 as varchar) end,
 Q12  = case isnull(q039124,-9) when -9 then 'M' when -8 then 'H' else cast(Q039124%10000 as varchar) end,
 Q13  = case isnull(q039125,-9) when -9 then 'M' when -8 then 'H' else cast(Q039125%10000 as varchar) end,
 Q14  = case isnull(q039126,-9) when -9 then 'M' when -8 then 'H' else cast(Q039126%10000 as varchar) end,
 Q15  = case isnull(q039127,-9) when -9 then 'M' when -8 then 'H' else cast(Q039127%10000 as varchar) end,
 Q16  = case isnull(q039130,-9) when -9 then 'M' when -8 then 'H' else cast(Q039130%10000 as varchar) end,
 Q17  = case isnull(q039131,-9) when -9 then 'M' when -8 then 'H' else cast(Q039131%10000 as varchar) end,
 Q18  = case isnull(q039132,-9) when -9 then 'M' when -8 then 'H' else cast(Q039132%10000 as varchar) end,
 Q19  = case isnull(q039133,-9) when -9 then 'M' when -8 then 'H' else cast(Q039133%10000 as varchar) end,
 Q20  = case isnull(q039134,-9) when -9 then 'M' when -8 then 'H' else cast(Q039134%10000 as varchar) end,
 Q21  = case isnull(q039135,-9) when -9 then 'M' when -8 then 'H' else cast(Q039135%10000 as varchar) end,
 Q22  = case isnull(q039136,-9) when -9 then 'M' when -8 then 'H' else cast(Q039136%10000 as varchar) end,
 Q23  = case isnull(q039128,-9) when -9 then 'M' when -8 then 'H' else cast(Q039128%10000 as varchar) end,
 Q24  = case isnull(q039129,-9) when -9 then 'M' when -8 then 'H' else cast(Q039129%10000 as varchar) end,
--DRM 01/20/2014 Added left pad on Q25.
 Q25  = case isnull(q039137,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(q039137%10000 as varchar),2) end,
-- Q25  = case isnull(q039137,-9) when -9 then 'M ' when -8 then 'H ' else Q039137%10000 end,
 Q26  = case isnull(q039138,-9) when -9 then 'M' when -8 then 'H' else cast(Q039138%10000 as varchar) end,
 Q27  = case isnull(q039139,-9) when -9 then 'M' when -8 then 'H' else cast(Q039139%10000 as varchar) end,
 Q28  = case isnull(q039140,-9) when -9 then 'M' when -8 then 'H' else cast(Q039140%10000 as varchar) end,
 Q29  = case isnull(q039151,-9) when -9 then 'M' when -8 then 'H' else cast(Q039151%10000 as varchar) end,
 Q30  = case isnull(q046688,-9) when -9 then 'M' when -8 then 'H' else cast(Q046688%10000 as varchar) end,
 Q31  = case isnull(q039156,-9) when -9 then 'M' when -8 then 'H' else cast(Q039156%10000 as varchar) end,
 Q32  = case isnull(q039157,-9) when -9 then 'M' when -8 then 'H' else cast(Q039157%10000 as varchar) end,
 Q33  = case isnull(q039158,-9) when -9 then 'M' when -8 then 'H' else cast(Q039158%10000 as varchar) end,
 Q34  = case isnull(q039159,-9) when -9 then 'M' when -8 then 'H' else cast(Q039159%10000 as varchar) end,
 Q35a = case isnull(q039160a,-9) when -9 then 0 else 1 end,
 Q35b = case isnull(q039160b,-9) when -9 then 0 else 1 end,
 Q35c = case isnull(q039160c,-9) when -9 then 0 else 1 end,
 Q35d = case isnull(q039160d,-9) when -9 then 0 else 1 end,
 Q35e = case isnull(q039160e,-9) when -9 then 0 else 1 end,
 Q35f = case isnull(q039160f,-9) when -9 then 0 else 1 end
 --Q36  = case isnull(q040716,-9) when -9 then 'M' when -8 then 'H' else q040716%10000 end,
 --Q37a = case isnull(q039162a,-9) when -9 then 0 else 1 end,
 --Q37b = case isnull(q039162b,-9) when -9 then 0 else 1 end,
 --Q37c = case isnull(q039162c,-9) when -9 then 0 else 1 end,
 --Q37d = case isnull(q039162d,-9) when -9 then 0 else 1 end,
 --Q37e = case isnull(q039162e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id



--06/18/2013 dmp
--If it's a phone survey, it won't have the last two "helped" questions, (cores 40716 & 39162)
--So we populate those columns with the appropriate values for "missing" or "appropriately skipped"
declare @sql nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (40716,39162))
 set @SQL =
 N'update r set
  Q36  = case isnull(q040716,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q040716%10000 as varchar) end,
  Q37a = case isnull(q039162a,-9) when -9 then 0 else 1 end,
  Q37b = case isnull(q039162b,-9) when -9 then 0 else 1 end,
  Q37c = case isnull(q039162c,-9) when -9 then 0 else 1 end,
  Q37d = case isnull(q039162d,-9) when -9 then 0 else 1 end,
  Q37e = case isnull(q039162e,-9) when -9 then 0 else 1 end'

else
 set @SQL =
 N'update r set
  Q36  = ''M'',
  Q37a = 7,
  Q37b = 7,
  Q37c = 7,
  Q37d = 7,
  Q37e = 7'


set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id



-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- Adult Visit:
-- Q1 = core q039113
-- If Q1 = 2 (“No”) Questions 2-28 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-28 should have case logic applied
-- If Q5 = 2 ("No") Question 6 should have case logic applied
-- If Q7 = 2 ("No") Question 8 should have case logic applied
-- If Q9 = 2 ("No") Question 10 should have case logic applied
-- If Q11 = 2 ("No") Question 12 should have case logic applied
-- If Q18 = 2 ("No") Question 19 should have case logic applied
-- If Q23 = 2 ("No") Question 24 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question(s)
 -- If they invoked the skip, then mark the question appropriately skipped.
 update #results set Q2  = 'S'  where Q2  = 'M'  and (Q1='2')
 update #results set Q3  = 'S'  where Q3  = 'M'  and (Q1='2')
 update #results set Q4  = 'S'  where Q4  = 'M'  and (Q1='2')
 update #results set Q5  = 'S'  where Q5  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6  = 'S'  where Q6  = 'M'  and (Q1='2' or Q4='1' or Q5='2')
 update #results set Q7  = 'S'  where Q7  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q8  = 'S'  where Q8  = 'M'  and (Q1='2' or Q4='1' or Q7='2')
 update #results set Q9  = 'S'  where Q9  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q10 = 'S'  where Q10 = 'M'  and (Q1='2' or Q4='1' or Q9='2')
 update #results set Q11 = 'S'  where Q11 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q12 = 'S'  where Q12 = 'M'  and (Q1='2' or Q4='1' or Q11='2')
 update #results set Q13 = 'S'  where Q13 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q14 = 'S'  where Q14 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q15 = 'S'  where Q15 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16 = 'S'  where Q16 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q17 = 'S'  where Q17 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q18 = 'S'  where Q18 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19 = 'S'  where Q19 = 'M'  and (Q1='2' or Q4='1' or Q18='2')
 update #results set Q20 = 'S'  where Q20 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21 = 'S'  where Q21 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q22 = 'S'  where Q22 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q23 = 'S'  where Q23 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q24 = 'S'  where Q24 = 'M'  and (Q1='2' or Q4='1' or Q23='2')
 update #results set Q25 = 'S ' where Q25 = 'M ' and (Q1='2' or Q4='1')
 update #results set Q26 = 'S'  where Q26 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27 = 'S'  where Q27 = 'M'  and (Q1='2' or Q4='1')
 update #results set Q28 = 'S'  where Q28 = 'M'  and (Q1='2' or Q4='1')

-- If Q36 = 2 (“No”) Skip to end of the survey
-- Questions 37a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q36).
 -- If they answered Q36 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q37a='S',Q37b='S',Q37c='S',Q37d='S',Q37e='S' where Q36  = '2' and Q37a+Q37b+Q37c+Q37d+Q37e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',
 Q24 =' ',
 Q25 ='  ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 =' ',
 Q33 =' ',
 Q34 =' ',
 Q35a=' ',
 Q35b=' ',
 Q35c=' ',
 Q35d=' ',
 Q35e=' ',
 Q35f=' ',
 Q36 =' ',
 Q37a=' ',
 Q37b=' ',
 Q37c=' ',
 Q37d=' ',
 Q37e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child12MonthPCMHa')
	drop procedure GetCGCAHPSdata2_sub_Child12MonthPCMHa
go
create procedure dbo.GetCGCAHPSdata2_sub_Child12MonthPCMHa
as
alter table #results add
	Q1   char(1), -- Q046265
	Q2   char(1), -- Q046266
	Q3   char(1), -- Q046267
	Q4   char(1), -- Q046268
	Q5   char(1), -- Q046269
	Q6   char(1), -- Q046270
	Q7   char(1), -- Q046271
	Q8   char(1), -- Q046272
	Q9   char(1), -- Q046273
	Q10  char(1), -- Q046274
	Q11  char(1), -- Q046275
	Q12  char(1), -- Q046276
	Q13  char(1), -- Q046277
	Q14  char(1), -- Q046278
	Q15  char(1), -- Q046279
	Q16  char(1), -- Q046280
	Q17  char(1), -- Q046281
	Q18  char(1), -- Q046282
	Q19  char(1), -- Q046283
	Q20  char(1), -- Q046284
	Q21  char(1), -- Q046285
	Q22  char(1), -- Q046286
	Q23  char(1), -- Q046287
	Q24  char(1), -- Q046288
	Q25  char(1), -- Q046289
	Q26  char(1), -- Q046290
	Q27  char(1), -- Q046291
	Q28  char(1), -- Q046292
	Q29  char(1), -- Q046293
	Q30  char(1), -- Q046294
	Q31  char(1), -- Q046295
	Q32  char(1), -- Q046296
	Q33  char(1), -- Q046297
	Q34  char(1), -- Q046298
	Q35  char(2), -- Q046299
	Q36  char(1), -- Q046300
	Q37  char(1), -- Q046301
	Q38  char(1), -- Q046302
	Q39  char(1), -- Q046303
	Q40  char(1), -- Q046304
	Q41  char(1), -- Q046305
	Q42  char(1), -- Q046306
	Q43  char(1), -- Q046307
	Q44  char(1), -- Q046308
	Q45  char(1), -- Q046309
	Q46  char(1), -- Q046310
	Q47  char(1), -- Q046311
	Q48  char(1), -- Q046312
	Q49  char(1), -- Q046313
	Q50  char(1), -- Q046314
	Q51  char(1), -- Q046315
	Q52  char(1), -- Q046316
	Q53  char(1), -- Q046317
	Q54  char(1), -- Q046318
	Q55  char(1), -- Q046319
	Q56  char(1), -- Q046320
	Q57  char(2), -- Q046321
	Q58  char(1), -- Q046322
	Q59  char(1), -- Q046323
	Q60a char(1), -- Q046324a
	Q60b char(1), -- Q046324b
	Q60c char(1), -- Q046324c
	Q60d char(1), -- Q046324d
	Q60e char(1), -- Q046324e
	Q60f char(1), -- Q046324f
	Q61  char(1), -- Q048856 / 46325   <-- some surveys use 488856, 48666, 48667 and 48668. Others use 46325, 46328, 46329 and 46330.
	Q62  char(1), -- Q046326
	Q63  char(1), -- Q046327
	Q64  char(1), -- Q048666 / 46328
	Q65  char(1), -- Q048667 / 46329
	Q66a char(1), -- Q048668a / 46330a
	Q66b char(1), -- Q048668b / 46330b
	Q66c char(1), -- Q048668c / 46330c
	Q66d char(1), -- Q048668d / 46330d
	Q66e char(1)  -- Q048668e / 46330e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child12MonthPCMHb')
	drop procedure GetCGCAHPSdata2_sub_Child12MonthPCMHb
go
--DRM 06/18/2013 Added check for empty results.  This was causing a problem for empty returns.
--DRM 01/20/2014 Added left pad on Q35.
--DRM 03/06/2014 Added phone and web surveys to check at end of proc.
create procedure dbo.GetCGCAHPSdata2_sub_Child12MonthPCMHb
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=18

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(q046265,-9) when -9 then 'M' when -8 then 'H' else cast(Q046265%10000 as varchar) end,
 Q2   = case isnull(q046266,-9) when -9 then 'M' when -8 then 'H' else cast(Q046266%10000 as varchar) end,
 Q3   = case isnull(q046267,-9) when -9 then 'M' when -8 then 'H' else cast(Q046267%10000 as varchar) end,
 Q4   = case isnull(q046268,-9) when -9 then 'M' when -8 then 'H' else cast(Q046268%10000 as varchar) end,
 Q5   = case isnull(q046269,-9) when -9 then 'M' when -8 then 'H' else cast(Q046269%10000 as varchar) end,
 Q6   = case isnull(q046270,-9) when -9 then 'M' when -8 then 'H' else cast(Q046270%10000 as varchar) end,
 Q7   = case isnull(q046271,-9) when -9 then 'M' when -8 then 'H' else cast(Q046271%10000 as varchar) end,
 Q8   = case isnull(q046272,-9) when -9 then 'M' when -8 then 'H' else cast(Q046272%10000 as varchar) end,
 Q9   = case isnull(q046273,-9) when -9 then 'M' when -8 then 'H' else cast(Q046273%10000 as varchar) end,
 Q10  = case isnull(q046274,-9) when -9 then 'M' when -8 then 'H' else cast(Q046274%10000 as varchar) end,
 Q11  = case isnull(q046275,-9) when -9 then 'M' when -8 then 'H' else cast(Q046275%10000 as varchar) end,
 Q12  = case isnull(q046276,-9) when -9 then 'M' when -8 then 'H' else cast(Q046276%10000 as varchar) end,
 Q13  = case isnull(q046277,-9) when -9 then 'M' when -8 then 'H' else cast(Q046277%10000 as varchar) end,
 Q14  = case isnull(q046278,-9) when -9 then 'M' when -8 then 'H' else cast(Q046278%10000 as varchar) end,
 Q15  = case isnull(q046279,-9) when -9 then 'M' when -8 then 'H' else cast(Q046279%10000 as varchar) end,
 Q16  = case isnull(q046280,-9) when -9 then 'M' when -8 then 'H' else cast(Q046280%10000 as varchar) end,
 Q17  = case isnull(q046281,-9) when -9 then 'M' when -8 then 'H' else cast(Q046281%10000 as varchar) end,
 Q18  = case isnull(q046282,-9) when -9 then 'M' when -8 then 'H' else cast(Q046282%10000 as varchar) end,
 Q19  = case isnull(q046283,-9) when -9 then 'M' when -8 then 'H' else cast(Q046283%10000 as varchar) end,
 Q20  = case isnull(q046284,-9) when -9 then 'M' when -8 then 'H' else cast(Q046284%10000 as varchar) end,
 Q21  = case isnull(q046285,-9) when -9 then 'M' when -8 then 'H' else cast(Q046285%10000 as varchar) end,
 Q22  = case isnull(q046286,-9) when -9 then 'M' when -8 then 'H' else cast(Q046286%10000 as varchar) end,
 Q23  = case isnull(q046287,-9) when -9 then 'M' when -8 then 'H' else cast(Q046287%10000 as varchar) end,
 Q24  = case isnull(q046288,-9) when -9 then 'M' when -8 then 'H' else cast(Q046288%10000 as varchar) end,
 Q25  = case isnull(q046289,-9) when -9 then 'M' when -8 then 'H' else cast(Q046289%10000 as varchar) end,
 Q26  = case isnull(q046290,-9) when -9 then 'M' when -8 then 'H' else cast(Q046290%10000 as varchar) end,
 Q27  = case isnull(q046291,-9) when -9 then 'M' when -8 then 'H' else cast(Q046291%10000 as varchar) end,
 Q28  = case isnull(q046292,-9) when -9 then 'M' when -8 then 'H' else cast(Q046292%10000 as varchar) end,
 Q29  = case isnull(q046293,-9) when -9 then 'M' when -8 then 'H' else cast(Q046293%10000 as varchar) end,
 Q30  = case isnull(q046294,-9) when -9 then 'M' when -8 then 'H' else cast(Q046294%10000 as varchar) end,
 Q31  = case isnull(q046295,-9) when -9 then 'M' when -8 then 'H' else cast(Q046295%10000 as varchar) end,
 Q32  = case isnull(q046296,-9) when -9 then 'M' when -8 then 'H' else cast(Q046296%10000 as varchar) end,
 Q33  = case isnull(q046297,-9) when -9 then 'M' when -8 then 'H' else cast(Q046297%10000 as varchar) end,
 Q34  = case isnull(q046298,-9) when -9 then 'M' when -8 then 'H' else cast(Q046298%10000 as varchar) end,
--DRM 01/20/2014 Added left pad on Q35.
 Q35  = case isnull(q046299,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(q046299%10000 as varchar),2) end,
-- Q35  = case isnull(q046299,-9) when -9 then 'M ' when -8 then 'H ' else Q046299%10000 end,
 Q36  = case isnull(q046300,-9) when -9 then 'M' when -8 then 'H' else cast(Q046300%10000 as varchar) end,
 Q37  = case isnull(q046301,-9) when -9 then 'M' when -8 then 'H' else cast(Q046301%10000 as varchar) end,
 Q38  = case isnull(q046302,-9) when -9 then 'M' when -8 then 'H' else cast(Q046302%10000 as varchar) end,
 Q39  = case isnull(q046303,-9) when -9 then 'M' when -8 then 'H' else cast(Q046303%10000 as varchar) end,
 Q40  = case isnull(q046304,-9) when -9 then 'M' when -8 then 'H' else cast(Q046304%10000 as varchar) end,
 Q41  = case isnull(q046305,-9) when -9 then 'M' when -8 then 'H' else cast(Q046305%10000 as varchar) end,
 Q42  = case isnull(q046306,-9) when -9 then 'M' when -8 then 'H' else cast(Q046306%10000 as varchar) end,
 Q43  = case isnull(q046307,-9) when -9 then 'M' when -8 then 'H' else cast(Q046307%10000 as varchar) end,
 Q44  = case isnull(q046308,-9) when -9 then 'M' when -8 then 'H' else cast(Q046308%10000 as varchar) end,
 Q45  = case isnull(q046309,-9) when -9 then 'M' when -8 then 'H' else cast(Q046309%10000 as varchar) end,
 Q46  = case isnull(q046310,-9) when -9 then 'M' when -8 then 'H' else cast(Q046310%10000 as varchar) end,
 Q47  = case isnull(q046311,-9) when -9 then 'M' when -8 then 'H' else cast(Q046311%10000 as varchar) end,
 Q48  = case isnull(q046312,-9) when -9 then 'M' when -8 then 'H' else cast(Q046312%10000 as varchar) end,
 Q49  = case isnull(q046313,-9) when -9 then 'M' when -8 then 'H' else cast(Q046313%10000 as varchar) end,
 Q50  = case isnull(q046314,-9) when -9 then 'M' when -8 then 'H' else cast(Q046314%10000 as varchar) end,
 Q51  = case isnull(q046315,-9) when -9 then 'M' when -8 then 'H' else cast(Q046315%10000 as varchar) end,
 Q52  = case isnull(q046316,-9) when -9 then 'M' when -8 then 'H' else cast(Q046316%10000 as varchar) end,
 Q53  = case isnull(q046317,-9) when -9 then 'M' when -8 then 'H' else cast(Q046317%10000 as varchar) end,
 Q54  = case isnull(q046318,-9) when -9 then 'M' when -8 then 'H' else cast(Q046318%10000 as varchar) end,
 Q55  = case isnull(q046319,-9) when -9 then 'M' when -8 then 'H' else cast(Q046319%10000 as varchar) end,
 Q56  = case isnull(q046320,-9) when -9 then 'M' when -8 then 'H' else cast(Q046320%10000 as varchar) end,
 -- Q57 (46321) is "What is your child's age?" (1) less than 1 year old (2) ____ years old (write in)
 -- the hand-entry is mapped to the HECGPedsAge metafield
 -- case  Q045321  HECGPedsAge    Result               comment
 -- a     -9       (numeric)      (HECGPedsAge value)  respondent didn't fill out either bubble, but they filled out the hand-entry
 -- a     -9       (non-numeric)  99 (missing)
 -- b     -8       (numeric)      88 (multi-mark)
 -- b     -8       (non-numeric)  88 (multi-mark)
 -- c     1        (numeric)      88 (multi-mark)      respondent marked the "less than 1" bubble and still filled out the hand-entry
 -- c     1        (non-numeric)  0
 -- d     2        (NULL)         99 (missing)         respondent marked the "___ years old" bubble, but didn't fill out the hand-entry
 -- e     2        (non-numeric)  99 (missing)         respondent marked the "___ years old" bubble, but filled in the hand-entry with a non-number
 -- f     2        (numeric)      (HECGPedsAge value)
 Q57  = case
     -- case a:
     when isnull(q046321,-9) = -9 then case when isnumeric(bt.HECGPedsAge)=1 and bt.HECGPedsAge not like '%,%' and floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2)) else 'M ' end
     -- case b:
     when isnull(q046321,-9) = -8 then 'H ' 
     -- case c:
     when q046321%10000 = 1 then case when isnumeric(bt.HECGPedsAge)=1 then 'H ' else '0 ' end
     -- case d:
     when bt.HECGPedsAge is null then 'M '
     -- case e:
     when isnumeric(bt.HECGPedsAge)=0 or bt.HECGPedsAge like '%,%' then 'M '
     -- case f:
     when floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2))
     else 'M '
     --case f was: else cast(floor(bt.HECGPedsAge) as varchar(2))
    end,
 Q58  = case isnull(q046322,-9) when -9 then 'M' when -8 then 'H' else cast(Q046322%10000 as varchar) end,
 Q59  = case isnull(q046323,-9) when -9 then 'M' when -8 then 'H' else cast(Q046323%10000 as varchar) end,
 Q60a = case isnull(q046324a,-9) when -9 then 0 else 1 end,
 Q60b = case isnull(q046324b,-9) when -9 then 0 else 1 end,
 Q60c = case isnull(q046324c,-9) when -9 then 0 else 1 end,
 Q60d = case isnull(q046324d,-9) when -9 then 0 else 1 end,
 Q60e = case isnull(q046324e,-9) when -9 then 0 else 1 end,
 Q60f = case isnull(q046324f,-9) when -9 then 0 else 1 end,
 Q62  = case isnull(q046326,-9) when -9 then 'M' when -8 then 'H' else cast(Q046326%10000 as varchar) end,
 Q63  = case isnull(q046327,-9) when -9 then 'M' when -8 then 'H' else cast(Q046327%10000 as varchar) end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 46325, 46328, 46329 and 46330 for Q61, Q64, Q65 and Q66.
-- others use cores 48856, 48666, 48667 and 48668.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @SQL nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (46325,46328,46329,46330))
 set @SQL = N'
 update r set
  Q61  = case isnull(q046325,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046325%10000 as varchar) end,
  Q64  = case isnull(q046328,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046328%10000 as varchar) end,
  Q65  = case isnull(q046329,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046329%10000 as varchar) end,
  Q66a = case isnull(q046330a,-9) when -9 then 0 else 1 end,
  Q66b = case isnull(q046330b,-9) when -9 then 0 else 1 end,
  Q66c = case isnull(q046330c,-9) when -9 then 0 else 1 end,
  Q66d = case isnull(q046330d,-9) when -9 then 0 else 1 end,
  Q66e = case isnull(q046330e,-9) when -9 then 0 else 1 end'
else
 set @SQL = N'
 update r set
  Q61  = case isnull(q048856,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048856%10000 as varchar) end,
  Q64  = case isnull(q048666,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048666%10000 as varchar) end,
  Q65  = case isnull(q048667,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048667%10000 as varchar) end,
  Q66a = case isnull(q048668a,-9) when -9 then 0 else 1 end,
  Q66b = case isnull(q048668b,-9) when -9 then 0 else 1 end,
  Q66c = case isnull(q048668c,-9) when -9 then 0 else 1 end,
  Q66d = case isnull(q048668d,-9) when -9 then 0 else 1 end,
  Q66e = case isnull(q048668e,-9) when -9 then 0 else 1 end'

set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
  inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Child 12-month w/ PCMH:
-- Q1 = core 46265
-- If Q1 = 2 (“No”) Questions 2-54 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-54 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
 update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
 update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
 update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='1')
 update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2')
 update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1' or Q10='2')
 update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
 update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
 update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1' or Q15='2')
 update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1' or Q18='2')
 update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1' or Q20='2')
 update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1' or Q22='2')
 update #results set Q24  = 'S'  where Q24  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25  = 'S'  where Q25  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q28  = 'S'  where Q28  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q29  = 'S'  where Q29  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q30  = 'S'  where Q30  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q31  = 'S'  where Q31  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q32  = 'S'  where Q32  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q33  = 'S'  where Q33  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q34  = 'S'  where Q34  = 'M'  and (Q1='2' or Q4='1' or Q33='2')
 update #results set Q35  = 'S ' where Q35  = 'M ' and (Q1='2' or Q4='1')
 update #results set Q36  = 'S'  where Q36  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q37  = 'S'  where Q37  = 'M'  and (Q1='2' or Q4='1' or Q36='2')
 update #results set Q38  = 'S'  where Q38  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q39  = 'S'  where Q39  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q40  = 'S'  where Q40  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q41  = 'S'  where Q41  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q42  = 'S'  where Q42  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q43  = 'S'  where Q43  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q44  = 'S'  where Q44  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q45  = 'S'  where Q45  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q46  = 'S'  where Q46  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q47  = 'S'  where Q47  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q48  = 'S'  where Q48  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q49  = 'S'  where Q49  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q50  = 'S'  where Q50  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q51  = 'S'  where Q51  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q52  = 'S'  where Q52  = 'M'  and (Q1='2' or Q4='1' or Q51='2')
 update #results set Q53  = 'S'  where Q53  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q54  = 'S'  where Q54  = 'M'  and (Q1='2' or Q4='1')

-- If Q65 = 2 (“No”) Skip to end of the survey
-- Questions 66a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q65).
 -- If they answered Q65 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q66a='S',Q66b='S',Q66c='S',Q66d='S',Q66e='S' where Q65 = '2' and Q66a+Q66b+Q66c+Q66d+Q66e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 =' ',
 Q33 =' ',
 Q34 =' ',
 Q35 ='  ',
 Q36 =' ',
 Q37 =' ',
 Q38 =' ',
 Q39 =' ',
 Q40 =' ',
 Q41 =' ',
 Q42 =' ',
 Q43 =' ',
 Q44 =' ',
 Q45 =' ',
 Q46 =' ',
 Q47 =' ',
 Q48 =' ',
 Q49 =' ',
 Q50 =' ',
 Q51 =' ',
 Q52 =' ',
 Q53 =' ',
 Q54 =' ',
 Q55 =' ',
 Q56 =' ',
 Q57 ='  ',
 Q58 =' ',
 Q59 =' ',
 Q60a=' ',
 Q60b=' ',
 Q60c=' ',
 Q60d=' ',
 Q60e=' ',
 Q60f=' ',
 Q61 =' ',
 Q62 =' ',
 Q63 =' ',
 Q64 =' ',
 Q65 =' ',
 Q66a=' ',
 Q66b=' ',
 Q66c=' ',
 Q66d=' ',
 Q66e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6Montha')
	drop procedure GetCGCAHPSdata2_sub_Child6Montha
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Child6Montha
as
alter table #results add
 Q1   char(1), -- Q050483
 Q2   char(1), -- Q050484
 Q3   char(1), -- Q050485
 Q4   char(1), -- Q050486
 Q5   char(1), -- Q050487
 Q6   char(1), -- Q050488
 Q7   char(1), -- Q050489
 Q8   char(1), -- Q050490
 Q9   char(1), -- Q050491
 Q10  char(1), -- Q050492
 Q11  char(1), -- Q050493
 Q12  char(1), -- Q050494
 Q13  char(1), -- Q050495
 Q14  char(1), -- Q050496
 Q15  char(1), -- Q050497
 Q16  char(1), -- Q050498
 Q17  char(1), -- Q050499
 Q18  char(1), -- Q050500
 Q19  char(1), -- Q050501
 Q20  char(1), -- Q050502
 Q21  char(1), -- Q050503
 Q22  char(1), -- Q050504
 Q23  char(1), -- Q050505
 Q24  char(1), -- Q050506
 Q25  char(1), -- Q050507
 Q26  char(1), -- Q050508
 Q27  char(1), -- Q050509
 Q28  char(1), -- Q050510
 Q29  char(1), -- Q050511
 Q30  char(2), -- Q050512
 Q31  char(1), -- Q050513
 Q32  char(1), -- Q050514
 Q33  char(1), -- Q050515
 Q34  char(1), -- Q050516
 Q35  char(1), -- Q050517
 Q36  char(1), -- Q050518
 Q37  char(1), -- Q050519
 Q38  char(1), -- Q050520
 Q39  char(1), -- Q050521
 Q40  char(1), -- Q050522
 Q41  char(1), -- Q050523
 Q42  char(1), -- Q050524
 Q43  char(1), -- Q050525
 Q44  char(1), -- Q050526
 Q45  char(1), -- Q050527
 Q46  char(2), -- Q050528
 Q47  char(1), -- Q050529
 Q48  char(1), -- Q050530
 Q49a char(1), -- Q050531a/Q052325a
 Q49b char(1), -- Q050531b/Q052325b
 Q49c char(1), -- Q050531c/Q052325c
 Q49d char(1), -- Q050531d/Q052325d
 Q49e char(1), -- Q050531e/Q052325e
 Q49f char(1), -- '0'/Q052325f
 Q50  char(1), -- Q050532
 Q51  char(1), -- Q050533
 Q52  char(1), -- Q050534
 Q53  char(1), -- Q050535
 Q54  char(1), -- Q050536
 Q55a char(1), -- Q050537a
 Q55b char(1), -- Q050537b
 Q55c char(1), -- Q050537c
 Q55d char(1), -- Q050537d
 Q55e char(1) -- Q050537e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6Monthb')
	drop procedure GetCGCAHPSdata2_sub_Child6Monthb
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Child6Monthb
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=17

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q050483,-9) when -9 then 'M' when -8 then 'H' else cast(Q050483%10000 as varchar) end,
 Q2   = case isnull(Q050484,-9) when -9 then 'M' when -8 then 'H' else cast(Q050484%10000 as varchar) end,
 Q3   = case isnull(Q050485,-9) when -9 then 'M' when -8 then 'H' else cast(Q050485%10000 as varchar) end,
 Q4   = case isnull(Q050486,-9) when -9 then 'M' when -8 then 'H' else cast(Q050486%10000 as varchar) end,
 Q5   = case isnull(Q050487,-9) when -9 then 'M' when -8 then 'H' else cast(Q050487%10000 as varchar) end,
 Q6   = case isnull(Q050488,-9) when -9 then 'M' when -8 then 'H' else cast(Q050488%10000 as varchar) end,
 Q7   = case isnull(Q050489,-9) when -9 then 'M' when -8 then 'H' else cast(Q050489%10000 as varchar) end,
 Q8   = case isnull(Q050490,-9) when -9 then 'M' when -8 then 'H' else cast(Q050490%10000 as varchar) end,
 Q9   = case isnull(Q050491,-9) when -9 then 'M' when -8 then 'H' else cast(Q050491%10000 as varchar) end,
 Q10  = case isnull(Q050492,-9) when -9 then 'M' when -8 then 'H' else cast(Q050492%10000 as varchar) end,
 Q11  = case isnull(Q050493,-9) when -9 then 'M' when -8 then 'H' else cast(Q050493%10000 as varchar) end,
 Q12  = case isnull(Q050494,-9) when -9 then 'M' when -8 then 'H' else cast(Q050494%10000 as varchar) end,
 Q13  = case isnull(Q050495,-9) when -9 then 'M' when -8 then 'H' else cast(Q050495%10000 as varchar) end,
 Q14  = case isnull(Q050496,-9) when -9 then 'M' when -8 then 'H' else cast(Q050496%10000 as varchar) end,
 Q15  = case isnull(Q050497,-9) when -9 then 'M' when -8 then 'H' else cast(Q050497%10000 as varchar) end,
 Q16  = case isnull(Q050498,-9) when -9 then 'M' when -8 then 'H' else cast(Q050498%10000 as varchar) end,
 Q17  = case isnull(Q050499,-9) when -9 then 'M' when -8 then 'H' else cast(Q050499%10000 as varchar) end,
 Q18  = case isnull(Q050500,-9) when -9 then 'M' when -8 then 'H' else cast(Q050500%10000 as varchar) end,
 Q19  = case isnull(Q050501,-9) when -9 then 'M' when -8 then 'H' else cast(Q050501%10000 as varchar) end,
 Q20  = case isnull(Q050502,-9) when -9 then 'M' when -8 then 'H' else cast(Q050502%10000 as varchar) end,
 Q21  = case isnull(Q050503,-9) when -9 then 'M' when -8 then 'H' else cast(Q050503%10000 as varchar) end,
 Q22  = case isnull(Q050504,-9) when -9 then 'M' when -8 then 'H' else cast(Q050504%10000 as varchar) end,
 Q23  = case isnull(Q050505,-9) when -9 then 'M' when -8 then 'H' else cast(Q050505%10000 as varchar) end,
 Q24  = case isnull(Q050506,-9) when -9 then 'M' when -8 then 'H' else cast(Q050506%10000 as varchar) end,
 Q25  = case isnull(Q050507,-9) when -9 then 'M' when -8 then 'H' else cast(Q050507%10000 as varchar) end,
 Q26  = case isnull(Q050508,-9) when -9 then 'M' when -8 then 'H' else cast(Q050508%10000 as varchar) end,
 Q27  = case isnull(Q050509,-9) when -9 then 'M' when -8 then 'H' else cast(Q050509%10000 as varchar) end,
 Q28  = case isnull(Q050510,-9) when -9 then 'M' when -8 then 'H' else cast(Q050510%10000 as varchar) end,
 Q29  = case isnull(Q050511,-9) when -9 then 'M' when -8 then 'H' else cast(Q050511%10000 as varchar) end,
 Q30  = case isnull(Q050512,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050512%10000 as varchar),2) end,
 Q31  = case isnull(Q050513,-9) when -9 then 'M' when -8 then 'H' else cast(Q050513%10000 as varchar) end,
 Q32  = case isnull(Q050514,-9) when -9 then 'M' when -8 then 'H' else cast(Q050514%10000 as varchar) end,
 Q33  = case isnull(Q050515,-9) when -9 then 'M' when -8 then 'H' else cast(Q050515%10000 as varchar) end,
 Q34  = case isnull(Q050516,-9) when -9 then 'M' when -8 then 'H' else cast(Q050516%10000 as varchar) end,
 Q35  = case isnull(Q050517,-9) when -9 then 'M' when -8 then 'H' else cast(Q050517%10000 as varchar) end,
 Q36  = case isnull(Q050518,-9) when -9 then 'M' when -8 then 'H' else cast(Q050518%10000 as varchar) end,
 Q37  = case isnull(Q050519,-9) when -9 then 'M' when -8 then 'H' else cast(Q050519%10000 as varchar) end,
 Q38  = case isnull(Q050520,-9) when -9 then 'M' when -8 then 'H' else cast(Q050520%10000 as varchar) end,
 Q39  = case isnull(Q050521,-9) when -9 then 'M' when -8 then 'H' else cast(Q050521%10000 as varchar) end,
 Q40  = case isnull(Q050522,-9) when -9 then 'M' when -8 then 'H' else cast(Q050522%10000 as varchar) end,
 Q41  = case isnull(Q050523,-9) when -9 then 'M' when -8 then 'H' else cast(Q050523%10000 as varchar) end,
 Q42  = case isnull(Q050524,-9) when -9 then 'M' when -8 then 'H' else cast(Q050524%10000 as varchar) end,
 Q43  = case isnull(Q050525,-9) when -9 then 'M' when -8 then 'H' else cast(Q050525%10000 as varchar) end,
 Q44  = case isnull(Q050526,-9) when -9 then 'M' when -8 then 'H' else cast(Q050526%10000 as varchar) end,
 Q45  = case isnull(Q050527,-9) when -9 then 'M' when -8 then 'H' else cast(Q050527%10000 as varchar) end,
 -- Q46 (50528) is "What is your child's age?" (1) less than 1 year old (2) ____ years old (write in)
 -- the hand-entry is mapped to the HECGPedsAge metafield
 -- case  Q050528  HECGPedsAge    Result               comment
 -- a     -9       (numeric)      (HECGPedsAge value)  respondent didn't fill out either bubble, but they filled out the hand-entry
 -- a     -9       (non-numeric)  99 (missing)
 -- b     -8       (numeric)      88 (multi-mark)
 -- b     -8       (non-numeric)  88 (multi-mark)
 -- c     1        (numeric)      88 (multi-mark)      respondent marked the "less than 1" bubble and still filled out the hand-entry
 -- c     1        (non-numeric)  0
 -- d     2        (NULL)         99 (missing)         respondent marked the "___ years old" bubble, but didn't fill out the hand-entry
 -- e     2        (non-numeric)  99 (missing)         respondent marked the "___ years old" bubble, but filled in the hand-entry with a non-number
 -- f     2        (numeric)      (HECGPedsAge value)
 Q46  = case
     -- case a:
     when isnull(Q050528,-9) = -9 then case when isnumeric(bt.HECGPedsAge)=1 and bt.HECGPedsAge not like '%,%' and floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2)) else 'M ' end
     -- case b:
     when isnull(Q050528,-9) = -8 then 'H ' 
     -- case c:
     when Q050528%10000 = 1 then case when isnumeric(bt.HECGPedsAge)=1 then 'H ' else '0 ' end
     -- case d:
     when bt.HECGPedsAge is null then 'M '
     -- case e:
     when isnumeric(bt.HECGPedsAge)=0 or bt.HECGPedsAge like '%,%' then 'M '
     -- case f:
     when floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2))
     else 'M '
     --case f was: else cast(floor(bt.HECGPedsAge) as varchar(2))
    end,
 Q47  = case isnull(Q050529,-9) when -9 then 'M' when -8 then 'H' else cast(Q050529%10000 as varchar) end,
 Q48  = case isnull(Q050530,-9) when -9 then 'M' when -8 then 'H' else cast(Q050530%10000 as varchar) end,
 Q50  = case isnull(Q050532,-9) when -9 then 'M' when -8 then 'H' else cast(Q050532%10000 as varchar) end,
 Q51  = case isnull(Q050533,-9) when -9 then 'M' when -8 then 'H' else cast(Q050533%10000 as varchar) end,
 Q52  = case isnull(Q050534,-9) when -9 then 'M' when -8 then 'H' else cast(Q050534%10000 as varchar) end,
 Q53  = case isnull(Q050535,-9) when -9 then 'M' when -8 then 'H' else cast(Q050535%10000 as varchar) end,
 Q54  = case isnull(Q050536,-9) when -9 then 'M' when -8 then 'H' else cast(Q050536%10000 as varchar) end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 46325, 46328, 46329 and 46330 for Q61, Q64, Q65 and Q66.
-- others use cores 48856, 48666, 48667 and 48668.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @SQL nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (50531))
 set @SQL = N'
 update r set
  Q49a = case isnull(q050531a,-9) when -9 then 0 else 1 end,
  Q49b = case isnull(q050531b,-9) when -9 then 0 else 1 end,
  Q49c = case isnull(q050531c,-9) when -9 then 0 else 1 end,
  Q49d = case isnull(q050531d,-9) when -9 then 0 else 1 end,
  Q49e = case isnull(q050531e,-9) when -9 then 0 else 1 end,
  Q49f = 0,'
else
 set @SQL = N'
 update r set
  Q49a = case isnull(q052325a,-9) when -9 then 0 else 1 end,
  Q49b = case isnull(q052325b,-9) when -9 then 0 else 1 end,
  Q49c = case isnull(q052325c,-9) when -9 then 0 else 1 end,
  Q49d = case isnull(q052325d,-9) when -9 then 0 else 1 end,
  Q49e = case isnull(q052325e,-9) when -9 then 0 else 1 end,
  Q49f = case isnull(q052325f,-9) when -9 then 0 else 1 end,'


--At the time of this writing, many surveys don't yet contain question 50537.
--  So check for its existence.
if exists (select name as col_nm
   from tempdb.sys.columns
   where object_id = object_id('tempdb..#Study_Results') and name like '%50537%')
 set @SQL = @sql + N'
  Q55a = case isnull(q050537a,-9) when -9 then 0 else 1 end,
  Q55b = case isnull(q050537b,-9) when -9 then 0 else 1 end,
  Q55c = case isnull(q050537c,-9) when -9 then 0 else 1 end,
  Q55d = case isnull(q050537d,-9) when -9 then 0 else 1 end,
  Q55e = case isnull(q050537e,-9) when -9 then 0 else 1 end '
else
 set @SQL = @sql + N'
  Q55a = 0,
  Q55b = 0,
  Q55c = 0,
  Q55d = 0,
  Q55e = 0'



set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
  inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Child 12-month w/ PCMH:
-- Q1 = core 46265
-- If Q1 = 2 (“No”) Questions 2-54 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-54 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.

-- If Q65 = 2 (“No”) Skip to end of the survey
-- Questions 66a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q65).
 -- If they answered Q65 “No”, invoking the skip, then mark the question appropriately skipped.
 --update #results set Q66a='S',Q66b='S',Q66c='S',Q66d='S',Q66e='S' where Q65 = '2' and Q66a+Q66b+Q66c+Q66d+Q66e='00000'

update #results set
 Q1   = ' ',
 Q2   = ' ',
 Q3   = ' ',
 Q4   = ' ',
 Q5   = ' ',
 Q6   = ' ',
 Q7   = ' ',
 Q8   = ' ',
 Q9   = ' ',
 Q10  = ' ',
 Q11  = ' ',
 Q12  = ' ',
 Q13  = ' ',
 Q14  = ' ',
 Q15  = ' ',
 Q16  = ' ',
 Q17  = ' ',
 Q18  = ' ',
 Q19  = ' ',
 Q20  = ' ',
 Q21  = ' ',
 Q22  = ' ',
 Q23  = ' ',
 Q24  = ' ',
 Q25  = ' ',
 Q26  = ' ',
 Q27  = ' ',
 Q28  = ' ',
 Q29  = ' ',
 Q30  = ' ',
 Q31  = ' ',
 Q32  = ' ',
 Q33  = ' ',
 Q34  = ' ',
 Q35  = ' ',
 Q36  = ' ',
 Q37  = ' ',
 Q38  = ' ',
 Q39  = ' ',
 Q40  = ' ',
 Q41  = ' ',
 Q42  = ' ',
 Q43  = ' ',
 Q44  = ' ',
 Q45  = ' ',
 Q46  = ' ',
 Q47  = ' ',
 Q48  = ' ',
 Q49a = ' ',
 Q49b = ' ',
 Q49c = ' ',
 Q49d = ' ',
 Q49e = ' ',
 Q49f = ' ',
 Q50  = ' ',
 Q51  = ' ',
 Q52  = ' ',
 Q53  = ' ',
 Q54  = ' ',
 Q55a = ' ',
 Q55b = ' ',
 Q55c = ' ',
 Q55d = ' ',
 Q55e = ' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6MonthPCMHa')
	drop procedure GetCGCAHPSdata2_sub_Child6MonthPCMHa
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Child6MonthPCMHa
as
alter table #results add
 Q1   char(1), -- Q050483
 Q2   char(1), -- Q050484
 Q3   char(1), -- Q050485
 Q4   char(1), -- Q050486
 Q5   char(1), -- Q050487
 Q6   char(1), -- Q050488
 Q7   char(1), -- Q050489
 Q8   char(1), -- Q050490
 Q9   char(1), -- Q050491
 Q10  char(1), -- Q050492
 Q11  char(1), -- Q050493
 Q12  char(1), -- Q050494
 Q13  char(1), -- Q050495
 Q14  char(1), -- Q050629
 Q15  char(1), -- Q050496
 Q16  char(1), -- Q050497
 Q17  char(1), -- Q050630
 Q18  char(1), -- Q050631
 Q19  char(1), -- Q050632
 Q20  char(1), -- Q050498
 Q21  char(1), -- Q050499
 Q22  char(1), -- Q050500
 Q23  char(1), -- Q050501
 Q24  char(1), -- Q050633
 Q25  char(1), -- Q050502
 Q26  char(1), -- Q050503
 Q27  char(1), -- Q050504
 Q28  char(1), -- Q050505
 Q29  char(1), -- Q050506
 Q30  char(1), -- Q050507
 Q31  char(1), -- Q050508
 Q32  char(1), -- Q050509
 Q33  char(1), -- Q050510
 Q34  char(1), -- Q050511
 Q35  char(2), -- Q050512
 Q36  char(1), -- Q050634
 Q37  char(1), -- Q050635
 Q38  char(1), -- Q050513
 Q39  char(1), -- Q050514
 Q40  char(1), -- Q050515
 Q41  char(1), -- Q050516
 Q42  char(1), -- Q050517
 Q43  char(1), -- Q050518
 Q44  char(1), -- Q050519
 Q45  char(1), -- Q050520
 Q46  char(1), -- Q050521
 Q47  char(1), -- Q050522
 Q48  char(1), -- Q050523
 Q49  char(1), -- Q050636
 Q50  char(1), -- Q050637
 Q51  char(1), -- Q050638
 Q52  char(1), -- Q050639
 Q53  char(1), -- Q050524
 Q54  char(1), -- Q050525
 Q55  char(1), -- Q050526
 Q56  char(1), -- Q050527
 Q57  char(2), -- Q050528
 Q58  char(1), -- Q050529
 Q59  char(1), -- Q050530
 Q60a char(1), -- Q050531a/Q052325a
 Q60b char(1), -- Q050531b/Q052325b
 Q60c char(1), -- Q050531c/Q052325c
 Q60d char(1), -- Q050531d/Q052325d
 Q60e char(1), -- Q050531e/Q052325e
 Q60f char(1), -- '0'/Q052325f
 Q61  char(1), -- Q050532
 Q62  char(1), -- Q050533
 Q63  char(1), -- Q050534
 Q64  char(1), -- Q050535
 Q65  char(1), -- Q050536
 Q66a char(1), -- Q050537a
 Q66b char(1), -- Q050537b
 Q66c char(1), -- Q050537c
 Q66d char(1), -- Q050537d
 Q66e char(1)  -- Q050537e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6MonthPCMHb')
	drop procedure GetCGCAHPSdata2_sub_Child6MonthPCMHb
go
--DRM 03/04/2015 Created.
create procedure dbo.GetCGCAHPSdata2_sub_Child6MonthPCMHb
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=18

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q050483,-9) when -9 then 'M' when -8 then 'H' else cast(Q050483%10000 as varchar) end,
 Q2   = case isnull(Q050484,-9) when -9 then 'M' when -8 then 'H' else cast(Q050484%10000 as varchar) end,
 Q3   = case isnull(Q050485,-9) when -9 then 'M' when -8 then 'H' else cast(Q050485%10000 as varchar) end,
 Q4   = case isnull(Q050486,-9) when -9 then 'M' when -8 then 'H' else cast(Q050486%10000 as varchar) end,
 Q5   = case isnull(Q050487,-9) when -9 then 'M' when -8 then 'H' else cast(Q050487%10000 as varchar) end,
 Q6   = case isnull(Q050488,-9) when -9 then 'M' when -8 then 'H' else cast(Q050488%10000 as varchar) end,
 Q7   = case isnull(Q050489,-9) when -9 then 'M' when -8 then 'H' else cast(Q050489%10000 as varchar) end,
 Q8   = case isnull(Q050490,-9) when -9 then 'M' when -8 then 'H' else cast(Q050490%10000 as varchar) end,
 Q9   = case isnull(Q050491,-9) when -9 then 'M' when -8 then 'H' else cast(Q050491%10000 as varchar) end,
 Q10  = case isnull(Q050492,-9) when -9 then 'M' when -8 then 'H' else cast(Q050492%10000 as varchar) end,
 Q11  = case isnull(Q050493,-9) when -9 then 'M' when -8 then 'H' else cast(Q050493%10000 as varchar) end,
 Q12  = case isnull(Q050494,-9) when -9 then 'M' when -8 then 'H' else cast(Q050494%10000 as varchar) end,
 Q13  = case isnull(Q050495,-9) when -9 then 'M' when -8 then 'H' else cast(Q050495%10000 as varchar) end,
 Q14  = case isnull(Q050629,-9) when -9 then 'M' when -8 then 'H' else cast(Q050629%10000 as varchar) end,
 Q15  = case isnull(Q050496,-9) when -9 then 'M' when -8 then 'H' else cast(Q050496%10000 as varchar) end,
 Q16  = case isnull(Q050497,-9) when -9 then 'M' when -8 then 'H' else cast(Q050497%10000 as varchar) end,
 Q17  = case isnull(Q050630,-9) when -9 then 'M' when -8 then 'H' else cast(Q050630%10000 as varchar) end,
 Q18  = case isnull(Q050631,-9) when -9 then 'M' when -8 then 'H' else cast(Q050631%10000 as varchar) end,
 Q19  = case isnull(Q050632,-9) when -9 then 'M' when -8 then 'H' else cast(Q050632%10000 as varchar) end,
 Q20  = case isnull(Q050498,-9) when -9 then 'M' when -8 then 'H' else cast(Q050498%10000 as varchar) end,
 Q21  = case isnull(Q050499,-9) when -9 then 'M' when -8 then 'H' else cast(Q050499%10000 as varchar) end,
 Q22  = case isnull(Q050500,-9) when -9 then 'M' when -8 then 'H' else cast(Q050500%10000 as varchar) end,
 Q23  = case isnull(Q050501,-9) when -9 then 'M' when -8 then 'H' else cast(Q050501%10000 as varchar) end,
 Q24  = case isnull(Q050633,-9) when -9 then 'M' when -8 then 'H' else cast(Q050633%10000 as varchar) end,
 Q25  = case isnull(Q050502,-9) when -9 then 'M' when -8 then 'H' else cast(Q050502%10000 as varchar) end,
 Q26  = case isnull(Q050503,-9) when -9 then 'M' when -8 then 'H' else cast(Q050503%10000 as varchar) end,
 Q27  = case isnull(Q050504,-9) when -9 then 'M' when -8 then 'H' else cast(Q050504%10000 as varchar) end,
 Q28  = case isnull(Q050505,-9) when -9 then 'M' when -8 then 'H' else cast(Q050505%10000 as varchar) end,
 Q29  = case isnull(Q050506,-9) when -9 then 'M' when -8 then 'H' else cast(Q050506%10000 as varchar) end,
 Q30  = case isnull(Q050507,-9) when -9 then 'M' when -8 then 'H' else cast(Q050507%10000 as varchar) end,
 Q31  = case isnull(Q050508,-9) when -9 then 'M' when -8 then 'H' else cast(Q050508%10000 as varchar) end,
 Q32  = case isnull(Q050509,-9) when -9 then 'M' when -8 then 'H' else cast(Q050509%10000 as varchar) end,
 Q33  = case isnull(Q050510,-9) when -9 then 'M' when -8 then 'H' else cast(Q050510%10000 as varchar) end,
 Q34  = case isnull(Q050511,-9) when -9 then 'M' when -8 then 'H' else cast(Q050511%10000 as varchar) end,
 Q35  = case isnull(Q050512,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050512%10000 as varchar),2) end,
 Q36  = case isnull(Q050634,-9) when -9 then 'M' when -8 then 'H' else cast(Q050634%10000 as varchar) end,
 Q37  = case isnull(Q050635,-9) when -9 then 'M' when -8 then 'H' else cast(Q050635%10000 as varchar) end,
 Q38  = case isnull(Q050513,-9) when -9 then 'M' when -8 then 'H' else cast(Q050513%10000 as varchar) end,
 Q39  = case isnull(Q050514,-9) when -9 then 'M' when -8 then 'H' else cast(Q050514%10000 as varchar) end,
 Q40  = case isnull(Q050515,-9) when -9 then 'M' when -8 then 'H' else cast(Q050515%10000 as varchar) end,
 Q41  = case isnull(Q050516,-9) when -9 then 'M' when -8 then 'H' else cast(Q050516%10000 as varchar) end,
 Q42  = case isnull(Q050517,-9) when -9 then 'M' when -8 then 'H' else cast(Q050517%10000 as varchar) end,
 Q43  = case isnull(Q050518,-9) when -9 then 'M' when -8 then 'H' else cast(Q050518%10000 as varchar) end,
 Q44  = case isnull(Q050519,-9) when -9 then 'M' when -8 then 'H' else cast(Q050519%10000 as varchar) end,
 Q45  = case isnull(Q050520,-9) when -9 then 'M' when -8 then 'H' else cast(Q050520%10000 as varchar) end,
 Q46  = case isnull(Q050521,-9) when -9 then 'M' when -8 then 'H' else cast(Q050521%10000 as varchar) end,
 Q47  = case isnull(Q050522,-9) when -9 then 'M' when -8 then 'H' else cast(Q050522%10000 as varchar) end,
 Q48  = case isnull(Q050523,-9) when -9 then 'M' when -8 then 'H' else cast(Q050523%10000 as varchar) end,
 Q49  = case isnull(Q050636,-9) when -9 then 'M' when -8 then 'H' else cast(Q050636%10000 as varchar) end,
 Q50  = case isnull(Q050637,-9) when -9 then 'M' when -8 then 'H' else cast(Q050637%10000 as varchar) end,
 Q51  = case isnull(Q050638,-9) when -9 then 'M' when -8 then 'H' else cast(Q050638%10000 as varchar) end,
 Q52  = case isnull(Q050639,-9) when -9 then 'M' when -8 then 'H' else cast(Q050639%10000 as varchar) end,
 Q53  = case isnull(Q050524,-9) when -9 then 'M' when -8 then 'H' else cast(Q050524%10000 as varchar) end,
 Q54  = case isnull(Q050525,-9) when -9 then 'M' when -8 then 'H' else cast(Q050525%10000 as varchar) end,
 Q55  = case isnull(Q050526,-9) when -9 then 'M' when -8 then 'H' else cast(Q050526%10000 as varchar) end,
 Q56  = case isnull(Q050527,-9) when -9 then 'M' when -8 then 'H' else cast(Q050527%10000 as varchar) end,
 -- Q57 (50528) is "What is your child's age?" (1) less than 1 year old (2) ____ years old (write in)
 -- the hand-entry is mapped to the HECGPedsAge metafield
 -- case  Q050528  HECGPedsAge    Result               comment
 -- a     -9       (numeric)      (HECGPedsAge value)  respondent didn't fill out either bubble, but they filled out the hand-entry
 -- a     -9       (non-numeric)  99 (missing)
 -- b     -8       (numeric)      88 (multi-mark)
 -- b     -8       (non-numeric)  88 (multi-mark)
 -- c     1        (numeric)      88 (multi-mark)      respondent marked the "less than 1" bubble and still filled out the hand-entry
 -- c     1        (non-numeric)  0
 -- d     2        (NULL)         99 (missing)         respondent marked the "___ years old" bubble, but didn't fill out the hand-entry
 -- e     2        (non-numeric)  99 (missing)         respondent marked the "___ years old" bubble, but filled in the hand-entry with a non-number
 -- f     2        (numeric)      (HECGPedsAge value)
 Q57  = case
     -- case a:
     when isnull(q046321,-9) = -9 then case when isnumeric(bt.HECGPedsAge)=1 and bt.HECGPedsAge not like '%,%' and floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2)) else 'M ' end
     -- case b:
     when isnull(q046321,-9) = -8 then 'H ' 
     -- case c:
     when q046321%10000 = 1 then case when isnumeric(bt.HECGPedsAge)=1 then 'H ' else '0 ' end
     -- case d:
     when bt.HECGPedsAge is null then 'M '
     -- case e:
     when isnumeric(bt.HECGPedsAge)=0 or bt.HECGPedsAge like '%,%' then 'M '
     -- case f:
     when floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2))
     else 'M '
     --case f was: else cast(floor(bt.HECGPedsAge) as varchar(2))
    end,
 Q58  = case isnull(Q050529,-9) when -9 then 'M' when -8 then 'H' else cast(Q050529%10000 as varchar) end,
 Q59  = case isnull(Q050530,-9) when -9 then 'M' when -8 then 'H' else cast(Q050530%10000 as varchar) end,
 Q61  = case isnull(Q050532,-9) when -9 then 'M' when -8 then 'H' else cast(Q050532%10000 as varchar) end,
 Q62  = case isnull(Q050533,-9) when -9 then 'M' when -8 then 'H' else cast(Q050533%10000 as varchar) end,
 Q63  = case isnull(Q050534,-9) when -9 then 'M' when -8 then 'H' else cast(Q050534%10000 as varchar) end,
 Q64  = case isnull(Q050535,-9) when -9 then 'M' when -8 then 'H' else cast(Q050535%10000 as varchar) end,
 Q65  = case isnull(Q050536,-9) when -9 then 'M' when -8 then 'H' else cast(Q050536%10000 as varchar) end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 46325, 46328, 46329 and 46330 for Q61, Q64, Q65 and Q66.
-- others use cores 48856, 48666, 48667 and 48668.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @SQL nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (46325,46328,46329,46330))
 set @SQL = N'
 update r set
  Q60a = case isnull(q050531a,-9) when -9 then 0 else 1 end,
  Q60b = case isnull(q050531b,-9) when -9 then 0 else 1 end,
  Q60c = case isnull(q050531c,-9) when -9 then 0 else 1 end,
  Q60d = case isnull(q050531d,-9) when -9 then 0 else 1 end,
  Q60e = case isnull(q050531e,-9) when -9 then 0 else 1 end,
  Q60f = 0,'
else
 set @SQL = N'
 update r set
  Q60a = case isnull(q052325a,-9) when -9 then 0 else 1 end,
  Q60b = case isnull(q052325b,-9) when -9 then 0 else 1 end,
  Q60c = case isnull(q052325c,-9) when -9 then 0 else 1 end,
  Q60d = case isnull(q052325d,-9) when -9 then 0 else 1 end,
  Q60e = case isnull(q052325e,-9) when -9 then 0 else 1 end,
  Q60f = case isnull(q052325f,-9) when -9 then 0 else 1 end,'


--At the time of this writing, many surveys don't yet contain question 50537.
--  So check for its existence.
if exists (select name as col_nm
   from tempdb.sys.columns
   where object_id = object_id('tempdb..#Study_Results') and name like '%50537%')
 set @SQL = @sql + N'
  Q66a = case isnull(q050537a,-9) when -9 then 0 else 1 end,
  Q66b = case isnull(q050537b,-9) when -9 then 0 else 1 end,
  Q66c = case isnull(q050537c,-9) when -9 then 0 else 1 end,
  Q66d = case isnull(q050537d,-9) when -9 then 0 else 1 end,
  Q66e = case isnull(q050537e,-9) when -9 then 0 else 1 end '
else
 set @SQL = @sql + N'
  Q66a = 0,
  Q66b = 0,
  Q66c = 0,
  Q66d = 0,
  Q66e = 0'


set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
  inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Child 12-month w/ PCMH:
-- Q1 = core 46265
-- If Q1 = 2 (“No”) Questions 2-54 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-54 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
 update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
 update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
 update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='1')
 update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2')
 update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1' or Q10='2')
 update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
 update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
 update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1' or Q15='2')
 update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1' or Q18='2')
 update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1' or Q20='2')
 update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1' or Q22='2')
 update #results set Q24  = 'S'  where Q24  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q25  = 'S'  where Q25  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q28  = 'S'  where Q28  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q29  = 'S'  where Q29  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q30  = 'S'  where Q30  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q31  = 'S'  where Q31  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q32  = 'S'  where Q32  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q33  = 'S'  where Q33  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q34  = 'S'  where Q34  = 'M'  and (Q1='2' or Q4='1' or Q33='2')
 update #results set Q35  = 'S ' where Q35  = 'M ' and (Q1='2' or Q4='1')
 update #results set Q36  = 'S'  where Q36  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q37  = 'S'  where Q37  = 'M'  and (Q1='2' or Q4='1' or Q36='2')
 update #results set Q38  = 'S'  where Q38  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q39  = 'S'  where Q39  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q40  = 'S'  where Q40  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q41  = 'S'  where Q41  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q42  = 'S'  where Q42  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q43  = 'S'  where Q43  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q44  = 'S'  where Q44  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q45  = 'S'  where Q45  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q46  = 'S'  where Q46  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q47  = 'S'  where Q47  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q48  = 'S'  where Q48  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q49  = 'S'  where Q49  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q50  = 'S'  where Q50  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q51  = 'S'  where Q51  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q52  = 'S'  where Q52  = 'M'  and (Q1='2' or Q4='1' or Q51='2')
 update #results set Q53  = 'S'  where Q53  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q54  = 'S'  where Q54  = 'M'  and (Q1='2' or Q4='1')

-- If Q65 = 2 (“No”) Skip to end of the survey
-- Questions 66a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q65).
 -- If they answered Q65 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q66a='S',Q66b='S',Q66c='S',Q66d='S',Q66e='S' where Q65 = '2' and Q66a+Q66b+Q66c+Q66d+Q66e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',
 Q14 =' ',
 Q15 =' ',
 Q16 =' ',
 Q17 =' ',
 Q18 =' ',
 Q19 =' ',
 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',
 Q24 =' ',
 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 =' ',
 Q33 =' ',
 Q34 =' ',
 Q35 ='  ',
 Q36 =' ',
 Q37 =' ',
 Q38 =' ',
 Q39 =' ',
 Q40 =' ',
 Q41 =' ',
 Q42 =' ',
 Q43 =' ',
 Q44 =' ',
 Q45 =' ',
 Q46 =' ',
 Q47 =' ',
 Q48 =' ',
 Q49 =' ',
 Q50 =' ',
 Q51 =' ',
 Q52 =' ',
 Q53 =' ',
 Q54 =' ',
 Q55 =' ',
 Q56 =' ',
 Q57 ='  ',
 Q58 =' ',
 Q59 =' ',
 Q60a=' ',
 Q60b=' ',
 Q60c=' ',
 Q60d=' ',
 Q60e=' ',
 Q60f=' ',
 Q61 =' ',
 Q62 =' ',
 Q63 =' ',
 Q64 =' ',
 Q65 =' ',
 Q66a=' ',
 Q66b=' ',
 Q66c=' ',
 Q66d=' ',
 Q66e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6Month30A')
	drop procedure GetCGCAHPSdata2_sub_Adult6Month30A
go
create procedure dbo.GetCGCAHPSdata2_sub_Adult6Month30A
as
alter table #results add
	Q1	 	char(1), 	-- Q050344
	Q2	 	char(1), 	-- Q050176
	Q3	 	char(1), 	-- Q050177
	Q4	 	char(1), 	-- Q050178
	Q5	 	char(1), 	-- Q050179
	Q6	 	char(1), 	-- Q050180
	Q7	 	char(1), 	-- Q050181
	Q8	 	char(1), 	-- Q050182
	Q9	 	char(1), 	-- Q050183
	Q10	 	char(1), 	-- Q050184
	Q11	 	char(1), 	-- Q050190
	Q12	 	char(1), 	-- Q050191
	Q13	 	char(1), 	-- Q050194
	Q14	 	char(1), 	-- Q050196
	Q15	 	char(1), 	-- Q050197
	Q16	 	char(1), 	-- Q050198
	Q17	 	char(1), 	-- Q050199
	Q18	 	char(2), 	-- Q050215
	Q19	 	char(1), 	-- Q050226
	Q20	 	char(1), 	-- Q053426
	Q21	 	char(1), 	-- Q050216
	Q22	 	char(1), 	-- Q050217
	Q23	 	char(1), 	-- Q050234
	Q24	 	char(1), 	-- Q050235
	Q25	 	char(1), 	-- Q050241
	Q26	 	char(1), 	-- Q050699
	Q27	 	char(1), 	-- Q050243
	Q28	 	char(1), 	-- Q050253
	Q29a	char(1), 	-- Q050255a
	Q29b	char(1), 	-- Q050255b
	Q29c	char(1), 	-- Q050255d through j
	Q32d	char(1), 	-- Q050255k through n
	Q29e	char(1), 	-- Q050255c
	Q29f	char(1), 	-- Other was not included on the scale, so will always be 0.
	Q30		char(1), 	-- Q050256
	Q31a	char(1), 	-- Q050257a
	Q31b	char(1), 	-- Q050257b
	Q31c	char(1), 	-- Q050257c
	Q31d	char(1), 	-- Q050257d
	Q31e	char(1) 	-- Q050257e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Adult6Month30B')
	drop procedure GetCGCAHPSdata2_sub_Adult6Month30B
go
create procedure dbo.GetCGCAHPSdata2_sub_Adult6Month30B
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as

update #results set surveytype=15

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1    = case isnull(Q050344,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050344%10000 as varchar) end,
 Q2    = case isnull(Q050176,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050176%10000 as varchar) end,
 Q3    = case isnull(Q050177,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050177%10000 as varchar) end,
 Q4    = case isnull(Q050178,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050178%10000 as varchar) end,
 Q5    = case isnull(Q050179,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050179%10000 as varchar) end,
 Q6    = case isnull(Q050180,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050180%10000 as varchar) end,
 Q7    = case isnull(Q050181,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050181%10000 as varchar) end,
 Q8    = case isnull(Q050182,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050182%10000 as varchar) end,
 Q9    = case isnull(Q050183,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050183%10000 as varchar) end,
 Q10   = case isnull(Q050184,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050184%10000 as varchar) end,
 Q11   = case isnull(Q050190,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050190%10000 as varchar) end,
 Q12   = case isnull(Q050191,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050191%10000 as varchar) end,
 Q13   = case isnull(Q050194,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050194%10000 as varchar) end,
 Q14   = case isnull(Q050196,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050196%10000 as varchar) end,
 Q15   = case isnull(Q050197,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050197%10000 as varchar) end,
 Q16   = case isnull(Q050198,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050198%10000 as varchar) end,
 Q17   = case isnull(Q050199,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050199%10000 as varchar) end,
 Q18   = case isnull(Q050215,-9)  when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050215%10000 as varchar),2) end,
 Q19   = case isnull(Q050226,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050226%10000 as varchar) end,
 Q20   = case isnull(Q053426,-9)  when -9 then 'M' when -8 then 'H' else cast(Q053426%10000 as varchar) end,
 Q21   = case isnull(Q050216,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050216%10000 as varchar) end,
 Q22   = case isnull(Q050217,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050217%10000 as varchar) end,
 Q23   = case isnull(Q050234,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050234%10000 as varchar) end,
 Q24   = case isnull(Q050235,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050235%10000 as varchar) end,
 Q25   = case isnull(Q050241,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050241%10000 as varchar) end,
 Q26   = case isnull(Q050699,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050699%10000 as varchar) end,
 Q27   = case isnull(Q050243,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050243%10000 as varchar) end,
 Q28   = case isnull(Q050253,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050253%10000 as varchar) end,
 Q29a  = case isnull(Q050255a,-9) when -9 then 'M' when -8 then 'H' else cast(Q050255a%10000 as varchar) end,
 Q29b  = case isnull(Q050255b,-9) when -9 then 'M' when -8 then 'H' else cast(Q050255b%10000 as varchar) end,
 Q29c  = case when (q050255d=1 or q050255e=1 or q050255f=1 or q050255g=1 or q050255h=1 or q050255i=1 or q050255j=1) then 1 else 0 end,
 Q32d  = case when (q050255k=1 or q050255l=1 or q050255m=1 or q050255n=1) then 1 else 0 end,
 Q29e  = case isnull(q050255c,-9) when -9 then 0 else 1 end,
 Q29f  = '0',
 Q30   = case isnull(Q050256,-9)  when -9 then 'M' when -8 then 'H' else cast(Q050256%10000 as varchar) end,
 Q31a  = case isnull(q050257a,-9) when -9 then 0 else 1 end,
 Q31b  = case isnull(q050257b,-9) when -9 then 0 else 1 end,
 Q31c  = case isnull(q050257c,-9) when -9 then 0 else 1 end,
 Q31d  = case isnull(q050257d,-9) when -9 then 0 else 1 end,
 Q31e  = case isnull(q050257e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- Adult 12-month:
-- Q1 = core 46385
-- If Q1 = 2 (“No”) Questions 2-25 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-25 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
update #results set Q2  = 'S'  where Q2  = 'M'  and (Q1='2')
update #results set Q3  = 'S'  where Q3  = 'M'  and (Q1='2')
update #results set Q4  = 'S'  where Q4  = 'M'  and (Q1='2')
update #results set Q5  = 'S'  where Q5  = 'M'  and (Q1='2' or Q4='1')
update #results set Q6  = 'S'  where Q6  = 'M'  and (Q1='2' or Q4='1' or Q5='2')
update #results set Q7  = 'S'  where Q7  = 'M'  and (Q1='2' or Q4='1')
update #results set Q8  = 'S'  where Q8  = 'M'  and (Q1='2' or Q4='1' or Q7='2')
update #results set Q9  = 'S'  where Q9  = 'M'  and (Q1='2' or Q4='1')
update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1' or Q9='2')
update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1')
update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1')
update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1')
update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1')
update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1')
update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1' or Q16='2')
update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1')
update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1' or Q19='2')
update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1')
update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1')

-- If Q33 = 2 (“No”) Skip to end of the survey
-- Questions 34a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q30).
 -- If they answered Q30 “No”, invoking the skip, then mark the question appropriately skipped.
    update #results set Q31a='S',Q31b='S',Q31c='S',Q31d='S',Q31e='S' where Q30  = '2' and Q31a+Q31b+Q31c+Q31d+Q31e='00000'

update #results set
	Q1	 = ' ',
	Q2	 = ' ',
	Q3	 = ' ',
	Q4	 = ' ',
	Q5	 = ' ',
	Q6	 = ' ',
	Q7	 = ' ',
	Q8	 = ' ',
	Q9	 = ' ',
	Q10	 = ' ',
	Q11	 = ' ',
	Q12	 = ' ',
	Q13	 = ' ',
	Q14	 = ' ',
	Q15	 = ' ',
	Q16	 = ' ',
	Q17	 = ' ',
	Q18	 = '  ',
	Q19	 = ' ',
	Q20	 = ' ',
	Q21	 = ' ',
	Q22	 = ' ',
	Q23	 = ' ',
	Q24	 = ' ',
	Q25	 = ' ',
	Q26	 = ' ',
	Q27	 = ' ',
	Q28	 = ' ',
	Q29a= ' ',
	Q29b= ' ',
	Q29c= ' ',
	Q32d= ' ',
	Q29e= ' ',
	Q29f= ' ',
	Q30	= ' ',
	Q31a= ' ',
	Q31b= ' ',
	Q31c= ' ',
	Q31d= ' ',
	Q31e= ' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6Month30a')
	drop procedure GetCGCAHPSdata2_sub_Child6Month30a
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child6Month30b')
	drop procedure GetCGCAHPSdata2_sub_Child6Month30b
go
create procedure dbo.GetCGCAHPSdata2_sub_Child6Month30a
as
alter table #results add
	Q1		char(1), 	-- Q050483
	Q2		char(1), 	-- Q050484
	Q3		char(1), 	-- Q050485
	Q4		char(1), 	-- Q050486
	Q5		char(1), 	-- Q050487
	Q6		char(1), 	-- Q050488
	Q7		char(1), 	-- Q050489
	Q8		char(1), 	-- Q050490
	Q9		char(1), 	-- Q050491
	Q10		char(1), 	-- Q050492
	Q11		char(1), 	-- Q050493
	Q12		char(1), 	-- Q050494
	Q13		char(1), 	-- Q050495
	Q14		char(1), 	-- Q050496
	Q15		char(1), 	-- Q050497
	Q16		char(1), 	-- Q050498
	Q17		char(1), 	-- Q050499
	Q18		char(1), 	-- Q050503
	Q19		char(1), 	-- Q050504
	Q20		char(1), 	-- Q050507
	Q21		char(1), 	-- Q050508
	Q22		char(1), 	-- Q050509
	Q23		char(1), 	-- Q050510
	Q24		char(1), 	-- Q050511
	Q25		char(2), 	-- Q050512
	Q26		char(1), 	-- Q050524
	Q27		char(1), 	-- Q050525
	Q28		char(1), 	-- Q050526
	Q29		char(1), 	-- Q050527
	Q30		char(2), 	-- Q050528
	Q31		char(1), 	-- Q050529
	Q32		char(1), 	-- Q050530
	Q33a	char(1), 	-- Q050531a / Q052325a
	Q33b	char(1), 	-- Q050531b / Q052325b
	Q33c	char(1), 	-- Q050531c / Q052325c
	Q33d	char(1), 	-- Q050531d / Q052325d
	Q33e	char(1), 	-- Q050531e / Q052325e
	Q33f	char(1), 	-- '0' / Q052325f
	Q34		char(1), 	-- Q050532
	Q35		char(1), 	-- Q050533
	Q36		char(1), 	-- Q050534
	Q37		char(1), 	-- Q050535
	Q38		char(1), 	-- Q050536
	Q39a	char(1), 	-- Q050537a
	Q39b	char(1), 	-- Q050537b
	Q39c	char(1), 	-- Q050537c
	Q39d	char(1), 	-- Q050537d
	Q39e	char(1) 	-- Q050537e
go
create procedure dbo.GetCGCAHPSdata2_sub_Child6Month30b
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=17

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(Q050483,-9) when -9 then 'M' when -8 then 'H' else cast(Q050483%10000 as varchar) end,
 Q2   = case isnull(Q050484,-9) when -9 then 'M' when -8 then 'H' else cast(Q050484%10000 as varchar) end,
 Q3   = case isnull(Q050485,-9) when -9 then 'M' when -8 then 'H' else cast(Q050485%10000 as varchar) end,
 Q4   = case isnull(Q050486,-9) when -9 then 'M' when -8 then 'H' else cast(Q050486%10000 as varchar) end,
 Q5   = case isnull(Q050487,-9) when -9 then 'M' when -8 then 'H' else cast(Q050487%10000 as varchar) end,
 Q6   = case isnull(Q050488,-9) when -9 then 'M' when -8 then 'H' else cast(Q050488%10000 as varchar) end,
 Q7   = case isnull(Q050489,-9) when -9 then 'M' when -8 then 'H' else cast(Q050489%10000 as varchar) end,
 Q8   = case isnull(Q050490,-9) when -9 then 'M' when -8 then 'H' else cast(Q050490%10000 as varchar) end,
 Q9   = case isnull(Q050491,-9) when -9 then 'M' when -8 then 'H' else cast(Q050491%10000 as varchar) end,
 Q10  = case isnull(Q050492,-9) when -9 then 'M' when -8 then 'H' else cast(Q050492%10000 as varchar) end,
 Q11  = case isnull(Q050493,-9) when -9 then 'M' when -8 then 'H' else cast(Q050493%10000 as varchar) end,
 Q12  = case isnull(Q050494,-9) when -9 then 'M' when -8 then 'H' else cast(Q050494%10000 as varchar) end,
 Q13  = case isnull(Q050495,-9) when -9 then 'M' when -8 then 'H' else cast(Q050495%10000 as varchar) end,
 Q14  = case isnull(Q050496,-9) when -9 then 'M' when -8 then 'H' else cast(Q050496%10000 as varchar) end,
 Q15  = case isnull(Q050497,-9) when -9 then 'M' when -8 then 'H' else cast(Q050497%10000 as varchar) end,
 Q16  = case isnull(Q050498,-9) when -9 then 'M' when -8 then 'H' else cast(Q050498%10000 as varchar) end,
 Q17  = case isnull(Q050499,-9) when -9 then 'M' when -8 then 'H' else cast(Q050499%10000 as varchar) end,
 Q18  = case isnull(Q050503,-9) when -9 then 'M' when -8 then 'H' else cast(Q050503%10000 as varchar) end,
 Q19  = case isnull(Q050504,-9) when -9 then 'M' when -8 then 'H' else cast(Q050504%10000 as varchar) end,
 Q20  = case isnull(Q050507,-9) when -9 then 'M' when -8 then 'H' else cast(Q050507%10000 as varchar) end,
 Q21  = case isnull(Q050508,-9) when -9 then 'M' when -8 then 'H' else cast(Q050508%10000 as varchar) end,
 Q22  = case isnull(Q050509,-9) when -9 then 'M' when -8 then 'H' else cast(Q050509%10000 as varchar) end,
 Q23  = case isnull(Q050510,-9) when -9 then 'M' when -8 then 'H' else cast(Q050510%10000 as varchar) end,
 Q24  = case isnull(Q050511,-9) when -9 then 'M' when -8 then 'H' else cast(Q050511%10000 as varchar) end,
 Q25  = case isnull(Q050512,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(Q050512%10000 as varchar),2) end,
 Q26  = case isnull(Q050524,-9) when -9 then 'M' when -8 then 'H' else cast(Q050524%10000 as varchar) end,
 Q27  = case isnull(Q050525,-9) when -9 then 'M' when -8 then 'H' else cast(Q050525%10000 as varchar) end,
 Q28  = case isnull(Q050526,-9) when -9 then 'M' when -8 then 'H' else cast(Q050526%10000 as varchar) end,
 Q29  = case isnull(Q050527,-9) when -9 then 'M' when -8 then 'H' else cast(Q050527%10000 as varchar) end,
 -- Q30 (50528) is "What is your child's age?" (1) less than 1 year old (2) ____ years old (write in)
 -- the hand-entry is mapped to the HECGPedsAge metafield
 -- case  Q050528  HECGPedsAge    Result               comment
 -- a     -9       (numeric)      (HECGPedsAge value)  respondent didn't fill out either bubble, but they filled out the hand-entry
 -- a     -9       (non-numeric)  99 (missing)
 -- b     -8       (numeric)      88 (multi-mark)
 -- b     -8       (non-numeric)  88 (multi-mark)
 -- c     1        (numeric)      88 (multi-mark)      respondent marked the "less than 1" bubble and still filled out the hand-entry
 -- c     1        (non-numeric)  0
 -- d     2        (NULL)         99 (missing)         respondent marked the "___ years old" bubble, but didn't fill out the hand-entry
 -- e     2        (non-numeric)  99 (missing)         respondent marked the "___ years old" bubble, but filled in the hand-entry with a non-number
 -- f     2        (numeric)      (HECGPedsAge value)
 Q30  = case
     -- case a:
     when isnull(Q050528,-9) = -9 then case when isnumeric(bt.HECGPedsAge)=1 and bt.HECGPedsAge not like '%,%' and floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2)) else 'M ' end
     -- case b:
     when isnull(Q050528,-9) = -8 then 'H ' 
     -- case c:
     when Q050528%10000 = 1 then case when isnumeric(bt.HECGPedsAge)=1 then 'H ' else '0 ' end
     -- case d:
     when bt.HECGPedsAge is null then 'M '
     -- case e:
     when isnumeric(bt.HECGPedsAge)=0 or bt.HECGPedsAge like '%,%' then 'M '
     -- case f:
     when floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2))
     else 'M '
     --case f was: else cast(floor(bt.HECGPedsAge) as varchar(2))
    end,
 Q31  = case isnull(Q050529,-9) when -9 then 'M' when -8 then 'H' else cast(Q050529%10000 as varchar) end,
 Q32  = case isnull(Q050530,-9) when -9 then 'M' when -8 then 'H' else cast(Q050530%10000 as varchar) end,
 Q34  = case isnull(Q050532,-9) when -9 then 'M' when -8 then 'H' else cast(Q050532%10000 as varchar) end,
 Q35  = case isnull(Q050533,-9) when -9 then 'M' when -8 then 'H' else cast(Q050533%10000 as varchar) end,
 Q36  = case isnull(Q050534,-9) when -9 then 'M' when -8 then 'H' else cast(Q050534%10000 as varchar) end,
 Q37  = case isnull(Q050535,-9) when -9 then 'M' when -8 then 'H' else cast(Q050535%10000 as varchar) end,
 Q38  = case isnull(Q050536,-9) when -9 then 'M' when -8 then 'H' else cast(Q050536%10000 as varchar) end,
 Q39a  = case isnull(Q050537a,-9) when -9 then 0 else 1 end,
 Q39b  = case isnull(Q050537b,-9) when -9 then 0 else 1 end,
 Q39c  = case isnull(Q050537c,-9) when -9 then 0 else 1 end,
 Q39d  = case isnull(Q050537d,-9) when -9 then 0 else 1 end,
 Q39e  = case isnull(Q050537e,-9) when -9 then 0 else 1 end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id





-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 46325, 46328, 46329 and 46330 for Q61, Q64, Q65 and Q66.
-- others use cores 48856, 48666, 48667 and 48668.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @SQL nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (50531))
 set @SQL = N'
 update r set
  Q33a = case isnull(q050531a,-9) when -9 then 0 else 1 end,
  Q33b = case isnull(q050531b,-9) when -9 then 0 else 1 end,
  Q33c = case isnull(q050531c,-9) when -9 then 0 else 1 end,
  Q33d = case isnull(q050531d,-9) when -9 then 0 else 1 end,
  Q33e = case isnull(q050531e,-9) when -9 then 0 else 1 end,
  Q33f = 0,'
else
 set @SQL = N'
 update r set
  Q33a = case isnull(q052325a,-9) when -9 then 0 else 1 end,
  Q33b = case isnull(q052325b,-9) when -9 then 0 else 1 end,
  Q33c = case isnull(q052325c,-9) when -9 then 0 else 1 end,
  Q33d = case isnull(q052325d,-9) when -9 then 0 else 1 end,
  Q33e = case isnull(q052325e,-9) when -9 then 0 else 1 end,
  Q33f = case isnull(q052325f,-9) when -9 then 0 else 1 end,'

set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
  inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Child 12-month w/ PCMH:
-- Q1 = core 46265
-- If Q1 = 2 (“No”) Questions 2-54 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-54 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='1')
update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q6 in ('1','2'))
update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1' or Q6 in ('1','2') or Q7='2')
update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q6 in ('1','2') or Q7='2')
update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1' or Q10='2')
update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1')
update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
update #results set Q14  = 'S'  where Q14  = 'M'  and (Q1='2' or Q4='1')
update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1' or Q14='2')
update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1')
update #results set Q17  = 'S'  where Q17  = 'M'  and (Q1='2' or Q4='1' or Q16='2')
update #results set Q18  = 'S'  where Q18  = 'M'  and (Q1='2' or Q4='1')
update #results set Q19  = 'S'  where Q19  = 'M'  and (Q1='2' or Q4='1')
update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1')
update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1')
update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1')
update #results set Q24  = 'S'  where Q24  = 'M'  and (Q1='2' or Q4='1' or Q23='2')
update #results set Q25  = 'S ' where Q25  = 'M ' and (Q1='2' or Q4='1')
update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1')
 
-- If Q38 = 2 (“No”) Skip to end of the survey
-- Questions 39a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q38).
 -- If they answered Q65 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q39a='S',Q39b='S',Q39c='S',Q39d='S',Q39e='S' where Q38 = '2' and Q39a+Q39b+Q39c+Q39d+Q39e='00000'

update #results set
	Q1	 = ' ',
	Q2	 = ' ',
	Q3	 = ' ',
	Q4	 = ' ',
	Q5	 = ' ',
	Q6	 = ' ',
	Q7	 = ' ',
	Q8	 = ' ',
	Q9	 = ' ',
	Q10	 = ' ',
	Q11	 = ' ',
	Q12	 = ' ',
	Q13	 = ' ',
	Q14	 = ' ',
	Q15	 = ' ',
	Q16	 = ' ',
	Q17	 = ' ',
	Q18	 = ' ',
	Q19	 = ' ',
	Q20	 = ' ',
	Q21	 = ' ',
	Q22	 = ' ',
	Q23	 = ' ',
	Q24	 = ' ',
	Q25	 = '  ',
	Q26	 = ' ',
	Q27	 = ' ',
	Q28	 = ' ',
	Q29	 = ' ',
	Q30	 = '  ',
	Q31	 = ' ',
	Q32	 = ' ',
	Q33a = ' ',
	Q33b = ' ',
	Q33c = ' ',
	Q33d = ' ',
	Q33e = ' ',
	Q33f = ' ',
	Q34	 = ' ',
	Q35	 = ' ',
	Q36	 = ' ',
	Q37	 = ' ',
	Q38	 = ' ',
	Q39a = ' ',
	Q39b = ' ',
	Q39c = ' ',
	Q39d = ' ',
	Q39e = ' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child12MonthA')
	drop procedure GetCGCAHPSdata2_sub_Child12MonthA
go
create procedure dbo.GetCGCAHPSdata2_sub_Child12MonthA
as
alter table #results add
	Q1   char(1), -- Q046265
	Q2   char(1), -- Q046266
	Q3   char(1), -- Q046267
	Q4   char(1), -- Q046268
	Q5   char(1), -- Q046269
	Q6   char(1), -- Q046270
	Q7   char(1), -- Q046271
	Q8   char(1), -- Q046272
	Q9   char(1), -- Q046273
	Q10  char(1), -- Q046274
	Q11  char(1), -- Q046275
	Q12  char(1), -- Q046276
	Q13  char(1), -- Q046277

	Q15  char(1), -- Q046279
	Q16  char(1), -- Q046280

	Q20  char(1), -- Q046284
	Q21  char(1), -- Q046285
	Q22  char(1), -- Q046286
	Q23  char(1), -- Q046287

	Q25  char(1), -- Q046289
	Q26  char(1), -- Q046290
	Q27  char(1), -- Q046291
	Q28  char(1), -- Q046292
	Q29  char(1), -- Q046293
	Q30  char(1), -- Q046294
	Q31  char(1), -- Q046295
	Q32  char(1), -- Q046296
	Q33  char(1), -- Q046297
	Q34  char(1), -- Q046298
	Q35  char(2), -- Q046299
	Q38  char(1), -- Q046302
	Q39  char(1), -- Q046303
	Q40  char(1), -- Q046304
	Q41  char(1), -- Q046305
	Q42  char(1), -- Q046306
	Q43  char(1), -- Q046307
	Q44  char(1), -- Q046308
	Q45  char(1), -- Q046309
	Q46  char(1), -- Q046310
	Q47  char(1), -- Q046311
	Q48  char(1), -- Q046312
	
	Q53  char(1), -- Q046317
	Q54  char(1), -- Q046318
	Q55  char(1), -- Q046319
	Q56  char(1), -- Q046320
	Q57  char(2), -- Q046321
	Q58  char(1), -- Q046322
	Q59  char(1), -- Q046323
	Q60a char(1), -- Q046324a
	Q60b char(1), -- Q046324b
	Q60c char(1), -- Q046324c
	Q60d char(1), -- Q046324d
	Q60e char(1), -- Q046324e
	Q60f char(1), -- Q046324f
	Q61  char(1), -- Q048856 / 46325   <-- some surveys use 488856, 48666, 48667 and 48668. Others use 46325, 46328, 46329 and 46330.
	Q62  char(1), -- Q046326
	Q63  char(1), -- Q046327
	Q64  char(1), -- Q048666 / 46328
	Q65  char(1), -- Q048667 / 46329
	Q66a char(1), -- Q048668a / 46330a
	Q66b char(1), -- Q048668b / 46330b
	Q66c char(1), -- Q048668c / 46330c
	Q66d char(1), -- Q048668d / 46330d
	Q66e char(1)  -- Q048668e / 46330e
go
if exists (select * from sys.procedures where name = 'GetCGCAHPSdata2_sub_Child12MonthB')
	drop procedure GetCGCAHPSdata2_sub_Child12MonthB
go
create procedure dbo.GetCGCAHPSdata2_sub_Child12MonthB
 @survey_id INT,
 @begindate VARCHAR(10),
 @enddate   VARCHAR(10)
as
update #results set surveytype=17

-- Load question responses into #results, mapping NULL & -9 to 9 and -8 to 8
-- (unless the #results field is char(2), then map them to 99 and 88, respectively)
-- if any of the responses had been altered by skip enforcement, subtract 10000 from them.
update r set
 Q1   = case isnull(q046265,-9) when -9 then 'M' when -8 then 'H' else cast(Q046265%10000 as varchar) end,
 Q2   = case isnull(q046266,-9) when -9 then 'M' when -8 then 'H' else cast(Q046266%10000 as varchar) end,
 Q3   = case isnull(q046267,-9) when -9 then 'M' when -8 then 'H' else cast(Q046267%10000 as varchar) end,
 Q4   = case isnull(q046268,-9) when -9 then 'M' when -8 then 'H' else cast(Q046268%10000 as varchar) end,
 Q5   = case isnull(q046269,-9) when -9 then 'M' when -8 then 'H' else cast(Q046269%10000 as varchar) end,
 Q6   = case isnull(q046270,-9) when -9 then 'M' when -8 then 'H' else cast(Q046270%10000 as varchar) end,
 Q7   = case isnull(q046271,-9) when -9 then 'M' when -8 then 'H' else cast(Q046271%10000 as varchar) end,
 Q8   = case isnull(q046272,-9) when -9 then 'M' when -8 then 'H' else cast(Q046272%10000 as varchar) end,
 Q9   = case isnull(q046273,-9) when -9 then 'M' when -8 then 'H' else cast(Q046273%10000 as varchar) end,
 Q10  = case isnull(q046274,-9) when -9 then 'M' when -8 then 'H' else cast(Q046274%10000 as varchar) end,
 Q11  = case isnull(q046275,-9) when -9 then 'M' when -8 then 'H' else cast(Q046275%10000 as varchar) end,
 Q12  = case isnull(q046276,-9) when -9 then 'M' when -8 then 'H' else cast(Q046276%10000 as varchar) end,
 Q13  = case isnull(q046277,-9) when -9 then 'M' when -8 then 'H' else cast(Q046277%10000 as varchar) end,
                                                                                     
 Q15  = case isnull(q046279,-9) when -9 then 'M' when -8 then 'H' else cast(Q046279%10000 as varchar) end,
 Q16  = case isnull(q046280,-9) when -9 then 'M' when -8 then 'H' else cast(Q046280%10000 as varchar) end,
                                                                                     
 Q20  = case isnull(q046284,-9) when -9 then 'M' when -8 then 'H' else cast(Q046284%10000 as varchar) end,
 Q21  = case isnull(q046285,-9) when -9 then 'M' when -8 then 'H' else cast(Q046285%10000 as varchar) end,
 Q22  = case isnull(q046286,-9) when -9 then 'M' when -8 then 'H' else cast(Q046286%10000 as varchar) end,
 Q23  = case isnull(q046287,-9) when -9 then 'M' when -8 then 'H' else cast(Q046287%10000 as varchar) end,
                                                                                     
 Q25  = case isnull(q046289,-9) when -9 then 'M' when -8 then 'H' else cast(Q046289%10000 as varchar) end,
 Q26  = case isnull(q046290,-9) when -9 then 'M' when -8 then 'H' else cast(Q046290%10000 as varchar) end,
 Q27  = case isnull(q046291,-9) when -9 then 'M' when -8 then 'H' else cast(Q046291%10000 as varchar) end,
 Q28  = case isnull(q046292,-9) when -9 then 'M' when -8 then 'H' else cast(Q046292%10000 as varchar) end,
 Q29  = case isnull(q046293,-9) when -9 then 'M' when -8 then 'H' else cast(Q046293%10000 as varchar) end,
 Q30  = case isnull(q046294,-9) when -9 then 'M' when -8 then 'H' else cast(Q046294%10000 as varchar) end,
 Q31  = case isnull(q046295,-9) when -9 then 'M' when -8 then 'H' else cast(Q046295%10000 as varchar) end,
 Q32  = case isnull(q046296,-9) when -9 then 'M' when -8 then 'H' else cast(Q046296%10000 as varchar) end,
 Q33  = case isnull(q046297,-9) when -9 then 'M' when -8 then 'H' else cast(Q046297%10000 as varchar) end,
 Q34  = case isnull(q046298,-9) when -9 then 'M' when -8 then 'H' else cast(Q046298%10000 as varchar) end,
--DRM 01/20/2014 Added left pad on Q35.
 Q35  = case isnull(q046299,-9) when -9 then 'M ' when -8 then 'H ' else right('00'+cast(q046299%10000 as varchar),2) end,
-- Q35  = case isnull(q046299,-9) when -9 then 'M ' when -8 then 'H ' else Q046299%10000 end,

 Q38  = case isnull(q046302,-9) when -9 then 'M' when -8 then 'H' else cast(Q046302%10000 as varchar) end,
 Q39  = case isnull(q046303,-9) when -9 then 'M' when -8 then 'H' else cast(Q046303%10000 as varchar) end,
 Q40  = case isnull(q046304,-9) when -9 then 'M' when -8 then 'H' else cast(Q046304%10000 as varchar) end,
 Q41  = case isnull(q046305,-9) when -9 then 'M' when -8 then 'H' else cast(Q046305%10000 as varchar) end,
 Q42  = case isnull(q046306,-9) when -9 then 'M' when -8 then 'H' else cast(Q046306%10000 as varchar) end,
 Q43  = case isnull(q046307,-9) when -9 then 'M' when -8 then 'H' else cast(Q046307%10000 as varchar) end,
 Q44  = case isnull(q046308,-9) when -9 then 'M' when -8 then 'H' else cast(Q046308%10000 as varchar) end,
 Q45  = case isnull(q046309,-9) when -9 then 'M' when -8 then 'H' else cast(Q046309%10000 as varchar) end,
 Q46  = case isnull(q046310,-9) when -9 then 'M' when -8 then 'H' else cast(Q046310%10000 as varchar) end,
 Q47  = case isnull(q046311,-9) when -9 then 'M' when -8 then 'H' else cast(Q046311%10000 as varchar) end,
 Q48  = case isnull(q046312,-9) when -9 then 'M' when -8 then 'H' else cast(Q046312%10000 as varchar) end,
 Q53  = case isnull(q046317,-9) when -9 then 'M' when -8 then 'H' else cast(Q046317%10000 as varchar) end,
 Q54  = case isnull(q046318,-9) when -9 then 'M' when -8 then 'H' else cast(Q046318%10000 as varchar) end,
 Q55  = case isnull(q046319,-9) when -9 then 'M' when -8 then 'H' else cast(Q046319%10000 as varchar) end,
 Q56  = case isnull(q046320,-9) when -9 then 'M' when -8 then 'H' else cast(Q046320%10000 as varchar) end,
 -- Q57 (46321) is "What is your child's age?" (1) less than 1 year old (2) ____ years old (write in)
 -- the hand-entry is mapped to the HECGPedsAge metafield
 -- case  Q045321  HECGPedsAge    Result               comment
 -- a     -9       (numeric)      (HECGPedsAge value)  respondent didn't fill out either bubble, but they filled out the hand-entry
 -- a     -9       (non-numeric)  99 (missing)
 -- b     -8       (numeric)      88 (multi-mark)
 -- b     -8       (non-numeric)  88 (multi-mark)
 -- c     1        (numeric)      88 (multi-mark)      respondent marked the "less than 1" bubble and still filled out the hand-entry
 -- c     1        (non-numeric)  0
 -- d     2        (NULL)         99 (missing)         respondent marked the "___ years old" bubble, but didn't fill out the hand-entry
 -- e     2        (non-numeric)  99 (missing)         respondent marked the "___ years old" bubble, but filled in the hand-entry with a non-number
 -- f     2        (numeric)      (HECGPedsAge value)
 Q57  = case
     -- case a:
     when isnull(q046321,-9) = -9 then case when isnumeric(bt.HECGPedsAge)=1 and bt.HECGPedsAge not like '%,%' and floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2)) else 'M ' end
     -- case b:
     when isnull(q046321,-9) = -8 then 'H ' 
     -- case c:
     when q046321%10000 = 1 then case when isnumeric(bt.HECGPedsAge)=1 then 'H ' else '0 ' end
     -- case d:
     when bt.HECGPedsAge is null then 'M '
     -- case e:
     when isnumeric(bt.HECGPedsAge)=0 or bt.HECGPedsAge like '%,%' then 'M '
     -- case f:
     when floor(bt.HECGPedsAge) between 1 and 99 then cast(floor(bt.HECGPedsAge) as varchar(2))
     else 'M '
     --case f was: else cast(floor(bt.HECGPedsAge) as varchar(2))
    end,
 Q58  = case isnull(q046322,-9) when -9 then 'M' when -8 then 'H' else cast(Q046322%10000 as varchar) end,
 Q59  = case isnull(q046323,-9) when -9 then 'M' when -8 then 'H' else cast(Q046323%10000 as varchar) end,
 Q60a = case isnull(q046324a,-9) when -9 then 0 else 1 end,
 Q60b = case isnull(q046324b,-9) when -9 then 0 else 1 end,
 Q60c = case isnull(q046324c,-9) when -9 then 0 else 1 end,
 Q60d = case isnull(q046324d,-9) when -9 then 0 else 1 end,
 Q60e = case isnull(q046324e,-9) when -9 then 0 else 1 end,
 Q60f = case isnull(q046324f,-9) when -9 then 0 else 1 end,
 Q62  = case isnull(q046326,-9) when -9 then 'M' when -8 then 'H' else cast(Q046326%10000 as varchar) end,
 Q63  = case isnull(q046327,-9) when -9 then 'M' when -8 then 'H' else cast(Q046327%10000 as varchar) end
from #results r
 inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
 left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
 inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

-- some surveys use cores 46325, 46328, 46329 and 46330 for Q61, Q64, Q65 and Q66.
-- others use cores 48856, 48666, 48667 and 48668.
-- check which cores currently appear in sel_qstns.
-- according to client services "Looking at what is currently on the survey in Qualisys would be our best option.  The core numbers shouldn’t change."
-- that said, if the survey was using different questions at the time of fielding or didn't ask one of these questions at all - this might crash.
declare @SQL nvarchar(4000)
if exists (select * from qualisys.qp_prod.dbo.sel_qstns where survey_id=@survey_id and qstncore in (46325,46328,46329,46330))
 set @SQL = N'
 update r set
  Q61  = case isnull(q046325,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046325%10000 as varchar) end,
  Q64  = case isnull(q046328,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046328%10000 as varchar) end,
  Q65  = case isnull(q046329,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q046329%10000 as varchar) end,
  Q66a = case isnull(q046330a,-9) when -9 then 0 else 1 end,
  Q66b = case isnull(q046330b,-9) when -9 then 0 else 1 end,
  Q66c = case isnull(q046330c,-9) when -9 then 0 else 1 end,
  Q66d = case isnull(q046330d,-9) when -9 then 0 else 1 end,
  Q66e = case isnull(q046330e,-9) when -9 then 0 else 1 end'
else
 set @SQL = N'
 update r set
  Q61  = case isnull(q048856,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048856%10000 as varchar) end,
  Q64  = case isnull(q048666,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048666%10000 as varchar) end,
  Q65  = case isnull(q048667,-9) when -9 then ''M'' when -8 then ''H'' else cast(Q048667%10000 as varchar) end,
  Q66a = case isnull(q048668a,-9) when -9 then 0 else 1 end,
  Q66b = case isnull(q048668b,-9) when -9 then 0 else 1 end,
  Q66c = case isnull(q048668c,-9) when -9 then 0 else 1 end,
  Q66d = case isnull(q048668d,-9) when -9 then 0 else 1 end,
  Q66e = case isnull(q048668e,-9) when -9 then 0 else 1 end'

set @SQL = @SQL + N'
 from #results r
  inner join #Big_Table bt on r.samplepop_id=bt.samplepop_id and r.sampleunit_id=bt.sampleunit_id
  left outer join #Study_Results sr on bt.samplepop_id = sr.samplepop_id and bt.sampleunit_id = sr.sampleunit_id
  inner join #tmp_mncm_mailsteps tmm on tmm.samplepop_id = sr.samplepop_id and tmm.sampleunit_id = sr.sampleunit_id'
-- #tmp_mncm_mailsteps only has records that we're exporting, so this where clause is redundant:
--   where tmm.bitmncm = 1
--   and bt.datsampleencounterdate between @begindate and @enddate
--   and bt.survey_id = @survey

EXEC sp_executesql @SQL, N'@begindate datetime, @enddate datetime, @survey_id int', @begindate, @enddate, @survey_id

-- Child 12-month w/ PCMH:
-- Q1 = core 46265
-- If Q1 = 2 (“No”) Questions 2-54 should have case logic applied
-- If Q4 = 1 ("none") Questions 5-54 should have case logic applied

-- If they didn’t answer the question, look at how they answered the screener question (Q1).
 -- If they answered Q1 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q2   = 'S'  where Q2   = 'M'  and (Q1='2')
 update #results set Q3   = 'S'  where Q3   = 'M'  and (Q1='2')
 update #results set Q4   = 'S'  where Q4   = 'M'  and (Q1='2')
 update #results set Q5   = 'S'  where Q5   = 'M'  and (Q1='2' or Q4='1')
 update #results set Q6   = 'S'  where Q6   = 'M'  and (Q1='2' or Q4='1' or Q5='1')
 update #results set Q7   = 'S'  where Q7   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2')
 update #results set Q8   = 'S'  where Q8   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q9   = 'S'  where Q9   = 'M'  and (Q1='2' or Q4='1' or Q6='1' or Q6='2' or Q7='2')
 update #results set Q10  = 'S'  where Q10  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q11  = 'S'  where Q11  = 'M'  and (Q1='2' or Q4='1' or Q10='2')
 update #results set Q12  = 'S'  where Q12  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q13  = 'S'  where Q13  = 'M'  and (Q1='2' or Q4='1' or Q12='2')
 
 update #results set Q15  = 'S'  where Q15  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q16  = 'S'  where Q16  = 'M'  and (Q1='2' or Q4='1' or Q15='2')

 update #results set Q20  = 'S'  where Q20  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q21  = 'S'  where Q21  = 'M'  and (Q1='2' or Q4='1' or Q20='2')
 update #results set Q22  = 'S'  where Q22  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q23  = 'S'  where Q23  = 'M'  and (Q1='2' or Q4='1' or Q22='2')

 update #results set Q25  = 'S'  where Q25  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q26  = 'S'  where Q26  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q27  = 'S'  where Q27  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q28  = 'S'  where Q28  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q29  = 'S'  where Q29  = 'M'  and (Q1='2' or Q4='1' or Q28='2')
 update #results set Q30  = 'S'  where Q30  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q31  = 'S'  where Q31  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q32  = 'S'  where Q32  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q33  = 'S'  where Q33  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q34  = 'S'  where Q34  = 'M'  and (Q1='2' or Q4='1' or Q33='2')
 update #results set Q35  = 'S ' where Q35  = 'M ' and (Q1='2' or Q4='1')

 update #results set Q38  = 'S'  where Q38  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q39  = 'S'  where Q39  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q40  = 'S'  where Q40  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q41  = 'S'  where Q41  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q42  = 'S'  where Q42  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q43  = 'S'  where Q43  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q44  = 'S'  where Q44  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q45  = 'S'  where Q45  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q46  = 'S'  where Q46  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q47  = 'S'  where Q47  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q48  = 'S'  where Q48  = 'M'  and (Q1='2' or Q4='1')

 update #results set Q53  = 'S'  where Q53  = 'M'  and (Q1='2' or Q4='1')
 update #results set Q54  = 'S'  where Q54  = 'M'  and (Q1='2' or Q4='1')

-- If Q65 = 2 (“No”) Skip to end of the survey
-- Questions 66a-e should have case logic applied

-- If they didn’t answer the question (i.e. all 5 multi-mark responses are '0'), look at how they answered the screener question (Q65).
 -- If they answered Q65 “No”, invoking the skip, then mark the question appropriately skipped.
 update #results set Q66a='S',Q66b='S',Q66c='S',Q66d='S',Q66e='S' where Q65 = '2' and Q66a+Q66b+Q66c+Q66d+Q66e='00000'

update #results set
 Q1  =' ',
 Q2  =' ',
 Q3  =' ',
 Q4  =' ',
 Q5  =' ',
 Q6  =' ',
 Q7  =' ',
 Q8  =' ',
 Q9  =' ',
 Q10 =' ',
 Q11 =' ',
 Q12 =' ',
 Q13 =' ',

 Q15 =' ',
 Q16 =' ',

 Q20 =' ',
 Q21 =' ',
 Q22 =' ',
 Q23 =' ',

 Q25 =' ',
 Q26 =' ',
 Q27 =' ',
 Q28 =' ',
 Q29 =' ',
 Q30 =' ',
 Q31 =' ',
 Q32 =' ',
 Q33 =' ',
 Q34 =' ',
 Q35 ='  ',

 Q38 =' ',
 Q39 =' ',
 Q40 =' ',
 Q41 =' ',
 Q42 =' ',
 Q43 =' ',
 Q44 =' ',
 Q45 =' ',
 Q46 =' ',
 Q47 =' ',
 Q48 =' ',

 Q53 =' ',
 Q54 =' ',
 Q55 =' ',
 Q56 =' ',
 Q57 ='  ',
 Q58 =' ',
 Q59 =' ',
 Q60a=' ',
 Q60b=' ',
 Q60c=' ',
 Q60d=' ',
 Q60e=' ',
 Q60f=' ',
 Q61 =' ',
 Q62 =' ',
 Q63 =' ',
 Q64 =' ',
 Q65 =' ',
 Q66a=' ',
 Q66b=' ',
 Q66c=' ',
 Q66d=' ',
 Q66e=' '
where --disposition not in (11, 21, 12, 22, 14, 24) or
q1 is null
go