/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_GetCurrentSamplingMethod
*
*	Description:
		This will return a the Sampling Method of the Period that is currently
		being sampled for.
*
*	Parameters:
		@survey_id
			This is the survey ID.
*
*	Return:
		Recordset containing the Sampling Method
*
*	History:
		release 1.0  Feb 5, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE  PROCEDURE dbo.SP_Period_GetCurrentSamplingMethod
	@survey_id int
AS
set transaction isolation level read uncommitted

create table #periodslist (perioddef_id int, activeperiod int)

insert into #periodslist 
execute ('sp_period_getsamplingperiodslist ' + @survey_id)

--Find the active period
--A count of 2 means that sampling has started but hasn't finished
--A count of 1 means that sampling has not started
select p.PeriodDef_id, strSamplingmethod_nm
into #Active
from perioddef p, #periodslist pd, samplingmethod s
where p.perioddef_id=pd.perioddef_id and
	  pd.activeperiod=1 and
	   p.samplingmethod_id=s.samplingmethod_id


select strsamplingmethod_nm
from #Active


drop table #Active


