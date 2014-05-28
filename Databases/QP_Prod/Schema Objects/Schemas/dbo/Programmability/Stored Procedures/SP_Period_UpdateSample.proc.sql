/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_UpdateSample
*
*	Description:
		This will update a sample in the PeriodDates table.
*
*	Parameters:
		@perioddef_id
			This is the period ID.
		@sampleNumber 
			This is the sample number for the period
		@datscheduledsample_dt
			This is the scheduled sample date
*
*	Return:

*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE    PROCEDURE dbo.SP_Period_UpdateSample
		@perioddef_id int,
		@sampleNumber int,
		@datscheduledsample_dt datetime,
		@datactualDate datetime 
AS

IF @datactualDate='1/1/1899' SET @datactualDate=null 
update PeriodDates 
set datscheduledsample_dt=@datscheduledsample_dt,
	datsamplecreate_dt=@datActualDate
where perioddef_id=@perioddef_id and
		samplenumber=@samplenumber


