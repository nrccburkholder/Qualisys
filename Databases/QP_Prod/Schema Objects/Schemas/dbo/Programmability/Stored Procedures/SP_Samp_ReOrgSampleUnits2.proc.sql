/*
This procedure requires a #SampleUnits table already exist.
CREATE TABLE #SampleUnits
  (SampleUnit_id INT,
   ParentSampleUnit_id INT,
   CriteriaStmt_id INT,
   intTier INT,
   strNode VARCHAR(255),
   intTreeOrder INT,
   Survey_id INT)
*/
 
CREATE PROCEDURE SP_Samp_ReOrgSampleUnits2
  @Survey_id INT
AS 

SET NOCOUNT ON

DECLARE @strSql VARCHAR(3000)
DECLARE @Tier INT, @TreeOrder INT, @intSamplePlan_id INT

SET @Tier=0

SELECT @intSamplePlan_id=SamplePlan_id FROM SamplePlan WHERE Survey_id=@Survey_id

--First pull over the Parent Unit
INSERT INTO #SampleUnits (SampleUnit_id, ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id)
  SELECT SampleUnit_id,ParentSampleUnit_id,CriteriaStmt_id,1,CONVERT(VARCHAR,SampleUnit_id), Survey_id
  FROM SampleUnit su, SamplePlan sp 
	WHERE sp.SamplePlan_id=@intSamplePlan_id
		AND sp.SamplePlan_id=su.SamplePlan_id 
		AND ParentSampleUnit_id IS NULL

--Now to pull over the children
WHILE (@@ROWCOUNT>0)
BEGIN
  SET @Tier = @Tier + 1
  INSERT INTO #SampleUnits (SampleUnit_id, ParentSampleUnit_id, CriteriaStmt_id, intTier, strNode, Survey_id)
   SELECT su.SampleUnit_id,su.ParentSampleUnit_id,su.CriteriaStmt_id,@Tier+1,t.strNode+'.'+RIGHT('000000'+CONVERT(VARCHAR,su.SampleUnit_id),7), Survey_id
   FROM SampleUnit su, #SampleUnits t
   WHERE su.SamplePlan_id=@intSamplePlan_id
     AND su.ParentSampleUnit_id=t.SampleUnit_id 
     AND t.intTier=@Tier
END

--Determine the ordering of the tree
SET @TreeOrder=1
UPDATE #SampleUnits 
 SET intTreeOrder=@TreeOrder 
 WHERE strNode=(SELECT MIN(strNode) FROM #SampleUnits WHERE intTreeOrder IS NULL)
WHILE @@ROWCOUNT>0
BEGIN
  SET @TreeOrder=@TreeOrder+1
  UPDATE #SampleUnits 
   SET intTreeOrder=@TreeOrder 
   WHERE strNode=(SELECT MIN(strNode) FROM #SampleUnits WHERE intTreeOrder IS NULL)
END


