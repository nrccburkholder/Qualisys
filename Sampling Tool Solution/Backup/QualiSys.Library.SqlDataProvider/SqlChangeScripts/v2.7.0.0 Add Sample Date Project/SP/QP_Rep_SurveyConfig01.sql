ALTER PROCEDURE QP_Rep_SurveyConfig01    
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50),    
 @Survey VARCHAR(50)    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
DECLARE @procedurebegin DATETIME    
SET @procedurebegin=GETDATE()    
    
--insert into dashboardlog (report, associate, Client, Study, Survey, procedurebegin) SELECT 'Survey Configuration', @associate, @Client, @Study, @Survey, @procedurebegin    

DECLARE @intSurvey_id INT, @intStudy_id INT    
SELECT @intSurvey_id=sd.Survey_id, @intStudy_id=sd.Study_id    
FROM Survey_def sd, Study s, Client c    
WHERE c.strClient_nm=@Client    
  AND s.strStudy_nm=@Study    
  AND sd.strSurvey_nm=@Survey    
  AND c.Client_id=s.Client_id    
  AND s.Study_id=sd.Study_id    
    
-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (  
	SELECT 'Survey Configuration' AS SheetNameDummy, 0 AS dummyPropNo, 'Date Created' AS Property, ''''+CONVERT(VARCHAR,DATCREATE_DT,107) AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 1 AS dummyPropNo, 'Contract duration' AS Property, CONVERT(VARCHAR,DATCONTRACTSTART,107) + ' - ' + CONVERT(VARCHAR,DATCONTRACTEND,107) AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 2 AS dummyPropNo, 'Archive delay' AS Property, CONVERT(VARCHAR,INTARCHIVE_MONTHS)+' months' AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 3 AS dummyPropNo, 'Study type' AS Property, CASE WHEN BITStudyONGOING=1 THEN 'On-going' ELSE 'Point in time' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 4 AS dummyPropNo, 'Address cleaning' AS Property, CASE WHEN BITCLEANADDR=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 5 AS dummyPropNo, 'Phone cleaning' AS Property, CASE WHEN BITCHECKPHON=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 6 AS dummyPropNo, 'Proper names' AS Property, CASE WHEN bitProperCASE=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 7 AS dummyPropNo, 'Sampling type' AS Property, CASE WHEN BITDYNAMIC=1 THEN 'Dynamic' ELSE 'Static' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 8 AS dummyPropNo, 'Report Date based on' AS Property, CASE WHEN STRCUTOFFRESPONSE_CD=2 THEN ISNULL(mt.strtable_nm + '.'+ mf.strfield_nm,'undefined')     
	   WHEN STRCUTOFFRESPONSE_CD=0 THEN 'SampleDate' ELSE 'ReturnDate' END    
	      FROM MetaField mf RIGHT OUTER JOIN Survey_def sd LEFT OUTER JOIN MetaTable mt ON sd.CutOffTable_id=mt.Table_id ON sd.cutofffield_id=mf.field_id    
	      WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 8 AS dummyPropNo, 'Sample Encounter Date based on' AS Property, CASE WHEN SampleEncounterfield_id is not null THEN ISNULL(mt.strtable_nm + '.'+ mf.strfield_nm,'undefined')     
	   ELSE 'N/A' END    
	      FROM MetaField mf RIGHT OUTER JOIN Survey_def sd LEFT OUTER JOIN MetaTable mt ON sd.SampleEncounterTable_id=mt.Table_id ON sd.SampleEncounterfield_id=mf.field_id    
	      WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 9 AS dummyPropNo, 'Recalc Response Rate' AS Property, CONVERT(VARCHAR,INTRESPONSE_RECALC_PERIOD)+' days after first sample' AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 10 AS dummyPropNo, 'ReSurvey Exclusion' AS Property, CONVERT(VARCHAR,INTRESurvey_PERIOD)+' days' AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 11 AS dummypropno, 'Samples in each period' AS Property, CONVERT(VARCHAR,INTSAMPLESINPERIOD) AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 12 AS dummypropno, 'Mail frequency' AS Property, STRMAILFREQ AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 13 AS dummypropno, 'Period defined by' AS Property,    
	 CASE     
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=1 THEN 'Week'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=1 THEN 'Month'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=4 THEN 'Month'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=6 THEN 'Quarter'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=3 THEN 'Quarter'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=13 THEN 'Quarter'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=13 THEN '6 month'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=6 THEN '6 month'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=26 THEN '6 month'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=26 THEN 'Year'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=12 THEN 'Year'    
	   ELSE 'Other'    
	 END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 13 AS dummyprocno, 'Validated' AS Property, CASE WHEN BITVALIDATED_FLG=1 THEN ''''+CONVERT(VARCHAR,datValidated,107) ELSE 'No' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 14 AS dummyprocno, 'FormGen Released' AS Property, CASE WHEN BITFORMGENRELEASE=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id
		)

	SELECT 'Survey Configuration' AS SheetNameDummy, 0 AS dummyPropNo, 'Date Created' AS Property, ''''+CONVERT(VARCHAR,DATCREATE_DT,107) AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 1 AS dummyPropNo, 'Contract duration' AS Property, CONVERT(VARCHAR,DATCONTRACTSTART,107) + ' - ' + CONVERT(VARCHAR,DATCONTRACTEND,107) AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 2 AS dummyPropNo, 'Archive delay' AS Property, CONVERT(VARCHAR,INTARCHIVE_MONTHS)+' months' AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 3 AS dummyPropNo, 'Study type' AS Property, CASE WHEN BITStudyONGOING=1 THEN 'On-going' ELSE 'Point in time' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 4 AS dummyPropNo, 'Address cleaning' AS Property, CASE WHEN BITCLEANADDR=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 5 AS dummyPropNo, 'Phone cleaning' AS Property, CASE WHEN BITCHECKPHON=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 6 AS dummyPropNo, 'Proper names' AS Property, CASE WHEN bitProperCASE=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Study WHERE Study_id=@intStudy_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 7 AS dummyPropNo, 'Sampling type' AS Property, CASE WHEN BITDYNAMIC=1 THEN 'Dynamic' ELSE 'Static' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 8 AS dummyPropNo, 'Report Date based on' AS Property, CASE WHEN STRCUTOFFRESPONSE_CD=2 THEN ISNULL(mt.strtable_nm + '.'+ mf.strfield_nm,'undefined')     
	   WHEN STRCUTOFFRESPONSE_CD=0 THEN 'SampleDate' ELSE 'ReturnDate' END    
	      FROM MetaField mf RIGHT OUTER JOIN Survey_def sd LEFT OUTER JOIN MetaTable mt ON sd.CutOffTable_id=mt.Table_id ON sd.cutofffield_id=mf.field_id    
	      WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 8 AS dummyPropNo, 'Sample Encounter Date based on' AS Property, CASE WHEN SampleEncounterfield_id is not null THEN ISNULL(mt.strtable_nm + '.'+ mf.strfield_nm,'undefined')     
	   ELSE 'N/A' END    
	      FROM MetaField mf RIGHT OUTER JOIN Survey_def sd LEFT OUTER JOIN MetaTable mt ON sd.SampleEncounterTable_id=mt.Table_id ON sd.SampleEncounterfield_id=mf.field_id    
	      WHERE Survey_id=@intSurvey_id 	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 9 AS dummyPropNo, 'Recalc Response Rate' AS Property, CONVERT(VARCHAR,INTRESPONSE_RECALC_PERIOD)+' days after first sample' AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 10 AS dummyPropNo, 'ReSurvey Exclusion' AS Property, CONVERT(VARCHAR,INTRESurvey_PERIOD)+' days' AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 11 AS dummypropno, 'Samples in each period' AS Property, CONVERT(VARCHAR,INTSAMPLESINPERIOD) AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 12 AS dummypropno, 'Mail frequency' AS Property, STRMAILFREQ AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 13 AS dummypropno, 'Period defined by' AS Property,    
	 CASE     
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=1 THEN 'Week'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=1 THEN 'Month'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=4 THEN 'Month'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=6 THEN 'Quarter'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=3 THEN 'Quarter'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=13 THEN 'Quarter'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=13 THEN '6 month'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=6 THEN '6 month'    
	   WHEN strMailFreq='Weekly' AND intSamplesInPeriod=26 THEN '6 month'    
	   WHEN strMailFreq='Bi-Weekly' AND intSamplesInPeriod=26 THEN 'Year'    
	   WHEN strMailFreq='Monthly' AND intSamplesInPeriod=12 THEN 'Year'    
	   ELSE 'Other'    
	 END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 13 AS dummyprocno, 'Validated' AS Property, CASE WHEN BITVALIDATED_FLG=1 THEN ''''+CONVERT(VARCHAR,datValidated,107) ELSE 'No' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	UNION SELECT 'Survey Configuration' AS SheetNameDummy, 14 AS dummyprocno, 'FormGen Released' AS Property, CASE WHEN BITFORMGENRELEASE=1 THEN 'Yes' ELSE 'No' END AS [Value] FROM Survey_def WHERE Survey_id=@intSurvey_id    
	ORDER BY dummyPropNo    

ELSE 
	SELECT 'Survey Configuration' AS SheetNameDummy, '' AS dummyPropNo, '' AS Property, '' AS [Value] 
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  

