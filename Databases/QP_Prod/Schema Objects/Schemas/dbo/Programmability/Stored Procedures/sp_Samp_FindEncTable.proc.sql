/****** Object:  Stored Procedure dbo.sp_Samp_FindEncTable    Script Date: 9/28/99 2:57:14 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FindEncTable
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FindEncTable
 @intSurvey_id int
AS
 DECLARE @Table_id int
 IF EXISTS (SELECT 1
  FROM dbo.metaTable MT, dbo.Survey_def SD
  WHERE MT.Study_id = SD.Study_id
   AND SD.Survey_id = @intSurvey_id
   AND MT.strTable_nm = 'ENCOUNTER')
  SELECT EncExists = 1
 ELSE 
  SELECT EncExists = 0


