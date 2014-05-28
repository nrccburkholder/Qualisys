/***********************************************************************************************************************************    
SP Name: QP_Rep_DQCriteria     
Purpose:  returns the list of business rules and their criteria clauses for a Survey    
Input:      
  @Associate    
  @Client    
  @Study     
  @Survey     
Output:      
  recordset containing    
 Rule_id     
 RuleType    
 Rule    
 CriteriaStatement    
    
Creation Date: April 11, 2000    
Author(s): DG    
Revision:     
v2.0.1 - 4/12/2000 - Dave Gilsdorf    
  changed it from returning just DQRules to returning all business rules.    
***********************************************************************************************************************************/    
CREATE PROCEDURE [dbo].[QP_Rep_DQCriteria]     
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50),    
 @Survey VARCHAR(50)    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
DECLARE @intSurvey_id INT, @intSamplePlan_id INT    
SELECT @intSurvey_id=sd.Survey_id     
FROM Survey_def sd, Study s, Client c    
WHERE c.strClient_nm=@Client    
  AND s.strStudy_nm=@Study    
  AND sd.strSurvey_nm=@Survey    
  AND c.Client_id=s.Client_id    
  AND s.Study_id=sd.Study_id    
    
SELECT @intSamplePlan_id=SamplePlan_id     
FROM SamplePlan     
WHERE Survey_id=@intSurvey_id    
    
CREATE TABLE #criters     
  (CriteriaStmt_id INT,    
  strCriteriaStmt VARCHAR(2550),    
  dummy_line INT)    
    
INSERT INTO #criters (CriteriaStmt_id)     
  SELECT CriteriaStmt_id FROM BusinessRule WHERE Survey_id=@intSurvey_id    
    
--This query replaces the following procedure  
UPDATE c  
SET c.strCriteriaStmt=case
						when SUBSTRING(cs.strCriteriaString,1,2)='((' then SUBSTRING(cs.strCriteriaString,2,(DATALENGTH(cs.strCriteriaString)-2)) 
						else cs.strCriteriaString
						end  
FROM #criters c, CriteriaStmt cs  
WHERE c.CriteriaStmt_id=cs.CriteriaStmt_id  
  
--EXEC sp_CriteriaStatements    
  
UPDATE #criters SET dummy_line=1    
    
DECLARE @crntLine INT, @cnt INT    
SET @crntLine=2    
SELECT @cnt=COUNT(*) FROM #criters WHERE LEN(strCriteriaStmt) > 255    
WHILE @cnt > 0     
BEGIN    
  INSERT INTO #criters (CriteriaStmt_id,dummy_line,strCriteriaStmt)    
    SELECT CriteriaStmt_id,@crntLine,SUBSTRING(strCriteriaStmt,256,2550)     
    FROM #criters    
    WHERE LEN(strCriteriaStmt) > 255 AND dummy_line < @crntLine    
    
  UPDATE #criters    
  SET strCriteriaStmt = LEFT(strCriteriaStmt,255)    
  WHERE LEN(strCriteriaStmt) > 255 AND dummy_line < @crntLine    
      
  SET @crntLine = @crntLine + 1     
  SELECT @cnt=COUNT(*) FROM #criters WHERE LEN(strCriteriaStmt) > 255    
END    
    

IF EXISTS (
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, br.BUSINESSRULE_ID AS Rule_id, br.busrule_cd [RuleType], NULL AS [_], cs.strcriteriastmt_nm AS [Rule], CONVERT(VARCHAR(255),c.strcriteriastmt) AS CriteriaStatement, c.dummy_line    
	FROM criteriastmt cs, #criters c, businessrule br    
	WHERE cs.criteriastmt_id=c.criteriastmt_id AND c.dummy_line=1 AND br.criteriastmt_id=cs.criteriastmt_id    
	UNION    
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, br.BUSINESSRULE_ID AS Rule_id, br.busrule_cd [RuleType], NULL AS [_], '' AS [Rule], CONVERT(VARCHAR(255),c.strcriteriastmt) AS CriteriaStatement, c.dummy_line    
	FROM criteriastmt cs, #criters c, businessrule br    
	WHERE cs.criteriastmt_id=c.criteriastmt_id AND c.dummy_line>1 AND br.criteriastmt_id=cs.criteriastmt_id    
		)

	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, br.BUSINESSRULE_ID AS Rule_id, br.busrule_cd [RuleType], NULL AS [_], cs.strcriteriastmt_nm AS [Rule], CONVERT(VARCHAR(255),c.strcriteriastmt) AS CriteriaStatement, c.dummy_line    
	FROM criteriastmt cs, #criters c, businessrule br    
	WHERE cs.criteriastmt_id=c.criteriastmt_id AND c.dummy_line=1 AND br.criteriastmt_id=cs.criteriastmt_id    
	UNION    
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, br.BUSINESSRULE_ID AS Rule_id, br.busrule_cd [RuleType], NULL AS [_], '' AS [Rule], CONVERT(VARCHAR(255),c.strcriteriastmt) AS CriteriaStatement, c.dummy_line    
	FROM criteriastmt cs, #criters c, businessrule br    
	WHERE cs.criteriastmt_id=c.criteriastmt_id AND c.dummy_line>1 AND br.criteriastmt_id=cs.criteriastmt_id    
	ORDER BY br.BUSINESSRULE_ID, c.dummy_line    
ELSE
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, '' AS Rule_id, '' [RuleType], '' [_], '' AS [Rule], '' AS CriteriaStatement, '' AS dummy_line    

    
UPDATE dashboardlog     
SET procedureend = GETDATE()    
WHERE report = 'Sample Plan Criteria Statements'    
AND Associate = @Associate    
AND Client = @Client    
AND Study = @Study    
AND Survey = @Survey    
AND procedureend IS NULL    
    
DROP TABLE #criters    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


