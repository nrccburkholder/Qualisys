/****** Object:  StoredProcedure [dbo].[delete_RespondentResponses]    Script Date: 08/09/2006 14:28:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_RespondentResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_RespondentResponses]
GO
/****** Object:  StoredProcedure [dbo].[delete_RespondentResponses]    Script Date: 08/09/2006 14:28:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_RespondentResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.delete_RespondentResponses
	(@RespondentID 	[int])

AS 
BEGIN

DELETE [QMS].[dbo].[Responses]
WHERE 
	( [RespondentID]	 = @RespondentID)
	
END



' 
END
GO
