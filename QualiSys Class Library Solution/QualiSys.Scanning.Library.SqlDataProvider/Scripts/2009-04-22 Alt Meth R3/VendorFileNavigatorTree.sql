---------------------------------------------------------------------------------------
--VendorFileStatusTree
--Renamed
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[VendorFileStatusTree]') IS NOT NULL 
    DROP PROCEDURE [dbo].[VendorFileStatusTree]
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileNavigatorTree
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileNavigatorTree]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectVendorFileNavigatorTree]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileNavigatorTree]
@VendorStatus INT      = 0, 
@StartDate    DATETIME = NULL,
@EndDate      DATETIME = NULL
AS

--Set the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Select the tree data
IF @VendorStatus = 0
BEGIN
    SELECT vq.VendorFile_ID, vq.SampleSet_ID, cv.strClient_Nm, cv.Client_ID, cv.strStudy_Nm, cv.Study_ID, cv.strSurvey_Nm, cv.Survey_ID,
           vq.VendorFileStatus_ID, vs.VendorFileStatus_Nm, vq.ShowInTree, mm.MailingStepMethod_ID, mm.MailingStepMethod_Nm, 
           CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) + ' ' + ms.strMailingStep_Nm AS Name, vq.ErrorDesc, ms.Vendor_ID
    FROM CSS_View cv, SampleSet ss, VendorFileCreationQueue vq, MailingStep ms, MailingStepMethod mm, VendorFileStatus vs
    WHERE cv.Survey_ID = ss.Survey_ID 
      AND ss.SampleSet_ID = vq.SampleSet_ID
      AND vq.MailingStep_ID = ms.MailingStep_ID
      AND ms.MailingStepMethod_ID = mm.MailingStepMethod_ID
      AND vs.VendorFileStatus_ID = vq.VendorFileStatus_ID
      AND CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) >= ISNULL(@StartDate, '1900-1-1')
      AND CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) <= ISNULL(@EndDate, '2149-1-1') 
    ORDER BY cv.strClient_Nm, cv.strStudy_Nm, cv.strSurvey_Nm, CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) + ' ' + ms.strMailingStep_Nm
END
ELSE
BEGIN
    SELECT vq.VendorFile_ID, vq.SampleSet_ID, cv.strClient_Nm, cv.Client_ID, cv.strStudy_Nm, cv.Study_ID, cv.strSurvey_Nm, cv.Survey_ID,
           vq.VendorFileStatus_ID, vs.VendorFileStatus_Nm, vq.ShowInTree, mm.MailingStepMethod_ID, mm.MailingStepMethod_Nm, 
           CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) + ' ' + ms.strMailingStep_Nm AS Name, vq.ErrorDesc, ms.Vendor_ID
    FROM CSS_View cv, SampleSet ss, VendorFileCreationQueue vq, MailingStep ms, MailingStepMethod mm, VendorFileStatus vs
    WHERE cv.Survey_ID = ss.Survey_ID 
      AND ss.SampleSet_ID = vq.SampleSet_ID
      AND vq.MailingStep_ID = ms.MailingStep_ID
      AND ms.MailingStepMethod_ID = mm.MailingStepMethod_ID
      AND vs.VendorFileStatus_ID = vq.VendorFileStatus_ID
      AND vq.VendorFileStatus_ID = @VendorStatus
      AND CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) >= ISNULL(@StartDate, '1900-1-1')
      AND CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) <= ISNULL(@EndDate, '2149-1-1') 
    ORDER BY cv.strClient_Nm, cv.strStudy_Nm, cv.strSurvey_Nm, CONVERT(VARCHAR, ss.datSampleCreate_Dt, 101) + ' ' + ms.strMailingStep_Nm
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
