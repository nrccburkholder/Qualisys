/****** Object:  StoredProcedure [dbo].[remove_duplicate_respondents]    Script Date: 08/10/2006 16:40:16 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[remove_duplicate_respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[remove_duplicate_respondents]
GO
/****** Object:  StoredProcedure [dbo].[remove_duplicate_respondents]    Script Date: 08/10/2006 16:40:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[remove_duplicate_respondents]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure remove_duplicate_respondents(
   @CleanSurveyInstanceID int -- the survey instance to remove respondents from
  ,@CompareSurveyInstanceID int -- the reference survey instance that
        -- we are looking at to find the duplicate respondents
) 
as

/* This procedure will look at all respondents in the clean survey and see if there
are any duplicate respondents in the comparison survey.
A duplicate is defined as a matc between first names and last names.
If a duplicate is found,  this duplicate is removed from the clean survey instance
.  This is a cascading removal -- which will remove all eventlogs, responses,
and respondentproperties.

At the end,  a selection of the number of respondents wiped out is performed.

Created by Hib Engler Feb 25, 2003
*/


begin
declare @RespondentID int
declare @RespondentCount int
set @RespondentCount=0

declare abc cursor for
select r2.respondentID 
from Respondents r1,
     Respondents r2
where r1.SurveyInstanceID = @CompareSurveyInstanceID 
  and r2.SurveyInstanceID = @CleanSurveyInstanceID 
  and @CompareSurveyInstanceID != @CleanSurveyInstanceID -- keeps us safe
  and r1.FirstName = r2.FirstName
  and r1.LastName = r2.LastName



open abc
fetch abc into @RespondentID
while @@Fetch_status = 0 
  begin
  set @RespondentCount = @RespondentCount +1  

  delete from responses where respondentID=@RespondentID
  delete from EventLog where RespondentID=@RespondentID
  delete from RespondentProperties where RespondentID=@RespondentID
  delete from Respondents where RespondentID=@RespondentID

  fetch abc into @RespondentID
  end
close abc
deallocate abc

select @RespondentCount

end

' 
END
GO
