---------------------------------------------------------------------------------------
--QSL_SelectComment
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectComment]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectComment]
GO
CREATE PROCEDURE [dbo].[QSL_SelectComment]
@DataLoadCmnt_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DataLoadCmnt_ID, DL_LithoCode_ID, DL_Error_ID, CmntNumber, cmntText, bitSubmitted
FROM [dbo].DL_Comments
WHERE DataLoadCmnt_ID = @DataLoadCmnt_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllComments
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllComments]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllComments]
GO
---------------------------------------------------------------------------------------
--QSL_SelectCommentsByLithoCode_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectCommentsByLithoCodeId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectCommentsByLithoCodeId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectCommentsByLithoCodeId]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DataLoadCmnt_ID, DL_LithoCode_ID, DL_Error_ID, CmntNumber, cmntText, bitSubmitted
FROM DL_Comments
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectCommentsByErrorId
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectCommentsByErrorId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectCommentsByErrorId]
GO
---------------------------------------------------------------------------------------
--QSL_InsertComment
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertComment]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertComment]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_UpdateComment
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateComment]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateComment]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_DeleteComment
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteComment]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteComment]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteComment]
@DataLoadCmnt_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_Comments
WHERE DataLoadCmnt_ID = @DataLoadCmnt_ID

SET NOCOUNT OFF
GO

