CREATE PROCEDURE [dbo].[QSL_InsertPopMapping]
    @DL_LithoCode_ID INT,
    @DL_Error_ID     INT,
    @QstnCore        INT,
    @PopMappingText  VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_PopMapping (DL_LithoCode_ID, DL_Error_ID, QstnCore, PopMappingText)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @QstnCore, @PopMappingText)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


