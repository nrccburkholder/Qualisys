CREATE PROCEDURE DBO.QCL_InsertSampleUnitLinking
@FromSampleUnitId INT,
@ToSampleUnitId INT
AS

INSERT INTO SampleUnitLinkage (SampleUnit_id, LinkSampleUnit_id) 
VALUES(@FromSampleUnitId,@ToSampleUnitId)


