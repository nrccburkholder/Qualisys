/****** Object:  Stored Procedure dbo.sp_Samp_AddNewPeriod    Script Date: 9/28/99 2:57:10 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_AddNewPeriod
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
03/09/2001 Dave Gilsdorf
 Period.datPeriodDate sometimes exactly equaled SampleSet.datSampleCreate_dt and the Sampling Tool 
 (which used a '>' operator, not a '>=') wouldn't recognize that the new sampleset was in the new period.
 changed the date inserted into Period.datPeriodDate to GetDate() minus 1 second.
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_AddNewPeriod
 @intSurvey_id int,
 @intEmployee_id int
AS
 INSERT INTO dbo.Period
  (Survey_id, datPeriodDate, Employee_id)
 VALUES
  (@intSurvey_id, dateadd(second,-1,GETDATE()), @intEmployee_id)


