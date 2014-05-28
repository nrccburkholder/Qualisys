CREATE PROCEDURE [dbo].[QP_Rep_SentaraCommentsSA]
    @Associate varchar(50),
    @StartDate datetime,
    @EndDate   datetime
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Create temp tables
create table #Surveys (Study_id int, 
                       StudyNm varchar(10),  
                       Survey_id int, 
                       SurveyNm varchar(10), 
                       MailingStepMethod_id int, --0=Mail, 1=Phone
                       Days0 int default(0), 
                       Days1 int default(0), 
                       Days2 int default(0), 
                       Days3 int default(0), 
                       Days4 int default(0), 
                       Days5 int default(0), 
                       Days6 int default(0), 
                       Days7 int default(0),
                       Days8orMore int default(0)
                      )

create table #Temp (Survey_id int, DaysOld int, Quantity int)

--Get the surveys to be worked on
insert into #Surveys (Study_id, StudyNm, Survey_id, SurveyNm, MailingStepMethod_id)
select st.Study_id, rtrim(st.strStudy_Nm), sd.Survey_id, rtrim(sd.strSurvey_Nm), ms.MailingStepMethod_id 
from Client cl, Study st, Survey_Def sd, MailingMethodology mm, MailingStep ms
where cl.Client_id = st.Client_id
and st.Study_id = sd. Study_id
and cl.Client_id = 1057
and mm.Survey_id = sd.Survey_id
and mm.Methodology_id = ms.Methodology_id
and cl.Active = 1
and st.Active = 1
and sd.Active = 1
and mm.bitActiveMethodology = 1
and ms.MailingStepMethod_id in (0, 1) --0=Mail, 1=Phone
and ms.BITFIRSTSURVEY = 1

--Get the SA comments and how old the are
insert into #Temp (Survey_id, DaysOld, Quantity)
select sv.Survey_id, datediff(day, convert(varchar, qf.datReturned, 101), convert(varchar, cm.datEntered, 101)), COUNT(*)
from #Surveys sv, QuestionForm qf, Comments cm
where sv.Survey_id = qf.Survey_id
and qf.QuestionForm_id = cm.QuestionForm_id
and qf.datReturned between @StartDate and @EndDate
and cm.CmntType_id in (2, 3)
group by sv.Survey_id, datediff(day, convert(varchar, qf.datReturned, 101), convert(varchar, cm.datEntered, 101))

--Update the number of days late
update sv
set sv.Days0 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 0

update sv
set sv.Days1 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 1

update sv
set sv.Days2 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 2

update sv
set sv.Days3 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 3

update sv
set sv.Days4 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 4

update sv
set sv.Days5 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 5

update sv
set sv.Days6 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 6

update sv
set sv.Days7 = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld = 7

update sv
set sv.Days8orMore = tm.Quantity
from #Surveys sv, #Temp tm
where sv.Survey_id = tm.Survey_id
and tm.DaysOld >= 8

--Return the result set
select StudyNm + ' (' + convert(varchar, Study_id) + ')' as [Study], SurveyNm + ' (' + convert(varchar, Survey_id) + ')' as [Survey], 
       case MailingStepMethod_id when 0 then 'Mail' else 'Phone' end as [Methodology], Days0 as [Same Day], Days1 as [1 Day], Days2 as [2 Days], 
       Days3 as [3 Days], Days4 as [4 Days], Days5 as [5 Days], Days6 as [6 Days], Days7 as [7 Days], Days8orMore as [8 or More]
from #Surveys 
order by MailingStepMethod_id, StudyNm, SurveyNm

--Cleanup
drop table #Surveys
drop table #Temp

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


