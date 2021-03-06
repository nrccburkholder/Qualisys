/****** Object:  StoredProcedure [dbo].[delete_UnverifiedResponses]    Script Date: 08/09/2006 14:31:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UnverifiedResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_UnverifiedResponses]
GO
/****** Object:  StoredProcedure [dbo].[delete_UnverifiedResponses]    Script Date: 08/09/2006 14:31:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UnverifiedResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[delete_UnverifiedResponses] 
(
	@RespondentID int,
	@ScriptID int
)
AS
DELETE FROM Responses 
WHERE     (RespondentID = @RespondentID) AND (NOT EXISTS
                          (SELECT     1
                            FROM          ScriptScreens
                            WHERE      (ScriptID = @ScriptID) 
			AND (SurveyQuestionID IS NOT NULL) 
			AND (Responses.SurveyQuestionID = ScriptScreens.SurveyQuestionID)))
' 
END
GO
