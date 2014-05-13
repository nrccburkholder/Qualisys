---------------------------------------------------------------------------------------
--QSL_SelectVendorWebFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorWebFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorWebFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorWebFile_Data]
@VendorWebFile_Data_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, LangID, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
FROM [dbo].VendorWebFile_Data
WHERE VendorWebFile_Data_ID = @VendorWebFile_Data_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorWebFile_Datas
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorWebFile_Datas]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorWebFile_Datas]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorWebFile_Datas]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, LangID, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
FROM [dbo].VendorWebFile_Data

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorWebFile_DatasByVendorFile_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorWebFile_DatasByVendorFileId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorWebFile_DatasByVendorFileId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorWebFile_DatasByVendorFileId]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorWebFile_Data_ID, VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LangID, LName, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
FROM VendorWebFile_Data
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorWebFile_DatasByLitho
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorWebFile_DatasByLitho]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorWebFile_DatasByLitho]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorWebFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorWebFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorWebFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_InsertVendorWebFile_Data]
@VendorFile_ID INT,
@Survey_ID INT,
@Sampleset_ID INT,
@Litho VARCHAR(50),
@WAC VARCHAR(50),
@FName VARCHAR(42),
@LName VARCHAR(42),
@LangID INT,
@EmailAddr VARCHAR(100),
@WbServDate DATETIME,
@wbServInd1 VARCHAR(100),
@wbServInd2 VARCHAR(100),
@wbServInd3 VARCHAR(100),
@wbServInd4 VARCHAR(100),
@wbServInd5 VARCHAR(100),
@wbServInd6 VARCHAR(100),
@ExternalRespondentID VARCHAR(100),
@bitSentToVendor BIT
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorWebFile_Data (VendorFile_ID, Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, LangID, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor)
VALUES (@VendorFile_ID, @Survey_ID, @Sampleset_ID, @Litho, @WAC, @FName, @LName, @LangID, @EmailAddr, @WbServDate, @wbServInd1, @wbServInd2, @wbServInd3, @wbServInd4, @wbServInd5, @wbServInd6, @ExternalRespondentID, @bitSentToVendor)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorWebFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorWebFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorWebFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateVendorWebFile_Data]
@VendorWebFile_Data_ID INT,
@VendorFile_ID INT,
@Survey_ID INT,
@Sampleset_ID INT,
@Litho VARCHAR(50),
@WAC VARCHAR(50),
@FName VARCHAR(42),
@LName VARCHAR(42),
@LangID INT,
@EmailAddr VARCHAR(100),
@WbServDate DATETIME,
@wbServInd1 VARCHAR(100),
@wbServInd2 VARCHAR(100),
@wbServInd3 VARCHAR(100),
@wbServInd4 VARCHAR(100),
@wbServInd5 VARCHAR(100),
@wbServInd6 VARCHAR(100),
@ExternalRespondentID VARCHAR(100),
@bitSentToVendor BIT
AS

SET NOCOUNT ON

UPDATE [dbo].VendorWebFile_Data SET
	VendorFile_ID = @VendorFile_ID,
	Survey_ID = @Survey_ID,
	Sampleset_ID = @Sampleset_ID,
	Litho = @Litho,
	WAC = @WAC,
	FName = @FName,
	LName = @LName,
	LangID = @LangID,
	Email_Address = @EmailAddr,
	WbServDate = @WbServDate,
	wbServInd1 = @wbServInd1,
	wbServInd2 = @wbServInd2,
	wbServInd3 = @wbServInd3,
	wbServInd4 = @wbServInd4,
	wbServInd5 = @wbServInd5,
	wbServInd6 = @wbServInd6,
	ExternalRespondentID = @ExternalRespondentID,
	bitSentToVendor = @bitSentToVendor
WHERE VendorWebFile_Data_ID = @VendorWebFile_Data_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorWebFile_Data
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorWebFile_Data]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorWebFile_Data]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorWebFile_Data]
@VendorWebFile_Data_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorWebFile_Data
WHERE VendorWebFile_Data_ID = @VendorWebFile_Data_ID

SET NOCOUNT OFF
GO

