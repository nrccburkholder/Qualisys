/****** Object:  StoredProcedure [dbo].[insert_AnswerCategories]    Script Date: 08/09/2006 16:29:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_AnswerCategories]
GO
/****** Object:  StoredProcedure [dbo].[insert_AnswerCategories]    Script Date: 08/09/2006 16:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_AnswerCategories]
	(@AnswerCategoryID 	[int] OUTPUT,
	 @QuestionID 	[int],
	 @AnswerValue 	[int],
	 @AnswerText 	[varchar](1000),
	 @AnswerCategoryTypeID 	[int])

AS 
BEGIN
INSERT INTO [QMS].[dbo].[AnswerCategories] 
	 ( [QuestionID],
	 [AnswerValue],
	 [AnswerText],
	 [AnswerCategoryTypeID]) 
 
VALUES 
	( @QuestionID,
	 @AnswerValue,
	 @AnswerText,
	 @AnswerCategoryTypeID)

SET @AnswerCategoryID = @@IDENTITY
 
END




' 
END
GO
