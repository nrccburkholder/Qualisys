/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Samp_DeletePreSample
*
*	Description:
		This will delete a sample in the PeriodDates table.
*
*	Parameters:
		@Survey
			This is the survey ID.

*
*	Return:

*
*	History:
		release 1.0  Feb 9, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE    PROCEDURE dbo.SP_Samp_DeletePreSample
		@Survey int
AS
Declare @study int, @sql VARCHAR(8000)

 /*Fetch the Study id*/
 SELECT @Study = Study_id
  FROM dbo.Survey_def 
  WHERE Survey_id = @Survey


 SET @sql='if exists (select * from dbo.sysobjects where id = object_id(N''[s' + convert(varchar,@study) + '].[presample]'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1)
			BEGIN' +
			
			 ' Delete '+
						'From s' + convert(varchar,@study) + '.presample '+
						'WHERE survey_id=' + convert(varchar,@survey)  + 
			

			
			 ' Delete '+ 
						'From s' + convert(varchar,@study) + '.presamplecounts '+
						'WHERE survey_id=' + convert(varchar,@survey) +
			

			' END'
exec (@sql)


