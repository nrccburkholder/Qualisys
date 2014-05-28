/*******************************************************************************
 *
 * Function Name:
 *           CM_IsTableExisted
 *
 * Description:
 *           Check if table exists
 *
 * Parameters:
 *           @TableName    sysname
 *               table name
 *              
 *
 * Return:
 *           1: exists
 *           0: not exists
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_IsTableExisted(
         @TableName     sysname
       ) RETURNS bit
AS
BEGIN
  DECLARE @Exist                       bit

  SET @Exist = 0

  -- temp table
  IF (SUBSTRING(@TableName, 1, 1) = '#') BEGIN
      IF (object_id('tempdb..' + @TableName, 'U') IS NOT NULL)
          SET @Exist = 1
  END
  
  -- temp table
  ELSE IF (SUBSTRING(@TableName, 1, 5) = 'dbo.#') BEGIN
      IF (object_id('tempdb.' + @TableName, 'U') IS NOT NULL)
          SET @Exist = 1
  END
  
  -- permanent table
  ELSE IF EXISTS (
      SELECT 1
        FROM dbo.sysobjects
       WHERE id = object_id(@TableName)
         AND OBJECTPROPERTY(id, N'IsUserTable') = 1
     ) BEGIN
      SET @Exist = 1
  END
  
  RETURN(@Exist)
  
END


