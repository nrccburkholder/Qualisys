CREATE PROCEDURE QCL_DeleteSampleUnitService
@SampleUnit_id INT
AS

DELETE SampleUnitService
WHERE SampleUnit_id=@SampleUnit_id


