/****** Object:  StoredProcedure [dbo].[insert_RespondentProperties]    Script Date: 08/09/2006 16:33:04 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_RespondentProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_RespondentProperties]
GO
/****** Object:  StoredProcedure [dbo].[insert_RespondentProperties]    Script Date: 08/09/2006 16:33:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_RespondentProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [insert_RespondentProperties]
	(@RespondentPropertyID 	[int] OUTPUT,
	 @RespondentID 	[int],
	 @PropertyName 	[varchar](100),
	 @PropertyValue 	[varchar](100))

AS 
BEGIN

-- check to see if property exists in property table
IF NOT EXISTS (SELECT 1 FROM Properties WHERE PropertyName = @PropertyName)
	INSERT INTO Properties (PropertyName, PropertyLevel)
	VALUES (@PropertyName, 0 )

-- check to see if the survey instance property exists
IF NOT EXISTS (SELECT 1 FROM surveyinstanceProperties sip,respondents r WHERE PropertyName = @PropertyName
              and sip.surveyinstanceid = r.surveyinstanceid
             and r.Respondentid= @RespondentID)
	INSERT INTO surveyInstanceProperties (PropertyName, SurveyInstanceID)
	select @propertyName,surveyInstanceID
	from respondents r
	where r.respondentID= @RespondentID

INSERT INTO [RespondentProperties] 
	 ( [RespondentID],
	 [PropertyName],
	 [PropertyValue]) 
 
VALUES 
	( @RespondentID,
	 @PropertyName,
	 @PropertyValue)

SET @RespondentPropertyID = @@IDENTITY

END


' 
END
GO
