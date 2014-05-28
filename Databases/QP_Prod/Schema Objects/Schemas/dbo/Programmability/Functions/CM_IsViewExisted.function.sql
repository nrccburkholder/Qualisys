/*******************************************************************************
 *
 * Function Name:
 *           CM_IsViewExisted
 *
 * Description:
 *           Check if view exists
 *
 * Parameters:
 *           @ViewName    sysname
 *               view name
 *
 * Return:
 *           1: exists
 *           0: not exists
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_IsViewExisted(
         @ViewName     sysname
       ) RETURNS bit
AS
BEGIN
  IF EXISTS (
      SELECT 1 
        FROM dbo.sysobjects
       WHERE id = object_id(@ViewName)
         AND OBJECTPROPERTY(id, N'IsView') = 1
  ) RETURN 1
  
  RETURN 0

END


