/*******************************************************************************
 *
 * Procedure Name:
 *           QCL_SelectServiceTypes
 *
 * Description:
 *           Select all the sample unit service type
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:     Success
 *           Other:  Fail
 *
 * History:
 *           1.0  03/13/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.QCL_SelectServiceTypes
AS
  SELECT Service_ID,
         ParentService_id,
         strService_nm
    FROM Service
   ORDER BY
         ParentService_id,
         strService_NM,
         Service_ID

  RETURN -1


