/****** Object:  StoredProcedure [dbo].[insert_FileDefs]    Script Date: 08/09/2006 16:54:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_FileDefs]
GO
/****** Object:  StoredProcedure [dbo].[insert_FileDefs]    Script Date: 08/09/2006 16:54:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_FileDefs]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_FileDefs]
	(@FileDefID 	[int] OUTPUT,
	 @FileDefName 	[varchar](200),
	 @FileDefDescription 	[varchar](200),
	 @ClientID 	[int],
	 @SurveyID 	[int],
	 @FileDefTypeID 	[int],
	 @FileTypeID 	[int],
	 @FileDefDelimiter 	[char](1))

AS
BEGIN

INSERT INTO [QMS].[dbo].[FileDefs] 
	 ( [FileDefName],
	 [FileDefDescription],
	 [ClientID],
	 [SurveyID],
	 [FileDefTypeID],
	 [FileTypeID],
	 [FileDefDelimiter]) 
 
VALUES 
	( @FileDefName,
	 @FileDefDescription,
	 @ClientID,
	 @SurveyID,
	 @FileDefTypeID,
	 @FileTypeID,
	 @FileDefDelimiter)

SET @FileDefID = @@IDENTITY

END




' 
END
GO
