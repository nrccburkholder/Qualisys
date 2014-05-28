CREATE PROCEDURE dbo.sp_SampleUnitTree
  @intSurvey_id INT, @IndentSize INT = 2
AS 
DECLARE @Tier INT, @Indent VARCHAR(100)
SET @Tier=0
SET @Indent=''

CREATE TABLE #SU
 (SampleUnit_id INT,
  strSampleUnit_nm VARCHAR(255),
  intTier INT,
  strNode VARCHAR(255),
  intTreeOrder INT,
  ParentSampleUnit_id INT,
  intTargetReturn INT)

INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode, ParentSampleUnit_id, intTargetReturn)
  SELECT SampleUnit_id,strSampleUnit_nm,1,CONVERT(VARCHAR,SampleUnit_id),ParentSampleUnit_id,intTargetReturn
  FROM SampleUnit su, SamplePlan sp 
	WHERE Survey_id=@intSurvey_id 
	AND ParentSampleUnit_id  IS NULL
	AND sp.SamplePlan_id = su.SamplePlan_id

WHILE (@@ROWCOUNT > 0)
BEGIN
  SET @Tier = @Tier + 1
  SET @Indent=@Indent + REPLICATE(CHAR(160),@IndentSize)
  INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode, ParentSampleUnit_id, intTargetReturn)
   SELECT su.SampleUnit_id,@Indent+su.strSampleUnit_nm,@Tier+1,t.strNode+'.'+RIGHT('000000'+CONVERT(VARCHAR,su.SampleUnit_id),7),su.ParentSampleUnit_id,su.intTargetReturn
   FROM SampleUnit su, SamplePlan sp, #SU t
   WHERE sp.Survey_id=@intSurvey_id
     AND sp.SamplePlan_id = su.SamplePlan_id
     AND su.ParentSampleUnit_id = t.SampleUnit_id 
     AND t.intTier=@Tier
end

DECLARE @treeorder INT
SET @treeorder = 1
UPDATE #SU 
 SET intTreeOrder = @treeorder 
 WHERE strNode = (SELECT MIN(strNode) FROM #su WHERE intTreeOrder IS NULL)
WHILE @@ROWCOUNT > 0
BEGIN
  SET @treeorder = @treeorder + 1
  UPDATE #SU 
   set intTreeOrder = @treeorder 
   WHERE strNode = (SELECT MIN(strNode) FROM #su WHERE intTreeOrder IS NULL)
END

INSERT INTO #SampleUnits (SampleUnit_id,strSampleUnit_nm,intTier,intTreeOrder,ParentSampleUnit_id,intTargetReturn)
  SELECT SampleUnit_id,strSampleUnit_nm,intTier,intTreeOrder,ParentSampleUnit_id,intTargetReturn
  FROM #SU
  ORDER BY strNode

DROP TABLE #SU


