/*******************************************************************************
 *
 * Function Name:
 *           CM_IsIndexExisted
 *
 * Description:
 *           Check if index exists in the table
 *
 * Parameters:
 *           @TableName       sysname
 *               table name
 *           @pstrIndexName   sysname
 *               index name
 *
 * Return:
 *           1: exists
 *           0: not exists
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_IsIndexExisted(
         @TableName       sysname,
         @pstrIndexName   sysname
       ) RETURNS bit
AS
BEGIN

  IF EXISTS (
      SELECT 1
        FROM sysobjects obj
             JOIN sysindexes idx
               ON idx.id = obj.id
                  AND idx.name = @pstrIndexName
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
     )
      RETURN 1

  RETURN 0

END


