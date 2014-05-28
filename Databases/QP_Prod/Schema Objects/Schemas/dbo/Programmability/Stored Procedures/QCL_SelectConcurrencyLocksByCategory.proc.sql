CREATE PROCEDURE DBO.QCL_SelectConcurrencyLocksByCategory
@LockCategoryId INT
AS

SELECT ConcurrencyLock_id, LockCategory_id, LockValue_id, UserName, MachineName, ProcessName, AcquisitionTime, ExpirationTime
FROM ConcurrencyLock
WHERE ExpirationTime > GETDATE()
AND LockCategory_id = @LockCategoryId


