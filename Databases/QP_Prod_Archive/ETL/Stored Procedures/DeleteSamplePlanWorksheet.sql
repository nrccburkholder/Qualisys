CREATE PROCEDURE [ETL].[DeleteSamplePlanWorksheet]
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
	WHERE TaskCode = 'D_SPW' --Delete DeleteSamplePlanWorksheet

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;	

	--WITH cteSP AS
	--(
		SELECT DISTINCT sst.SampleSet_ID
		INTO #tmpSP
		FROM ETL.ArchiveQueue q
		INNER JOIN [ARCHIVE].[SampleSet] sst ON sst.SampleSet_ID = q.Pkey1 AND sst.Recover = 0 AND EntityTypeID=8
		WHERE q.ArchiveRunID = @ArchiveRunID

	--)

	WHILE 1=1
	BEGIN
		DELETE TOP (@NumToWork) s
		FROM [QP_Prod].[dbo].[SamplePlanWorksheet] s
		INNER JOIN #tmpSP t ON t.SampleSet_ID = s.SampleSet_ID
		INNER JOIN [ARCHIVE].[SamplePlanWorksheet] a ON s.[SamplePlanWorksheet_id] = a.[SamplePlanWorksheet_id] 

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


