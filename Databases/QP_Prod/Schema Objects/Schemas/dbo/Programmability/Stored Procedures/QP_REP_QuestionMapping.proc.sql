CREATE PROCEDURE QP_REP_QuestionMapping   
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
DECLARE @intSurvey_id INT  
SELECT @intSurvey_id=sd.Survey_id   
FROM Survey_def sd, Study s, client c  
WHERE c.strclient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND sd.strSurvey_nm=@Survey  
  AND c.client_id=s.client_id  
  AND s.Study_id=sd.Study_id  
  
  
CREATE TABLE #SampleUnits (  
 SampleUnit_id  INT,  
 strSampleUnit_nm VARCHAR(60),  
 intTier   INT,  
 intTreeOrder  INT,  
 ParentSampleUnit_id INT,  
 intTargetReturn  INT  
)  
  
EXEC sp_SampleUnitTree @intSurvey_id  
  
CREATE TABLE #mapping (Tier INT, SampleUnit_ID INT, SampleUnit_Name VARCHAR(60), ParentSampleUnit_ID INT, Quota INT, Theme VARCHAR(60), Section_ID INT, intTreeOrder INT)  
/*  
INSERT INTO #mapping (Tier, SampleUnit_ID, SampleUnit_Name, ParentSampleUnit_id, Quota, Section_ID, intTreeOrder)  
SELECT DISTINCT intTier, su.SampleUnit_id, strSampleUnit_nm, su.ParentSampleUnit_id, su.intTargetReturn, sus.SelQstnsSection, intTreeOrder  
FROM #SampleUnits su, SampleUnitSection sus  
WHERE su.SampleUnit_id = sus.SampleUnit_id  
*/  
INSERT INTO #mapping (Tier, SampleUnit_ID, SampleUnit_Name, ParentSampleUnit_id, Quota, Section_ID, intTreeOrder)  
SELECT DISTINCT intTier, su.SampleUnit_id, strSampleUnit_nm, su.ParentSampleUnit_id, su.intTargetReturn, sus.SelQstnsSection, intTreeOrder  
FROM #SampleUnits su, SampleUnitSection sus, Sel_Qstns sq  
WHERE su.SampleUnit_id = sus.SampleUnit_id  
AND sus.SelQstnsSection=sq.Section_id  
AND sus.SelQstnsSurvey_id=sq.Survey_id  
  
UPDATE m  
SET m.Tier = su.intTier, m.ParentSAmpleUnit_id = su.ParentSampleUnit_id, m.Quota = su.intTargetReturn  
FROM #mapping m, #SampleUnits su  
WHERE m.SampleUnit_id = su.SampleUnit_id  
  
DELETE #mapping WHERE Section_id < 1  
  
UPDATE m  
SET Theme = Label  
FROM #mapping m, Sel_Qstns sq  
WHERE sq.Survey_id = @intSurvey_id  
AND sq.Section_id = m.Section_id  
AND scaleid = 0  
AND Language = 1  
AND subType = 3  
AND Label IS NOT NULL  
  
UPDATE #mapping   
SET Theme = 'No Theme Assigned'  
WHERE Theme IS NULL  

IF EXISTS (SELECT 'Question Mapping' AS SheetNameDummy, Tier, SampleUnit_ID, SampleUnit_Name, ParentSampleUnit_ID, Quota, Theme, Section_ID FROM #mapping)
		 SELECT 'Question Mapping' AS SheetNameDummy, Tier, SampleUnit_ID, SampleUnit_Name, ParentSampleUnit_ID, Quota, Theme, Section_ID FROM #mapping ORDER BY intTreeOrder  
ELSE
	SELECT 'Question Mapping' AS SheetNameDummy, '' AS Tier, '' AS SampleUnit_ID, '' AS SampleUnit_Name, '' AS ParentSampleUnit_ID, '' AS Quota, '' AS Theme, '' AS Section_ID
  
DROP TABLE #mapping  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


