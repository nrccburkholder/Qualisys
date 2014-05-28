CREATE PROCEDURE [dbo].[QCL_DeleteClientGroup]
    @ClientGroupID INT
AS

IF EXISTS (SELECT * FROM Client WHERE ClientGroup_ID = @ClientGroupID) OR @ClientGroupID = -1
BEGIN
	RAISERROR ('The Client Group cannot be deleted because it contains Clients.', 18, 1)
END
ELSE
BEGIN
	DELETE ClientGroups
	WHERE ClientGroup_ID = @ClientGroupID
END


