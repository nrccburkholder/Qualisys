CREATE PROCEDURE SP_SYS_ClientList @strLogin_nm VARCHAR(42)=NULL
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @strLogin_nm IS NULL
SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id
	FROM Client c, Study s
		WHERE s.Client_id=c.Client_id
		ORDER BY 1,3
ELSE
SELECT c.strClient_nm, c.Client_id, s.strStudy_nm, s.Study_id
	FROM Client c, Study s, Employee e, Study_Employee se
		WHERE e.strNTLogin_nm=@strLogin_nm
			AND e.Employee_id=se.Employee_id
			AND se.Study_id=s.Study_id
			AND s.Client_id=c.Client_id
		ORDER BY 1,3


