/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesPra]    Script Date: 08/09/2006 09:18:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesPra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScorePercentilesPra]
GO
/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesPra]    Script Date: 08/09/2006 09:18:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesPra]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[update_ScorePercentilesPra] AS
BEGIN

DELETE FROM ScorePercentiles WHERE score_type = ''PRA''

INSERT INTO ScorePercentiles(score_type, score_value, respondent_count, percentile)
SELECT     ''PRA'' as score_type, shs.PraScore AS score_value, COUNT(shs.RespondentID) AS respondent_count, 0 as percentile
FROM         SeniorHealthScores shs INNER JOIN
                      Respondents r ON shs.RespondentID = r.RespondentID INNER JOIN
                      SurveyInstances si ON r.SurveyInstanceID = si.SurveyInstanceID INNER JOIN
                      EventLog el ON r.RespondentID = el.RespondentID AND si.SurveyInstanceID = el.SurveyInstanceID
WHERE     (si.SurveyID IN (24, 8, 31)) AND (el.EventID IN (3012, 3022, 3032, 3035)) AND (shs.PraScore IS NOT NULL)
GROUP BY shs.PraScore

EXEC update_ScorePercentiles ''PRA''

END
' 
END
GO
