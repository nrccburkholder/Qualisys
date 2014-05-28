/*******************************************************************************
 *
 * Procedure Name:
 *           CM_DropPK
 *
 * Description:
 *           Drop primary key
 *
 * Parameters:
 *           @TableName    sysname
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
CREATE PROCEDURE dbo.CM_DropPK (
         @TableName   sysname
       )
AS
  DECLARE @intError              int,
          @strPkName             sysname,
          @Sql                   varchar(1024)
  
  SELECT @strPkName = pk.name
    FROM sysobjects tb,
         sysobjects pk
   WHERE tb.name = @TableName
     AND pk.parent_obj = tb.id
     AND pk.xtype = 'PK'

  IF (@strPkName IS NOT NULL) BEGIN
      SET @Sql = '
             ALTER TABLE ' + @TableName + '
              DROP CONSTRAINT ' + @strPkName
              
      EXEC(@Sql)
  END
  
  RETURN 0


