/****** Object:  StoredProcedure [dbo].[delete_ProtocolStepParameters]    Script Date: 08/09/2006 13:51:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_ProtocolStepParameters]
GO
/****** Object:  StoredProcedure [dbo].[delete_ProtocolStepParameters]    Script Date: 08/09/2006 13:51:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_ProtocolStepParameters]
	(@ProtocolStepParamID 	[int])

AS DELETE [QMS].[dbo].[ProtocolStepParameters] 

WHERE 
	( [ProtocolStepParamID]	 = @ProtocolStepParamID)



' 
END
GO
