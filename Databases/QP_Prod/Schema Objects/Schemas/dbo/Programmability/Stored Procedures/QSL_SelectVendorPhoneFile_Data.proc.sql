CREATE PROCEDURE [dbo].[QSL_SelectVendorPhoneFile_Data]
@VendorFile_Data_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
FROM [dbo].VendorPhoneFile_Data
WHERE VendorFile_Data_ID = @VendorFile_Data_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


