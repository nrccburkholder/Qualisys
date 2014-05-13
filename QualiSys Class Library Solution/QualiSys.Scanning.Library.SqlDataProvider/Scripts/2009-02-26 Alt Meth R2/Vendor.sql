---------------------------------------------------------------------------------------
--QSL_SelectVendor
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendor]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendor]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendor]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Vendor_ID, VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, Province, 
       Zip5, Zip4, DateCreated, DateModified, 
       bitAcceptFilesFromVendor, NoResponseChar, SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName
FROM [dbo].Vendors
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorByVendorCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorByVendorCode]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorByVendorCode]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorByVendorCode]
@VendorCode VARCHAR(25)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Vendor_ID, VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, Province, 
       Zip5, Zip4, DateCreated, DateModified, 
       bitAcceptFilesFromVendor, NoResponseChar, SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName
FROM [dbo].Vendors
WHERE VendorCode = @VendorCode

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendors
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendors]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendors]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendors]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Vendor_ID, VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, Province, 
       Zip5, Zip4, DateCreated, DateModified, 
       bitAcceptFilesFromVendor, NoResponseChar, SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName
FROM [dbo].Vendors

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendor
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendor]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendor]
GO
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
@LocalFTPLoginName VARCHAR(20)
AS

SET NOCOUNT ON

INSERT INTO [dbo].Vendors (VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, 
                           Province, Zip5, Zip4, DateCreated, DateModified, bitAcceptFilesFromVendor, 
                           NoResponseChar, SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName)
VALUES (@VendorCode, @Vendor_nm, @Phone, @Addr1, @Addr2, @City, @StateCode, @Province, 
        @Zip5, @Zip4, @DateCreated, @DateModified, 
        @bitAcceptFilesFromVendor, @NoResponseChar, @SkipResponseChar, @MultiRespItemNotPickedChar, @LocalFTPLoginName)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendor
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendor]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendor]
GO
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
@LocalFTPLoginName VARCHAR(20)
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
    LocalFTPLoginName = @LocalFTPLoginName
WHERE Vendor_ID = @Vendor_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_IsUniqueVendorCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_IsUniqueVendorCode]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_IsUniqueVendorCode]
GO
CREATE PROCEDURE [dbo].[QSL_IsUniqueVendorCode]
@Vendor_ID INT,
@VendorCode VARCHAR(25)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Vendor_ID, VendorCode, Vendor_nm, Phone, Addr1, Addr2, City, StateCode, Province, 
       Zip5, Zip4, DateCreated, DateModified, 
       bitAcceptFilesFromVendor, NoResponseChar, SkipResponseChar, MultiRespItemNotPickedChar, LocalFTPLoginName
FROM [dbo].Vendors
WHERE Vendor_ID != @Vendor_ID AND VendorCode = @VendorCode

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO