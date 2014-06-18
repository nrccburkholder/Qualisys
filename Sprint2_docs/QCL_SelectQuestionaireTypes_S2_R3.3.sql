USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionaireTypes]    Script Date: 6/17/2014 1:52:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectQuestionaireTypes] 
@surveytypeid int,
@questionairetypeid int = 0
AS

If @questionairetypeid = 0
BEGIN
	SELECT q1.QuestionaireType_ID, q1.SurveyType_ID, q1.[Description]
	FROM QuestionaireTypes q1
	WHERE q1.SurveyType_ID = @surveytypeid
	AND q1.QuestionaireType_ID IS NULL
END
ELSE
BEGIN
	SELECT QuestionaireType_ID, SurveyType_ID, [Description]
	FROM QuestionaireTypes
	WHERE QuestionaireType_ID = @questionairetypeid
END

