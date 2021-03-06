/****** Object:  StoredProcedure [dbo].[insert_SeniorHealthScores]    Script Date: 08/09/2006 16:45:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SeniorHealthScores]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_SeniorHealthScores]
GO
/****** Object:  StoredProcedure [dbo].[insert_SeniorHealthScores]    Script Date: 08/09/2006 16:45:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SeniorHealthScores]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[insert_SeniorHealthScores]
(
	@RespondentID int
)
 AS
BEGIN
	SET NOCOUNT ON

	DECLARE @result varchar(100)
	DECLARE @PraScore decimal(9,4)
	DECLARE @FrailtyScore decimal(9,4)
	DECLARE @DepressionScore int
	DECLARE @RedFlagFactors int
	DECLARE @PraFactors int
	DECLARE @FrailtyFactors int
	DECLARE @DepressionFactors int
	DECLARE @HighRisk tinyint

	SET @PraScore = NULL
	SET @FrailtyScore = NULL
	SET @DepressionScore  = NULL
	SET @HighRisk = 0

	-- get risk scores
	SET @result = dbo.GetRespondentPropertyValue(@RespondentID, ''PRA_SCORE'')
	IF ISNUMERIC(@result) = 1 SET @PraScore = CAST(@result as decimal(9,4))
	SET @result = dbo.GetRespondentPropertyValue(@RespondentID, ''FRAILTY_SCORE'') 
	IF ISNUMERIC(@result) = 1 SET @FrailtyScore = CAST(@result as decimal(9,4))
	SET @result = dbo.GetRespondentPropertyValue(@RespondentID, ''DEPRESSION_SCORE'') 
	IF ISNUMERIC(@result) = 1 SET @DepressionScore = CAST(@result as int)

	-- Is respondent high risk
	IF (ISNULL(@PraScore, 0) >= 0.4) OR (ISNULL(@FrailtyScore, 0) >= 0.5) SET @HighRisk = 1

	-- Count factors
	SET SELECT @RedFlagFactors = COUNT(*) FROM v_GHS_RespondentRiskFactors WHERE  (RespondentID = @RespondentID) AND (RiskFactorTypeId = 16)
	SET SELECT @PraFactors = COUNT(*) FROM v_GHS_RespondentRiskFactors WHERE  (RespondentID = @RespondentID) AND (RiskFactorTypeId = 13)
	SET SELECT @FrailtyFactors = COUNT(*) FROM v_GHS_RespondentRiskFactors WHERE  (RespondentID = @RespondentID) AND (RiskFactorTypeId = 15)
	SET SELECT @DepressionFactors = COUNT(*) FROM v_GHS_RespondentRiskFactors WHERE  (RespondentID = @RespondentID) AND (RiskFactorTypeId = 14)

	-- update or insert scores
	IF (SELECT COUNT(*) FROM SeniorHealthScores WHERE RespondentID = @RespondentID) = 1
		UPDATE SeniorHealthScores SET PraScore = @PraScore, FrailtyScore = @FrailtyScore, DepressionScore = @DepressionScore, 
			RedFlagFactors= @RedFlagFactors, PraFactors = @PraFactors, FrailtyFactors = @FrailtyFactors, DepressionFactors = @DepressionFactors, 
			HighRisk = @HighRisk
			WHERE RespondentID = @RespondentID
	ELSE
		INSERT INTO SeniorHealthScores (RespondentID, PraScore, FrailtyScore, DepressionScore, RedFlagFactors, PraFactors, FrailtyFactors, DepressionFactors, HighRisk) 
			VALUES (@RespondentID, @PraScore, @FrailtyScore, @DepressionScore, @RedFlagFactors, @PraFactors, @FrailtyFactors, @DepressionFactors, @HighRisk)

	-- Set notify flag if respondent is high risk or has red flags
	IF (@HighRisk = 1 OR @RedFlagFactors > 0)
		    EXEC dbo.spSetRespondentProperty @RespondentID, ''NOTIFY_PCP'' , ''Y''
	ELSE
		    EXEC dbo.spSetRespondentProperty @RespondentID, ''NOTIFY_PCP'' , ''N''

	SET NOCOUNT OFF

END
' 
END
GO
