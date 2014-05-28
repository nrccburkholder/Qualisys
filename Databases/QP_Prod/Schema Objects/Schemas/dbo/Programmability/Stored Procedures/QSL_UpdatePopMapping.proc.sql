CREATE PROCEDURE [dbo].[QSL_UpdatePopMapping]
    @DL_PopMapping_ID INT,
    @DL_LithoCode_ID  INT,
    @DL_Error_ID      INT,
    @QstnCore         INT,
    @PopMappingText   VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].DL_PopMapping SET
	DL_LithoCode_ID = @DL_LithoCode_ID,
	DL_Error_ID = @DL_Error_ID,
	QstnCore = @QstnCore,
	PopMappingText = @PopMappingText
WHERE DL_PopMapping_ID = @DL_PopMapping_ID

SET NOCOUNT OFF


