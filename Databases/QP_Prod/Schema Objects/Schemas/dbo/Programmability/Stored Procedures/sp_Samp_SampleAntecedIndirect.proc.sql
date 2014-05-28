/****** Object:  Stored Procedure dbo.sp_Samp_SampleAntecedIndirect    Script Date: 9/28/99 2:57:18 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_SampleAntecedIndirect
Part of:  Sampling Tool
Purpose:  Indirectly samples the encounters of all ancestor sample units that were directly sampled  in the
  source (@intSampleUnit_id) sample unit.
Input:  @intSampleUnit_id: Sample Unit ID of the source sample unit.
  @vcPopID_EncID_Join: The portion of the where clause that will be used to perform the join
     between #SampleUnit_Universe 1 and #SampleUnit_Universe 2.
 
Output:  
Creation Date: 09/14/1999
Author(s): DA 
Revision: First build - 09/14/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_SampleAntecedIndirect
 @intSampleUnit_id int,
 @vcPopID_EncID_Join varchar(8000)
AS
 DECLARE @vcSQL varchar(8000)
 SET @vcSQL = 'UPDATE X
   SET X.strUnitSelectType = ''I''
   FROM #Sampleunit_Universe X, #Sampleunit_Universe Y, dbo.SampleUnitTreeIndex SUTI
   WHERE X.SampleUnit_id = SUTI.AncestorUnit_id
    AND ' + @vcPopID_EncID_Join + '
    AND Y.SampleUnit_id = SUTI.SampleUnit_id  
    AND X.strUnitSelectType = ''N''
    AND X.Removed_Rule = 0
    AND Y.strUnitSelectType = ''D''
    AND Y.SampleUnit_id = ' + CONVERT(varchar(100), @intSampleUnit_id)
 EXECUTE (@vcSQL)



