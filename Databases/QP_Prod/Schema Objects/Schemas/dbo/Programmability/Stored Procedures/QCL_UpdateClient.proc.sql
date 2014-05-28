CREATE PROCEDURE [dbo].[QCL_UpdateClient]
    @ClientId INT,
    @ClientName VARCHAR(40),
    @OrgClientName VARCHAR(40),
    @Active BIT,
    @ClientGroupID INT
AS

IF EXISTS (SELECT * FROM Client WHERE strClient_nm = @ClientName) AND @ClientName <> @OrgClientName
BEGIN
	RAISERROR ('The specified client name has already been used.', 18, 1)
END
ELSE
BEGIN
    IF @ClientGroupID = -1
        SET @ClientGroupID = NULL

	UPDATE Client 
	SET strClient_nm = @ClientName, 
	    Active = @Active, 
	    ClientGroup_ID = @ClientGroupID 
	WHERE Client_id = @ClientId
END


