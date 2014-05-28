CREATE PROCEDURE [dbo].[QSL_SaveQuestionResultToQualiSys]
@QuestionFormID INT,
@SampleUnitID INT,
@QstnCore INT,
@ResponseVal INT
AS

SET NOCOUNT ON

INSERT INTO QuestionResult (QuestionForm_Id, SampleUnit_Id, QstnCore, intResponseVal) 
VALUES (@QuestionFormID, @SampleUnitID, @QstnCore, @ResponseVal)

SET NOCOUNT OFF


