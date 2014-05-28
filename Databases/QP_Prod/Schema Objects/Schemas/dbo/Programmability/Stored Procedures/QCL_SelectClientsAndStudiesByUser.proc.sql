CREATE PROCEDURE [dbo].[QCL_SelectClientsAndStudiesByUser]    
    @UserName VARCHAR(42),
	@ShowAllClients BIT = 0
AS    

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
    
--Need a temp table to hold the ids the user has rights to    
CREATE TABLE #EmpStudy (    
    Client_id INT,    
    Study_id INT,    
    strStudy_nm VARCHAR(10),    
    strStudy_dsc VARCHAR(255),  
    ADEmployee_id int,
    datCreate_dt datetime,
    bitCleanAddr bit,
    bitProperCase bit,
    Active bit
)    
    
--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	                   datCreate_dt, bitCleanAddr, bitProperCase, Active)    
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc, s.ADEmployee_id,
	   s.datCreate_dt, s.bitCleanAddr, s.bitProperCase, s.Active   
FROM Employee e, Study_Employee se, Study s    
WHERE e.strNTLogin_nm = @UserName    
  AND e.Employee_id = se.Employee_id    
  AND se.Study_id = s.Study_id    
  AND s.datArchived IS NULL    
    
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    
    
--First recordset.  List of clients they have rights to or all clients    
IF @ShowAllClients = 1
BEGIN
	SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID
	FROM Client c
	ORDER BY c.strClient_nm
END
ELSE
BEGIN
	SELECT c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID
	FROM #EmpStudy t, Client c
	WHERE t.Client_id = c.Client_id
	GROUP BY c.Client_id, c.strClient_nm, c.Active, c.ClientGroup_ID
	ORDER BY c.strClient_nm
END
    
--Second recordset.  List of studies they have rights to    
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	   datCreate_dt, bitCleanAddr, bitProperCase, Active
FROM #EmpStudy
ORDER BY strStudy_nm
    
--Cleanup temp table    
DROP TABLE #EmpStudy
    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


