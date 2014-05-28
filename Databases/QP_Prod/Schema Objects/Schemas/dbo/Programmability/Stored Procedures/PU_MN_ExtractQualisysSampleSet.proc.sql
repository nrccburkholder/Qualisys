/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractQualisysSampleSet
 *
 * Description:
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_MN_ExtractQualisysSampleSet
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  DECLARE @MaxSampleSet_ID  varchar(15),
          @Study_ID         varchar(15),
          @ReportDateColumn varchar(128),
          @IsEncounterTable bit,
          @Sql              varchar(8000),
          @SqlKey           varchar(500),
          @datBegin         datetime,
          @intReturn        int,
          @i                int

  SELECT @MaxSampleSet_ID = MAX(SampleSet_ID)
    FROM SampleSet

  SELECT sd.Study_ID,
         mt.strTable_nm + mf.strField_nm AS ReportDateColumn,
         CASE mt.strTable_NM
           WHEN 'Encounter' THEN 1
           ELSE 0
           END AS IsEncounterTable,
         ss.SampleSet_ID
    INTO #NewSampleSet
    FROM (
          SELECT ss.SampleSet_ID,
                 ss.Survey_ID
            FROM SampleSet ss
                 LEFT JOIN Workflow.dbo.SampleSetDate_Test ssd
                   ON ss.SampleSet_ID = ssd.SampleSet_ID
           WHERE ssd.SampleSet_ID IS NULL
        ) ss,
         Survey_Def sd,
         dbo.sysobjects so,
         MetaTable mt,
         MetaField mf
   WHERE sd.Survey_ID = ss.Survey_ID
     AND so.id = object_id('s' + CONVERT(varchar, sd.Study_ID) + '.Big_View')
     AND OBJECTPROPERTY(so.id, N'IsView') = 1
     AND sd.CutoffTable_ID = mt.Table_ID
     AND sd.CutoffField_ID = mf.Field_ID
   ORDER BY
         sd.Study_ID,
         ReportDateColumn,
         IsEncounterTable
  
  CREATE CLUSTERED INDEX Idx_NewSampleSet_1 ON #NewSampleSet(Study_ID, ReportDateColumn, IsEncounterTable)
  
  DECLARE curCriteria CURSOR FOR
  SELECT DISTINCT
         Study_ID,
         ReportDateColumn,
         IsEncounterTable
    FROM #NewSampleSet
   ORDER BY
         Study_ID,
         ReportDateColumn
  
  OPEN curCriteria
  FETCH curCriteria INTO @Study_ID, @ReportDateColumn, @IsEncounterTable

  SET @datBegin = GETDATE()
  SET @i = 1
  WHILE @@FETCH_STATUS = 0 BEGIN
      SET @SqlKey = '
              AND bv.PopulationPop_ID = se.Pop_ID
          '
      IF (@IsEncounterTable = 1) BEGIN
          SET @SqlKey = @SqlKey + '
              AND bv.EncounterEnc_ID = se.Enc_ID
          '
      END
      
      SET @Sql = '
           INSERT INTO Workflow.dbo.SampleSetDate_Test (
                   SampleSet_ID,
                   MinReportDate,
                   MaxReportDate
                  )
           SELECT ss.SampleSet_ID,
                  MIN(bv.' + @ReportDateColumn + ') AS MinReportDate,
                  MAX(bv.' + @ReportDateColumn + ') AS MaxReportDate
             FROM #NewSampleSet ss,
                  SelectedSample se (NOLOCK),
                  s' + @Study_ID + '.Big_View bv (NOLOCK)
            WHERE ss.Study_ID = ' + @Study_ID + '
              AND ss.ReportDateColumn = ''' + @ReportDateColumn + '''
              AND ss.IsEncounterTable = ' + CONVERT(varchar, @IsEncounterTable) + '
              AND se.SampleSet_ID = ss.SampleSet_ID ' + 
                  @SqlKey + '
              AND (
                   bv.' + @ReportDateColumn + ' IS NOT NULL
                   OR ss.SampleSet_ID < ' + @MaxSampleSet_ID + ' - 5000
                  )
            GROUP BY ss.SampleSet_ID
          '
      
      EXEC(@Sql)
      
      EXEC dbo.PU_CM_TimeUsed  @Study_ID, @datBegin OUTPUT
      SET @i = @i + 1
      -- IF (@i > 10) BREAK
      
      FETCH curCriteria INTO @Study_ID, @ReportDateColumn, @IsEncounterTable
  END
  
  CLOSE curCriteria
  DEALLOCATE curCriteria
  
  RETURN -1


