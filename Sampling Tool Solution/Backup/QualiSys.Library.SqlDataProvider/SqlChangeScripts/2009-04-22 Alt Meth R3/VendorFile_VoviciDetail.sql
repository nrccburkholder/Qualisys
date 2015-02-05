---------------------------------------------------------------------------------------
--QCL_SelectVendorFile_VoviciDetail
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectVendorFile_VoviciDetail]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetail]
GO
CREATE PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM [dbo].VendorFile_VoviciDetails
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectAllVendorFile_VoviciDetails
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectAllVendorFile_VoviciDetails]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectAllVendorFile_VoviciDetails]
GO
CREATE PROCEDURE [dbo].[QCL_SelectAllVendorFile_VoviciDetails]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM [dbo].VendorFile_VoviciDetails

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectVendorFile_VoviciDetailsBySurvey_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectVendorFile_VoviciDetailsBySurveyId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetailsBySurveyId]
GO
CREATE PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetailsBySurveyId]
@Survey_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM VendorFile_VoviciDetails
WHERE Survey_ID = @Survey_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_SelectVendorFile_VoviciDetailsByMailingStep_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectVendorFile_VoviciDetailsByMailingStepId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetailsByMailingStepId]
GO
CREATE PROCEDURE [dbo].[QCL_SelectVendorFile_VoviciDetailsByMailingStepId]
@MailingStep_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT VendorFile_VoviciDetail_ID, Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm
FROM VendorFile_VoviciDetails
WHERE MailingStep_ID = @MailingStep_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QCL_InsertVendorFile_VoviciDetail
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_InsertVendorFile_VoviciDetail]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_InsertVendorFile_VoviciDetail]
GO
CREATE PROCEDURE [dbo].[QCL_InsertVendorFile_VoviciDetail]
@Survey_ID INT,
@MailingStep_ID INT,
@VoviciSurvey_ID INT,
@VoviciSurvey_nm VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFile_VoviciDetails (Survey_ID, MailingStep_ID, VoviciSurvey_ID, VoviciSurvey_nm)
VALUES (@Survey_ID, @MailingStep_ID, @VoviciSurvey_ID, @VoviciSurvey_nm)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_UpdateVendorFile_VoviciDetail
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_UpdateVendorFile_VoviciDetail]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_UpdateVendorFile_VoviciDetail]
GO
CREATE PROCEDURE [dbo].[QCL_UpdateVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT,
@Survey_ID INT,
@MailingStep_ID INT,
@VoviciSurvey_ID INT,
@VoviciSurvey_nm VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFile_VoviciDetails SET
	Survey_ID = @Survey_ID,
	MailingStep_ID = @MailingStep_ID,
	VoviciSurvey_ID = @VoviciSurvey_ID,
	VoviciSurvey_nm = @VoviciSurvey_nm
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QCL_DeleteVendorFile_VoviciDetail
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_DeleteVendorFile_VoviciDetail]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_DeleteVendorFile_VoviciDetail]
GO
CREATE PROCEDURE [dbo].[QCL_DeleteVendorFile_VoviciDetail]
@VendorFile_VoviciDetail_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFile_VoviciDetails
WHERE VendorFile_VoviciDetail_ID = @VendorFile_VoviciDetail_ID

SET NOCOUNT OFF
GO

