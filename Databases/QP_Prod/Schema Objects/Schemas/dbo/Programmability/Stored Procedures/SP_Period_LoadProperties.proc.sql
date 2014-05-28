/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_LoadProperties
*
*	Description:
		This will return the properties for period.
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

CREATE   PROCEDURE dbo.SP_Period_LoadProperties
	@period_id int
AS

set transaction isolation level read uncommitted
--This recordset has the Period Properties information
select p.*, strsamplingmethod_nm
from PeriodDef p, samplingmethod s
where perioddef_id =@period_id and
	  p.samplingmethod_id=s.samplingmethod_id


