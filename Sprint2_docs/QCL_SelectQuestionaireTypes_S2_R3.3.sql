USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectQuestionaireTypes]    Script Date: 6/17/2014 1:52:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QCL_SelectQuestionaireTypes] 
@surveytypeid int 
AS
SELECT QuestionaireType_id 'Id', [Description]
FROM QuestionaireTypes
WHERE SurveyType_ID = @surveytypeid
