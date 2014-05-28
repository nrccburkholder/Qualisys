/*******************************************************************************
 *
 * Procedure Name:
 *           PU_PR_Workflow
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
CREATE PROCEDURE dbo.PU_PR_Workflow (
                       @PUReport_ID         int,
                       @Employee_ID         int
) AS

  -- Constants
  DECLARE @YES                   int,
          @TITLE_CLIENT_NAME     int,
          @TITLE_PU_NAME         int

  SET @YES = dbo.PU_CM_GetConstant('YES')
  SET @TITLE_CLIENT_NAME = dbo.PU_CM_GetConstant('TITLE_CLIENT_NAME')
  SET @TITLE_PU_NAME = dbo.PU_CM_GetConstant('TITLE_PU_NAME')

  -- Variables
  DECLARE @datBegin               datetime

  SET NOCOUNT ON

  SELECT @datBegin = GETDATE()

  BEGIN TRAN

  -----------------------------------------------------
  -- Heading Info
  -----------------------------------------------------
  DELETE FROM PUR_ResultHeadInfo
   WHERE PUReport_ID = @PUReport_ID
  
  INSERT INTO PUR_ResultHeadInfo (
          PUReport_ID,
          GenerateDate,
          Title
         )
  SELECT rp.PUReport_ID,
         GETDATE(),
         CASE pl.TitleType
           WHEN @TITLE_PU_NAME THEN pl.PuName
           ELSE cl.strClient_Nm
           END AS Title
    FROM PUR_Report rp,
         PU_Plan pl,
         Client_View cl
   WHERE rp.PUReport_ID = @PUReport_ID
     AND pl.PU_ID = rp.PU_ID
     AND cl.Client_ID = pl.Client_ID
  
  --Delete PUR_ResultHeadInfoAddressee
  DELETE FROM PUR_ResultHeadInfoAddressee  
   WHERE PUReport_ID = @PUReport_ID

  --Insert PUR_ResultHeadInfoAddressee
  INSERT INTO PUR_ResultHeadInfoAddressee (  
          PUReport_ID,  
          AddrType,  
          SeqNum,  
          Name,  
          Email  
         )  
  SELECT PUReport_ID,  
         AddrType,  
         SeqNum,  
         Name,  
         Email  
    FROM PUR_Addressee  
   WHERE PUReport_ID = @PUReport_ID
     AND AddrType IN (1, 3)
  UNION  
  SELECT PUReport_ID,  
         AddrType,  
         SeqNum,  
         em.strEmployee_First_NM + ' ' + em.strEmployee_Last_NM AS Name,  
         em.strEmail AS Email  
    FROM PUR_Addressee ad,  
         Employee em  
   WHERE ad.PUReport_ID = @PUReport_ID
     AND ad.AddrType = 2
     AND em.Employee_ID = ad.Employee_ID  
  UNION
  SELECT PUReport_ID,
         4 AS AddrType,  
         SeqNum,
         Label,
         URL
    FROM PUR_Attachment
   WHERE PUReport_ID = @PUReport_ID


  EXEC dbo.PU_CM_TimeUsed 'Heading Info', @datBegin OUTPUT

  -----------------------------------------------------
  -- News Brief
  -----------------------------------------------------
  UPDATE PUR_Report
     SET News_ID = (
                    SELECT MAX(News_ID)
                      FROM NewsBrief
                     WHERE Published = @YES
                   )
   WHERE PUReport_ID = @PUReport_ID
 
  -----------------------------------------------------
  -- Save the generate person and time
  -----------------------------------------------------
  UPDATE PUR_Report
     SET GeneratedBy = @Employee_ID,
         DateGenerated = GETDATE()
   WHERE PUReport_ID = @PUReport_ID

  EXEC dbo.PU_CM_TimeUsed 'Generate by', @datBegin OUTPUT

  COMMIT TRAN
  
  RETURN -1


