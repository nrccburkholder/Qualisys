/*******************************************************************************
 *
 * Procedure Name:
 *           sp_LoadApply_PK
 *
 * Description:
 *           Get primary key of the specified table
 *
 * Parameters:
 *           @pintStudy_ID  int
 *              Study ID
 *           @pstrTable     varchar(20)
 *              Table name
 *           @pstrPK        varchar(20) OUTPUT
 *              Primary key field name
 *
 * Return:
 *           0:      succeed
 *           others: failed
 *
 * History:
 *           1.0  12/18/2002 by Brian Mao
 *
 ******************************************************************************/
CREATE PROC dbo.sp_LoadApply_PK (
                @pintStudy_ID  int,
                @pstrTable     varchar(20),
                @pstrPK        varchar(20) OUTPUT
            )
AS
  SELECT @pstrPK = f.strField_nm 
  FROM MetaTable t,
       MetaStructure s,
       MetaField f
  WHERE t.Study_ID = @pintStudy_ID
  AND t.StrTable_Nm = @pstrTable
  AND s.Table_ID = t.Table_ID
  AND s.Field_ID = f.Field_ID
  AND s.BitKeyField_flg = 1
  
  IF (@@ERROR <> 0 OR @@ROWCOUNT <= 0) RETURN 1
  ELSE RETURN 0


