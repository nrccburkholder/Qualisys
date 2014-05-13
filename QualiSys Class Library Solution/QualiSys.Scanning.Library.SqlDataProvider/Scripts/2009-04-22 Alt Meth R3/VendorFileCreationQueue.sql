---------------------------------------------------------------------------------------
--VendorFileCreationQueue
---------------------------------------------------------------------------------------
ALTER TABLE dbo.VendorFileCreationQueue ADD
	ShowInTree bit NULL
GO
ALTER TABLE dbo.VendorFileCreationQueue ADD CONSTRAINT
	DF_VendorFileCreationQueue_ShowInTree DEFAULT 1 FOR ShowInTree
GO
---------------------------------------------------------------------------------------
--VendorFileStatus
---------------------------------------------------------------------------------------
DELETE VendorFileStatus
WHERE VendorFileStatus_ID = 6
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileCreationQueue
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileCreationQueue]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueue]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorFileCreationQueues
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorFileCreationQueues]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorFileCreationQueues]
GO
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorFileCreationQueues]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_ID, Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc
FROM [dbo].VendorFileCreationQueue

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileCreationQueuesBySampleset_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileCreationQueuesBySamplesetId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesBySamplesetId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesBySamplesetId]
@Sampleset_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_ID, Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc
FROM VendorFileCreationQueue
WHERE Sampleset_ID = @Sampleset_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileCreationQueuesByMailingStep_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileCreationQueuesByMailingStepId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesByMailingStepId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesByMailingStepId]
@MailingStep_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_ID, Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc
FROM VendorFileCreationQueue
WHERE MailingStep_ID = @MailingStep_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileCreationQueuesByVendorFileStatus_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileCreationQueuesByVendorFileStatusId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesByVendorFileStatusId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileCreationQueuesByVendorFileStatusId]
@VendorFileStatus_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_ID, Sampleset_ID, MailingStep_ID, VendorFileStatus_ID, DateFileCreated, DateDataCreated, ArchiveFileName, RecordsInFile, RecordsNoLitho, ShowInTree, ErrorDesc
FROM VendorFileCreationQueue
WHERE VendorFileStatus_ID = @VendorFileStatus_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertVendorFileCreationQueue
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorFileCreationQueue]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorFileCreationQueue]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_UpdateVendorFileCreationQueue
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorFileCreationQueue]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorFileCreationQueue]
GO
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
GO
---------------------------------------------------------------------------------------
--QSL_DeleteVendorFileCreationQueue
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorFileCreationQueue]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorFileCreationQueue]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteVendorFileCreationQueue]
@VendorFile_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileCreationQueue
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileData
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileData]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileData]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileData]
@VendorFile_ID INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @MailingStepMethodID INT

--Get the Mailing Step Method
SELECT @MailingStepMethodID = ms.MailingStepMethod_ID
FROM VendorFileCreationQueue vq, mailingstep ms
WHERE vq.MailingStep_Id = ms.MailingStep_ID
  AND vq.VendorFile_Id = @VendorFile_ID

--Determine which table has the data
IF @MailingStepMethodID IN (1, 3)
BEGIN
	--This is phone data
	SELECT HCAHPSSamp, Litho, Survey_ID, Sampleset_ID, Phone, AltPhone, FName, LName, Addr, Addr2, City, St, Zip5, PhServDate, LangID, Telematch, PhFacName, PhServInd1, PhServInd2, PhServInd3, PhServInd4, PhServInd5, PhServInd6, PhServInd7, PhServInd8, PhServInd9, PhServInd10, PhServInd11, PhServInd12
	FROM VendorPhoneFile_Data
	WHERE VendorFile_ID = @VendorFile_ID
END
ELSE IF @MailingStepMethodID IN (2, 4)
BEGIN
	--This is web data
	SELECT Survey_ID, Sampleset_ID, Litho, WAC, FName, LName, Email_Address, WbServDate, wbServInd1, wbServInd2, wbServInd3, wbServInd4, wbServInd5, wbServInd6, ExternalRespondentID, bitSentToVendor
	FROM [dbo].VendorWebFile_Data
	WHERE VendorFile_ID = @VendorFile_ID
END
ELSE
BEGIN
	--The MailingStepMethod is not for phone or web so throw an error
    RAISERROR ('Invalid Mailing Step Method.  Please Contact the System Aministrator.', -- Message Text
               16, -- Severity
               1)  -- State
    RETURN
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileFileName
--No longer being used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileFileName]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorFileFileName]
GO
/*
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileFileName]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT RTRIM(cl.strClient_Nm) + '_' + RTRIM(st.strStudy_Nm) + '_' + 
       RTRIM(sd.strSurvey_Nm) + '_' + CONVERT(VARCHAR, sd.Survey_ID) + '_' + 
       CONVERT(VARCHAR, ss.datDateRange_FromDate, 112) + '_' +
       CONVERT(VARCHAR, ss.datDateRange_ToDate, 112) + '_' + 
       RTRIM(ms.strMailingStep_Nm) AS FileName
FROM VendorFileCreationQueue vf, SampleSet ss, Survey_Def sd, Study st, Client cl, 
     MailingStep ms
WHERE vf.SampleSet_ID = ss.SampleSet_ID
  AND ss.Survey_ID = sd.Survey_ID
  AND sd.Study_ID = st.Study_ID
  AND st.Client_ID = cl.Client_ID
  AND vf.MailingStep_ID = ms.MailingStep_ID
  AND vf.VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
*/
