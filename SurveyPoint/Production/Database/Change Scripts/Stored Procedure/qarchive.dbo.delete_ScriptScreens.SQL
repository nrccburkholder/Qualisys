/****** Object:  StoredProcedure [dbo].[delete_ScriptScreens]    Script Date: 08/09/2006 14:29:48 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_ScriptScreens]
GO
/****** Object:  StoredProcedure [dbo].[delete_ScriptScreens]    Script Date: 08/09/2006 14:29:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_ScriptScreens]
	(@ScriptScreenID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[ScriptScreenCategories] 
WHERE 
	( [ScriptScreenID]	 = @ScriptScreenID)

DELETE [QMS].[dbo].[ScriptScreens] 
WHERE 
	( [ScriptScreenID]	 = @ScriptScreenID)

END

' 
END
GO
