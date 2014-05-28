/*******************************************************************************
 *
 * Procedure Name:
 *           PU_PR_Sampling
 *
 * Description:
 *           Pull sample activity result
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
CREATE PROCEDURE dbo.PU_PR_Sampling (
                       @PUReport_ID          int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @MAILSTEP_SCHEDULED          int,
          @MAILSTEP_COMPLETED          int

  SET @MAILSTEP_SCHEDULED = dbo.PU_CM_GetConstant('MAILSTEP_SCHEDULED')
  SET @MAILSTEP_COMPLETED = dbo.PU_CM_GetConstant('MAILSTEP_COMPLETED')


  DECLARE @strPUReport_ID        varchar(12),
          @datActivityBeginDate  datetime,
          @datActivityEndDate    datetime,
          @Study_ID              varchar(10),
          @ReportDateTable       varchar(128),
          @ReportDateColumn      varchar(128),
          @SQL                   varchar(8000),
          @datBegin              datetime,
          @strCR                 char(1)

          
          
  SELECT @datBegin = GETDATE()
          
  ----------------------------------------------------------
  -- Init
  ----------------------------------------------------------
  SET @strCR = char(10)

  SET @strPUReport_ID = CONVERT(varchar, @PUReport_ID)

  SELECT @datActivityBeginDate = ActivityBeginDate,
         @datActivityEndDate = ActivityEndDate
    FROM #PUR_Report

  ----------------------------------------------------------
  -- Pull sample set data
  ----------------------------------------------------------
  CREATE TABLE #SampleSet (
          SampleSet_ID           int NOT NULL PRIMARY KEY,
          Study_ID               int NOT NULL,
          strStudy_Nm            varchar(25) NULL,
          Survey_ID              int NOT NULL,
          strSurvey_Nm           varchar(25) NULL,
          datSampleCreate_Dt	 datetime NULL,
          datDateRange_FromDate  datetime NULL,
          datDateRange_ToDate    datetime NULL,
          SamplePopCount         int NULL
  )
  
  
  INSERT INTO #SampleSet (
          SampleSet_ID,
          Study_ID,
          strStudy_Nm,
          Survey_ID,
          strSurvey_Nm,
          datSampleCreate_Dt,
          datDateRange_FromDate,
          datDateRange_ToDate
         )
  SELECT ss.SampleSet_ID,
         st.Study_ID,
         st.strStudy_Nm,
         sv.Survey_ID,
         sv.strSurvey_Nm,
         ss.datSampleCreate_Dt,
         ssd.MinReportDate,
         ssd.MaxReportDate
    FROM #PUR_Survey psv,
         SampleSet ss
         LEFT JOIN Workflow.dbo.SampleSetDate ssd
           ON ssd.SampleSet_ID = ss.SampleSet_ID,
         Survey_Def sv,
         Study st
   WHERE ss.Survey_ID = psv.Survey_ID
     AND ss.datSampleCreate_Dt BETWEEN DATEADD(week, -6, @datActivityBeginDate)
                                   AND @datActivityEndDate
     AND ss.web_extract_flg IS NOT NULL
     AND sv.Survey_ID = ss.Survey_ID
     AND st.Study_ID = sv.Study_ID

  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 1', @datBegin OUTPUT

  
  ----------------------------------------------------------
  -- Pull sample pop count
  ----------------------------------------------------------
  UPDATE ss
     SET SamplePopCount = sp.SamplePopCount
    FROM #SampleSet ss,
         (
          SELECT sp.SampleSet_ID,
                 COUNT(*) AS SamplePopCount
            FROM #SampleSet ss,
                 SamplePop sp
           WHERE sp.SampleSet_ID = ss.SampleSet_ID
           GROUP BY sp.SampleSet_ID
         ) sp
   WHERE sp.SampleSet_ID = ss.SampleSet_ID

  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 2', @datBegin OUTPUT
   
  ----------------------------------------------------------
  -- Pull completed mailing step
  ----------------------------------------------------------
  CREATE TABLE #MailingStepResult (
           SampleSet_ID          int,
           MailingStep_ID        int,
           MailingStepStatus     tinyint,
           datProcessed          datetime, 
           MailPiece             int
  )

  INSERT INTO #MailingStepResult
  SELECT ss.SampleSet_ID,
         scm.MailingStep_ID,
         @MAILSTEP_COMPLETED,
         MAX(sm.datMailed) AS datMailed,
         COUNT(*) AS MailPiece
    FROM #SampleSet ss,
         SamplePop sp,
         ScheduledMailing scm,
         SentMailing sm
   WHERE sp.SampleSet_ID = ss.SampleSet_ID
     AND scm.SamplePop_ID = sp.SamplePop_ID
     AND scm.OverrideItem_ID IS NULL   -- Pull data for being sampled in the 1st time
     AND sm.SentMail_ID = scm.SentMail_ID
   GROUP BY
         ss.SampleSet_ID,
         scm.MailingStep_ID
  HAVING MAX(sm.datMailed) BETWEEN @datActivityBeginDate
                               AND @datActivityEndDate
      OR MAX(sm.datMailed) IS NULL


  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 3', @datBegin OUTPUT

  ----------------------------------------------------------
  -- Pull scheduled mailing step
  ----------------------------------------------------------
  INSERT INTO #MailingStepResult
  SELECT ss.SampleSet_ID,
         scm.MailingStep_ID,
         @MAILSTEP_SCHEDULED,
         MIN(scm.datGenerate) AS datMailed,
         COUNT(*) AS MailPiece
    FROM #SampleSet ss,
         SamplePop sp,
         ScheduledMailing scm  WITH (INDEX(IDX_SchedMailing_SAMPLEPOP))
   WHERE sp.SampleSet_ID = ss.SampleSet_ID
     AND scm.SamplePop_ID = sp.SamplePop_ID
     AND scm.OverrideItem_ID IS NULL
     AND scm.SentMail_ID IS NULL
   GROUP BY
         ss.SampleSet_ID,
         scm.MailingStep_ID
  UNION
  SELECT ss.SampleSet_ID,
         scm.MailingStep_ID,
         @MAILSTEP_SCHEDULED,
         MAX(sm.datMailed) AS datMailed,
         COUNT(*) AS MailPiece
    FROM #SampleSet ss,
         SamplePop sp,
         ScheduledMailing scm,
         SentMailing sm
   WHERE sp.SampleSet_ID = ss.SampleSet_ID
     AND scm.SamplePop_ID = sp.SamplePop_ID
     AND scm.OverrideItem_ID IS NULL
     AND sm.SentMail_ID = scm.SentMail_ID
   GROUP BY
         ss.SampleSet_ID,
         scm.MailingStep_ID
  HAVING MAX(sm.datMailed) > @datActivityEndDate

  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 4', @datBegin OUTPUT

  ----------------------------------------------------------
  -- Delete old result
  ----------------------------------------------------------
  DELETE FROM Workflow.dbo.PUR_ResultSampling
   WHERE PUReport_ID = @PUReport_ID

  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 5', @datBegin OUTPUT

  ----------------------------------------------------------
  -- Output result
  ----------------------------------------------------------
  INSERT INTO Workflow.dbo.PUR_ResultSampling (
          PUReport_ID,
          SampleSet_ID,
          MailingStep_ID,
          MailingStepStatus,
          strMailingStep_NM,
          Study_ID,
          strStudy_NM,
          Survey_ID,
          strSurvey_NM,
          datSampleCreate_Dt,
          datDateRange_FromDate,
          datDateRange_ToDate,
          SamplePopCount,
          datProcessed,
          MailPiece
         )
  SELECT @PUReport_ID,
         ss.SampleSet_ID,
         msr.MailingStep_ID,
         msr.MailingStepStatus,
         RTRIM(LEFT(ms.strMailingStep_NM,
                    CHARINDEX('(', ms.strMailingStep_NM + '(') - 1
                   )
              ) AS strMailingStep_NM,
         ss.Study_ID,
         ss.strStudy_NM,
         ss.Survey_ID,
         ss.strSurvey_NM,
         ss.datSampleCreate_Dt,
         ss.datDateRange_FromDate,
         ss.datDateRange_ToDate,
         ss.SamplePopCount,
         msr.datProcessed,
         msr.MailPiece
    FROM #SampleSet ss
         LEFT JOIN #MailingStepResult msr
           ON ss.SampleSet_ID = msr.SampleSet_ID
         LEFT JOIN MailingStep ms
           ON ms.MailingStep_ID = msr.MailingStep_ID
   WHERE ss.datSampleCreate_Dt >= @datActivityEndDate
      OR msr.datProcessed >= @datActivityBeginDate

  EXEC dbo.PU_CM_TimeUsed 'Sampling -- Step 6', @datBegin OUTPUT

  RETURN -1


