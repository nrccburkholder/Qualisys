/****** Object:  StoredProcedure [dbo].[delete_ScriptScreenCategories]    Script Date: 08/09/2006 14:29:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_ScriptScreenCategories]
GO
/****** Object:  StoredProcedure [dbo].[delete_ScriptScreenCategories]    Script Date: 08/09/2006 14:29:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptScreenCategories]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_ScriptScreenCategories]
	(@ScriptScreenCategoryID 	[int])

AS DELETE [QMS].[dbo].[ScriptScreenCategories] 

WHERE 
	( [ScriptScreenCategoryID]	 = @ScriptScreenCategoryID)



' 
END
GO
