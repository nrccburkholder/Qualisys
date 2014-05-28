/****** Object:  Stored Procedure dbo.sp_Samp_Update_UnitDQ    Script Date: 9/28/99 2:57:19 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_Update_UnitDQ
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_Update_UnitDQ
 @intStudy_id int,
 @intSurvey_id int,
 @intSampleSet_id int,
 @vcPopID_EncID_Select varchar(8000) 
AS
 DECLARE @vcSQL varchar(8000)
 SET @vcSQL = 'INSERT INTO UnitDQ' +
   ' (STUDY_ID, SURVEY_ID, SAMPLEUNIT_ID, SAMPLESET_ID, DQRULE_ID, ' + @vcPopID_EncID_Select + ')' +
   ' SELECT ' + CONVERT(varchar, @intStudy_id) + ', ' + CONVERT(varchar, @intSurvey_id) + ', SUU.SampleUnit_id, ' + 
     CONVERT(varchar, @intSampleSet_id) + ', SUU.DQ_Bus_Rule, ' + @vcPopID_EncID_SELECT +
    ' FROM #SampleUnit_Universe SUU' +
    ' WHERE SUU.DQ_Bus_Rule IS NOT NULL'
 EXECUTE (@vcSQL)


