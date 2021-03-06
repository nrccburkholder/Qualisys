/****** Object:  StoredProcedure [dbo].[CopyQuestionToFolder]    Script Date: 08/09/2006 13:34:21 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CopyQuestionToFolder]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[CopyQuestionToFolder]
GO
/****** Object:  StoredProcedure [dbo].[CopyQuestionToFolder]    Script Date: 08/09/2006 13:34:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[CopyQuestionToFolder]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE  PROCEDURE dbo.CopyQuestionToFolder(
	@QuestionID 	[int],
	@QuestionFolderID [int]
)AS
/* This procedure will Copy a question from one folder into another folder.It can duplicate a question in the same folder,  as there is no natural unique keyon questions 
This also copies the answer categories associated with the question.
The return select is one row,  containing the new question id.
Created by Hibbard M. Engler2/21/2003*/
BEGIN
DECLARE @NewQuestionID [int]
/* copy question */
INSERT INTO Questions(QuestionFolderID, [Text], ShortDesc, QuestionTypeID, ItemOrder)
SELECT @QuestionFolderID, [Text], ShortDesc, QuestionTypeID, NextItemOrderFROM Questions q, (SELECT ISNULL(MAX(ItemOrder),0)+1 NextItemOrder FROM Questions                    WHERE QuestionFolderID = @QuestionFolderID) maxqWHERE q.QuestionID = @QuestionID
/* get the new id */SET @NewQuestionID = @@IDENTITY
/* copy the answer categories */INSERT INTO AnswerCategories (QuestionID, AnswerValue, AnswerText, AnswerCategoryTypeID)SELECT @NewQuestionID, AnswerValue, AnswerText, AnswerCategoryTypeIDFROM AnswerCategoriesWHERE QuestionID = @QuestionID
/*return new question id */
SELECT @NewQuestionID
END


' 
END
GO
