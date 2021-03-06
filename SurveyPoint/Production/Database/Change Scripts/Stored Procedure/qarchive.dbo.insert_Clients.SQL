/****** Object:  StoredProcedure [dbo].[insert_Clients]    Script Date: 08/09/2006 16:29:22 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Clients]
GO
/****** Object:  StoredProcedure [dbo].[insert_Clients]    Script Date: 08/09/2006 16:29:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_Clients]
	(@ClientID 	[int] OUTPUT,
	 @Name 	[varchar](100),
	 @Address1 	[varchar](250),
	 @Address2 	[varchar](250),
	 @City 	[varchar](100),
	 @State 	[varchar](100),
	 @PostalCode 	[varchar](50),
	 @Telephone 	[varchar](50),
	 @Fax 	[varchar](50),
	 @Active 	[tinyint])

AS
BEGIN
INSERT INTO [QMS].[dbo].[Clients] 
	 ( [Name],
	 [Address1],
	 [Address2],
	 [City],
	 [State],
	 [PostalCode],
	 [Telephone],
	 [Fax],
	 [Active]) 
 
VALUES 
	( @Name,
	 @Address1,
	 @Address2,
	 @City,
	 @State,
	 @PostalCode,
	 @Telephone,
	 @Fax,
	 @Active)

SET @ClientID = @@IDENTITY

END




' 
END
GO
