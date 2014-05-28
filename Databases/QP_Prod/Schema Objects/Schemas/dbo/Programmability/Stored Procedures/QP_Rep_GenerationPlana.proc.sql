CREATE PROCEDURE QP_Rep_GenerationPlana
  @Days int
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

--insert into dashboardlog (report, days, procedurebegin) select 'Work Scheduled', @days, @procedurebegin

 SELECT c.strClient_nm as Client, s.strStudy_nm as Study, SD.Study_id as StudyID, sd.strsurvey_nm as Survey, SD.Survey_id as SurveyID, SP.SampleSet_id as SampleSet, 
ms.strmailingstep_nm as MailingStep, MM.strMethodology_nm as Methodology, sm.datgenerate as Dategenerate, count(*) as Cnt, 
ss.datDateRange_FromDate as FromDate, ss.datDateRange_ToDate as ToDate
 FROM   Survey_def SD, SamplePop SP, SampleSet SS, ScheduledMailing SM, MailingMethodology MM, mailingstep ms, study s, client c
 WHERE  sd.study_id=s.study_id and
        s.client_id=c.client_id and 
        SP.SamplePop_id = SM.SamplePop_id AND
	SP.SampleSet_ID = SS.SampleSet_ID AND
        SM.SentMail_id IS NULL AND
        SM.datGenerate <= dateadd(day,@Days,getdate()) AND
        SD.bitFormGenRelease = 1 AND
        MM.Methodology_id = SM.Methodology_id AND
        MM.Survey_id = SD.Survey_id and
        sm.mailingstep_id=ms.mailingstep_id
 group by c.strClient_nm, s.strStudy_nm, sd.strsurvey_nm, SD.Study_id, SD.Survey_id, SP.SampleSet_id, ms.strmailingstep_nm, MM.strMethodology_nm, sm.datgenerate, ss.datdaterange_fromdate, ss.datDateRange_ToDate
 order by sm.datgenerate

--update dashboardlog 
--set procedureend = getdate()
--where report = 'Work Scheduled'
--and days = @days
--and procedurebegin = @procedurebegin
--and procedureend is null

set transaction isolation level read committed


