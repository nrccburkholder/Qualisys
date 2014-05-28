/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectClients
 *
 * Description:
 *           Retrieve client list
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_SelectClients
AS
  SELECT '_All' AS strClient_NM
  
  UNION
  
  SELECT pj.strClient_NM
    FROM GHS_MailMergeLog mm,
         GHS_MailMergeProject pj
   WHERE mm.DateRun >= DATEADD(yy, -2, GETDATE())
     AND pj.Project_ID = mm.Project_ID
   ORDER BY strClient_NM

  RETURN -1


