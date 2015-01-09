/*
S15.US11 Changes to Catalyst ETL
		ICH CAHPS 

T11.1	Update skip to differentiate between not answered and appropriately skipped. 
		Differentiate between "not answered" (-9) and "appropriately skipped" (-4)	  

Dave Gilsdorf

ALTER PROCEDURE [dbo].[GetExportData]
ALTER PROCEDURE [SSISCustomExtract].[csp_GetHealthPartnersExtract01]
*/
use NRC_Datamart
go
-- =============================================
-- Author:		Emily Douglas [Nebraska Global]
-- Create date: 8/28/2012
-- Description:	Used by Catalyst Export website to create export file based pm surveyid, studyid and a date range.
-- =============================================
ALTER PROCEDURE [dbo].[GetExportData] 
	@SurveyId int,
	@StudyId int, 
	@StartDate date,
	@EndDate date,
	@DateType int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
declare @ReportDate varchar(1000)
set @ReportDate = 
	(SELECT
	  CASE 
			WHEN st.CahpsTypeID = 0 THEN dt.Label
			WHEN st.CahpsTypeID = 1 THEN 'Discharge Date'
			WHEN st.CahpsTypeID IN (2,3) THEN 'Service Date'
			ELSE NULL
	  END [Cutoff Field]
	FROM Survey s WITH(NOLOCK)
	INNER JOIN SurveyType st WITH(NOLOCK) ON s.SurveyTypeID = st.SurveyTypeID
	LEFT JOIN DateType dt WITH(NOLOCK) ON s.ReportDateTypeID = dt.DateTypeID
	where s.SurveyId = @SurveyId)

Select 
sv.ClientId as CatalystClientId,
sv.Client_Id as QualisysClientId,
sv.StudyId as CatalystStudyId,
sv.Study_Id as QualisysStudyId,
sv.SurveyID as CatalystSurveyId,
sv.Survey_ID as QualisysSurveyId,
su.sampleunitid as CatalystSampleUnitId,
suKey.DataSourceKey as QualisysSampleUnitId,
sp.SamplePopulationId as CatalystSamplePopulationId,
spKey.DataSourceKey as QualisysSamplePopulationId,
sp.SampleSetID,
sp.DispositionID,
sp.CahpsDispositionID,
sp.IsCahpsDispositionComplete,
sp.FirstName,
sp.LastName,
sp.City,
sp.Province,
sp.PostalCode,
sp.IsMale,
case when IsMale = 1 then 'Male' else 'Female' END as Gender,
sp.Age,
sp.LanguageID,
sp.AdmitDate,
sp.DischargeDate,
sp.ServiceDate,
sp.ReportDate,
qf.ReturnDate AS SurveyReturnDate,
rb.OriginalQuestionCore AS QuestionNumber,
rb.ResponseValue AS ResponseValues,
ISNULL(sqLT.Value,rb.MasterQuestionCore) AS QuestionLabel,
case when rb.ResponseValue = -9 then 'Invalid Response (No Response)' when rb.ResponseValue = -8  then 'Invalid Response (Multiple Response)' when rb.ResponseValue > 999  then ' Invalid Response (Skip Pattern Response)'  else  ISNULL(siLT.Value,rb.Respons
eValue) end AS ScaleLabel,
CASE WHEN sq.SectionName  = 'DoD' THEN 'Standard Question' ELSE ISNULL(sq.SectionName,SPACE(1)) END AS Section,
ISNULL(qsq.QuestionSet,SPACE(1)) AS Dimension,
case when rc.UnmaskedResponse is null then rc.MaskedResponse when rc.UnmaskedResponse = '' then rc.MaskedResponse else rc.UnmaskedResponse end as UnmaskedResponse,
rc.MaskedResponse,
dskQF.DataSourceKey AS LithoCode,
su.Name as UnitName,
DATEDIFF(day,qf.DatMailed,qf.ReturnDate) AS DaysFromCurrentMailing,
DATEDIFF(day,qf.DatFirstMailed,qf.ReturnDate) AS DaysFromFirstMailing,
qf.DatExpire as ExpirationDate,
qf.DatUndeliverable as UndeliverableDate,
sas.SampleDate as SampleDate,
cd.Label as CahpsDispLabel,
mpn.MedicareProviderNumber,
cast(case when sv.CahpsTypeID = 1 and su.IsCahps = 1 then 1 else 0 end as bit) as HCAHPS,
cast(case when sv.CahpsTypeID = 2 and su.IsCahps = 1 then 1 else 0 end as bit) as HHCAHPS,
case when sp.CahpsDispositionID = 1 then 'HCAHPS Reportable' else 'HCAHPS Non-Reportable' end as HCAHPSReportable,
case when  sv.CahpsTypeID  = 2 then sp.CahpsDispositionID else null end as HHCAHPSDisp
from 
	 dbo.SampleUnit su WITH (NOLOCK) 
	 INNER JOIN dbo.v_ClientstudySurvey sv WITH (NOLOCK) ON su.SurveyID = sv.SurveyID
	 INNER JOIN dbo.SelectedSample ss WITH (NOLOCK) ON su.SampleUnitID = ss.SampleUnitID	
	 INNER JOIN dbo.QuestionForm qf WITH (NOLOCK) ON ss.SamplePopulationID = qf.SamplePopulationID
	 LEFT JOIN dbo.SurveyQuestion sq  WITH (NOLOCK) ON sq.SurveyID = sv.SurveyID
	 left JOIN dbo.ResponseBubble rb WITH (NOLOCK) ON qf.QuestionFormID = rb.QuestionFormID and rb.SurveyQuestionID = sq.SurveyQuestionID
	 LEFT JOIN dbo.ScaleItem si WITH (NOLOCK) ON sq.SurveyQuestionID = si.SurveyQuestionID AND rb.ResponseValue = si.ResponseValue
	 LEFT JOIN dbo.LocalizedText sqLT WITH (NOLOCK) ON sq.SurveyQuestionID = sqLT.EntityID AND sqLT.EntityTypeID = 4 AND sqLT.LanguageID = 1
	 LEFT JOIN dbo.LocalizedText siLT WITH (NOLOCK) ON si.ScaleItemID = siLT.EntityID AND siLT.EntityTypeID = 5 AND siLT.LanguageID = 1
	 LEFT JOIN dbo.v_QuestionSetQuestion qsq WITH (NOLOCK) ON rb.MasterQuestionCore = qsq.MasterQuestionCore AND qsq.Category = 'Picker Dimensions' and qsq.InstrumentTypeAbbr not like '%_old' and qsq.ClientID is null
	 inner join dbo.SamplePopulation sp WITH(NOLOCK) on sp.SamplePopulationId = ss.SamplePopulationID	
	 inner join dbo.SampleSet sas WITH(NOLOCK) on sp.SampleSetId = sas.SampleSetID
	 left join dbo.Responsecomment rc WITH (NOLOCK) ON qf.QuestionFormID = rc.QuestionFormID and rc.SurveyQuestionID = sq.SurveyQuestionID
	 left join etl.DataSourceKey suKey with (nolock) on su.SampleUnitId = suKey.DataSourceKeyId and suKey.EntityTypeId = 6
	 left join etl.DataSourceKey spKey with (nolock) on sp.SamplePopulationId = spKey.DataSourceKeyId and spKey.EntityTypeId = 7
	 left JOIN etl.DataSourceKey dskQF WITH (NOLOCK) ON qf.QuestionFormID = dskQF.DataSourceKeyID and dskQF.EntityTypeId = 11
     left join CahpsDisposition cd WITH (NOLOCK) on cd.CahpsDispositionID = sp.CahpsDispositionID
	 left join (SELECT sump.[SampleUnitID]
      ,sump.[BenchmarkDate]
      ,sump.[MedicareProviderNumber]      
	  FROM [SampleUnitMedicareProviderNumber] sump 
	  where not exists (select * from [SampleUnitMedicareProviderNumber]  high where 
	  high.SampleUnitId = sump.SampleUnitId  and high.BenchmarkDate > sump.BenchmarkDate)) mpn on mpn.SampleUnitID = su.SampleUnitID
	WHERE qf.IsActive = 1 AND sv.StudyID = @StudyId AND sv.SurveyID = @SurveyId and (rb.responsebubbleid is not null or rc.responsecommentid is not null)
		AND case @DateType
				when 1 then qf.ReturnDate
				else case @ReportDate 
						when 'Discharge Date' then sp.DischargeDate 
						when 'Service Date' then sp.ServiceDate 
						else sp.ReportDate 
					 end
			end BETWEEN @StartDate AND @EndDate

END
go
ALTER PROCEDURE [SSISCustomExtract].[csp_GetHealthPartnersExtract01]
 @ConfigurationID INT,@StudyID INT--,@StudyName NVARCHAR(50)
 ,@DataStartDate DATE,@DataEndDate DATE
  ,@HistoryID INT
  ,@StudyName NVARCHAR(50)
  --,@SurveyAlias NVARCHAR(50),@SurveyDivision NVARCHAR(50),@Survey_ID NVARCHAR(50)
  --exec SSISCustomExtract.csp_GetHealthPartnersExtract01 4,119607585,'2012-05-01 00:00:00.000','2012-05-31 00:00:00.000',1
  ---exec SSISCustomExtract.csp_GetHealthPartnersExtract01 4,120154991,	'2012-05-01 00:00:00.000','2012-05-31 00:00:00.000',1
  
   
/*******************************************************************************91356795
 * Procedure Name:
 *           SSISCustomExtract.csp_GetHealthPartnersExtract
 * Description:
 *           Stored Procedure used for listing HealthPartners monthly results
 *           The sproc is called by the TFS\Development\SSIS\CustomExtracts\HealthPartners\HealthPartnersExtract01.dtsx package  			
 * History:
 *           1.0  6/10/2012 by knussrallah
 *           2.0  8/16/2012 by agallichotte
 *			
 ******************************************************************************/
AS
BEGIN
	SET NOCOUNT ON
 
	---CONSTANTS - Would Recommend Question Cores - KEEP THESE IN SYNC---
	DECLARE @WR1Core int = 39138 
	DECLARE @WR2Core int = 39532
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
		@extractCount INT
	
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
	 	 
	-- identify our background fields
	SELECT
		ROW_NUMBER() OVER(ORDER BY ColumnName) AS RowNum,
		ColumnName,
		ColumnCustomDescription,
		ColumnFormula
	INTO #samplePopBackgroundColumns
	FROM SSISCustomExtract.HealthPartnersBackgroundFieldIncluded01
	WHERE
		CustomExtactConfigurationID = @ConfigurationID
		AND InactivatedDate IS NULL  
		AND Source = 'dbo.SamplePopulationBackgroundField'
	
	
	If NOT @StudyName = 'SMG'
	Begin
			update #samplePopBackgroundColumns
			set ColumnName = 'SERVICEIND_7'
			where ColumnName = 'MRN'
	End


	-- identify our samplepops
	SELECT DISTINCT
		ss.SamplePopulationID,
		dskQF.DataSourceKey AS Survey_ID,
		qf.ReturnDate AS Survey_Return_Date,
		qf.QuestionFormID,
		hpsv.Division AS Division,
		sv.Survey_ID AS Survey
	INTO #samplepops
	FROM dbo.SampleUnit su  
	JOIN dbo.v_Survey sv ON su.SurveyID = sv.SurveyID
	JOIN SSISCustomExtract.HealthPartnersSurveyIncluded01 hpsv  ON sv.SurveyID = hpsv.SurveyID
	JOIN dbo.SelectedSample ss ON su.SampleUnitID = ss.SampleUnitID	
	JOIN dbo.QuestionForm qf ON ss.SamplePopulationID = qf.SamplePopulationID
	JOIN etl.DataSourceKey dskQF ON qf.QuestionFormID = dskQF.DataSourceKeyID
	WHERE
		sv.StudyID = @StudyID
		AND qf.IsActive = 1
		AND qf.ReturnDate BETWEEN @DataStartDate AND @DataEndDate
		AND EXISTS (SELECT 1 FROM dbo.ResponseBubble rb  WHERE rb.QuestionFormID = qf.QuestionFormID)
	CREATE NONCLUSTERED INDEX [IX_samplepop] ON #samplepops
	(
		[SamplePopulationID] ASC
	) ON [PRIMARY]
	CREATE NONCLUSTERED INDEX [IX_QuestionFormI] ON #samplepops
	(
		[QuestionFormID] ASC
	) ON [PRIMARY]
	 
	-- collate our responses
	SELECT
		rb.QuestionFormID,
		rb.MasterQuestionCore AS QuestionNumber,
		rb.ResponseValue AS ResponseValues,
		ISNULL(sqLT.Value,rb.MasterQuestionCore) AS QuestionLabel,
		ISNULL(siLT.Value,rb.ResponseValue) AS ScaleLabel,
		CASE
			WHEN CAST(psd.IsProblem AS VARCHAR) = '1' THEN '0'
			WHEN CAST(psd.IsProblem AS VARCHAR) = '0' THEN '100'
			ELSE ' '
		END AS Positive_Score,
		CASE
			WHEN sq.SectionName  = 'DoD' THEN 'Standard Question'
			ELSE ISNULL(sq.SectionName,SPACE(1))
		END AS SECTION,
		ISNULL(qs.Dimension,SPACE(1)) AS Dimension
	INTO #responses
	FROM #samplepops qf
	JOIN dbo.ResponseBubble rb ON qf.QuestionFormID = rb.QuestionFormID
	LEFT JOIN dbo.SurveyQuestion sq ON rb.SurveyQuestionID = sq.SurveyQuestionID
	LEFT JOIN dbo.ScaleItem si ON sq.SurveyQuestionID = si.SurveyQuestionID AND rb.ResponseValue = si.ResponseValue
	LEFT JOIN dbo.LocalizedText sqLT ON sq.SurveyQuestionID = sqLT.EntityID AND sqLT.EntityTypeID = 4 AND sqLT.LanguageID = 1
	LEFT JOIN dbo.LocalizedText siLT ON si.ScaleItemID = siLT.EntityID AND siLT.EntityTypeID = 5 AND siLT.LanguageID = 1
	LEFT JOIN dbo.ProblemScoreDefinition psd ON rb.MasterQuestionCore = psd.MasterQuestionCore AND rb.ResponseValue = psd.ResponseValue
	LEFT JOIN
		(SELECT
			sq.MasterQuestionCore,
			MIN(qs.Label) AS Dimension
		FROM
			(SELECT DISTINCT MasterQuestionCore 
			FROM dbo.SurveyQuestion sq
			JOIN dbo.Survey sv ON sq.SurveyID = sv.SurveyID 
			WHERE sv.StudyID = @StudyID) sq 
		JOIN dbo.QuestionSetQuestion qsq ON sq.MasterQuestionCore= qsq.MasterQuestionCore
		JOIN
			(SELECT
				Label,
				QuestionSetID
			FROM dbo.QuestionSet
			WHERE Category = 'Picker Dimensions') qs
			ON qsq.QuestionSetID = qs.QuestionSetID
		GROUP BY sq.MasterQuestionCore, qs.Label) qs
		ON sq.MasterQuestionCore = qs.MasterQuestionCore
	 
	SET @extractCount = @@ROWCOUNT

	-- add a study-level row to the audit log
	INSERT SSISCustomExtract.HealthPartnersAuditLog01
		(CustomExtactConfigurationHistoryID,
		StudyID, Study_ID, StudyName,
		SurveyID, Survey_ID, SurveyName,
		LithoCount,
		ExtractRowCount,
		MinReturnDate, MaxReturnDate,
		WouldRecommendQuestionCore,
		WouldRecommend1, WouldRecommend2, WouldRecommend3,
		[WouldRecommend-8], [WouldRecommend-9], [WouldRecommend-89],
		WouldRecommend10001, WouldRecommend10002, WouldRecommend10003 ) 
	SELECT
		@HistoryID,
		st.StudyID, st.Study_ID, st.StudyName,
		NULL, NULL, 'All',
		Count(DISTINCT QuestionFormID),
		@extractCount,
		ISNULL(MIN(Survey_Return_Date),'1900-01-10'),ISNULL(MAX(Survey_Return_Date),'1900-01-10'),
		NULL,
		wr1, wr2, wr3, wr8, wr9, wr89, wr10001, wr10002, wr10003
	FROM #samplepops sp
	CROSS JOIN (SELECT StudyID,Study_id,StudyName FROM dbo.v_Study WHERE StudyID = @StudyID) st
	CROSS JOIN
		(SELECT
			SUM(CASE ResponseValues WHEN 1 THEN 1 ELSE 0 END) AS wr1,
			SUM(CASE ResponseValues WHEN 2 THEN 1 ELSE 0 END) AS wr2,
			SUM(CASE ResponseValues WHEN 3 THEN 1 ELSE 0 END) AS wr3,
			SUM(CASE ResponseValues WHEN -8 THEN 1 ELSE 0 END) AS wr8,
			SUM(CASE ResponseValues WHEN -9 THEN 1 ELSE 0 END) AS wr9,
			SUM(CASE ResponseValues WHEN -89 THEN 1 ELSE 0 END) AS wr89,
			SUM(CASE ResponseValues WHEN 10001 THEN 1 ELSE 0 END) AS wr10001,
			SUM(CASE ResponseValues WHEN 10002 THEN 1 ELSE 0 END) AS wr10002,
			SUM(CASE ResponseValues WHEN 10003 THEN 1 ELSE 0 END) AS wr10003
		FROM #responses
		WHERE QuestionNumber IN (@WR1Core, @WR2Core)) resp
	GROUP BY
		st.StudyID, st.Study_ID, st.StudyName,
		wr1, wr2, wr3, wr8, wr9, wr89, wr10001, wr10002, wr10003
		
	-- add survey-level rows to the audit log
	INSERT SSISCustomExtract.HealthPartnersAuditLog01
		(CustomExtactConfigurationHistoryID,
		StudyID, Study_ID, StudyName,
		SurveyID, Survey_ID, SurveyName,
		LithoCount,
		ExtractRowCount,
		MinReturnDate, MaxReturnDate,
		WouldRecommendQuestionCore,
		WouldRecommend1, WouldRecommend2, WouldRecommend3,
		[WouldRecommend-8], [WouldRecommend-9], [WouldRecommend-89],
		WouldRecommend10001, WouldRecommend10002, WouldRecommend10003 ) 
	SELECT
		@HistoryID,
		st.StudyID, st.Study_ID, st.StudyName,
		su.SurveyID, su.Survey_ID, su.SurveyName,
		Count(DISTINCT QuestionFormID),
		@extractCount,
		ISNULL(MIN(Survey_Return_Date),'1900-01-10'), ISNULL(MAX(Survey_Return_Date),'1900-01-10'),
		wrqc,
		wr1, wr2, wr3, wr8, wr9, wr89, wr10001, wr10002, wr10003
	FROM #samplepops sp
	CROSS JOIN (SELECT StudyID, Study_id, StudyName FROM dbo.v_Study WHERE StudyID = @StudyID) st
	CROSS APPLY (SELECT SurveyID, Survey_ID, SurveyName FROM dbo.v_Survey WHERE Survey_ID = sp.Survey) su
	JOIN
		(SELECT
			Survey,
			CASE
				WHEN SUM(CASE QuestionNumber WHEN @WR1Core THEN 1 ELSE 0 END)
					>= SUM(CASE QuestionNumber WHEN @WR2Core THEN 1 ELSE 0 END)
				THEN @WR1Core ELSE @WR2Core
			END AS wrqc,
			SUM(CASE ResponseValues WHEN 1 THEN 1 ELSE 0 END) AS wr1,
			SUM(CASE ResponseValues WHEN 2 THEN 1 ELSE 0 END) AS wr2,
			SUM(CASE ResponseValues WHEN 3 THEN 1 ELSE 0 END) AS wr3,
			SUM(CASE ResponseValues WHEN -8 THEN 1 ELSE 0 END) AS wr8,
			SUM(CASE ResponseValues WHEN -9 THEN 1 ELSE 0 END) AS wr9,
			SUM(CASE ResponseValues WHEN -89 THEN 1 ELSE 0 END) AS wr89,
			SUM(CASE ResponseValues WHEN 10001 THEN 1 ELSE 0 END) AS wr10001,
			SUM(CASE ResponseValues WHEN 10002 THEN 1 ELSE 0 END) AS wr10002,
			SUM(CASE ResponseValues WHEN 10003 THEN 1 ELSE 0 END) AS wr10003
		FROM #responses r
		JOIN #samplepops sp ON r.QuestionFormID = sp.QuestionFormID
		WHERE QuestionNumber IN (@WR1Core, @WR2Core)
		GROUP BY Survey) resp
		ON sp.Survey = resp.Survey
	GROUP BY
		st.StudyID, st.Study_ID, st.StudyName,
		su.SurveyID, su.Survey_ID, su.SurveyName,
		wrqc, wr1, wr2, wr3, wr8, wr9, wr89, wr10001, wr10002, wr10003
	
	-- assemble final query
	SELECT
		ROW_NUMBER() OVER(ORDER BY ColumnName) AS RowNum,
		ColumnName,
		ColumnCustomDescription
	INTO #samplePopColumns
	FROM SSISCustomExtract.HealthPartnersBackgroundFieldIncluded01
	WHERE
		CustomExtactConfigurationID = @ConfigurationID
		AND Source = 'dbo.SamplePopulation'
		AND InactivatedDate IS NULL

	If NOT @StudyName = 'SMG'
	Begin
			update #samplePopColumns
			set ColumnName = 'SERVICEIND_7'
			where ColumnName = 'MRN'
	End


	SET @rowNum = 0
	
	SET @selectedColumnList = 'SELECT Survey_ID, Survey_Return_Date, Division, Survey, bf.ColumnCustomDescription, spbf.ColumnValue'
	
	SET @rowNum = 0
	SET @maXRowNum = (SELECT ISNULL(MAX(RowNum),0) FROM #samplePopColumns )

	WHILE @rowNum < @maXRowNum
	  BEGIN
			SET @rowNum = @rowNum + 1
		    		
		   	SET @selectedColumn = (SELECT TOP 1 ColumnName + ' AS ' + ColumnCustomDescription FROM #SamplePopColumns WHERE RowNum = @RowNum)
		   	SET @selectedColumnList  =  @selectedColumnList  + ',' + @selectedColumn 		   
	END		
	
	SET @selectedColumnList = @selectedColumnList + ',resp.QuestionNumber,resp.ResponseValues
	 ,resp.QuestionLabel,resp.ScaleLabel,resp.Positive_Score,resp.Section,resp.Dimension '

	SET @rowNum = 0
	SET @maXRowNum = (SELECT MAX(RowNum) FROM #samplePopBackgroundColumns )
	SET @backgroundFieldsColumnList = SPACE(0)
					
	WHILE @rowNum < @maXRowNum
	  BEGIN
			SET @rowNum = @rowNum + 1
		    			
		    SET @selectedColumn = (SELECT TOP 1 ColumnCustomDescription FROM #samplePopBackgroundColumns WHERE RowNum = @rowNum)
		   
		    IF @rowNum > 1 SET @backgroundFieldsColumnList  =  @backgroundFieldsColumnList  + ',' + @selectedColumn 	
		      ELSE SET @backgroundFieldsColumnList  =  @selectedColumn 		  		    
		
	  END		
	
	SELECT
		ROW_NUMBER() OVER(ORDER BY ColumnSequence) AS RowNum,
		ColumnCustomDescription,
		ColumnFormula
	INTO #orderedColumns
	FROM SSISCustomExtract.HealthPartnersBackgroundFieldIncluded01    
	WHERE
		CustomExtactConfigurationID = @ConfigurationID
		AND InactivatedDate IS NULL 
	
	SET @rowNum = 0
	SET @maXRowNum = (SELECT MAX(RowNum) FROM #orderedColumns )
	
	SET @orderedColumnList = SPACE(0)
					
	WHILE @rowNum < @maXRowNum
	BEGIN
		SET @rowNum = @rowNum + 1
		    			
		SET @selectedColumn = (SELECT TOP 1 ISNULL(ColumnFormula,ColumnCustomDescription) FROM #orderedColumns WHERE RowNum = @rowNum)
		   		   
		IF @rowNum > 1 SET @orderedColumnList =  @orderedColumnList  + ',' + @selectedColumn 	
			ELSE SET @orderedColumnList  =  @selectedColumn	  		    
	END		
			
	--Build the SQL string  
	SET @sQLCmd = 'SELECT ' + @orderedColumnList + 
		' FROM ( ' + @SelectedColumnList + 
				' FROM  #samplepops t
				INNER JOIN dbo.SamplePopulation sp ON t.SamplePopulationID = sp.SamplePopulationID
				INNER JOIN #responses resp ON t.QuestionFormID = resp.QuestionFormID 	
				LEFT JOIN dbo.SamplePopulationBackgroundField spbf  ON t.SamplePopulationID = spbf.SamplePopulationID
				LEFT JOIN #samplePopBackgroundColumns bf   ON spbf.ColumnName = bf.ColumnName	
				
				) x
		PIVOT
			(MAX(ColumnValue)
			   FOR ColumnCustomDescription IN (' + @backgroundFieldsColumnList + ') 	) AS PivotTable '

	-- produce final extract
	EXEC (@sQLCmd )
	--print @sQLCmd 
	SET QUOTED_IDENTIFIER ON
	SET NOCOUNT OFF
END
go
