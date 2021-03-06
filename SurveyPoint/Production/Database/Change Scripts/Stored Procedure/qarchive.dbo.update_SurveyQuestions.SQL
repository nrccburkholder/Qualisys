/****** Object:  StoredProcedure [dbo].[update_SurveyQuestions]    Script Date: 08/09/2006 09:10:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_SurveyQuestions]
GO
/****** Object:  StoredProcedure [dbo].[update_SurveyQuestions]    Script Date: 08/09/2006 09:10:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_SurveyQuestions]
	(@SurveyQuestionID 	[int],
	 @SurveyID 	[int],
	 @QuestionID 	[int],
	 @DisplayNumber 	[varchar](50),
	 @ItemOrder 	[int])

AS UPDATE [QMS].[dbo].[SurveyQuestions] 

SET  [SurveyID]	 = @SurveyID,
	 [QuestionID]	 = @QuestionID,
	 [DisplayNumber]	 = @DisplayNumber,
	 [ItemOrder]	 = @ItemOrder

WHERE 
	( [SurveyQuestionID]	 = @SurveyQuestionID)



' 
END
GO
