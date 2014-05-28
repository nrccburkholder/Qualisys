/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_SampleSetInPeriod
 *
 * Description:
 *           Pull update report list that client user can access
 *
 * Parameters:
 *           @ClientUser_ID     int
 *                Client user ID
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  4/30/2004 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_UI_SampleSetInPeriod (
                       @Survey_ID   int,
                       @PeriodType  int
                       
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @PERIOD_CURRENT      tinyint,
          @PERIOD_PERVIOUS     tinyint
  
  SET @PERIOD_CURRENT = dbo.PU_CM_GetConstant('PERIOD_CURRENT')
  SET @PERIOD_PERVIOUS = dbo.PU_CM_GetConstant('PERIOD_PERVIOUS') 

  --
  -- Pull last 2 periods
  --
  -- Some special things we need to consider in this query statement:
  -- 1. If a period is planned but no any sample is completed, we will 
  --    not pull this period
  -- 2. If some of the samples in a period are completed, and some are not,
  --    this period is the current period. We will set today's date as 
  --    period "last sample create date".
  -- 3. If a period is finished, which means all planned samples are sampled,
  --    we will pull all the non-oversampled samples, find the max sample 
  --    create date and set this date as period "last sample create date".
  -- 4. A period can be finished without sampling all planned samples. In this case,
  --    the sample create date for the unprocessed sample will have "1900/1/1' 
  --    as sample create date, and null as sample set ID.
  --
  SELECT TOP 2
         p.PeriodDef_ID,
         MIN(pd.datSampleCreate_DT) AS FirstSampleCreate_Dt,
         MAX(ISNULL(pd.datSampleCreate_DT, '9999/12/31')) AS LastSampleCreate_Dt,
         @PERIOD_CURRENT AS PeriodType
    INTO #Last2Period
    FROM (
          SELECT DISTINCT
                 p.PeriodDef_ID
            FROM PeriodDef p,
                 PeriodDates pd
           WHERE p.Survey_ID = @Survey_ID
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

  -- 
  -- Set previous period
  --
  IF @@ROWCOUNT > 1 BEGIN
      UPDATE p1
         SET PeriodType = @PERIOD_PERVIOUS
        FROM #Last2Period p1,
             #Last2Period p2
       WHERE p1.LastSampleCreate_Dt < p2.LastSampleCreate_Dt
  END

  --
  -- Output general info (study, survey, date range, etc.)
  --
  SELECT RTRIM(st.strStudy_Nm) + ' (' + CONVERT(varchar, st.Study_ID) + ')' AS Study,
         RTRIM(sv.strSurvey_Nm) + ' (' + CONVERT(varchar, sv.Survey_ID) + ')' AS Survey,
         CASE @PeriodType
           WHEN @PERIOD_CURRENT  THEN 'Current Period'
           WHEN @PERIOD_PERVIOUS THEN 'Pervious Period'
           END AS PeriodType,
         CONVERT(varchar, lp.FirstSampleCreate_Dt, 101) + ' - ' +
            CASE
              WHEN lp.LastSampleCreate_Dt > GETDATE() THEN 'Present'
              ELSE CONVERT(varchar, DATEADD(dd, -1, lp.LastSampleCreate_Dt), 101)
              END AS DateRange
  FROM Survey_Def sv,
       Study st
       LEFT JOIN #Last2Period lp
         ON lp.PeriodType = @PeriodType
 WHERE sv.Survey_ID = @Survey_ID
   AND st.Study_ID = sv.Study_ID

    
  --
  -- Output sample sets in specified period
  --
  SELECT ss.SampleSet_ID,
         ss.datSampleCreate_Dt AS SampleDate,
         ssd.MinReportDate AS FromDate,
         ssd.MaxReportDate AS ToDate,
         CASE ss.tiOverSample_Flag
           WHEN 1 THEN 'Yes'
           ELSE 'No'
           END AS OverSampled,
         em.strEmployee_First_Nm + ' ' + em.strEmployee_Last_Nm AS SampledBy
    FROM #Last2Period lp,
         PeriodDates pd,
         SampleSet ss
         LEFT JOIN Workflow.dbo.SampleSetDate ssd
           ON ssd.SampleSet_ID = ss.SampleSet_ID,
         Employee em
   WHERE lp.PeriodType = @PeriodType
     AND pd.PeriodDef_ID = lp.PeriodDef_ID
     AND ss.SampleSet_ID = pd.SampleSet_ID
     AND em.Employee_ID = ss.Employee_ID
   ORDER BY ss.SampleSet_ID

  RETURN -1


