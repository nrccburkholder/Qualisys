CREATE PROCEDURE [dbo].[sp_SelectAllVendorContacts]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorContact_ID, VendorID, Type, FirstName, LastName, emailAddr1, emailAddr2, SendFileArrivalEmail, Phone1, Phone2, Notes
FROM [dbo].VendorContacts

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


