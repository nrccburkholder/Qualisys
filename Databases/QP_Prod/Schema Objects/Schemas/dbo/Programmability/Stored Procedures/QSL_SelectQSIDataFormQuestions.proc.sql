CREATE PROCEDURE [dbo].[QSL_SelectQSIDataFormQuestions]
    @QuestionFormID INT,
    @SurveyID       INT, 
    @LangID         INT
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @InDebug BIT
SET @InDebug = 0

--Create required temp tables
CREATE TABLE #Bubble (QstnCore INT, SampleUnit_id INT, intPage_Num INT, intBegColumn INT, 
                      intRespCol INT, ReadMethod_id INT, Item INT, Val INT)

CREATE TABLE #Questions (QstnCore INT, QuestionText VARCHAR(60), ScaleID INT, Section INT, SubSection INT, SubSectionOrder INT)

CREATE TABLE #Scales (ScaleID INT, Item INT, ScaleItemText VARCHAR(60), ScaleOrder INT)

--Get the bubble data for this survey
INSERT INTO #Bubble(QstnCore, SampleUnit_id, intPage_Num, intBegColumn, intRespCol, ReadMethod_id, Item, Val)
SELECT bp.QstnCore, bp.SampleUnit_id, bp.intPage_Num, bp.intBegColumn, bp.intRespCol, bp.ReadMethod_id, bi.Item, bi.Val
FROM QP_Scan.dbo.BubblePos bp INNER JOIN QP_Scan.dbo.BubbleItemPos bi 
                                      ON bp.intPage_Num = bi.intPage_Num 
                                     AND bp.QuestionForm_ID = bi.QuestionForm_ID 
                                     AND bp.SampleUnit_ID = bi.SampleUnit_ID 
                                     AND bp.QstnCore = bi.QstnCore
WHERE bp.ReadMethod_id > 0
  AND bp.QuestionForm_id = @QuestionFormID
ORDER BY bp.intPage_Num, bp.intBegColumn

IF @InDebug = 1
    SELECT * FROM #Bubble ORDER BY intPage_Num, intBegColumn

--Get the question info for this survey
INSERT INTO #Questions (QstnCore, QuestionText, ScaleID, Section, SubSection, SubSectionOrder)
SELECT QstnCore, Label, ScaleID, Section_ID, SubSection, Item
FROM Sel_Qstns
WHERE Survey_ID = @SurveyID
  AND [Language] = @LangID
  AND SubType = 1

IF @InDebug = 1
    SELECT * FROM #Questions ORDER BY QstnCore

--Get the scale info for this survey
INSERT INTO #Scales (ScaleID, Item, ScaleItemText, ScaleOrder)
SELECT QPC_ID, Item, Label, ScaleOrder
FROM Sel_Scls
WHERE Survey_ID = @SurveyID
  AND [Language] = @LangID

IF @InDebug = 1
    SELECT * FROM #Scales ORDER BY ScaleID, ScaleOrder

--Get the resultset
SELECT bb.QstnCore, bb.SampleUnit_id, bb.intPage_Num, bb.intBegColumn, bb.intRespCol, bb.ReadMethod_id, 
       bb.Item, bb.Val, qs.QuestionText, sc.ScaleItemText, qs.Section, qs.SubSection, qs.SubSectionOrder, sc.ScaleOrder
FROM #Bubble bb LEFT JOIN #Questions qs
                       ON bb.QstnCore = qs.QstnCore
                LEFT JOIN #Scales sc
                       ON qs.ScaleID = sc.ScaleID
                      AND bb.Item = sc.Item
ORDER BY qs.Section, qs.SubSection, qs.SubSectionOrder, sc.ScaleOrder, bb.intPage_Num, bb.intBegColumn

--Cleanup 
DROP TABLE #Bubble
DROP TABLE #Questions
DROP TABLE #Scales

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


