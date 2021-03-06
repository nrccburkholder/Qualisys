/****** Object:  StoredProcedure [dbo].[delete_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 14:30:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_SurveyInstanceDefaultScripts]
GO
/****** Object:  StoredProcedure [dbo].[delete_SurveyInstanceDefaultScripts]    Script Date: 08/09/2006 14:30:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyInstanceDefaultScripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [delete_SurveyInstanceDefaultScripts]
	(@SurveyInstanceScriptID 	[int])

AS DELETE [QMS].[dbo].[SurveyInstanceDefaultScripts] 

WHERE 
	( [SurveyInstanceScriptID]	 = @SurveyInstanceScriptID)

' 
END
GO
