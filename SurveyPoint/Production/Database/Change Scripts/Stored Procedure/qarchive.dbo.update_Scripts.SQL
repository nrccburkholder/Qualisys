/****** Object:  StoredProcedure [dbo].[update_Scripts]    Script Date: 08/09/2006 09:15:10 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Scripts]
GO
/****** Object:  StoredProcedure [dbo].[update_Scripts]    Script Date: 08/09/2006 09:15:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_Scripts]
	(@ScriptID 	[int],
	 @SurveyID 	[int],
	 @ScriptTypeID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](1000),
	 @CompletenessLevel 	[decimal],
	 @FollowSkips 	[tinyint],
	 @CalcCompleteness 	[tinyint],
	 @DefaultScript0 	[tinyint])

AS UPDATE [QMS].[dbo].[Scripts] 

SET  	 [SurveyID]	 = @SurveyID,
	 [ScriptTypeID]	 = @ScriptTypeID,
	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [CompletenessLevel]	 = @CompletenessLevel,
	 [FollowSkips]	 = @FollowSkips,
	 [CalcCompleteness]	 = @CalcCompleteness,
	 [DefaultScript]	 = @DefaultScript0 

WHERE 
	( [ScriptID]	 = @ScriptID)


IF @DefaultScript0 = 1 EXEC set_DefaultScript @ScriptID

' 
END
GO
