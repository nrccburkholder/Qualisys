/****** Object:  StoredProcedure [dbo].[delete_AnswerCategories]    Script Date: 08/09/2006 13:38:48 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_AnswerCategories]
GO
/****** Object:  StoredProcedure [dbo].[delete_AnswerCategories]    Script Date: 08/09/2006 13:38:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_AnswerCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_AnswerCategories]
	(@AnswerCategoryID 	[int])

AS DELETE [QMS].[dbo].[AnswerCategories] 

WHERE 
	( [AnswerCategoryID]	 = @AnswerCategoryID)



' 
END
GO
