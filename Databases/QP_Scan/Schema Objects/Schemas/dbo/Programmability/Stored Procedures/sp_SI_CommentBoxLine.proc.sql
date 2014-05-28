CREATE PROCEDURE sp_SI_CommentBoxLine
    @QuestionFormID int,
    @PageNo         int,
    @CmntBoxID      int,
    @intDODSurvey   int
AS

SELECT QuestionForm_id,
       intPage_Num,
       intLine_Num,
       cmntBox_Id,
       CASE WHEN intPage_num = 2 and @intDODSurvey = 1 then X_Pos - 5100 else X_Pos end as X1,
       Y_Pos AS Y1,
       CASE WHEN intPage_num = 2 and @intDODSurvey = 1 then X_Pos + intWidth - 5100 else X_Pos + intWidth end AS X2,
       Y_Pos + intHeight AS Y2
FROM  CommentLinePos
WHERE Questionform_id = @QuestionFormID
  AND intPage_Num = @PageNo
  AND cmntBox_id = @CmntBoxID
ORDER BY intLine_Num


