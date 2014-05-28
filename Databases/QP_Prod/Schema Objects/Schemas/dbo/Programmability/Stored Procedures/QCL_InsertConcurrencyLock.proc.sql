CREATE PROCEDURE DBO.QCL_InsertConcurrencyLock
@LockCategoryId INT,
@LockValueId INT,
@UserName VARCHAR(50),
@MachineName VARCHAR(50),
@ProcessName VARCHAR(50),
@ExpirationTime DATETIME

AS

IF NOT EXISTS (SELECT ConcurrencyLock_id 
			FROM ConcurrencyLock 
			WHERE LockCategory_id = @LockCategoryId 
			AND LockValue_id = @LockValueId
			AND ExpirationTime > GETDATE())
BEGIN

	INSERT INTO ConcurrencyLock (LockCategory_id, LockValue_id, UserName, MachineName, ProcessName, AcquisitionTime, ExpirationTime)
	SELECT @LockCategoryId, @LockValueId, @UserName, @MachineName, @ProcessName, GETDATE(), @ExpirationTime

	SELECT ConcurrencyLock_id, LockCategory_id, LockValue_id, UserName, MachineName, ProcessName, AcquisitionTime, ExpirationTime
	FROM ConcurrencyLock
	WHERE ConcurrencyLock_id = SCOPE_IDENTITY()

END


