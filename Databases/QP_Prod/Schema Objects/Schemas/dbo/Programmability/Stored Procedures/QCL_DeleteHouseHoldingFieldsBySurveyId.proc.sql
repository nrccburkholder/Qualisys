/*
Business Purpose: 

This procedure is used to delete all HouseHolding Fields for a Survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_DeleteHouseHoldingFieldsBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

DELETE HOUSEHOLDRULE
WHERE Survey_ID=@survey_Id


