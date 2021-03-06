/****** Object:  StoredProcedure [dbo].[update_AnswerCategories]    Script Date: 08/09/2006 12:54:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_AnswerCategories]
GO
/****** Object:  StoredProcedure [dbo].[update_AnswerCategories]    Script Date: 08/09/2006 12:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_AnswerCategories]
	(@AnswerCategoryID 	[int],
	 @QuestionID 	[int],
	 @AnswerValue 	[int],
	 @AnswerText 	[varchar](1000),
	 @AnswerCategoryTypeID 	[int])

AS UPDATE [QMS].[dbo].[AnswerCategories] 

SET  	 [QuestionID]	 = @QuestionID,
	 [AnswerValue]	 = @AnswerValue,
	 [AnswerText]	 = @AnswerText,
	 [AnswerCategoryTypeID]	 = @AnswerCategoryTypeID 

WHERE 
	( [AnswerCategoryID]	 = @AnswerCategoryID)



' 
END
GO
