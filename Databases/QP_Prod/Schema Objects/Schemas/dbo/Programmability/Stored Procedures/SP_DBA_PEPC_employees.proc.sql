CREATE PROCEDURE SP_DBA_PEPC_employees
AS

SELECT employee_id
INTO #emp
FROM employee
WHERE employee_id IN (303,187,143,304,190,108,17,307,308,282,214,292,71,310)

SELECT DISTINCT study_id, 0 checked
INTO #s1
FROM survey_def 
WHERE strsurvey_nm LIKE '%6530%'

SELECT study_id, 0 checked
INTO #s2
FROM study
WHERE strstudy_nm LIKE '%pep-c%'

SELECT study_id, checked
INTO #s
FROM #s2
UNION
SELECT study_id, checked
FROM #s1

DECLARE @study INT, @emp INT

WHILE (SELECT COUNT(*) FROM #emp) > 0
BEGIN

SET @emp = (SELECT TOP 1 employee_id FROM #emp)

UPDATE #s SET checked = 0

WHILE (SELECT COUNT(*) FROM #s WHERE checked = 0) > 0
BEGIN

SET @study = (SELECT TOP 1 study_id FROM #s WHERE checked = 0)

IF NOT EXISTS (SELECT * FROM study_employee WHERE employee_id = @emp AND study_id = @study)
BEGIN

INSERT INTO study_employee
SELECT @emp, @study

END

UPDATE #s SET checked = 1 WHERE study_id = @study

END

DELETE #emp WHERE employee_id = @emp

END

DROP TABLE #s
DROP TABLE #s1
DROP TABLE #s2
DROP TABLE #emp


