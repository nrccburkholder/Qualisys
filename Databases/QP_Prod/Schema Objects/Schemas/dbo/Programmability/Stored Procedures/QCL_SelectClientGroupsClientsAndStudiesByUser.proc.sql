CREATE PROCEDURE [dbo].[QCL_SelectClientGroupsClientsAndStudiesByUser]    
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
    Active bit,
	bitAutoSample bit
)    

--Need a temp table to hold the client groups
CREATE TABLE #ClientGroups (
    ClientGroup_id INT,
    ClientGroup_nm VARCHAR(50),
    ClientGroupReporting_nm VARCHAR(100),
    Active BIT,
    DateCreated DATETIME
)

--Populate the Client Group temp table
INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
VALUES (-1, 'Unassigned', 'Unassigned', 1, '01/01/2010')

INSERT INTO #ClientGroups (ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated
FROM ClientGroups
ORDER BY ClientGroup_nm

--Populate the temp table with the studies they have rights to.    
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	                   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample)    
SELECT st.Client_id, st.Study_id, st.strStudy_nm, st.strStudy_dsc, st.ADEmployee_id,
	   st.datCreate_dt, st.bitCleanAddr, st.bitProperCase, st.Active, st.bitAutosample  
FROM Employee em, Study_Employee se, Study st    
WHERE em.strNTLogin_nm = @UserName    
  AND em.Employee_id = se.Employee_id    
  AND se.Study_id = st.Study_id    
  AND st.datArchived IS NULL    
    
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)    

--First recordset.  List of client groups they have rights to or all client groups
IF @ShowAllClients = 1
BEGIN
    SELECT ClientGroup_id, ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated
    FROM #ClientGroups
END
ELSE
BEGIN
    SELECT cg.ClientGroup_id, cg.ClientGroup_nm, cg.ClientGroupReporting_nm, cg.Active, cg.DateCreated
    FROM #EmpStudy es, Client cl, #ClientGroups cg
    WHERE es.Client_id = cl.CLIENT_ID
      AND ISNULL(cl.ClientGroup_ID, -1) = cg.ClientGroup_id
    GROUP BY cg.ClientGroup_id, cg.ClientGroup_nm, cg.ClientGroupReporting_nm, cg.Active, cg.DateCreated
END

--Second recordset.  List of clients they have rights to or all clients    
IF @ShowAllClients = 1
BEGIN
	SELECT Client_id, strClient_nm, Active, ISNULL(ClientGroup_ID, -1) AS ClientGroup_ID
	FROM Client
	ORDER BY strClient_nm
END
ELSE
BEGIN
	SELECT cl.Client_id, cl.strClient_nm, cl.Active, cl.ClientGroup_ID
	FROM #EmpStudy es, Client cl
	WHERE es.Client_id = cl.Client_id
	GROUP BY cl.Client_id, cl.strClient_nm, cl.Active, cl.ClientGroup_ID
	ORDER BY cl.strClient_nm
END
    
--Third recordset.  List of studies they have rights to    
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc, ADEmployee_id,
	   datCreate_dt, bitCleanAddr, bitProperCase, Active, bitAutoSample
FROM #EmpStudy
ORDER BY strStudy_nm

--Cleanup temp table    
DROP TABLE #EmpStudy
DROP TABLE #ClientGroups

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

