/****** Object:  StoredProcedure [dbo].[update_SurveyInstances]    Script Date: 08/09/2006 09:10:13 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_SurveyInstances]
GO
/****** Object:  StoredProcedure [dbo].[update_SurveyInstances]    Script Date: 08/09/2006 09:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SurveyInstances]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'







CREATE PROCEDURE update_SurveyInstances
	(@SurveyInstanceID 	[int],
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

UPDATE [SurveyInstances] 

SET  	 [SurveyID]	 = @SurveyID,
	 [ClientID]	 = @ClientID,
	 [ProtocolID]	 = @ProtocolID,
	 [Name]	 = @Name,
	 [InstanceDate]	 = @InstanceDate,
	 [StartDate]	 = @StartDate,
	 [Active]	 = @Active,
	 [GroupByHousehold]	 = @GroupByHousehold, 
	[SurveyInstanceCategoryID] = @SurveyInstanceCategoryID, 
	[QuarterEnding] = @QuarterEnding

WHERE 
	( [SurveyInstanceID]	 = @SurveyInstanceID)

SELECT @SurveyName = SurveyName, @ClientName = ClientName FROM vr_SurveyInstances
       WHERE SurveyInstanceID = @SurveyInstanceID

END

' 
END
GO
