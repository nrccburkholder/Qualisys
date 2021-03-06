/****** Object:  StoredProcedure [dbo].[spChangeResponseNumber]    Script Date: 08/09/2006 12:58:19 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseNumber]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spChangeResponseNumber]
GO
/****** Object:  StoredProcedure [dbo].[spChangeResponseNumber]    Script Date: 08/09/2006 12:58:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spChangeResponseNumber]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE procedure spChangeResponseNumber(
		@RespondentID int,                         	-- RespondentID to look at
		@QuestionShortDesc varchar(100),	-- Question short description to read
		@ResponseNumber float(53)		-- new response number
)
AS
/* spChangeResponseNumber will insert/update a response for the given question
recorded for a given question.

It finds the question that applies and then finds the answer category of type 2(select open answer) 
or type 3(open answer)

Then it looks for the response.  If it exists, it updates the text with the textual form of the number,
 otherwise it inserts a new response.

This is for the trigger functions -- so that you can change respondent text as numerical values
*/
begin
declare @ResponseText varchar(1000)
set @ResponseText = convert(varchar(1000),@ResponseNumber)

exec dbo.spChangeResponseText @RespondentID,@QuestionShortDesc,@responseText
end
' 
END
GO
