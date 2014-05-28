/****** Object:  Stored Procedure dbo.sp_Samp_CalcResponseRates    Script Date: 9/28/99 2:57:11 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_CalcResponseRates
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_CalcResponseRates_orig
 @intSurvey_id int
AS
 DECLARE @ResponseRate_Recalc_Period int
 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id
 CREATE TABLE #SampleSet_Status
  (SampleSet_id int, bitComplete bit)
 /* Identify the Sample Sets that have mailing items. */
 INSERT INTO #SampleSet_Status
  SELECT DISTINCT SS.SampleSet_id, 1
   FROM dbo.SampleSet SS, dbo.SamplePop SP, dbo.ScheduledMailing SchM
   WHERE SS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SS.Survey_id = @intSurvey_id
 /* Of the sample sets that have mailing items, identify the ones that have non-generated mailing items. */
 UPDATE #SampleSet_Status
  SET bitComplete = 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.SentMail_id IS NULL
    AND SchM.OverrideItem_id IS NULL
 CREATE TABLE #SampleSet_MailDate
  (SampleSet_id int, datLastMailDate datetime, bitCompleteCollMethod bit)
 /* Of the sample sets that do have generated all mailing items, identify the date the last non-Thank You item was sent */
 INSERT INTO #SampleSet_MailDate
  SELECT SSS.SampleSet_id, MAX(SM.datMailed), 0
   FROM #SampleSet_Status SSS, dbo.SamplePop SP, dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, dbo.MailingStep MS
   WHERE SSS.SampleSet_id = SP.SampleSet_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.SentMail_id = SM.SentMail_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND MS.bitThankYouItem = 0
    AND SchM.OverrideItem_id IS NULL
    AND SSS.bitComplete = 1
   GROUP BY SSS.SampleSet_id
 DROP TABLE #SampleSet_Status
 
 /* Mark the Sample Sets that have completed the collection methodology */
 UPDATE #SampleSet_MailDate
  SET bitCompleteCollMethod = 1
  WHERE datLastMailDate IS NOT NULL
   AND DATEDIFF(day, datLastMailDate, GETDATE()) > @ResponseRate_Recalc_Period
 CREATE TABLE #SampleUnit_Mailed
  (SampleUnit_id int, intNumMailed int)
 /* For each Sample Unit, calculate the number of people directly sampled from the sample sets that have completed the collection methodology */
 INSERT INTO #SampleUnit_Mailed
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
   FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
   GROUP BY SU.SampleUnit_id
 CREATE TABLE #SampleUnit_Returned
  (SampleUnit_id int, intNumReturn int)
 /* For each Sample Unit, calculate the number of people who have returned surveys from the sample sets that have completed the collection methodology */
 INSERT INTO #SampleUnit_Returned
  SELECT SU.SampleUnit_id, COUNT(DISTINCT SS.Pop_id)
FROM dbo.SamplePlan SP, dbo.SampleUnit SU, dbo.SelectedSample SS, 
    dbo.SamplePop SPop, dbo.QuestionForm QF, #SampleSet_MailDate SSMD
   WHERE SP.SamplePlan_id = SU.SamplePlan_id
    AND SU.SampleUnit_id = SS.SampleUnit_id
    AND SS.SampleSet_id = SSMD.SampleSet_id
    AND SS.SampleSet_id = SPop.SampleSet_id
    AND SS.Study_id = SPop.Study_id
    AND SS.Pop_id = SPop.Pop_id
    AND SPop.SamplePop_id = QF.SamplePop_id
    AND SP.Survey_id = @intSurvey_id
    AND SSMD.bitCompleteCollMethod = 1
    AND SS.strUnitSelectType = 'D'
    AND QF.datReturned IS NOT NULL
   GROUP BY SU.SampleUnit_id
 /* Calculate and Record the Response Rate for each sample unit */
 UPDATE SampleUnit
  SET SampleUnit.numResponseRate = CONVERT(float, SUR.intNumReturn)/CONVERT(float, SUS.intNumMailed) * 100
  FROM #SampleUnit_Mailed SUS, #SampleUnit_Returned SUR
  WHERE SampleUnit.SampleUnit_id = SUS.SampleUnit_id
   AND SUS.SampleUnit_id = SUR.SampleUnit_id
   AND SUR.intNumReturn <> 0
   AND SUS.intNumMailed <> 0 
 DROP TABLE #SampleUnit_Mailed
 DROP TABLE #SampleUnit_Returned
 DROP TABLE #SampleSet_MailDate


