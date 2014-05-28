/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_PullHeadInfo
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
CREATE PROCEDURE dbo.PU_UI_PullHeadInfo (
                       @PUReport_ID   int
) AS

  SET NOCOUNT ON

  -- Constants
  DECLARE @ADDR_TO            int,
          @ADDR_FROM          int,
          @ADDR_CC            int,
          @ADDR_WEBACCOUNT    int

  SET @ADDR_TO = dbo.PU_CM_GetConstant('ADDR_TO')
  SET @ADDR_FROM = dbo.PU_CM_GetConstant('ADDR_FROM')
  SET @ADDR_CC = dbo.PU_CM_GetConstant('ADDR_CC')
  SET @ADDR_WEBACCOUNT = dbo.PU_CM_GetConstant('ADDR_WEBACCOUNT')

  -- "To" fields
  SELECT Name,
         Email
    FROM PUR_Addressee
   WHERE PUReport_ID = @PUReport_ID
     AND AddrType = @ADDR_TO
   ORDER BY SeqNum
  
  -- "From" fields
  SELECT Employee_ID
    FROM PUR_Addressee
   WHERE PUReport_ID = @PUReport_ID
     AND AddrType = @ADDR_FROM
   ORDER BY SeqNum

  -- "Cc" fields
  SELECT Name,
         Email
    FROM PUR_Addressee
   WHERE PUReport_ID = @PUReport_ID
     AND AddrType = @ADDR_CC
   ORDER BY SeqNum
  
  -- "WebAccount" fields
  SELECT Employee_ID AS Group_ID
    FROM PUR_Addressee
   WHERE PUReport_ID = @PUReport_ID
     AND AddrType = @ADDR_WEBACCOUNT
   ORDER BY SeqNum
  
  -- "Attachment" fields
  SELECT Label,
         FileName
    FROM PUR_Attachment
   WHERE PUReport_ID = @PUReport_ID
   ORDER BY SeqNum
  
  RETURN -1


