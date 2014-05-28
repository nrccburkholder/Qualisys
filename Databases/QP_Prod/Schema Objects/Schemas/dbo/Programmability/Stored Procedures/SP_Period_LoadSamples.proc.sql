/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_LoadSamples
*
*	Description:
		This will return the samples for period.
*
*	Parameters:
		@period_id
			This is the period ID.
*
*	Return:
		Recordset contain the period properties information
*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE     PROCEDURE dbo.SP_Period_LoadSamples
	@period_id int
AS

set transaction isolation level read uncommitted

--This recordset will have the Period dates information
select case
		when p.samplenumber > pd.intExpectedSamples then 'OS' + convert(varchar,p.samplenumber)
		else convert(varchar,p.samplenumber)
	   end as samplenumber,
	   datscheduledsample_dt,
	   datsamplecreate_dt
from PeriodDates p, PeriodDef pd
where p.perioddef_id=@period_id and
  		pd.perioddef_id =p.perioddef_id


