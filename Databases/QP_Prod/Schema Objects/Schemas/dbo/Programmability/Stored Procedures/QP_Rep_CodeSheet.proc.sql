--Modified 10/15/2004 BD Changed the datamart server name to a variable stored in QualPro_Params.        
--Modified 06/03/2005 BD Changed to return the same question label used by APB and eReports.        
--Modified 06/23/2005 SS Changed problem_score_flag recode to include " " (BLANK) for NULL  
--Modified 09/30/2005 DC Added a check of the custom problem score table to get custom definitions    
-- drop procedure dbo.QP_Rep_CodeSheetTest      
--Modified 09/29/09 MWB changed *= to Left outer join syntax due to sql 2008 upgrade.
CREATE PROCEDURE dbo.QP_Rep_CodeSheet      
 @Associate VARCHAR(50),      
 @Client VARCHAR(50),      
 @Study VARCHAR(50),      
 @Survey VARCHAR(50),      
 @AnalysisType VARCHAR(10)      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
DECLARE @ProcedureBegin DATETIME      
SET @ProcedureBegin=GETDATE()      
      
INSERT INTO DashBoardLog (Report, Associate, Client, Study, Survey, ProcedureBegin) SELECT 'Code Sheet', @Associate, @Client, @Study, @Survey, @ProcedureBegin      
      
DECLARE @intSurvey_id INT, @DataMartServer VARCHAR(20), @sql VARCHAR(8000), @intClient_id int      
      
SELECT @DataMartServer=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'      
      
SELECT @intSurvey_id=sd.Survey_id,  
 @intClient_id=c.client_id      
FROM Survey_def sd, Study s, Client c      
WHERE c.strClient_nm=@Client      
  AND s.strStudy_nm=@Study      
  AND sd.strSurvey_nm=@Survey      
  AND c.Client_id=s.Client_id      
  AND s.Study_id=sd.Study_id      
      
SELECT ss.qpc_id, ss.Item, ss.Val, ss.Label, ss.Missing      
INTO #MyTempTbl      
FROM sel_scls ss, (SELECT sel_scls.qpc_id, MIN(sel_scls.Item) AS Item FROM sel_scls WHERE sel_scls.Survey_id=@intSurvey_id GROUP BY qpc_id) x      
WHERE ss.qpc_id=x.qpc_id AND ss.Item=x.Item AND ss.Survey_id=@intSurvey_id      
      
CREATE TABLE #SubType (SubType int,SubType_nm CHAR(10))      
INSERT INTO #SubType (SubType,SubType_nm) ValUES (1,'Question')      
INSERT INTO #SubType (SubType,SubType_nm) ValUES (2,'SubSection')      
INSERT INTO #SubType (SubType,SubType_nm) ValUES (3,'Section')      
INSERT INTO #SubType (SubType,SubType_nm) ValUES (4,'Comment')      
      
SELECT       
  st.SubType_nm, SQ.QstnCore,SQ.Label,SQ.Scaleid, ss.Val, ss.Label AS scalelbl, ss.Missing, SQ.Section_id, SQ.SubSection, SQ.Item,       
  ss.Item AS SItem, SQ.bitmeanable AS Meanable, SQ.nummarkcount AS MultResponse, '   ' AS Problem, '   ' AS Positive      
INTO #MyTempTbl2      
FROM sel_Qstns SQ	left outer join Sel_Scls SS on SQ.Scaleid=ss.qpc_id and ss.Survey_id=@intSurvey_id 
					inner join #SubType ST on sq.SubType=st.SubType 
WHERE sq.Survey_id=@intSurvey_id      

    
UPDATE t    
SET t.Label=ql.strQstnLabel    
FROM #MyTempTbl2 t, QuestionLabel ql    
WHERE t.SubType_nm='Question'    
AND t.QstnCore=ql.QstnCore    
  
create table #lu_problem_score (qstncore int, val int, problem_score_flag int)  
  
set @sql='insert into #lu_problem_score  
   select qstncore, val, problem_score_flag  
   from '+@DataMartServer+'.qp_comments.dbo.lu_Problem_score_custom  
   where client_id=' +convert(varchar,@intClient_id)  
  
exec (@sql)  
  
set @sql='insert into #lu_problem_score  
   select qstncore, val, problem_score_flag  
   from '+@DataMartServer+'.qp_comments.dbo.lu_Problem_score  
   where qstncore not in (select distinct qstncore  
     from #lu_problem_score)'  
  
exec (@sql)  
      
UPDATE t      
SET Problem =CASE WHEN Problem_Score_Flag =-1 THEN '*' WHEN Problem_Score_Flag =1 THEN 'Yes' WHEN Problem_Score_Flag =0  THEN 'No ' WHEN Problem_Score_Flag =9 THEN 'n/a' WHEN ISNULL(Problem_Score_Flag,-99) =-99 THEN ' ' ELSE '???' END,  
    Positive=CASE WHEN Problem_Score_Flag =-1 THEN '*' WHEN Problem_Score_Flag =1 THEN 'No ' WHEN Problem_Score_Flag =0  THEN 'Yes' WHEN Problem_Score_Flag =9 THEN 'n/a' WHEN ISNULL(Problem_Score_Flag,-99) =-99 THEN ' ' ELSE '???' END    
FROM #MyTempTbl2 t left outer join #lu_problem_score PS on t.QstnCore=ps.QstnCore AND t.Val=ps.Val  
WHERE t.SubType_nm='Question'      
      
SELECT t2.QstnCore, t2.Label, t2.Scaleid, t2.Val, t2.scalelbl, t2.Missing, t2.Section_id, t2.subSection, t2.Item, t2.SubType_nm,       
t1.Item AS flag, t2.sItem AS dummy1, Meanable, MultResponse, Problem, Positive      
INTO #MyTempTbl3       
FROM #MyTempTbl2 t2 left outer join #MyTempTbl T1 on T2.Scaleid=t1.qpc_id AND t2.sItem=t1.Item
ORDER BY Section_id, subSection, t2.Item, t1.Item      
      
IF @AnalysisType='Problem'       
BEGIN      
 SELECT SubType_nm, Label, QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 (CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END) AS Meanable,       
 (CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END) AS MultResponse,      
 Problem      
 FROM #MyTempTbl3 WHERE flag IS not NULL OR Item=0 OR SubType_nm='Comment'      
 UNION       
 SELECT '' AS SubType_nm, '' AS Label, NULL AS QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END,       
 CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END,      
 Problem      
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'      
 ORDER BY Section_id,subSection,Item,dummy1      
END      
ELSE IF @AnalysisType='Positive'      
BEGIN      
 SELECT SubType_nm, Label, QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 (CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END) AS Meanable,       
 (CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END) AS MultResponse,      
 Positive      
 FROM #MyTempTbl3 WHERE flag IS not NULL OR Item=0 OR SubType_nm='Comment'      
 UNION       
 SELECT '' AS SubType_nm, '' AS Label, NULL AS QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END,       
 CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END,      
 Positive      
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'      
 ORDER BY Section_id,subSection,Item,dummy1      
END      
ELSE       
BEGIN      
 SELECT SubType_nm, Label, QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 (CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END) AS Meanable,       
 (CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END) AS MultResponse      
 FROM #MyTempTbl3 WHERE flag IS not NULL OR Item=0 OR SubType_nm='Comment'      
 UNION       
 SELECT '' AS SubType_nm, '' AS Label, NULL AS QstnCore, Val, scalelbl, Missing, Section_id, subSection, Item, dummy1,       
 CASE WHEN Meanable=0 THEN 'No'       
 WHEN meanable=1 THEN 'Yes' END,       
 CASE WHEN MultResponse=NULL THEN 'No'       
 WHEN multresponse=1 THEN 'No'       
 WHEN multresponse>1 THEN 'Yes' END      
 FROM #MyTempTbl3 WHERE flag IS NULL AND Item>0 AND SubType_nm<>'Comment'      
 ORDER BY Section_id,subSection,Item,dummy1      
END      
      
DROP TABLE #Mytemptbl      
DROP TABLE #Mytemptbl2      
DROP TABLE #Mytemptbl3      
DROP TABLE #SubType      
      
UPDATE DashBoardLog       
SET ProcedureEnd=GETDATE()      
WHERE Report='Code Sheet'      
AND Associate=@Associate      
AND Client=@Client      
AND Study=@Study      
AND Survey=@Survey      
AND ProcedureBegin=@ProcedureBegin      
AND ProcedureEnd IS NULL       
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


