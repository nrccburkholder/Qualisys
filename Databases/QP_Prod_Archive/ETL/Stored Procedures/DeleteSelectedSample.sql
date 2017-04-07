CREATE PROCEDURE [ETL].[DeleteSelectedSample]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @cnt1 INT = 0;
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'D_SS' --Delete SelectedSample

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	--WITH cteSP AS
	--(
		SELECT DISTINCT sp.SamplePop_ID
		INTO #tmpSP
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SamplePop] sp ON sp.SamplePop_ID = q.Pkey1 AND sp.Recover = 0 AND EntityTypeID=7
		WHERE q.ArchiveRunID = @ArchiveRunID

	--)


	WHILE 1=1
	BEGIN
	DELETE s
	FROM [QP_Prod].[dbo].[SelectedSample] s
	  INNER JOIN [QP_Prod].[dbo].[SamplePop] sp ON s.Study_ID = sp.Study_ID AND s.Pop_ID = sp.Pop_ID AND s.SampleSet_ID = sp.SampleSet_ID
	  INNER JOIN #tmpSP t ON t.SamplePop_ID = sp.SamplePop_ID
	  INNER JOIN [ARCHIVE].[SelectedSample] a ON  s.[SELECTEDSAMPLE_ID] = a.[SELECTEDSAMPLE_ID]
		
		SELECT @cnt1 = @@ROWCOUNT;
		IF @cnt1 < @NumToWork
		BEGIN
		 SELECT @TaskCount = @TaskCount + @cnt1;
		 BREAK;
		END
		ELSE
		 SELECT @TaskCount = @TaskCount + @cnt1;
	END

	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

END
