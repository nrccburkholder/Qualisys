/*
Business Purpose: 

This procedure is used to Insert a record into CriteriaClause Table 

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertCriteriaClause]
@criteriaStatementId Int, 
@criteriaPhraseId Int, 
@tableId Int, 
@fieldId Int, 
@operator Int, 
@lowValue varchar(42), 
@highValue varchar(42)
AS

INSERT INTO CriteriaClause (CRITERIAPHRASE_ID, CRITERIASTMT_ID, TABLE_ID, FIELD_ID, INTOPERATOR, STRLOWVALUE, STRHIGHVALUE)
VALUES (@criteriaPhraseId, @criteriaStatementId, @tableId, @fieldId, @operator, @lowValue, @highValue)

SELECT SCOPE_IDENTITY() as criteriaClause_id


