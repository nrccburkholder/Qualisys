---------------------------------------------------------------------------------------
--DL_RetrieveTreeView
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_RetrieveTreeView]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_RetrieveTreeView]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcDistinctLithosInError
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcDistinctLithosInError]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcDistinctLithosInError]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcTotalCommentErrors
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcTotalCommentErrors]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcTotalCommentErrors]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcTotalDispositionErrors
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcTotalDispositionErrors]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcTotalDispositionErrors]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcTotalHandEntryErrors
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcTotalHandEntryErrors]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcTotalHandEntryErrors]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcTotalLithoErrors
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcTotalLithoErrors]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcTotalLithoErrors]
GO
---------------------------------------------------------------------------------------
--DL_sp_CalcTotalQuestionResultErrors
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DL_sp_CalcTotalQuestionResultErrors]') IS NOT NULL 
    DROP PROCEDURE [dbo].[DL_sp_CalcTotalQuestionResultErrors]
GO
---------------------------------------------------------------------------------------
--QSL_SelectVendorFileSurveyTree
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectVendorFileSurveyTree]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectVendorFileSurveyTree]
GO
CREATE PROCEDURE [dbo].[QSL_SelectVendorFileSurveyTree]
@StartDate DATETIME,
@EndDate   DATETIME,
@SortMode  INT
AS

--Set the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Create the required temp table
CREATE TABLE #TreeData (Vendor_ID         INT, 
                        Vendor_Nm         VARCHAR(100),
                        DataLoad_ID       INT,
                        DisplayName       VARCHAR(500),
                        bitShowInTree     BIT,
                        SurveyDataLoad_ID INT,
                        Survey_ID         INT,
                        strSurvey_Nm      VARCHAR(10),
                        bitSDLHasErrors   BIT
                       )
                       
CREATE TABLE #DLErrors (DataLoad_ID          INT,
                        bitDLHasBadLithos    BIT,
                        bitDLHasSurveyErrors BIT
                       )
                       
--Select the tree data
INSERT INTO #TreeData (Vendor_ID, Vendor_Nm, DataLoad_ID, DisplayName, bitShowInTree, SurveyDataLoad_ID, Survey_ID, strSurvey_Nm, bitSDLHasErrors)
SELECT vd.Vendor_ID, vd.Vendor_Nm, dl.DataLoad_ID, dl.DisplayName, dl.bitShowInTree, sl.SurveyDataLoad_ID, sl.Survey_ID, sd.strSurvey_Nm, sl.bitHasErrors
FROM Vendors vd, DL_DataLoad dl, DL_SurveyDataLoad sl, Survey_Def sd
WHERE vd.Vendor_ID = dl.Vendor_ID
  AND dl.DataLoad_ID = sl.DataLoad_ID
  AND sl.Survey_ID = sd.Survey_ID
  AND dl.DateLoaded >= convert(varchar, @StartDate, 101)
  AND dl.DateLoaded <= convert(varchar, @EndDate, 101) + ' 23:59:59'

--Determine which dataloads have errors
INSERT INTO #DLErrors (DataLoad_ID, bitDLHasSurveyErrors, bitDLHasBadLithos)
SELECT td.DataLoad_ID, 
       CASE WHEN (MAX(CONVERT(INT, ISNULL(td.bitSDLHasErrors, 0)))) > 0 THEN 1 ELSE 0 END AS bitDLHasSurveyErrors, 
       CASE WHEN (COUNT(bl.BadLitho_ID)) > 0 THEN 1 ELSE 0 END AS bitDLHasBadLithos
FROM #TreeData td, DL_BadLithos bl
WHERE td.DataLoad_ID *= bl.DataLoad_ID
GROUP BY td.DataLoad_ID

--Return the data set
IF (@SortMode = 0)
BEGIN
	SELECT td.Vendor_ID, td.Vendor_Nm, td.DataLoad_ID, td.DisplayName, td.bitShowInTree, de.bitDLHasSurveyErrors, de.bitDLHasBadLithos, td.SurveyDataLoad_ID, td.Survey_ID, td.strSurvey_Nm, td.bitSDLHasErrors
	FROM #TreeData td, #DLErrors de
	WHERE td.DataLoad_id = de.DataLoad_id
	ORDER BY td.Vendor_Nm, td.DataLoad_ID DESC, td.strSurvey_Nm
END
ELSE
BEGIN
	SELECT td.Vendor_ID, td.Vendor_Nm, td.DataLoad_ID, td.DisplayName, td.bitShowInTree, de.bitDLHasSurveyErrors, de.bitDLHasBadLithos, td.SurveyDataLoad_ID, td.Survey_ID, td.strSurvey_Nm, td.bitSDLHasErrors
	FROM #TreeData td, #DLErrors de
	WHERE td.DataLoad_id = de.DataLoad_id
	ORDER BY td.Vendor_Nm, td.DisplayName, td.strSurvey_Nm
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
