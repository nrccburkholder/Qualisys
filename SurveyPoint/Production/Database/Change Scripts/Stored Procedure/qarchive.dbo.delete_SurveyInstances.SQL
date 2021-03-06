/****** Object:  StoredProcedure [dbo].[delete_SurveyInstances]    Script Date: 08/09/2006 14:30:11 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_SurveyInstances]
GO
/****** Object:  StoredProcedure [dbo].[delete_SurveyInstances]    Script Date: 08/09/2006 14:30:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE delete_SurveyInstances
	(@SurveyInstanceID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[SurveyInstanceEvents]
WHERE 
	( [SurveyInstanceID]	 = @SurveyInstanceID)

DELETE [QMS].[dbo].[Respondents] 
WHERE 
	( [SurveyInstanceID]	 = @SurveyInstanceID AND [MailingSeedFlag] = 1)

DELETE [QMS].[dbo].[SurveyInstanceDefaultScripts] 
WHERE 
	( [SurveyInstanceID]	 = @SurveyInstanceID)

DELETE [QMS].[dbo].[SurveyInstances] 
WHERE 
	( [SurveyInstanceID]	 = @SurveyInstanceID)

END

' 
END
GO
