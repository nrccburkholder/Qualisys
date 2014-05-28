/*******************************************************************************
 *
 * Procedure Name:
 *           sp_ImpWiz_ReplaceQuotes
 *
 * Description:
 *           Repace character <'> and <"> with <`> in the string type columns
 *           in load tables
 *
 * Parameters:
 *           @pintStudy_ID int 
 *              Study ID
 *
 * Return:
 *           0:      succeed
 *           others: failed
 *
 * History:
 *           1.0
 *           2.0  12/16/2002 by Brian Mao
 *                Rewrote for the readability and preformance issue
 *
 * Note:
 *           When move to production DB, the following changes need to be done:
 *           (1) Change SP name to "sp_ImpWiz_ReplaceQuotes"
 *           (2) Change the DB name from "QP_Test" to "QP_Prod"
 *
 ******************************************************************************/

CREATE PROC dbo.bm_ImpWiz_ReplaceQuotes @pintStudy_ID int
AS
  SET NOCOUNT ON
  
  DECLARE @DBLQUOTE           varchar(5),
          @SNGQUOTE           varchar(5),
          @BCKQUOTE           varchar(5)
          
  DECLARE @strOwner           varchar(20),
          @strTable_Nm        varchar(20),
          @strField_Nm        varchar(20),
          @strPreTable_Nm     varchar(20),
          @strSQL             varchar(8000),
          @strWhere           varchar(8000)
          

  DECLARE curTables CURSOR FOR
  SELECT mt.StrTable_Nm + '_Load' AS StrTable_Nm,
         mf.StrField_Nm 
  FROM dbo.MetaTable mt,
       dbo.MetaStructure ms,
       dbo.MetaField mf
  WHERE mt.Study_ID = @pintStudy_ID
  AND mt.Table_ID = ms.Table_ID
  AND ms.Field_ID = mf.Field_ID
  AND mf.StrFieldDataType = 'S'
  AND ms.BitPostedField_Flg = 1
  ORDER BY
        StrTable_Nm,
        StrField_Nm 
  IF (@@ERROR <> 0) RETURN 1

  -- Init
  SET @DBLQUOTE = '''"'''
  SET @SNGQUOTE = ''''''''''
  SET @BCKQUOTE = '''`'''
  
  SET @strOwner = 'S' + CONVERT(varchar, @pintStudy_ID) + '.'
  SET @strPreTable_Nm = ''
  SET @strSQL = ''
  SET @strWhere = ''
  
  -- Fetch cursor
  OPEN curTables
  FETCH curTables
  INTO  @strTable_Nm,
        @strField_Nm
  IF (@@ERROR <> 0) RETURN 2
  
  BEGIN TRAN
  
  WHILE (@@FETCH_STATUS = 0) BEGIN
    -- Begin with a new table
    IF (@strTable_Nm <> @strPreTable_Nm
        OR LEN(@strSQL) + LEN(@strWhere) > 7000) BEGIN
    
      -- Exec the previous SQL
      IF (@strSQL <> '') BEGIN
        SET @strSQL = @strSQL + @strWhere
        --PRINT @strSQL
        EXEC(@strSQL)
        IF (@@ERROR <> 0) BEGIN
          ROLLBACK TRAN
          CLOSE curTables
          DEALLOCATE curTables
          RETURN 3
        END
      END
      
      -- Back up the table name
      SET @strPreTable_Nm = @strTable_Nm
      
      -- Construct the 'UPDATE' SQL statement
      SET @strSQL = ''
      SET @strSQL = @strSQL + ' UPDATE ' + @strOwner + @strTable_Nm
      SET @strSQL = @strSQL + ' SET ' + @strField_Nm + ' = '
      SET @strSQL = @strSQL + ' REPLACE(REPLACE(' + @strField_Nm + ', ' + @SNGQUOTE + ', ' + @BCKQUOTE + '), ' + @DBLQUOTE + ', ' + @BCKQUOTE + ') '
      
      -- Construct the 'WHERE' statement
      SET @strWhere = ''
      SET @strWhere = @strWhere + ' WHERE CHARINDEX(' + @DBLQUOTE + ', ' + @strField_Nm + ') > 0'
      SET @strWhere = @strWhere + ' OR CHARINDEX(' + @SNGQUOTE + ', ' + @strField_Nm + ') > 0'
    END
    ELSE BEGIN
      SET @strSQL = @strSQL + ' ,' + @strField_Nm + ' = '
      SET @strSQL = @strSQL + ' REPLACE(REPLACE(' + @strField_Nm + ', ' + @SNGQUOTE + ', ' + @BCKQUOTE + '), ' + @DBLQUOTE + ', ' + @BCKQUOTE + ') '
      SET @strWhere = @strWhere + ' OR CHARINDEX(' + @DBLQUOTE + ', ' + @strField_Nm + ') > 0'
      SET @strWhere = @strWhere + ' OR CHARINDEX(' + @SNGQUOTE + ', ' + @strField_Nm + ') > 0'
    END

    -- Fetch next
    FETCH curTables
    INTO  @strTable_Nm,
          @strField_Nm
    
  END

  CLOSE curTables
  DEALLOCATE curTables
  
  -- Exec the last SQL
  IF (@strSQL <> '') BEGIN
    SET @strSQL = @strSQL + @strWhere
    EXEC(@strSQL)
    IF (@@ERROR <> 0) BEGIN
      ROLLBACK TRAN
      RETURN 3
    END
  END
  
  COMMIT TRAN
  RETURN 0


