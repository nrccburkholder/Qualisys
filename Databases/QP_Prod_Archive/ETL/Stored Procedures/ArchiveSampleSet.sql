CREATE PROCEDURE [ETL].[ArchiveSampleSet]
	@ArchiveRunID INT,
	@NumToWork INT
AS
BEGIN

	DECLARE @TaskCount INT = 0;
	DECLARE @CurrentDateTime DATETIME = GETDATE();
	DECLARE @LastTaskID INT; 
	SELECT @LastTaskID = ArchiveTaskID
	FROM [ETL].[ArchiveTask]
	WHERE TaskCode = 'A_SST' --Archive SampleSet

  	DECLARE @oRunLogID INT;
	EXEC [ETL].[InsertArchiveRunDetails] @ArchiveRunID, @LastTaskID, @CurrentDateTime, @ArchiveRunDetailsID = @oRunLogID OUTPUT;

	;WITH cteSP AS
	(
		SELECT  sp.[SAMPLESET_ID]
		FROM ETL.ArchiveQueue q
	    INNER JOIN  [QP_Prod].dbo.SamplePop sp ON q.Pkey1 = sp.SamplePop_ID
		WHERE q.ArchiveRunID = @ArchiveRunID AND EntityTypeID=7

	)


	INSERT INTO [ARCHIVE].[SampleSet]
           ([SAMPLESET_ID]
		  ,[SAMPLEPLAN_ID]
		  ,[SURVEY_ID]
		  ,[EMPLOYEE_ID]
		  ,[DATSAMPLECREATE_DT]
		  ,[intDateRange_Table_id]
		  ,[intDateRange_Field_id]
		  ,[datDateRange_FromDate]
		  ,[datDateRange_ToDate]
		  ,[tiOversample_flag]
		  ,[tiNewPeriod_flag]
		  ,[strSampleSurvey_nm]
		  ,[extract_flg]
		  ,[datLastMailed]
		  ,[tiUnikeysDeled]
		  ,[web_extract_flg]
		  ,[intSample_Seed]
		  ,[PreSampleTime]
		  ,[PostSampleTime]
		  ,[datScheduled]
		  ,[SamplingAlgorithmId]
		  ,[SurveyType_Id]
		  ,[HCAHPSOverSample]
		  ,[IneligibleCount]
		  ,[ArchiveRunID])
	SELECT DISTINCT
			s.[SAMPLESET_ID]
		  ,s.[SAMPLEPLAN_ID]
		  ,s.[SURVEY_ID]
		  ,s.[EMPLOYEE_ID]
		  ,s.[DATSAMPLECREATE_DT]
		  ,s.[intDateRange_Table_id]
		  ,s.[intDateRange_Field_id]
		  ,s.[datDateRange_FromDate]
		  ,s.[datDateRange_ToDate]
		  ,s.[tiOversample_flag]
		  ,s.[tiNewPeriod_flag]
		  ,s.[strSampleSurvey_nm]
		  ,s.[extract_flg]
		  ,s.[datLastMailed]
		  ,s.[tiUnikeysDeled]
		  ,s.[web_extract_flg]
		  ,s.[intSample_Seed]
		  ,s.[PreSampleTime]
		  ,s.[PostSampleTime]
		  ,s.[datScheduled]
		  ,s.[SamplingAlgorithmId]
		  ,s.[SurveyType_Id]
		  ,s.[HCAHPSOverSample]
		  ,s.[IneligibleCount]
		  ,@ArchiveRunID
	  FROM [QP_Prod].[dbo].[SampleSet] s
	  INNER JOIN cteSP t ON t.[SAMPLESET_ID] = s.[SAMPLESET_ID]
	  LEFT JOIN [ARCHIVE].[SampleSet] a ON a.[SAMPLESET_ID] = s.[SAMPLESET_ID] 
	WHERE a.[SAMPLESET_ID] IS NULL; SELECT @TaskCount = @@ROWCOUNT


	SET @CurrentDateTime = GETDATE();

	UPDATE r
	SET ArchiveTaskID = @LastTaskID, TaskCompleteTime = @CurrentDateTime
	FROM ETL.ArchiveRun r
		WHERE ArchiveRunID = @ArchiveRunID

	EXEC [ETL].[UpdateArchiveRunDetails] @oRunLogID, @CurrentDateTime, @TaskCount

END

