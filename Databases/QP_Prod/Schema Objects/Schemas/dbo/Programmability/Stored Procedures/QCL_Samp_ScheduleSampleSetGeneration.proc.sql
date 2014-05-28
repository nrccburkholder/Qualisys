/*
Business Purpose: 

This procedure schedules a sample set for survey generation.

Created:  1/31/2006 By Brian Dohmen

Modified:

*/   
CREATE PROCEDURE QCL_Samp_ScheduleSampleSetGeneration  
@SampleSetId INT,  
@GenerationDate DATETIME  
AS  
   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
   
IF EXISTS (SELECT *   
           FROM SamplePop sp, ScheduledMailing schm   
           WHERE sp.SampleSet_id=@SampleSetID   
           AND sp.SamplePop_id=schm.SamplePop_id)  
BEGIN  
   
   RAISERROR ('This sample set has already been scheduled.', 18, 1)  
   RETURN  
   
END  
   
BEGIN TRANSACTION  
   
INSERT INTO ScheduledMailing (MailingStep_id,SamplePop_id,OverRideItem_id,SentMail_id,Methodology_id,datGenerate)  
SELECT ms.MailingStep_id,sp.SamplePop_id,NULL,NULL,ms.Methodology_id,@GenerationDate  
FROM SampleSet ss, SamplePop sp, MailingStep ms, MailingMethodology mm  
WHERE ss.SampleSet_id=@SampleSetID  
AND ss.SampleSet_id=sp.SampleSet_id  
AND ss.Survey_id=mm.Survey_id  
AND mm.bitActiveMethodology=1  
AND mm.Methodology_id=ms.Methodology_id  
and ms.intSequence=1  
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
UPDATE SampleSet   
SET datScheduled=@GenerationDate  
WHERE SampleSet_id=@SampleSetID  
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
COMMIT TRANSACTION  
   
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


