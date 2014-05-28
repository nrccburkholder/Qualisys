-- =====================================================================  
-- Author:  Jeffrey J. Fleming  
-- Create date: 08/18/2006  
-- Description: This procedure sets the UndeliverableDate and ScanBatch   
--              for a non-del survey.
-- MODIFIED: MWB 7/8/2009
--			 Changed ms.MailingStepMethod_id <> 1 to 
--			 ms.MailingStepMethod_id = 0 b/c we added new ID's to the 
--			 table and the logic should be ONLY IF MAIL.
-- =====================================================================  
CREATE PROCEDURE [dbo].[sp_SI_CDFSetUndeliverableDateNDL]   
 -- Add the parameters for the stored procedure here  
 @SentMailID int,   
 @UndeliverableDate datetime,   
 @ScanBatch varchar(100)  
AS  
  
--Setup the environment  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
--Update the undeliverable date  
UPDATE SentMailing   
SET datUndeliverable = @UndeliverableDate  
WHERE SentMail_id = @SentMailID  
  
--Update the scan batch  
UPDATE QuestionForm   
SET strScanBatch = @ScanBatch  
WHERE SentMail_id = @SentMailID  
      
--Remove respondant from Scheduled Mailing  
DELETE sm   
FROM ScheduledMailing sm, MailingStep ms   
WHERE sm.MailingStep_id = ms.MailingStep_id   
  AND SamplePop_Id IN   
      (SELECT SamplePop_Id   
       FROM ScheduledMailing   
       WHERE SentMail_Id = @SentMailID  
      )   
  AND SentMail_Id IS NULL   
  AND ms.MailingStepMethod_id = 0 
  
--Reset the environment  
SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


