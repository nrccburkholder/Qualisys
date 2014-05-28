/***********************************************************************************************************************************
SP Name: sp_Samp_ValidateConfiguration
Part of:  Sampling Tool
Purpose:  Makes sure a sample plan has been set up for this survey.
 
Output:  a one-row record set with a message in ConfigStatus 
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 3/2/2000 - Dave Gilsdorf
   Removed @intSampleUnits and use the SELECT COUNT(*) directly in the IF statement
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_ValidateConfiguration
 @intSurvey_id int
AS
 INSERT INTO DashboardLog (Report, Client, Study, Survey, ProcedureBegin)
   SELECT 'Sampling Tool', C.strClient_nm, S.strStudy_nm, SD.strSurvey_nm, getdate()
   FROM Client C, Study S, Survey_def SD
   WHERE C.Client_id=S.Client_id
   and S.Study_id=SD.Study_id
   and SD.Survey_id=@intSurvey_id
 DECLARE @vcMsg varchar(8000)
 SET @vcMsg = 'NO ERROR'
 IF (SELECT COUNT(*)
  FROM dbo.SamplePlan SP, dbo.SampleUnit SU
  WHERE SP.SamplePlan_id = SU.SamplePlan_id
   AND SP.Survey_id = @intSurvey_id) = 0
  SET @vcMsg = 'A Sample Plan has not been set up for this survey.'
 SELECT ConfigStatus = @vcMsg


