/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_LoadSamplingMethods
*
*	Description:
		This will return a list of sampling methods.
*
*	Parameters:

*
*	Return:
		Recordset containing the sampling methods
*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE    PROCEDURE dbo.SP_Period_LoadSamplingMethods
AS

select strsamplingmethod_nm
from samplingmethod


