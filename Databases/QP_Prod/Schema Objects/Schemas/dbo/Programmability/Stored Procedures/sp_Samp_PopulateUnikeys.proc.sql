/****** Object:  Stored Procedure dbo.sp_Samp_PopulateUnikeys    Script Date: 9/28/99 2:57:17 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_PopulateUnikeys
Part of:  Sampling Tool
Purpose:  This stored procedure populates the study unikey table with the value of the keyfields
     of each study table for the sampled records (population or encounter)
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
--Modified 1/27/3 BD Populate enc_id in selectedsample
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_PopulateUnikeys 
 @SampleSet_id INT,
 @BigViewJoin VARCHAR(8000)
AS
 DECLARE @Study_id INT
 DECLARE @strINList VARCHAR(8000)
 DECLARE @strSQL VARCHAR(8000)
 /* Variables used to fetch the values of the cursor into */
 DECLARE @FieldName VARCHAR(8000)
 DECLARE @Table_id INT
 /* Fetch the Study_id */
 SELECT @Study_id = SD.Study_id
  FROM dbo.SampleSet SS, dbo.Survey_Def SD
  WHERE SS.Survey_id = SD.Survey_id
   AND SS.SampleSet_id = @SampleSet_id
 /* Creating the temporary table that will hold the list of keyfields for this study */
 CREATE TABLE #KeyFields
  (Table_id INT,
  KeyFieldName VARCHAR(255))
 /* Getting the list of study tables defined for this study (contained in @strINList)*/
 EXEC dbo.sp_CE_GetBigViewInList @Study_id, @strINList output
 /* Populating the #KeyFields temporary table with the name of each key field of the study tables */
 SELECT @strSQL = 
  'INSERT INTO #KeyFields
   SELECT Table_id, strTable_nm + strField_nm as KeyField
   FROM dbo.MetaData_View
                WHERE strTable_nm IN (' +  @strINList + ') 
    AND Study_id = ' + CONVERT(varchar, @Study_id) + ' 
    AND bitKeyField_flg = 1'
 EXECUTE(@strSQL)
 /* Declaring the cursor that will prepare the SQL statement to populate unikeys tables */
 DECLARE curKeyFieldList CURSOR
  FOR SELECT Table_id, KeyfieldName 
   FROM #KeyFields
 OPEN curKeyFieldList
 FETCH NEXT FROM curKeyFieldList INTO @Table_id, @FieldName
 WHILE @@FETCH_STATUS = 0
 BEGIN
/* 2/26/02 -- Inserted but not tested by JC to create a summary table of records inserted into unikeys
  SELECT @strSQL = 
   'INSERT INTO UnikeysSummary (SampleSet_id, SampleUnit_id, UnikeysCount)
    SELECT ' + CONVERT(VARCHAR, @SampleSet_id) + ', X.SampleUnit_id, count(*)
    FROM #SampleUnit_Universe X, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
    WHERE  X.Removed_Rule = 0
    AND ' + @BigViewJoin + '
    GROUP BY ' + CONVERT(VARCHAR, @SampleSet_id) + ', X.SampleUnit_id'
  EXECUTE (@strSQL) 
*/

/*  Don't want to run this in the testing environment
--Added 1/10/3 BD to troubleshoot why Unikeys records are not being added for some units/people.
--Survey 2039 has had this problem twice.  So I want to try and capture some information for this survey.
IF (SELECT survey_id FROM sampleset WHERE sampleset_id = @sampleset_id) = 2039
BEGIN

INSERT INTO NHS_Unikeys (sampleset_id, sampleunit_id, pop_id, Removed_Rule, strUnitSelectType)
SELECT @sampleset_id, sampleunit_id, pop_id, Removed_Rule, strUnitSelectType
FROM #SampleUnit_Universe 

END
*/

  SELECT @strSQL = 
   'INSERT INTO S' + CONVERT(VARCHAR, @Study_id) + '.Unikeys
    SELECT DISTINCT ' + CONVERT(VARCHAR, @SampleSet_id) + ', X.SampleUnit_id, X.Pop_id, ' 
      + CONVERT(VARCHAR, @Table_id) + ', BV.' + @FieldName + ' 
     FROM #SampleUnit_Universe X, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
     WHERE  X.Removed_Rule = 0 
      AND ' + @BigViewJoin
  /* populating Unikeys table */
  --PRINT @strSQL
  EXECUTE (@strSQL)
  FETCH NEXT FROM curKeyFieldList INTO @Table_id, @FieldName
 END
 /* Closeing cthe cursor */
 CLOSE curKeyFieldList 
 DEALLOCATE curKeyFieldList 
 /* Droping temp tables */
 DROP TABLE #KeyFields

insert into sampleunikeyscount
select @sampleset_id, count(*), getdate()
from #sampleunit_universe

--Added 1/27/3 BD Populate enc_id in selectedsample
EXEC SP_Samp_SelectedSampleEncid @SampleSet_id


