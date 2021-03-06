/****** Object:  StoredProcedure [dbo].[compute_SeniorScoresForRespondent]    Script Date: 08/08/2006 15:58:43 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_SeniorScoresForRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_SeniorScoresForRespondent]
GO
/****** Object:  StoredProcedure [dbo].[compute_SeniorScoresForRespondent]    Script Date: 08/08/2006 15:58:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_SeniorScoresForRespondent]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[compute_SeniorScoresForRespondent] (
	@RespondentID int
)
AS
BEGIN

/* get scores */
DECLARE @PraScore decimal(9,4)
DECLARE @DepressionScore int
DECLARE @FrailtyScore decimal(9,4)

SET SELECT 	@PraScore = dbo.senior_GetPraScore(@RespondentID, GETDATE()),
		@DepressionScore = dbo.senior_GetDepressionScore(@RespondentID), 
		@FrailtyScore = dbo.senior_GetFrailtyScore(@RespondentID, GETDATE())

/* store scores as respondent properties */
DECLARE  @property_value varchar(100)
SET @property_value = CAST(@PraScore AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''PRA_SCORE'', @property_value
SET @property_value = CAST(@DepressionScore AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''DEPRESSION_SCORE'', @property_value 
SET @property_value = CAST(@FrailtyScore AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''FRAILTY_SCORE'', @property_value 

/* store scoring percentiles */
SET @property_value = CAST(dbo.GetScorePercentile(''PRA'', @PraScore) AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''PRA_PERCENTILE'', @property_value
SET @property_value = CAST(dbo.GetScorePercentile(''DEPRESSION'', @DepressionScore) AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''DEPRESSION_PERCENTILE'', @property_value 
SET @property_value = CAST(dbo.GetScorePercentile(''FRAILTY'', @FrailtyScore) AS varchar(100))
IF @property_value IS NOT NULL EXEC dbo.spSetRespondentProperty @RespondentID, ''FRAILTY_PERCENTILE'', @property_value 

END
' 
END
GO
