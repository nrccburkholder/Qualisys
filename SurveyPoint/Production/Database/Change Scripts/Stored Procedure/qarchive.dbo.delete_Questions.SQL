/****** Object:  StoredProcedure [dbo].[delete_Questions]    Script Date: 08/09/2006 13:54:42 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Questions]
GO
/****** Object:  StoredProcedure [dbo].[delete_Questions]    Script Date: 08/09/2006 13:54:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Questions]
	(@QuestionID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[AnswerCategories] 
WHERE 
	( [QuestionID]	 = @QuestionID)

DELETE [QMS].[dbo].[Questions] 
WHERE 
	( [QuestionID]	 = @QuestionID)


END


' 
END
GO
