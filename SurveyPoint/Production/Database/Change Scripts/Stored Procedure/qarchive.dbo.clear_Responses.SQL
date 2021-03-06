/****** Object:  StoredProcedure [dbo].[clear_Responses]    Script Date: 08/08/2006 15:58:00 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clear_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[clear_Responses]
GO
/****** Object:  StoredProcedure [dbo].[clear_Responses]    Script Date: 08/08/2006 15:58:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[clear_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[clear_Responses] 
(
	@RespondentID int
)
AS
DELETE FROM Responses 
	WHERE RespondentID = @RespondentID 
	AND EXISTS 
		(SELECT 1 FROM AnswerCategories ac 
		WHERE (Responses.AnswerCategoryID = ac.AnswerCategoryID) 
		AND (ac.AnswerCategoryTypeID <> 7))



' 
END
GO
