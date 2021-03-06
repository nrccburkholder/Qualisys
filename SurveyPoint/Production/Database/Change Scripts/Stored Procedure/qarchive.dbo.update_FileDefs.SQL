/****** Object:  StoredProcedure [dbo].[update_FileDefs]    Script Date: 08/09/2006 12:54:15 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_FileDefs]
GO
/****** Object:  StoredProcedure [dbo].[update_FileDefs]    Script Date: 08/09/2006 12:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_FileDefs]
	(@FileDefID 	[int],
	 @FileDefName 	[varchar](200),
	 @FileDefDescription 	[varchar](200),
	 @ClientID 	[int],
	 @SurveyID 	[int],
	 @FileDefTypeID 	[int],
	 @FileTypeID 	[int],
	 @FileDefDelimiter 	[char](1))

AS UPDATE [QMS].[dbo].[FileDefs] 

SET  	 [FileDefName]	 = @FileDefName,
	 [FileDefDescription]	 = @FileDefDescription,
	 [ClientID]	 = @ClientID,
	 [SurveyID]	 = @SurveyID,
	 [FileDefTypeID]	 = @FileDefTypeID,
	 [FileTypeID]	 = @FileTypeID,
	 [FileDefDelimiter]	 = @FileDefDelimiter 

WHERE 
	( [FileDefID]	 = @FileDefID)



' 
END
GO
