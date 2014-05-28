/* This procedure will allows PCLGen to identify batch runs by updating the end time */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
CREATE PROCEDURE sp_pcl_endrun
 @pclgenrun_id int
AS
 UPDATE dbo.PCLGenRun
 SET end_dt = GETDATE()
 WHERE PCLGenRun_id = @pclgenrun_id


