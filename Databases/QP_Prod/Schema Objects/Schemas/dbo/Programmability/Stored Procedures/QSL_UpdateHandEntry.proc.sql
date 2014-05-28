CREATE PROCEDURE [dbo].[QSL_UpdateHandEntry]
@DL_HandEntry_ID INT,
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ItemNumber INT,
@LineNumber INT,
@HandEntryText VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].DL_HandEntry SET
    DL_LithoCode_ID = @DL_LithoCode_ID,
    DL_Error_ID = @DL_Error_ID,
    QstnCore = @QstnCore,
    ItemNumber = @ItemNumber,
    LineNumber = @LineNumber,
    HandEntryText = @HandEntryText
WHERE DL_HandEntry_ID = @DL_HandEntry_ID

SET NOCOUNT OFF


