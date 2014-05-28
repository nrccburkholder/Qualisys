/*******************************************************************************
 *
 * Procedure Name:
 *           sp_LoadApply_MatchField
 *
 * Description:
 *           Retrieve match fields, build some SQL statements components
 *
 * Parameters:
 *           @pintStudy_ID  int
 *              Study ID
 *           @pstrTable     varchar(20)
 *              Table name
 *           @pstrSQLPart1  varchar(8000) OUTPUT
 *              SQL statement component
 *           @pstrSQLPart2  varchar(8000) OUTPUT
 *              SQL statement component
 *           @pstrSQLPart3  varchar(8000) OUTPUT
 *              SQL statement component
 *           @pstrSQLPart4  varchar(8000) OUTPUT
 *              SQL statement component
 *
 * Return:
 *           0:      succeed
 *           others: failed
 *
 * History:
 *           1.0  12/18/2002 by Brian Mao
 *
 ******************************************************************************/
CREATE PROC dbo.sp_LoadApply_MatchField (
                @pintStudy_ID  int,
                @pstrTable     varchar(20),
                @pstrSQLPart1  varchar(8000) OUTPUT,
                @pstrSQLPart2  varchar(8000) OUTPUT,
                @pstrSQLPart3  varchar(8000) OUTPUT,
                @pstrSQLPart4  varchar(8000) OUTPUT
            )
AS
  DECLARE @strField             varchar(20)

  DECLARE curMatchField CURSOR FOR 
  SELECT f.strField_nm 
  FROM MetaTable t,
       MetaStructure s,
       MetaField f
  WHERE t.Study_id = @pintStudy_ID
  AND t.StrTable_Nm = @pstrTable
  AND s.Table_ID = t.Table_ID
  AND s.Field_ID = f.Field_ID
  AND s.BitMatchField_flg = 1
  
  OPEN curMatchField
  FETCH NEXT FROM curMatchField INTO @strField
  IF (@@FETCH_STATUS <> 0) BEGIN
      CLOSE curMatchField
      DEALLOCATE curMatchField
      RETURN 1
  END
  
  SET @pstrSQLPart1 = @strField
  SET @pstrSQLPart2 = ' ld.' + @strField + ' = ldg.' + @strField
  SET @pstrSQLPart3 = ' ld.' + @strField + ' = lv.' + @strField
  SET @pstrSQLPart4 = ' ld.' + @strField + ' <> lv.' + @strField
  
  FETCH NEXT FROM curMatchField INTO @strField
  WHILE (@@FETCH_STATUS = 0) BEGIN
      SET @pstrSQLPart1 = @pstrSQLPart1 + ' , ' + @strField
      SET @pstrSQLPart2 = @pstrSQLPart2
                          + ' AND ld.' + @strField + ' = ldg.' + @strField
      SET @pstrSQLPart3 = @pstrSQLPart3
                          + ' AND ld.' + @strField + ' = lv.' + @strField
      SET @pstrSQLPart4 = @pstrSQLPart4
                          + ' OR ld.' + @strField + ' <> lv.' + @strField
      FETCH NEXT FROM curMatchField INTO @strField
  END
  CLOSE curMatchField
  DEALLOCATE curMatchField
  
  RETURN 0


