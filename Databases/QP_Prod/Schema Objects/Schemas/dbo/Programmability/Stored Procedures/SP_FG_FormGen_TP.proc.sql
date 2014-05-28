--Modified 11/17/3 BD Generate up to 1500 of the study that contains the top priority_flg, survey_id      
--Adapted 1/23/04 SS (From SP_FG_FormGen    
/*    
 Modified 1/23/04 SS     
 FG_MailingWork changed to #FG_MailngWork.    
 Added bitMockup = NULL column to #FG_MailingWork for compatability with FormGen_Sub     
 Added @bitTP = 0 to SP_FG_FormGen_Sub parameter list.    
*/    
CREATE PROCEDURE SP_FG_FormGen_TP    
@BatchSize INT = 0    
AS      

DECLARE @Study INT, @Survey INT      
SET NOCOUNT ON    
      
EXEC SP_FG_Fix_RespCol      
      
exec sp_FG_FormGen_Pop_PreMailingWork_TP    
    
-- INSERT INTO FormGenLog(Survey_id, strSampleSurvey_nm, MailingStep_id, intSequence, datGenerated, Quantity)      
-- SELECT pm.Survey_id, ss.strSampleSurvey_nm, pm.MailingStep_id, ms.intSequence, GETDATE(), COUNT(*)      
-- FROM fg_preMailingWork pm, MailingStep ms, SampleSet ss      
-- WHERE pm.MailingStep_id=ms.MailingStep_id      
-- AND pm.SampleSet_id=ss.SampleSet_id      
-- GROUP BY pm.Survey_id, ss.strSampleSurvey_nm, pm.MailingStep_id, ms.intSequence      
    
-- MOD 1/20/04 SS (Changed FG_MailingWork from permanent tbl to #tbl)      
CREATE TABLE #FG_MailingWork (study_id INT, survey_id INT, samplepop_id INT, sampleset_id INT, pop_id INT, scheduledmailing_id INT, mailingstep_id INT,       
 methodology_id INT, overrideitem_id INT, poptable_nm CHAR(20), zipfield_nm CHAR(20), langfield_nm CHAR(20), zip3_cd CHAR(3), langid INT,       
 selcover_id INT, bitsurveyinline BIT, intintervaldays int, bitthankyouitem BIT, bitfirstsurvey BIT, bitsendsurvey BIT, nextmailingstep_id INT,       
 intoffsetdays INT, sentmail_id INT, questionform_id INT, batch_id INT, bitDone BIT DEFAULT 0, Priority_Flg TINYINT, zip5 INT, zip4 INT, employee_id INT, bitMockup BIT, strEmail VARCHAR(255))      
    
WHILE (SELECT COUNT(*) FROM FG_PreMailingWork_TP)>0      
  BEGIN      
  SELECT TOP 1 @Survey=Survey_id FROM FG_PreMailingWork_TP ORDER BY priority_flg, Survey_id      
  SELECT @Study=Study_id FROM Survey_def WHERE Survey_id=@Survey      
    
       
 -- print 'beginning batch ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,GETDATE(),113)      
 -- INSERT INTO formgenerror (ScheduledMailing_id,datgenerated,fgerrortype_id) values (@BatchSize,GETDATE(),1)      
       
-- MOD 1/20/04 SS (Changed FG_MailingWork reference from permanent tbl to #tbl)      
TRUNCATE TABLE #FG_MailingWork       

print '@study = ' + cast(@study as varchar)
print '@survey = ' + cast(@survey as varchar)
       
--  SET ROWCOUNT @BatchSize      
  INSERT INTO #FG_MailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id,       
     Methodology_id, OverrideItem_id, langid, bitSurveyInLine, bitThankYouItem, bitFirstSurvey, bitSendSurvey, intOffsetDays, Priority_Flg,       
     Zip5, Zip4, employee_id, bitMockup, strEmail)    
  SELECT PM.Study_id, PM.Survey_id, PM.SamplePop_id, PM.SampleSet_id, PM.Pop_id, PM.ScheduledMailing_id, PM.MailingStep_id,       
     PM.Methodology_id, PM.OverrideItem_id, [language], 0, 0, 0, 0, 0, PM.Priority_Flg, 
	 case when isnumeric(PM.Zip5)=1 then PM.Zip5 else null end as zip5, --DRM 7/6/2010
	 PM.Zip4, employee_id, bitMockup, strEmail    
  FROM   FG_PreMailingWork_TP PM      
  WHERE PM.Study_id=@Study      
  AND   PM.Survey_id=@Survey      
  ORDER BY PM.Priority_flg, PM.Survey_id, PM.Zip5, PM.Zip4, SamplePop_id      
--  SET ROWCOUNT 0         
  UPDATE STATISTICS #FG_MailingWork      
    
  DELETE FG_PreMailingWork_TP    
  FROM #FG_MailingWork mw, FG_PreMailingWork_TP pm      
  WHERE pm.ScheduledMailing_id=mw.ScheduledMailing_id      
       
 -- Delete the People on the 'Take Off Call List FROM #FG_MailingWork      
 -- We will first set the sentmail_id to -1 for the ScheduledMailing record      
    
/*    
-- Not Applicable for Test Prints 1/23/04 SS       
  UPDATE SCHM      
  SET SentMail_ID=-1      
  FROM ScheduledMailing SCHM, #FG_MailingWork M, TOCL       
  WHERE TOCL.Pop_id=M.Pop_id AND      
       TOCL.Study_id=M.Study_id AND      
       M.ScheduledMailing_ID=SCHM.ScheduledMailing_ID      
       
  DELETE      
  FROM  #FG_MailingWork       
  FROM  #FG_MailingWork M, TOCL      
  WHERE TOCL.Pop_id=M.Pop_id AND      
       TOCL.Study_id=M.Study_id      
       
 IF (SELECT COUNT(*) FROM #FG_MailingWork)=0      
 GOTO Completed      
*/    
       
-- Update the #FG_MailingWork with the rest of the attributes necessary to Form Gen      
   -- Call GetMailingAttributes(cn)      
  UPDATE #FG_MailingWork       
  SET    SelCover_id=MS1.SelCover_id,       
          bitSendSurvey=MS1.bitSendSurvey    
  FROM MailingStep MS1       
  WHERE #FG_MailingWork.MailingStep_id=MS1.MailingStep_id       
       
  UPDATE #FG_MailingWork       
  SET NextMailingStep_id=MS2.MailingStep_id       
  FROM MailingStep MS1, MailingStep MS2       
  WHERE #FG_MailingWork.MailingStep_id=MS1.MailingStep_id AND       
         MS1.Methodology_id=MS2.Methodology_id AND       
         MS1.intSequence+1=MS2.intSequence       
    
  EXEC SP_FG_FormGen_Sub @Study, @Survey, 1  -- "0" Indicates that Production FormGen is calling the subroutine, NOT FormGen_TP which passes "1" as the bitTP parameter.    
        
  -- Call AddPCLNeeded(cn)      
  EXEC SP_FG_Insert_PCLNeeded_TP    
  -- print 'ending batch    ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,GETDATE(),113)      
  -- INSERT INTO formgenerror (ScheduledMailing_id,datgenerated,fgerrortype_id) values (@BatchSize,GETDATE(),2)      
       
  END      
      
/*    
-- Not Applicable to TestPrints    
Completed:      
*/    
      
 -- Added 1/20/04 ss      
UPDATE stp SET stp.bitDone = 1 FROM Scheduled_TP stp, #FG_MailingWork mw WHERE stp.TP_id = mw.SentMail_id    
    
DROP TABLE #FG_MailingWork    
    
SET NOCOUNT OFF    
      
-- Added 8/19/2 BD  With the ability to generate multiple MailingSteps in a single night of generation,       
--  it is possible for the SamplePop to exist in multiple batches.      
-- This procedure moves them to the lowest batch_id for each SamplePop_id that is duplicated.      
      
/*    
-- Not Applicable to TestPrints    
EXEC SP_FG_Allign_PCLNeeded_Batches    
*/


