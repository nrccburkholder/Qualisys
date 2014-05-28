/* This procedure gets the next batch_id for PCLGen to run, and updates the appropriate tables */
/* Last Modified by:  Daniel Vansteenburg - 7/15/1999 */
/* DV 7/15/99 - Added code to determine if PCLGen should be running or not */
/*              based on QualPro params. */
/* DG 1/22/04 - Added code for test prints. */
CREATE PROCEDURE sp_pcl_nextbatch
 @compname varchar(16), @survey_id int = 0
AS
--declare @compname varchar(16) set @compname='dgilsdorf'
 declare @nextbatch int, @pclgenrun_id int, @rc int, @err int, @TPBatch datetime, @timefor int

-- if we want a batch for a specific survey_id, wait up to 10 minutes for it.
declare @starttime datetime
set @starttime = getdate()
if @survey_id > 0 
begin
    while not exists (select survey_id from pclneeded_tp (NOLOCK) where bitdone=0 and survey_id = @survey_id
		union select survey_id from pclneeded (NOLOCK) where bitdone=0 and survey_id = @survey_id)
    begin
        waitfor delay '0:00:01'
        if datediff(minute,@starttime,getdate()) > 10 
            break
    end
end

/* Determine if we can run */
exec @timefor=sp_PCL_Timefor @survey_id
if @timefor=0 return

if @timefor=1 -- Real Surveys
begin
    print 'timefor realsurveys'
    BEGIN TRANSACTION
    update dbo.pcllocks
    set lockdate = getdate()
    if @@error <> 0
    begin
     ROLLBACK TRANSACTION
     return
    end
    select top 1 @nextbatch = n.batch_id
    from dbo.PCLNeeded n
    where n.bitDone = 0
    and n.batch_id >= 0
    and n.survey_id = case @survey_id when 0 then n.survey_id else @survey_id end
    order by n.priority_flg, n.batch_id
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
     INSERT INTO #MyPCLNeeded (
      samplepop_id, survey_id, selcover_id, language, sentmail_id,
      questionform_id, batch_id, PCLGenRun_id, bitdone, bitTestPrints
     ) SELECT
      samplepop_id, survey_id, selcover_id, language, sentmail_id,
      questionform_id, batch_id, @pclgenrun_id, bitdone, 0
     FROM dbo.PCLNeeded
     WHERE batch_id = @nextbatch
     if @@error <> 0
     begin
      ROLLBACK TRANSACTION
      return
     end
    end
    COMMIT TRANSACTION
end
else -- @timefor=2 - Test Prints
begin
    print 'timefor testprints'
    BEGIN TRANSACTION
    update dbo.pcllocks
    set lockdate = getdate()
    if @@error <> 0
    begin
     ROLLBACK TRANSACTION
     return
    end
    select top 1 @TPBatch = min(s.datScheduled)
    from dbo.PCLNeeded_TP n, dbo.Scheduled_TP s
    where n.tp_id=s.tp_id
    and n.bitDone = 0
    and n.batch_id >= 0
    and n.survey_id = case @survey_id when 0 then n.survey_id else @survey_id end
    if @@error <> 0
    begin
     ROLLBACK TRANSACTION
     return
    end

    update n
    set bitdone=1
    from dbo.PCLNeeded_TP n, dbo.Scheduled_TP s
    where n.tp_id=s.tp_id 
    and s.datScheduled = @TPBatch
    if @@error <> 0 or @@rowcount=0
    begin
     ROLLBACK TRANSACTION
     return
    end
    set @compname='TP_'+@compname
    exec @rc=dbo.sp_pcl_startnewrun @compname=@compname, @PCLGenRun_id=@pclgenrun_id OUTPUT
    select @err=@@error
    if @err <> 0 or @rc < 0 or @PCLGenRun_id is null or @PCLGenRun_id <= 0
    begin
     ROLLBACK TRANSACTION
     return
    end
    INSERT INTO #MyPCLNeeded 
     (samplepop_id, survey_id, selcover_id, language, sentmail_id,
      questionform_id, batch_id, PCLGenRun_id, bitdone, bitTestPrints)
    SELECT
     n.samplepop_id, n.survey_id, n.selcover_id, n.language, n.tp_id as sentmail_id, 
     n.tp_id as questionform_id, n.batch_id, @PCLGenRun_id, n.bitdone, 1
    from dbo.PCLNeeded_tp n, dbo.Scheduled_TP s
    where n.tp_id=s.tp_id
    and s.datScheduled=@TPBatch
    if @@error <> 0 or @@rowcount=0
    begin
     ROLLBACK TRANSACTION
     return
    end
    COMMIT TRANSACTION
end


