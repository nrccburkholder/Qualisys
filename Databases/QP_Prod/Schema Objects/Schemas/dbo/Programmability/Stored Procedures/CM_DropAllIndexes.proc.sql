/*******************************************************************************
 *
 * Procedure Name:
 *           CM_DropAllIndexes
 *
 * Description:
 *           Drop all the indexes exist on the table
 *
 * Parameters:
 *           @TableName       sysname
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
CREATE PROCEDURE dbo.CM_DropAllIndexes (
         @TableName   sysname
       )
AS
  DECLARE @IndexName   sysname

  DECLARE curIndex CURSOR LOCAL FOR
  SELECT idx.name
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
     AND ido.name IS NULL
   ORDER BY idx.name
  
  OPEN curIndex
  FETCH curIndex INTO @IndexName
  
  WHILE @@FETCH_STATUS = 0 BEGIN
      EXEC dbo.CM_DropIndex @TableName, @IndexName
      FETCH curIndex INTO @IndexName
  END
  
  CLOSE curIndex
  DEALLOCATE curIndex
    
  RETURN 0


