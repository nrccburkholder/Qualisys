--MODIFIED 1/27/4 BD Added Language=1 to the population of #MyTempTbl2  
--MODIFIED 2/7/5 BD Added Report Text to the output.  
--MODIFIED 6/3/5 BD Changed to return the same question label used by APB and eReports.  
--MODIFIED 10/4/5 DC Changed to incorporate custom problem score definitions    
CREATE  PROCEDURE dbo.QP_REP_Questionnaire   
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50),    
 @Survey VARCHAR(50),    
 @AnalysisType VARCHAR(10)    
AS    
    
SET NOCOUNT ON    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
DECLARE @intSurvey_id int, @intClient_id int    
SELECT @intSurvey_id=sd.Survey_id,
	@intClient_id=c.client_id     
FROM Survey_def sd, Study s, Client c    
WHERE c.strClient_nm=@Client    
  AND s.strStudy_nm=@Study    
  AND sd.strSurvey_nm=@Survey    
  AND c.Client_id=s.Client_id    
  AND s.Study_id=sd.Study_id    
    
SELECT ss.QPC_id, ss.Item, ss.Val, ss.Label, ss.Missing    
INTO #MyTempTbl    
FROM Sel_Scls ss, (SELECT Sel_Scls.QPC_id, MIN(Sel_Scls.Item) AS Item FROM Sel_Scls WHERE Sel_Scls.Survey_id=@intSurvey_id GROUP BY QPC_id) x    
WHERE ss.QPC_id=x.QPC_id AND ss.Item=x.Item AND ss.Survey_id=@intSurvey_id    
    
CREATE TABLE #SubType (SubType int,SubType_nm char(10))    
INSERT INTO #SubType (SubType,SubType_nm) ValUES (1,'Question')    
INSERT INTO #SubType (SubType,SubType_nm) ValUES (2,'SubSection')    
INSERT INTO #SubType (SubType,SubType_nm) ValUES (3,'Section')    
INSERT INTO #SubType (SubType,SubType_nm) ValUES (4,'Comment')    
    
SELECT     
  st.SubType_nm, SQ.QstnCore,SQ.strFullQuestion Label, SQ.Label ReportText, SQ.Scaleid, ss.Val, ss.Label AS ScaleLbl, ss.Missing, SQ.Section_id, SQ.SubSection, SQ.Item,     
  ss.Item AS SItem, SQ.bitMeanable AS Meanable, SQ.numMarkCount AS MultResponse, '   ' AS Problem, '   ' AS Positive    
INTO #MyTempTbl2    
FROM Sel_Qstns SQ 
		left outer join Sel_Scls SS on SQ.Scaleid=ss.QPC_id AND ss.Language=1 and ss.Survey_id=@intSurvey_id  
		inner join #SubType ST on sq.SubType=st.SubType
WHERE sq.Survey_id=@intSurvey_id    
--Begin of addition BD 1/27/4  
  AND sq.Language=1  
--End of addition BD 1/27/4  


    
UPDATE t  
SET t.ReportText=ql.strQstnLabel  
FROM #MyTempTbl2 t, QuestionLabel ql  
WHERE t.SubType_nm='Question'  
AND t.QstnCore=ql.QstnCore 

create table #lu_problem_score (qstncore int, val int, problem_score_flag int)

insert into #lu_problem_score
	  select qstncore, val, problem_score_flag
	  from Datamart.qp_comments.dbo.lu_Problem_score_custom
	  where client_id=@intClient_id

insert into #lu_problem_score
	  select qstncore, val, problem_score_flag
	  from Datamart.qp_comments.dbo.lu_Problem_score
	  where qstncore not in (select distinct qstncore
					from #lu_problem_score)
  
UPDATE t    
SET Problem =CASE WHEN Problem_Score_Flag =-1 THEN '*' WHEN Problem_Score_Flag =1 THEN 'Yes' WHEN Problem_Score_Flag =0  THEN 'No ' WHEN Problem_Score_Flag =9 THEN 'n/a' WHEN ISNULL(Problem_Score_Flag,-99) =-99 THEN ' ' ELSE '???' END,
    Positive=CASE WHEN Problem_Score_Flag =-1 THEN '*' WHEN Problem_Score_Flag =1 THEN 'No ' WHEN Problem_Score_Flag =0  THEN 'Yes' WHEN Problem_Score_Flag =9 THEN 'n/a' WHEN ISNULL(Problem_Score_Flag,-99) =-99 THEN ' ' ELSE '???' END  
FROM #MyTempTbl2 t left outer join #lu_problem_score PS on t.QstnCore=ps.QstnCore AND t.Val=ps.Val      
WHERE t.SubType_nm='Question'    
 
    
SELECT t2.QstnCore, t2.Label, t2.ReportText, t2.Scaleid, t2.Val, t2.ScaleLbl, t2.Missing, t2.Section_id, t2.subSection, t2.Item, t2.SubType_nm,     
t1.Item AS flag, t2.sItem AS dummy1, Meanable, MultResponse, Problem, Positive    
INTO #MyTempTbl3     
FROM #MyTempTbl2 t2 left outer join #MyTempTbl T1 on T2.Scaleid=t1.QPC_id AND t2.sItem=t1.Item
ORDER BY Section_id, subSection, t2.Item, t1.Item    
    
IF @AnalysisType='Problem'     
BEGIN    
 SELECT SubType_nm, Label, ReportText, QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 (CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END) AS Meanable,     
 (CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END) AS MultResponse,    
 Problem    
 FROM #MyTempTbl3 WHERE flag IS NOT NULL OR Item=0 OR SubType_nm='Comment'    
 UNION     
 SELECT '' AS SubType_nm, '' AS Label, '' AS ReportText, NULL AS QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END,     
 CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END,    
 Problem    
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'    
 ORDER BY Section_id,subSection,Item,dummy1    
END    
ELSE IF @AnalysisType='Positive'    
BEGIN    
 SELECT SubType_nm, Label, ReportText, QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 (CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END) AS Meanable,     
 (CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END) AS MultResponse,    
 Positive    
 FROM #MyTempTbl3 WHERE flag IS NOT NULL OR Item=0 OR SubType_nm='Comment'    
 UNION     
 SELECT '' AS SubType_nm, '' AS Label, '' AS ReportText, NULL AS QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END,     
 CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END,    
 Positive    
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'    
 ORDER BY Section_id,subSection,Item,dummy1    
END    
ELSE     
BEGIN    
 SELECT SubType_nm, Label, ReportText, QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 (CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END) AS Meanable,     
 (CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END) AS MultResponse    
 FROM #MyTempTbl3 WHERE flag IS NOT NULL OR Item=0 OR SubType_nm='Comment'    
 UNION     
 SELECT '' AS SubType_nm, '' AS Label, '' AS ReportText, NULL AS QstnCore, Val, ScaleLbl, Missing, Section_id, subSection, Item, dummy1,     
 CASE WHEN Meanable = 0 THEN 'NO'     
 WHEN meanable = 1 THEN 'Yes' END,     
 CASE WHEN MultResponse = NULL THEN 'No'     
 WHEN MultResponse = 1 THEN 'No'     
 WHEN MultResponse > 1 THEN 'Yes' END    
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'    
 ORDER BY Section_id,subSection,Item,dummy1    
END    
    
DROP TABLE #Mytemptbl    
DROP TABLE #Mytemptbl2    
DROP TABLE #Mytemptbl3    
DROP TABLE #SubType    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
    
SET NOCOUNT OFF


