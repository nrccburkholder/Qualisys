/****** Object:  StoredProcedure [dbo].[delete_Clients]    Script Date: 08/09/2006 13:39:00 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Clients]
GO
/****** Object:  StoredProcedure [dbo].[delete_Clients]    Script Date: 08/09/2006 13:39:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Clients]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Clients]
	(@ClientID 	[int])

AS DELETE [QMS].[dbo].[Clients] 

WHERE 
	( [ClientID]	 = @ClientID)



' 
END
GO
