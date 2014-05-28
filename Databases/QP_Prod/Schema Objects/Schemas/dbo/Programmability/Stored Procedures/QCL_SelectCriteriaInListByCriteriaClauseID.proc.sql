﻿/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  03/9/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectCriteriaInListByCriteriaClauseID]
@CRITERIACLAUSE_ID INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT CRITERIAINLIST_ID, CRITERIACLAUSE_ID, STRLISTVALUE
FROM CRITERIAINLIST
WHERE CRITERIACLAUSE_ID=@CRITERIACLAUSE_ID


