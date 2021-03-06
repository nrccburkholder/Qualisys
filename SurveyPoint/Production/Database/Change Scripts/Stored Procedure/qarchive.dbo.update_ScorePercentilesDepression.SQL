/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesDepression]    Script Date: 08/09/2006 09:18:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesDepression]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScorePercentilesDepression]
GO
/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesDepression]    Script Date: 08/09/2006 09:18:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesDepression]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[update_ScorePercentilesDepression] AS
BEGIN

DELETE FROM ScorePercentiles WHERE score_type = ''DEPRESSION''

INSERT INTO ScorePercentiles(score_type, score_value, respondent_count, percentile)
SELECT     ''DEPRESSION'' as score_type, shs.DepressionScore AS score_value, COUNT(shs.RespondentID) AS respondent_count, 0 as percentile
FROM         SeniorHealthScores shs INNER JOIN
                      Respondents r ON shs.RespondentID = r.RespondentID INNER JOIN
                      SurveyInstances si ON r.SurveyInstanceID = si.SurveyInstanceID INNER JOIN
                      EventLog el ON r.RespondentID = el.RespondentID AND si.SurveyInstanceID = el.SurveyInstanceID
WHERE     (si.SurveyID IN (24, 8, 31)) AND (el.EventID IN (3012, 3022, 3032, 3035)) AND (shs.DepressionScore IS NOT NULL)
GROUP BY shs.DepressionScore

EXEC update_ScorePercentiles ''DEPRESSION''

END
' 
END
GO
