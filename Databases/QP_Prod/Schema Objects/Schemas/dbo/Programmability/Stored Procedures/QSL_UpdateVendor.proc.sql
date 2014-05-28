CREATE PROCEDURE [dbo].[QSL_UpdateVendor]
@Vendor_ID INT,
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

UPDATE [dbo].Vendors SET
	VendorCode = @VendorCode,
	Vendor_nm = @Vendor_nm,
	Phone = @Phone,
	Addr1 = @Addr1,
	Addr2 = @Addr2,
	City = @City,
	StateCode = @StateCode,
	Province = @Province,
	Zip5 = @Zip5,
	Zip4 = @Zip4,
	DateCreated = @DateCreated,
	DateModified = @DateModified,
	bitAcceptFilesFromVendor = @bitAcceptFilesFromVendor,
	NoResponseChar = @NoResponseChar,
	SkipResponseChar = @SkipResponseChar,
    MultiRespItemNotPickedChar = @MultiRespItemNotPickedChar,
    LocalFTPLoginName = @LocalFTPLoginName,
    VendorFileOutgoType_ID = @VendorFileOutgoType_ID,
	DontKnowResponseChar = @DontKnowResponseChar,
	RefusedResponseChar = @RefusedResponseChar
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF


