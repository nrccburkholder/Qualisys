CREATE PROCEDURE sp_fgtables_cleanup_TP
AS

/*
 Create 1/23/04 SS (Test Print FGPop# cleanup routine - for records that no longer exist in PCLNeede_TP
*/

SELECT DISTINCT TP_id INTO #sp
FROM pclneeded_TP

BEGIN TRAN
	/*-------------------------------*/
	DELETE f
	FROM fgpopsection_TP f LEFT OUTER JOIN #sp sp
	ON f.TP_id = sp.TP_id 
	WHERE sp.TP_id IS NULL
		IF @@ERROR<> 0
		BEGIN
		  ROLLBACK TRANSACTION
		END
	/*-------------------------------*/
	DELETE f
	FROM fgpopcover_TP f LEFT OUTER JOIN #sp sp
	ON f.TP_id = sp.TP_id 
	WHERE sp.TP_id IS NULL
		IF @@ERROR<> 0
		BEGIN
		  ROLLBACK TRANSACTION
		END
	/*-------------------------------*/
	DELETE f
	FROM fgpopcode_TP f LEFT OUTER JOIN #sp sp
	ON f.TP_id = sp.TP_id 
	WHERE sp.TP_id IS NULL
		IF @@ERROR<> 0
		BEGIN
		  ROLLBACK TRANSACTION
		END
	/*-------------------------------*/
COMMIT TRAN

DROP TABLE #sp


