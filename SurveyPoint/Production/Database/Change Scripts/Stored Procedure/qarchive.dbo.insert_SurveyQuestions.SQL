/****** Object:  StoredProcedure [dbo].[insert_SurveyQuestions]    Script Date: 08/09/2006 16:45:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_SurveyQuestions]
GO
/****** Object:  StoredProcedure [dbo].[insert_SurveyQuestions]    Script Date: 08/09/2006 16:45:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE insert_SurveyQuestions
	(@SurveyQuestionID [int] output,
	 @SurveyID 	[int],
	 @QuestionID 	[int],
	 @DisplayNumber 	[varchar](50),
	 @ItemOrder 	[int])

AS
BEGIN

INSERT INTO [QMS].[dbo].[SurveyQuestions] 
	 ([SurveyID],
	 [QuestionID],
	 [DisplayNumber],
	 [ItemOrder]) 
 
VALUES 
	(@SurveyID,
	 @QuestionID,
	 @DisplayNumber,
	 @ItemOrder)

SELECT @SurveyQuestionID = @@IDENTITY

END



' 
END
GO
