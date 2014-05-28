/*******************************************************************************
 *
 * Procedure Name:
 *           PU_MN_ExtractSampleSetDate
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
CREATE PROCEDURE [dbo].[PU_MN_ExtractSampleSetDate]
AS
  SET ANSI_NULLS ON
  SET ANSI_WARNINGS ON
  SET NOCOUNT ON

  BEGIN TRAN
     
  -- DELETE FROM SampleSetDate
  
  INSERT INTO SampleSetDate (
          SampleSet_ID,
          MinReportDate,
          MaxReportDate
         )
  SELECT SampleSet_ID,
         MinReportDate,
         MaxReportDate
    FROM DATAMART.QP_Comments.dbo.SampleSetDateWork

  COMMIT TRAN

  RETURN -1


