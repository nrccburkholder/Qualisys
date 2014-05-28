CREATE PROCEDURE dbo.QP_Rep_HandEntriesTransferred        
@Associate VARCHAR(50),        
@StartDate DATETIME,        
@EndDate DATETIME        
AS        
        
-- =======================================================    
-- Revision    
-- MWB - 1/15/09  Added ContractNumber to report for   
-- SalesLogix integration  
--
-- MWB - 3/10/09  Added AND qf.strSTRBatchNumber 
--				  not in ('OffTR', 'NewOffTr')
-- as part of new Scanner interface logic  
-- =======================================================    
  
  
SET NOCOUNT ON        
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
        
--DECLARE @StartDate DATETIME        
--DECLARE @EndDate DATETIME        
--SET @StartDate = '9/2/04'        
--SET @EndDAte = '9/3/04'        
        
        
SELECT l.datEntered, qf.datReturned, LEFT(s.strSurvey_nm, 4) AS 'ProjectNum', isnull(s.Contract, 'Missing') as ContractNumber, DATEDIFF(DAY, qf.datReturned, l.datEntered) AS 'DaysLate'        
INTO #Transferred        
FROM HandEntry_Log l, QuestionForm qf, Survey_def s        
WHERE l.QuestionForm_id = qf.QuestionForm_id        
AND qf.Survey_id = s.Survey_id        
AND l.datEntered > @StartDate        
AND l.datEntered < DATEADD(DAY, 1, @EndDate)        
AND qf.strSTRBatchNumber not in ('OffTR', 'NewOffTr')
    
CREATE TABLE #Results(dummy_id INT IDENTITY(1,1), [Project Number] VARCHAR(5),[Contract Number] Varchar(9), [Qty Transferred] INT,[Same Day] INT,[1 Day] INT,[2 Days] INT,[3 Days] INT,[4 Days] INT,[5 Days] INT,[6 Days] INT,[7 Days] INT,[8 or More] INT)    
    
        
INSERT INTO #Results([Project Number],[Contract Number], [Qty Transferred],[Same Day],[1 Day],[2 Days],[3 Days],[4 Days],[5 Days],[6 Days],[7 Days],[8 or More])        
SELECT ProjectNum AS 'Project Number', ContractNumber,          
 COUNT(*) AS 'Qty Transferred',         
 SUM(CASE WHEN DaysLate = 0 THEN 1 ELSE 0 END) AS 'Same Day',        
 SUM(CASE WHEN DaysLate = 1 THEN 1 ELSE 0 END) AS '1 Day',        
 SUM(CASE WHEN DaysLate = 2 THEN 1 ELSE 0 END) AS '2 Days',        
 SUM(CASE WHEN DaysLate = 3 THEN 1 ELSE 0 END) AS '3 Days',        
 SUM(CASE WHEN DaysLate = 4 THEN 1 ELSE 0 END) AS '4 Days',        
 SUM(CASE WHEN DaysLate = 5 THEN 1 ELSE 0 END) AS '5 Days',        
 SUM(CASE WHEN DaysLate = 6 THEN 1 ELSE 0 END) AS '6 Days',        
 SUM(CASE WHEN DaysLate = 7 THEN 1 ELSE 0 END) AS '7 Days',        
 SUM(CASE WHEN DaysLate > 7 THEN 1 ELSE 0 END) AS '8 or More'        
FROM #Transferred        
GROUP BY ProjectNum,ContractNumber        
        
INSERT INTO #Results([Project Number],[Contract Number], [Qty Transferred],[Same Day],[1 Day],[2 Days],[3 Days],[4 Days],[5 Days],[6 Days],[7 Days],[8 or More])        
SELECT 'Total' AS 'Project Number', '' as ContractNumber,        
 COUNT(*) AS 'Qty Transferred',         
 SUM(CASE WHEN DaysLate = 0 THEN 1 ELSE 0 END) AS 'Same Day',        
 SUM(CASE WHEN DaysLate = 1 THEN 1 ELSE 0 END) AS '1 Day',        
 SUM(CASE WHEN DaysLate = 2 THEN 1 ELSE 0 END) AS '2 Days',        
 SUM(CASE WHEN DaysLate = 3 THEN 1 ELSE 0 END) AS '3 Days',        
 SUM(CASE WHEN DaysLate = 4 THEN 1 ELSE 0 END) AS '4 Days',        
 SUM(CASE WHEN DaysLate = 5 THEN 1 ELSE 0 END) AS '5 Days',        
 SUM(CASE WHEN DaysLate = 6 THEN 1 ELSE 0 END) AS '6 Days',        
 SUM(CASE WHEN DaysLate = 7 THEN 1 ELSE 0 END) AS '7 Days',        
 SUM(CASE WHEN DaysLate > 7 THEN 1 ELSE 0 END) AS '8 or More'        
FROM #Transferred        
        
SELECT *        
FROM #Results        
ORDER BY dummy_id        
        
DROP TABLE #Transferred        
DROP TABLE #Results


