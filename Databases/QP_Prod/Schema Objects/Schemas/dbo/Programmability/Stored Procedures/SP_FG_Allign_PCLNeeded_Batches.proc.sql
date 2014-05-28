--Created 8/19/2 BD This procedure will make sure all generations for a given samplepop are in the same batch.
CREATE PROCEDURE SP_FG_Allign_PCLNeeded_Batches
AS

BEGIN TRAN

--First want to lock the table so additional batches cannot begin processing.
UPDATE pclneeded
SET bitdone = bitdone

IF @@ERROR <> 0
  BEGIN
	ROLLBACK TRAN
	RETURN
  END

--Identify all samplepop records that exist in more than one batch.
SELECT samplepop_id, MIN(batch_id) minbatch, MAX(batch_id) maxbatch
INTO #p
FROM pclneeded
WHERE bitdone = 0
GROUP BY samplepop_id
HAVING COUNT(*) > 1

IF @@ERROR <> 0
  BEGIN
	ROLLBACK TRAN
	RETURN
  END

--Set the batch_id to the minimun batch_id from the above query.
UPDATE p
SET p.batch_id = t.minbatch
FROM #p t, pclneeded p
WHERE p.samplepop_id = t.samplepop_id

IF @@ERROR <> 0
  BEGIN
	ROLLBACK TRAN
	RETURN
  END

DROP TABLE #p

COMMIT TRAN


