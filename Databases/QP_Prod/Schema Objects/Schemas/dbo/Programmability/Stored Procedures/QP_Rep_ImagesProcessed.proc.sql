--===================================================================


CREATE PROCEDURE QP_Rep_ImagesProcessed    
@Associate VARCHAR(50),    
@StartDate DATETIME,    
@EndDate DATETIME    
AS    
  
-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON   
  
SELECT isnull(sd.Contract, 'Missing') as ContractNumber, LEFT(sd.strSurvey_nm,4) as Project, qf.QuestionForm_id, ps.PaperSize_nm PaperSize, COUNT(*) Pages,   
     CASE WHEN PaperSize_nm='8.5x11' THEN COUNT(*)*2   
          WHEN PaperSize_nm='8.5x14' THEN COUNT(*)*2   
          WHEN PaperSize_nm='11x17' THEN COUNT(*)*4 END Images    
INTO #Images    
FROM QuestionForm qf, SentMailing sm, PaperConfig pc, PaperConfigSheet pcs, PaperSize ps, Survey_def sd    
WHERE qf.SentMail_id=sm.SentMail_id    
AND sm.PaperConfig_id=pc.PaperConfig_id    
AND pc.PaperConfig_id=pcs.PaperConfig_id    
AND pcs.PaperSize_id=ps.PaperSize_id    
AND qf.Survey_id=sd.Survey_id    
AND qf.datReturned>@StartDate    
AND qf.datReturned<DATEADD(DAY,1,@EndDate)    
GROUP BY sd.Contract, LEFT(sd.strSurvey_nm,4), qf.QuestionForm_id, ps.PaperSize_nm    
    
SELECT ContractNumber, Project, PaperSize, COUNT(*) Surveys, SUM(pages) Pages, SUM(images) Images    
INTO #results    
FROM #images    
GROUP BY ContractNumber, Project, PaperSize    
ORDER BY ContractNumber, project, PaperSize    
    
SELECT * FROM #results    
UNION ALL    
SELECT '', '           ','Total       ',SUM(Surveys),SUM(pages),SUM(Images) FROM #results    
    
DROP TABLE #images    
DROP TABLE #results    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


