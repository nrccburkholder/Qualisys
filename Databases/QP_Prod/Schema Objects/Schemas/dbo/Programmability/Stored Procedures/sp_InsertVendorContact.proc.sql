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


