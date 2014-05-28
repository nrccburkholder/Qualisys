CREATE PROCEDURE [dbo].[QSL_DeleteTranslationModule]
@TranslationModule_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_TranslationModules
WHERE TranslationModule_ID = @TranslationModule_ID

SET NOCOUNT OFF


