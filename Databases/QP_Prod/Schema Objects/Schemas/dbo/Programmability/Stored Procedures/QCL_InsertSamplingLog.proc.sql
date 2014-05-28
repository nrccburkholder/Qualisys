CREATE PROCEDURE [dbo].[QCL_InsertSamplingLog]        
    @SampleSet_id              INT,        
    @StepName                  VARCHAR(50),        
    @Occurred                  DATETIME,        
    @SQLCode                   VARCHAR(MAX)
AS

INSERT INTO SamplingLog (SampleSet_id, StepName, Occurred, SQLCode) 
VALUES (@SampleSet_id, @StepName, @Occurred, @SQLCode)


