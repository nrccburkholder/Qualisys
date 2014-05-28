CREATE PROCEDURE SP_DBM_Update_FullAccess
AS

SELECT Employee_id, Study_id
INTO #all
FROM Study s, Employee e
WHERE e.FullAccess=1
AND e.Dashboard_FullAccess<>2

CREATE INDEX TempIndex ON #all (Employee_id, Study_id)

INSERT INTO Study_Employee
SELECT t.Employee_id, t.Study_id
FROM #all t LEFT JOIN Study_Employee se
ON t.Employee_id=se.Employee_id
AND t.Study_id=se.Study_id
WHERE se.Study_id IS NULL

DROP TABLE #all


