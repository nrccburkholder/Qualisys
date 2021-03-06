/****** Object:  StoredProcedure [dbo].[update_ScriptScreens]    Script Date: 08/09/2006 09:10:36 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScriptScreens]
GO
/****** Object:  StoredProcedure [dbo].[update_ScriptScreens]    Script Date: 08/09/2006 09:10:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_ScriptScreens]
	(@ScriptScreenID 	[int],
	 @ScriptID 	[int],
	 @SurveyQuestionID 	[int],
	 @Title 	[varchar](100),
	 @Text 	[varchar](4000),
	 @CalculationTypeID 	[int],
	 @ItemOrder 	[int])

AS UPDATE [QMS].[dbo].[ScriptScreens] 

SET  	 [ScriptID]	 = @ScriptID,
	 [SurveyQuestionID]	 = @SurveyQuestionID,
	 [Title]	 = @Title,
	 [Text]	 = @Text,
	 [CalculationTypeID]	 = @CalculationTypeID,
	 [ItemOrder]	 = @ItemOrder 

WHERE 
	( [ScriptScreenID]	 = @ScriptScreenID)



' 
END
GO
