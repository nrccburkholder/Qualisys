CREATE  PROCEDURE [dbo].[QP_Rep_SamplePlanCriteria]     
 @Associate VARCHAR(50),    
 @Client VARCHAR(50),    
 @Study VARCHAR(50),    
 @Survey VARCHAR(50)    
AS    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
DECLARE @ProcedureBegin DATETIME    
SET @ProcedureBegin = GETDATE()    
    
INSERT INTO DashBoardLog (Report, Associate, Client, Study, Survey, ProcedureBegin) SELECT 'Sample Plan Criteria Statements', @Associate, @Client, @Study, @Survey, @ProcedureBegin    
    
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
    
    
CREATE TABLE #SampleUnits    
 (SampleUnit_id INT,    
  strSampleUnit_nm VARCHAR(255),    
  intTier INT,    
  intTreeOrder INT)    
    
EXEC sp_SampleUnits @intSamplePlan_id    
      
CREATE TABLE #rpt     
  (SampleUnit_id INT,     
   CriteriaStmt_id INT,     
   ParentSampleUnit_id INT,     
   strSampleUnit_nm VARCHAR(60),     
   Tier INT,     
   Suppressed BIT,    
   dummyTreeOrder INT)    
    
INSERT INTO #rpt     
  (SampleUnit_id, Tier, strSampleUnit_nm, dummyTreeOrder)     
SELECT SampleUnit_id, intTier, strSampleUnit_nm, intTreeOrder    
FROM #SampleUnits    
     
DROP TABLE #SampleUnits    
    
UPDATE t    
SET Suppressed=su.bitSuppress    
FROM #rpt t, SampleUnit su    
WHERE t.SampleUnit_id=su.SampleUnit_id    
    
UPDATE #rpt    
  SET CriteriaStmt_id=su.CriteriaStmt_id    
  FROM SampleUnit su    
  WHERE #rpt.SampleUnit_id=su.SampleUnit_id    
    
CREATE TABLE #criters     
  (CriteriaStmt_id INT,    
  strCriteriaStmt VARCHAR(7000),    
  dummy_line INT)    
    
INSERT INTO #criters (CriteriaStmt_id)     
  SELECT DISTINCT CriteriaStmt_id FROM #rpt    
    
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
    SELECT CriteriaStmt_id,@crntLine,SUBSTRING(strCriteriaStmt,256,7000)     
    FROM #criters    
    WHERE LEN(strCriteriaStmt) > 255 AND dummy_line < @crntLine    
    
  UPDATE #criters    
  SET strCriteriaStmt = LEFT(strCriteriaStmt,255)    
  WHERE LEN(strCriteriaStmt) > 255 AND dummy_line < @crntLine    
      
  SET @crntLine = @crntLine + 1     
  SELECT @cnt=COUNT(*) FROM #criters WHERE LEN(strCriteriaStmt) > 255    
END    


IF EXISTS (    
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, CASE WHEN Suppressed=0 THEN CONVERT(VARCHAR,r.SampleUnit_id) ELSE CONVERT(VARCHAR,r.SampleUnit_id)+'(Suppressed)' END SampleUnit_id,     
	 su.INTTARGETRETURN AS Target, CASE su.NUMRESPONSERATE WHEN 0 THEN su.NumInitResponseRate ELSE su.NumResponseRate END AS ResponseRate,     
	 r.strSampleUnit_nm AS SampleUnit, CONVERT(VARCHAR(255),c.strCriteriaStmt) AS CriteriaStatement, dummyTreeOrder, dummy_line    
	FROM #rpt r, #criters c, SampleUnit su    
	WHERE r.CriteriaStmt_id=c.CriteriaStmt_id AND c.dummy_line=1 AND r.SampleUnit_id=su.SampleUnit_id    
	UNION    
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, CASE WHEN Suppressed=0 THEN CONVERT(VARCHAR,r.SampleUnit_id) ELSE CONVERT(VARCHAR,r.SampleUnit_id)+'(Suppressed)' END,     
	 su.INTTARGETRETURN AS Target, CASE su.NUMRESPONSERATE WHEN 0 THEN su.NumInitResponseRate ELSE su.NumResponseRate END AS ResponseRate,     
	 '' AS SampleUnit, CONVERT(VARCHAR(255),c.strCriteriaStmt) AS CriteriaStatement, dummyTreeOrder, dummy_line    
	FROM #rpt r, #criters c, SampleUnit su    
	WHERE r.CriteriaStmt_id=c.CriteriaStmt_id AND c.dummy_line>1 AND r.SampleUnit_id=su.SampleUnit_id    
		)

	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, CASE WHEN Suppressed=0 THEN CONVERT(VARCHAR,r.SampleUnit_id) ELSE CONVERT(VARCHAR,r.SampleUnit_id)+'(Suppressed)' END SampleUnit_id,     
	 su.INTTARGETRETURN AS Target, CASE su.NUMRESPONSERATE WHEN 0 THEN su.NumInitResponseRate ELSE su.NumResponseRate END AS ResponseRate,     
	 r.strSampleUnit_nm AS SampleUnit, CONVERT(VARCHAR(255),c.strCriteriaStmt) AS CriteriaStatement, dummyTreeOrder, dummy_line    
	FROM #rpt r, #criters c, SampleUnit su    
	WHERE r.CriteriaStmt_id=c.CriteriaStmt_id AND c.dummy_line=1 AND r.SampleUnit_id=su.SampleUnit_id    
	UNION    
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, CASE WHEN Suppressed=0 THEN CONVERT(VARCHAR,r.SampleUnit_id) ELSE CONVERT(VARCHAR,r.SampleUnit_id)+'(Suppressed)' END,     
	 su.INTTARGETRETURN AS Target, CASE su.NUMRESPONSERATE WHEN 0 THEN su.NumInitResponseRate ELSE su.NumResponseRate END AS ResponseRate,     
	 '' AS SampleUnit, CONVERT(VARCHAR(255),c.strCriteriaStmt) AS CriteriaStatement, dummyTreeOrder, dummy_line    
	FROM #rpt r, #criters c, SampleUnit su    
	WHERE r.CriteriaStmt_id=c.CriteriaStmt_id AND c.dummy_line>1 AND r.SampleUnit_id=su.SampleUnit_id    
	ORDER BY r.dummyTreeOrder, dummy_line    
ELSE 
	SELECT 'Sample Plan Criteria Statements' AS SheetNameDummy, '' AS SampleUnit_id, '' AS Target, '' AS ResponseRate, '' AS SampleUnit, '' AS CriteriaStatement, '' AS dummyTreeOrder, '' AS dummy_line    
    
DROP TABLE #criters    
DROP TABLE #rpt    
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


