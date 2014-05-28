/*******************************************************************************
 *
 * Procedure Name:
 *           CM_CreateIndex
 *
 * Description:
 *           Create index
 *
 * Parameters:
 *           @TableName      sysname
 *               table name
 *           @pstrIndexName   sysname
 *               index name
 *           @pstrColumns    varchar(8000)
 *               columns in the PK
 *           @pbitClustered  bit
 *               cluster or not
 *           @pbitUnique     bit
 *               unique or not
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_CreateIndex (
         @TableName       sysname,
         @pstrIndexName   sysname,
         @pstrColumns     varchar(8000),
         @pbitClustered   bit = 0,
         @pbitUnique      bit = 0
       )
AS
  --
  -- Drop existing index
  --
  EXEC dbo.CM_DropIndex @TableName, @pstrIndexName


  --
  -- CREATE index
  --
  
  -- Constants
  DECLARE @YES                             bit

  SET @YES = 1
  
  -- Variables
  DECLARE @Sql      varchar(1000),
          @Unique   varchar(15),
          @Cluster  varchar(15)
  
  IF (@pbitUnique = @YES)
      SET @Unique = 'UNIQUE '
  ELSE
      SET @Unique = ''
  
  IF (@pbitClustered = @YES)
      SET @Cluster = 'CLUSTERED '
  ELSE
      SET @Cluster = 'NONCLUSTERED '
      
  SET @Sql = '
       CREATE ' + @Unique + @Cluster + 'INDEX ' + @pstrIndexName + '
           ON ' + @TableName + ' (
               ' + @pstrColumns + '
              ) ON ''PRIMARY''
      '
      
  EXEC(@Sql)
  
  IF (@@ERROR = 0) RETURN 0
  ELSE RETURN 2


