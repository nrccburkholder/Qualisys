CREATE PROCEDURE QCL_AllowDeleteFacility
@FacilityId INT
AS

--Return 1 if facility can be deleted otherwise return 0
IF EXISTS (SELECT * FROM SampleUnit WHERE SUFacility_id = @FacilityId)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT 1
END


