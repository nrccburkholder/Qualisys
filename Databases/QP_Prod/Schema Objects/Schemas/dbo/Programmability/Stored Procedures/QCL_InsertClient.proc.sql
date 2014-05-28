CREATE PROCEDURE [dbo].[QCL_InsertClient]
    @ClientName VARCHAR(40),
    @Active BIT, 
    @ClientGroupID INT
AS

IF EXISTS (SELECT * FROM Client WHERE strClient_nm = @ClientName)
BEGIN
	RAISERROR ('The specified client name already exists.', 18, 1)
END
ELSE
BEGIN
    IF @ClientGroupID = -1
        SET @ClientGroupID = NULL
        
	INSERT INTO Client (strClient_nm, Active, ClientGroup_ID)
	VALUES(@ClientName, @Active, @ClientGroupID)

	SELECT SCOPE_IDENTITY()
END


