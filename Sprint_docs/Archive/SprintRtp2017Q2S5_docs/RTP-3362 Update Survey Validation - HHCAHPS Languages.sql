USE [QP_Prod]
GO
/* SP modification history
Modified 6/21/2017 Jing F. - RTP-3362, Update Survey Validation - HHCAHPS Languages
*/

ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
    @Survey_id INT
AS
BEGIN
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		SET NOCOUNT ON

		DECLARE @SurveyTypeDescription VARCHAR(20), @study_ID INT

		SELECT @SurveyTypeDescription = surveyType.SurveyType_dsc, @study_ID = SURVEY_DEF.study_ID
		FROM SURVEY_DEF INNER JOIN surveyType ON SURVEY_DEF.SurveyType_ID = surveyType.SurveyType_ID
		WHERE SURVEY_DEF.SURVEY_ID = @Survey_id AND surveyType.CAHPSType_id IS NOT NULL
		IF @SurveyTypeDescription IS NULL 
				RETURN

		--check to make sure only english and/or spanish is used on HHACAHPS survey. If hcahps spanish is used, give warning message
		--0=Passed,1=Error,2=Warning
		IF (EXISTS (SELECT [LANGUAGE] FROM SEL_QSTNS WHERE SURVEY_ID = @Survey_id AND [LANGUAGE] NOT IN (1,2,19)))
		BEGIN
				SELECT DISTINCT 1 AS Error, l.Language + ' is not a valid Language for a HHCAHPS survey' AS strMessage
				FROM Languages l INNER JOIN SEL_QSTNS sq ON l.LangID = sq.[LANGUAGE]
				WHERE sq.SURVEY_ID = @Survey_id AND  l.LangID NOT IN (1,2,19)
		END
		ELSE
		 BEGIN
				SELECT DISTINCT 2 AS Error,  'Survey uses HCAHPS Spanish. Please use Spanish. ' AS strMessage
				FROM Languages l INNER JOIN SEL_QSTNS sq ON l.LangID = sq.[LANGUAGE]
				WHERE  sq.SURVEY_ID = @Survey_id AND l.LangID=19
		END

		SET NOCOUNT OFF
		SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
