/*******************************************************************************
 *
 * Procedure Name:
 *           CM_CreatePK
 *
 * Description:
 *           Create primary key
 *
 * Parameters:
 *           @TableName      sysname
 *               table name
 *           @pstrColumns    varchar(8000)
 *               columns in the PK
 *           @pbitClustered  bit
 *               cluster or not
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_CreatePK (
         @TableName       sysname,
         @pstrColumns     varchar(8000),
         @pbitClustered   bit
       )
AS
  -- Check if specified index exists
  IF EXISTS (
      SELECT 1
        FROM sysobjects obj
             JOIN sysindexes idx
               ON idx.id = obj.id
                  AND idx.indid BETWEEN 1 And 250
                  AND INDEXPROPERTY(idx.id, idx.name, 'IsStatistics'    ) = 0
                  AND INDEXPROPERTY(idx.id, idx.name, 'IsAutoStatistics') = 0
                  AND INDEXPROPERTY(idx.id, idx.name, 'IsHypothetical'  ) = 0
             LEFT JOIN sysobjects ido
               ON ido.name = idx.name
                  AND ido.xtype = 'PK'
       WHERE obj.name = @TableName
         AND obj.xtype = 'U'
         AND ido.xtype = 'PK'
     ) BEGIN
      PRINT 'PK on ' + @TableName + ' already exists.'
      PRINT 'Can not create another PK.'
      RETURN 1
  END

  --
  -- CREATE PK
  --
  
  -- Constants
  DECLARE @YES                             int

  SET @YES = 1
  
  -- Variables
  DECLARE @Sql      varchar(1000),
          @Cluster  varchar(15)
  
  IF (@pbitClustered = @YES)
      SET @Cluster = 'CLUSTERED'
  ELSE
      SET @Cluster = 'NONCLUSTERED'
      
  SET @Sql = '
       ALTER TABLE ' + @TableName + '
         ADD PRIMARY KEY ' + @Cluster + ' (
              ' + @pstrColumns + '
             )
      '
      
  EXEC(@Sql)
  
  IF (@@ERROR = 0) RETURN 0
  ELSE RETURN 2


