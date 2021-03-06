/****** Object:  StoredProcedure [dbo].[maintain_DBFileSize]    Script Date: 08/10/2006 16:46:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[maintain_DBFileSize]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[maintain_DBFileSize]
GO
/****** Object:  StoredProcedure [dbo].[maintain_DBFileSize]    Script Date: 08/10/2006 16:46:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[maintain_DBFileSize]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'







CREATE              PROCEDURE [dbo].[maintain_DBFileSize]
(
	@for_days_prod int,	-- predict file size how many days in the future
	@days_history int	-- how many days back of history to use for prediction
)
AS
BEGIN

SET NOCOUNT ON

--log current file sizes
EXEC dbo.log_DbFileSize

DECLARE @FileName nvarchar(255)
DECLARE @GrowthRate float
DECLARE @CurrentSize float
DECLARE @PredictedSize int
DECLARE @UsedSize float
DECLARE @AlterDbSQL varchar(2000)

--open cursor to get each file in database
DECLARE FileNameCursor CURSOR FOR
	SELECT DISTINCT Name FROM DbFileSizeLog
OPEN FileNameCursor
FETCH NEXT FROM FileNameCursor INTO @FileName

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT ''Processing '' + @FileName

	-- get growth rate
	EXEC calc_FileGrowthRate @FileName, @GrowthRate OUTPUT, @days_history
	PRINT ''Growth: '' + CONVERT(nvarchar, @GrowthRate)

	-- get current size, predicted size w/ 25% safety margin
	SET SELECT 	@CurrentSize = FileSizeMB, 
			@PredictedSize = UsageSizeMB + (@GrowthRate * @for_days_prod * 1.25), 
			@UsedSize = UsageSizeMB 
	FROM DbFileSizeLog 
	WHERE 	Name = @FileName 
		AND StatusDate IN (
			SELECT MAX(StatusDate) 
			FROM DbFileSizeLog 
			WHERE Name = @FileName)

	-- display results for debugging
	PRINT ''Used: '' + CONVERT(nvarchar, @UsedSize)
	PRINT ''Current: '' + CONVERT(nvarchar, @CurrentSize)
	PRINT ''Predicted: '' + CONVERT(nvarchar, @PredictedSize)

	-- increase file size if current does not exceed predicted
	IF @CurrentSize < @PredictedSize
	BEGIN
		SET SELECT @AlterDbSQL = ''ALTER DATABASE [QMS] MODIFY FILE (NAME = '''''' + @FileName + '''''', SIZE = '' + CAST(@PredictedSize as varchar(20)) + ''MB )'' 
		EXECUTE (@AlterDbSQL)
		PRINT ''Run: '' + @AlterDbSQL
		
	END
	PRINT ''''
	
	-- go to next file
	FETCH NEXT FROM FileNameCursor INTO @FileName
	
END

-- clean up
CLOSE FileNameCursor
DEALLOCATE FileNameCursor
SET NOCOUNT OFF

END
' 
END
GO
GRANT EXECUTE ON [dbo].[maintain_DBFileSize] TO [reporter]
GO
