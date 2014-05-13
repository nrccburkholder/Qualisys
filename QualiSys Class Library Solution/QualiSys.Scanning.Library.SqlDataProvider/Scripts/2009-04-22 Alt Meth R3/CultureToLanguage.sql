---------------------------------------------------------------------------------------
--QSL_SelectCultureToLanguage
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectCultureToLanguage]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectCultureToLanguage]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllCultureToLanguages
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllCultureToLanguages]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllCultureToLanguages]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllCultureToLanguages]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT a.CultureLangID, a.CultureID, b.CultureCode, b.CultureDesc,
	a.LangID, c.Language, c.QualiSysLanguage
FROM [dbo].CultureToLanguages a inner join [dbo].Cultures b ON a.CultureID = b.CultureID
	inner join [dbo].Languages c ON a.LangID = c.LangID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectCultureToLanguageByCultureCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectCultureToLanguageByCultureCode]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectCultureToLanguageByCultureCode]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectCultureToLanguageByLanguageID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectCultureToLanguageByLanguageID]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectCultureToLanguageByLanguageID]
GO
CREATE PROCEDURE [dbo].[QSL_SelectCultureToLanguageByLanguageID]
@LangID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT a.CultureLangID, a.CultureID, b.CultureCode, b.CultureDesc,
	a.LangID, c.Language, c.QualiSysLanguage
FROM [dbo].CultureToLanguages a inner join [dbo].Cultures b ON a.CultureID = b.CultureID
	inner join [dbo].Languages c ON a.LangID = c.LangID
WHERE a.LangID = @LangID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

