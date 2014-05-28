CREATE PROCEDURE [dbo].[QSL_UpdateComment]
@DataLoadCmnt_ID INT,
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

--Update the record with the first chunck of the comment
UPDATE [dbo].DL_Comments 
SET	DL_LithoCode_ID = @DL_LithoCode_ID,
	DL_Error_ID = @DL_Error_ID,
	CmntNumber = @CmntNumber,
	CmntText = @CmntText1,
	bitSubmitted = @bitSubmitted
WHERE DataLoadCmnt_ID = @DataLoadCmnt_ID

--Get the text pointer for the text column
SELECT @TextPtr = TEXTPTR(CmntText)
FROM [dbo].DL_Comments
WHERE DataLoadCmnt_ID = @DataLoadCmnt_ID

--Append the remaining chunck of the comment
UPDATETEXT [dbo].DL_Comments.CmntText @TextPtr NULL NULL WITH LOG @CmntText2

SET NOCOUNT OFF


