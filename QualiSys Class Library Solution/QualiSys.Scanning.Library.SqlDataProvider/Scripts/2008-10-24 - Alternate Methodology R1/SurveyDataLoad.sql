---------------------------------------------------------------------------------------
--QSL_SelectSurveyDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectSurveyDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectSurveyDataLoad]
GO
CREATE PROCEDURE [dbo].[QSL_SelectSurveyDataLoad]
@SurveyDataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyDataLoad_ID, DataLoad_ID, Survey_ID, DateCreated, Notes
FROM [dbo].DL_SurveyDataLoad
WHERE SurveyDataLoad_ID = @SurveyDataLoad_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllSurveyDataLoads
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllSurveyDataLoads]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectAllSurveyDataLoads]
GO
---------------------------------------------------------------------------------------
--QSL_SelectSurveyDataLoadsByDataLoad_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectSurveyDataLoadsByDataLoadId]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectSurveyDataLoadsByDataLoadId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectSurveyDataLoadsByDataLoadId]
@DataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT SurveyDataLoad_ID, DataLoad_ID, Survey_ID, DateCreated, Notes
FROM DL_SurveyDataLoad
WHERE DataLoad_ID = @DataLoad_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_InsertSurveyDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertSurveyDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_InsertSurveyDataLoad]
GO
CREATE PROCEDURE [dbo].[QSL_InsertSurveyDataLoad]
@DataLoad_ID INT,
@Survey_ID INT,
@DateCreated DATETIME,
@Notes VARCHAR(8000)
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_SurveyDataLoad (DataLoad_ID, Survey_ID, DateCreated, Notes)
VALUES (@DataLoad_ID, @Survey_ID, @DateCreated, @Notes)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateSurveyDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateSurveyDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_UpdateSurveyDataLoad]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateSurveyDataLoad]
@SurveyDataLoad_ID INT,
@DataLoad_ID INT,
@Survey_ID INT,
@DateCreated DATETIME,
@Notes VARCHAR(8000)
AS

SET NOCOUNT ON

UPDATE [dbo].DL_SurveyDataLoad SET
	DataLoad_ID = @DataLoad_ID,
	Survey_ID = @Survey_ID,
	DateCreated = @DateCreated,
	Notes = @Notes
WHERE SurveyDataLoad_ID = @SurveyDataLoad_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteSurveyDataLoad
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteSurveyDataLoad]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_DeleteSurveyDataLoad]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteSurveyDataLoad]
@SurveyDataLoad_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_SurveyDataLoad
WHERE SurveyDataLoad_ID = @SurveyDataLoad_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_SelectValidationDataBySampleSet
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectValidationDataBySampleSet]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QSL_SelectValidationDataBySampleSet]
GO
CREATE PROCEDURE [dbo].[QSL_SelectValidationDataBySampleSet]
@SampleSet_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Question Data
SELECT qf.QuestionForm_id, sq.QstnCore, sq.ScaleID, min(su.SampleUnit_id) AS SampleUnit_id
FROM SentMailing sm, QuestionForm qf, DL_Sel_Qstns_BySampleSet sq, 
     SamplePop sp, SelectedSample ss, SampleUnitSection su
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.Survey_id = sq.Survey_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sq.SampleSet_id = sp.SampleSet_id
  AND sp.SampleSet_id = ss.SampleSet_id
  AND sp.Study_id = ss.Study_id
  AND sp.Pop_id = ss.Pop_id
  AND ss.SampleUnit_id = su.SampleUnit_id
  AND sq.Section_id = su.SelQstnsSection
  AND sq.Survey_id = su.SelQstnsSurvey_id
  AND sq.SampleSet_id = @SampleSet_ID
  AND sq.SubType = 1
GROUP BY qf.QuestionForm_id, sq.QstnCore, sq.ScaleID
ORDER BY qf.QuestionForm_id, sq.QstnCore, sq.ScaleID

--Comment Data
SELECT qf.QuestionForm_id, sq.QstnCore, min(su.SampleUnit_id) AS SampleUnit_id
FROM SentMailing sm, QuestionForm qf, DL_Sel_Qstns_BySampleSet sq, 
     SamplePop sp, SelectedSample ss, SampleUnitSection su
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.Survey_id = sq.Survey_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sq.SampleSet_id = sp.SampleSet_id
  AND sp.SampleSet_id = ss.SampleSet_id
  AND sp.Study_id = ss.Study_id
  AND sp.Pop_id = ss.Pop_id
  AND ss.SampleUnit_id = su.SampleUnit_id
  AND sq.Section_id = su.SelQstnsSection
  AND sq.Survey_id = su.SelQstnsSurvey_id
  AND sq.SampleSet_id = @SampleSet_ID
  AND sq.SubType = 4
  AND sq.Height > 0
GROUP BY qf.QuestionForm_id, sq.QstnCore
ORDER BY qf.QuestionForm_id, sq.QstnCore

--HandEntry Data
SELECT qf.QuestionForm_id, sq.QstnCore, hf.Item, hf.Line_id, mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength
FROM SentMailing sm, QuestionForm qf, DL_Sel_Qstns_BySampleSet sq, 
     SamplePop sp, SelectedSample ss, SampleUnitSection su, 
     MetaField mf, QP_Scan.dbo.HandWrittenField hf
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.Survey_id = sq.Survey_id
  AND qf.SamplePop_id = sp.SamplePop_id
  AND sq.SampleSet_id = sp.SampleSet_id
  AND sp.SampleSet_id = ss.SampleSet_id
  AND sp.Study_id = ss.Study_id
  AND sp.Pop_id = ss.Pop_id
  AND ss.SampleUnit_id = su.SampleUnit_id
  AND sq.Section_id = su.SelQstnsSection
  AND sq.Survey_id = su.SelQstnsSurvey_id
  AND hf.Survey_id = qf.Survey_id
  AND hf.Field_id = mf.Field_id
  AND hf.QstnCore = sq.QstnCore
  AND sq.SampleSet_id = @SampleSet_ID
  AND sq.SubType = 1
ORDER BY qf.QuestionForm_id, sq.QstnCore, hf.Item, hf.Line_id

--Scale Data
SELECT QPC_ID AS ScaleID, Item, CONVERT(VARCHAR, Val) AS Val
FROM DL_SEL_SCLS_BySampleSet
WHERE SampleSet_ID = @SampleSet_ID
ORDER BY QPC_ID, Item

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO

