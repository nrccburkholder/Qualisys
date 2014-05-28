/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_Delete
*
*	Description:
		This will delete a period.
*
*	Parameters:
		@perioddef_id
			This is the period ID.
*
*	Return:
*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE PROCEDURE dbo.SP_Period_Delete
	@perioddef_id int
AS

set transaction isolation level read uncommitted

delete
from perioddef
where perioddef_id=@perioddef_id

delete 
from perioddates
where perioddef_id=@perioddef_id


