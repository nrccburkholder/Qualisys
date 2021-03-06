/****** Object:  StoredProcedure [dbo].[update_Surveys]    Script Date: 08/09/2006 09:09:26 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Surveys]
GO
/****** Object:  StoredProcedure [dbo].[update_Surveys]    Script Date: 08/09/2006 09:09:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE update_Surveys
	(@SurveyID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](1000),
	 @Active 	[tinyint])

AS UPDATE [QMS].[dbo].[Surveys] 

SET  	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [Active]	 = @Active 

WHERE 
	( [SurveyID]	 = @SurveyID)



' 
END
GO
