CREATE PROCEDURE SP_SYS_RollbackCleanupLoop
AS

SELECT Rollback_id
INTO #r
FROM Generation_Rollbacks
WHERE datRollback_Start<DATEADD(MONTH,-2,GETDATE())
AND datRecoveryDeleted IS NULL

DECLARE @r INT

SELECT TOP 1 @r=Rollback_id FROM #r

WHILE @@ROWCOUNT>0
BEGIN

EXEC SP_SYS_RollbackCleanup @r

UPDATE Generation_Rollbacks SET datRecoveryDeleted=GETDATE() WHERE Rollback_id=@r

DELETE #r WHERE Rollback_id=@r

SELECT TOP 1 @r=Rollback_id FROM #r

END

DROP TABLE #r


