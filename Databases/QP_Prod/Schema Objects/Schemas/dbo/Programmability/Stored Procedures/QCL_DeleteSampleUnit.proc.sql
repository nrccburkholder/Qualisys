CREATE PROCEDURE [dbo].[QCL_DeleteSampleUnit]
@SampleUnit_id INT,
@bitCheckOnly BIT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

CREATE TABLE #M (
  Error INT, 
  strMessage VARCHAR(200)
)
CREATE TABLE #SU (
  SampleUnit_id INT, 
  strSampleUnit_nm VARCHAR(42), 
  ParentSampleUnit_id INT, 
  CriteriaStmt_id INT
)

INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, CriteriaStmt_id)
SELECT SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, CriteriaStmt_id
FROM SampleUnit
WHERE SampleUnit_id=@SampleUnit_id

WHILE @@ROWCOUNT>0
BEGIN

INSERT INTO #SU (SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, CriteriaStmt_id)
SELECT su.SampleUnit_id, su.strSampleUnit_nm, su.ParentSampleUnit_id, su.CriteriaStmt_id
FROM SampleUnit su, #SU t
WHERE t.SampleUnit_id=su.ParentSampleUnit_id
AND su.SampleUnit_id NOT IN (SELECT SampleUnit_id FROM #SU)

END

IF EXISTS (SELECT * FROM SelectedSample ss, #SU t WHERE ss.SampleUnit_id=t.SampleUnit_id)
INSERT INTO #M (Error, strMessage)
SELECT 1,'The sampleunit has been sampled.'

INSERT INTO #M (Error, strMessage)
SELECT DISTINCT 1,strSampleUnit_nm+' has questions mapped to it.'
FROM #SU t, SampleUnitSection sus
WHERE t.SampleUnit_id=sus.SampleUnit_id

IF @bitCheckOnly=1
BEGIN

  IF (SELECT COUNT(*) FROM #M)>0
    SELECT * FROM #M
  ELSE 
    SELECT 0 Error,'This sampleunit can be deleted.' strMessage
  RETURN

END
ELSE
BEGIN

  IF (SELECT COUNT(*) FROM #M)>0
  BEGIN
    SELECT Error, strMessage FROM #M
    RETURN
  END

  BEGIN TRAN

  --Delete SampleUnit
  DELETE su
  FROM SampleUnit su, #SU t
  WHERE t.SampleUnit_id=su.SampleUnit_id

  IF @@ERROR<>0
  BEGIN 
    SELECT -1, 'Error deleting SampleUnit'
    ROLLBACK TRAN
    RETURN
  END

  --Delete CriteriaInList
  DELETE cil
  FROM CriteriaInList cil, CriteriaClause cc, #SU t
  WHERE t.CriteriaStmt_id=cc.CriteriaStmt_id
  AND cc.CriteriaClause_id=cil.CriteriaClause_id

  IF @@ERROR<>0
  BEGIN 
    SELECT -1, 'Error deleting CriteriaInList'
    ROLLBACK TRAN
    RETURN
  END

  --Delete CriteriaClause
  DELETE cc
  FROM CriteriaClause cc, #SU t
  WHERE t.CriteriaStmt_id=cc.CriteriaStmt_id

  IF @@ERROR<>0
  BEGIN 
    SELECT -1, 'Error deleting CriteriaClause'
    ROLLBACK TRAN
    RETURN
  END

  --Delete CriteriaStmt
  DELETE cs
  FROM CriteriaStmt cs, #SU t
  WHERE t.CriteriaStmt_id=cs.CriteriaStmt_id

  IF @@ERROR<>0
  BEGIN 
    SELECT -1, 'Error deleting CriteriaStmt'
    ROLLBACK TRAN
    RETURN
  END

  --Delete SampleUnitTreeIndex
  DELETE suti
  FROM SampleUnitTreeIndex suti, #SU t
  WHERE t.SampleUnit_id=suti.SampleUnit_id

  IF @@ERROR<>0
  BEGIN 
    SELECT -1, 'Error deleting SampleUnitTreeIndex'
    ROLLBACK TRAN
    RETURN
  END

  COMMIT TRAN

END

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


