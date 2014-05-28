/*
Business Purpose: 

This procedure unschedules a sample set for survey generation.

Created:  1/31/2006 By Brian Dohmen

Modified:

*/   
CREATE PROCEDURE QCL_Samp_UnscheduleSampleSetGeneration
@SampleSetId INT
AS
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
 
IF EXISTS (SELECT * FROM SamplePop sp, ScheduledMailing schm
WHERE sp.SampleSet_id=@SampleSetID
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id IS NOT NULL)
 
BEGIN
 
   RAISERROR ('This sample set cannot be unscheduled because it has already been generated.', 18, 1)
   RETURN
 
END
 
BEGIN TRANSACTION
 
DELETE schm
FROM SamplePop sp, ScheduledMailing schm
WHERE sp.SampleSet_id=@SampleSetID
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id IS NULL
 
IF @@ERROR<>0
BEGIN
   ROLLBACK TRANSACTION
   RAISERROR ('A database error occurred while attempting to unschedule the sample set.  The sampleset was not unscheduled.', 18, 1)
   RETURN
END
 
UPDATE SampleSet
SET datScheduled=NULL
WHERE SampleSet_id=@SampleSetID
 
IF @@ERROR<>0
BEGIN
   ROLLBACK TRANSACTION
   RAISERROR ('A database error occurred while attempting to unschedule the sample set.  The sampleset was not unscheduled.', 18, 1)
   RETURN
END
 
COMMIT TRANSACTION
 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


