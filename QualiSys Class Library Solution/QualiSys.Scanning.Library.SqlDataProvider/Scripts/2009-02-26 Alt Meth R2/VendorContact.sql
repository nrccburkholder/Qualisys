---------------------------------------------------------------------------------------
--sp_SelectVendorContact
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_SelectVendorContact]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_SelectVendorContact]
GO
CREATE PROCEDURE [dbo].[sp_SelectVendorContact]
@VendorContact_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorContact_ID, VendorID, Type, FirstName, LastName, emailAddr1, emailAddr2, SendFileArrivalEmail, Phone1, Phone2, Notes
FROM [dbo].VendorContacts
WHERE VendorContact_ID = @VendorContact_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--sp_SelectAllVendorContacts
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_SelectAllVendorContacts]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_SelectAllVendorContacts]
GO
CREATE PROCEDURE [dbo].[sp_SelectAllVendorContacts]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorContact_ID, VendorID, Type, FirstName, LastName, emailAddr1, emailAddr2, SendFileArrivalEmail, Phone1, Phone2, Notes
FROM [dbo].VendorContacts

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--sp_SelectAllVendorContactsByVendor
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_SelectAllVendorContactsByVendor]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_SelectAllVendorContactsByVendor]
GO
CREATE PROCEDURE [dbo].[sp_SelectAllVendorContactsByVendor]
@Vendor_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorContact_ID, VendorID, Type, FirstName, LastName, emailAddr1, emailAddr2, SendFileArrivalEmail, Phone1, Phone2, Notes
FROM [dbo].VendorContacts
WHERE VendorID = @Vendor_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--sp_InsertVendorContact
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_InsertVendorContact]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_InsertVendorContact]
GO
CREATE PROCEDURE [dbo].[sp_InsertVendorContact]
@VendorID INT,
@Type VARCHAR(50),
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@emailAddr1 VARCHAR(150),
@emailAddr2 VARCHAR(50),
@SendFileArrivalEmail BIT,
@Phone1 VARCHAR(20),
@Phone2 VARCHAR(20),
@Notes VARCHAR(8000)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorContacts (VendorID, Type, FirstName, LastName, emailAddr1, emailAddr2, SendFileArrivalEmail, Phone1, Phone2, Notes)
VALUES (@VendorID, @Type, @FirstName, @LastName, @emailAddr1, @emailAddr2, @SendFileArrivalEmail, @Phone1, @Phone2, @Notes)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--sp_UpdateVendorContact
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_UpdateVendorContact]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_UpdateVendorContact]
GO
CREATE PROCEDURE [dbo].[sp_UpdateVendorContact]
@VendorContact_ID INT,
@VendorID INT,
@Type VARCHAR(50),
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@emailAddr1 VARCHAR(150),
@emailAddr2 VARCHAR(50),
@SendFileArrivalEmail BIT,
@Phone1 VARCHAR(20),
@Phone2 VARCHAR(20),
@Notes VARCHAR(8000)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorContacts SET
	VendorID = @VendorID,
	Type = @Type,
	FirstName = @FirstName,
	LastName = @LastName,
	emailAddr1 = @emailAddr1,
	emailAddr2 = @emailAddr2,
	SendFileArrivalEmail = @SendFileArrivalEmail,
	Phone1 = @Phone1,
	Phone2 = @Phone2,
	Notes = @Notes
WHERE VendorContact_ID = @VendorContact_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--sp_DeleteVendorContact
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[sp_DeleteVendorContact]') IS NOT NULL 
	DROP PROCEDURE [dbo].[sp_DeleteVendorContact]
GO
CREATE PROCEDURE [dbo].[sp_DeleteVendorContact]
@VendorContact_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorContacts
WHERE VendorContact_ID = @VendorContact_ID

SET NOCOUNT OFF
GO

