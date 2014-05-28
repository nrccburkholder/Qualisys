CREATE PROCEDURE [dbo].[QSL_SelectVendorPhoneFile_DatasByVendorFileId]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
FROM VendorPhoneFile_Data
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


