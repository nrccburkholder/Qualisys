/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_StartOver
 *
 * Description:
 *           Create a new PU Report
 *
 * Parameters:
 *           @PU_ID          int
 *             Project Update ID
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_UI_StartOver (
                       @PU_ID         int,
                       @PUReport_ID   int,
                       @Employee_ID   int
) AS

  SET NOCOUNT ON

  BEGIN TRAN
  
  UPDATE PU_Plan
     SET NextPUReport_ID = NULL,
         StartOverBy = @Employee_ID,
         DateStartOver = GETDATE()
   WHERE PU_ID = @PU_ID
   
  DELETE PUR_Addressee
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_Period
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_PeriodCustom
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_Report
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_ResultLoading
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_ResultResponseRate
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_ResultSampling
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_Section
   WHERE PUReport_ID = @PUReport_ID

  DELETE PUR_Survey
   WHERE PUReport_ID = @PUReport_ID
     
  COMMIT TRAN
  
  RETURN -1


