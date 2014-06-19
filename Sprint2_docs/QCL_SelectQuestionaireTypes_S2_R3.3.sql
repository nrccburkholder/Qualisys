USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionaireTypes]    Script Date: 6/19/2014 10:51:33 AM ******/
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
END
ELSE
BEGIN
	SELECT QuestionaireType_ID, SurveyType_ID, [Description]
	FROM QuestionaireTypes
	WHERE QuestionaireType_ID = @questionairetypeid
END




