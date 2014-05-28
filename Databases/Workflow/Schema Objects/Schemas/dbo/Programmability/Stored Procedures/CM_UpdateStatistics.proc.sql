/*******************************************************************************
 *
 * Procedure Name:
 *           CM_UpdateStatistics
 *
 * Description:
 *           Update statistics for a table
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
CREATE PROCEDURE dbo.CM_UpdateStatistics (
        @TableName           sysname
       )
AS
  DECLARE @Sql                         varchar(500)

  SET @Sql = 'UPDATE STATISTICS ' + @TableName + ' WITH FULLSCAN'
      
  EXEC(@Sql)
  
  RETURN 0


