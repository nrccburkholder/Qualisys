/****** Object:  StoredProcedure [dbo].[delete_SurveyQuestions]    Script Date: 08/09/2006 14:30:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_SurveyQuestions]
GO
/****** Object:  StoredProcedure [dbo].[delete_SurveyQuestions]    Script Date: 08/09/2006 14:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_SurveyQuestions]
	(@SurveyQuestionID 	[int])

AS DELETE [QMS].[dbo].[SurveyQuestions] 

WHERE 
	( [SurveyQuestionID]	 = @SurveyQuestionID)



' 
END
GO
