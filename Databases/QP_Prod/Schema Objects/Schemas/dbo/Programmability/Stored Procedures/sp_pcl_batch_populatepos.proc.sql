CREATE PROCEDURE dbo.sp_pcl_batch_populatepos
AS
 declare @batch_id int, @rc int, @err int
 declare @starttime int, @stoptime int, @pause int, @nowtime int
 declare @startdtime datetime, @enddtime datetime
 declare @sqlstr varchar(255)
 select @startdtime = getdate()
 while exists (select batch_id
   from dbo.PCLQuestionForm
   where  bitIsProcessed = 0
   and batch_id not in (select batch_id
      from dbo.PCLGenPosError
      where isResolved = 0)
 ) 
 begin
  select @starttime = numParam_value
  from dbo.qualpro_params
  where strParam_nm = 'PCLGenPosStartTime' and strParam_grp = 'PCLGen'
  select @stoptime = numParam_value
  from dbo.qualpro_params
  where strParam_nm = 'PCLGenPosStopTime' and strParam_grp = 'PCLGen'
  select @pause = numParam_value
  from dbo.qualpro_params
  where strParam_nm = 'PCLGenPosPause' and strParam_grp = 'PCLGen'
  select @starttime = isnull(@starttime,0),
   @stoptime = isnull(@stoptime,0),
   @pause = isnull(@pause,0),
   @nowtime = (datepart(hh,getdate()) * 100) + datepart(mi,getdate())
/* If the batch windows is closed, then we will raise an error for it to retry later. */
  if ((@pause > 0) OR
     (@nowtime > @stoptime and @nowtime < @starttime and @starttime > @stoptime) OR
     (@nowtime > @stoptime and @starttime < @stoptime) OR
     (@nowtime < @starttime and @starttime < @stoptime))
  begin
   raiserror ('Batch window is closed, enter retry looping.', 16, 1)
   return
  end
  select @batch_id = min(batch_id)
  from dbo.pclquestionform
  where bitIsProcessed = 0
  and batch_id not in (select batch_id
     from dbo.PCLGenPosError
     where isResolved = 0)
  exec @rc=dbo.sp_pcl_populate_pos_tables @batch_id
  select @err = @@error
  if @err <> 0
  begin
   INSERT INTO dbo.PCLGenPosError (batch_id, sql_error, returned_error)
   VALUES (@batch_id, @err, @rc)
  end
  else if @rc <> 0
  begin
   INSERT INTO dbo.PCLGenPosError (batch_id, sql_error, returned_error)
   VALUES (@batch_id, @err, @rc)
  end
 end
 select @enddtime = getdate()
 if exists (select batch_id
   from dbo.PCLGenPosError
   where datgenerated between @startdtime and @enddtime)
 begin
  select @sqlstr = 'SELECT * FROM dbo.PCLGenPosError WHERE datgenerated BETWEEN ''' + convert(varchar,@startdtime,101) + ''' AND ''' + convert(varchar,@enddtime,101) + ''''
  exec dbo.sp_RaiseError 2, 'PCLGenPos', @sqlstr
 end


