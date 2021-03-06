/****** Object:  StoredProcedure [dbo].[calc_FileGrowthRate]    Script Date: 08/08/2006 14:38:47 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[calc_FileGrowthRate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[calc_FileGrowthRate]
GO
/****** Object:  StoredProcedure [dbo].[calc_FileGrowthRate]    Script Date: 08/08/2006 14:38:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[calc_FileGrowthRate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'










CREATE          PROCEDURE [dbo].[calc_FileGrowthRate]
(
	@FileName nvarchar(500), 
	@GrowthRate float output,
	@DaysHistory int
)
AS
BEGIN 
/*
Calculates the daily growth rate for a database file using linear regression
@FileName: Database file name
Returns the file growth rate in MB per day
*/
	DECLARE @date_avg float	-- avg of date
	DECLARE @size_avg float	-- avg of used file size
	DECLARE @sum_sqr_dx float	-- sum of the square of dx

	CREATE TABLE #FileSizeGrowthRate
	(
		x int, 			-- x, date convert to day from start date
		y float,		-- y, the file size, what is being predicted
		dx float,		-- x - avg of x
		dy float,		-- y - avg of y
		sqr_dx float, 		-- square of dx
		prod_dx_dy float	-- product of dx and dy
	)

	-- insert raw data into tmp table
	INSERT INTO #FileSizeGrowthRate ( x, y)
	SELECT DATEDIFF( day, GETDATE(), StatusDate), UsageSizeMB FROM DbFileSizeLog WHERE Name = @FileName
		AND StatusDate >= DATEADD(day, -1 * @DaysHistory, GETDATE())

	-- calculate avgs
	SET @date_avg =  (SELECT CAST(SUM( x * 1.) / COUNT(*) AS float) FROM #FileSizeGrowthRate)
	SET @size_avg =  (SELECT CAST( SUM( y ) / COUNT(*) AS float) FROM #FileSizeGrowthRate)

	-- calculate deltas
	UPDATE #FileSizeGrowthRate SET dx = CAST(x as float) - @date_avg, dy = y - @size_avg

	-- calculate sqr_dx and prod_dx_dy
	UPDATE #FileSizeGrowthRate SET sqr_dx = SQUARE(dx), prod_dx_dy = dx * dy

	SET @sum_sqr_dx = (SELECT SUM( sqr_dx ) FROM #FileSizeGrowthRate )

	IF @sum_sqr_dx > 0 
		-- calculate b, the growth rate
		SET @GrowthRate =  ( SELECT SUM( prod_dx_dy ) / SUM( sqr_dx ) FROM #FileSizeGrowthRate )
	ELSE
		-- zero growth
		SET @GrowthRate = 0
	
	-- For debugging
	--SELECT * FROM #FileSizeGrowthRate
	--SELECT @date_avg, @size_avg
	--SELECT @GrowthRate AS DailyGrowthRateMB

	DROP TABLE #FileSizeGrowthRate 

	RETURN
END

' 
END
GO
