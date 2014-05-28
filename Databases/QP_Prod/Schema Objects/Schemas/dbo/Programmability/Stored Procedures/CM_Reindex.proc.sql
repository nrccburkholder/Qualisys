/*******************************************************************************
 *
 * Procedure Name:
 *           CM_Reindex
 *
 * Description:
 *           Rebuilds all the indexes for a table
 *
 * Parameters:
 *           @TableName      sysname
 *               table name
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_Reindex (
        @TableName           sysname
       )
AS
  DECLARE @Sql                         varchar(500)

  SET @Sql = 'DBCC DBREINDEX(''' + @TableName + ''') WITH NO_INFOMSGS'
      
  EXEC(@Sql)
  
  RETURN 0


