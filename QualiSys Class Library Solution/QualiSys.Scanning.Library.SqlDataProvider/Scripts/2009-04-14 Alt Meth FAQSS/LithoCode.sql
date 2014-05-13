---------------------------------------------------------------------------------------
--QSL_SelectLithoCode
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCode]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCode]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCode]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (DL_LithoCode_ID      INT,
                      SurveyDataLoad_ID    INT,
                      DL_Error_ID          INT,
                      TranslationCode      VARCHAR(10),
                      strLithoCode         VARCHAR(50),
                      bitIgnore            BIT,
                      bitSubmitted         BIT,
                      bitExtracted         BIT,
                      bitSkipDuplicate     BIT,
                      bitDispositionUpdate BIT,
                      DateCreated          DATETIME,
                      SentMail_id          INT, 
					  LangID               INT,
					  datExpire            DATETIME,
					  QuestionForm_id      INT,
					  SamplePop_id         INT,
					  Survey_id            INT,
					  datReturned          DATETIME,
					  UnusedReturn_id      INT,
					  datResultsImported   DATETIME,
					  SampleSet_id         INT,
					  Study_id             INT,
					  Pop_id               INT,
					  OtherStepImported    BIT,
					  strSurvey_Nm         VARCHAR(10),
					  strClient_Nm         VARCHAR(40))

INSERT INTO #Lithos
SELECT lc.DL_LithoCode_ID, lc.SurveyDataLoad_ID, lc.DL_Error_ID, lc.TranslationCode, lc.strLithoCode, lc.bitIgnore, 
       lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated, 
       sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0, sd.strSurvey_Nm, 
       cl.strClient_Nm
FROM (((((DL_LithoCodes lc (NOLOCK) LEFT JOIN SentMailing sm (NOLOCK) ON lc.strLithoCode = sm.strLithoCode)
                                    LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id)
                                    LEFT JOIN SamplePop sp (NOLOCK) ON qf.SamplePop_id = sp.SamplePop_id)
                                    LEFT JOIN Survey_Def sd (NOLOCK) ON qf.Survey_id = sd.Survey_id)
                                    LEFT JOIN Study st (NOLOCK) ON sd.Study_id = st.Study_id)
                                    LEFT JOIN Client cl (NOLOCK) ON st.Client_id = cl.Client_id
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT DL_LithoCode_ID, SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore,
       bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated, SentMail_id, LangID, 
       datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned, UnusedReturn_id, datResultsImported, 
       SampleSet_id, Study_id, Pop_id, OtherStepImported, strSurvey_Nm, strClient_Nm 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodesBySurveyDataLoad_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCodesBySurveyDataLoadId]
@SurveyDataLoad_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (DL_LithoCode_ID      INT,
                      SurveyDataLoad_ID    INT,
                      DL_Error_ID          INT,
                      TranslationCode      VARCHAR(10),
                      strLithoCode         VARCHAR(50),
                      bitIgnore            BIT,
                      bitSubmitted         BIT,
                      bitExtracted         BIT,
                      bitSkipDuplicate     BIT,
                      bitDispositionUpdate BIT,
                      DateCreated          DATETIME,
                      SentMail_id          INT, 
					  LangID               INT,
					  datExpire            DATETIME,
					  QuestionForm_id      INT,
					  SamplePop_id         INT,
					  Survey_id            INT,
					  datReturned          DATETIME,
					  UnusedReturn_id      INT,
					  datResultsImported   DATETIME,
					  SampleSet_id         INT,
					  Study_id             INT,
					  Pop_id               INT,
					  OtherStepImported    BIT,
					  strSurvey_Nm         VARCHAR(10),
					  strClient_Nm         VARCHAR(40))

INSERT INTO #Lithos
SELECT lc.DL_LithoCode_ID, lc.SurveyDataLoad_ID, lc.DL_Error_ID, lc.TranslationCode, lc.strLithoCode, lc.bitIgnore, 
       lc.bitSubmitted, lc.bitExtracted, lc.bitSkipDuplicate, lc.bitDispositionUpdate, lc.DateCreated, 
       sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0, sd.strSurvey_Nm, 
       cl.strClient_Nm
FROM (((((DL_LithoCodes lc (NOLOCK) LEFT JOIN SentMailing sm (NOLOCK) ON lc.strLithoCode = sm.strLithoCode)
                                    LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id)
                                    LEFT JOIN SamplePop sp (NOLOCK) ON qf.SamplePop_id = sp.SamplePop_id)
                                    LEFT JOIN Survey_Def sd (NOLOCK) ON qf.Survey_id = sd.Survey_id)
                                    LEFT JOIN Study st (NOLOCK) ON sd.Study_id = st.Study_id)
                                    LEFT JOIN Client cl (NOLOCK) ON st.Client_id = cl.Client_id
WHERE lc.SurveyDataLoad_ID = @SurveyDataLoad_ID

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT DL_LithoCode_ID, SurveyDataLoad_ID, DL_Error_ID, TranslationCode, strLithoCode, bitIgnore,
       bitSubmitted, bitExtracted, bitSkipDuplicate, bitDispositionUpdate, DateCreated, SentMail_id, LangID, 
       datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned, UnusedReturn_id, datResultsImported, 
       SampleSet_id, Study_id, Pop_id, OtherStepImported, strSurvey_Nm, strClient_Nm 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectLithoCodeAdditionalInfo
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectLithoCodeAdditionalInfo]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectLithoCodeAdditionalInfo]
GO
CREATE PROCEDURE [dbo].[QSL_SelectLithoCodeAdditionalInfo]
    @strLithoCode VARCHAR(10)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Lithos (SentMail_id        INT, 
					  LangID             INT,
					  datExpire          DATETIME,
					  QuestionForm_id    INT,
					  SamplePop_id       INT,
					  Survey_id          INT,
					  datReturned        DATETIME,
					  UnusedReturn_id    INT,
					  datResultsImported DATETIME,
					  SampleSet_id       INT,
					  Study_id           INT,
					  Pop_id             INT,
					  OtherStepImported  BIT,
					  strSurvey_Nm       VARCHAR(10),
					  strClient_Nm       VARCHAR(40))

INSERT INTO #Lithos
SELECT sm.SentMail_id, sm.LangID, sm.datExpire, qf.QuestionForm_id, qf.SamplePop_id, qf.Survey_id, qf.datReturned, 
       qf.UnusedReturn_id, qf.datResultsImported, sp.SampleSet_id, sp.Study_id, sp.Pop_id, 0, sd.strSurvey_Nm, 
       cl.strClient_Nm 
FROM ((((SentMailing sm (NOLOCK) LEFT JOIN QuestionForm qf (NOLOCK) ON sm.SentMail_id = qf.SentMail_id)
                                 LEFT JOIN SamplePop sp (NOLOCK) ON qf.SamplePop_id = sp.SamplePop_Id)
                                 LEFT JOIN Survey_Def sd (NOLOCK) ON qf.Survey_id = sd.Survey_id)
                                 LEFT JOIN Study st (NOLOCK) ON sd.Study_id = st.Study_id)
                                 LEFT JOIN Client cl (NOLOCK) ON st.Client_id = cl.Client_id
WHERE sm.strLithoCode = @strLithoCode

UPDATE lt
SET lt.OtherStepImported = 1
FROM #Lithos lt, QuestionForm q1, QuestionForm q2
WHERE lt.QuestionForm_id = q1.QuestionForm_id
  AND q2.QuestionForm_id <> q1.QuestionForm_id
  AND q2.SamplePop_id = q1.SamplePop_id
  AND q2.datResultsImported IS NOT NULL

SELECT SentMail_id, LangID, datExpire, QuestionForm_id, SamplePop_id, Survey_id, datReturned,
       UnusedReturn_id, datResultsImported, SampleSet_id, Study_id, Pop_id, 
       OtherStepImported, strSurvey_Nm, strClient_Nm 
FROM #Lithos

DROP TABLE #Lithos

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
