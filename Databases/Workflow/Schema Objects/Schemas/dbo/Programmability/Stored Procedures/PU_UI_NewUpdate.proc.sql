/*******************************************************************************
 *
 * Procedure Name:
 *           PU_UI_NewUpdate
 *
 * Description:
 *           Create a new PU Report
 *
 * Parameters:
 *           @PU_ID          int
 *             Project Update ID
 *
 * Return:
 *           >0:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_UI_NewUpdate (
                       @Team_ID         int,
                       @PuName          varchar(128),
                       @PuDescription   varchar (256),
                       @Client_ID       int,
                       @ReportDay       tinyint,
                       @NRCContact      int,
                       @MailFrom        int,
                       @Logo            tinyint,
                       @ShowNewsBrief   bit,
                       @TitleType       tinyint,
                       @NextDueDate     datetime,
                       @CreatedBy       int
) AS

  -- Constants
  DECLARE @FORMAT_TEXT                 int,
          @FORMAT_HTML                 int

  SET @FORMAT_TEXT = dbo.PU_CM_GetConstant('FORMAT_TEXT')
  SET @FORMAT_HTML = dbo.PU_CM_GetConstant('FORMAT_HTML')

  DECLARE @PU_ID                       int

  BEGIN TRAN
  
  -- Insert PU_Plan
  INSERT INTO PU_Plan (
          Team_ID,
          PuName,
          PuDescription,
          Client_ID,
          ReportDay,
          NRCContact,
          MailFrom,
          Logo,
          ShowNewsBrief,
          TitleType,
          NextDueDate,
          CreatedBy
         )
  VALUES (
          @Team_ID,
          @PuName,
          @PuDescription,
          @Client_ID,
          @ReportDay,
          @NRCContact,
          @MailFrom,
          @Logo,
          @ShowNewsBrief,
          @TitleType,
          @NextDueDate,
          @CreatedBy
         )

  SET @PU_ID = @@IDENTITY

  -- Insert default mail
  INSERT INTO PU_Mail (
          PU_ID,
          Format
         )
  SELECT @PU_ID,
         Format
    FROM PU_DefaultMail
   WHERE Format = @FORMAT_HTML
          
  COMMIT TRAN
  
  RETURN @PU_ID


