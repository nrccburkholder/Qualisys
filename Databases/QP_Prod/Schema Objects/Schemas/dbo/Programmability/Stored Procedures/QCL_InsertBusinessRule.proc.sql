/*
Business Purpose: 

This procedure is used to Insert a record into Busines Rule 

Created:  03/13/2006 by Dan Christensen

Modified:

*/
CREATE  PROCEDURE [dbo].[QCL_InsertBusinessRule]
@study_Id INT,
@survey_Id int,
@CRITERIASTMT_Id int,
@BusRule_CD char(1)
AS

INSERT INTO BusinessRule (Survey_ID, Study_id, CRITERIASTMT_Id, BusRule_CD)
VALUES (@survey_Id, @study_Id, @CRITERIASTMT_Id,@BusRule_CD)

SELECT SCOPE_IDENTITY() as businessRule_id


