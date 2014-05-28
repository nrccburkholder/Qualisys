CREATE PROCEDURE [dbo].[QSL_InsertVendor]
@VendorCode VARCHAR(25),
@Vendor_nm VARCHAR(100),
@Phone VARCHAR(10),
@Addr1 VARCHAR(100),
@Addr2 VARCHAR(100),
@City VARCHAR(42),
@StateCode VARCHAR(2),
@Province VARCHAR(25),
@Zip5 VARCHAR(5),
@Zip4 VARCHAR(4),
@DateCreated DATETIME,
@DateModified DATETIME,
@bitAcceptFilesFromVendor BIT,
@NoResponseChar VARCHAR(1),
@SkipResponseChar VARCHAR(1),
@MultiRespItemNotPickedChar VARCHAR(1),
@LocalFTPLoginName VARCHAR(20), 
@VendorFileOutgoType_ID INT,
@DontKnowResponseChar VARCHAR(1),
@RefusedResponseChar VARCHAR(1)
AS

SET NOCOUNT ON

INSERT INTO [dbo].Vendors (VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, 
                           Province, Zip5, Zip4, DateCreated, DateModified, 
                           bitAcceptFilesFromVendor, NoResponseChar, SkipResponseChar, 
                           MultiRespItemNotPickedChar, LocalFTPLoginName, VendorFileOutgoType_ID,
						   DontKnowResponseChar,RefusedResponseChar)
VALUES (@VendorCode, @Vendor_nm, @Phone, @Addr1, @Addr2, @City, @StateCode, @Province, 
        @Zip5, @Zip4, @DateCreated, @DateModified, @bitAcceptFilesFromVendor, @NoResponseChar, 
        @SkipResponseChar, @MultiRespItemNotPickedChar, @LocalFTPLoginName, @VendorFileOutgoType_ID,
		@DontKnowResponseChar,@RefusedResponseChar)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


