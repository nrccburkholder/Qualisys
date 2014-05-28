CREATE PROCEDURE WebPref_SelectAvailableLangs @Litho VARCHAR(20) 
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT WebLanguageLabel Language, l.LangID
FROM Languages l, SurveyLanguage sl, Survey_def sd, MailingMethodology mm, SentMailing sm
WHERE sm.strLithoCode=@Litho
AND sm.Methodology_id=mm.Methodology_id
AND mm.Survey_id=sd.Survey_id
AND sd.Survey_id=sl.Survey_id
AND sl.LangID=l.LangID

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


