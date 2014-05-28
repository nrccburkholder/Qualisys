CREATE PROCEDURE QCL_InsertSampleUnitService
@SampleUnit_id INT,
@Service_id INT, 
@AltService VARCHAR(50)=NULL
AS

INSERT INTO SampleUnitService (SampleUnit_id,Service_id,strAltService_nm,datLastUpdated)
SELECT @SampleUnit_id,@Service_id,@AltService,GETDATE()


