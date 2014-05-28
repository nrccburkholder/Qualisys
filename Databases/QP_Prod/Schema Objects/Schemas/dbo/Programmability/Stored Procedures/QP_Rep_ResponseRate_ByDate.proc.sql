CREATE PROCEDURE [dbo].[QP_Rep_ResponseRate_ByDate]  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50),  
 @MinDate varchar(20),  
 @MaxDate varchar(20),  
 @DateType varchar(10)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SET NOCOUNT ON  
  
DECLARE @intSurvey_id INT,   
  @intSamplePlan_id INT,   
  @intstudy_id int,  
  @sql varchar(8000),  
   @DatamartServer varchar(20),  
  @btv varchar(50),  
  @srv varchar(50)  

set @MaxDate = dateadd(d, 1, cast(convert(varchar, @MaxDate, 101) as datetime))

  
--Set Datamart Server  
SELECT @DataMartServer=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'  
  
  
--Set intsurvey_id based on the string information chosen in Dashboard  
SELECT @intSurvey_id=sd.Survey_id   
FROM Survey_def sd, Study s, Client c  
WHERE c.strClient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND sd.strSurvey_nm=@Survey  
  AND c.Client_id=s.Client_id  
  AND s.Study_id=sd.Study_id  
  
-- Set intsampleplan_id based on survey_id  
select @intSamplePlan_ID = SamplePlan_ID  
from SamplePlan  
where survey_id = @intSurvey_id  
  
-- Pull Qualisys sample unit info from sample plan table  
CREATE TABLE #SampleUnits   
 (SampleUnit_id int,  
 strSampleUnit_nm varchar(255),   
 INTTier int,   
 INTTreeOrder int,  
 INTTargetReturn int)  
  
-- Format sampleplan for Dashboard reports (with indents for child units, etc.)  
EXEC sp_SampleUnits @intSamplePlan_id  
  
-- Add targets to sample units table  
update sus  
 set INTTargetreturn = s.inttargetreturn  
 from #SampleUnits sus, sampleunit s  
 where sus.sampleunit_id = s.sampleunit_id  
  
-- Set study_id to determine the Datamart tables to pull study data from  
select @intstudy_id = study_id  
from survey_def   
where survey_id = @intSurvey_id  
  
--Set big table and study results tables to variables to simplify the dynamic SQL  
set @btv = 's'+convert(varchar,@intstudy_id)+'.big_table_view'    
set @srv = 's'+convert(varchar,@intstudy_id)+'.study_results_view'    
  
-- Pull study data based on the type of date selected  
if @DateType = 'Encounter'  
begin  
  
declare @Enc_Field varchar(20)  
  
-- Find Enc_Field from survey_def  
select @Enc_Field = mf.strfield_nm  
 from metafield mf, survey_def sd  
 where sd.SampleEncounterField_id = mf.FIELD_ID  
 and sd.SURVEY_ID = @intSurvey_id  
  
-- Create table to store study data  
 create table #EncDateData   
  (samplepop_id int,  
  sampleunit_id int,   
  EncDate datetime,   
  datundeliverable datetime,  
  datReturned datetime)  
  
-- Pull study data  
--set @sql = 'INSERT INTO #EncDateData   
--    (samplepop_id,  
--    sampleunit_id,   
--    EncDate,   
--    datundeliverable,  
--    datReturned)  
--  
--   select bv.samplepop_id, bv.sampleunit_id, bv.' + @Enc_Field + ', bv.datUndeliverable, sv.datreturned  
--   from ' + @DatamartServer + '.QP_Comments.'+@btv+' bv  
--    left outer join ' + @DatamartServer + '.QP_Comments.'+@srv+' sv  
--     on (bv.samplepop_id = sv.samplepop_id) and (bv.sampleunit_id = sv.sampleunit_id)  
--   where bv.sampleunit_id in (select distinct sampleunit_id from #SampleUnits) and  
--       bv.' + @Enc_Field + ' between ''' + convert(varchar,@MinDate) + ''' and   
--    ''' + convert(varchar,@MaxDate) + ''''  

/*
--for testing
declare @sql varchar(4000)
declare @enc_field varchar(100)
declare @datamartserver varchar(100)
declare @btv varchar(100)
declare @srv varchar(100)
declare @mindate datetime
declare @maxdate datetime

set @enc_field = 'testfield'
set @datamartserver = 'datamartserver'
set @btv = 'btv'
set @srv = 'srv'
set @mindate = getdate()-30
set @maxdate = getdate()
set @MaxDate = dateadd(d, 1, cast(convert(varchar, @MaxDate, 101) as datetime))
*/

set @sql = 'INSERT INTO #EncDateData   
    (samplepop_id,  
    sampleunit_id,   
    EncDate,   
    datundeliverable,  
    datReturned)  
  
   select bv.samplepop_id, bv.sampleunit_id, bv.' + @Enc_Field + ', bv.datUndeliverable, sv.datreturned  
   from ' + @DatamartServer + '.QP_Comments.'+@btv+' bv  
    left outer join ' + @DatamartServer + '.QP_Comments.'+@srv+' sv  
     on (bv.samplepop_id = sv.samplepop_id) and (bv.sampleunit_id = sv.sampleunit_id)  
   where bv.sampleunit_id in (select distinct sampleunit_id from #SampleUnits) and  
       bv.' + @Enc_Field + ' >= ''' + convert(varchar,@MinDate) + ''' and   
       bv.' + @Enc_Field + ' < ''' + convert(varchar,@MaxDate) + ''''  
--print @sql

exec (@sql)  
  
-- Calculate response rate from study data  
 select sus.strsampleunit_nm as [Sample Unit],  
     edd.sampleunit_id as [Unit ID],   
   sum(case when EncDate is not null then 1 else 0 end) as [Sampled],  
   sum(case when datUndeliverable is not null then 1 else 0 end) as [NonDel],  
   sum(case when datReturned is not null then 1 else 0 end) as [Returned],  
   isnull(sus.inttargetreturn,0) as Target,  
   (sum(case when datReturned is not null then 1 else 0 end) * 1.0) /  
   (sum(case when EncDate is not null then 1 else 0 end) -  
   sum(case when datUndeliverable is not null then 1 else 0 end))  as [Current RespRate]  
  from #EncDateData edd  
  right outer join #SampleUnits sus  
   on (sus.sampleunit_id = edd.sampleunit_id)  
 group by edd.sampleunit_id, sus.strsampleunit_nm, sus.INTTreeOrder, sus.inttargetreturn  
 having sum(case when EncDate is not null then 1 else 0 end) -  
   sum(case when datUndeliverable is not null then 1 else 0 end) > 0  
 order by sus.INTTreeOrder  
  
drop table #EncDateData  
  
end  
/**********************************************************************************************  
**********************************************************************************************/  
ELSE IF @DateType = 'Report'  
 begin  
-- Create table to store study data  
 create table #ReportDateData   
  (samplepop_id int,  
  sampleunit_id int,   
  datReportDate datetime,   
  datundeliverable datetime,  
  datReturned datetime)  
  
-- Pull study data  
--set @sql = 'INSERT INTO #ReportDateData   
--    (samplepop_id,  
--    sampleunit_id,   
--    datReportDate,   
--    datundeliverable,  
--    datReturned)  
--  
--   select bv.samplepop_id, bv.sampleunit_id, bv.datReportDate, bv.datundeliverable, sv.datreturned  
--   from ' + @DatamartServer + '.QP_Comments.'+@btv+' bv  
--    left outer join ' + @DatamartServer + '.QP_Comments.'+@srv+' sv  
--     on (bv.samplepop_id = sv.samplepop_id) and (bv.sampleunit_id = sv.sampleunit_id)  
--   where bv.sampleunit_id in (select distinct sampleunit_id from #SampleUnits) and  
--    bv.datReportDate between ''' + convert(varchar,@MinDate) + ''' and   
--    ''' + convert(varchar,@MaxDate) + ''''  

set @sql = 'INSERT INTO #ReportDateData   
    (samplepop_id,  
    sampleunit_id,   
    datReportDate,   
    datundeliverable,  
    datReturned)  
  
   select bv.samplepop_id, bv.sampleunit_id, bv.datReportDate, bv.datundeliverable, sv.datreturned  
   from ' + @DatamartServer + '.QP_Comments.'+@btv+' bv  
    left outer join ' + @DatamartServer + '.QP_Comments.'+@srv+' sv  
     on (bv.samplepop_id = sv.samplepop_id) and (bv.sampleunit_id = sv.sampleunit_id)  
   where bv.sampleunit_id in (select distinct sampleunit_id from #SampleUnits) and  
    bv.datReportDate >= ''' + convert(varchar,@MinDate) + ''' and   
    bv.datReportDate < ''' + convert(varchar,@MaxDate) + ''''  

exec (@sql)  
  
-- Calculate response rate from study data  
 select sus.strsampleunit_nm as [Sample Unit],  
     edd.sampleunit_id as [Unit ID],   
   sum(case when datReportDate is not null then 1 else 0 end) as [Sampled],  
   sum(case when datUndeliverable is not null then 1 else 0 end) as [NonDel],  
   sum(case when datReturned is not null then 1 else 0 end) as [Returned],  
   isnull(sus.inttargetreturn,0) as Target,  
   (sum(case when datReturned is not null then 1 else 0 end) * 1.0) /  
   (sum(case when datReportDate is not null then 1 else 0 end) -  
   sum(case when datUndeliverable is not null then 1 else 0 end))  as [Current RespRate]  
  from #ReportDateData edd  
   right outer join #SampleUnits sus  
    on (edd.sampleunit_id = sus.sampleunit_id)  
 group by edd.sampleunit_id, sus.strsampleunit_nm, sus.INTTreeOrder, sus.inttargetreturn  
 having sum(case when datReportDate is not null then 1 else 0 end) -  
   sum(case when datUndeliverable is not null then 1 else 0 end) > 0  
 order by sus.INTTreeOrder  
  
  
drop table #ReportDateData  
  
end  
  
drop table #SampleUnits


