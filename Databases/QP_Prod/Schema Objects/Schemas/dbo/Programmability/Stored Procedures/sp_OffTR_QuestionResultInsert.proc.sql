CREATE PROCEDURE sp_OffTR_QuestionResultInsert
    @intQuestionFormID int,
    @intSampleUnitID   int,
    @intQstnCore       int,
    @intResponseVal    int

AS

INSERT INTO QuestionResult 
       (QuestionForm_Id ,SampleUnit_Id, QstnCore, intResponseVal) 
VALUES (@intQuestionFormID, @intSampleUnitID, @intQstnCore, @intResponseVal)


