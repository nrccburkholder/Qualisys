CREATE PROCEDURE DBO.QCL_DeleteConcurrencyLock
@ConcurrencyLockId INT
AS

DELETE ConcurrencyLock
WHERE ConcurrencyLock_id = @ConcurrencyLockId


