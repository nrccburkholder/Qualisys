/****** Object:  Stored Procedure dbo.sp_Samp_FetchHouseholdingVals    Script Date: 9/28/99 2:57:14 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FetchHouseholdingVals
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FetchHouseholdingVals
 @intSurvey_id int
AS
 SELECT MF.strField_nm, MF.strFieldDataType, MF.intFieldLength
  FROM dbo.HouseholdRule HR, dbo.MetaTable MT, dbo.MetaField MF
  WHERE HR.Table_id = MT.Table_id
   AND HR.Field_id = MF.Field_id
   AND HR.Survey_id = @intSurvey_id


