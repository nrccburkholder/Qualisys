CREATE PROCEDURE DBO.QCL_SelectAllConcurrencyLocks
AS

SELECT ConcurrencyLock_id, LockCategory_id, LockValue_id, UserName, MachineName, ProcessName, AcquisitionTime, ExpirationTime
FROM ConcurrencyLock
WHERE ExpirationTime > GETDATE()


