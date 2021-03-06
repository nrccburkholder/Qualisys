/****** Object:  StoredProcedure [dbo].[delete_ProtocolSteps]    Script Date: 08/09/2006 13:52:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_ProtocolSteps]
GO
/****** Object:  StoredProcedure [dbo].[delete_ProtocolSteps]    Script Date: 08/09/2006 13:52:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE delete_ProtocolSteps
	(@ProtocolStepID 	[int])

AS 
BEGIN

DELETE [QMS].[dbo].[ProtocolStepParameters] 
WHERE 
	( [ProtocolStepID]	 = @ProtocolStepID)
	
DELETE [QMS].[dbo].[ProtocolSteps] 
WHERE 
	( [ProtocolStepID]	 = @ProtocolStepID)

END

' 
END
GO
