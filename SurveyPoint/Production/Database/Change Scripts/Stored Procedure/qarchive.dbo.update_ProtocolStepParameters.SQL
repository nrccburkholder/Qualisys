/****** Object:  StoredProcedure [dbo].[update_ProtocolStepParameters]    Script Date: 08/09/2006 10:19:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ProtocolStepParameters]
GO
/****** Object:  StoredProcedure [dbo].[update_ProtocolStepParameters]    Script Date: 08/09/2006 10:19:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_ProtocolStepParameters]
	(@ProtocolStepParamID 	[int],
	 @ProtocolStepID 	[int],
	 @ProtocolStepTypeParamID 	[int],
	 @ProtocolStepParamValue 	[varchar](100))

AS UPDATE [QMS].[dbo].[ProtocolStepParameters] 

SET  	 [ProtocolStepID]	 = @ProtocolStepID,
	 [ProtocolStepTypeParamID]	 = @ProtocolStepTypeParamID,
	 [ProtocolStepParamValue]	 = @ProtocolStepParamValue 

WHERE 
	( [ProtocolStepParamID]	 = @ProtocolStepParamID)



' 
END
GO
