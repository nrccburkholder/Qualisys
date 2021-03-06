/****** Object:  StoredProcedure [dbo].[insert_Events]    Script Date: 08/09/2006 16:29:59 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Events]
GO
/****** Object:  StoredProcedure [dbo].[insert_Events]    Script Date: 08/09/2006 16:29:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [insert_Events]
	(@EventID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @EventTypeID 	[int],
	 @FinalCode 	[tinyint],
	 @UserCreated 	[tinyint],
	 @DefaultNonContact 	[int])

AS 
BEGIN

INSERT INTO [QMS].[dbo].[Events] 
	 ( [EventID],
	 [Name],
	 [Description],
	 [EventTypeID],
	 [FinalCode],
	 [UserCreated],
	 [DefaultNonContact]) 
 
VALUES 
	( @EventID,
	 @Name,
	 @Description,
	 @EventTypeID,
	 @FinalCode,
	 @UserCreated,
	 @DefaultNonContact)

END

' 
END
GO
