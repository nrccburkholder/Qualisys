CREATE PROCEDURE [dbo].[QSL_SelectVendorPhoneFile_DatasByVendorFileId]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

/*
	Modified:  03/13/2014 TSB -- Made country-aware for CA Qualisys Upgrade, Phone Vendor File data, requirement #13
	Modified:  5/30/2014 TSB -- ALLCAHPS sprint 1, task 7.3 - add AgeRange
*/

DECLARE @Country as varchar(2)

SELECT @Country = strParam_Value
FROM QualPro_Params 
WHERE strParam_nm='Country'


IF @Country = 'CA'
BEGIN
	SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, Province, PostalCode, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12, AgeRange
	FROM VendorPhoneFile_Data
	WHERE VendorFile_ID = @VendorFile_ID
END
ELSE
BEGIN
	SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12, AgeRange
	FROM VendorPhoneFile_Data
	WHERE VendorFile_ID = @VendorFile_ID
END

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


