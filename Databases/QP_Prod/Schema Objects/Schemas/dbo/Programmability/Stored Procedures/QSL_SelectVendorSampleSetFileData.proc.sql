/*********************************************************************************************************
QSL_SelectVendorSampleSetFileData
Created by: Michael Beltz 
Purpose:    This proc is a shell SP that calls QSL_SelectPhoneVendorSampleSetFileData or
                  QSL_SelectwebVendorSampleSetFileData based on the type of the mailing step.
                  it is only called when you want to save data (insert or update) and is called from
                  formgen.  
                  You need to call QSL_SelectPhoneVendorSampleSetFileData or
                  QSL_SelectwebVendorSampleSetFileData directly if there is no VendorFile_ID as it is
                  impossible to tell which MailingStepmethod type the SampleSet belongs too.

History Log:
Created on: 7/15/09
Modified: 8/9/2012 DBG -- added MailingStepMethod #9 to "IF @MailingStepMethod_ID IN (2,4,9)" to accomodate Letter-Web Mailing Step Method
*********************************************************************************************************/
CREATE PROCEDURE [dbo].[QSL_SelectVendorSampleSetFileData] (
      @SampleSet_ID INT
      ,@SaveData BIT = 0
      ,@bitUpdate INT = 0
      ,@VendorFileID INT = 0
      ,@UseWorkTable BIT = 0
      ,@inDebug INT = 0
      )
AS
BEGIN
      IF @indebug = 1
            PRINT 'Start QSL_SelectVendorSampleSetFileData'

      IF @VendorFileID = 0
      BEGIN
            RAISERROR ('VendorFile_ID cannot be 0.  Please contact system Administrator.', -- Message text.
                           16, -- Severity.
                              1 -- State.
                              )           
            RETURN
      END

      DECLARE @MailingStepMethod_ID INT

      SELECT @MailingStepMethod_ID = ms.MailingStepMethod_ID
      FROM VendorFileCreationQueue VFC, MailingStep ms
      WHERE VFC.MailingStep_Id = ms.MailingStep_ID
            AND VFC.vendorFile_Id = @VendorFileID

      IF @MailingStepMethod_ID IN (1,3)
      BEGIN
            EXEC QSL_SelectPhoneVendorSampleSetFileData @SampleSet_ID
                  ,@SaveData
                  ,@bitUpdate
                  ,@VendorFileID
                  ,@UseWorkTable
                  ,@inDebug
      END
      ELSE IF @MailingStepMethod_ID IN (2,4,9)
      BEGIN
            EXEC QSL_SelectWebVendorSampleSetFileData @SampleSet_ID
                  ,@SaveData
                  ,@bitUpdate
                  ,@VendorFileID
                  ,@UseWorkTable
                  ,@inDebug
      END
      ELSE
      BEGIN
            RAISERROR ('Invalid Mailing Step Method.  Please contact system Administrator.', -- Message text.
                           16, -- Severity.
                              1 -- State.
                              )
            RETURN
      END
END


