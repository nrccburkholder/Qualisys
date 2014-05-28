CREATE PROCEDURE QCL_DeleteClient
@ClientId INT
AS

IF EXISTS (SELECT * FROM Study WHERE Client_id=@ClientId)
BEGIN
	RAISERROR ('The client cannot be deleted because it contains studies.', 18, 1)
END
ELSE
BEGIN
	DELETE ClientSUFacilityLookup
	WHERE Client_id=@ClientId

	DELETE Client
	WHERE Client_id=@ClientId
END


