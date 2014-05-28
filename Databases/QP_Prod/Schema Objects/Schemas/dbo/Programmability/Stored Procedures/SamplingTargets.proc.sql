CREATE PROCEDURE SamplingTargets   
     @StartDate Datetime = NULL,  
     @EndDate   Datetime = NULL   
AS    
BEGIN    
/*****************************************************************************************************************    
UnitTest: EXEC SamplingTargets    
    
    
CREATE TABLE #targetchanges(IDValue int, OldValue varchar(3000),NewValue varchar(3000), ActionType char,datChanged datetime)    
    
 EXEC SamplingTargets  '1/1/2013','10/21/2013'   
   
  EXEC SamplingTargets  '2013-10-14 00:00:00.000','2013-10-18 23:59:59.997'   
    
  DECLARE @StartDate datetime  
  DECLARE @EndDate datetime  
  SET @StartDate = DATEADD(day, -7 ,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))    
SET @EndDate = DateAdd(ms,-3,(DATEADD(day, -2 ,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))))    
    
 select @StartDate,@EndDate  
    
***********************************************************************************************************************/      
IF @StartDate is not null and @EndDate is not null  
BEGIN  
select c.strclient_nm, c.client_id, s.strstudy_nm, s.study_id, sd.strsurvey_nm, sd.survey_id, st.surveytype_dsc,    
su.strsampleunit_nm, su.sampleunit_id, t.oldvalue, t.newvalue, t.actiontype, su.numresponserate, t.datchanged , @StartDate AS StartDate, @EndDate AS EndDate  
from client c, study s, survey_def sd, sampleplan spl, sampleunit su, changelog t, surveytype st    
where c.client_id = s.client_id    
and s.study_id = sd.study_id    
and sd.survey_id = spl.survey_id    
and spl.sampleplan_id = su.sampleplan_id    
and su.sampleunit_id = t.idvalue    
and sd.surveytype_id = st.surveytype_id    
and t.idname = 'sampleunit'    
and t.property = 'target'    
and t.datchanged between @StartDate and @EndDate    
order by c.client_id    
END  
ELSE  
BEGIN  
     
--Always get Last weeks Data(5 days), irrespective of which day the proc is executed.    
SET @StartDate = DATEADD(day, -7 ,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))    
SET @EndDate = DateAdd(ms,-3,(DATEADD(day, -0 ,DATEADD(wk, DATEDIFF(wk,0,GETDATE()), 0))))    
    
/*    
--select @StartDate,@EndDate    
--Temptable existance check    
IF object_id('tempdb..#targetchanges') is not null    
BEGIN    
   DROP table #targetchanges    
END    
  --  CREATE TABLE #targetchanges(IDValue int, OldValue varchar(3000),NewValue varchar(3000), ActionType char,datChanged datetime)    
*/    
    
/*    
INSERT INTO #targetchanges    
select idvalue, oldvalue, newvalue, actiontype, datchanged     
from changelog    
where idname = 'sampleunit'    
and property = 'target'    
and datchanged between @StartDate and @EndDate    
*/    
    
select c.strclient_nm, c.client_id, s.strstudy_nm, s.study_id, sd.strsurvey_nm, sd.survey_id, st.surveytype_dsc,    
su.strsampleunit_nm, su.sampleunit_id, t.oldvalue, t.newvalue, t.actiontype, su.numresponserate, t.datchanged ,@StartDate AS StartDate, @EndDate AS EndDate  
from client c, study s, survey_def sd, sampleplan spl, sampleunit su, changelog t, surveytype st    
where c.client_id = s.client_id    
and s.study_id = sd.study_id    
and sd.survey_id = spl.survey_id    
and spl.sampleplan_id = su.sampleplan_id    
and su.sampleunit_id = t.idvalue    
and sd.surveytype_id = st.surveytype_id    
and t.idname = 'sampleunit'    
and t.property = 'target'    
and t.datchanged between @StartDate and @EndDate    
order by c.client_id    
END    
END


