/****** Object:  Stored Procedure dbo.sp_Samp_FetchParentUnit    Script Date: 9/28/99 2:57:14 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_FetchParentUnit 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_FetchParentUnit 
 @intSampleUnit_id int
AS
 SELECT SU2.SampleUnit_id as ParentSampleUnit_id, SU2.CriteriaStmt_id
  FROM SampleUnit SU1, SampleUnit SU2
  WHERE SU1.ParentSampleUnit_id = SU2.SampleUnit_id
   AND SU1.SampleUnit_id = @intSampleUnit_id


