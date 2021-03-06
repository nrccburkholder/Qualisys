/****** Object:  StoredProcedure [dbo].[insert_Scripts]    Script Date: 08/09/2006 16:39:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Scripts]
GO
/****** Object:  StoredProcedure [dbo].[insert_Scripts]    Script Date: 08/09/2006 16:39:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [insert_Scripts]
	(@ScriptID 	[int] OUTPUT,
	 @SurveyID 	[int],
	 @ScriptTypeID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](1000),
	 @CompletenessLevel 	[decimal],
	 @FollowSkips 	[tinyint],
	 @CalcCompleteness 	[tinyint],
	 @DefaultScript 	[tinyint])

AS
BEGIN

INSERT INTO [QMS].[dbo].[Scripts] 
	 ( [SurveyID],
	 [ScriptTypeID],
	 [Name],
	 [Description],
	 [CompletenessLevel],
	 [FollowSkips],
	 [CalcCompleteness],
	 [DefaultScript]) 
 
VALUES 
	( @SurveyID,
	 @ScriptTypeID,
	 @Name,
	 @Description,
	 @CompletenessLevel,
	 @FollowSkips,
	 @CalcCompleteness,
	 @DefaultScript)

SET @ScriptID = @@IDENTITY

IF @DefaultScript = 1 EXEC set_DefaultScript @ScriptID

END

' 
END
GO
