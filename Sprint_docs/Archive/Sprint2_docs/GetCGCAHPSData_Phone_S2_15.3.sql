USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[GetCGCAHPSData_Phone]    Script Date: 6/16/2014 11:38:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetCGCAHPSData_Phone]          
 @survey_id int,          
 @begindate varchar(10),          
 @enddate varchar(10)          
as          
    
/****
Note: the difference between this proc and GetCGCAHPSData is that this does not include the code to find 
the "how helped" question response, as that is not asked on the phone version of the questionnaire
****/
    
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

02/14/2013 dmp
**Added same check for length and if numeric to Zip5 that was added to the non-phone proc on 01/22/2011
[Added isNumeric and length checks to zip5 to replace bad data with 99999 (value for missing)]

Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table
    
**/    
    
    
    
         
---- testing code    
--declare  @survey_id int,          
-- @begindate varchar(10),          
-- @enddate varchar(10)          
    
----set @survey_id = 9899    
----set @survey_id =9489   --both how helped questions    
--set @survey_id = 10396    
--set @begindate = '2010-07-01'    
--set @enddate = '2010-08-31'    
---- end testing code    
         
          
declare @study varchar(10)          
declare @survey varchar(10)     
declare @sql varchar(8000)     
declare @sqldoc varchar(8000)      
          
select @survey = cast(@survey_id as varchar)          
select @study = cast(study_id as varchar) from qualisys.qp_prod.dbo.survey_def where survey_id = @survey_id    
    
    
          
if not exists(select * from information_schema.tables where table_name = 'big_table_view' and table_schema = 's' + @study)          
begin          
 print 'Table s' + @study + '.big_table_view does not exist.  Exiting...'          
 return          
end          
    
        
if isdate(@begindate)=0          
begin          
 print 'Please enter a valid begin date.  Exiting...'          
 return          
end          
          
          
if isdate(@enddate)=0          
begin          
 print 'Please enter a valid end date.  Exiting...'          
 return          
end          
          
-- Make sure the methodology contains only two steps          
if exists(select 1 from information_schema.tables where table_name = 'tmp_mncm' and table_schema = 'dbo') drop table dbo.tmp_mncm          
    
exec('select su.survey_id, ms.intsequence           
into dbo.tmp_mncm          
from s' + @study + '.big_table_view bt inner join s' + @study + '.study_results_view sr          
 on bt.samplepop_id = sr.samplepop_id          
 and bt.sampleunit_id = sr.sampleunit_id          
inner join sampleunit su          
 on bt.sampleunit_id = su.sampleunit_id          
inner join qualisys.qp_prod.dbo.sentmailing sm          
 on sr.strlithocode = sm.strlithocode          
inner join qualisys.qp_prod.dbo.scheduledmailing schm          
 on sm.scheduledmailing_id = schm.scheduledmailing_id          
inner join qualisys.qp_prod.dbo.mailingstep ms          
 on schm.mailingstep_id = ms.mailingstep_id          
where su.bitmncm = 1          
and bt.datsampleencounterdate between ''' + @begindate + ''' and ''' + @enddate + '''          
and ms.intsequence not in (1,2)')          
          
if exists (select * from dbo.tmp_mncm)           
begin          
 print 'Problem with intsequence.  Exiting...'          
 return          
end       
    
/**Section to create doctor identifier dynamic SQL **/    
--Studies may have DRNPI or DRID, or both, either may be populated    
--If neither exists, we use DrLastName    
--Here we're creating some dynamic SQL to plug in the appropriate place in the exec below    
    
create table #docfields (columnname varchar(10))    
    
--declare @study varchar(4)    
--set @study = 3578    
    
insert into #docfields    
select  COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS    
where table_schema = 's' +  @study     
AND COLUMN_NAME in ('drnpi','drid','drlastname') AND TABLE_NAME LIKE '%VIEW%'     
    
--select * from #docfields    
    
--delete from #docfields where columnname = 'drid'    
    
--declare @sqldoc varchar(8000)      
declare @fieldcount int    
select @fieldcount = count(*) from #docfields    
    
if @fieldcount = 3    
begin    
 set @sqldoc = ' right(space(10) + isnull(drnpi, isnull(drid, left(isnull(drlastname, ''''),10))), 10)'    
end    
    
if @fieldcount = 2    
begin    
 set @sqldoc = ' right(space(10) + '    
 if exists (select * from #docfields where columnname = 'drnpi')     
 and exists (select * from #docfields where columnname = 'drid')    
 begin    
  set @sqldoc = @sqldoc + ' isnull(drnpi, isnull(drid,'''')),10)'    
 end    
 if exists (select * from #docfields where columnname = 'drnpi')     
 and exists (select * from #docfields where columnname = 'drlastname')    
 begin    
  set @sqldoc = @sqldoc + ' isnull(drnpi, isnull(drlastname,'''')),10)'    
 end    
 if exists (select * from #docfields where columnname = 'drid')     
 and exists (select * from #docfields where columnname = 'drlastname')    
 begin    
  set @sqldoc = @sqldoc + ' isnull(drid, isnull(drlastname,'''')),10)'    
 end    
     
end    
    
if @fieldcount = 1    
begin    
 declare @columnname varchar(10)    
 select @columnname = columnname from #docfields    
 set @sqldoc = ' right(space(10) + ' + @columnname + ', 10)'    
end    
    
--print @sqldoc    
    
/**Section to create helped core dynamic SQL **/    
--There are two different versions of the how-helped question. Studies may have one or the other, or both cores in    
--their study_results_view. Here we're creating some dynamic SQL to plug in the appropriate place in the exec below    
    
create table #helpedcores (columnname varchar(7))    
    
insert into #helpedcores    
select  COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS    
where table_schema = 's' +  @study     
AND COLUMN_NAME in ('Q039161','Q040716') AND TABLE_NAME LIKE '%VIEW%'       --core for how-helped question    
    
declare @corecount int    
--select @corecount =  count(*) from #helpedcores    
    
    
    
--select * from #helpedcores    
    
--if @corecount = 1    
--begin    
-- if exists (select * from #helpedcores where columnname = 'Q040716')    
-- begin    
-- set @sql =     
    
--'right('' '' + cast(abs(isnull(q040716,-9)) as varchar), 1) + --Q40          
-- case              --Q41a          
--  when isnull(q039162a,-9) = -9 then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41b          
--  when isnull(q039162b,-9) = -9 then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41c          
--  when isnull(q039162c,-9) = -9 then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41d          
--  when isnull(q039162d,-9) = -9 then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41e          
--  when isnull(q039162e,-9) = -9 then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''   end '    
      
--  --print @sql    
--  end    
      
--  --old core    
--   if exists (select * from #helpedcores where columnname = 'Q039161')    
-- begin    
-- set @sql =     
    
--'right('' '' + cast(abs(isnull(Q039161,-9)) as varchar), 1) + --Q40          
-- case              --Q41a          
--  when isnull(q039162a,-9) = -9 then case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41b          
--  when isnull(q039162b,-9) = -9 then case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41c          
--  when isnull(q039162c,-9) = -9 then case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41d          
--  when isnull(q039162d,-9) = -9 then case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''          
-- end +          
-- case              --Q41e          
--  when isnull(q039162e,-9) = -9 then case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end          
--  else ''1''   end '    
      
--  --print @sql    
--  end    
--end    
----both cores    
----select * from #helpedcores    
--if @corecount = 2    
--begin    
-- --print 'rowcount is 2'         
-- set @sql =     
--' + case  --Q40    
-- when Q039161 is null then right('' '' + cast(abs(isnull(q040716,-9)) as varchar), 1)    
-- else right('' '' + cast(abs(isnull(Q039161,-9)) as varchar), 1)    
--end +           
-- case              --Q41a          
--  when isnull(q039162a,-9) = -9 then     
-- case when Q039161 is null then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end    
-- else case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end    
-- end          
--  else ''1''          
-- end +          
-- case              --Q41b          
--  when isnull(q039162b,-9) = -9 then     
-- case when Q039161 is null then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end    
-- else case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end    
-- end          
--  else ''1''         
-- end +          
-- case              --Q41c          
--  when isnull(q039162c,-9) = -9 then     
-- case when Q039161 is null then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end    
-- else case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end    
-- end          
--  else ''1''          
-- end +          
-- case              --Q41d          
--  when isnull(q039162d,-9) = -9 then     
-- case when Q039161 is null then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end    
-- else case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end    
-- end          
--  else ''1''         
-- end +          
-- case              --Q41e          
--  when isnull(q039162e,-9) = -9 then     
-- case when Q039161 is null then case when isnull(q040716,-9) = 2 then ''7'' else ''0'' end    
-- else case when isnull(Q039161,-9) = 2 then ''7'' else ''0'' end    
-- end          
--  else ''1''  end '     
      
--  --print @sql    
--  end    
  
--if @corecount = 0    
--begin    
-- select @sql = ''  
--end    
  
--drop table #helpedcores    
/**End section to create helped core dynamic SQL **/    
  
  
--Get the mail step sequence (1 or 2) for the returns. Have to do it here so we only    
--have mailing step data for the returns to avoid duplicate records    
create table #tmp_mncm_dispositions (samplepop_id int, disposition_id int, receipttype_id int, datlogged datetime, numattempts int)    
  
-- TSB 06/16/2014 use surveytypedispositions table instead of MNCMdispositions
exec(    
'insert into #tmp_mncm_dispositions (samplepop_id, disposition_id, receipttype_id, datlogged)  
select distinct sr.samplepop_id, dl.disposition_id, dl.receipttype_id, dl.datlogged  
from s' + @study + '.big_table_view bt    
inner join s' + @study + '.study_results_view sr    
  on bt.samplepop_id = sr.samplepop_id    
  and bt.sampleunit_id = sr.sampleunit_id    
inner join surveytypedispositions md  
 on bt.mncmdisposition = md.value and md.surveytype_id = 4   
inner join dispositionlog dl  
 on bt.samplepop_id = dl.samplepop_id  
 and md.disposition_id = dl.disposition_id  
where bt.survey_id = ' + @survey +    
'and bt.datsampleencounterdate between ''' + @begindate + ''' and ''' + @enddate + ''' '         
)      
    
--select * from #tmp_mncm_mailsteps      
  
update a  
set numattempts = total  
from #tmp_mncm_dispositions a inner join  
 (select dl.samplepop_id, count(*) total  
 from #tmp_mncm_dispositions t inner join dispositionlog dl  
  on t.samplepop_id = dl.samplepop_id  
 where dl.disposition_id <> t.disposition_id  
 and dl.receipttype_id = 12  
 and dl.datlogged <= t.datlogged  
 and t.receipttype_id = 12  
 group by dl.samplepop_id) b  
on a.samplepop_id = b.samplepop_id  
  
update a  
set numattempts = total  
from #tmp_mncm_dispositions a inner join  
 (select dl.samplepop_id, count(*) total  
 from #tmp_mncm_dispositions t inner join dispositionlog dl  
  on t.samplepop_id = dl.samplepop_id  
 where dl.disposition_id <> t.disposition_id  
 and dl.receipttype_id = 12  
 and dl.datlogged < t.datlogged  
 and t.receipttype_id <> 12  
 group by dl.samplepop_id) b  
on a.samplepop_id = b.samplepop_id  
      
  
    
exec('select distinct         
 ''32'' +              --Survey Type        
 right(space(3) + cast(bt.samplepop_id as varchar), 10) + --Unique Record ID        
 --isnull(cg_siteid, '''') + space(10 - len(isnull(cg_siteid, ''''))) +   --Practice Site ID     
 right(space(10) + isnull(cg_siteid,''''), 10) +      
 --isnull(cg_groupid, '''') + space(10 - len(isnull(cg_groupid, ''''))) +   --Group ID     
 right(space(10) + isnull(cg_groupid,''''), 10) + '      
 --right(space(10) + isnull(drnpi, isnull(drid, left(isnull(drlastname, ''''),10))), 10) +     --Physician NPI or ID        
 + @sqldoc + '+    
 right(space(20) + isnull(drfirstname, ''''), 20) +   --Physician First Name        
 right(space(20) + isnull(drlastname, ''''), 20) +    --Physician Last Name        
 case             --Physician Specialty        
  when cg_physspec is null then ''999''      
  when rtrim(cg_physspec) in ('''', ''0'') then ''999''      
  when (isnumeric(cg_physspec) = 1 and right(''000'' + cg_physspec, 3) between ''001'' and ''036'') then right(''000'' + cg_physspec, 3)    
  else ''998''    
 end +    
 case              --Physician Gender          
  when cg_physsex = ''M'' then ''1''          
  when cg_physsex = ''F'' then ''2''          
  else ''9''          
 end +          
 case              --Date of Last Visit          
  when datsampleencounterdate is null then ''99999999''          
  else replace(convert(varchar(10), datsampleencounterdate, 101), ''/'', '''')           
 end +           
 right(''  '' + rtrim(isnull(mncmdisposition, ''38'')), 2) +  --Survey Disposition Code          
 case              --Survey Completion Date          
  when datreturned is null then ''99999999''          
  else replace(convert(varchar(10), datreturned, 101), ''/'', '''')           
 end +          
 case              --Survey Complete Round          
  when mncmdisposition = ''12'' then right(''0'' + cast(tmm.numattempts as varchar), 2)        --numattempts  
  else ''NC''          
 end +          
 case              --Survey Language          
  when (mncmdisposition in (''12'', ''22'') and bt.langid in (2, 8, 18, 19)) then ''2''          
  when (mncmdisposition in (''12'', ''22'') and bt.langid not in (2, 8, 18, 19)) then ''1''          
  else ''3''          
 end +          
 cast(year(isnull(dob, ''12/31/9999'')) as varchar) +   --Patient Birth Year          
 case              --Patient Gender          
  when sex = ''M'' then ''1''          
  when sex = ''F'' then ''2''          
  else ''9''          
 end +          
 --isnull(zip5, ''99999'') +          --Patient zip code
  case
	when isnumeric(zip5) <> 1 or len(zip5) < 5 then ''99999''
	else zip5
 end + 
     
 case when mncmdisposition in (''12'', ''22'') then    
          
 right(cast(abs(isnull(q039113,-9)) as char(1)), 1) +  --Q1          
 case       --Q2          
  when isnull(q039114,-9) = -9 then case when isnull(q039113,-9) = 2 then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039114,-9)) as varchar), 1)          
 end +          
 case              --Q3          
  when isnull(q039115,-9) = -9 then case when isnull(q039113,-9) = 2 then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039115,-9)) as varchar), 1)          
 end +          
 case              --Q4          
  when isnull(q039116,-9) = -9 then case when isnull(q039113,-9) = 2 then ''77'' else ''99'' end          
  when isnull(q039116,-9) = -8 then ''88''          
  --else right('' '' + cast(abs(isnull(q039116,-9)) as varchar), 2)    
  else right('' '' + cast(abs(right(isnull(q039116,-9),2)) as varchar),2)          
 end +          
 case              --Q5          
  when isnull(q039117,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039117,-9)) as varchar), 1)          
 end +          
 case              --Q6          
  when isnull(q039118,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039117,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039118,-9)) as varchar), 1)          
 end +          
 case              --Q7          
  when isnull(q039119,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039119,-9)) as varchar), 1)          
 end +          
 case              --Q8          
  when isnull(q039120,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039119,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039120,-9)) as varchar), 1)          
 end +          
 case              --Q9          
  when isnull(q039121,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039121,-9)) as varchar), 1)          
 end +          
 case              --Q10          
  when isnull(q039122,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039121,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039122,-9)) as varchar), 1)          
 end +          
 case              --Q11          
  when isnull(q039123,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039123,-9)) as varchar), 1)          
 end +          
 case              --Q12          
  when isnull(q039124,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039123,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039124,-9)) as varchar), 1)          
 end +          
 case              --Q13          
  when isnull(q039125,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039125,-9)) as varchar), 1)          
 end +          
 case              --Q14          
  when isnull(q039126,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039126,-9)) as varchar), 1)          
 end +          
 case              --Q15          
  when isnull(q039127,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039127,-9)) as varchar), 1)          
 end +          
 case              --Q16          
  when isnull(q039128,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039128,-9)) as varchar), 1)          
 end +          
 case              --Q17          
  when isnull(q039129,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039128,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039129,-9)) as varchar), 1)          
 end +          
 case              --Q18          
  when isnull(q039130,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039130,-9)) as varchar), 1)          
 end +          
 case              --Q19          
  when isnull(q039131,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039131,-9)) as varchar), 1)          
 end +          
 case              --Q20          
  when isnull(q039132,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039132,-9)) as varchar), 1)          
 end +          
 case              --Q21          
  when isnull(q039133,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1 or isnull(q039132,-9) = 2) then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039133,-9)) as varchar), 1)          
 end +          
 case              --Q22          
  when isnull(q039134,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039134,-9)) as varchar), 1)          
 end +          
 case              --Q23          
  when isnull(q039135,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039135,-9)) as varchar), 1)          
 end +          
 case              --Q24          
  when isnull(q039136,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039136,-9)) as varchar), 1)          
 end +          
 case              --Q25          
  when isnull(q039137,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''77'' else ''99'' end          
  when isnull(q039137,-9) = -8 then ''88''          
  else right('' '' + cast(abs(isnull(q039137,-9)) as varchar), 2)          
 end +          
 case              --Q26          
  when isnull(q039138,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039138,-9)) as varchar), 1)          
 end +          
 case              --Q28          
  when isnull(q039139,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039139,-9)) as varchar), 1)          
 end +          
 case              --Q29          
  when isnull(q039140,-9) = -9 then case when (isnull(q039113,-9) = 2 or isnull(q039116,-9) = 1) then ''7'' else ''9'' end          
  else right('' '' + cast(abs(isnull(q039140,-9)) as varchar), 1)          
 end +          
 right('' '' + cast(abs(isnull(q039151,-9)) as varchar), 1) + --Q30          
 right('' '' + cast(abs(isnull(q039152,-9)) as varchar), 1) + --Q31          
 case              --Q32          
  when isnull(q039153,-9) = -9 then case when isnull(q039152,-9) = 2 then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039153,-9)) as varchar), 1)          
 end +          
 right('' '' + cast(abs(isnull(q039154,-9)) as varchar), 1) + --Q33          
 case              --Q34          
  when isnull(q039155,-9) = -9 then case when isnull(q039154,-9) = 2 then ''7'' else ''9'' end          
  else right(cast(abs(isnull(q039155,-9)) as varchar), 1)          
 end +          
 right('' '' + cast(abs(isnull(q039156,-9)) as varchar), 1) + --Q35          
 right('' '' + cast(abs(isnull(q039157,-9)) as varchar), 1) + --Q36          
 right('' '' + cast(abs(isnull(q039158,-9)) as varchar), 1) + --Q37          
 right('' '' + cast(abs(isnull(q039159,-9)) as varchar), 1) + --Q38          
 case              --Q39a          
  when isnull(q039160a,-9) = -9 then ''0''          
  else ''1''          
 end +          
 case              --Q39b          
  when isnull(q039160b,-9) = -9 then ''0''          
  else ''1''          
 end +          
 case              --Q39c          
  when isnull(q039160c,-9) = -9 then ''0''          
  else ''1''          
 end +          
 case              --Q39d          
  when isnull(q039160d,-9) = -9 then ''0''          
  else ''1''          
 end +          
 case              --Q39e          
  when isnull(q039160e,-9) = -9 then ''0''          
  else ''1''          
 end +          
 case              --Q39f          
  when isnull(q039160f,-9) = -9 then ''0''          
  else ''1''     
 end + ''977777''  
else ''                                                   ''    
end   
--as Output          
from s' + @study + '.big_table_view bt left outer join s' + @study + '.study_results_view sr          
 on bt.samplepop_id = sr.samplepop_id          
 and bt.sampleunit_id = sr.sampleunit_id          
inner join sampleunit su          
 on bt.sampleunit_id = su.sampleunit_id          
left join #tmp_mncm_dispositions tmm  
  on  tmm.samplepop_id = sr.samplepop_id        
where su.bitmncm = 1          
and bt.datsampleencounterdate between ''' + @begindate + ''' and ''' + @enddate + '''          
and bt.survey_id = ' + @survey)  
    
    
drop table #tmp_mncm_dispositions
