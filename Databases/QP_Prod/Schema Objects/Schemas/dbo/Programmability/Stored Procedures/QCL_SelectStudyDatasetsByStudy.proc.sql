/*
Business Purpose: 

This procedure will return the study dataset data for all datasets within the specified
date range for the study specified.  If no dates are specified, then all datasets for the study
will be returned.
Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectStudyDatasetsByStudy]
 @intStudy_id int,
 @dtFrom_Date datetime,
 @dtTo_Date datetime
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
CREATE TABLE #Temp_DataSetRecs
  (study_id int, Date_Imported datetime, Records int, Sampled bit, DataSet_id int,
	MinEncDate datetime, MaxEncDate datetime)
 
IF @dtFrom_Date is not null
BEGIN
 INSERT INTO #Temp_DataSetRecs (study_id, date_imported, records, sampled, dataset_id)
  SELECT @intStudy_id, datLoad_dt, RecordCount, 0, DataSet_id
   FROM dbo.Data_Set
   WHERE Study_id = @intStudy_id
    AND datLoad_dt BETWEEN @dtFrom_Date AND DATEADD(DAY,1,@dtTo_Date)
   ORDER BY datLoad_dt DESC
END 
ELSE
BEGIN
 INSERT INTO #Temp_DataSetRecs (study_id, date_imported, records, sampled, dataset_id)
  SELECT @intStudy_id, datLoad_dt, RecordCount, 0, DataSet_id
   FROM dbo.Data_Set
   WHERE Study_id = @intStudy_id
   ORDER BY datLoad_dt DESC
END
 
 UPDATE TDSR
  SET Sampled = 1
  FROM #Temp_DataSetRecs TDSR, dbo.SampleDataSet SDS
   WHERE TDSR.DataSet_id = SDS.DataSet_id
 
 SELECT * 
  FROM #Temp_DataSetRecs 
  
 SELECT dr.Dataset_id, Table_id, Field_id, MinDate, MaxDate
 FROM DatasetDateRange dr, #Temp_DataSetRecs ds
 WHERE dr.Dataset_id = ds.Dataset_id

 DROP TABLE #Temp_DataSetRecs


