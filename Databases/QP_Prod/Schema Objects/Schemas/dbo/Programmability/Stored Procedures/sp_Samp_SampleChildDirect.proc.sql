/****** Object:  Stored Procedure dbo.sp_Samp_SampleChildDirect    Script Date: 9/28/99 2:57:18 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_SampleChildDirect 
Part of:  Sampling Tool
Purpose:  Directly samples all encounters in the child sample units that were directly sampled into the 
  source sample unit (@intSampleUnit_id).
Input:  @intSampleUnit_id: Sample Unit ID of the source sample unit.
  @vcPopID_EncID_Join A string used to join two tables on Pop_id and, if an encounter table
     exists, Enc_id.
Output:  Records in #SampleUnit_Universe with an "D" in the strUnitSelectType field that were directly
  sampled.
Creation Date: 09/15/1999
Author(s): DA 
Revision: First build - 09/15/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_SampleChildDirect 
 @intSampleUnit_id int,
 @vcPopID_EncID_Join varchar(8000)
AS
 DECLARE @vcSQL varchar(8000)
 /*Create the Temp Tables*/
 CREATE TABLE #ChildUnits
  (SampleUnit_id int)
 /*Identify the child units*/
 INSERT INTO #ChildUnits
  SELECT SampleUnit_id
   FROM dbo.SampleUnit
   WHERE ParentSampleUnit_id = @intSampleUnit_id
 /*Directly Sample all non-removed child units*/
 SET @vcSQL = 'UPDATE Y
  SET Y.strUnitSelectType = "D"
  FROM #SampleUnit_Universe X, #SampleUnit_Universe Y, #ChildUnits CU
  WHERE ' + @vcPopID_EncID_Join + '
   AND Y.SampleUnit_id = CU.SampleUnit_id
   AND X.SampleUnit_id = ' + CONVERT(varchar, @intSampleUnit_id) + '
   AND X.strUnitSelectType = "D"
   AND Y.strUnitSelectType <> "D"
   AND Y.Removed_Rule = 0'
 EXECUTE(@vcSQL)
 DROP TABLE #ChildUnits


