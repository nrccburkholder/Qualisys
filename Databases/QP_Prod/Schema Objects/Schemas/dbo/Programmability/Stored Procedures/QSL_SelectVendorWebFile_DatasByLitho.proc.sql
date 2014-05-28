CREATE PROCEDURE [dbo].[QSL_SelectVendorWebFile_DatasByLitho]
@Litho VARCHAR(50)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LangID, LName, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
FROM VendorWebFile_Data
WHERE Litho = @Litho

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


