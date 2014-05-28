CREATE PROCEDURE [dbo].[QSL_SelectTranslationModuleMappings]
    @TranslationModuleID INT
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the resultset
SELECT TranslationModuleMapping_ID, OrigColumnName, NRCColumnName, SchemaFormat
FROM DL_TranslationModuleMapping
WHERE TranslationModule_ID = @TranslationModuleID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


