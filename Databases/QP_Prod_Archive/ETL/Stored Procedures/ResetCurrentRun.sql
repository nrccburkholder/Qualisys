
CREATE PROCEDURE [ETL].[ResetCurrentRun] 
	@TaskCode VARCHAR(10) =  NULL, @Type CHAR(1)='A'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	--EXEC [ETL].[ResetCurrentRun]

	--DECLARE @TaskCode VARCHAR(10) =  NULL
	DECLARE @ArchiveTaskID INT = NULL;
	DECLARE @newTaskCode VARCHAR(10) = NULL;
	IF @TaskCode IS NOT NULL
	BEGIN
	--@ArchiveTaskID = @ArchiveTaskID
		SELECT @ArchiveTaskID = CASE WHEN @TaskCode='S_SP' THEN c.ArchiveTaskID
								ELSE p.ArchiveTaskID END
				, @newTaskCode=c.TaskCode 
		FROM  [ETL].[ArchiveTask] c
		LEFT JOIN [ETL].[ArchiveTask] p ON p.ArchiveTaskID = c.ParentTask AND p.[Type] = @Type
		WHERE c.TaskCode = @TaskCode AND c.[Type] = @Type 

		IF @ArchiveTaskID IS NULL
		BEGIN
			PRINT 'ERROR: Task Code (' + @TaskCode + ') Does Not Exist';
			RETURN 0;
		END
		ELSE
			PRINT 'Archive Process set to run task ' + CAST(@newTaskCode AS VARCHAR(10))  + ' next.';
	END


	/****** Script for SelectTopNRows command from SSMS  ******/
	UPDATE r
	SET ArchiveStateID = (SELECT ArchiveStateID FROM [ETL].[ArchiveState] WHERE [State] = 'Running')
		, ArchiveTaskID = @ArchiveTaskID
	--SELECT *
	FROM [ETL].[ArchiveRun] r
	INNER JOIN [ETL].[ArchiveState] s ON r.ArchiveStateID = s.ArchiveStateID
	WHERE r.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE EndDateTime IS NULL AND [Type] = @Type )
		AND r.[Type] = @Type;



END
