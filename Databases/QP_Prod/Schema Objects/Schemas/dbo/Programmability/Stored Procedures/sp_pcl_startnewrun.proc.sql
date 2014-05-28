/* This procedure will allows PCLGen to identify batch runs by inserting the start record */
/* Last Modified by:  Daniel Vansteenburg - 7/14/1999 */
/* DV 7/14/99 - Removed the Transaction stuff, this procedure is already run within */
/*              a transaction from sp_pcl_startnewrun */
CREATE PROCEDURE sp_pcl_startnewrun
 @compname VARCHAR(16),
 @PCLGenRun_id int OUTPUT
AS
/* StartNewRun */
/* BEGIN TRANSACTION*/
 INSERT INTO dbo.PCLGenRun (computer_nm, start_dt)
  VALUES (@compname,GETDATE())
 if @@error <> 0
 begin
/*  ROLLBACK TRANSACTION*/
  return -1
 end
 select @PCLGenRun_id = max(pclgenrun_id)
 from dbo.PCLGenRun
/* COMMIT TRANSACTION*/
 return 0


