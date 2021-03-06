/****** Object:  StoredProcedure [dbo].[delete_Scripts]    Script Date: 08/09/2006 14:29:25 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Scripts]
GO
/****** Object:  StoredProcedure [dbo].[delete_Scripts]    Script Date: 08/09/2006 14:29:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Scripts]
	(@ScriptID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[ScriptScreenCategories] 
WHERE 
	([ScriptScreenID] IN 
		(SELECT [ScriptScreenID] FROM ScriptScreens 
			WHERE ( [ScriptID] = @ScriptID)
		)
	)

DELETE [QMS].[dbo].[ScriptScreens] 
WHERE 
	( [ScriptID]	 = @ScriptID)

DELETE [QMS].[dbo].[Scripts] 
WHERE 
	( [ScriptID]	 = @ScriptID)

END

' 
END
GO
