/****** Object:  Stored Procedure dbo.sp_Samp_FetchDataSets    Script Date: 9/28/99 2:57:13 PM ******/
CREATE PROCEDURE sp_Samp_FetchDataSets
 @intStudy_id int,
 @dtFrom_Date datetime,
 @dtTo_Date datetime
AS
 CREATE TABLE #Temp_DataSetRecs
  (Date_Imported datetime, Records int, Sampled varchar(3), DataSet_id int)
 
 INSERT INTO #Temp_DataSetRecs
  SELECT DS.datLoad_dt, COUNT(*), 'No', DS.DataSet_id
   FROM dbo.Data_Set DS, dbo.DataSetMember DSM
   WHERE DS.DataSet_id = DSM.DataSet_id
    AND DS.Study_id = @intStudy_id
    AND DS.datLoad_dt BETWEEN @dtFrom_Date AND @dtTo_Date
   GROUP BY DS.datLoad_dt, DS.DataSet_id
   ORDER BY DS.datLoad_dt DESC
 
 UPDATE TDSR
  SET Sampled = 'Yes'
  FROM #Temp_DataSetRecs TDSR, dbo.SampleDataSet SDS
   WHERE TDSR.DataSet_id = SDS.DataSet_id
 
 SELECT * 
  FROM #Temp_DataSetRecs 
 DROP TABLE #Temp_DataSetRecs


