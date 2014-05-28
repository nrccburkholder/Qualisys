/* This procedure gets the next batch_id for PCLGen to run, and updates the appropriate tables         */
/* DG 12/6/02 - This is the same code as sp_pcl_nextbatch, except it doesn't check PCLGenStartTime     */
/*              or PCLGenStopTime.  It's used when trying to figure out why a questionnaire won't gen. */

CREATE PROCEDURE dbo.sp_pcl_nextbatch_always
 @compname varchar(16)
AS
 declare @nextbatch int, @pclgenrun_id int, @rc int, @err int
 BEGIN TRANSACTION
 update dbo.pcllocks set lockdate = getdate()
 if @@error <> 0
 begin
    ROLLBACK TRANSACTION
    return
 end

 select top 1 @nextbatch = batch_id
 from dbo.PCLNeeded
 where bitDone = 0
 and batch_id >= 0
 order by priority_flg, batch_id
 if @@error <> 0
 begin
    ROLLBACK TRANSACTION
    return
 end

 if @nextbatch >= 0
 begin
    update dbo.PCLNeeded
    set bitdone=1
    where batch_id = @nextbatch
    if @@error <> 0
    begin
     ROLLBACK TRANSACTION
     return
    end
 
    exec @rc=dbo.sp_pcl_startnewrun @compname=@compname, @PCLGenRun_id=@pclgenrun_id OUTPUT
    select @err=@@error
    if @err <> 0 or @rc < 0 or @PCLGenRun_id is null or @PCLGenRun_id <= 0
    begin
       ROLLBACK TRANSACTION
       return
    end

    INSERT INTO #MyPCLNeeded 
     (samplepop_id, survey_id, selcover_id, language, sentmail_id, questionform_id, batch_id, PCLGenRun_id, bitdone)
    SELECT
      samplepop_id, survey_id, selcover_id, language, sentmail_id, questionform_id, batch_id, @pclgenrun_id, bitdone
    FROM dbo.PCLNeeded
    WHERE batch_id = @nextbatch
    if @@error <> 0
    begin
       ROLLBACK TRANSACTION
       return
    end
 end
 COMMIT TRANSACTION


