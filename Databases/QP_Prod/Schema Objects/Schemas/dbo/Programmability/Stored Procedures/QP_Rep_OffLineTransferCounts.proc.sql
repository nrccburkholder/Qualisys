CREATE PROCEDURE QP_Rep_OffLineTransferCounts    
 @Associate  VARCHAR(50),    
 @BeginDate  DATETIME,    
 @EndDate DATETIME    
    
AS    
    
-- =======================================================    
-- Revision    
-- MWB - 1/15/09  Added ContractNumber to report for   
-- SalesLogix integration  
--
-- MWB - 3/10/09  Added qf.strSTRBatchNumber in ('OFFTR', 'NewOffTR') 
-- to report as part of new Scanner interface logic  
-- =======================================================    
  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
SELECT @EndDate=DATEADD(DAY,1,@EndDate)    
    
SELECT qf.Survey_id, isnull(sd.contract, 'Missing') as ContractNumber,  COUNT(*) [Returns]    
FROM QuestionForm qf (NOLOCK), Survey_Def sd    
WHERE qf.Survey_ID = sd.Survey_ID and  
  qf.strSTRBatchNumber in ('OFFTR', 'NewOffTR') and  
  qf.datResultsImported>=@BeginDate and    
  qf.datResultsImported<@EndDate    
GROUP BY qf.Survey_id, sd.contract    
ORDER BY 1    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF


