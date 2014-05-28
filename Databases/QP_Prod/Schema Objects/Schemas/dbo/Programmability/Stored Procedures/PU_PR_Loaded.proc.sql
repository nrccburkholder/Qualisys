/*******************************************************************************
 *
 * Procedure Name:
 *           PU_PR_Loaded
 *
 * Description:
 *           Pull data loading result to report
 *
 * Parameters:
 *           @PUReport_ID          int
 *             Project Update report ID
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_PR_Loaded (
                       @PUReport_ID          int
) AS

  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  DECLARE @strPUReport_ID        varchar(12),
          @strActivityBeginDate  char(23),
          @strActivityEndDate    char(23),
          @strStudy_ID           varchar(12),
          @strStudy_nm           char(10),
          @strReportDateColumn   varchar(128),
          @bitIsEncounterTable   bit,
          @strSql                varchar(8000),
          @strCR                 char(1),
          @datBegin              datetime
          
  SELECT @datBegin = GETDATE()
          
  ----------------------------------------------------------
  -- Init
  ----------------------------------------------------------
  SET @strPUReport_ID = CONVERT(varchar, @PUReport_ID)
  SET @strCR = char(10)
  
  SELECT @strActivityBeginDate = CONVERT(varchar, ActivityBeginDate, 121),
         @strActivityEndDate = CONVERT(varchar, ActivityEndDate, 121)
    FROM #PUR_Report
  
   
  ----------------------------------------------------------
  -- For each study, get the report date column name
  -- and set "IsEncounterTable" to "1" if its data set
  -- table is "Encounter".
  -- Since different surveys in a study may use different
  -- report date column, we will select the max survey which
  -- has "CutoffResponse_CD" of "2", and use its report date
  -- column as the study's report date column 
  ----------------------------------------------------------

  CREATE TABLE #Criteria (
          Study_ID           varchar(12),
          strStudy_nm        char(10),
          ReportDateColumn   varchar(128),
          IsEncounterTable   bit DEFAULT 0
  )
  
/*  
  INSERT INTO #Criteria (
          Study_ID,
          strStudy_nm,
          ReportDateColumn,
          IsEncounterTable
         )
  SELECT DISTINCT
         st.Study_ID,
         s.strStudy_nm,
         rd.ReportDateColumn,
         CASE mt.strTable_nm
           WHEN 'ENCOUNTER' THEN 1
           ELSE 0
           END AS IsEncounterTable
    FROM #PUR_Study st,
         #PUR_Report rp,
         Study s,
         Data_Set ds
         LEFT JOIN (
           SELECT sd.Study_ID,
                  mt.strTable_nm + mf.strField_nm AS ReportDateColumn
             FROM (
                   SELECT MAX(sd.Survey_ID) AS Survey_ID
                     FROM #PUR_Survey sv,
                          Survey_Def sd
                    WHERE sd.Survey_ID = sd.Survey_ID
                      AND sd.strCutoffResponse_CD = 2
                    GROUP BY
                          sd.Study_ID
                  ) msv,
                  Survey_Def sd,
                  MetaTable mt,
                  MetaField mf
            WHERE sd.Survey_ID = msv.Survey_ID
              AND sd.CutoffTable_ID = mt.Table_ID
              AND sd.CutoffField_ID = mf.Field_ID
         ) rd
           ON rd.Study_ID = ds.Study_ID
         LEFT JOIN MetaTable mt
           ON mt.Study_ID = ds.Study_ID
   WHERE s.Study_ID = st.Study_ID
     AND ds.Study_ID = st.Study_ID
     AND ds.datLoad_dt BETWEEN rp.ActivityBeginDate
                           AND rp.ActivityEndDate
*/

  INSERT INTO #Criteria (
          Study_ID,
          strStudy_nm
         )
  SELECT DISTINCT
         st.Study_ID,
         s.strStudy_nm
    FROM #PUR_Study st,
         #PUR_Report rp,
         Study s,
         Data_Set ds
   WHERE s.Study_ID = st.Study_ID
     AND ds.Study_ID = st.Study_ID
     AND ds.datLoad_dt BETWEEN rp.ActivityBeginDate
                           AND rp.ActivityEndDate

  IF @@ERROR <> 0 RETURN 1

  EXEC dbo.PU_CM_TimeUsed 'Data Loading -- Step 1', @datBegin OUTPUT
  
  UPDATE cr
     SET ReportDateColumn = rd.ReportDateColumn
    FROM #Criteria cr,
         (
           SELECT sd.Study_ID,
                  mt.strTable_nm + mf.strField_nm AS ReportDateColumn
             FROM (
                   SELECT MAX(sd.Survey_ID) AS Survey_ID
                     FROM #PUR_Survey sv,
                          Survey_Def sd
                    WHERE sd.Survey_ID = sd.Survey_ID
                      AND sd.strCutoffResponse_CD = 2
                    GROUP BY
                          sd.Study_ID
                  ) msv,
                  Survey_Def sd,
                  MetaTable mt,
                  MetaField mf
            WHERE sd.Survey_ID = msv.Survey_ID
              AND sd.CutoffTable_ID = mt.Table_ID
              AND sd.CutoffField_ID = mf.Field_ID
         ) rd
   WHERE rd.Study_ID = cr.Study_ID

  EXEC dbo.PU_CM_TimeUsed 'Data Loading -- Step 2', @datBegin OUTPUT
    
  UPDATE cr
     SET IsEncounterTable = 1
    FROM #Criteria cr,
         MetaTable mt
   WHERE mt.Study_ID = cr.Study_ID
     AND mt.strTable_NM = 'Encounter'
    
  EXEC dbo.PU_CM_TimeUsed 'Data Loading -- Step 3', @datBegin OUTPUT
    
  -- SELECT * FROM #Criteria
  
  ----------------------------------------------------------
  -- Pull loading data
  ----------------------------------------------------------

  ---------------------------------------------------------
  -- Sampe batch script
  ---------------------------------------------------------
  -- 
  -- DELETE FROM Workflow.dbo.PUR_ResultLoading
  --  WHERE PUReport_ID = 2
  --
  -- INSERT INTO Workflow.dbo.PUR_ResultLoading
  -- SELECT 2 AS PUReport_ID,
  --        ds.DataSet_ID,
  --        8 AS Study_ID,
  --        'IP/ER' AS strStudy_NM,
  --        ds.datLoad_dt, 
  --        MIN(bv.EncounterServiceDate) AS ReportDateBegin,
  --        MAX(bv.EncounterServiceDate) AS ReportDateEnd,
  --        COUNT(*) AS RecNum,
  --        COUNT(DISTINCT bv.Pop_ID) AS PopNum
  --   FROM Data_Set ds,
  --        DatasetMember dsm,
  --        s8.Big_View bv
  --  WHERE ds.Study_ID = 8
  --    AND ds.datLoad_dt BETWEEN '2003/9/19 00:00:00.000'
  --                          AND '2003/9/25 23:59:59.997'
  --    AND dsm.Dataset_ID = ds.Dataset_ID
  --    AND bv.PopulationPop_ID = dsm.Pop_ID
  --    AND bv.EncounterEnc_ID = dsm.Enc_ID
  --  GROUP BY ds.Dataset_ID
  --
  -- INSERT INTO Workflow.dbo.PUR_ResultLoading
  -- SELECT 2 AS PUReport_ID,
  --        ds.DataSet_ID,
  --        684 AS Study_ID,
  --        'IP/ER' AS strStudy_NM,
  --        ds.datLoad_dt, 
  --        NULL AS ReportDateBegin,
  --        NULL AS ReportDateEnd,
  --        COUNT(*) AS RecNum,
  --        COUNT(DISTINCT bv.Pop_ID) AS PopNum
  --   FROM Data_Set ds,
  --        DatasetMember dsm,
  --        s684.Big_View bv
  --  WHERE ds.Study_ID = 8
  --    AND ds.datLoad_dt BETWEEN '2003/9/19 00:00:00.000'
  --                          AND '2003/9/25 23:59:59.997'
  --    AND dsm.Dataset_ID = ds.Dataset_ID
  --    AND bv.PopulationPop_ID = dsm.Pop_ID
  --  GROUP BY ds.Dataset_ID
  --
  -- ......
  --
  ---------------------------------------------------------


  -- Delete the old loading data
  
  SET @strSql = ''
  SET @strSql = @strSql + ' DELETE FROM Workflow.dbo.PUR_ResultLoading' + @strCR
  SET @strSql = @strSql + '  WHERE PUReport_ID = ' + @strPUReport_ID + @strCR + @strCR
  
  EXEC (@strSQL)
  
  DECLARE curCriteria CURSOR FOR
  SELECT Study_ID,
         strStudy_nm,
         ReportDateColumn,
         IsEncounterTable
    FROM #Criteria
  
  OPEN curCriteria
  FETCH curCriteria 
   INTO @strStudy_ID,
        @strStudy_nm,
        @strReportDateColumn,
        @bitIsEncounterTable
        
  WHILE @@FETCH_STATUS = 0 BEGIN
      /*
       * In some cases the query takes forever. Especially when 3 tables are joined in the view
       * (e.g. study 544, pop, encounter and clinic name tables are joined)
       * Split the query into 2 pieces will significantly improve the performance.
       * 
       
      SET @strSql = ''
      SET @strSql = @strSql + ' INSERT INTO Workflow.dbo.PUR_ResultLoading' + @strCR
      SET @strSql = @strSql + ' SELECT ' + @strPUReport_ID + ',' + @strCR
      SET @strSql = @strSql + '        ds.DataSet_ID,' + @strCR
      SET @strSql = @strSql + '        ' + @strStudy_ID + ',' + @strCR
      SET @strSql = @strSql + '        ''' + @strStudy_nm + ''',' + @strCR
      SET @strSql = @strSql + '        ds.datLoad_dt, ' + @strCR
      IF (@strReportDateColumn IS NULL) BEGIN
          SET @strSql = @strSql + '        NULL AS ReportDateBegin,' + @strCR
          SET @strSql = @strSql + '        NULL AS ReportDateEnd,' + @strCR
      END 
      ELSE BEGIN
          SET @strSql = @strSql + '        MIN(bv.' + @strReportDateColumn + ') AS ReportDateBegin,' + @strCR
          SET @strSql = @strSql + '        MAX(bv.' + @strReportDateColumn + ') AS ReportDateEnd,' + @strCR
      END
      SET @strSql = @strSql + '        COUNT(*) AS RecNum,' + @strCR
      SET @strSql = @strSql + '        COUNT(DISTINCT dsm.Pop_ID) AS PopNum' + @strCR
      SET @strSql = @strSql + '   FROM Data_Set ds,' + @strCR
      SET @strSql = @strSql + '        DatasetMember dsm,' + @strCR
      SET @strSql = @strSql + '        s' + @strStudy_ID + '.Big_View bv' + @strCR
      SET @strSql = @strSql + '  WHERE ds.Study_ID = ' + @strStudy_ID + @strCR
      SET @strSql = @strSql + '    AND ds.datLoad_dt BETWEEN ''' + @strActivityBeginDate + '''' + @strCR
      SET @strSql = @strSql + '                          AND ''' + @strActivityEndDate + '''' + @strCR
      SET @strSql = @strSql + '    AND dsm.Dataset_ID = ds.Dataset_ID' + @strCR
      SET @strSql = @strSql + '    AND bv.PopulationPop_ID = dsm.Pop_ID' + @strCR
      IF (@bitIsEncounterTable = 1)
          SET @strSql = @strSql + '    AND bv.EncounterEnc_ID = dsm.Enc_ID' + @strCR
      SET @strSql = @strSql + '  GROUP BY' + @strCR
      SET @strSql = @strSql + '        ds.Dataset_ID,' + @strCR
      SET @strSql = @strSql + '        ds.datLoad_dt' + @strCR + @strCR
       
       */

      SET @strSql = ''
      SET @strSql = @strSql + ' SELECT ds.DataSet_ID,' + @strCR
      SET @strSql = @strSql + '        ds.datLoad_dt, ' + @strCR
      SET @strSql = @strSql + '        dsm.Pop_ID, ' + @strCR
      SET @strSql = @strSql + '        dsm.Enc_ID ' + @strCR
      SET @strSql = @strSql + '   INTO dbo.#Tmp' + @strCR
      SET @strSql = @strSql + '   FROM Data_Set ds,' + @strCR
      SET @strSql = @strSql + '        DatasetMember dsm' + @strCR
      SET @strSql = @strSql + '  WHERE ds.Study_ID = ' + @strStudy_ID + @strCR
      SET @strSql = @strSql + '    AND ds.datLoad_dt BETWEEN ''' + @strActivityBeginDate + '''' + @strCR
      SET @strSql = @strSql + '                          AND ''' + @strActivityEndDate + '''' + @strCR
      SET @strSql = @strSql + '    AND dsm.Dataset_ID = ds.Dataset_ID' + @strCR + @strCR

      SET @strSql = @strSql + ' INSERT INTO Workflow.dbo.PUR_ResultLoading' + @strCR
      SET @strSql = @strSql + ' SELECT ' + @strPUReport_ID + ',' + @strCR
      SET @strSql = @strSql + '        ds.DataSet_ID,' + @strCR
      SET @strSql = @strSql + '        ' + @strStudy_ID + ',' + @strCR
      SET @strSql = @strSql + '        ''' + @strStudy_nm + ''',' + @strCR
      SET @strSql = @strSql + '        ds.datLoad_dt, ' + @strCR
      IF (@strReportDateColumn IS NULL) BEGIN
          SET @strSql = @strSql + '        NULL AS ReportDateBegin,' + @strCR
          SET @strSql = @strSql + '        NULL AS ReportDateEnd,' + @strCR
      END 
      ELSE BEGIN
          SET @strSql = @strSql + '        MIN(bv.' + @strReportDateColumn + ') AS ReportDateBegin,' + @strCR
          SET @strSql = @strSql + '        MAX(bv.' + @strReportDateColumn + ') AS ReportDateEnd,' + @strCR
      END
      SET @strSql = @strSql + '        COUNT(*) AS RecNum,' + @strCR
      SET @strSql = @strSql + '        COUNT(DISTINCT ds.Pop_ID) AS PopNum' + @strCR
      SET @strSql = @strSql + '   FROM #Tmp ds,' + @strCR
      SET @strSql = @strSql + '        s' + @strStudy_ID + '.Big_View bv' + @strCR
      SET @strSql = @strSql + '  WHERE bv.PopulationPop_ID = ds.Pop_ID' + @strCR
      IF (@bitIsEncounterTable = 1)
          SET @strSql = @strSql + '    AND bv.EncounterEnc_ID = ds.Enc_ID' + @strCR
      SET @strSql = @strSql + '  GROUP BY' + @strCR
      SET @strSql = @strSql + '        ds.Dataset_ID,' + @strCR
      SET @strSql = @strSql + '        ds.datLoad_dt' + @strCR + @strCR

      -- PRINT @strSQL
      EXEC (@strSQL)
      IF @@ERROR <> 0 RETURN 2
      
      FETCH curCriteria 
       INTO @strStudy_ID,
            @strStudy_nm,
            @strReportDateColumn,
            @bitIsEncounterTable

  END      
  
  CLOSE curCriteria
  DEALLOCATE curCriteria

  EXEC dbo.PU_CM_TimeUsed 'Data Loading -- Step 4', @datBegin OUTPUT
  
  RETURN -1


