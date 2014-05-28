--Script to update all reports indicated by Lynn blaney to include new 
--Contract Number field located in Survey_Def table.
--Script created 1/15/09

CREATE PROCEDURE QP_Rep_ChildrensRoyaltiesOP @BeginDate DATETIME, @EndDate DATETIME    
AS    

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  

    
CREATE TABLE #su (SampleUnit_id INT)    
    
INSERT INTO #su    
EXEC QP_REP_QuestionsByUnits '11374,12903,12904,12905,12906,12907,12908,12909,12910,12911,11375,11376,11377,11378,11431,11386,11392,11406,11388,11394,11415,11421,11422,11405,11402,11403,11384,11390,11420,11391,11393,11396,11397,11385,11389,11387,11379,11380,11383,11417,11418,11419,11416,11404,11395,11381,11382,11398,11399,11400,11401,11407,11408,11409,11410,11411,11412,11413,11414'    
    
SELECT Survey_id, SUM(inttargetreturn) target, COUNT(*) SampleUnits    
INTO #opSurvey    
FROM SampleUnit su, SamplePlan sp, #su t    
WHERE su.SampleUnit_id=t.SampleUnit_id    
AND su.SamplePlan_id=sp.SamplePlan_id    
GROUP BY Survey_id    
    
SELECT qf.SamplePop_id, sset.Survey_id, strSampleSurvey_nm, MAX(datMailed) LastMailed, CONVERT(INT,0) Returned    
INTO #opcount    
FROM SelectedSample ss(NOLOCK), SampleSet sset(NOLOCK), SamplePop sp(NOLOCK), QuestionForm qf(NOLOCK), SentMailing sm(NOLOCK), #su t    
WHERE ss.SampleUnit_id=t.SampleUnit_id    
AND ss.SampleSet_id=sset.SampleSet_id    
AND ss.SampleSet_id=sp.SampleSet_id    
AND ss.Pop_id=sp.Pop_id    
AND sp.SamplePop_id=qf.SamplePop_id    
AND qf.SentMail_id=sm.SentMail_id    
AND datMailed BETWEEN @BeginDate AND @EndDate    
GROUP BY qf.SamplePop_id, sset.Survey_id, strSampleSurvey_nm    
    
UPDATE t    
set t.Returned=1    
FROM #opcount t, QuestionForm qf(NOLOCK)    
WHERE t.SamplePop_id=qf.SamplePop_id    
AND qf.datReturned>'1/1/1900'    
    
SELECT Survey_id, strSampleSurvey_nm, MAX(LastMailed) LastMailed, COUNT(*) Outgo, SUM(Returned) Returned    
INTO #op    
FROM #opcount    
GROUP BY Survey_id, strSampleSurvey_nm    
    
SELECT c.strClient_nm [OP Client], isnull(sd.contract, 'Missing') as ContractNumber, t.Survey_id,  strSampleSurvey_nm, LastMailed, OutGo, Returned, SampleUnits, Target, strMailFreq, intSamplesinPeriod, COUNT(*) NumQuestions     
FROM #op t, #opSurvey ts, Survey_def sd(NOLOCK), Study s(NOLOCK), Client c(NOLOCK), Sel_Qstns sq(NOLOCK)    
WHERE t.Survey_id=ts.Survey_id    
AND t.Survey_id=sd.Survey_id    
AND sd.Study_id=s.Study_id    
AND s.Client_id=c.Client_id   
AND sd.Survey_id=sq.Survey_id   
AND sq.SubType=1  
AND sq.Language=1  
AND sq.QstnCore IN (11374,12903,12904,12905,12906,12907,12908,12909,12910,12911,11375,11376,11377,11378,11431,11386,  
 11392,11406,11388,11394,11415,11421,11422,11405,11402,11403,11384,11390,11420,11391,11393,11396,11397,11385,11389,  
 11387,11379,11380,11383,11417,11418,11419,11416,11404,11395,11381,11382,11398,11399,11400,11401,11407,11408,11409,  
 11410,11411,11412,11413,11414)  
GROUP BY c.strClient_nm, sd.contract, t.Survey_id, strSampleSurvey_nm, LastMailed, OutGo, Returned, SampleUnits, Target, strMailFreq, intSamplesinPeriod  
ORDER BY c.strClient_nm,t.Survey_id, strSampleSurvey_nm


