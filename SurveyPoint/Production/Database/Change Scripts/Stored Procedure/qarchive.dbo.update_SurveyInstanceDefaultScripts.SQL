/****** Object:  StoredProcedure [dbo].[update_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 09:10:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_SurveyInstanceDefaultScripts]
GO
/****** Object:  StoredProcedure [dbo].[update_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 09:10:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [update_SurveyInstanceDefaultScripts]
	(@SurveyInstanceScriptID 	[int],
	 @SurveyInstanceID 	[int],
	 @ScriptTypeID 	[int],
	 @ScriptID 	[int])

AS UPDATE [QMS].[dbo].[SurveyInstanceDefaultScripts] 

SET   [SurveyInstanceID]	 = @SurveyInstanceID,
	 [ScriptTypeID]	 = @ScriptTypeID,
	 [ScriptID]	 = @ScriptID 

WHERE 
	( [SurveyInstanceScriptID]	 = @SurveyInstanceScriptID)

' 
END
GO
