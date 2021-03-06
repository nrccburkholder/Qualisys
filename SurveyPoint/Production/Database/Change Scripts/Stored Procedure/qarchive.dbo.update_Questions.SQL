/****** Object:  StoredProcedure [dbo].[update_Questions]    Script Date: 08/09/2006 10:18:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Questions]
GO
/****** Object:  StoredProcedure [dbo].[update_Questions]    Script Date: 08/09/2006 10:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE update_Questions
	(@QuestionID 	[int],
	 @QuestionFolderID 	[int],
	 @Text 	[varchar](3000),
	 @ShortDesc 	[varchar](100),
	 @QuestionTypeID 	[int],
	 @ItemOrder 	[int])

AS UPDATE [QMS].[dbo].[Questions] 

SET  [QuestionFolderID]	 = @QuestionFolderID,
	 [Text]	 = @Text,
	 [ShortDesc]	 = @ShortDesc,
	 [QuestionTypeID]	 = @QuestionTypeID,
	 [ItemOrder]	 = @ItemOrder 

WHERE 
	( [QuestionID]	 = @QuestionID)



' 
END
GO
