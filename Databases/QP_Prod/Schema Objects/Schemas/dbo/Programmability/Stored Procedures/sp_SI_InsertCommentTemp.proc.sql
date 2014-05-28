CREATE PROCEDURE sp_SI_InsertCommentTemp 
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
    @CmntTextUM1    varchar(6000),
    @CmntTextUM2    varchar(6000),
    @CmntID         int OUTPUT

AS

--Declare the required variable
DECLARE @TextPtr1 varbinary(16)
DECLARE @TextPtr2 varbinary(16)

--Insert the record with the first chunck of the comment
BEGIN TRAN
INSERT INTO Comments (
        CmntType_id, CmntValence_id, SampleUnit_id, QstnCore, 
        QuestionForm_id, strVSTRBatchNumber, intVSTRLineNumber, 
        strCmntOrHand, strCmntText, strCmntTextUM, datEntered ) 
VALUES (@CmntType, @CmntValence, @SampleUnitID, @QstnCore, 
        @QuestionFormID, @BatchNumber, @LineNumber, 
        @CmntOrHand, @CmntText1, @CmntTextUM1, '08/02/2002 20:00')

--Save the CmntID
SELECT @CmntID = MAX(Cmnt_id) FROM Comments
COMMIT TRAN

--Get the text pointer for the text column
SELECT @TextPtr1=TEXTPTR(strCmntText), @TextPtr2=TEXTPTR(strCmntTextUM) 
FROM Comments (UPDLOCK) 
WHERE Cmnt_id = @CmntID

--Append the remaining chunck of the comment
UPDATETEXT Comments.strCmntText @TextPtr1 NULL NULL WITH LOG @CmntText2
UPDATETEXT Comments.strCmntTextUM @TextPtr2 NULL NULL WITH LOG @CmntTextUM2


