CREATE PROCEDURE SP_SYS_CriteriaFields @Study_id INT
AS
SELECT DISTINCT strTable_nm, strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, m.Field_id
FROM CriteriaStmt cs, CriteriaClause cc, MetaData_View m
WHERE cs.Study_id=@Study_id
AND cs.CriteriaStmt_id=cc.CriteriaStmt_id
AND cc.Table_id=m.Table_id
AND cc.Field_id=m.Field_id


