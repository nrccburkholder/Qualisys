CREATE PROCEDURE [dbo].[QSL_SelectVendorWebFile_DatasByVendorFileId]
@VendorFile_ID INT,
@HidePII bit = 0
AS

--2013-1104 Fixing Email should be hidden when HidePII is 1

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
if @HidePII = 0
	SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LangID, LName, 
	ISNULL(NULLIF(RTRIM(LTRIM(Email_Address)),''), 'noreply@nationalresearch.com') AS Email_Address, 
	WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
	FROM VendorWebFile_Data
	WHERE VendorFile_ID = @VendorFile_ID
Else
    	SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, '' AS FName, LangID, '' AS LName, 
	'noreply@nationalresearch.com' AS Email_Address, 
	WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
	FROM VendorWebFile_Data
	WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


