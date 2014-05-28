CREATE PROCEDURE sp_BDUS_GetInitialInfo
    @strLithoCode varchar(10)

AS

--Declare variables
DECLARE @strSQL           varchar(1000)
DECLARE @intStudyID       int
DECLARE @intSurveyID      int
DECLARE @intQtyFields     int
DECLARE @intCutOffFieldID int

--Set SQL Settings
SET NOCOUNT ON

--Create the temp table to hold the return dataset
CREATE TABLE #MyData (intClientID int, strClientName varchar(40), intStudyID int, strStudyName varchar(10), 
                      intSurveyID int, strSurveyName varchar(10), datUndeliverable datetime, intPopID int,
                      intSamplePopID int, intToclID int, strFName varchar(42), strLName varchar(42), 
                      intQtyFields int, intCutOffFieldID int, strCutOffFieldName varchar(20), 
                      bitCutOffFieldError bit, intQuestionFormID int)

--Get the initial data
INSERT INTO #MyData (intClientID, strClientName, intStudyID, strStudyName, intSurveyID, strSurveyName, 
                     datUndeliverable, intPopID, intSamplePopID, intToclID, intCutOffFieldID, 
                     bitCutOffFieldError, intQuestionFormID)
SELECT cl.Client_id, cl.strClient_Nm, st.Study_id, st.strStudy_Nm, sd.Survey_id, sd.strSurvey_Nm, 
       sm.datUndeliverable, sp.Pop_id, sp.SamplePop_id, tl.TOCL_id, sd.CutOffField_id, 0, qf.QuestionForm_id
FROM SentMailing sm, QuestionForm qf, Client cl, Study st, Survey_Def sd, ScheduledMailing sc, 
     SamplePop sp LEFT JOIN TOCL tl 
                    ON sp.Study_id = tl.Study_id 
                   AND sp.Pop_id = tl.Pop_id 
WHERE sm.SentMail_id = qf.SentMail_id
  AND qf.Survey_id = sd.Survey_id
  AND sd.Study_id = st.Study_id
  AND st.Client_id = cl.Client_id
  AND sm.SentMail_id = sc.SentMail_id 
  AND sc.SamplePop_id = sp.SamplePop_id 
  AND sm.strLithoCode = @strLithoCode

--Get the StudyID and SurveyID
SELECT @intStudyID = intStudyID, @intSurveyID = intSurveyID, @intCutOffFieldID = intCutOffFieldID FROM #MyData

--Get the quantity of fields
SELECT @intQtyFields = Count(*)
FROM BDUS_MetaFieldLookup
WHERE Survey_id = @intSurveyID

UPDATE #MyData
SET intQtyFields = @intQtyFields

--Determine if we are going to try to update the cut off field
IF @intCutOffFieldID IS NOT NULL
BEGIN
    IF (SELECT Count(*) FROM BDUS_MetaFieldLookup WHERE Survey_id = @intSurveyID AND Field_id = @intCutOffFieldID) > 0
    BEGIN
        UPDATE md
        SET md.strCutOffFieldName = mf.strField_Nm, md.bitCutOffFieldError = 0
        FROM #MyData md, MetaField mf
        WHERE md.intCutOffFieldID = mf.Field_id
    END
END

--Get the population data
SET @strSql = 'UPDATE md ' + Char(10) +
              'SET md.strFName = po.FName, ' + Char(10) +
              '    md.strLName = po.LName ' + Char(10) +
              'FROM #MyData md, s' + Convert(varchar, @intStudyID) + '.Population po ' + Char(10) +
              'WHERE md.intPopID = po.Pop_id'
EXEC (@strSql)

--Select the return dataset
SELECT * FROM #MyData

--Cleanup
DROP TABLE #MyData
SET NOCOUNT OFF


