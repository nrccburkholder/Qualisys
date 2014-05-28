/****** Object:  Stored Procedure dbo.sp_Samp_InheritSample    Script Date: 9/28/99 2:57:16 PM ******/
/***********************************************************************************************************************************
SP Name:	sp_Samp_InheritSample

Part of:		Sampling Tool

Purpose: 	

Input:		
	
Output:		

Creation Date:	09/08/1999

Author(s):	DA, RC 

Revision:	First build - 09/08/1999
***********************************************************************************************************************************/

CREATE PROCEDURE sp_Samp_InheritSample
	@intSourceUnit int,
	@intTargetUnit int,
	@vcPopID_EncID_Join varchar(255),
	@vcInheritType varchar(1)
AS
	DECLARE @vcSQL varchar(8000)
	
	SET @vcSQL = "UPDATE #SampleUnit_Universe" +
				" SET strUnitSelectType = " + @vcInheritType +
				" FROM #SampleUnit_Universe SourceUnit"  +
				" WHERE " + @vcPopID_EncID_Join +  
					" AND #SampleUnit_Universe.SampleUnit_id = " + @intTargetUnit +
					" AND SourceUnit.SampleUnit_id = " + @intSourceUnit

	EXECUTE (@vcSQL)


