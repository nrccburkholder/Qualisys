---------------------------------------------------------------------------------------
--QSL_SelectVendorSampleSetFile
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorSampleSetFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorSampleSetFile]
GO
/*
CREATE PROCEDURE [dbo].[QSL_SelectVendorSampleSetFile]
@VendorFile_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT vf.VendorFile_ID, vf.Sampleset_ID, vf.DateCreated, vf.FileName, vf.bitCreated, 
       vf.RecordsInFile, vf.RecordsNoLitho, 
       ss.datSampleCreate_DT, ss.datDateRange_FromDate, ss.datDateRange_ToDate, 
       sd.Survey_ID, sd.strSurvey_Nm, st.strStudy_Nm, cl.strClient_Nm
FROM VendorFileCreationQueue vf, SampleSet ss, Survey_Def sd, Study st, Client cl
WHERE vf.SampleSet_ID = ss.SampleSet_ID
  AND ss.Survey_ID = sd.Survey_ID
  AND sd.Study_ID = st.Study_ID
  AND st.Client_ID = cl.Client_ID
  AND vf.VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
*/
---------------------------------------------------------------------------------------
--QSL_SelectVendorSampleSetFilesBySampleSetId
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorSampleSetFilesBySampleSetId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorSampleSetFilesBySampleSetId]
GO
/*
CREATE PROCEDURE [dbo].[QSL_SelectVendorSampleSetFilesBySampleSetId]
@SampleSet_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT vf.VendorFile_ID, vf.Sampleset_ID, vf.DateCreated, vf.FileName, vf.bitCreated, 
       vf.RecordsInFile, vf.RecordsNoLitho, 
       ss.datSampleCreate_DT, ss.datDateRange_FromDate, ss.datDateRange_ToDate, 
       sd.Survey_ID, sd.strSurvey_Nm, st.strStudy_Nm, cl.strClient_Nm
FROM VendorFileCreationQueue vf, SampleSet ss, Survey_Def sd, Study st, Client cl
WHERE vf.SampleSet_ID = ss.SampleSet_ID
  AND ss.Survey_ID = sd.Survey_ID
  AND sd.Study_ID = st.Study_ID
  AND st.Client_ID = cl.Client_ID
  AND vf.SampleSet_ID = @SampleSet_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
*/
---------------------------------------------------------------------------------------
--QSL_SelectVendorSampleSetFilesByCreated
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorSampleSetFilesByCreated]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectVendorSampleSetFilesByCreated]
GO
/*
CREATE PROCEDURE [dbo].[QSL_SelectVendorSampleSetFilesByCreated]
@Created BIT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT vf.VendorFile_ID, vf.Sampleset_ID, vf.DateCreated, vf.FileName, vf.bitCreated, 
       vf.RecordsInFile, vf.RecordsNoLitho, 
       ss.datSampleCreate_DT, ss.datDateRange_FromDate, ss.datDateRange_ToDate, 
       sd.Survey_ID, sd.strSurvey_Nm, st.strStudy_Nm, cl.strClient_Nm
FROM VendorFileCreationQueue vf, SampleSet ss, Survey_Def sd, Study st, Client cl
WHERE vf.SampleSet_ID = ss.SampleSet_ID
  AND ss.Survey_ID = sd.Survey_ID
  AND sd.Study_ID = st.Study_ID
  AND st.Client_ID = cl.Client_ID
  AND vf.bitCreated = @Created

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
*/
---------------------------------------------------------------------------------------
--QSL_SelectAllVendorSampleSetFiles
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllVendorSampleSetFiles]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllVendorSampleSetFiles]
GO
/*
CREATE PROCEDURE [dbo].[QSL_SelectAllVendorSampleSetFiles]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT vf.VendorFile_ID, vf.Sampleset_ID, vf.DateCreated, vf.FileName, vf.bitCreated, 
       vf.RecordsInFile, vf.RecordsNoLitho, 
       ss.datSampleCreate_DT, ss.datDateRange_FromDate, ss.datDateRange_ToDate, 
       sd.Survey_ID, sd.strSurvey_Nm, st.strStudy_Nm, cl.strClient_Nm
FROM VendorFileCreationQueue vf, SampleSet ss, Survey_Def sd, Study st, Client cl
WHERE vf.SampleSet_ID = ss.SampleSet_ID
  AND ss.Survey_ID = sd.Survey_ID
  AND sd.Study_ID = st.Study_ID
  AND st.Client_ID = cl.Client_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
*/
---------------------------------------------------------------------------------------
--QSL_InsertVendorSampleSetFile
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertVendorSampleSetFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertVendorSampleSetFile]
GO
/*
CREATE PROCEDURE [dbo].[QSL_InsertVendorSampleSetFile]
@Sampleset_ID INT,
@DateCreated DATETIME,
@FileName VARCHAR(250),
@bitCreated BIT,
@RecordsInFile INT,
@RecordsNoLitho INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].VendorFileCreationQueue (Sampleset_ID, DateCreated, FileName, bitCreated, RecordsInFile, RecordsNoLitho)
VALUES (@Sampleset_ID, @DateCreated, @FileName, @bitCreated, @RecordsInFile, @RecordsNoLitho)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
*/
---------------------------------------------------------------------------------------
--QSL_UpdateVendorSampleSetFile
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateVendorSampleSetFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateVendorSampleSetFile]
GO
/*
CREATE PROCEDURE [dbo].[QSL_UpdateVendorSampleSetFile]
@VendorFile_ID INT,
@Sampleset_ID INT,
@DateCreated DATETIME,
@FileName VARCHAR(250),
@bitCreated BIT,
@RecordsInFile INT,
@RecordsNoLitho INT
AS

SET NOCOUNT ON

UPDATE [dbo].VendorFileCreationQueue SET
	Sampleset_ID = @Sampleset_ID,
	DateCreated = @DateCreated,
	FileName = @FileName,
	bitCreated = @bitCreated,
	RecordsInFile = @RecordsInFile,
	RecordsNoLitho = @RecordsNoLitho
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
GO
*/
---------------------------------------------------------------------------------------
--QSL_DeleteVendorSampleSetFile
--No Longer Used
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteVendorSampleSetFile]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteVendorSampleSetFile]
GO
/*
CREATE PROCEDURE [dbo].[QSL_DeleteVendorSampleSetFile]
@VendorFile_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].VendorFileCreationQueue
WHERE VendorFile_ID = @VendorFile_ID

SET NOCOUNT OFF
GO
*/

