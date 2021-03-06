/****** Object:  StoredProcedure [dbo].[insert_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 16:45:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_SurveyInstanceDefaultScripts]
GO
/****** Object:  StoredProcedure [dbo].[insert_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 16:45:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [insert_SurveyInstanceDefaultScripts]
	(@SurveyInstanceScriptID 	[int] output,
	 @SurveyInstanceID 	[int],
	 @ScriptTypeID 	[int],
	 @ScriptID 	[int])

AS 
BEGIN

INSERT INTO [QMS].[dbo].[SurveyInstanceDefaultScripts] 
	 ( [SurveyInstanceID],
	 [ScriptTypeID],
	 [ScriptID]) 
 
VALUES 
	( @SurveyInstanceID,
	 @ScriptTypeID,
	 @ScriptID)

SET @SurveyInstanceScriptID = @@IDENTITY

END

' 
END
GO
