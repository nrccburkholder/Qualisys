CREATE PROCEDURE [dbo].[QCL_UnassignFacilityFromClient]
@SUFacilityID INT,
@ClientID INT,
@IsPracticeSite bit = false
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

IF (@IsPracticeSite = 0)

	DELETE ClientSUFacilityLookup
	WHERE Client_id=@ClientID
	AND SUFacility_id=@SUFacilityID

ELSE --@IsPracticeSite = 1

	DELETE ClientPracticeSiteGroupLookup
	WHERE Client_id=@ClientID
	AND SiteGroup_id=@SUFacilityID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


