/* This procedure determines what should be PCLGen'd (real surveys, test prints or nothing at all. */
/* Last Modified by:  Dave Gilsdorf - 1/22/2004 */
create procedure dbo.sp_PCL_TimeFor
  @survey_id int = 0
as
/* return values:
** 0 - nothing - don't run anything
** 1 - Real surveys - run regular PCLGen
** 2 - Test Prints - run test prints
*/
declare @starttime int, @stoptime int, @starttime_tp int, @stoptime_tp int, @nowtime int, @pause int, @timefor char(11)

select @starttime = numParam_value
from dbo.qualpro_params
where strParam_nm = 'PCLGenStartTime' and strParam_grp = 'PCLGen'

select @stoptime = numParam_value
from dbo.qualpro_params
where strParam_nm = 'PCLGenStopTime' and strParam_grp = 'PCLGen'

select @starttime_tp = numParam_value
from dbo.qualpro_params
where strParam_nm = 'PCLGenStartTime_TP' and strParam_grp = 'PCLGen'

select @stoptime_tp = numParam_value
from dbo.qualpro_params
where strParam_nm = 'PCLGenStopTime_TP' and strParam_grp = 'PCLGen'

select @pause = numParam_value
from dbo.qualpro_params
where strParam_nm = 'PCLGenPause' and strParam_grp = 'PCLGen'

select @starttime = isnull(@starttime,0),
  @stoptime = isnull(@stoptime,0),
  @starttime_tp = isnull(@starttime_tp,0),
  @stoptime_tp = isnull(@stoptime_tp,0),
  @pause = isnull(@pause,0),
  @nowtime = (datepart(hh,getdate()) * 100) + datepart(mi,getdate()),
  @timefor='TestPrints'

if @pause > 1 return 0
if @nowtime > @stoptime_tp and @nowtime < @starttime_tp and @starttime_tp > @stoptime_tp set @timefor='Not Test' -- maybe Real Surveys
if @nowtime > @stoptime_tp and @starttime_tp < @stoptime_tp set @timefor='Not Test' -- maybe Real Surveys
if @nowtime < @starttime_tp and @starttime_tp < @stoptime_tp set @timefor='Not Test' -- maybe Real Surveys

if (@timefor='TestPrints') and 
   (exists (	select * 
		from pclneeded_tp n
		where n.bitdone=0 
		and n.survey_id = case @survey_id when 0 then n.survey_id else @survey_id end
	   )
   )
	return 2

if @pause > 0 return 0
if @nowtime > @stoptime and @nowtime < @starttime and @starttime > @stoptime return 0
if @nowtime > @stoptime and @starttime < @stoptime return 0
if @nowtime < @starttime and @starttime < @stoptime return 0

return 1 -- Real Surveys


