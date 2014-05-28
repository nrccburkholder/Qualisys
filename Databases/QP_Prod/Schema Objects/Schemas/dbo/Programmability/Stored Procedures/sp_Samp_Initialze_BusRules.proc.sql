/****** Object:  Stored Procedure dbo.sp_Samp_Initialze_BusRules    Script Date: 9/28/99 2:57:17 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_Initialze_BusRules
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
Revision: 1/25/2006 DC - Added strCriteriaString to the result set
***********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[sp_Samp_Initialze_BusRules]
 @intSurvey_id int
AS
 SELECT BusinessRule_id, BusRule_cd, cs.CriteriaStmt_id, strCriteriaString
  FROM dbo.BusinessRule br, criteriastmt cs
  WHERE Survey_id = @intSurvey_id and
		br.criteriastmt_id=cs.criteriastmt_id
  ORDER BY BusRule_cd


