/****** Object:  Stored Procedure dbo.sp_Samp_SampleIndirectDyn    Script Date: 9/28/99 2:57:18 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_SampleIndirectDyn
Part of:  Sampling Tool
Purpose:  Indirectly samples all encounters that were directly sampled into the source sample unit
  (@intSampleUnit_id), but have not been previously directly sampled.
Input:  @intSampleUnit_id: Sample Unit ID of the source sample unit.
  @vcPopID_EncID_Join A string used to join two tables on Pop_id and, if an encounter table
     exists, Enc_id.
Output:  Records in #SampleUnit_Universe with an "I" in the strUnitSelectType field that were indirectly
  sampled.
Creation Date: 09/15/1999
Author(s): DA 
Revision: First build - 09/15/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_SampleIndirectDyn
 @intSampleUnit_id int,
 @vcPopID_EncID_Join varchar(8000)
AS
 DECLARE @vcSQL varchar(8000)
 DECLARE @vcSampleUnit_id varchar(255)
 /*Convert the Sample Unit into a varchar*/
 SET @vcSampleUnit_id = CONVERT(varchar, @intSampleUnit_id)
 /*Indirectly sample encounters in all units that were directly sampled into the source unit and are not already
    directly sampled*/
 SET @vcSQL = 'UPDATE Y
    SET strUnitSelectType = "I"
    FROM #SampleUnit_Universe X, #SampleUnit_Universe Y
    WHERE ' + @vcPopID_EncID_Join + '
     AND X.SampleUnit_id = ' + @vcSampleUnit_id + '
     AND Y.SampleUnit_id <> ' + @vcSampleUnit_id + '
     AND X.strUnitSelectType = "D"
     AND Y.strUnitSelectType <> "D"
     AND Y.Removed_Rule = 0'
 EXECUTE (@vcSQL)


