/****** Object:  StoredProcedure [dbo].[spChangeResponseText]    Script Date: 08/09/2006 12:58:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseText]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spChangeResponseText]
GO
/****** Object:  StoredProcedure [dbo].[spChangeResponseText]    Script Date: 08/09/2006 12:58:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseText]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure spChangeResponseText(
		@RespondentID int,                         -- RespondentID to look at
		@QuestionShortDesc varchar(100),	   -- Question short description to read
		@ResponseText varchar(1000)		   -- new response text
)
AS
/* spChangeResponseText will insert/update a response for the given question
recorded for a given question.

It finds the question that applies and then finds the answer category of type 2(select open answer) 
or type 3(open answer)

Then it looks for the response.  If it exists, it updates the text, otherwise it inserts a new
response.

This is for the trigger functions -- so that you can change respondent text
*/
begin
declare @SurveyQuestionID int		-- Survey Question for the response
declare @AnswerCategoryID int		-- Answer Category appropriate for entering text values in the response
declare @ResponseID int			-- Response ID if the response already exists



/* find the survey question,  the question,  and the first answer category which is open answer or select item open answer */
declare getPrepInfo cursor for
	select sq.SurveyQuestionID,
	       ac.AnswerCategoryID
	from SurveyQuestions sq,
	     answerCategories ac
	where sq.SurveyQuestionID = dbo.GetSurveyQuestionIDFromDesc(@RespondentID,@questionShortDesc)
	  and sq.QuestionID = ac.QuestionID
	  and ac.AnswerCategoryTypeID in (2,3) -- open answer or select item open answer

/* get the first row -- there might be more than one */
set @SurveyQuestionID = null
open getPrepInfo
fetch getPrepInfo into @SurveyQuestionID,@AnswerCategoryID
close getPrepInfo
deallocate getPrepInfo

-- if we dont have anything,  then quit
if @SurveyQuestionID is null
  return


/* See if there is an existing response with the value */
declare findExistingResponse cursor for
	select r.ResponseID
	from Responses r
	where r.RespondentID = @RespondentID
	  and r.SurveyQuestionID = @SurveyQuestionID


set @ResponseID = null
open findExistingResponse
fetch findExistingResponse into @ResponseID
close findExistingResponse
deallocate findExistingResponse

if @ResponseID is null  -- if we couldnt find one
  begin
  insert into Responses(RespondentID,
	SurveyQuestionID,
	AnswerCategoryID,
	ResponseText)
  values (@RespondentID,
          @SurveyQuestionID,
          @AnswerCategoryID,
          @ResponseText)
  end
else   -- we found one
  begin
  update Responses
  set AnswerCategoryID=@AnswerCategoryID,
  ResponseText=@ResponseText
  where ResponseID=@ResponseID
  end


end  


' 
END
GO
