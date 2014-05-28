CREATE PROCEDURE sp_SI_InsertComment 
    @CmntType       int,
    @CmntValence    int,
    @SampleUnitID   int,
    @QstnCore       int,
    @QuestionFormID int,
    @BatchNumber    varchar(40),
    @LineNumber     int,
    @CmntOrHand     char(1),
    @CmntText1      varchar(6000),
    @CmntText2      varchar(6000),
    @CmntID         int OUTPUT

AS

--Declare the required variable
DECLARE @TextPtr varbinary(16)

--Insert the record with the first chunck of the comment
BEGIN TRAN  --** Added 01-22-02 JJF - To fix trigger problem with @@IDENTITY
INSERT INTO Comments (
        CmntType_id, CmntValence_id, SampleUnit_id, QstnCore, 
        QuestionForm_id, strVSTRBatchNumber, intVSTRLineNumber, 
        strCmntOrHand, strCmntText, datEntered ) 
VALUES (@CmntType, @CmntValence, @SampleUnitID, @QstnCore, 
        @QuestionFormID, @BatchNumber, @LineNumber, 
        @CmntOrHand, @CmntText1, GetDate())

--Save the CmntID
--** Modified 01-22-02 JJF - To fix trigger problem with @@IDENTITY
--SET @CmntID = @@IDENTITY
SELECT @CmntID = MAX(Cmnt_id) FROM Comments
COMMIT TRAN
--** End of modification 01-22-02 JJF

--Get the text pointer for the text column
SELECT @TextPtr=TEXTPTR(strCmntText) 
FROM Comments (UPDLOCK) 
WHERE Cmnt_id = @CmntID

--Append the remaining chunck of the comment
UPDATETEXT Comments.strCmntText @TextPtr NULL NULL WITH LOG @CmntText2


