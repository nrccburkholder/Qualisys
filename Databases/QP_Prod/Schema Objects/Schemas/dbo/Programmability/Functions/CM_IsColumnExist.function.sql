/*******************************************************************************
 *
 * Function Name:
 *           CM_IsColumnExist
 *
 * Description:
 *           Check if column exists in the specified table
 *
 * Parameters:
 *           @TableName
 *               table name
 *           @ColumnName
 *               column name
 *
 * Return:
 *           1: exists
 *           0: not exists
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_IsColumnExist (
         @TableName       sysname,
         @ColumnName      sysname
       ) RETURNS bit
AS
BEGIN

  IF EXISTS (
      SELECT 1
        FROM dbo.sysobjects ob,
             dbo.syscolumns cl
       WHERE ob.id = object_id(@TableName)
         AND OBJECTPROPERTY(ob.id, N'IsUserTable') = 1
         AND cl.id = ob.id
         AND cl.name = @ColumnName
     )
      RETURN 1

  RETURN 0

END


