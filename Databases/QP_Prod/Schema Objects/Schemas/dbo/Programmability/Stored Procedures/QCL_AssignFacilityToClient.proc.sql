CREATE PROCEDURE [dbo].[QCL_AssignFacilityToClient]
@SUFacilityID INT,
@ClientID INT,
@IsPracticeSite bit = false
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

EXEC QCL_UnassignFacilityFromClient @SUFacilityID, @ClientID

IF (@IsPracticeSite = 0)

	INSERT INTO ClientSUFacilityLookup (Client_id, SUFacility_id)
	SELECT @ClientID, @SUFacilityID

Else --@IsPracticeSite = 1

	INSERT INTO ClientPracticeSiteGroupLookup (Client_id, SiteGroup_id )
	SELECT @ClientID, @SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


