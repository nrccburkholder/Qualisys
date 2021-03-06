/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesFrailty]    Script Date: 08/09/2006 09:18:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesFrailty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScorePercentilesFrailty]
GO
/****** Object:  StoredProcedure [dbo].[update_ScorePercentilesFrailty]    Script Date: 08/09/2006 09:18:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentilesFrailty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[update_ScorePercentilesFrailty] AS
BEGIN

DELETE FROM ScorePercentiles WHERE score_type = ''FRAILTY''

INSERT INTO ScorePercentiles(score_type, score_value, respondent_count, percentile)
SELECT     ''FRAILTY'' as score_type, shs.FrailtyScore AS score_value, COUNT(shs.RespondentID) AS respondent_count, 0 as percentile
FROM         SeniorHealthScores shs INNER JOIN
                      Respondents r ON shs.RespondentID = r.RespondentID INNER JOIN
                      SurveyInstances si ON r.SurveyInstanceID = si.SurveyInstanceID INNER JOIN
                      EventLog el ON r.RespondentID = el.RespondentID AND si.SurveyInstanceID = el.SurveyInstanceID
WHERE     (si.SurveyID IN (24, 8, 31)) AND (el.EventID IN (3012, 3022, 3032, 3035)) AND (shs.FrailtyScore IS NOT NULL)
GROUP BY shs.FrailtyScore

EXEC update_ScorePercentiles ''FRAILTY''

END

' 
END
GO
