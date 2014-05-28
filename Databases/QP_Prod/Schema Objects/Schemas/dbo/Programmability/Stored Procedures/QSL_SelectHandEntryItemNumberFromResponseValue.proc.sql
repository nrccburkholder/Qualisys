CREATE PROCEDURE [dbo].[QSL_SelectHandEntryItemNumberFromResponseValue]
@strLithoCode VARCHAR(10),
@QstnCore INT,
@ResponseValue INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT TOP 1 sc.Item
FROM SamplePop sp, QuestionForm qf, SentMailing sm, DL_Sel_Qstns_BySampleSet sq, 
     DL_Sel_Scls_BySampleSet sc
WHERE sp.SamplePop_id = qf.SamplePop_id
  AND qf.SentMail_id = sm.SentMail_id
  AND sp.SampleSet_id = sq.SampleSet_id
  AND qf.Survey_id = sq.Survey_id
  AND sq.SampleSet_id = sc.SampleSet_id
  AND sq.Survey_id = sc.Survey_id
  AND sq.ScaleID = sc.QPC_ID
  AND sm.strLithoCode = @strLithoCode
  AND sq.QstnCore = @QstnCore
  AND sc.Val = @ResponseValue

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


