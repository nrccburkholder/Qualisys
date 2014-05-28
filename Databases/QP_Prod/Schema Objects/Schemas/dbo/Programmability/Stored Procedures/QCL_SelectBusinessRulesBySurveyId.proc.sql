/*
Business Purpose: 

This procedure is used to get information about all Business Rules for a survey  

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectBusinessRulesBySurveyId]
@survey_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  BusinessRule_Id, Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD
FROM BusinessRule
WHERE Survey_ID=@survey_Id


