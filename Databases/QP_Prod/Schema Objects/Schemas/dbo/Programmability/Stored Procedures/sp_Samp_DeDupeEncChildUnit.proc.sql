/****** Object:  Stored Procedure dbo.sp_Samp_DeDupeEncChildUnit    Script Date: 9/28/99 2:57:12 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_SampleChildDirect 
Part of:  Sampling Tool
Purpose:  All encounters that were directly sampled into the source sample unit (@SampleUnit_id) are 
  located in each child sample unit.  Any encounters that are sampleable members of more 
  than one child sample unit are randomly deduped, leaving only one encounter among all
  child sample units as eligible to be directly sampled.
Input:  @intSampleUnit_id:  Sample Unit ID of the source sample unit.
  @vcPopID_EncID_Join  A string used to join two tables on Pop_id and, if an encounter 
      table exists, Enc_id in an SQL query.
  @vcPopID_EncID_Select A string that is used to select Pop_id and, if an encounter
      table exists, Enc_id in a SQL statement.
  @vcPopID_EncID_CreateTable  A string that is used to format Pop_id and, if an encounter
      table exists, Enc_id in a 'CREATE TABLE' SQL statement.
Output:  Records in #SampleUnit_Universe with an "8" in the Removed_Rule that were eliminated
  from "DIRECT" sample availability.
Creation Date: 09/15/1999
Author(s): DA 
Revision: First build - 09/15/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_DeDupeEncChildUnit 
 @intSampleUnit_id int,
 @vcPopID_EncID_Join  varchar(8000),
 @vcPopID_EncID_Select varchar(8000),
 @vcPopID_EncID_CreateTable varchar(8000)
AS
 DECLARE @vcSQL varchar(8000)
 /*Create Child Sample Unit Temp Table*/
 CREATE TABLE #ChildUnits
  (SampleUnit_id int)
 /*Fetch the Child Sample Units*/
 INSERT INTO #ChildUnits
  SELECT SampleUnit_id
   FROM dbo.SampleUnit 
   WHERE ParentSampleUnit_id = @intSampleUnit_id
 
 /*Find the duplicate encounters from child sample units that meet the parent sample unit*/
 SET @vcSQL = 'INSERT INTO #DD_Dups
    SELECT ' + @vcPopID_EncID_Select + '
     FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, #ChildUnits CSU
     WHERE ' + @vcPopID_EncID_Join + '
      AND X.SampleUnit_id = ' + CONVERT(varchar, @intSampleUnit_id) + '
                 AND Y.SampleUnit_id = CSU.SampleUnit_id
      AND X.strUnitSelectType = "D"
      AND Y.Removed_Rule = 0
     GROUP BY ' + @vcPopID_EncID_Select +  '
     HAVING COUNT(*) > 1'
 EXECUTE (@vcSQL)
 /*Insert the duplicate encounters into #ChildSample*/
 SET @vcSQL = 'INSERT INTO #DD_ChildSample 
    SELECT X.SampleUnit_id, ' + @vcPopID_EncID_Select + ', NULL, 0
     FROM #SampleUnit_Universe X, #DD_Dups Y, #ChildUnits CSU
     WHERE ' + @vcPopID_EncID_Join + ' 
      AND X.SampleUnit_id = CSU.SampleUnit_id
      AND X.Removed_Rule = 0'
 
 EXECUTE (@vcSQL)
 /*Assign a Random number to each duplicate encounter */
 SET NOCOUNT ON
 DECLARE curDups CURSOR
  FOR SELECT CS_ID
   FROM #DD_ChildSample 
 DECLARE @CS_ID int
 --BEGIN TRANSACTION
  OPEN curDups 
  
  FETCH NEXT FROM curDups INTO @CS_ID
   
  WHILE @@FETCH_STATUS = 0
  BEGIN
   UPDATE #DD_ChildSample 
    SET numRandom = RAND()
    WHERE CS_ID = @CS_ID
   FETCH NEXT FROM curDups INTO @CS_ID
  END
 --COMMIT TRANSACTION
 
 CLOSE curDups  
 DEALLOCATE curDups 
 SET NOCOUNT OFF
 /*For each duplicate encounter, select one to keep*/
 SET @vcSQL = 'UPDATE #DD_ChildSample 
    SET bitKeep = 1
    FROM (SELECT MIN(numRandom) AS numRandom
      FROM #DD_ChildSample X
      GROUP BY ' + @vcPopID_EncID_Select + ') RandEnc, #DD_ChildSample CS
    WHERE RandEnc.numRandom = CS.numRandom'
 EXECUTE (@vcSQL)
 /*Remove from #SampleUnit_Universe*/
 SET @vcSQL ='UPDATE X 
    SET X.Removed_Rule = 8
     FROM #SampleUnit_Universe X, #DD_ChildSample Y
     WHERE X.SampleUnit_id = Y.SampleUnit_id
      AND ' + @vcPopID_EncID_Join + '
      AND Y.bitKeep = 0'
 EXECUTE (@vcSQL)
 /*Clean up Temp Tables*/
 DROP TABLE #ChildUnits


