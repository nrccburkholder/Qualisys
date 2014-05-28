/****** Object:  Stored Procedure dbo.sp_Samp_FetchSurveyValues    Script Date: 9/28/99 2:57:14 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FetchSurveyValues
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FetchSurveyValues
 @intSurvey_id int
AS
 SELECT SD.strHouseholdingType, SD.intResurvey_Period, SD.bitDynamic
  FROM dbo.Survey_def SD
  WHERE SD.Survey_id  = @intSurvey_id


