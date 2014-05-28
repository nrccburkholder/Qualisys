/****** Object:  Stored Procedure dbo.sp_Samp_IdentifyUnitUniverse    Script Date: 9/28/99 2:57:16 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_IdentifyUnitUniverse
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 2/29/2000 - Dave Gilsdorf
  removed white space from @SQL value  
v2.0.2 - 3/2/2000 - Dave Gilsdorf
  discarded @vcSQL and returned the command as a row in a record set which then gets executed
  from the MTS dll
v2.0.3 - 7/7/2003 - Brian Dohmen
  Update SamplePlanWorkSheet table with the criteria statement
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_IdentifyUnitUniverse 
 @intSampleUnit_id INT,
 @intStudy_id INT,
 @vcPopID_EncID_Select VARCHAR(8000),
 @vcBigView_Join VARCHAR(8000),
 @vcCurrent_SampleUnit_Where VARCHAR(8000),
 @vcHouseholdField_SelectBV VARCHAR(8000)=''
AS
 DECLARE @vcSampleUnit_id VARCHAR(10)
 DECLARE @vcStudy_id VARCHAR(10)
 SET @vcSampleUnit_id = CONVERT(VARCHAR, @intSampleUnit_id)
 SET @vcStudy_id = CONVERT(VARCHAR, @intStudy_id)
 IF LTRIM(RTRIM(@vcHouseholdField_SelectBV)) <> ''
  SET @vcHouseholdField_SelectBV = @vcHouseholdField_SelectBV + ', '

--Insert into SamplePlanWorkSheet table
INSERT INTO SamplePlanWorkSheet (SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget, 
	numDefaultResponseRate, intSamplesInPeriod, strCriteria)
SELECT SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn, 
	numInitResponseRate, intSamplesInPeriod, @vcCurrent_SampleUnit_Where
FROM SampleUnit su, SamplePlan sp, Survey_def sd
WHERE su.SampleUnit_id = @intSampleUnit_id
AND su.SamplePlan_id = sp.SamplePlan_id
AND sp.Survey_id = sd.Survey_id

 /* POPULATIONAge is a mandatory field of Population table */
 /* Set strUnitSelectType = "N" to specify that each record has not been sampled*/
 SELECT 'INSERT INTO #SampleUnit_Universe '
    + 'SELECT DISTINCT ' + @vcSampleUnit_id + ', ' 
    + @vcPopID_EncID_Select + ', ' 
    + @vcHouseholdField_SelectBV 
    + ' POPULATIONAge, NULL, 0, "N" '
    + 'FROM #Universe X, S' + @vcStudy_id + '.Big_View BV '
    + 'WHERE ' + @vcBigView_Join + ' AND ' 
    + @vcCurrent_SampleUnit_Where 
    + ' AND X.Removed_Rule IS NULL' AS SQLStatement


