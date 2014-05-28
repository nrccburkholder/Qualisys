CREATE PROCEDURE SP_SYS_CriteriaStmts @Study_id INT
AS
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, BusRule_cd
FROM CriteriaStmt c, BusinessRule b
WHERE c.CriteriaStmt_id=b.CriteriaStmt_id
AND c.Study_id=@Study_id
AND BusRule_cd='Q'
UNION ALL
SELECT Survey_id, c.CriteriaStmt_id, strCriteriaString, 'C'
FROM CriteriaStmt c, SampleUnit su, Sampleplan sp
WHERE c.CriteriaStmt_id=su.CriteriaStmt_id
AND c.Study_id=@Study_id
AND su.Sampleplan_id=sp.Sampleplan_id


