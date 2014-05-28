CREATE PROCEDURE DBO.SP_QDE_UnLockForm
@Form_id INT
AS

UPDATE QDEForm
SET bitLocked = 0
WHERE Form_id = @Form_id


