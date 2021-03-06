/****** Object:  StoredProcedure [dbo].[update_Triggers]    Script Date: 08/09/2006 08:54:46 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Triggers]
GO
/****** Object:  StoredProcedure [dbo].[update_Triggers]    Script Date: 08/09/2006 08:54:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [update_Triggers]
	(@TriggerID 	[int],
	 @TriggerTypeID 	[int],
	 @SurveyID 	[int],
	 @TriggerName 	[varchar](100),
	 @CriteriaID 	[int],
	 @TheCode 	[varchar](8000),
	 @PerodicyDate 	[datetime],
	 @PerodicyNextDate 	[datetime])

AS UPDATE [QMS].[dbo].[Triggers] 

SET	[TriggerTypeID]	 = @TriggerTypeID,
	 [SurveyID]	 = @SurveyID,
	 [TriggerName]	 = @TriggerName,
	 [CriteriaID]	 = @CriteriaID,
	 [TheCode]	 = @TheCode,
	 [PerodicyDate]	 = @PerodicyDate,
	 [PerodicyNextDate]	 = @PerodicyNextDate 

WHERE 
	( [TriggerID]	 = @TriggerID)



' 
END
GO
