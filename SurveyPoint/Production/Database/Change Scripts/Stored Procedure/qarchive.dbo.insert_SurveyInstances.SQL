/****** Object:  StoredProcedure [dbo].[insert_SurveyInstances]    Script Date: 08/09/2006 16:45:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_SurveyInstances]
GO
/****** Object:  StoredProcedure [dbo].[insert_SurveyInstances]    Script Date: 08/09/2006 16:45:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'







CREATE PROCEDURE insert_SurveyInstances
	(@SurveyInstanceID 	[int] OUTPUT,
	 @SurveyID 	[int],
	 @ClientID 	[int],
	 @ProtocolID 	[int],
	 @Name 	[varchar](100),
	 @InstanceDate 	[datetime],
	 @StartDate 	[datetime],
	 @Active 	[tinyint],
	 @GroupByHousehold 	[tinyint],
	 @SurveyName [varchar](100) OUTPUT,
	 @ClientName [varchar](100) OUTPUT, 
	 @SurveyInstanceCategoryID [int] = null, 
	 @QuarterEnding [datetime] = null)
	 
AS 
BEGIN

INSERT INTO [SurveyInstances] 
	 ( [SurveyID],
	 [ClientID],
	 [ProtocolID],
	 [Name],
	 [InstanceDate],
	 [StartDate],
	 [Active],
	 [GroupByHousehold],
	 [SurveyInstanceCategoryID],
	 [QuarterEnding]) 
 
VALUES 
	( @SurveyID,
	 @ClientID,
	 @ProtocolID,
	 @Name,
	 @InstanceDate,
	 @StartDate,
	 @Active,
	 @GroupByHousehold,
	 @SurveyInstanceCategoryID, 
	 @QuarterEnding)

SET @SurveyInstanceID = @@IDENTITY

SELECT @SurveyName = SurveyName, @ClientName = ClientName FROM vr_SurveyInstances
       WHERE SurveyInstanceID = @SurveyInstanceID

--Insert initial survey instance events, remove this after switching to protocol events
INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours)
SELECT     @SurveyInstanceID, EventID, EventID, FinalCode, DefaultNonContact
FROM         Events
WHERE     (EventTypeID IN (3, 4, 5))

END

' 
END
GO
