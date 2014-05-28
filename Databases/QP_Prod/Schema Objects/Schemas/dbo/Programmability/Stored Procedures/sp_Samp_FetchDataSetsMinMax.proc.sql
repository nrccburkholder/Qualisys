/****** Object:  Stored Procedure dbo.sp_Samp_FetchDataSets    Script Date: 9/28/99 2:57:13 PM ******/
CREATE   PROCEDURE sp_Samp_FetchDataSetsMinMax
 @intStudy_id int,
 @intSurvey_id int,
 @dtFrom_Date datetime,
 @dtTo_Date datetime
AS
 CREATE TABLE #Temp_DataSetRecs
  (Date_Imported datetime, Records int, Sampled varchar(3), DataSet_id int,
	MinEncDate datetime, MaxEncDate datetime)
 
 INSERT INTO #Temp_DataSetRecs (date_imported, records, sampled, dataset_id)
  SELECT DS.datLoad_dt, COUNT(*), 'No', DS.DataSet_id
   FROM dbo.Data_Set DS, dbo.DataSetMember DSM
   WHERE DS.DataSet_id = DSM.DataSet_id
    AND DS.Study_id = @intStudy_id
    AND DS.datLoad_dt BETWEEN @dtFrom_Date AND @dtTo_Date
   GROUP BY DS.datLoad_dt, DS.DataSet_id
   ORDER BY DS.datLoad_dt DESC

 --Loop through each dataset ID and get the min and max Encounter Dates
 DECLARE @Dataset_id int, @MINDATE DATETIME, @MAXDATE DATETIME, @DATASETCOUNT INT

 SELECT DataSet_id
 INTO #DATASETS
 FROM #Temp_DataSetRecs

 SET @DATASETCOUNT=@@ROWCOUNT

 WHILE @DATASETCOUNT>0
 BEGIN
	SELECT TOP 1 @dataset_id=dataset_id
	FROM #DATASETS

	EXEC [SP_Samp_MinMaxEncDates] @DataSet_id, @intsurvey_id, @minDate OUTPUT , @maxDate OUTPUT 
 
	UPDATE #Temp_DataSetRecs
	SET MinEncDate=@MINDATE,
		MaxEncDate=@MAXDATE
	WHERE Dataset_id=@dataset_id

	DELETE FROM #DATASETS WHERE Dataset_id=@dataset_id
	SET @DATASETCOUNT=@DATASETCOUNT - 1
 END
 
 UPDATE TDSR
  SET Sampled = 'Yes'
  FROM #Temp_DataSetRecs TDSR, dbo.SampleDataSet SDS
   WHERE TDSR.DataSet_id = SDS.DataSet_id
 
 SELECT * 
  FROM #Temp_DataSetRecs 

 DROP TABLE #Temp_DataSetRecs
 DROP TABLE #DATASETS


