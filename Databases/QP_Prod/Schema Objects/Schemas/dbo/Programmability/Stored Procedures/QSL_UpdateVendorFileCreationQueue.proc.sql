CREATE PROCEDURE [dbo].[QSL_UpdateVendorFileCreationQueue]
@VendorFile_ID INT,
@Sampleset_ID INT,
@MailingStep_ID INT,
@VendorFileStatus_ID INT,
@DateFileCreated DATETIME,
@DateDataCreated DATETIME,
@ArchiveFileName VARCHAR(500),
@RecordsInFile INT,
@RecordsNoLitho INT,
@ShowInTree BIT,
@ErrorDesc VARCHAR(1000)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileCreationQueue SET
	Sampleset_ID = @Sampleset_ID,
	MailingStep_ID = @MailingStep_ID,
	VendorFileStatus_ID = @VendorFileStatus_ID,
	DateFileCreated = @DateFileCreated,
	DateDataCreated = @DateDataCreated,
	ArchiveFileName = @ArchiveFileName,
	RecordsInFile = @RecordsInFile,
	RecordsNoLitho = @RecordsNoLitho,
	ShowInTree = @ShowInTree,
	ErrorDesc = @ErrorDesc
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF


