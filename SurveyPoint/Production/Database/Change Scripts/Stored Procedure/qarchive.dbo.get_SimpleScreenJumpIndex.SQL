/****** Object:  StoredProcedure [dbo].[get_SimpleScreenJumpIndex]    Script Date: 08/11/2006 13:05:51 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_SimpleScreenJumpIndex]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_SimpleScreenJumpIndex]
GO
/****** Object:  StoredProcedure [dbo].[get_SimpleScreenJumpIndex]    Script Date: 08/11/2006 13:05:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_SimpleScreenJumpIndex]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE  PROCEDURE [dbo].[get_SimpleScreenJumpIndex] 
(
	@RespondentID int,
	@ScriptID int,
	@ScreenIndex int
)  
AS  
BEGIN 
	SET NOCOUNT ON

	DECLARE @JumpIndex int
	SET @JumpIndex = NULL

	SET SELECT  @JumpIndex = MIN(ISNULL(CASE WHEN ssc.JumpToScriptScreenID > 0 THEN jss.ItemOrder ELSE ssc.JumpToScriptScreenID END, 0))
	FROM         ScriptScreenCategories ssc INNER JOIN
	                      Responses r ON ssc.AnswerCategoryID = r.AnswerCategoryID INNER JOIN
	                      ScriptScreens ON ssc.ScriptScreenID = ScriptScreens.ScriptScreenID LEFT OUTER JOIN
	                      ScriptScreens jss ON ssc.JumpToScriptScreenID = jss.ScriptScreenID
	WHERE     (ssc.JumpToScriptScreenID <> 0) AND (r.RespondentID = @RespondentID) AND (ScriptScreens.ScriptID = @ScriptID) AND (ScriptScreens.ItemOrder = @ScreenIndex)
	
	PRINT @JumpIndex

	IF @JumpIndex IS NULL SET @JumpIndex = 0
	ELSE IF @JumpIndex = -999 
		BEGIN
		SET SELECT @JumpIndex = COUNT(*) + 1 FROM ScriptScreens WHERE ScriptID = @ScriptID
		END

	SELECT @JumpIndex

	SET NOCOUNT OFF

END



' 
END
GO
GRANT EXECUTE ON [dbo].[get_SimpleScreenJumpIndex] TO [reporter]
GO
