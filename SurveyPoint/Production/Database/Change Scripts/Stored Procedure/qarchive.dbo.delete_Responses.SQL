/****** Object:  StoredProcedure [dbo].[delete_Responses]    Script Date: 08/09/2006 14:29:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Responses]
GO
/****** Object:  StoredProcedure [dbo].[delete_Responses]    Script Date: 08/09/2006 14:29:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Responses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE dbo.delete_Responses
	(@ResponseID 	[int])

AS 
BEGIN

DELETE [QMS].[dbo].[Responses]
WHERE 
	( [ResponseID]	 = @ResponseID)
	
END

' 
END
GO
