CREATE PROCEDURE [dbo].[QSL_SelectCultureToLanguage]
@CultureLangID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT a.CultureLangID, a.CultureID, b.CultureCode, b.CultureDesc,
	a.LangID, c.Language, c.QualiSysLanguage
FROM [dbo].CultureToLanguages a inner join [dbo].Cultures b ON a.CultureID = b.CultureID
	inner join [dbo].Languages c ON a.LangID = c.LangID
WHERE CultureLangID = @CultureLangID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


