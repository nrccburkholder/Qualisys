/****** Object:  StoredProcedure [dbo].[update_Protocols]    Script Date: 08/09/2006 10:19:14 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Protocols]
GO
/****** Object:  StoredProcedure [dbo].[update_Protocols]    Script Date: 08/09/2006 10:19:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_Protocols]
	(@ProtocolID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @CreatedByUserID 	[int])

AS UPDATE [QMS].[dbo].[Protocols] 

SET  	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [CreatedByUserID]	 = @CreatedByUserID 

WHERE 
	( [ProtocolID]	 = @ProtocolID)



' 
END
GO
