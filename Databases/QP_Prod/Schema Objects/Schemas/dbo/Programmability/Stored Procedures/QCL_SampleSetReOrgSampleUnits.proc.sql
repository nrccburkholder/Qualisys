/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
the hierarchical order for units that is used during the presample.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE PROCEDURE [dbo].[QCL_SampleSetReOrgSampleUnits]  
  @Survey_id INT, @bitPreSampleReport BIT=0  
AS   
  
SET NOCOUNT ON  
  
CREATE TABLE #SU  
  (strSurvey_nm VARCHAR(42),  
   SampleUnit_id INT,  
   strSampleUnit_nm VARCHAR(42),  
   ParentSampleUnit_id INT,  
   CriteriaStmt_id INT,  
   intTier INT,  
   strNode VARCHAR(255),  
   intTreeOrder INT,  
   Survey_id INT,
   intTargetReturn INT)  
  
DECLARE @strSql VARCHAR(3000)  
DECLARE @Tier INT, @TreeOrder INT, @intSamplePlan_id INT  
  
SET @Tier=0  
  
SELECT @intSamplePlan_id=SamplePlan_id FROM SamplePlan WHERE Survey_id=@Survey_id  
  
--First pull over the Parent Unit  
INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id,strSurvey_nm,intTargetReturn)  
  SELECT SampleUnit_id,su.strSampleUnit_nm,ParentSampleUnit_id,CriteriaStmt_id,1,CONVERT(VARCHAR,SampleUnit_id), sp.Survey_id,sd.strSurvey_nm,intTargetReturn
  FROM SampleUnit su, SamplePlan sp, Survey_def sd   
 WHERE sp.SamplePlan_id=@intSamplePlan_id  
  AND sp.SamplePlan_id=su.SamplePlan_id   
  AND ParentSampleUnit_id IS NULL  
  AND sp.Survey_id=sd.Survey_id  
  
--Now to pull over the children  
WHILE (@@ROWCOUNT>0)  
BEGIN  
  SET @Tier = @Tier + 1  
  INSERT INTO #SU (SampleUnit_id,strSampleUnit_nm,ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id,strSurvey_nm,intTargetReturn)  
   SELECT su.SampleUnit_id,su.strSampleUnit_nm,su.ParentSampleUnit_id,su.CriteriaStmt_id,@Tier+1,  
  t.strNode+'.'+RIGHT('000000'+CONVERT(VARCHAR,su.SampleUnit_id),7), Survey_id,strSurvey_nm,su.intTargetReturn
   FROM SampleUnit su, #SU t  
   WHERE su.SamplePlan_id=@intSamplePlan_id  
     AND su.ParentSampleUnit_id=t.SampleUnit_id   
     AND t.intTier=@Tier  
END  
  
--Determine the ordering of the tree  
SET @TreeOrder=1  
UPDATE #SU   
 SET intTreeOrder=@TreeOrder   
 WHERE strNode=(SELECT MIN(strNode) FROM #SU WHERE intTreeOrder IS NULL)  
WHILE @@ROWCOUNT>0  
BEGIN  
  SET @TreeOrder=@TreeOrder+1  
  UPDATE #SU   
   SET intTreeOrder=@TreeOrder   
   WHERE strNode=(SELECT MIN(strNode) FROM #SU WHERE intTreeOrder IS NULL)  
END  
  
IF @bitPreSampleReport=1  
 SELECT * FROM #SU  
ELSE  
 SELECT SampleUnit_id,ParentSampleUnit_id,CriteriaStmt_id,intTier,strNode,intTreeOrder,Survey_id  
 FROM #SU


