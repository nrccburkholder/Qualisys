CREATE PROCEDURE [dbo].[QCL_UpdateHHCAHPSDisposition]
@HHCAHPSDispositionID INT,
@Disposition_ID INT,
@HHCAHPSValue VARCHAR(5),
@HHCAHPSHierarchy INT,
@HHCAHPSDesc VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].HHCAHPSDispositions SET
	Disposition_ID = @Disposition_ID,
	HHCAHPSValue = @HHCAHPSValue,
	HHCAHPSHierarchy = @HHCAHPSHierarchy,
	HHCAHPSDesc = @HHCAHPSDesc
WHERE HHCAHPSDispositionID = @HHCAHPSDispositionID

SET NOCOUNT OFF


