/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_UpdateTemplate
 *
 * Description:
 *           Update/insert template info
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_UpdateTemplate (
        @Template_ID     int,
        @TemplateName    varchar(128),
        @strClient_NM    varchar(128),
        @Description     varchar(7500)
       )
AS
  DECLARE @Count   int,
          @Error   int
  
  BEGIN TRAN
  
  UPDATE GHS_MailMergeTemplate
     SET TemplateName = @TemplateName,
         strClient_NM = @strClient_NM,
         Description = @Description
   WHERE Template_ID = @Template_ID
  
  SELECT @Count = @@ROWCOUNT,
         @Error = @@Error
         
  IF @ERROR <> 0 BEGIN
      ROLLBACK TRAN
      RAISERROR('Failed to update GHS_MailMergeTemplate!',16, 1)
  END
  
  IF (@Count = 0) BEGIN
      INSERT INTO GHS_MailMergeTemplate (
              Template_ID,
              TemplateName,
              strClient_NM,
              Description
             )
      VALUES (
              @Template_ID,
              @TemplateName,
              @strClient_NM,
              @Description
             )

      IF @@ERROR <> 0 BEGIN
          ROLLBACK TRAN
          RAISERROR('Failed to insert GHS_MailMergeTemplate!',16, 1)
      END
  END
  
  COMMIT TRAN
  
  RETURN -1


