/****** Object:  StoredProcedure [dbo].[insert_Protocols]    Script Date: 08/09/2006 16:30:48 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Protocols]
GO
/****** Object:  StoredProcedure [dbo].[insert_Protocols]    Script Date: 08/09/2006 16:30:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Protocols]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_Protocols]
	(@ProtocolID 	[int] OUTPUT,
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @CreatedByUserID 	[int])

AS
BEGIN

INSERT INTO [QMS].[dbo].[Protocols] 
	 ( [Name],
	 [Description],
	 [CreatedByUserID]) 
 
VALUES 
	( @Name,
	 @Description,
	 @CreatedByUserID)

SET @ProtocolID = @@IDENTITY

END




' 
END
GO
