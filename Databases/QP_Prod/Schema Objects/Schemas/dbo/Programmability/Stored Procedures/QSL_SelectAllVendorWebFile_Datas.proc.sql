CREATE PROCEDURE [dbo].[QSL_SelectAllVendorWebFile_Datas]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, LangID, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
FROM [dbo].VendorWebFile_Data

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


