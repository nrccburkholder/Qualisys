CREATE PROCEDURE [dbo].[QCL_InsertSampleSetMedicareCalcLookup]  
@Sampleset_ID INT,  
@Sampleunit_ID INT,  
@MedicareReCalcLog_ID INT  
AS  
  
SET NOCOUNT ON  
  
INSERT INTO [dbo].SampleSetMedicareCalcLookup (Sampleset_ID, Sampleunit_ID, MedicareReCalcLog_ID)  
VALUES (@Sampleset_ID, @Sampleunit_ID, @MedicareReCalcLog_ID)  
  
SELECT SCOPE_IDENTITY()  
  
SET NOCOUNT OFF


