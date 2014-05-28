CREATE PROCEDURE [dbo].[QSL_InsertHandEntry]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ItemNumber INT,
@LineNumber INT,
@HandEntryText VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_HandEntry (DL_LithoCode_ID, DL_Error_ID, QstnCore, ItemNumber, LineNumber, HandEntryText)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @QstnCore, @ItemNumber, @LineNumber, @HandEntryText)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


