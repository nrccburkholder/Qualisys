/****** Object:  StoredProcedure [dbo].[compute_PartialCompletenessForSurveyInstance]    Script Date: 08/08/2006 15:58:35 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_PartialCompletenessForSurveyInstance]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_PartialCompletenessForSurveyInstance]
GO
/****** Object:  StoredProcedure [dbo].[compute_PartialCompletenessForSurveyInstance]    Script Date: 08/08/2006 15:58:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_PartialCompletenessForSurveyInstance]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE   procedure compute_PartialCompletenessForSurveyInstance(@surveyInstanceID int)
as
begin
/* this procedure looks for incomplete events (type 3000,3010,3020, and 3030)
for all events that are in a survey instance and
if the eventparameter is numeric and between 50 and 80,  updates the 
event id to be partially complete (3001,3011,3021,and 3031 respectively)
*/

/* This uses a hint (index = ix_eventlog1)  to force the query plan to be the following:
Find all respondents based on the index on surveyinstance id (approx 300 rows)
  for each respondentID   
    find all events based on the index on respondent id  (approx 3 per respondent)

Where the standard way that SQLserver will choose is

   Find all respondents based on the index on surveyinstance id (300 rows)


   Find all eventlogs on the index eventid -- where event id = 3000, 3010, 3020,  3030  (100000 rows)


   Merge the two lists together based on respondent id


Te query hint is MUCH faster.

Then I rejoin with eventlogs again -- I do this to make sure that the isnumeric check
goes BEFORE we try a numerical comparison.

Hib
*/


update eventlog set eventID = eventID + 1
from eventlog,
(
select eventlogid
 from eventlog a (index = ix_eventlog1),
 respondents r
where r.surveyinstanceid = @surveyInstanceID
  and a.respondentID = r.respondentID
  and a.eventID in (3000,3010,3020,3030)
  and isnumeric(eventparameters) = 1
) b
where eventlog.eventlogid = b.eventlogid
and cast(eventlog.eventparameters as decimal) between 50 and 80

end;


' 
END
GO
