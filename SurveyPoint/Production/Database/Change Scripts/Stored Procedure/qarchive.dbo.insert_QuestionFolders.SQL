/****** Object:  StoredProcedure [dbo].[insert_QuestionFolders]    Script Date: 08/09/2006 16:32:44 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_QuestionFolders]
GO
/****** Object:  StoredProcedure [dbo].[insert_QuestionFolders]    Script Date: 08/09/2006 16:32:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_QuestionFolders]
	(@QuestionFolderID 	[int] OUTPUT,
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @Active 	[tinyint])

AS
BEGIN

INSERT INTO [QMS].[dbo].[QuestionFolders] 
	 ( [Name],
	 [Description],
	 [Active]) 
 
VALUES 
	( @Name,
	 @Description,
	 @Active)

SET @QuestionFolderID = @@IDENTITY

END




' 
END
GO
