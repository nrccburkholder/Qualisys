/****** Object:  StoredProcedure [dbo].[set_CATISurveyDateProperty]    Script Date: 08/10/2006 10:08:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_CATISurveyDateProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[set_CATISurveyDateProperty]
GO
/****** Object:  StoredProcedure [dbo].[set_CATISurveyDateProperty]    Script Date: 08/10/2006 10:08:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[set_CATISurveyDateProperty]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[set_CATISurveyDateProperty] 
(
	@RespondentID int
)
AS
BEGIN

DECLARE @SurveyDate datetime
DECLARE @SURVEY_DATE_CODE varchar(100)
SET @SURVEY_DATE_CODE = ''SURVEY_DATE''

SET SELECT @SurveyDate = EventDate FROM EventLog WHERE EventLogID = (SELECT MAX(EventLogID) FROM EventLog WHERE RespondentID = @RespondentID AND EventID IN (2030, 2032, 2040, 2031, 2033, 2041))

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
