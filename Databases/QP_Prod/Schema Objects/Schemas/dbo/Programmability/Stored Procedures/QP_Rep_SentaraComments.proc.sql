CREATE PROCEDURE [dbo].[QP_Rep_SentaraComments]
    @Associate varchar(50),
    @StartDate datetime,
    @EndDate   datetime
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variable
declare @Study int
declare @Sql   varchar(8000)

--Create temp tables
create table #Results (Study_id int,
                       StudyNm varchar(10),  
                       Survey_id int, 
                       SurveyNm varchar(10), 
                       MailingStepMethod_id int, --0=Mail, 1=Phone
                       DLComments int,
                       DLCommentsNo int, 
                       QSComments int, 
                       DMComments int
                      )

create table #Temp (Survey_id int, Quantity int)

create table #Study (Study_id int)

--Get the surveys to be worked on
insert into #Results (Study_id, StudyNm, Survey_id, SurveyNm, MailingStepMethod_id)
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
and ms.bitFirstSurvey = 1

--Get the quantity of comments in the DL_Comments table
insert into #Temp (Survey_id, Quantity)
select rs.Survey_id, count(*)
from #Results rs, SampleSet ss, SamplePop sp, QuestionForm qf, SentMailing sm, DL_LithoCodes lc, DL_Comments cm, DL_Dispositions ds
where rs.Survey_id = ss.Survey_id
and ss.SampleSet_id = sp.SampleSet_id
and sp.SamplePop_id = qf.SamplePop_id
and qf.SentMail_id = sm.SentMail_id
and sm.strLithoCode = lc.strLithoCode
and lc.DL_LithoCode_id = cm.DL_LithoCode_id
and lc.DL_LithoCode_id = ds.DL_LithoCode_id
and cm.DL_LithoCode_id = ds.DL_LithoCode_id
and rs.MailingStepMethod_id = 1
and qf.datReturned is not null
and qf.datResultsImported is not null
and ss.datDateRange_FromDate between @StartDate and @EndDate
and ds.IsFinal = 1
and cm.bitSubmitted = 1
group by rs.Survey_id

--Update the counts
update rs
set rs.DLComments = tp.Quantity
from #Results rs, #Temp tp
where rs.Survey_id = tp.Survey_id

--Truncate the table for the next step
truncate table #Temp

--Get the quantity of comments in the DL_Comments table that are nos
insert into #Temp (Survey_id, Quantity)
select rs.Survey_id, count(*)
from #Results rs, SampleSet ss, SamplePop sp, QuestionForm qf, SentMailing sm, DL_LithoCodes lc, DL_Comments cm, DL_Dispositions ds
where rs.Survey_id = ss.Survey_id
and ss.SampleSet_id = sp.SampleSet_id
and sp.SamplePop_id = qf.SamplePop_id
and qf.SentMail_id = sm.SentMail_id
and sm.strLithoCode = lc.strLithoCode
and lc.DL_LithoCode_id = cm.DL_LithoCode_id
and lc.DL_LithoCode_id = ds.DL_LithoCode_id
and cm.DL_LithoCode_id = ds.DL_LithoCode_id
and rs.MailingStepMethod_id = 1
and qf.datReturned is not null
and qf.datResultsImported is not null
and ss.datDateRange_FromDate between @StartDate and @EndDate
and ds.IsFinal = 1
and cm.bitSubmitted = 1
and convert(varchar, cm.cmntText) in ('no', 'no.', 'none', 'none.', 'nope', 'nope.', 'nothing', 'nothing.', 'no comment', 'no comment.', 'no comments', 'no comments.', 'nothing', 'nothing.', 'no response', 'no response.')
group by rs.Survey_id

--Update the counts
update rs
set rs.DLCommentsNo = tp.Quantity
from #Results rs, #Temp tp
where rs.Survey_id = tp.Survey_id

--Truncate the table for the next step
truncate table #Temp

--Get the quantity of comments in the QualiSys comments table
insert into #Temp (Survey_id, Quantity)
select rs.Survey_id, count(*)
from #Results rs, SampleSet ss, SamplePop sp, QuestionForm qf, Comments cm
where rs.Survey_id = ss.Survey_id
and ss.SampleSet_id = sp.SampleSet_id
and sp.SamplePop_id = qf.SamplePop_id
and qf.QuestionForm_id = cm.QuestionForm_id
and qf.datReturned is not null
and qf.datResultsImported is not null
and ss.datDateRange_FromDate between @StartDate and @EndDate
group by rs.Survey_id

--Update the counts
update rs
set rs.QSComments = tp.Quantity
from #Results rs, #Temp tp
where rs.Survey_id = tp.Survey_id

--Truncate the table for the next step
truncate table #Temp

--Get the studies involved
insert into #Study (Study_id)
select distinct Study_id
from #Results
where QSComments > 0

--Get the first study
select top 1 @Study = Study_id from #Study

--Loop through the studies
while @@RowCount > 0
begin
    --Get the datamart comment counts for this study
    set @Sql = 'insert into #Temp (Survey_id, Quantity) ' + char(10) +
               'select rs.Survey_id, count(*) ' + char(10) +
               'from #Results rs, SampleSet ss, SamplePop sp, QuestionForm qf, DataMart.QP_Comments.s' + convert(varchar, @Study) + '.Comments cm ' + char(10) +
               'where rs.Survey_id = ss.Survey_id ' + char(10) +
               'and ss.SampleSet_id = sp.SampleSet_id ' + char(10) +
               'and sp.SamplePop_id = qf.SamplePop_id ' + char(10) +
               'and qf.QuestionForm_id = cm.QuestionForm_id ' + char(10) +
               'and qf.datReturned is not null ' + char(10) +
               'and qf.datResultsImported is not null ' + char(10) +
               'and ss.datDateRange_FromDate between ''' + convert(varchar, @StartDate, 101) + ''' and ''' + convert(varchar, @EndDate, 101) + ''' ' + char(10) +
               'group by rs.Survey_id'
    
    --Run the query
    exec (@Sql)
    
    --Delete this study
    delete #Study where Study_id = @Study
    
    --Get the next study
    select top 1 @Study = Study_id from #Study
end

--Update the counts
update rs
set rs.DMComments = tp.Quantity
from #Results rs, #Temp tp
where rs.Survey_id = tp.Survey_id

--Truncate the table for the next step
truncate table #Temp

--Return results for Phone
select StudyNm + ' (' + convert(varchar, Study_id) + ')' as [Study], SurveyNm + ' (' + convert(varchar, Survey_id) + ')' as [Survey], 
       case MailingStepMethod_id when 0 then 'Mail' else 'Phone' end as [Methodology], DLComments as [Incoming Comments], 
       DLCommentsNo as [Incoming Comments Containing NO], QSComments as [QualiSys Comments], DMComments as [DataMart Comments]
from #Results
order by MailingStepMethod_id, StudyNm, SurveyNm

--Clean up
drop table #Results
drop table #Temp
drop table #Study

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


