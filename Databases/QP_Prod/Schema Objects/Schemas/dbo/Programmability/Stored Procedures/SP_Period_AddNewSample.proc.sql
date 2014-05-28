/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_AddNewSample
*
*	Description:
		This will add a new sample to the PeriodDates table.
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

CREATE PROCEDURE dbo.SP_Period_AddNewSample
		@perioddef_id int,
		@sampleNumber int,
		@datscheduledsample_dt datetime
AS

insert into PeriodDates (Perioddef_id, samplenumber, datscheduledsample_dt)
values (@Perioddef_id, @samplenumber, @datscheduledsample_dt)


