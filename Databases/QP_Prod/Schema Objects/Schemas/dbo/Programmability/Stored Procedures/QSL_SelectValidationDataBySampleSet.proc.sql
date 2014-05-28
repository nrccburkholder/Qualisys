CREATE PROCEDURE [dbo].[QSL_SelectValidationDataBySampleSet]  
    @SampleSet_ID INT  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

--Collect the SampleSet data
SELECT * 
INTO #DL_Sel_Qstns_BySampleSet
FROM DL_Sel_Qstns_BySampleSet
WHERE SampleSet_id = @SampleSet_ID

SELECT * 
INTO #DL_SampleUnitSection_bySampleset
FROM DL_SampleUnitSection_bySampleset
WHERE SampleSet_id = @SampleSet_ID

--Question Data  
SELECT qf.QuestionForm_id, sq.QstnCore, sq.ScaleID, min(su.SampleUnit_id) AS SampleUnit_id  
FROM SentMailing sm, QuestionForm qf, #DL_Sel_Qstns_BySampleSet sq,   
     SamplePop sp, SelectedSample ss, #DL_SampleUnitSection_bySampleset su  
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
SELECT qf.QuestionForm_id, sq.QstnCore, sq.Label, min(su.SampleUnit_id) AS SampleUnit_id  
FROM SentMailing sm, QuestionForm qf, #DL_Sel_Qstns_BySampleSet sq,   
     SamplePop sp, SelectedSample ss, #DL_SampleUnitSection_bySampleset su  
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
GROUP BY qf.QuestionForm_id, sq.QstnCore, sq.Label  
ORDER BY qf.QuestionForm_id, sq.QstnCore, sq.Label  
  
--HandEntry Data  
SELECT qf.QuestionForm_id, sq.QstnCore, hf.Item, hf.Line_id, mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength  
FROM SentMailing sm, QuestionForm qf, #DL_Sel_Qstns_BySampleSet sq,   
     SamplePop sp, SelectedSample ss, #DL_SampleUnitSection_bySampleset su,   
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
  
--PopMapping Data  
SELECT ss.Survey_id, pm.QstnCore, mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength  
FROM SampleSet ss, QP_Scan.dbo.PopMapping pm, MetaField mf   
WHERE ss.Survey_id = pm.Survey_id
  AND pm.Field_id = mf.Field_id  
  AND ss.SampleSet_id = @SampleSet_ID  
ORDER BY ss.Survey_id, pm.QstnCore  

--Cleanup
DROP TABLE #DL_Sel_Qstns_BySampleSet
DROP TABLE #DL_SampleUnitSection_bySampleset

SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


