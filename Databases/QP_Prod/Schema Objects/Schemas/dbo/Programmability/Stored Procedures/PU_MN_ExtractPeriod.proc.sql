/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractPeriod
 *
 * Description:
 *           Extract survey's current and previous sample period
 *           
 *           e.g.
 *             Period 1 (2003/5/1)
 *               Sampling 1 (2003/5/2)
 *               Sampling 2 (2003/5/5)
 *             Period 2 (2003/6/1)
 *             Period 3 (2003/7/1)
 *               Sampling 3 (2003/7/8)
 *             Period 4 (2003/8/1)
 *               Sampling 4 (2003/8/3)
 *
 *             Current period is:  2003/8/3 -- present
 *             Previous period is: 2003/6/1 -- 2003/8/1
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
CREATE PROCEDURE dbo.PU_MN_ExtractPeriod
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  -- Constants
  DECLARE @PERIOD_CURRENT      tinyint,
          @PERIOD_PERVIOUS     tinyint
  
  SET @PERIOD_CURRENT = dbo.PU_CM_GetConstant('PERIOD_CURRENT')
  SET @PERIOD_PERVIOUS = dbo.PU_CM_GetConstant('PERIOD_PERVIOUS') 
  
  
  -------------------------------
  -- Current and previous period
  -------------------------------
  CREATE TABLE #CleanPeriod (
         Survey_ID        int,
         PeriodDate       datetime
  )

  --
  -- Find all the periods that have sample sets in the period.
  -- Use the end date point of these period as the begin date point
  -- of the next effective period.
  -- Find the miniumn period date point and use it as the begin date
  -- point of the first effective period
  --
  INSERT INTO #CleanPeriod (
         Survey_ID,
         PeriodDate
  )
  SELECT DISTINCT
         pd.Survey_ID,
         pd.PeriodEndDate AS PeriodDate
    FROM ( -- Pull all the period
          SELECT pe.Survey_ID,
                 MAX(pb.datPeriodDate) AS PeriodBeginDate,
                 pe.datPeriodDate AS PeriodEndDate
            FROM Period pb (NOLOCK),      -- period begin date point
                 Period pe (NOLOCK)       -- period end date point
           WHERE pb.Survey_ID = pe.Survey_ID
             AND pb.datPeriodDate < pe.datPeriodDate
           GROUP BY 
                 pe.Survey_ID,
                 pe.datPeriodDate
          UNION
          -- Last period
          SELECT Survey_ID,
                 MAX(datPeriodDate) AS PeriodBeginDate,
                 CONVERT(datetime, '2999/12/31') AS PeriodEndDate
            FROM Period (NOLOCK)
           GROUP BY Survey_ID
         ) pd,
         SampleSet ss (NOLOCK)
   WHERE ss.Survey_ID = pd.Survey_ID
     AND ss.datSampleCreate_Dt >= pd.PeriodBeginDate
     AND ss.datSampleCreate_Dt < pd.PeriodEndDate
     AND ss.web_extract_flg IS NOT NULL
  UNION
  SELECT Survey_ID,
         MIN(datPeriodDate) AS PeriodDate
    FROM Period (NOLOCK)
   GROUP BY Survey_ID
  
  IF (@@ERROR <> 0) RETURN 1


  -- If the date for the first sample set is earlier than the first period data point,
  -- add a period using the date of first sample set
  INSERT INTO #CleanPeriod (
         Survey_ID,
         PeriodDate
  )
  SELECT pd.Survey_ID,
         ss.SampleMinDate AS PeriodDate
    FROM (
          SELECT Survey_ID,
                 MIN(PeriodDate) AS PeriodMinDate
            FROM #CleanPeriod
           GROUP BY Survey_ID
         ) pd,
         (
          SELECT Survey_ID,
                 MIN(datSampleCreate_Dt) AS SampleMinDate
            FROM SampleSet (NOLOCK)
           GROUP BY Survey_ID
         ) ss
   WHERE ss.Survey_ID = pd.Survey_ID
     AND ss.SampleMinDate < pd.PeriodMinDate


  -- For those surveys that sampled but no period,
  -- add a period of min sample date, and add a period of max date
  SELECT DISTINCT
         ss.Survey_ID
    INTO #SurveyNoPeriod
    FROM SampleSet ss (NOLOCK)
         LEFT JOIN Period pd (NOLOCK)
           ON ss.Survey_ID = pd.Survey_ID
   WHERE pd.Survey_ID IS NULL

  INSERT INTO #CleanPeriod (
         Survey_ID,
         PeriodDate
         )
  SELECT ss.Survey_ID,
         MIN(ss.datSampleCreate_Dt) AS SampleMinDate
    FROM SampleSet ss (NOLOCK),
         #SurveyNoPeriod np
   WHERE ss.Survey_ID = np.Survey_ID
   GROUP BY ss.Survey_ID

  INSERT INTO #CleanPeriod (
         Survey_ID,
         PeriodDate
         )
  SELECT Survey_ID,
         '2999/12/31' AS PeriodDate
    FROM #SurveyNoPeriod
    
  -- Delete the old data
  TRUNCATE TABLE Last2Period

  IF (@@ERROR <> 0) RETURN 2
  

  -- Current period
  INSERT INTO Last2Period (
          Survey_ID,
          PeriodType,
          PeriodBeginDate,
          PeriodEndDate
         )
  SELECT ed.Survey_ID,
         @PERIOD_CURRENT,
         MAX(bd.PeriodDate) AS PeriodBeginDate,
         ed.PeriodEndDate
    FROM (      -- Get period end date from this subquery
          SELECT Survey_ID,
                 MAX(PeriodDate) AS PeriodEndDate
            FROM #CleanPeriod
           GROUP BY Survey_ID
         ) ed,
         #CleanPeriod bd  -- Get period begin date from this table
   WHERE bd.Survey_ID = ed.Survey_ID
     AND bd.PeriodDate < ed.PeriodEndDate
   GROUP BY 
         ed.Survey_ID,
         ed.PeriodEndDate
   
  IF (@@ERROR <> 0) RETURN 3
  

  -- Previous period
  -- Use the "Period Begin Date" of current period
  -- as the "Period End Date" of previous period
  INSERT INTO Last2Period (
          Survey_ID,
          PeriodType,
          PeriodBeginDate,
          PeriodEndDate
         )
  SELECT ed.Survey_ID,
         @PERIOD_PERVIOUS,
         MAX(bd.PeriodDate) AS PeriodBeginDate,
         ed.PeriodBeginDate AS PeriodEndDate
    FROM Last2Period ed,
         #CleanPeriod bd
   WHERE bd.Survey_ID = ed.Survey_ID
     AND bd.PeriodDate < ed.PeriodBeginDate
   GROUP BY 
         ed.Survey_ID,
         ed.PeriodBeginDate
       
  IF (@@ERROR <> 0) RETURN 4

  RETURN -1


