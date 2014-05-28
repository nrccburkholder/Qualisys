CREATE PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueue]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_ID, Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc
FROM [dbo].VendorFileCreationQueue
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


