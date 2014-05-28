/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_GeneralSetting
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
CREATE PROCEDURE dbo.PU_UI_GeneralSetting (
                       @PU_ID           int,
                       @PuName          varchar(128),
                       @PuDescription   varchar (256),
                       @ReportDay       tinyint,
                       @NRCContact      int,
                       @MailFrom        int,
                       @Logo            tinyint,
                       @ShowNewsBrief   bit,
                       @TitleType       tinyint,
                       @NextDueDate     datetime,
                       @ModifiedBy      int
) AS

  SET NOCOUNT ON
  
  DECLARE @intReturn              int,
          @PUReport_ID            int,
          @OrgNextDueDate         datetime
          


  -- Check if PU_ID exists and get original "NextDueDate"
  SELECT @OrgNextDueDate = NextDueDate,
         @PUReport_ID = NextPUReport_ID
    FROM PU_Plan
   WHERE PU_ID = @PU_ID

  IF @@ROWCOUNT = 0 RETURN 1
  
  BEGIN TRAN
  
  -- Update PU_Plan
  UPDATE PU_Plan
     SET PuName = @PuName,
         PuDescription = @PuDescription,
         ReportDay = @ReportDay,
         NRCContact = @NRCContact,
         Logo = @Logo,
         ShowNewsBrief = @ShowNewsBrief,
         TitleType = @TitleType,
         MailFrom = @MailFrom,
         NextDueDate = @NextDueDate,
         ModifiedBy = @ModifiedBy,
         DateModified = GETDATE()
   WHERE PU_ID = @PU_ID
  
  -- Update PUR_Report
  IF (@NextDueDate <> @OrgNextDueDate AND
      @PUReport_ID IS NOT NULL) BEGIN
      
      UPDATE PUR_Report
         SET DueDate = @NextDueDate,
             ModifiedBy = @ModifiedBy,
             DateModified = GETDATE()
       WHERE PUReport_ID = @PUReport_ID
  END
  
  COMMIT TRAN
  
  RETURN -1


