/* This procedure gets the next batch_id for PCLGen to run, and updates the appropriate tables */
/* Last Modified by:  Daniel Vansteenburg - 7/15/1999 */
/* DV 7/15/99 - Added code to determine if PCLGen should be running or not */
/*              based on QualPro params. */
CREATE PROCEDURE sp_pcl_nextbatch_2
 @compname varchar(16)
AS
 declare @nextbatch int, @pclgenrun_id int, @rc int, @err int
 declare @starttime int, @stoptime int, @pause int, @nowtime int
/* Determine if we can run */
 select @starttime = numParam_value
 from dbo.qualpro_params
 where strParam_nm = 'PCLGenStartTime' and strParam_grp = 'PCLGen'
 select @stoptime = numParam_value
 from dbo.qualpro_params
 where strParam_nm = 'PCLGenStopTime' and strParam_grp = 'PCLGen'
 select @pause = numParam_value
 from dbo.qualpro_params
 where strParam_nm = 'PCLGenPause' and strParam_grp = 'PCLGen'
 select @starttime = isnull(@starttime,0),
  @stoptime = isnull(@stoptime,0),
  @pause = isnull(@pause,0),
  @nowtime = (datepart(hh,getdate()) * 100) + datepart(mi,getdate())
 if @pause > 0 return
 if @nowtime > @stoptime and @nowtime < @starttime and @starttime > @stoptime return
 if @nowtime > @stoptime and @starttime < @stoptime return
 if @nowtime < @starttime and @starttime < @stoptime return
/* If we got here, PCLGen can process batches. */
 BEGIN TRANSACTION
 update dbo.pcllocks
 set lockdate = getdate()
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
  INSERT INTO ##MyPCLNeeded (
   samplepop_id, survey_id, selcover_id, language, sentmail_id,
   questionform_id, batch_id, PCLGenRun_id, bitdone
  ) SELECT
   samplepop_id, survey_id, selcover_id, language, sentmail_id,
   questionform_id, batch_id, @pclgenrun_id, bitdone
  FROM dbo.PCLNeeded
  WHERE batch_id = @nextbatch
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   return
  end
 end
 COMMIT TRANSACTION


