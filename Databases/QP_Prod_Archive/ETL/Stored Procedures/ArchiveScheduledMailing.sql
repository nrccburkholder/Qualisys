CREATE PROCEDURE [ETL].[ArchiveScheduledMailing]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SDM' --Archive [SCHEDULEDMAILING]

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;



	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SAMPLEPOP_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



INSERT INTO [ARCHIVE].[SCHEDULEDMAILING]
           ([SCHEDULEDMAILING_ID]
		  ,[MAILINGSTEP_ID]
		  ,[SAMPLEPOP_ID]
		  ,[OVERRIDEITEM_ID]
		  ,[SENTMAIL_ID]
		  ,[METHODOLOGY_ID]
		  ,[DATGENERATE]
		  ,[ArchiveRunID])
	SELECT DISTINCT
	   s.[SCHEDULEDMAILING_ID]
		  ,s.[MAILINGSTEP_ID]
		  ,s.[SAMPLEPOP_ID]
		  ,s.[OVERRIDEITEM_ID]
		  ,s.[SENTMAIL_ID]
		  ,s.[METHODOLOGY_ID]
		  ,s.[DATGENERATE]
	  ,@ArchiveRunID
  FROM [QP_Prod].[dbo].[SCHEDULEDMAILING] s
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = s.[SAMPLEPOP_ID]
	  LEFT JOIN [ARCHIVE].[SENTMAILING] a ON s.[SCHEDULEDMAILING_ID] = a.[SCHEDULEDMAILING_ID] 
	  WHERE a.[SCHEDULEDMAILING_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT



	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END

