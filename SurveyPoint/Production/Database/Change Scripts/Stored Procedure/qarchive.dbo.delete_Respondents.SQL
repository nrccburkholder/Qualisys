/****** Object:  StoredProcedure [dbo].[delete_Respondents]    Script Date: 08/09/2006 14:28:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Respondents]
GO
/****** Object:  StoredProcedure [dbo].[delete_Respondents]    Script Date: 08/09/2006 14:28:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE delete_Respondents
	(@RespondentID 	[int])

AS 
BEGIN

DELETE [QMS].[dbo].[EventLog]
WHERE 
	( [RespondentID]	 = @RespondentID)

DELETE [QMS].[dbo].[RespondentProperties]
WHERE 
	( [RespondentID]	 = @RespondentID)

DELETE [QMS].[dbo].[Respondents] 
WHERE 
	( [RespondentID]	 = @RespondentID)
	
END




' 
END
GO
