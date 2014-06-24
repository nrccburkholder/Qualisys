USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionnaireTypes]    Script Date: 6/17/2014 1:52:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectQuestionnaireTypes] 
@surveytypeid int,
@questionnairetypeid int 
AS

IF @questionnairetypeid = 0 
BEGIN
	SELECT SurveyType_ID, QuestionnaireType_id , [Description]
	FROM QuestionnaireTypes
	WHERE SurveyType_ID = @surveytypeid
END
ELSE
BEGIN

	SELECT SurveyType_ID, QuestionnaireType_id , [Description]
	FROM QuestionnaireTypes
	WHERE QuestionnaireType_ID = @questionnairetypeid
END


