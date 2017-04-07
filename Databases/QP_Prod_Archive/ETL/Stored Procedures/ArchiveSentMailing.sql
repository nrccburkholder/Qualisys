CREATE PROCEDURE [ETL].[ArchiveSentMailing]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SM' --Archive SentMailing

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;



	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SAMPLEPOP_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



INSERT INTO [ARCHIVE].[SENTMAILING]
           ([SENTMAIL_ID]
		  ,[SCHEDULEDMAILING_ID]
		  ,[DATGENERATED]
		  ,[DATPRINTED]
		  ,[DATMAILED]
		  ,[METHODOLOGY_ID]
		  ,[PAPERCONFIG_ID]
		  ,[STRLITHOCODE]
		  ,[STRPOSTALBUNDLE]
		  ,[INTPAGES]
		  ,[DATUNDELIVERABLE]
		  ,[INTRESPONSESHAPE]
		  ,[STRGROUPDEST]
		  ,[datDeleted]
		  ,[datBundled]
		  ,[intReprinted]
		  ,[datReprinted]
		  ,[LangID]
		  ,[datExpire]
		  ,[Country_id]
		  ,[bitExported]
		  ,[QuestionnaireType_ID]
		  ,[ArchiveRunID])
	SELECT DISTINCT
	   s.[SENTMAIL_ID]
      ,s.[SCHEDULEDMAILING_ID]
      ,s.[DATGENERATED]
      ,s.[DATPRINTED]
      ,s.[DATMAILED]
      ,s.[METHODOLOGY_ID]
      ,s.[PAPERCONFIG_ID]
      ,s.[STRLITHOCODE]
      ,s.[STRPOSTALBUNDLE]
      ,s.[INTPAGES]
      ,s.[DATUNDELIVERABLE]
      ,s.[INTRESPONSESHAPE]
      ,s.[STRGROUPDEST]
      ,s.[datDeleted]
      ,s.[datBundled]
      ,s.[intReprinted]
      ,s.[datReprinted]
      ,s.[LangID]
      ,s.[datExpire]
      ,s.[Country_id]
      ,s.[bitExported]
      ,s.[QuestionnaireType_ID]
	  ,@ArchiveRunID
  FROM [QP_Prod].[dbo].[SENTMAILING] s
  INNER JOIN [QP_Prod].[dbo].[QUESTIONFORM] qf ON s.[SENTMAIL_ID] = qf.[SENTMAIL_ID]
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = qf.[SAMPLEPOP_ID]
	  LEFT JOIN [ARCHIVE].[SENTMAILING] a ON s.[SENTMAIL_ID] = a.[SENTMAIL_ID] 
	  WHERE a.[SENTMAIL_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT



	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END

