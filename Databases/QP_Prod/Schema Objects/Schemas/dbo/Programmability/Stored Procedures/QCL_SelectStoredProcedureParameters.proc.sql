/*
Business Purpose: 

This procedure is used to select the list of parameters for a stored procedure.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].QCL_SelectStoredProcedureParameters
	@StoredProcedureName varchar(50)
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT sc.name as paramName, st.name as paramType 
FROM sysobjects so, syscolumns sc, systypes st 
WHERE so.name =@StoredProcedureName 
AND so.id=sc.id 
AND sc.xtype = st.xtype
ORDER BY sc.colorder


