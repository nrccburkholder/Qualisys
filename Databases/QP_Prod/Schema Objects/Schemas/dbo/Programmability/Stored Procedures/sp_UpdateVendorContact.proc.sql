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


