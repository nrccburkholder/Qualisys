/****** Object:  StoredProcedure [dbo].[hos2004_SurveyDate]    Script Date: 08/09/2006 16:27:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[hos2004_SurveyDate]
GO
/****** Object:  StoredProcedure [dbo].[hos2004_SurveyDate]    Script Date: 08/09/2006 16:27:39 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[hos2004_SurveyDate]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[hos2004_SurveyDate] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN

DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID = 3040 AND EventParameters LIKE ''hos2004_SurveyDate:%''

DECLARE @SURVEY_DATE_CODE varchar(100)
SET @SURVEY_DATE_CODE = ''SURVEY_DATE''
DECLARE @SurveyDate datetime
SET @SurveyDate = NULL

-- Mailing
IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''M10'', ''M11'', ''M31'') 
  BEGIN
	SET SELECT @SurveyDate = EventDate FROM EventLog WHERE (RespondentID = @RespondentID) AND (EventID = 2006)
	
    IF (@SurveyDate = NULL)
      BEGIN
        EXEC insert_EventLog @EventLogID = NULL, @EventID = 3040, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = ''hos2004_SurveyDate: Missing batch code, unable to determine survey date.''
		RETURN
		
      END
	  
  END

-- Telephone
ELSE IF dbo.GetRespondentPropertyValue(@RespondentID, ''SURVEY_DISPOSITION'') IN (''T10'', ''T11'', ''T31'') 
  BEGIN
	SET SELECT @SurveyDate = EventDate FROM EventLog 
		WHERE EventLogID = (SELECT MAX(EventLogID) FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2030, 2032, 2040, 2031, 2033, 2041))

  END

-- Non-completion
ELSE
  BEGIN
	EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DATE_CODE, ''99999999''
	RETURN
	
  END
	
IF @SurveyDate IS NOT NULL
  BEGIN
    DECLARE @DateValue varchar(10)
    SET @DateValue = SUBSTRING(ISNULL(CONVERT(varchar(8), @SurveyDate, 112), ''''), 5, 4) + SUBSTRING(ISNULL(CONVERT(varchar(8), @SurveyDate, 112), ''''), 1, 4) 
    EXEC dbo.spSetRespondentProperty @RespondentID, @SURVEY_DATE_CODE, @DateValue 

  END

END
' 
END
GO
GRANT EXECUTE ON [dbo].[hos2004_SurveyDate] TO [reporter]
GO
