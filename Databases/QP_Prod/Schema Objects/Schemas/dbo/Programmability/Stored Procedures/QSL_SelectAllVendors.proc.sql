CREATE PROCEDURE [dbo].[QSL_SelectAllVendors]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Vendor_ID, VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, Province, 
       Zip5, Zip4, DateCreated, DateModified, bitAcceptFilesFromVendor, NoResponseChar, 
       SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName, VendorFileOutgoType_ID,
	   DontKnowResponseChar,RefusedResponseChar
FROM [dbo].Vendors

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


