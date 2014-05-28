/*******************************************************************************
 *
 * Procedure Name:
 *           PU_CM_PinTableInMemory
 *
 * Description:
 *           Pin a table in the DB host's memory.
 *           The purpose to pin table in memory is to improve the performance
 *
 * Parameters:
 *           @TableName    varchar(256)
 *             Table to be pinned in the memory
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_CM_PinTableInMemory (
       @TableName     varchar(256)
) AS


  DECLARE @db_id       int,
          @tbl_id      int

  IF LEFT(@TableName, 1) = '#' BEGIN       -- Temporary table
      SET @db_id = DB_ID('tempdb')
      SET @tbl_id = OBJECT_ID('tempdb..' + @TableName)
  END
  ELSE BEGIN                               -- Permenant table
      SET @db_id = DB_ID()
      SET @tbl_id = OBJECT_ID(@TableName)
  END
  
  DBCC PINTABLE (@db_id, @tbl_id)
      
  RETURN -1


