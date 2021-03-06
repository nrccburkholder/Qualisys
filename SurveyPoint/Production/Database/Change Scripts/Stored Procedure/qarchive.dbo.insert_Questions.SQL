/****** Object:  StoredProcedure [dbo].[insert_Questions]    Script Date: 08/09/2006 16:32:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Questions]
GO
/****** Object:  StoredProcedure [dbo].[insert_Questions]    Script Date: 08/09/2006 16:32:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Questions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_Questions]
	(@QuestionID 	[int] OUTPUT,
	 @QuestionFolderID 	[int],
	 @Text 	[varchar](3000),
	 @ShortDesc 	[varchar](100),
	 @QuestionTypeID 	[int],
	 @ItemOrder 	[int])

AS
BEGIN

INSERT INTO [QMS].[dbo].[Questions] 
	 ( [QuestionFolderID],
	 [Text],
	 [ShortDesc],
	 [QuestionTypeID],
	 [ItemOrder]) 
 
VALUES 
	( @QuestionFolderID,
	 @Text,
	 @ShortDesc,
	 @QuestionTypeID,
	 @ItemOrder)

SET @QuestionID = @@IDENTITY

END




' 
END
GO
