/****** Object:  StoredProcedure [dbo].[update_Clients]    Script Date: 08/09/2006 12:54:45 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Clients]
GO
/****** Object:  StoredProcedure [dbo].[update_Clients]    Script Date: 08/09/2006 12:54:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_Clients]
	(@ClientID 	[int],
	 @Name 	[varchar](100),
	 @Address1 	[varchar](250),
	 @Address2 	[varchar](250),
	 @City 	[varchar](100),
	 @State 	[varchar](100),
	 @PostalCode 	[varchar](50),
	 @Telephone 	[varchar](50),
	 @Fax 	[varchar](50),
	 @Active 	[tinyint])

AS UPDATE [QMS].[dbo].[Clients] 

SET  	 [Name]	 = @Name,
	 [Address1]	 = @Address1,
	 [Address2]	 = @Address2,
	 [City]	 = @City,
	 [State]	 = @State,
	 [PostalCode]	 = @PostalCode,
	 [Telephone]	 = @Telephone,
	 [Fax]	 = @Fax,
	 [Active]	 = @Active

WHERE 
	( [ClientID]	 = @ClientID)



' 
END
GO
