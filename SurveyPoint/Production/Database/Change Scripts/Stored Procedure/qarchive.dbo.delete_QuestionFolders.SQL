/****** Object:  StoredProcedure [dbo].[delete_QuestionFolders]    Script Date: 08/09/2006 13:53:18 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_QuestionFolders]
GO
/****** Object:  StoredProcedure [dbo].[delete_QuestionFolders]    Script Date: 08/09/2006 13:53:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_QuestionFolders]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_QuestionFolders]
	(@QuestionFolderID 	[int])

AS DELETE [QMS].[dbo].[QuestionFolders] 

WHERE 
	( [QuestionFolderID]	 = @QuestionFolderID)



' 
END
GO
