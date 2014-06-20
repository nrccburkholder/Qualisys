USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionnaireTypes]    Script Date: 6/19/2014 10:51:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectQuestionnaireTypes] 
@surveytypeid int,
@questionnairetypeid int = 0
AS

If @questionnairetypeid = 0
BEGIN
	SELECT q1.QuestionnaireType_ID, q1.SurveyType_ID, q1.[Description]
	FROM QuestionnaireTypes q1
	WHERE q1.SurveyType_ID = @surveytypeid
END
ELSE
BEGIN
	SELECT QuestionnaireType_ID, SurveyType_ID, [Description]
	FROM QuestionnaireTypes
	WHERE QuestionnaireType_ID = @questionnairetypeid
END



