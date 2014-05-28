/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_CopyPUReport
 *
 * Description:
 *           Copy previous update to a new one
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
CREATE PROCEDURE dbo.PU_UI_CopyPUReport (
                       @PU_ID                int,
                       @LastPUReport_ID      int,
                       @Employee_ID          int
) AS

  -- Constants
  DECLARE @YES                         int,
          @RPT_STATUS_SETUP            int,
          @SECTION_COMMENT             int

  SET @YES = dbo.PU_CM_GetConstant('YES')
  SET @RPT_STATUS_SETUP = dbo.PU_CM_GetConstant('RPT_STATUS_SETUP')
  SET @SECTION_COMMENT = dbo.PU_CM_GetConstant('SECTION_COMMENT')

  -- Variables
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
          RRDetail,
          UseWebAccount,
          CreatedBy
         )
  SELECT @PU_ID,
         pl.NextDueDate,
         @RPT_STATUS_SETUP AS Status,
         CONVERT(varchar, DATEADD(day, 1, rp.ActivityEndDate), 111) AS ActivityBeginDate,
         dbo.YesterdayMidnight(pl.NextDueDate) AS UiActivityEndDate,
         dbo.YesterdayMidnight(pl.NextDueDate) AS ActivityEndDate,
         rp.RRDetail,
         UseWebAccount,
         @Employee_ID AS CreatedBy
    FROM PUR_Report rp,
         PU_Plan pl
   WHERE rp.PUReport_ID = @LastPUReport_ID
     AND pl.PU_ID = @PU_ID
  
  SET @PUReport_ID = @@IDENTITY


  --
  -- PU_Plan
  --
  UPDATE PU_Plan
     SET NextPUReport_ID = @PUReport_ID
   WHERE PU_ID = @PU_ID
  
  
  --
  -- PUR_Addressee
  --
  INSERT INTO PUR_Addressee (
          PUReport_ID,
          AddrType,
          SeqNum,
          Name,
          Email,
          Employee_ID
         )
  SELECT @PUReport_ID,
         AddrType,
         SeqNum,
         Name,
         Email,
         Employee_ID
    FROM PUR_Addressee
   WHERE PUReport_ID = @LastPUReport_ID


  --
  -- PUR_Period
  --
  INSERT INTO PUR_Period (
          PUReport_ID,
          Survey_ID,
          Period_ID,
          PeriodType
         )
  SELECT @PUReport_ID,
         Survey_ID,
         Period_ID,
         PeriodType
    FROM PUR_Period
   WHERE PUReport_ID = @LastPUReport_ID
  

  --
  -- PUR_PeriodCustom
  --
  INSERT INTO PUR_PeriodCustom (
          PUReport_ID,
          Survey_ID,
          Period_ID,
          SampleSet_ID
         )
  SELECT @PUReport_ID,
         Survey_ID,
         Period_ID,
         SampleSet_ID
    FROM PUR_PeriodCustom
   WHERE PUReport_ID = @LastPUReport_ID

  --
  -- PUR_Section
  --
  INSERT INTO PUR_Section (
          PUReport_ID,
          Section_ID,
          Type,
          Skip,
          Title,
          Format,
          Copy,
          PrevRptSection_ID
         )
  SELECT @PUReport_ID,
         Section_ID,
         Type,
         Skip,
         Title,
         Format,
         Copy,
         Section_ID
    FROM PUR_Section
   WHERE PUReport_ID = @LastPUReport_ID

  UPDATE n
     SET Content = p.Content
    FROM PUR_Section n,
         PUR_Section p
   WHERE n.PUReport_ID = @PUReport_ID
     AND n.Type = @SECTION_COMMENT
     AND n.Copy = @YES
     AND p.PUReport_ID = @LastPUReport_ID
     AND p.Section_ID = n.Section_ID


  --
  -- PUR_Survey
  --
  INSERT INTO PUR_Survey (
          PUReport_ID,
          Study_ID,
          Survey_ID
         )
  SELECT @PUReport_ID,        
         Study_ID,
         Survey_ID
    FROM PUR_Survey
   WHERE PUReport_ID = @LastPUReport_ID
    
    
  COMMIT TRAN 
  
  RETURN -1


