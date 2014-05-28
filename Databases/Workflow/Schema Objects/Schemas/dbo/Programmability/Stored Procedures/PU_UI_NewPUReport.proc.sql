/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_NewPUReport
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
CREATE PROCEDURE dbo.PU_UI_NewPUReport (
                       @PU_ID                int,
                       @Employee_ID          int
) AS

  -- Constants
  DECLARE @RPT_STATUS_SETUP            int,
          @RPT_STATUS_POSTED           int,
          @SECTION_HEADING_INFO        int,
          @SECTION_COMMENT             int,
          @SECTION_DATA_LOADING        int,
          @SECTION_SAMPLE_ACTIVITY     int,
          @SECTION_RESPONSE_RATE       int,
          @PERIOD_1                    int,
          @PERIOD_CURRENT              int

  SET @RPT_STATUS_SETUP = dbo.PU_CM_GetConstant('RPT_STATUS_SETUP')
  SET @RPT_STATUS_POSTED = dbo.PU_CM_GetConstant('RPT_STATUS_POSTED')
  SET @SECTION_HEADING_INFO = dbo.PU_CM_GetConstant('SECTION_HEADING_INFO')
  SET @SECTION_COMMENT = dbo.PU_CM_GetConstant('SECTION_COMMENT')
  SET @SECTION_DATA_LOADING = dbo.PU_CM_GetConstant('SECTION_DATA_LOADING')
  SET @SECTION_SAMPLE_ACTIVITY = dbo.PU_CM_GetConstant('SECTION_SAMPLE_ACTIVITY')
  SET @SECTION_RESPONSE_RATE = dbo.PU_CM_GetConstant('SECTION_RESPONSE_RATE')
  SET @PERIOD_1 = dbo.PU_CM_GetConstant('PERIOD_1')
  SET @PERIOD_CURRENT = dbo.PU_CM_GetConstant('PERIOD_CURRENT')
  
  DECLARE @PUReport_ID          int
  

  BEGIN TRAN
  
  --
  -- PUR_Report
  --
  INSERT INTO PUR_Report (
          PU_ID,
          DueDate,
          Status,
          ActivityBeginDate,
          UiActivityEndDate,
          ActivityEndDate,
          News_ID,
          CreatedBy
         )
  SELECT @PU_ID,
         NextDueDate,
         @RPT_STATUS_SETUP AS Status,
         CONVERT(varchar, DATEADD(day, -7, NextDueDate), 111) AS ActivityBeginDate,
         dbo.YesterdayMidnight(NextDueDate) AS UiActivityEndDate,
         dbo.YesterdayMidnight(NextDueDate) AS ActivityEndDate,
         0 AS News_ID,
         @Employee_ID AS CreatedBy
    FROM PU_Plan
   WHERE PU_ID = @PU_ID
  
  SET @PUReport_ID = @@IDENTITY


  --
  -- PU_Plan
  --
  UPDATE PU_Plan
     SET NextPUReport_ID = @PUReport_ID
   WHERE PU_ID = @PU_ID
  
  
  --
  -- PUR_Section
  --
  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title
         )
  VALUES (
          @PUReport_ID,
          1,
          @SECTION_HEADING_INFO,
          'Heading Information'
         )

  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title
         )
  VALUES (
          @PUReport_ID,
          2,
          @SECTION_COMMENT,
          'Greeting'
         )

  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title
         )
  SELECT @PUReport_ID,
         3 AS Section_ID,
         Type,
         Title
    FROM PU_StandardSection
   WHERE Type = @SECTION_DATA_LOADING

  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title
         )
  SELECT @PUReport_ID,
         4 AS Section_ID,
         Type,
         Title
    FROM PU_StandardSection
   WHERE Type = @SECTION_SAMPLE_ACTIVITY

  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Title
         )
  SELECT @PUReport_ID,
         5 AS Section_ID,
         Type,
         Title
    FROM PU_StandardSection
   WHERE Type = @SECTION_RESPONSE_RATE

  -- PUR_Period
  -- Set the default of period 1 to current period
  INSERT INTO PUR_Period (
          PUReport_ID,
          Survey_ID,
          Period_ID,
          PeriodType
         )
  SELECT pr.PUReport_ID,
         css.Survey_ID,
         @PERIOD_1 AS Period_ID,
         @PERIOD_CURRENT AS Period_Type
    FROM PUR_Report pr,
         PU_Plan pl,
         ClientStudySurvey_View css
   WHERE pr.PUReport_ID = @PUReport_ID
     AND pl.PU_ID = pr.PU_ID
     AND css.Client_ID = pl.Client_ID
  
  COMMIT TRAN 
  
  RETURN -1


