/****** Object:  StoredProcedure [dbo].[delete_Surveys]    Script Date: 08/09/2006 14:30:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Surveys]
GO
/****** Object:  StoredProcedure [dbo].[delete_Surveys]    Script Date: 08/09/2006 14:30:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Surveys]
	(@SurveyID 	[int])

AS DELETE [QMS].[dbo].[Surveys] 

WHERE 
	( [SurveyID]	 = @SurveyID)



' 
END
GO
