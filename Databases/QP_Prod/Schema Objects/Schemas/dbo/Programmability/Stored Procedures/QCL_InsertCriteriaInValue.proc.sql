/*
Business Purpose: 

This procedure is used to Insert a record into CriteriaInList Table 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteriaInValue]
@criteriaClauseId Int, 
@Value varchar(42)
AS

INSERT INTO CriteriaInList (CRITERIACLAUSE_ID, STRLISTVALUE)
VALUES (@criteriaClauseId, @Value)

SELECT SCOPE_IDENTITY() as CRITERIAINLIST_ID


