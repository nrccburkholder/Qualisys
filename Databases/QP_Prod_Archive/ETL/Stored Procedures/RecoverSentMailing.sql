CREATE PROCEDURE [ETL].[RecoverSentMailing]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN
	
	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'R_SM' --Recover SentMailing
		AND [Type] = 'R'

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SENTMAILING] ON;
	WITH cteSP AS
	(
		SELECT TOP (@NumToWork) Pkey1 AS [SAMPLEPOP_ID]
		FROM ETL.ArchiveQueue
		WHERE ArchiveRunID = @ArchiveRunID AND EntityTypeID=7
		ORDER BY 1
	)



	INSERT INTO [QP_Prod].[dbo].[SENTMAILING]
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
		  )
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
	  
  FROM [ARCHIVE].[SENTMAILING] s
  INNER JOIN [ARCHIVE].[QUESTIONFORM] qf ON s.[SENTMAIL_ID] = qf.[SENTMAIL_ID]
	  INNER JOIN cteSP t ON t.[SAMPLEPOP_ID] = qf.[SAMPLEPOP_ID]
	  LEFT JOIN [QP_Prod].[dbo].[SENTMAILING] a ON s.[SENTMAIL_ID] = a.[SENTMAIL_ID] 
	  WHERE a.[SENTMAIL_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET IDENTITY_INSERT [QP_Prod].[dbo].[SENTMAILING] OFF;	
	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime,@TaskCount

	

END


