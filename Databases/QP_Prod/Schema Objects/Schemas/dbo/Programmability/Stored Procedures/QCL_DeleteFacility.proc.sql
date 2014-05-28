CREATE PROCEDURE [dbo].[QCL_DeleteFacility]
@FacilityId INT
AS


IF EXISTS (SELECT * FROM SampleUnit WHERE SUFacility_id = @FacilityId)
BEGIN
    RAISERROR ('The facility cannot be deleted because there are still sample units associated with it.', 18, 1)
END
ELSE
BEGIN
    --Delete any client mappings
    DELETE ClientSUFacilityLookup
    WHERE SUFacility_id = @FacilityId

    --Delete the facility
    DELETE SUFacility
    WHERE SUFacility_id = @FacilityId
END


