CREATE PROCEDURE [QualisysStudy].[GetQualisysStudyExtract]
	@ExtractClientStudyID INT
	,@DefaultColumns BIT
	,@Study_ID INT
	,@StartDate DATE
	,@EndDate DATE
	,@ExtractLogID INT

AS
BEGIN
	SET NOCOUNT ON
 
	-----CONSTANTS - Would Recommend Question Cores - KEEP THESE IN SYNC---
	--DECLARE @WR1Core int = 39138 
	--DECLARE @WR2Core int = 39532
	--DECLARE @WR3Core int = 45538
	--DECLARE @WR4Core int = 43797
	--DECLARE @WR5Core int = 50717
	--DECLARE @WR6Core int = 50716
	--DECLARE @WR7Core int = 39671
	--DECLARE @WR8Core int = 41409
	--DECLARE @WR9Core int = 39850 
	--DECLARE @WR10Core int = 39190  
	--DECLARE @WR11Core int = 41500 
	---------------------------------------------------------------------

	-- declare variables
    DECLARE
		@selectedColumn AS VARCHAR(MAX),
		@columnFormula AS VARCHAR(MAX),
		@caseStatementList_ColumnValue AS VARCHAR(MAX),
		@selectedColumnList AS VARCHAR(MAX),
		@sQLCmd AS VARCHAR(MAX),
		@backgroundFieldsColumnList AS NVARCHAR(MAX),
		@orderedColumnList AS NVARCHAR(MAX),
		@rowNum AS INT,
		@maxRowNum AS INT,
		@extractCount INT,
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
	 
	--IF @DefaultColumns = 1
	--BEGIN
	--	SET @ExtractID = 0
	--END 	 
	--ELSE
	--BEGIN
	--	SET @ExtractID = @ExtractClientStudyID
	--END
	---- identify our background fields
	--SELECT
	--	ROW_NUMBER() OVER(ORDER BY ColumnName) AS RowNum,
	--	ColumnName,
	--	ColumnCustomDescription,
	--	ColumnFormula
	--INTO #samplePopBackgroundColumns
	--FROM [QP_PROD_Extracts].[QualisysStudy].[IncludedColumns]
	--WHERE
	--	ExtractClientStudyID = @ExtractID
	--	AND InactivatedDate IS NULL  
	--	AND [Source] = 'dbo.SamplePopulationBackgroundField'


	---- identify our samplepops
	--SELECT DISTINCT
	--	ss.SamplePopulationID,
	--	dskQF.DataSourceKey AS Survey_ID,
	--	qf.ReturnDate AS Survey_Return_Date,
	--	qf.QuestionFormID,
	--	hpsv.Division AS Division,
	--	sv.Survey_ID AS Survey,
	--	sv.SurveyID
	--INTO #samplepops
	--FROM QP_PROD.dbo.SampleUnit su  
	--JOIN QP_PROD.dbo.ClientStudySurvey_view sv ON su.Survey_ID = sv.Survey_ID
	--JOIN QualisysStudy.IncludeSurvey hpsv  ON sv.Survey_ID = hpsv.Survey_ID
	--JOIN QP_PROD.dbo.SelectedSample ss ON su.SampleUnitID = ss.SampleUnitID	
	--JOIN QP_PROD.dbo.QuestionForm qf ON ss.SamplePopulationID = qf.SamplePopulationID
	--WHERE
	--	sv.Study_ID = @Study_ID
	--	AND qf.IsActive = 1
	--	AND qf.ReturnDate BETWEEN @StartDate AND @EndDate
	--	AND EXISTS (SELECT 1 FROM NRC_DataMart.dbo.ResponseBubble rb  WHERE rb.QuestionFormID = qf.QuestionFormID)
	--CREATE NONCLUSTERED INDEX [IX_samplepop] ON #samplepops
	--(
	--	[SamplePopulationID] ASC
	--) ON [PRIMARY]
	--CREATE NONCLUSTERED INDEX [IX_QuestionFormI] ON #samplepops
	--(
	--	[QuestionFormID] ASC
	--) ON [PRIMARY]
	 
	---- collate our responses
	--SELECT
	--	rb.QuestionFormID,
	--	rb.MasterQuestionCore AS QuestionNumber,
	--	rb.ResponseValue AS ResponseValues,
	--	ISNULL(sqLT.Value,rb.MasterQuestionCore) AS QuestionLabel,
	--	ISNULL(siLT.Value,rb.ResponseValue) AS ScaleLabel,
	--	CASE
	--		WHEN CAST(psd.IsProblem AS VARCHAR) = '1' THEN '0'
	--		WHEN CAST(psd.IsProblem AS VARCHAR) = '0' THEN '100'
	--		ELSE ' '
	--	END AS Positive_Score,
	--	CASE
	--		WHEN sq.SectionName  = 'DoD' THEN 'Standard Question'
	--		ELSE ISNULL(sq.SectionName,SPACE(1))
	--	END AS SECTION,
	--	ISNULL(qs.Dimension,SPACE(1)) AS Dimension,
	--	qf.SurveyID
	--INTO #responses
	--FROM #samplepops qf
	--JOIN QP_PROD.dbo.ResponseBubble rb ON qf.QuestionFormID = rb.QuestionFormID
	--LEFT JOIN NRC_DataMart.dbo.SurveyQuestion sq ON rb.SurveyQuestionID = sq.SurveyQuestionID
	--LEFT JOIN NRC_DataMart.dbo.ScaleItem si ON sq.SurveyQuestionID = si.SurveyQuestionID AND rb.ResponseValue = si.ResponseValue
	--LEFT JOIN NRC_DataMart.dbo.LocalizedText sqLT ON sq.MasterQuestionCore = sqLT.EntityID AND sqLT.EntityTypeID = 13 AND sqLT.LanguageID = 1
	--LEFT JOIN NRC_DataMart.dbo.LocalizedText siLT ON si.ScaleItemID = siLT.EntityID AND siLT.EntityTypeID = 5 AND siLT.LanguageID = 1
	--LEFT JOIN NRC_DataMart.dbo.ProblemScoreDefinition psd ON rb.MasterQuestionCore = psd.MasterQuestionCore AND rb.ResponseValue = psd.ResponseValue
	--LEFT JOIN
	--	(SELECT
	--		sq.MasterQuestionCore,
	--		MIN(qs.Label) AS Dimension
	--	FROM
	--		(SELECT DISTINCT MasterQuestionCore 
	--		FROM NRC_DataMart.dbo.SurveyQuestion sq
	--		JOIN NRC_DataMart.dbo.Survey sv ON sq.SurveyID = sv.SurveyID 
	--		WHERE sv.Study_ID = @Study_ID) sq 
	--	JOIN NRC_DataMart.dbo.QuestionSetQuestion qsq ON sq.MasterQuestionCore= qsq.MasterQuestionCore
	--	JOIN
	--		(SELECT
	--			Label,
	--			QuestionSetID
	--		FROM NRC_DataMart.dbo.QuestionSet
	--		WHERE Category = 'Picker Dimensions') qs
	--		ON qsq.QuestionSetID = qs.QuestionSetID
	--	GROUP BY sq.MasterQuestionCore, qs.Label) qs
	--	ON sq.MasterQuestionCore = qs.MasterQuestionCore
	 
	--SET @extractCount = @@ROWCOUNT

	---- add a study-level row to the audit log
	--INSERT [QualisysStudy].ExtractLogDetail
	--	(ExtractClientStudyID,
	--	ExtractLogID,
	--	Study_ID, StudyName,
	--	Survey_ID, SurveyName,
	--	LithoCount,
	--	ExtractRowCount,
	--	MinReturnDate, MaxReturnDate,
	--	WouldRecommendQuestionCore,
	--	WouldRecommend1, WouldRecommend2, WouldRecommend3, [WouldRecommend4], [WouldRecommend-4],
	--	[WouldRecommend-8], [WouldRecommend-9], [WouldRecommend-89],
	--	WouldRecommend10001, WouldRecommend10002, WouldRecommend10003, WouldRecommend10004 ) 
	--SELECT
	--	@ExtractClientStudyID,
	--	@ExtractLogID,
	--	st.Study_ID, st.StudyName,
	--	NULL, 'All',
	--	Count(DISTINCT QuestionFormID),
	--	@extractCount,
	--	ISNULL(MIN(Survey_Return_Date),'1900-01-10'),ISNULL(MAX(Survey_Return_Date),'1900-01-10'),
	--	NULL,
	--	wr1, wr2, wr3, wr4, wr_4, wr_8, wr_9, wr_89, wr10001, wr10002, wr10003, wr10004
	--FROM #samplepops sp
	--CROSS JOIN (SELECT Study_id,StudyName FROM QP_PROD.dbo.ClientStudySurvey_view WHERE Study_ID = @Study_ID) st
	--CROSS JOIN
	--	(SELECT
	--		SUM(CASE ResponseValues WHEN 1 THEN 1 ELSE 0 END) AS wr1,
	--		SUM(CASE ResponseValues WHEN 2 THEN 1 ELSE 0 END) AS wr2,
	--		SUM(CASE ResponseValues WHEN 3 THEN 1 ELSE 0 END) AS wr3,
	--		SUM(CASE ResponseValues WHEN 4 THEN 1 ELSE 0 END) AS wr4,
	--		SUM(CASE ResponseValues WHEN -8 THEN 1 ELSE 0 END) AS wr_8,
	--		SUM(CASE WHEN ResponseValues in (-4) THEN 1 ELSE 0 END) AS wr_4,
	--		SUM(CASE WHEN ResponseValues in (-9) THEN 1 ELSE 0 END) AS wr_9,
	--		SUM(CASE ResponseValues WHEN -89 THEN 1 ELSE 0 END) AS wr_89,
	--		SUM(CASE ResponseValues WHEN 10001 THEN 1 ELSE 0 END) AS wr10001,
	--		SUM(CASE ResponseValues WHEN 10002 THEN 1 ELSE 0 END) AS wr10002,
	--		SUM(CASE ResponseValues WHEN 10003 THEN 1 ELSE 0 END) AS wr10003,
	--		SUM(CASE ResponseValues WHEN 10004 THEN 1 ELSE 0 END) AS wr10004
	--	FROM #responses r
	--	WHERE QuestionNumber IN (
	--								SELECT sq.MasterQuestionCore
	--								FROM NRC_DataMart.dbo.SurveyQuestion sq 
	--								INNER JOIN NRC_DataMart.dbo.QuestionQuestionAttribute qqa ON sq.MasterQuestionCore = qqa.MasterQuestionCore
	--								WHERE sq.SurveyID = r.SurveyID AND qqa.QuestionAttributeID = 4 --IsWouldRecommend Question
	--							-- @WR1Core, @WR2Core
	--							--,@WR3Core, @WR4Core
	--							--,@WR5Core, @WR6Core
	--							--,@WR7Core, @WR8Core
	--							--,@WR9Core,@WR10Core,@WR11Core
	--							)) resp
	--GROUP BY
	--	st.Study_ID, st.StudyName,
	--	wr1, wr2, wr3, wr4, wr_4, wr_8, wr_9, wr_89, wr10001, wr10002, wr10003, wr10004
		
	---- add survey-level rows to the audit log
	--INSERT [QualisysStudy].ExtractLogDetail
	--	(ExtractClientStudyID,
	--	ExtractLogID,
	--	Study_ID, StudyName,
	--	Survey_ID, SurveyName,
	--	LithoCount,
	--	ExtractRowCount,
	--	MinReturnDate, MaxReturnDate,
	--	WouldRecommendQuestionCore,
	--	WouldRecommend1, WouldRecommend2, WouldRecommend3, [WouldRecommend4], [WouldRecommend-4],
	--	[WouldRecommend-8], [WouldRecommend-9], [WouldRecommend-89],
	--	WouldRecommend10001, WouldRecommend10002, WouldRecommend10003, WouldRecommend10004) 
	--SELECT
	--	@ExtractClientStudyID,
	--	@ExtractLogID,
	--	st.Study_ID, st.StudyName,
	--	su.Survey_ID, su.SurveyName,
	--	Count(DISTINCT QuestionFormID),
	--	@extractCount,
	--	ISNULL(MIN(Survey_Return_Date),'1900-01-10'), ISNULL(MAX(Survey_Return_Date),'1900-01-10'),
	--	wrqc,
	--	wr1, wr2, wr3, wr4, wr_4, wr_8, wr_9, wr_89, wr10001, wr10002, wr10003, wr10004
	--FROM #samplepops sp
	--CROSS JOIN (SELECT Study_id, StudyName FROM QP_PROD.dbo.ClientStudySurvey_view WHERE Study_ID = @Study_ID) st
	--CROSS APPLY (SELECT Survey_ID, SurveyName FROM QP_PROD.dbo.ClientStudySurvey_view WHERE Survey_ID = sp.Survey) su
	--JOIN
	--	(SELECT
	--		Survey,
	--		QuestionNumber AS wrqc,
	--		SUM(CASE ResponseValues WHEN 1 THEN 1 ELSE 0 END) AS wr1,
	--		SUM(CASE ResponseValues WHEN 2 THEN 1 ELSE 0 END) AS wr2,
	--		SUM(CASE ResponseValues WHEN 3 THEN 1 ELSE 0 END) AS wr3,
	--		SUM(CASE ResponseValues WHEN 4 THEN 1 ELSE 0 END) AS wr4,
	--		SUM(CASE ResponseValues WHEN -8 THEN 1 ELSE 0 END) AS wr_8,
	--		SUM(CASE WHEN ResponseValues in (-4) THEN 1 ELSE 0 END) AS wr_4,
	--		SUM(CASE WHEN ResponseValues in (-9) THEN 1 ELSE 0 END) AS wr_9,
	--		SUM(CASE ResponseValues WHEN -89 THEN 1 ELSE 0 END) AS wr_89,
	--		SUM(CASE ResponseValues WHEN 10001 THEN 1 ELSE 0 END) AS wr10001,
	--		SUM(CASE ResponseValues WHEN 10002 THEN 1 ELSE 0 END) AS wr10002,
	--		SUM(CASE ResponseValues WHEN 10003 THEN 1 ELSE 0 END) AS wr10003,
	--		SUM(CASE ResponseValues WHEN 10004 THEN 1 ELSE 0 END) AS wr10004
	--	FROM #responses r
	--	JOIN #samplepops sp ON r.QuestionFormID = sp.QuestionFormID
	--	WHERE QuestionNumber IN (SELECT sq.MasterQuestionCore
	--								FROM NRC_DataMart.dbo.SurveyQuestion sq 
	--								INNER JOIN NRC_DataMart.dbo.QuestionQuestionAttribute qqa ON sq.MasterQuestionCore = qqa.MasterQuestionCore
	--								WHERE sq.SurveyID = r.SurveyID AND qqa.QuestionAttributeID = 4 --IsWouldRecommend Question
	--							-- @WR1Core, @WR2Core
	--							--,@WR3Core, @WR4Core
	--							--,@WR5Core, @WR6Core
	--							--,@WR7Core, @WR8Core
	--							--,@WR9Core,@WR10Core,@WR11Core
	--							)
	--	GROUP BY Survey, QuestionNumber) resp
	--	ON sp.Survey = resp.Survey
	--GROUP BY
	--	st.Study_ID, st.StudyName,
	--	su.Survey_ID, su.SurveyName,
	--	wrqc, wr1, wr2, wr3, wr4, wr_4, wr_8, wr_9, wr_89, wr10001, wr10002, wr10003, wr10004
	
	---- assemble final query
	--SELECT
	--	ROW_NUMBER() OVER(ORDER BY ColumnName) AS RowNum,
	--	ColumnName,
	--	ColumnCustomDescription
	--INTO #samplePopColumns
	--FROM [QP_PROD_Extracts].[QualisysStudy].[IncludedColumns]
	--WHERE
	--	ExtractClientStudyID = @ExtractID 
	--	AND [Source] = 'dbo.SamplePopulation'
	--	AND InactivatedDate IS NULL

		

	--SET @rowNum = 0
	
	--SET @selectedColumnList = 'SELECT Survey_ID, Survey_Return_Date, Division, Survey, bf.ColumnCustomDescription, spbf.ColumnValue'
	
	--SET @rowNum = 0
	--SET @maXRowNum = (SELECT ISNULL(MAX(RowNum),0) FROM #samplePopColumns )

	--WHILE @rowNum < @maXRowNum
	--  BEGIN
	--		SET @rowNum = @rowNum + 1
		    		
	--	   	SET @selectedColumn = (SELECT TOP 1 ColumnName + ' AS ' + ColumnCustomDescription FROM #SamplePopColumns WHERE RowNum = @RowNum)
	--	   	SET @selectedColumnList  =  @selectedColumnList  + ',' + @selectedColumn 		   
	--END		
	
	--SET @selectedColumnList = @selectedColumnList + ',resp.QuestionNumber,resp.ResponseValues
	-- ,resp.QuestionLabel,resp.ScaleLabel,resp.Positive_Score,resp.Section,resp.Dimension '

	--SET @rowNum = 0
	--SET @maXRowNum = (SELECT MAX(RowNum) FROM #samplePopBackgroundColumns )
	--SET @backgroundFieldsColumnList = SPACE(0)
					
	--WHILE @rowNum < @maXRowNum
	--  BEGIN
	--		SET @rowNum = @rowNum + 1
		    			
	--	    SET @selectedColumn = (SELECT TOP 1 ColumnCustomDescription FROM #samplePopBackgroundColumns WHERE RowNum = @rowNum)
		   
	--	    IF @rowNum > 1 SET @backgroundFieldsColumnList  =  @backgroundFieldsColumnList  + ',' + @selectedColumn 	
	--	      ELSE SET @backgroundFieldsColumnList  =  @selectedColumn 		  		    
		
	--  END		
	
	--SELECT
	--	ROW_NUMBER() OVER(ORDER BY ColumnSequence) AS RowNum,
	--	ColumnCustomDescription,
	--	ColumnFormula
	--INTO #orderedColumns
	--FROM [QP_PROD_Extracts].[QualisysStudy].[IncludedColumns]
	--WHERE
	--	ExtractClientStudyID = @ExtractID
	--	AND InactivatedDate IS NULL 
	
	--SET @rowNum = 0
	--SET @maXRowNum = (SELECT MAX(RowNum) FROM #orderedColumns )
	
	--SET @orderedColumnList = SPACE(0)
					
	--WHILE @rowNum < @maXRowNum
	--BEGIN
	--	SET @rowNum = @rowNum + 1
		    			
	--	SET @selectedColumn = (SELECT TOP 1 ISNULL(ColumnFormula,ColumnCustomDescription) FROM #orderedColumns WHERE RowNum = @rowNum)
		   		   
	--	IF @rowNum > 1 SET @orderedColumnList =  @orderedColumnList  + ',' + @selectedColumn 	
	--		ELSE SET @orderedColumnList  =  @selectedColumn	  		    
	--END		
			
	----Build the SQL string  
	--SET @sQLCmd = 'SELECT ' + @orderedColumnList + 
	--	' FROM ( ' + @SelectedColumnList + 
	--			' FROM  #samplepops t
	--			INNER JOIN NRC_DataMart.dbo.SamplePopulation sp ON t.SamplePopulationID = sp.SamplePopulationID
	--			INNER JOIN #responses resp ON t.QuestionFormID = resp.QuestionFormID 	
	--			LEFT JOIN NRC_DataMart.dbo.SamplePopulationBackgroundField spbf  ON t.SamplePopulationID = spbf.SamplePopulationID
	--			LEFT JOIN #samplePopBackgroundColumns bf   ON spbf.ColumnName = bf.ColumnName	
				
	--			) x
	--	PIVOT
	--		(MAX(ColumnValue)
	--		   FOR ColumnCustomDescription IN (' + @backgroundFieldsColumnList + ') 	) AS PivotTable '

	---- produce final extract
	--EXEC (@sQLCmd )
	--print @sQLCmd 
	--SET QUOTED_IDENTIFIER ON
	SET NOCOUNT OFF
END
