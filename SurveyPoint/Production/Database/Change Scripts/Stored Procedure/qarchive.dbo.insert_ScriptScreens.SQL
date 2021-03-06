/****** Object:  StoredProcedure [dbo].[insert_ScriptScreens]    Script Date: 08/09/2006 16:44:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_ScriptScreens]
GO
/****** Object:  StoredProcedure [dbo].[insert_ScriptScreens]    Script Date: 08/09/2006 16:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptScreens]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_ScriptScreens]
	(@ScriptScreenID 	[int] OUTPUT,
	 @ScriptID 	[int],
	 @SurveyQuestionID 	[int],
	 @Title 	[varchar](100),
	 @Text 	[varchar](4000),
	 @CalculationTypeID 	[int],
	 @ItemOrder 	[int])

AS
BEGIN

INSERT INTO [QMS].[dbo].[ScriptScreens] 
	 ( [ScriptID],
	 [SurveyQuestionID],
	 [Title],
	 [Text],
	 [CalculationTypeID],
	 [ItemOrder]) 
 
VALUES 
	( @ScriptID,
	 @SurveyQuestionID,
	 @Title,
	 @Text,
	 @CalculationTypeID,
	 @ItemOrder)

SET @ScriptScreenID = @@IDENTITY

END




' 
END
GO
