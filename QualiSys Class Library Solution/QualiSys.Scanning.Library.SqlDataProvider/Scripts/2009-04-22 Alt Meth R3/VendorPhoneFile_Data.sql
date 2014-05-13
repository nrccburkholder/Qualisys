---------------------------------------------------------------------------------------
--QSL_SelectVendorPhoneFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorPhoneFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorPhoneFile_Data]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorPhoneFile_Datas
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorPhoneFile_Datas]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorPhoneFile_Datas]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorPhoneFile_Datas]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_Data_ID, VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
FROM [dbo].VendorPhoneFile_Data

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorPhoneFile_DatasByVendorFile_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorPhoneFile_DatasByVendorFileId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorPhoneFile_DatasByVendorFileId]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorPhoneFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorPhoneFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorPhoneFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorPhoneFile_Data]
@VendorFile_ID INT,
@HCAHPSSamp INT,
@Litho VARCHAR(10),
@Survey_ID INT,
@Sampleset_ID INT,
@Phone VARCHAR(10),
@AltPhone VARCHAR(10),
@FName VARCHAR(42),
@LName VARCHAR(42),
@Addr VARCHAR(42),
@Addr2 VARCHAR(42),
@City VARCHAR(42),
@St VARCHAR(2),
@Zip5 VARCHAR(5),
@PhServDate DATETIME,
@LangID INT,
@Telematch VARCHAR(15),
@PhFacName VARCHAR(100),
@PhServInd1 VARCHAR(100),
@PhServInd2 VARCHAR(100),
@PhServInd3 VARCHAR(100),
@PhServInd4 VARCHAR(100),
@PhServInd5 VARCHAR(100),
@PhServInd6 VARCHAR(100),
@PhServInd7 VARCHAR(100),
@PhServInd8 VARCHAR(100),
@PhServInd9 VARCHAR(100),
@PhServInd10 VARCHAR(100),
@PhServInd11 VARCHAR(100),
@PhServInd12 VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorPhoneFile_Data (VendorFile_ID, HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12)
VALUES (@VendorFile_ID, @HCAHPSSamp, @Litho, @Survey_ID, @Sampleset_ID, @Phone, @AltPhone, @FName, @LName, @Addr, @Addr2, @City, @St, @Zip5, @PhServDate, @LangID, @Telematch, @PhFacName, @PhServInd1, @PhServInd2, @PhServInd3, @PhServInd4, @PhServInd5, @PhServInd6, @PhServInd7, @PhServInd8, @PhServInd9, @PhServInd10, @PhServInd11, @PhServInd12)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorPhoneFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorPhoneFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorPhoneFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorPhoneFile_Data]
@VendorFile_Data_ID INT,
@VendorFile_ID INT,
@HCAHPSSamp INT,
@Litho VARCHAR(10),
@Survey_ID INT,
@Sampleset_ID INT,
@Phone VARCHAR(10),
@AltPhone VARCHAR(10),
@FName VARCHAR(42),
@LName VARCHAR(42),
@Addr VARCHAR(42),
@Addr2 VARCHAR(42),
@City VARCHAR(42),
@St VARCHAR(2),
@Zip5 VARCHAR(5),
@PhServDate DATETIME,
@LangID INT,
@Telematch VARCHAR(15),
@PhFacName VARCHAR(100),
@PhServInd1 VARCHAR(100),
@PhServInd2 VARCHAR(100),
@PhServInd3 VARCHAR(100),
@PhServInd4 VARCHAR(100),
@PhServInd5 VARCHAR(100),
@PhServInd6 VARCHAR(100),
@PhServInd7 VARCHAR(100),
@PhServInd8 VARCHAR(100),
@PhServInd9 VARCHAR(100),
@PhServInd10 VARCHAR(100),
@PhServInd11 VARCHAR(100),
@PhServInd12 VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorPhoneFile_Data SET
	VendorFile_ID = @VendorFile_ID,
	HCAHPSSamp = @HCAHPSSamp,
	Litho = @Litho,
	Survey_ID = @Survey_ID,
	Sampleset_ID = @Sampleset_ID,
	Phone = @Phone,
	AltPhone = @AltPhone,
	FName = @FName,
	LName = @LName,
	Addr = @Addr,
	Addr2 = @Addr2,
	City = @City,
	St = @St,
	Zip5 = @Zip5,
	PhServDate = @PhServDate,
	LangID = @LangID,
	Telematch = @Telematch,
	PhFacName = @PhFacName,
	PhServInd1 = @PhServInd1,
	PhServInd2 = @PhServInd2,
	PhServInd3 = @PhServInd3,
	PhServInd4 = @PhServInd4,
	PhServInd5 = @PhServInd5,
	PhServInd6 = @PhServInd6,
	PhServInd7 = @PhServInd7,
	PhServInd8 = @PhServInd8,
	PhServInd9 = @PhServInd9,
	PhServInd10 = @PhServInd10,
	PhServInd11 = @PhServInd11,
	PhServInd12 = @PhServInd12
WHERE VendorFile_Data_ID = @VendorFile_Data_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorPhoneFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorPhoneFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorPhoneFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorPhoneFile_Data]
@VendorFile_Data_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorPhoneFile_Data
WHERE VendorFile_Data_ID = @VendorFile_Data_ID

SET NOCOUNT OFF
GO

