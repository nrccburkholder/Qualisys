/****** Object:  StoredProcedure [dbo].[update_ProtocolSteps]    Script Date: 08/09/2006 10:19:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ProtocolSteps]
GO
/****** Object:  StoredProcedure [dbo].[update_ProtocolSteps]    Script Date: 08/09/2006 10:19:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_ProtocolSteps]
	(@ProtocolStepID 	[int],
	 @ProtocolID 	[int],
	 @Name 	[varchar](100),
	 @ProtocolStepTypeID 	[int],
	 @StartDay 	[int])

AS UPDATE [QMS].[dbo].[ProtocolSteps] 

SET  	 [ProtocolID]	 = @ProtocolID,
	 [Name]	 = @Name,
	 [ProtocolStepTypeID]	 = @ProtocolStepTypeID,
	 [StartDay]	 = @StartDay 

WHERE 
	( [ProtocolStepID]	 = @ProtocolStepID)



' 
END
GO
