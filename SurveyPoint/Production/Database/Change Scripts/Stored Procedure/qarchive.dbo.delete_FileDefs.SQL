/****** Object:  StoredProcedure [dbo].[delete_FileDefs]    Script Date: 08/09/2006 13:40:07 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_FileDefs]
GO
/****** Object:  StoredProcedure [dbo].[delete_FileDefs]    Script Date: 08/09/2006 13:40:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE delete_FileDefs
	(@FileDefID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[FileDefColumns] 

WHERE 
	( [FileDefID]	 = @FileDefID)

DELETE [QMS].[dbo].[FileDefs] 

WHERE 
	( [FileDefID]	 = @FileDefID)

END

' 
END
GO
