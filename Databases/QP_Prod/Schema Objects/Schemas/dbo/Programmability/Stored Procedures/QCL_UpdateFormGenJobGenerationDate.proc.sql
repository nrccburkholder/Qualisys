CREATE PROCEDURE QCL_UpdateFormGenJobGenerationDate  
@SurveyID INT,   
@MailingStepID INT,  
@datGenerate DATETIME,   
@NewdatGenerate DATETIME  
  
AS    
  
SELECT @NewdatGenerate=CONVERT(DATETIME,CONVERT(VARCHAR(10),@NewdatGenerate,120))  
  
CREATE TABLE #schm (ScheduledMailing_id INT)    
    
INSERT INTO #schm    
SELECT ScheduledMailing_id    
FROM ScheduledMailing schm, MailingStep ms    
WHERE ms.Survey_id=@SurveyID  
AND ms.MailingStep_id=schm.MailingStep_id  
AND datGenerate=@datGenerate  
AND ms.mailingstep_id=@mailingstepID  

--adding logging b/c josh reporting app is setting survey's to the wrong date (IE not the date entered)
insert into UpdateFormGenJobGenerationDate_log (Survey_ID, MailingStep_ID,CurrentDatGenerate , NewDatGenerate)
Select @SurveyID as Survey_ID, @MailingStepID as MailingStep_ID, @datGenerate as CurrentDatGenerate, @NewdatGenerate as NewDatGenerate
    
BEGIN TRAN    
    
UPDATE schm    
SET datGenerate=@NewdatGenerate    
FROM #schm t, ScheduledMailing schm    
WHERE t.ScheduledMailing_id = schm.ScheduledMailing_id    
    
IF @@ERROR <> 0    
BEGIN    
 ROLLBACK TRAN    
 RAISERROR('Error updated the generation date.',18,1)  
 RETURN    
END    
    
COMMIT TRAN    
    
DROP TABLE #schm


