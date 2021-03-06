/****** Object:  StoredProcedure [dbo].[update_ScorePercentiles]    Script Date: 08/09/2006 09:20:42 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentiles]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScorePercentiles]
GO
/****** Object:  StoredProcedure [dbo].[update_ScorePercentiles]    Script Date: 08/09/2006 09:20:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScorePercentiles]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[update_ScorePercentiles] 
(
	@score_type varchar(100)
)
AS
BEGIN

DECLARE @score_value decimal(18, 4)
DECLARE @respondent_count int
DECLARE @respondent_cumulative_count int
DECLARE @percentile decimal(9, 4)
DECLARE @total_count int

-- initialize values
SET @respondent_cumulative_count = 0
SET SELECT @total_count = SUM(respondent_count) FROM ScorePercentiles WHERE score_type = @score_type

-- setup cusor
DECLARE score_cusor CURSOR FOR
	SELECT score_value, respondent_count FROM ScorePercentiles 
	WHERE score_type = @score_type
	ORDER BY score_value

OPEN score_cusor

FETCH NEXT FROM score_cusor
INTO @score_value, @respondent_count

WHILE @@FETCH_STATUS = 0
BEGIN
	-- get cumulative count
	SET @respondent_cumulative_count = @respondent_cumulative_count + @respondent_count
	-- get cumulative percentage
	SET @percentile = ((@respondent_cumulative_count * 1.0) / (@total_count * 1.0)) * 100.0
	-- update score percentile
	UPDATE ScorePercentiles SET percentile = @percentile WHERE score_type = @score_type AND score_value = @score_value
	-- get next score
	FETCH NEXT FROM score_cusor
	INTO @score_value, @respondent_count
END

CLOSE score_cusor
DEALLOCATE score_cusor

END
' 
END
GO
