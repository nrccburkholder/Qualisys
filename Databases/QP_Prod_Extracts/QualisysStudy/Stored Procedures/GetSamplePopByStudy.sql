CREATE PROCEDURE [QualisysStudy].[GetSamplePopByStudy]
	@ExtractClientStudyID INT
	,@DefaultColumns BIT
	,@Study_ID INT
	,@StartDate VARCHAR(20)
	,@EndDate VARCHAR(20)
	,@ExtractLogID INT

AS
BEGIN
	SET NOCOUNT ON
 

	---------------------------------------------------------------------

	---- declare variables
	DECLARE
	--	@selectedColumn AS VARCHAR(MAX),
	--	@columnFormula AS VARCHAR(MAX),
	--	@caseStatementList_ColumnValue AS VARCHAR(MAX),
	--	@selectedColumnList AS VARCHAR(MAX),
	--	@sQLCmd AS VARCHAR(MAX),
	--	@backgroundFieldsColumnList AS NVARCHAR(MAX),
	--	@orderedColumnList AS NVARCHAR(MAX),
	--	@rowNum AS INT,
	--	@maxRowNum AS INT,
	--	@extractCount INT,
		@ExtractID INT
	
    -- clean up temp tables  	    
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#samplePops')) 
	 DROP TABLE #samplePops       
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#samplePopColumns')) 
	 DROP TABLE #samplePopColumns	
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#samplePopBackgroundColumns')) 
	 DROP TABLE #samplePopBackgroundColumns 	
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#responses')) 
	 DROP TABLE #responses
	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#orderedColumns')) 
	 DROP TABLE #orderedColumns
	 
	IF @DefaultColumns = 1
	BEGIN
		SET @ExtractID = 0
	END 	 
	ELSE
	BEGIN
		SET @ExtractID = @ExtractClientStudyID
	END
	-- identify our background fields
	SELECT
		ROW_NUMBER() OVER(ORDER BY ColumnName) AS RowNum,
		ColumnName,
		ColumnCustomDescription,
		ColumnFormula
	INTO #samplePopBackgroundColumns
	FROM [QP_PROD_Extracts].[QualisysStudy].[IncludedColumns]
	WHERE
		ExtractClientStudyID = @ExtractID
		AND InactivatedDate IS NULL  
	ORDER BY ColumnSequence	



	DECLARE @sql VARCHAR(MAX);
	DECLARE @selectedColumnList VARCHAR(MAX)= 'SELECT DISTINCT  ';
	DECLARE @selectedColumn VARCHAR(MAX)
	--DECLARE @Study_ID INT = 26113;
	DECLARE @sStudy_ID VARCHAR(50) = 's' + CAST(@Study_ID AS VARCHAR(40));
	DECLARE @rowNum INT = 0;
	DECLARE @maXRowNum INT = 0;

	--drop table #samplePopColumns
	--select * from #samplePopColumns
	SELECT
		ColumnSequence,
		ColumnName,
		ColumnCustomDescription,
		ColumnFormula,
		TableAlias,
		[Source] AS TableName
	INTO #samplePopColumns
	FROM [QualisysStudy].[IncludedColumns]
	WHERE
		ExtractClientStudyID = @ExtractID
		AND InactivatedDate IS NULL  
	ORDER BY ColumnSequence
		
	
	SET @maXRowNum = (SELECT ISNULL(MAX(ColumnSequence),0) FROM #samplePopColumns )

	WHILE @rowNum < @maXRowNum
	  BEGIN
			SET @rowNum = @rowNum + 1
		    		
		   	SET @selectedColumn = (SELECT TOP 1  ISNULL(ColumnFormula, TableAlias + '.' +ColumnName) + ' AS ' + ColumnCustomDescription FROM #SamplePopColumns WHERE ColumnSequence = @RowNum)
			IF @rowNum > 1 AND @rowNum <> @maXRowNum + 1
				SET @selectedColumnList = @selectedColumnList + ','

		   	SET @selectedColumnList  =  @selectedColumnList  + @selectedColumn 	+ char(13) 	   
	END	

	SET @sql =	@selectedColumnList + ' ' +
				'FROM QP_PROD.' + @sStudy_ID + '.Population p ' + char(13) + 
				'INNER JOIN QP_PROD.' + @sStudy_ID + '.Encounter e ON p.pop_id = e.pop_id ' + char(13) +
				'INNER JOIN QP_PROD.dbo.SamplePop sp ON sp.Pop_ID = p.Pop_ID AND sp.Study_ID = ' + CAST(@Study_ID AS VARCHAR(40)) + char(13) +
				'INNER JOIN QP_PROD.dbo.QuestionForm qf ON qf.SamplePop_ID = sp.SamplePop_ID ' + char(13) +
				'INNER JOIN QP_PROD.dbo.SentMailing sm ON sm.SentMail_ID = qf.SentMail_ID '  + char(13) +
				'INNER JOIN QP_PROD.dbo.SampleSet sst ON sp.SampleSet_ID = sst.SampleSet_ID ' + char(13) +
				--'INNER JOIN QP_PROD.dbo.SampleDataSet sds ON sds.SAMPLESET_ID  = sst.SAMPLESET_ID ' + char(13) +				--'INNER JOIN QP_PROD.dbo.DataSetMember dsm ON dsm.DataSet_ID = sds.DataSet_ID ' + char(13) +				'INNER JOIN QP_PROD.dbo.SelectedSample ss ON ss.SampleSet_ID = sst.SampleSet_ID AND p.Pop_ID = ss.Pop_ID AND ss.enc_id = e.enc_id ' + char(13) +				--'INNER JOIN QP_Prod.dbo.SAMPLEPLAN p ON p.SAMPLEPLAN_ID = sst.SAMPLEPLAN_ID ' + char(13) +				'INNER JOIN QP_PROD.dbo.SampleUnit su ON su.SAMPLEPLAN_ID = sst.SAMPLEPLAN_ID AND su.ParentSampleUnit_ID IS NULL ' + char(13) +
				'INNER JOIN QP_PROD.dbo.Survey_Def sv ON sst.Survey_ID = sv.Survey_ID ' + char(13) +
				'INNER JOIN QP_PROD.dbo.Study st ON st.Study_ID = sv.Study_ID ' + char(13) +
				'WHERE CAST(e.DischargeDate AS DATE) between ''' + @StartDate + ''' AND ''' + @EndDate + ''''


	--SET @sql =	@selectedColumnList + ' ' +
	--			'FROM QP_PROD.' + @sStudy_ID + '.Population p ' + char(13) + 
	--			'INNER JOIN QP_PROD.' + @sStudy_ID + '.Encounter e ON p.pop_id = e.pop_id ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.SamplePop sp ON sp.Pop_ID = p.Pop_ID AND sp.Study_ID = ' + CAST(@Study_ID AS VARCHAR(40)) + char(13) +
	--			'INNER JOIN QP_PROD.dbo.QuestionForm qf ON qf.SamplePop_ID = sp.SamplePop_ID ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.SentMailing sm ON sm.SentMail_ID = qf.SentMail_ID '  + char(13) +
	--			'INNER JOIN QP_PROD.dbo.SampleSet sst ON sp.SampleSet_ID = sst.SampleSet_ID ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.SelectedSample ss ON ss.SampleSet_ID = sst.SampleSet_ID AND p.Pop_ID = ss.Pop_ID AND ss.strUnitSelectType = ''D''  ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.SampleUnit su ON su.SampleUnit_ID = ss.SampleUnit_ID ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.Survey_Def sv ON sst.Survey_ID = sv.Survey_ID ' + char(13) +
	--			'INNER JOIN QP_PROD.dbo.Study st ON st.Study_ID = sv.Study_ID ' + char(13) +
	--			--'AND sm.DatUndeliverable IS NULL' + char(13) +
	--			'WHERE CAST(e.DischargeDate AS DATE) between ''' + @StartDate + ''' AND ''' + @EndDate + ''''

print @sql
EXEC (@sql )

	IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#samplePopColumns')) 
		DROP TABLE #samplePopColumns
END
