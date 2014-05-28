/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractTeamClient
 *
 * Description:
 *           Extract teams and their client list
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_MN_ExtractTeamClient
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  ---------------------------
  -- TeamClient
  ---------------------------
  TRUNCATE TABLE TeamClient
  
  IF (@@ERROR <> 0) RETURN 1
  
  INSERT INTO TeamClient (
          Team_ID,
          Client_ID
         )
  SELECT DISTINCT
         tm.Team_ID,
         st.Client_ID
    FROM TeamMember tm,
         QP_Prod.dbo.Study_Employee se,
         QP_Prod.dbo.Study st
   WHERE se.Employee_ID = tm.Employee_ID
     AND st.Study_ID = se.Study_ID
     AND (st.datContractEnd >= DATEADD(mm, -12, GETDATE())
          OR st.datContractEnd IS NULL
         )
   ORDER BY 
         tm.Team_ID,
         st.Client_ID

  IF (@@ERROR <> 0) RETURN 2

  UPDATE STATISTICS TeamClient WITH FULLSCAN

  RETURN -1


