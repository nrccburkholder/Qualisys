/****** Object:  StoredProcedure [dbo].[insert_Triggers]    Script Date: 08/09/2006 16:47:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Triggers]
GO
/****** Object:  StoredProcedure [dbo].[insert_Triggers]    Script Date: 08/09/2006 16:47:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [insert_Triggers]
	(@TriggerID 	[int] output,
	 @TriggerTypeID 	[int],
	 @SurveyID 	[int],
	 @TriggerName 	[varchar](100),
	 @CriteriaID 	[int],
	 @TheCode 	[varchar](8000),
	 @PerodicyDate 	[datetime],
	 @PerodicyNextDate 	[datetime])

AS 
BEGIN

INSERT INTO [QMS].[dbo].[Triggers] 
	 ( 
	 [TriggerTypeID],
	 [SurveyID],
	 [TriggerName],
	 [CriteriaID],
	 [TheCode],
	 [PerodicyDate],
	 [PerodicyNextDate]) 
 
VALUES 
	( @TriggerTypeID,
	 @SurveyID,
	 @TriggerName,
	 @CriteriaID,
	 @TheCode,
	 @PerodicyDate,
	 @PerodicyNextDate)

SET @TriggerID = @@IDENTITY

END


' 
END
GO
