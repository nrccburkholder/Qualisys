/****** Object:  StoredProcedure [dbo].[spChangeResponseAnswerValue]    Script Date: 08/09/2006 12:58:27 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseAnswerValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spChangeResponseAnswerValue]
GO
/****** Object:  StoredProcedure [dbo].[spChangeResponseAnswerValue]    Script Date: 08/09/2006 12:58:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseAnswerValue]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE procedure spChangeResponseAnswerValue(
		@RespondentID int,                         -- RespondentID to look at
		@QuestionShortDesc varchar(100),	   -- Question short description to read
		@AnswerValue int		   -- new Answer value
)
AS
/* spChangeAnswerValue will insert/update a response for the given question
recorded to a specified answer category via the value

It finds the question that applies and then finds the answer category of type 2(select open answer) 
or type 1(select).  All other types are bogus for entering values.

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
	  and ac.AnswerCategoryTypeID in (1,2) -- select item or select open answer
          and ac.AnswerValue = @AnswerValue

/* get the first row -- there might be more than one */
set @SurveyQuestionID = null
open getPrepInfo
fetch getPrepInfo into @SurveyQuestionID,@AnswerCategoryID
close getPrepInfo
deallocate getPrepInfo

-- if we dont have anything,  then quit
if @SurveyQuestionID is null 
  begin
  print ''failed with respondent '' + convert(varchar(20),@respondentID )+ '' text '' + @questionshortdesc + '' and ac value '' + 
          convert(varchar(20),@AnswerCategoryID)
  return
  end

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
        responseText)
  values (@RespondentID,
          @SurveyQuestionID,
          @AnswerCategoryID,'''')
  end
else   -- we found one
  begin
  update Responses
  set AnswerCategoryID=@AnswerCategoryID
  where ResponseID=@ResponseID
  end


end  


' 
END
GO
