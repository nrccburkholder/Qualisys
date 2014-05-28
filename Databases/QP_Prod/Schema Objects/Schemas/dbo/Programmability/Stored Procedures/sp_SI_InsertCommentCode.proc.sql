CREATE PROCEDURE sp_SI_InsertCommentCode 
    @CmntID   int,
    @CmntCode int

AS

--Insert the code record
INSERT INTO CommentSelCodes ( Cmnt_id, CmntCode_id )
VALUES (@CmntID, @CmntCode)


