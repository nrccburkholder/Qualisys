CREATE PROCEDURE [dbo].[QSL_DeletePopMapping]
    @DL_PopMapping_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_PopMapping
WHERE DL_PopMapping_ID = @DL_PopMapping_ID

SET NOCOUNT OFF


