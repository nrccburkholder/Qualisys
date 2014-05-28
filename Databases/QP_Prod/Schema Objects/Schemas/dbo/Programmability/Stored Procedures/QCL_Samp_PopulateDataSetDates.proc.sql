CREATE PROCEDURE QCL_Samp_PopulateDataSetDates @DataSet_id INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
SET ANSI_WARNINGS OFF  
  
DELETE DataSetDateRange WHERE DataSet_id=@DataSet_id  
  
DECLARE @Study_id INT, @sql VARCHAR(8000), @hasEncounter BIT, @a INT  
  
SELECT @Study_id=Study_id FROM Data_Set WHERE DataSet_id=@DataSet_id  
  
--Do we have an encounter table in the study  
IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')  
  SELECT @hasEncounter=1  
ELSE   
  SELECT @hasEncounter=0  
  
--Get the list of fields we have to deal with  
SELECT IDENTITY(INT,1,1) a, strTable_nm+strField_nm DateField, Table_id, Field_id  
INTO #Field  
FROM MetaData_View  
WHERE strFieldDataType='d'   
AND bitUserField_flg=1  
AND Study_id=@Study_id  


-- Return out of the procedure if there are no datefields to report on.
IF @@ROWCOUNT = 0
	RETURN
  
--Create a temp table to hold the dates  
CREATE TABLE #Dates (DataSet_id INT)  
  
--Initialize the variable  
SELECT @sql='ALTER TABLE #Dates ADD'  
  
--Add in the additional columns needed in the #Dates table  
SELECT @sql=@sql+CASE WHEN RIGHT(@sql,3)='ADD' THEN ' ' ELSE ',' END+'MIN_'+DateField+' DATETIME,MAX_'+DateField+' DATETIME'  
FROM #field  
  
EXEC (@sql)  
  
--Now to build the syntax to populate the #Dates table  
SELECT @sql='INSERT INTO #Dates (DataSet_id'  
  
--Add in the columns  
SELECT @sql=@sql+',MIN_'+DateField+',MAX_'+DateField  
FROM #Field  
ORDER BY a  
  
--Add the select clause  
SELECT @sql=@sql+') SELECT '+LTRIM(STR(@DataSet_id))  
  
--Add the columns to the select clause  
SELECT @sql=@sql+',MIN('+DateField+'),MAX('+DateField+')'  
FROM #Field  
ORDER BY a  
  
--Finish off the query   
SELECT @sql=@sql+' FROM S'+LTRIM(STR(@Study_id))+'.Big_View b, DataSetMember dsm  
WHERE dsm.DataSet_id='+LTRIM(STR(@DataSet_id))+'  
AND '+CASE @hasEncounter WHEN 1 THEN 'dsm.Enc_id=b.EncounterEnc_id' ELSE 'dsm.Pop_id=b.PopulationPop_id' END  
  
EXEC (@sql)  
  
--Now to use the temp table to populate the DataSetDateRange table  
--Loop thru one field at a time  
SELECT TOP 1 @a=a FROM #Field ORDER BY a  
WHILE @@ROWCOUNT>0  
BEGIN  
  
--Add a record into the DataSetDateRange table for the table and field  
SELECT @sql='INSERT INTO DataSetDateRange (DataSet_id, Table_id, Field_id, MinDate, MaxDate)  
SELECT '+LTRIM(STR(@DataSet_id))+',Table_id, Field_id, MIN_'+DateField+',MAX_'+DateField+'  
FROM #Dates t, #Field f  
WHERE f.a='+LTRIM(STR(@a))  
FROM #Field  
WHERE a=@a  
  
EXEC (@sql)  
  
DELETE #Field WHERE a=@a  
  
SELECT TOP 1 @a=a FROM #Field ORDER BY a  
  
END  
  
  
DROP TABLE #Field  
DROP TABLE #Dates  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
SET ANSI_WARNINGS ON


