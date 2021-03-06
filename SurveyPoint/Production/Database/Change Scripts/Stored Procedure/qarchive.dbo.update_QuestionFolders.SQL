/****** Object:  StoredProcedure [dbo].[update_QuestionFolders]    Script Date: 08/09/2006 10:18:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_QuestionFolders]
GO
/****** Object:  StoredProcedure [dbo].[update_QuestionFolders]    Script Date: 08/09/2006 10:18:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_QuestionFolders]
	(@QuestionFolderID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @Active 	[tinyint])

AS UPDATE [QMS].[dbo].[QuestionFolders] 

SET  	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [Active]	 = @Active 

WHERE 
	( [QuestionFolderID]	 = @QuestionFolderID)



' 
END
GO
