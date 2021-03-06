/****** Object:  StoredProcedure [dbo].[update_Events]    Script Date: 08/09/2006 12:54:24 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Events]
GO
/****** Object:  StoredProcedure [dbo].[update_Events]    Script Date: 08/09/2006 12:54:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_Events]
	(@EventID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @EventTypeID 	[int],
	 @FinalCode 	[tinyint],
	 @UserCreated 	[tinyint],
	 @DefaultNonContact 	[int])

AS UPDATE [QMS].[dbo].[Events] 

SET  	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [EventTypeID]	 = @EventTypeID,
	 [FinalCode]	 = @FinalCode,
	 [UserCreated]	 = @UserCreated,
	 [DefaultNonContact]	 = @DefaultNonContact 

WHERE 
	( [EventID]	 = @EventID)



' 
END
GO
