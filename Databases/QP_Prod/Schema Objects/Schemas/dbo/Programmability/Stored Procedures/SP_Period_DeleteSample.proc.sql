/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_DeleteSample
*
*	Description:
		This will delete a sample in the PeriodDates table.
*
*	Parameters:
		@perioddef_id
			This is the period ID.
		@sampleNumber 
			This is the sample number for the period

*
*	Return:

*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE PROCEDURE dbo.SP_Period_DeleteSample
		@perioddef_id int,
		@sampleNumber int
AS

delete
from perioddates
where perioddef_id=@perioddef_id and
	samplenumber=@samplenumber


