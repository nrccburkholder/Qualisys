CREATE PROCEDURE sp_SI_CommentSetLock

AS

UPDATE CommentLocks
SET datLockDate = GetDate()


