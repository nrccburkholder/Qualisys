CREATE PROCEDURE [dbo].[QCL_UpdateHCAHPSDisposition]
@HCAHPSDispositionID INT,
@Disposition_ID INT,
@HCAHPSValue VARCHAR(2),
@HCAHPSHierarchy INT,
@HCAHPSDesc VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].HCAHPSDispositions SET
	Disposition_ID = @Disposition_ID,
	HCAHPSValue = @HCAHPSValue,
	HCAHPSHierarchy = @HCAHPSHierarchy,
	HCAHPSDesc = @HCAHPSDesc
WHERE HCAHPSDispositionID = @HCAHPSDispositionID

SET NOCOUNT OFF


