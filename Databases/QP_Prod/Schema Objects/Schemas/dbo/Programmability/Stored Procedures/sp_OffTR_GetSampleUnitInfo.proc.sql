CREATE PROCEDURE sp_OffTR_GetSampleUnitInfo   
    @intQstnCore       int,  -- Remove this parameter when the second query is used.  
    @intQuestionFormID int  
  
AS  
  
SELECT ss.SampleUnit_id, Count(*) AS QtyRec   
FROM SamplePop sp, SelectedSample ss, (
			SELECT DISTINCT qf.Survey_id, SamplePop_id, Section_id 
			FROM QuestionForm qf, Sel_Qstns sq 
			WHERE qf.Questionform_id=@intQuestionFormID 
			AND qf.Survey_id=sq.Survey_id 
			AND sq.QstnCore=@intQstnCore 
			AND SubType=1) a,   
     SampleUnitSection su   
WHERE sp.Study_id = ss.Study_id   
  AND sp.SampleSet_id = ss.SampleSet_id   
  AND sp.Pop_id = ss.Pop_id   
  AND sp.SamplePop_id = a.SamplePop_id   
  AND a.Section_id = su.SelQstnsSection   
  AND a.Survey_id = su.SelQstnsSurvey_id   
  AND su.SampleUnit_id = ss.SampleUnit_id   
GROUP BY ss.SampleUnit_id


