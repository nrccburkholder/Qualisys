CREATE PROCEDURE [dbo].[QSL_SelectCultureToLanguageByCultureCode]
@CultureCode VARCHAR(10)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT a.CultureLangID, a.CultureID, b.CultureCode, b.CultureDesc,
	a.LangID, c.Language, c.QualiSysLanguage
FROM [dbo].CultureToLanguages a inner join [dbo].Cultures b ON a.CultureID = b.CultureID
	inner join [dbo].Languages c ON a.LangID = c.LangID
WHERE b.CultureCode = @CultureCode

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


