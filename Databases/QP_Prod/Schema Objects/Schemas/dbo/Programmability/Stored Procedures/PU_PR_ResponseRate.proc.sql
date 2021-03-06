﻿/*******************************************************************************
 *
 * Procedure Name:
 *           PU_PR_ResponseRate
 *
 * Description:
 *           Pull response rate result
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
CREATE PROCEDURE dbo.PU_PR_ResponseRate (
                       @PUReport_ID          int
) AS

  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  -- Constants
  DECLARE @YES                     tinyint,
          @NO                      tinyint,
          @PERIOD_CURRENT          tinyint,
          @PERIOD_PERVIOUS         tinyint,
          @SAMPLING_METHOD_CENSUS  int
  
  SET @YES = dbo.PU_CM_GetConstant('YES')
  SET @NO = dbo.PU_CM_GetConstant('NO')
  SET @PERIOD_CURRENT = dbo.PU_CM_GetConstant('PERIOD_CURRENT')
  SET @PERIOD_PERVIOUS = dbo.PU_CM_GetConstant('PERIOD_PERVIOUS') 
  SET @SAMPLING_METHOD_CENSUS = dbo.PU_CM_GetConstant('SAMPLING_METHOD_CENSUS')

  -- Variables
  DECLARE @intRRDetail           tinyint,
          @intTier               tinyint,
          @datBegin              datetime
          
  SET @datBegin = GETDATE()

  ----------------------------------------------------------
  -- Init
  ----------------------------------------------------------
  SELECT @intRRDetail = RRDetail
    FROM #PUR_Report
   WHERE PUReport_ID = @PUReport_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 1', @datBegin OUTPUT

  ----------------------------------------------------------
  -- Pull last 2 periods for each survey
  ----------------------------------------------------------
  CREATE TABLE #Last2Period (
         Survey_ID           int NOT NULL,
         PeriodDef_ID        int NOT NULL,
         SamplingMethod_ID   int NOT NULL,
         PeriodType          int NOT NULL,
         LastSampleCreate_Dt datetime NULL
  )
  
  -- Pull last 2 periods for each survey
  INSERT INTO #Last2Period (
          Survey_ID,
          PeriodDef_ID,
          SamplingMethod_ID,
          PeriodType
         )
  SELECT p.Survey_ID,
         p.PeriodDef_ID,
         p.SamplingMethod_ID,
         @PERIOD_CURRENT AS PeriodType
    FROM (
          SELECT DISTINCT
                 Survey_ID
            FROM #PUR_Period
         ) sv
         JOIN PeriodDef p
           ON p.Survey_ID = sv.Survey_ID
   WHERE p.PeriodDef_ID IN (
           SELECT TOP 2 
                  p.PeriodDef_ID
             FROM (
                   SELECT DISTINCT
                          p.PeriodDef_ID
                     FROM PeriodDef p,
                          PeriodDates pd
                    WHERE p.Survey_ID = sv.Survey_ID
                      AND pd.PeriodDef_ID = p.PeriodDef_ID
                      AND pd.datSampleCreate_DT IS NOT NULL
                  ) vp,
                  PeriodDef p,
                  PeriodDates pd
            WHERE p.PeriodDef_ID = vp.PeriodDef_ID
              AND pd.PeriodDef_ID = p.PeriodDef_ID
              AND pd.SampleNumber <= p.intExpectedSamples
            GROUP BY p.PeriodDef_ID
            ORDER BY MAX(ISNULL(pd.datSampleCreate_DT, '9999/12/31')) DESC
         )

  -- Set "Last sample create date" for each period
  UPDATE lp
     SET LastSampleCreate_Dt = p.LastSampleCreate_Dt
    FROM #Last2Period lp,
         (
           SELECT p.PeriodDef_ID,
                  MAX(ISNULL(pd.datSampleCreate_DT, '9999/12/31')) AS LastSampleCreate_Dt
             FROM #Last2Period lp,
                  PeriodDef p,
                  PeriodDates pd
            WHERE p.PeriodDef_ID = lp.PeriodDef_ID
              AND pd.PeriodDef_ID = p.PeriodDef_ID
              AND pd.SampleNumber <= p.intExpectedSamples
            GROUP BY p.PeriodDef_ID
         ) p
   WHERE p.PeriodDef_ID = lp.PeriodDef_ID
   
  -- Find out previous period
  UPDATE p1
     SET PeriodType = @PERIOD_PERVIOUS
    FROM #Last2Period p1,
         #Last2Period p2
   WHERE p1.Survey_ID = p2.Survey_ID
     AND p1.LastSampleCreate_Dt < p2.LastSampleCreate_Dt
  
  ----------------------------------------------------------
  -- Pull sample set for each survey and period
  ----------------------------------------------------------
  CREATE TABLE #SelectedSampleSet (
         Survey_ID              int,
         Period_ID              tinyint,
         SampleSet_ID           int,
         SamplingMethod_ID      int,
         datDateRange_FromDate  datetime,
         datDateRange_ToDate    datetime
  )
  
  INSERT INTO #SelectedSampleSet (
          Survey_ID,
          Period_ID,
          SampleSet_ID,
          SamplingMethod_ID,
          datDateRange_FromDate,
          datDateRange_ToDate
         )
  -- Pull sample set for current/previous period
  SELECT pd.Survey_ID,
         pd.Period_ID,
         ss.SampleSet_ID,
         lp.SamplingMethod_ID,
         ss.datDateRange_FromDate,
         ss.datDateRange_ToDate
    FROM #PUR_Period pd,
         #Last2Period lp,
         PeriodDates pdt,
         SampleSet ss
   WHERE lp.Survey_ID = pd.Survey_ID
     AND lp.PeriodType = pd.PeriodType
     AND pdt.PeriodDef_ID = lp.PeriodDef_ID
     AND ss.SampleSet_ID = pdt.SampleSet_ID
  UNION
  -- Pull sample set for custom period
  SELECT pd.Survey_ID,
         pd.Period_ID,
         pc.SampleSet_ID,
         pdf.SamplingMethod_ID,
         ss.datDateRange_FromDate,
         ss.datDateRange_ToDate
    FROM #PUR_Period pd,
         #PUR_PeriodCustom pc,
         SampleSet ss,
         PeriodDates pdt,
         PeriodDef pdf
   WHERE pc.PUReport_ID = pd.PUReport_ID
     AND pc.Survey_ID = pd.Survey_ID
     AND pc.Period_ID = pd.Period_ID
     AND ss.SampleSet_ID = pc.SampleSet_ID
     AND pdt.SampleSet_ID = pc.SampleSet_ID
     AND pdf.PeriodDef_ID = pdt.PeriodDef_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 2', @datBegin OUTPUT

  ----------------------------------------------------------
  -- Pull response rate from Datamart
  -- if any sample set for one sample unit uses census
  -- sampling methodology, set "HasCensusSampling" to "Yes"
  -- for this sample unit
  ----------------------------------------------------------
  SELECT ss.Survey_ID,
         ss.Period_ID,
         rr.SampleUnit_ID,
         ISNULL(SUM(rr.intSampled), 0) AS Sampled,
         ISNULL(SUM(rr.intUD), 0) as Undel,
         ISNULL(SUM(rr.intReturned), 0) AS Returned,
         MAX(
             CASE ss.SamplingMethod_ID
               WHEN @SAMPLING_METHOD_CENSUS THEN @YES
               ELSE @NO
               END
            ) AS HasCensusSampling
    INTO #ResponseRate
    FROM #SelectedSampleSet ss,
         Workflow.dbo.RespRateCount rr
   WHERE rr.SampleSet_ID = ss.SampleSet_ID
     AND rr.Survey_ID = ss.Survey_ID
   GROUP BY
         ss.Survey_ID,
         ss.Period_ID,
         rr.SampleUnit_ID

  ----------------------------------------------------------
  -- Pull sample units, their target and their mail result 
  -- for each survey and period
  -- Note that for census sampling, the target is estimated
  -- and not accurate, we will not use it in the response rate
  -- report but leave target blank.
  ----------------------------------------------------------
  CREATE TABLE #SampleUnitResult (
         Survey_ID              int NOT NULL,
         Period_ID              tinyint NOT NULL,
         SampleUnit_ID          int NOT NULL,
         datDateRange_FromDate  datetime NULL,
         datDateRange_ToDate    datetime NULL,
         ParentSampleUnit_ID    int NULL,
         Tier                   tinyint NULL,
         TreeOrder              int NULL,
         HasCensusSampling      bit NULL,
         Target                 int NULL DEFAULT 0,
         KidTarget              int NULL DEFAULT 0,
         Sampled                int NULL DEFAULT 0,
         Undel                  int NULL DEFAULT 0,
         Returned               int NULL DEFAULT 0
  )

  INSERT INTO #SampleUnitResult (
         Survey_ID,
         Period_ID,
         SampleUnit_ID,
         datDateRange_FromDate,
         datDateRange_ToDate,
         ParentSampleUnit_ID,
         Tier,
         TreeOrder,
         HasCensusSampling,
         Target,
         Sampled,
         Undel,
         Returned
         )
  SELECT sv.Survey_ID,
         rr.Period_ID,
         ut.SampleUnit_ID,
         dr.datDateRange_FromDate,
         dr.datDateRange_ToDate,
         ut.ParentSampleUnit_ID,
         ut.Tier,
         ut.TreeOrder,
         rr.HasCensusSampling,
         CASE rr.HasCensusSampling
           WHEN @NO THEN ut.Target
           ELSE NULL
           END AS Target,
         rr.Sampled,
         rr.Undel,
         rr.Returned
    FROM #PUR_Survey sv,
         SampleUnitTree ut,
         #ResponseRate rr,
/*         
         ( -- date range (using sampleset datDateRange_FromDate/datDateRange_ToDate)
          SELECT Survey_ID,
                 Period_ID,
                 MIN(datDateRange_FromDate) AS datDateRange_FromDate,
                 MAX(datDateRange_ToDate) AS datDateRange_ToDate
            FROM #SelectedSampleSet
           GROUP BY 
                 Survey_ID,
                 Period_ID
         ) dr
*/
         ( -- date range (using sampleset min/max report date)
          SELECT ss.Survey_ID,
                 ss.Period_ID,
                 MIN(ssd.MinReportDate) AS datDateRange_FromDate,
                 MAX(ssd.MaxReportDate) AS datDateRange_ToDate
            FROM #SelectedSampleSet ss,
                 Workflow.dbo.SampleSetDate ssd
           WHERE ssd.SampleSet_ID = ss.SampleSet_ID
           GROUP BY 
                 ss.Survey_ID,
                 ss.Period_ID
         ) dr
   WHERE ut.Survey_ID = sv.Survey_ID
     AND ut.bitSuppress = 0
     AND rr.Survey_ID = sv.Survey_ID
     AND rr.SampleUnit_ID = ut.SampleUnit_ID
     AND dr.Survey_ID = sv.Survey_ID
     AND dr.Period_ID = rr.Period_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 3', @datBegin OUTPUT

  -- Add those targeted but not sampled sample units.
  -- For units using census sampling, we add these units but
  -- leave target null
  INSERT INTO #SampleUnitResult (
         Survey_ID,
         Period_ID,
         SampleUnit_ID,
         ParentSampleUnit_ID,
         Tier,
         TreeOrder,
         HasCensusSampling,
         Target
         )
  SELECT au.Survey_ID,
         au.Period_ID,
         au.SampleUnit_ID,
         au.ParentSampleUnit_ID,
         au.Tier,
         au.TreeOrder,
         au.HasCensusSampling,
         au.Target
    FROM (
          SELECT sv.Survey_ID,
                 pd.Period_ID,
                 ut.SampleUnit_ID,
                 ut.ParentSampleUnit_ID,
                 ut.Tier,
                 ut.TreeOrder,
                 CASE lp.SamplingMethod_ID 
                   WHEN @SAMPLING_METHOD_CENSUS THEN @YES
                   ELSE @NO
                   END AS HasCensusSampling,
                 CASE lp.SamplingMethod_ID 
                   WHEN @SAMPLING_METHOD_CENSUS THEN NULL
                   ELSE ut.Target
                   END AS Target
            FROM #PUR_Survey sv,
                 #PUR_Period pd,
                 #Last2Period lp,
                 SampleUnitTree ut
           WHERE pd.PUReport_ID = sv.PUReport_ID
             AND pd.Survey_ID = sv.Survey_ID
             AND lp.Survey_ID = pd.Survey_ID
             AND lp.PeriodType = pd.PeriodType
--             AND lp.SamplingMethod_ID <> @SAMPLING_METHOD_CENSUS
             AND ut.Survey_ID = sv.Survey_ID
             AND ut.bitSuppress = 0
         ) au
         LEFT JOIN #SampleUnitResult ur
           ON au.Survey_ID = ur.Survey_ID
              AND au.Period_ID = ur.Period_ID
              AND au.SampleUnit_ID = ur.SampleUnit_ID
   WHERE ur.Survey_ID IS NULL
   
  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 3.5', @datBegin OUTPUT
  
  ----------------------------------------------------------
  -- For each sample unit, sum up the target of all the 
  -- child sample units
  ----------------------------------------------------------
  
  SELECT @intTier = MAX(Tier)
    FROM #SampleUnitResult
  
  WHILE @intTier >= 2 BEGIN
      UPDATE pa
         SET KidTarget = kt.KidTarget
        FROM #SampleUnitResult pa,     -- parent sample unit
             (                         -- sum up of kid unit's target
              SELECT pu.SampleUnit_ID,
                     SUM(cu.Target) KidTarget
                FROM #SampleUnitResult pu,    -- parent sample unit
                     #SampleUnitResult cu     -- child sample unit
               WHERE cu.Tier = @intTier
                 AND pu.SampleUnit_ID = cu.ParentSampleUnit_ID
               GROUP BY
                     pu.SampleUnit_ID
             ) kt
       WHERE pa.SampleUnit_ID = kt.SampleUnit_ID
      
      SET @intTier = @intTier - 1
  END
         
  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 4', @datBegin OUTPUT

  -- Delete surveys that have never sampled
  DELETE FROM ur
    FROM #SampleUnitResult ur,
         (  -- Unsampled survey
          SELECT Survey_ID,
                 Period_ID
            FROM #SampleUnitResult
           GROUP BY 
                 Survey_ID,
                 Period_ID
          HAVING SUM(Sampled) = 0
         ) us
   WHERE ur.Survey_ID = us.Survey_ID
     AND ur.Period_ID = us.Period_ID
   
  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 5', @datBegin OUTPUT

  -- For non-census-sampling sample units,
  -- delete those that have never sampled and have target and kid target of 0
  DELETE FROM #SampleUnitResult
   WHERE HasCensusSampling = @NO
     AND (Target = 0 OR Target IS NULL)
     AND (KidTarget = 0 OR KidTarget IS NULL)
     AND Sampled = 0

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 6', @datBegin OUTPUT

  -- Sort the output data and get the order ID
  CREATE TABLE #ResultResponseRate (
         Order_ID               int NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
         Study_ID               int NOT NULL,
         strStudy_Nm            varchar(25) NOT NULL,
         Survey_ID              int NOT NULL,
         strSurvey_Nm           varchar(25) NOT NULL,
         Period_ID              tinyint NOT NULL,
         SampleUnit_ID          int NULL,
         strSampleUnit_nm       varchar(42) NULL,
         datDateRange_FromDate  datetime NULL,
         datDateRange_ToDate    datetime NULL,
         Target                 int NULL,
         Sampled                int NULL,
         Undel                  int NULL,
         Returned               int NULL,
         RespRate               decimal(7, 6) NULL,
         Tier                   int NOT NULL
  )
  
  INSERT INTO #ResultResponseRate (
          Study_ID,
          strStudy_Nm,
          Survey_ID,
          strSurvey_Nm,
          Period_ID,
          SampleUnit_ID,
          strSampleUnit_nm,
          datDateRange_FromDate,
          datDateRange_ToDate,
          Target,
          Sampled,
          Undel,
          Returned,
          RespRate,
          Tier
  )
  SELECT st.Study_ID,
         st.strStudy_Nm,
         ur.Survey_ID,
         sv.strSurvey_Nm,
         ur.Period_ID,
         ur.SampleUnit_ID,
         su.strSampleUnit_nm,
         ur.datDateRange_FromDate,
         ur.datDateRange_ToDate,
         ur.Target,
         ur.Sampled,
         ur.Undel,
         ur.Returned,
         CASE
           WHEN ur.Sampled = ur.Undel THEN NULL
           ELSE 1.0 * ur.Returned / (ur.Sampled - ur.Undel)
           END AS RespRate,
         ur.Tier
    FROM #SampleUnitResult ur,
         SampleUnit su,
         Survey_Def sv,
         Study st
   WHERE ur.Tier <= @intRRDetail
     AND su.SampleUnit_ID = ur.SampleUnit_ID
     AND sv.Survey_ID = ur.Survey_ID
     AND st.Study_ID = sv.Study_ID
   ORDER BY
         RTRIM(st.strStudy_Nm) + ' - ' + RTRIM(sv.strSurvey_Nm),
         ur.Survey_ID,
         ur.Period_ID,
         ur.TreeOrder

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 7', @datBegin OUTPUT

  -- Output result data
  BEGIN TRAN
  
  DELETE FROM Workflow.dbo.PUR_ResultResponseRate
   WHERE PUReport_ID = @PUReport_ID
  
  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 8', @datBegin OUTPUT

  INSERT INTO Workflow.dbo.PUR_ResultResponseRate (
          PUReport_ID,
          Order_ID,
          Study_ID,
          strStudy_Nm,
          Survey_ID,
          strSurvey_Nm,
          Period_ID,
          SampleUnit_ID,
          strSampleUnit_Nm,
          datDateRange_FromDate,
          datDateRange_ToDate,
          Target,
          Sampled,
          Undel,
          Returned,
          RespRate,
          Tier,
          RRDetail
         )
  SELECT @PUReport_ID,
         Order_ID,
         Study_ID,
         strStudy_Nm,
         Survey_ID,
         strSurvey_Nm,
         Period_ID,
         SampleUnit_ID,
         strSampleUnit_nm,
         datDateRange_FromDate,
         datDateRange_ToDate,
         Target,
         Sampled,
         Undel,
         Returned,
         RespRate,
         Tier,
         @intRRDetail 
    FROM #ResultResponseRate
   ORDER BY
         Order_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 9', @datBegin OUTPUT

  DELETE FROM Workflow.dbo.PUR_ResultResponseRateCutOffField
   WHERE PUReport_ID = @PUReport_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 10', @datBegin OUTPUT

  INSERT INTO Workflow.dbo.PUR_ResultResponseRateCutOffField (
          PUReport_ID,
          Survey_ID,
          CutOffTable,
          CutOffField
         )
  SELECT @PUReport_ID,
         sv.Survey_ID,
         mt.strTable_nm,
         mf.strField_nm
    FROM (
          SELECT DISTINCT
                 Survey_ID
            FROM #ResultResponseRate
         ) sv,
         Survey_Def sd,
         MetaTable mt,
         MetaField mf
   WHERE sd.Survey_ID = sv.Survey_ID
     AND sd.CutoffTable_ID = mt.Table_ID
     AND sd.CutoffField_ID = mf.Field_ID

  EXEC dbo.PU_CM_TimeUsed 'Response Rate -- Step 11', @datBegin OUTPUT
  
  COMMIT TRAN
   
  RETURN -1


