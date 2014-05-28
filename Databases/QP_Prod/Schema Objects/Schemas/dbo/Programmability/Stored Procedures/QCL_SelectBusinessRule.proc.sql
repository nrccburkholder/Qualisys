/*
Business Purpose: 

This procedure is used to get information about a Business Rule   

Created:  03/13/2006 by Dan Christensen

Modified:

*/
Create PROCEDURE [dbo].[QCL_SelectBusinessRule]
@BusinessRule_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT  BusinessRule_Id, Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD
FROM BusinessRule
WHERE BusinessRule_Id=@BusinessRule_Id


