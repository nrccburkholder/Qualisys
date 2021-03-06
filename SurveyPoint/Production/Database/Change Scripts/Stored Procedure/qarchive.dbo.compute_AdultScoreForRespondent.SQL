/****** Object:  StoredProcedure [dbo].[compute_AdultScoreForRespondent]    Script Date: 08/08/2006 15:57:43 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_AdultScoreForRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_AdultScoreForRespondent]
GO
/****** Object:  StoredProcedure [dbo].[compute_AdultScoreForRespondent]    Script Date: 08/08/2006 15:57:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_AdultScoreForRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE    PROCEDURE compute_AdultScoreForRespondent(@RespondentID int)
AS
BEGIN

-- Get survey id of the respondent
DECLARE @SurveyID int
SET @SurveyID = [dbo].GetRespondentSurveyID(@RespondentID) 

-- Check that respondent is in correct survey, if not correct survey - flag and exit routine
IF (@SurveyID NOT IN (11, 15, 16, 34))
	BEGIN
		EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = 1, @RespondentID = @RespondentID, @EventParameters = ''compute_AdultScoreForRespondent: Finalize routine not run for respondent. Does not belong to a listed survey.''
		RETURN	
	END

DECLARE @a      int             -- some of the effective colums to be pulled from the respondents table
DECLARE @b      int
DECLARE @c      int
DECLARE @d      int
DECLARE @e      int
DECLARE @f      int
DECLARE @g      int
DECLARE @h      int
DECLARE @noncontrib     int
DECLARE @other  int
DECLARE @none   int
DECLARE @predicted_expenditure  float(53)   -- the calculation

SET SELECT 
	@a = a,
	@b = b,
	@c = c,
	@d = d,
	@e = e,
	@f = f,
	@g = g,
	@h = h,
	@noncontrib = noncontrib,
	@other = other,
	@none = none,
	@predicted_expenditure = 
	        EXP(5.057 +
	        a * 0.370 +
	        b * 0.380 + 
	        c * 1.483 + 
	        d * 0.456 + 
	        e * 0.423 + 
	        f * 1.087 - 
	        g * 0.416 + 
	        h * 1.048)
FROM (
	/* This query looks at the respondent id and any perspective risk factors and then denormalizes the information
	so that one column is specified for each risk factor */
	SELECT r.respondentID,
		SUM(CASE riskFactorTypeID WHEN 1 THEN 1 ELSE 0 END) a,
		SUM(CASE riskFactorTypeID WHEN 2 THEN 1 ELSE 0 END) b,
		SUM(CASE riskFactorTypeID WHEN 3 THEN 1 ELSE 0 END) c,
		SUM(CASE riskFactorTypeID WHEN 4 THEN 1 ELSE 0 END) d,
		SUM(CASE riskFactorTypeID WHEN 5 THEN 1 ELSE 0 END) e,
		SUM(CASE riskFactorTypeID WHEN 6 THEN 1 ELSE 0 END) f,
		CASE SUM(CASE riskFactorTypeID WHEN 7 THEN 1 ELSE 0 END) WHEN 1 THEN 0 ELSE 1 END g,
		SUM(CASE riskFactorTypeID WHEN 8 THEN 1 ELSE 0 END) h,
		SUM(CASE riskFactorTypeID WHEN 9 THEN 1 ELSE 0 END) noncontrib,
		SUM(CASE riskFactorTypeID WHEN 10 THEN 1 ELSE 0 END) other,
		SUM(CASE riskFactorTypeID WHEN 11 THEN 1 ELSE 0 END) none
	FROM respondents r
		LEFT OUTER JOIN v_GHS_RespondentRiskFactors risk
		ON r.respondentid = risk.respondentid
	WHERE
		r.RespondentID=@RespondentID
		AND EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID IN (3002, 3012, 3022, 3032, 3035) AND EventLog.RespondentID = r.RespondentID)
		GROUP BY r.respondentID) a

print ''Respondent '' + convert(varchar(20),@RespondentId)

/* store risk score and risk percentile as respondent properties */
DECLARE  @property_value varchar(100)
SET @property_value = CAST(CAST(@predicted_expenditure AS decimal(9,0)) AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''PIE_SCORE'', @property_value
SET @property_value = CAST(CAST(dbo.fnGetRiskPercentile(@predicted_expenditure) AS decimal(9,0)) AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''RISK_PERCENTILE'', @property_value 

/* store results in RespondentRiskScores table */
IF EXISTS (SELECT 1 FROM respondentRiskScores WHERE RespondentID = @RespondentID)
BEGIN
	UPDATE respondentRiskScores SET
		 a = @a, b = @b, c = @c, d = @d, e = @e, f = @f, g = @g, h = @h,
		 noncontrib = @noncontrib, other = @other, none = @none,
		 predicted_expenditure = @predicted_expenditure
	WHERE respondentID = @respondentID
END
ELSE
BEGIN
	INSERT INTO respondentRiskScores(RespondentID,a,b,c,d,e,f,g,h,
	          noncontrib,other,none,
	          predicted_expenditure)
	VALUES (@RespondentID,@a,@b,@c,@d,@e,@f,@g,@h,
	          @noncontrib,@other,@none,
	          @predicted_expenditure)
END

END
' 
END
GO
