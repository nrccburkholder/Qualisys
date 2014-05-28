/*********************************************************************************************************
QSL_SelectVendorFileData
Created by: ?
Purpose:    ?

History Log:
Created on: ?
Modified: 8/9/2012 DBG -- added MailingStepMethod #9 to "IF @MailingStepMethod_ID IN (2,4,9)" to accomodate Letter-Web Mailing Step Method
*********************************************************************************************************/
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileData] (
      @VendorFile_ID INT
      )
AS
--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @MailingStepMethodID INT

--Get the Mailing Step Method
SELECT @MailingStepMethodID = ms.MailingStepMethod_ID
FROM VendorFileCreationQueue vq
      ,MailingStep ms
WHERE vq.MailingStep_Id = ms.MailingStep_ID
      AND vq.VendorFile_Id = @VendorFile_ID

--Determine which table has the data
IF @MailingStepMethodID IN (1,3)
BEGIN
      --This is phone data
      SELECT HCAHPSSamp, Litho, Survey_ID, SampleSet_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, 
                  PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
      FROM VendorPhoneFile_Data
      WHERE VendorFile_ID = @VendorFile_ID
END
ELSE IF @MailingStepMethodID IN (2,4,9)
BEGIN
      --This is web data
      SELECT Survey_ID, SampleSet_ID, Litho, WAC, FName, LName, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, 
                  wbServInd6, ExternalRespondentID, bitSentToVendor
      FROM [dbo].VendorWebFile_Data
      WHERE VendorFile_ID = @VendorFile_ID
END
ELSE
BEGIN
      --The MailingStepMethod is not for phone or web so throw an error
      RAISERROR ('Invalid Mailing Step Method.  Please Contact the System Aministrator.', -- Message Text
                     16, -- Severity
                     1)  -- State
      RETURN
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


