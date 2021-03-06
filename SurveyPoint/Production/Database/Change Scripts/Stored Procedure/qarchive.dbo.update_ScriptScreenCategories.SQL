/****** Object:  StoredProcedure [dbo].[update_ScriptScreenCategories]    Script Date: 08/09/2006 09:14:47 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScriptScreenCategories]
GO
/****** Object:  StoredProcedure [dbo].[update_ScriptScreenCategories]    Script Date: 08/09/2006 09:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_ScriptScreenCategories]
	(@ScriptScreenCategoryID 	[int],
	 @ScriptScreenID 	[int],
	 @AnswerCategoryID 	[int],
	 @JumpToScriptScreenID 	[int],
	 @Text 	[varchar](1000))

AS UPDATE [QMS].[dbo].[ScriptScreenCategories] 

SET  	 [ScriptScreenID]	 = @ScriptScreenID,
	 [AnswerCategoryID]	 = @AnswerCategoryID,
	 [JumpToScriptScreenID]	 = @JumpToScriptScreenID,
	 [Text]	 = @Text 

WHERE 
	( [ScriptScreenCategoryID]	 = @ScriptScreenCategoryID)



' 
END
GO
