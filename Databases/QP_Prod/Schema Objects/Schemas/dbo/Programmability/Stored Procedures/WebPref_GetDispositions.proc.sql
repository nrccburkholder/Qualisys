CREATE PROCEDURE WebPref_GetDispositions @Litho VARCHAR(20)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @Survey_id INT

SELECT @Survey_id=Survey_id
FROM SentMailing sm, MailingMethodology mm
WHERE strLithoCode=@Litho
AND sm.Methodology_id=mm.Methodology_id

--Check to see if the survey has multiple languages
IF (SELECT COUNT(*) FROM SurveyLanguage WHERE Survey_id=@Survey_id)>1

--If more than 1 language, we select all dispositions
SELECT Disposition_id, strDispositionLabel, Action_id
FROM Disposition
ELSE
--If only 1 language, we ignore Action_id=3(Regenerate diff language)
SELECT Disposition_id, strDispositionLabel, Action_id
FROM Disposition
WHERE Action_id<>3

SELECT strClient_nm, strStudy_nm, strSurvey_nm, strEmail
FROM Client c, Study s, Survey_def sd, Employee e
WHERE sd.Survey_id=@Survey_id
AND sd.Study_id=s.Study_id
AND s.ADEmployee_id=e.Employee_id
AND s.Client_id=c.Client_id

--Log it
INSERT INTO WebPrefLog (strLithoCode,Disposition_id,datLogged,strComment)
SELECT @Litho,-1,GETDATE(),'Got Dispositions'

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


