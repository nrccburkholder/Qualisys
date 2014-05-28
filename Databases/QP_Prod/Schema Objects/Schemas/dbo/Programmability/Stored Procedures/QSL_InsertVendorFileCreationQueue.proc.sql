CREATE PROCEDURE [dbo].[QSL_InsertVendorFileCreationQueue]
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

INSERT INTO [dbo].VendorFileCreationQueue (Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc)
VALUES (@Sampleset_ID, @MailingStep_ID, @VendorFileStatus_ID, @DateFileCreated, @DateDataCreated, @ArchiveFileName, @RecordsInFile, @RecordsNoLitho, @ShowInTree, @ErrorDesc)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


