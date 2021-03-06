/****** Object:  StoredProcedure [dbo].[set_DefaultScript]    Script Date: 08/09/2006 12:58:54 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_DefaultScript]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[set_DefaultScript]
GO
/****** Object:  StoredProcedure [dbo].[set_DefaultScript]    Script Date: 08/09/2006 12:58:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_DefaultScript]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[set_DefaultScript]
(
	@ScriptID int
) AS
BEGIN
	DECLARE @ScriptTypeID int
	DECLARE @SurveyID int
	SET SELECT @ScriptTypeID =  ScriptTypeID, @SurveyID = SurveyID FROM Scripts WHERE ScriptID =@ScriptID

	UPDATE Scripts SET DefaultScript = 0 WHERE ScriptTypeID = @ScriptTypeID AND SurveyID = @SurveyID AND ScriptID <> @ScriptID

END

' 
END
GO
