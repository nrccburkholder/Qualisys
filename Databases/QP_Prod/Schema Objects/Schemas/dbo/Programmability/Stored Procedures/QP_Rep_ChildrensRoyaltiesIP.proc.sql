--=============================================

CREATE PROCEDURE QP_Rep_ChildrensRoyaltiesIP @BeginDate DATETIME, @EndDate DATETIME    
AS    

-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  
    
CREATE TABLE #su (SampleUnit_id INT)    
    
INSERT INTO #su    
EXEC QP_REP_QuestionsByUnits2 '8087,8089,8090,8093,8106,8107,8113,12990,8102,8096,8110,9130,8094,8100,8112,8114,8115,8116,8117,8133,8134,8135,8136,8137,8138,8139,8140,8146,8095,8101,8097,8103,8108,8109,12991,9296,9297,12992,12993,8142,9118,9119,8145,8143,
  
8131,8119,8120,8121,8122,8123,8130,8132,9298,9299,9300,9301,9302,16373,16374,19916,19073,16573,19083,19086'    
    
SELECT Survey_id, SUM(intTargetReturn) Target, COUNT(*) SampleUnits    
INTO #ipSurvey    
FROM SampleUnit su(NOLOCK), SamplePlan sp(NOLOCK), #su t    
WHERE su.SampleUnit_id=t.SampleUnit_id    
AND su.SamplePlan_id=sp.SamplePlan_id    
GROUP BY Survey_id    
    
SELECT qf.SamplePop_id, sset.Survey_id, strSampleSurvey_nm, MAX(datMailed) LastMailed, CONVERT(INT,0) Returned    
INTO #ipcount    
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
SET t.Returned=1    
FROM #ipcount t, QuestionForm qf(NOLOCK)    
WHERE t.SamplePop_id=qf.SamplePop_id    
AND qf.datReturned>'1/1/1900'    
    
SELECT Survey_id, strSampleSurvey_nm, MAX(LastMailed) LastMailed, COUNT(*) Outgo, SUM(Returned) Returned    
INTO #ip    
FROM #ipcount    
GROUP BY Survey_id, strSampleSurvey_nm    
    
SELECT c.strClient_nm [IP Client], isnull(sd.contract, 'Missing') as ContractNumber, t.Survey_id, strSampleSurvey_nm, LastMailed, OutGo, Returned, SampleUnits, Target, strMailFreq, intSamplesinPeriod, COUNT(*) NumQuestions     
FROM #ip t, #ipSurvey ts, Survey_def sd(NOLOCK), Study s(NOLOCK), Client c(NOLOCK), Sel_Qstns sq (NOLOCK)  
WHERE t.Survey_id=ts.Survey_id    
AND t.Survey_id=sd.Survey_id    
AND sd.Study_id=s.Study_id    
AND s.Client_id=c.Client_id   
AND sd.Survey_id=sq.Survey_id  
AND sq.SubType=1  
AND sq.Language=1  
AND sq.QstnCore IN (8087,8089,8090,8093,8106,8107,8113,12990,8102,8096,8110,9130,8094,8100,8112,8114,8115,8116,  
 8117,8133,8134,8135,8136,8137,8138,8139,8140,8146,8095,8101,8097,8103,8108,8109,12991,9296,9297,12992,12993,  
 8142,9118,9119,8145,8143,8131,8119,8120,8121,8122,8123,8130,8132,9298,9299,9300,9301,9302,16373,16374,19916,  
 19073,16573,19083,19086)  
GROUP BY c.strClient_nm, sd.contract, t.Survey_id, strSampleSurvey_nm, LastMailed, OutGo, Returned, SampleUnits, Target, strMailFreq, intSamplesinPeriod  
ORDER BY c.strClient_nm, t.Survey_id, strSampleSurvey_nm


