/*
Business Purpose: 

This procedure is used to add a new HouseHolding Fields record for a survey

Created:  03/14/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_InsertHouseHoldingField]
@survey_Id INT,
@table_id INT,
@field_id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

Insert HOUSEHOLDRULE (survey_id, table_id, field_id) VALUES (@survey_Id,@table_id,@field_id)


