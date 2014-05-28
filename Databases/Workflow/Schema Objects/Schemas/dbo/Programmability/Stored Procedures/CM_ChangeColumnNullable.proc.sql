/*******************************************************************************
 *
 * Procedure Name:
 *           CM_ChangeColumnNullable
 *
 * Description:
 *           Change column nullable property
 *
 * Parameters:
 *           @TableName      sysname
 *               table name
 *           @ColumnName     sysname
 *               column name
 *           @DataType       varchar(128)
 *               column data type
 *           @Nullable       bit
 *               nullable or not
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_ChangeColumnNullable (
        @TableName         sysname,
        @ColumnName        sysname,
        @DataType          varchar(128),
        @Nullable          bit
       )
AS
  DECLARE @Sql        nvarchar(1000)
  
  SET @Sql = '
       ALTER TABLE ' + @TableName + '
       ALTER COLUMN ' + @ColumnName + ' ' + @DataType + ' ' + CASE @Nullable WHEN 1 THEN 'NULL' ELSE 'NOT NULL' END

  EXEC dbo.sp_executesql @Sql

  RETURN 0


