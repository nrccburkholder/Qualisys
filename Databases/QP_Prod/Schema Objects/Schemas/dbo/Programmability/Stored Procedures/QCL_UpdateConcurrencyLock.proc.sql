CREATE PROCEDURE DBO.QCL_UpdateConcurrencyLock
@ConcurrencyLockId INT,
@ExpirationTime DATETIME
AS

UPDATE ConcurrencyLock SET ExpirationTime = @ExpirationTime
WHERE ConcurrencyLock_id = @ConcurrencyLockId


