/****** Object:  StoredProcedure [dbo].[delete_Protocols]    Script Date: 08/09/2006 13:40:28 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Protocols]
GO
/****** Object:  StoredProcedure [dbo].[delete_Protocols]    Script Date: 08/09/2006 13:40:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE delete_Protocols
	(@ProtocolID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[ProtocolStepParameters] 
WHERE 
	( [ProtocolStepID]	IN 
		(SELECT [ProtocolStepID] FROM 
			[QMS].[dbo].[ProtocolSteps] 
			WHERE 
				( [ProtocolID]	 = @ProtocolID)
		)
	)
	
DELETE [QMS].[dbo].[ProtocolSteps] 
WHERE 
	( [ProtocolID]	 = @ProtocolID)

DELETE [QMS].[dbo].[Protocols] 
WHERE 
	( [ProtocolID]	 = @ProtocolID)

END

' 
END
GO
