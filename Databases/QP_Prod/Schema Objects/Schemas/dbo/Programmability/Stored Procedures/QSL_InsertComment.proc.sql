CREATE PROCEDURE [dbo].[QSL_InsertComment]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@CmntNumber INT,
@CmntText1 VARCHAR(6000),
@CmntText2 VARCHAR(6000),
@bitSubmitted BIT
AS

SET NOCOUNT ON

--Declare required variables
DECLARE @TextPtr VARBINARY(16)
DECLARE @CmntID  INT

--Insert the record with the first chunck of the comment
INSERT INTO [dbo].DL_Comments (DL_LithoCode_ID, DL_Error_ID, CmntNumber, CmntText, bitSubmitted)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @CmntNumber, @CmntText1, @bitSubmitted)

--Get the new ID
SET @CmntID = SCOPE_IDENTITY()

--Get the text pointer for the text column
SELECT @TextPtr = TEXTPTR(CmntText)
FROM [dbo].DL_Comments
WHERE DataLoadCmnt_ID = @CmntID

--Append the remaining chunck of the comment
UPDATETEXT [dbo].DL_Comments.CmntText @TextPtr NULL NULL WITH LOG @CmntText2

--Return the new ID
SELECT @CmntID

SET NOCOUNT OFF


