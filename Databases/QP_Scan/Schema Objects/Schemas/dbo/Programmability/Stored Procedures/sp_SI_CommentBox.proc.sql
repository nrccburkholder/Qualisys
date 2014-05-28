CREATE PROCEDURE sp_SI_CommentBox
    @QuestionFormID int,
    @intDODSurvey   int
AS

SELECT CLP.QuestionForm_ID,
       CLP.intPage_Num,
       CLP.CmntBox_Id,
       COUNT(CLP.intLine_Num) as numLines,
       CASE WHEN CLP.intpage_num=2 and @intDODSurvey = 1 then MIN(CP.X_Pos)-5100 else MIN(CP.X_Pos) end as X1,
       MIN(CP.Y_Pos) AS Y1,
       CASE WHEN CLP.intpage_num=2 and @intDODSurvey = 1 then MIN(CP.X_Pos + CP.intWidth)-5100 else MIN(CP.X_Pos + CP.intWidth) end AS X2,
       MIN(CP.Y_Pos + CP.intHeight) AS Y2
FROM CommentPos CP,
     CommentLinePos CLP
WHERE CP.QuestionForm_Id = CLP.QuestionForm_Id
  AND CP.SampleUnit_Id   = CLP.SampleUnit_Id
  AND CP.IntPage_Num     = CLP.IntPage_Num
  AND CP.CmntBox_Id      = CLP.CmntBox_Id
  AND CLP.QuestionForm_id = @QuestionFormID
GROUP BY CLP.QuestionForm_id, CLP.IntPage_Num, CLP.CmntBox_Id


