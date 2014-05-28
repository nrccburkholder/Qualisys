/*******************************************************************************
 *
 * Procedure Name:
 *           PU_PR_Qualisys
 *
 * Description:
 *           (1) Copy Project Update definition tables to Qualisys
 *           (2) Trigger Project Update SPs on Qualisys
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
CREATE PROCEDURE dbo.PU_PR_Qualisys (
                       @PUReport_ID         int,
                       @Employee_ID         int
) AS
  -- Constants
  DECLARE @SECTION_DATA_LOADING        int,
          @SECTION_SAMPLE_ACTIVITY     int,
          @SECTION_RESPONSE_RATE       int

  SET @SECTION_DATA_LOADING = dbo.PU_CM_GetConstant('SECTION_DATA_LOADING')
  SET @SECTION_SAMPLE_ACTIVITY = dbo.PU_CM_GetConstant('SECTION_SAMPLE_ACTIVITY')
  SET @SECTION_RESPONSE_RATE = dbo.PU_CM_GetConstant('SECTION_RESPONSE_RATE')

  -- Variables
  DECLARE @intSqlError            int,
          @intRowCnt              int,
          @intReturn              int,
          @datBegin               datetime

  DECLARE @HaveDataLoad           int,
          @HaveSampleActivity     int,
          @HaveResponseRate       int
          
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON


  SELECT @datBegin = GETDATE()

  -- Set activity end date to yesterday midnight if it is
  -- equal or later than today
  UPDATE Workflow.dbo.PUR_Report
     SET ActivityEndDate = CASE
                             WHEN UiActivityEndDate >= CONVERT(varchar, GETDATE(), 101)
                               THEN dbo.YesterdayMidnight(GETDATE())
                             ELSE UiActivityEndDate
                           END
   WHERE PUReport_ID = @PUReport_ID
      
  -----------------------------------------------------
  -- Make a copy of current project update 
  -----------------------------------------------------
  SELECT *
    INTO #PUR_Report
    FROM Workflow.dbo.PUR_Report
   WHERE PUReport_ID = @PUReport_ID
  
  SELECT DISTINCT
         PUReport_ID,
         Study_ID
    INTO #PUR_Study
    FROM Workflow.dbo.PUR_Survey
   WHERE PUReport_ID = @PUReport_ID

  SELECT *
    INTO #PUR_Survey
    FROM Workflow.dbo.PUR_Survey
   WHERE PUReport_ID = @PUReport_ID


  SELECT *
    INTO #PUR_Period
    FROM Workflow.dbo.PUR_Period
   WHERE PUReport_ID = @PUReport_ID

  SELECT *
    INTO #PUR_PeriodCustom
    FROM Workflow.dbo.PUR_PeriodCustom
   WHERE PUReport_ID = @PUReport_ID

  SELECT *
    INTO #PUR_Section
    FROM Workflow.dbo.PUR_Section
   WHERE PUReport_ID = @PUReport_ID

  EXEC dbo.PU_CM_TimeUsed 'Create temp table', @datBegin OUTPUT
  

  -----------------------------------------------------
  -- Check if have 3 data sections
  -----------------------------------------------------
  SELECT @HaveDataLoad = COUNT(*)
    FROM #PUR_Section
   WHERE Type = @SECTION_DATA_LOADING
     AND Skip = 0

  SELECT @HaveSampleActivity = COUNT(*)
    FROM #PUR_Section
   WHERE Type = @SECTION_SAMPLE_ACTIVITY
     AND Skip = 0

  SELECT @HaveResponseRate = COUNT(*)
    FROM #PUR_Section
   WHERE Type = @SECTION_RESPONSE_RATE
     AND Skip = 0
  
  BEGIN DISTRIBUTED TRAN

  -----------------------------------------------------
  -- Loading
  -----------------------------------------------------
  IF @HaveDataLoad > 0 BEGIN

      EXEC @intReturn = dbo.PU_PR_Loaded @PUReport_ID
      IF @intReturn <> -1 BEGIN
          PRINT 'Error: failed to pull loading result. (PU_PR_Loaded)'
          ROLLBACK TRAN
          RETURN 2
      END

      EXEC dbo.PU_CM_TimeUsed 'PU_PR_Loaded', @datBegin OUTPUT

  END

  -----------------------------------------------------
  -- Sampling
  -----------------------------------------------------
  IF @HaveSampleActivity > 0 BEGIN

      EXEC @intReturn = dbo.PU_PR_Sampling @PUReport_ID
      IF @intReturn <> -1 BEGIN
          PRINT 'Error: failed to pull sampling result. (PU_PR_Sampling)'
          ROLLBACK TRAN
          RETURN 3
      END

      EXEC dbo.PU_CM_TimeUsed 'PU_PR_Sampling', @datBegin OUTPUT

  END

  -----------------------------------------------------
  -- Response Rate
  -----------------------------------------------------
  IF @SECTION_RESPONSE_RATE > 0 BEGIN

      EXEC @intReturn = dbo.PU_PR_ResponseRate @PUReport_ID
      IF @intReturn <> -1 BEGIN
          PRINT 'Error: failed to get response rate result. (PU_PR_ResponseRate)'
          ROLLBACK TRAN
          RETURN 4
      END

      EXEC dbo.PU_CM_TimeUsed 'PU_PR_ResponseRate', @datBegin OUTPUT

  END

  -----------------------------------------------------
  -- Data on Workflow
  -----------------------------------------------------
  EXEC @intReturn = Workflow.dbo.PU_PR_Workflow @PUReport_ID, @Employee_ID
  IF @intReturn <> -1 BEGIN
      PRINT 'Error: SP failed. (PU_PR_Workflow)'
      ROLLBACK TRAN
      RETURN 5
  END

  EXEC dbo.PU_CM_TimeUsed 'PU_PR_Workflow', @datBegin OUTPUT


  COMMIT TRAN
  
  RETURN -1


