CREATE PROCEDURE [dbo].[QSL_SelectTranslationModuleMappingRecodes]
    @TranslationModuleMappingID INT
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT OrigValue, NewValue
FROM DL_TranslationModuleMappingRecode
WHERE TranslationModuleMapping_ID = @TranslationModuleMappingID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


