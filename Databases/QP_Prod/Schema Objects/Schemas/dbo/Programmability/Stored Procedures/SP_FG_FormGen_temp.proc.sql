CREATE procedure SP_FG_FormGen_temp
@batchsize int
as

declare @Study int, @Survey int
set nocount on

while (select count(*) from FG_PreMailingWork) > 0
begin
 set @survey = (select top 1 survey_id from FG_PreMailingWork order by priority_flg, survey_id)
 set @study = (select study_id from survey_def where survey_id = @survey)

-- print 'beginning batch ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,getdate(),113)
-- insert into formgenerror (scheduledmailing_id,datgenerated,fgerrortype_id) values (@batchsize,getdate(),1)

 truncate table FG_MailingWork 

 set rowcount @BatchSize
 INSERT INTO FG_MailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, 
    Methodology_id, OverrideItem_id, bitSurveyInLine, bitThankYouItem, bitFirstSurvey, bitSendSurvey, intOffsetDays, Priority_Flg, 
    Zip5, Zip4)
 SELECT PM.Study_id, PM.Survey_id, PM.SamplePop_id, PM.SampleSet_id, PM.Pop_id, PM.ScheduledMailing_id, PM.MailingStep_id, 
    PM.Methodology_id, PM.OverrideItem_id, 0, 0, 0, 0, 0, PM.Priority_Flg, PM.Zip5, PM.Zip4
 FROM   FG_PreMailingWork PM
 WHERE PM.Study_id = @study
 and   PM.Survey_id = @survey
 Order by PM.Zip5, PM.Zip4, samplepop_id
 set rowcount 0   
 UPDATE STATISTICS FG_MailingWork

 delete FG_PreMailingWork 
 from FG_MailingWork mw, FG_PreMailingWork pm
 where pm.scheduledmailing_id = mw.scheduledmailing_id

-- Delete the People on the 'Take Off Call List from FG_MailingWork
-- We will first set the sentmail_id to -1 for the scheduledmailing record

 UPDATE SCHM
 set SentMail_ID = -1
 FROM ScheduledMailing SCHM, FG_MailingWork M, TOCL 
 WHERE TOCL.Pop_id = M.Pop_id AND
      TOCL.Study_id = M.Study_id AND
      M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

 DELETE
 FROM  FG_MailingWork 
 FROM  FG_MailingWork M, TOCL
 WHERE TOCL.Pop_id = M.Pop_id AND
      TOCL.Study_id = M.Study_id

IF (select count(*) from FG_MailingWork) = 0
GOTO Completed

 -- Update the FG_MailingWork with the rest of the attributes necessary to Form Gen
  -- Call GetMailingAttributes(cn)
 UPDATE FG_MailingWork 
 SET    SelCover_id = MS1.SelCover_id, 
--         bitSurveyInLine = MS1.bitSurveyInLine, 
         bitSendSurvey = MS1.bitSendSurvey--, 
--         intIntervalDays = MS1.intIntervalDays, 
--         bitThankYouItem = MS1.bitThankYouItem, 
--         bitFirstSurvey = MS1.bitFirstSurvey 
 FROM MailingStep MS1 
 WHERE FG_MailingWork.MailingStep_id = MS1.MailingStep_id 

 UPDATE FG_MailingWork 
 SET NextMailingStep_id = MS2.MailingStep_id 
 FROM MailingStep MS1, MailingStep MS2 
 WHERE FG_MailingWork.MailingStep_id = MS1.MailingStep_id AND 
        MS1.Methodology_id = MS2.Methodology_id AND 
        MS1.intSequence + 1  = MS2.intSequence 

select @@options

  exec SP_FG_FormGen_Sub @Study, @Survey
 
-- Moved into SP_FG_FormGen_Sub 
/*
 -- Call AddNextMailings(cn, dFrmGenDate)
 INSERT INTO ScheduledMailing(MailingStep_id, SamplePop_id, Methodology_id, datGenerate)
 SELECT NextMailingStep_id, SamplePop_id, Methodology_id, '12/31/4172'
 FROM   FG_MailingWork
 WHERE  NextMailingStep_id IS NOT NULL AND
        OverrideItem_id IS NULL
*/

 -- Call AddPCLNeeded(cn)
 exec SP_FG_Insert_PCLNeeded
-- print 'ending batch    ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,getdate(),113)
-- insert into formgenerror (scheduledmailing_id,datgenerated,fgerrortype_id) values (@batchsize,getdate(),2)

end

Completed:

UPDATE STATISTICS SentMailing


