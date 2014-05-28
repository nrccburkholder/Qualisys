/****** Object:  Stored Procedure dbo.SP_LoadedDataClean    Script Date: 6/9/99 4:36:36 PM ******/
/****** Object:  Stored Procedure dbo.SP_LoadedDataClean    Script Date: 3/12/99 4:16:07 PM ******/
/*************************************************************
   This procedure cleans the load tables with rules applied
   for each metafield type. RC - 020599
   Revised by DPA on 03/01/99 - Previous version: OldSP_LoadedDataClean
*************************************************************/
CREATE PROCEDURE SP_LoadedDataClean @study_id NUMERIC
AS
BEGIN
   SET NOCOUNT ON
   SELECT Msg = 'Cleaning Statistics for Study ' + CONVERT(VARCHAR, @study_id)
/*********************************************************************
  Creating temp table of metafields used during sampling or as tags 
*********************************************************************/
   SELECT mf.field_id, mf.strField_nm, usage = 'Used as Tag       '
      INTO #field_table
      FROM tagField tf, metaField mf
      WHERE study_id = @study_id
         AND mf.field_id = tf.field_id
      GROUP BY mf.field_id, mf.strField_nm
   INSERT INTO #field_table
   SELECT mf.field_id, mf.strField_nm, usage = 'Used for Sampling'
      FROM sampleplan sp, sampleunit su, criteriaClause cc, criteriaStmt cs, metaField mf
      WHERE study_id = @study_id
  AND sp.sampleplan_id = su.sampleplan_id
  AND su.criteriastmt_id = cs.criteriastmt_id
         AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
         AND mf.field_id = cc.field_id
  AND mf.field_id NOT IN (SELECT field_id FROM #field_table)
      GROUP BY mf.field_id, mf.strField_nm
   SELECT * FROM #field_table 
/*********************************************************************
  Starting general cleaning rule: NULL OR TRIM() = ""
*********************************************************************/
   DECLARE @field_id        NUMERIC
   DECLARE @field_nm        VARCHAR(255)
   DECLARE @table_nm        VARCHAR(255)
   DECLARE @workingString   VARCHAR(255) 
   DECLARE metaFieldCursor CURSOR
      FOR SELECT ms.field_id, mf.strField_nm, mt.strTable_nm
             FROM metaStructure ms, metaTable mt, metaField mf
             WHERE ms.table_id = mt.table_id 
                AND ms.field_id = mf.field_id
                AND mt.study_id = @study_id
                AND ms.field_id IN (SELECT field_id FROM #field_table)
                AND ms.field_id IN (17, 621, 10, 674, 8, 622, 624, 673, 18, 625, 626, 627, 
                                    11, 679, 9, 628, 661, 37, 38, 629, 468, 24, 15, 563, 
                                    647, 630, 631, 476, 478, 633, 637, 14, 1, 301, 641, 642, 
                                    643, 644, 620, 662, 19, 672, 645, 21)
             ORDER BY ms.table_id
   OPEN metaFieldCursor
   FETCH FIRST 
      FROM metaFieldCursor 
      INTO @field_id, @field_nm, @table_nm
   
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' + 
                     'OR LEN(RTRIM(CONVERT(VARCHAR,' + @field_nm + '))) IS NULL' 
      
      exec(@workingString)   
      FETCH NEXT 
         FROM metaFieldCursor 
         INTO @field_id, @field_nm, @table_nm
   END
   CLOSE metaFieldCursor
   DEALLOCATE metaFieldCursor
/*********************************************************************
  Starting DATE cleaning: NULL OR >TODAY
*********************************************************************/
   DECLARE dateMetaFieldCursor CURSOR
      FOR SELECT ms.field_id, mf.strField_nm, mt.strTable_nm
             FROM metaStructure ms, metaTable mt, metaField mf
             WHERE ms.table_id = mt.table_id 
                AND ms.field_id = mf.field_id
                AND mt.study_id = @study_id
                AND ms.field_id IN (SELECT field_id FROM #field_table)
                AND ms.field_id IN (6, 29, 461, 646, 47, 21)
             ORDER BY ms.table_id
   SET NOCOUNT ON
   OPEN dateMetaFieldCursor
   FETCH FIRST 
      FROM dateMetaFieldCursor 
      INTO @field_id, @field_nm, @table_nm
   
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' + 
                     'OR CONVERT(DATETIME,' + @field_nm + ') IS NULL ' +
                     'OR CONVERT(DATETIME,' + @field_nm + ') > GETDATE()' 
      
      exec(@workingString)   
      FETCH NEXT 
         FROM dateMetaFieldCursor 
         INTO @field_id, @field_nm, @table_nm
   END
   CLOSE dateMetaFieldCursor
   DEALLOCATE dateMetaFieldCursor
/*********************************************************************
  Starting ID cleaning: NULL 
*********************************************************************/
   DECLARE idMetaFieldCursor CURSOR
      FOR SELECT ms.field_id, mf.strField_nm, mt.strTable_nm
             FROM metaStructure ms, metaTable mt, metaField mf
             WHERE ms.table_id = mt.table_id 
                AND ms.field_id = mf.field_id
                AND mt.study_id = @study_id
                AND ms.field_id IN (SELECT field_id FROM #field_table)
                AND ms.field_id IN (30, 548, 638, 639, 39)
             ORDER BY ms.table_id
   SET NOCOUNT ON
   OPEN idMetaFieldCursor
   FETCH FIRST 
      FROM idMetaFieldCursor 
      INTO @field_id, @field_nm, @table_nm
   
   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL '
      
 
      exec(@workingString)   
      FETCH NEXT 
         FROM idMetaFieldCursor 
         INTO @field_id, @field_nm, @table_nm
   END
   CLOSE idMetaFieldCursor
   DEALLOCATE idMetaFieldCursor
/*********************************************************************
  Starting GOUP_INDIV cleaning: NOT IN ('G', 'I')
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 105
      ORDER BY ms.table_id
 
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' NOT IN (''G'',''I'')'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting MARITAL cleaning: NOT IN ('D', 'S', 'M')
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id                      
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 23
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' NOT IN (''D'',''S'',''M'')'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting SEX cleaning: NOT IN ('M', 'F')
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 22
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' NOT IN (''M'',''F'')'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting GUAR_SEX cleaning: NOT IN ('M', 'F')
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 632
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' NOT IN (''M'',''F'')'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting ZIP5 cleaning: NULL OR LEN < 5
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 20
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' +
                     ' OR LEN(RTRIM(' + @field_nm + ')) < 5'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting GUAR_ZIP5 cleaning: NULL OR LEN < 5
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 636
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' +
                     ' OR LEN(RTRIM(' + @field_nm + ')) < 5'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting PHONE cleaning: NULL OR LEN < 8
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 640
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' +
                     ' OR LEN(RTRIM(' + @field_nm + ')) < 8'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting SSN cleaning: NULL OR LEN < 9
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
         AND ms.field_id IN (SELECT field_id FROM #field_table)
         AND ms.field_id = 470
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NULL ' +
                     ' OR LEN(RTRIM(' + @field_nm + ')) < 9'
      
      exec(@workingString)   
   END
/*********************************************************************
  Starting ADDRERR cleaning - Always applied: 
     NOT IN (E413, E500, E501, E503, E504, E412, E420, E430, E431)
*********************************************************************/
   SELECT @field_id = NULL, 
          @field_nm = NULL, 
          @table_nm = NULL
   SELECT @field_id = ms.field_id, 
          @field_nm = mf.strField_nm, 
          @table_nm = mt.strTable_nm
      FROM metaStructure ms, metaTable mt, metaField mf
      WHERE ms.table_id = mt.table_id 
         AND ms.field_id = mf.field_id
         AND mt.study_id = @study_id
/*         AND ms.field_id IN (SELECT field_id FROM #field_table) */
         AND ms.field_id = 43
      ORDER BY ms.table_id
   IF @field_id IS NOT NULL
   BEGIN
      SELECT @workingString = 
                'DELETE S' + CONVERT(VARCHAR, @study_id) + '.' + @table_nm + '_load' +
                  ' WHERE ' + @field_nm + ' IS NOT NULL ' +
                     ' AND RTRIM(' + @field_nm + ') ' +
                         ' NOT IN (''E413'', ''E500'', ''E501'', ''E503'', ' +
                            ' ''E504'', ''E412'', ''E420'', ''E430'', ''E431'')'
      
      exec(@workingString)   
   END
/*********************************************************************
  Cleaning Stats Completed.
*********************************************************************/
   DROP TABLE #field_table
END


