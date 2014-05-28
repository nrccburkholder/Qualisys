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


