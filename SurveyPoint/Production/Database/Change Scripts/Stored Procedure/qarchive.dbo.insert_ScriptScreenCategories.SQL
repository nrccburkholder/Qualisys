/****** Object:  StoredProcedure [dbo].[insert_ScriptScreenCategories]    Script Date: 08/09/2006 16:43:47 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_ScriptScreenCategories]
GO
/****** Object:  StoredProcedure [dbo].[insert_ScriptScreenCategories]    Script Date: 08/09/2006 16:43:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE PROCEDURE [insert_ScriptScreenCategories]
	(@ScriptScreenCategoryID 	[int] OUTPUT,
	 @ScriptScreenID 	[int],
	 @AnswerCategoryID 	[int],
	 @JumpToScriptScreenID 	[int],
	 @Text 	[varchar](1000))

AS 
BEGIN

INSERT INTO [QMS].[dbo].[ScriptScreenCategories] 
	 ( [ScriptScreenID],
	 [AnswerCategoryID],
	 [JumpToScriptScreenID],
	 [Text]) 
 
VALUES 
	( @ScriptScreenID,
	 @AnswerCategoryID,
	 @JumpToScriptScreenID,
	 @Text)

SET @ScriptScreenCategoryID = @@IDENTITY

END




' 
END
GO
