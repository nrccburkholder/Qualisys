USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SupplementalQuestionCount]    Script Date: 8/13/2014 1:38:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

Declare @SupplementalQuestions int

select @SupplementalQuestions = count(distinct qstncore)
				   FROM sel_qstns sq inner join survey_def sd on sq.SURVEY_ID = sd.SURVEY_ID
					 WHERE sq.Survey_id = @Survey_id
					 and subtype in (1,4) --questions/comment boxes
					 and qstncore > 0
					 and qstncore not in (select qstncore from SurveyTypeQuestionMappings where surveytype_id = sd.SurveyType_id)
	IF (@SupplementalQuestions > 15)
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has more than 15 supplemental questions.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has 15 or fewer supplemental questions.'

SELECT * FROM #M

DROP TABLE #M
