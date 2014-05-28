CREATE PROCEDURE SP_SYS_RollbackCleanup @RollbackID INT
AS

DELETE Rollback_BubbleLoc WHERE Rollback_id=@RollbackID
DELETE Rollback_PCLResults WHERE Rollback_id=@RollbackID
DELETE Rollback_BubblePos WHERE Rollback_id=@RollbackID
DELETE Rollback_BubbleItemPos WHERE Rollback_id=@RollbackID
DELETE Rollback_CommentLinePos WHERE Rollback_id=@RollbackID
DELETE Rollback_PCLOutput WHERE Rollback_id=@RollbackID
DELETE Rollback_CommentLoc WHERE Rollback_id=@RollbackID
DELETE Rollback_SentMailing WHERE Rollback_id=@RollbackID
DELETE Rollback_NPSentMailing WHERE Rollback_id=@RollbackID
DELETE Rollback_PCLGenLog WHERE Rollback_id=@RollbackID
DELETE Rollback_ScheduledMailing WHERE Rollback_id=@RollbackID
DELETE Rollback_Questionform WHERE Rollback_id=@RollbackID
DELETE Rollback_CommentPos WHERE Rollback_id=@RollbackID
DELETE Rollback_PCLQuestionForm WHERE Rollback_id=@RollbackID
DELETE Rollback_HandWrittenPos WHERE Rollback_id=@RollbackID
DELETE Rollback_HandWrittenLoc WHERE Rollback_id=@RollbackID
DELETE Rollback_FormGenError WHERE Rollback_id=@RollbackID


