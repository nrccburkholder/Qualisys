/*
S10.US6	Change to TestPrints
		As an Implementation Associate, I want to do test prints for dynamically created Cover Letters, so that I know the coverletters are created correctly.

T6.2	Modify the test print notification email to add additional indicator signifiying that the sample unit affected the cover letter. 

Dave Gilsdorf

ALTER PROCEDURE [dbo].[sp_TP_PopInfo1]
ALTER PROCEDURE [dbo].[sp_TP_PopInfo2]

*/
use qp_prod
go
begin tran
go
alter procedure [dbo].[sp_TP_PopInfo1]
@survey_id int, @tp_id int
as
set nocount on
--select @survey_id=535, @tp_id=131

create table #result (strAddressInfo char(60))

insert into #result 
select 'ERROR! ' + logentry 
from pclgenlog l, pclgenrun r
where r.computer_nm like 'tp%'
and l.pclgenrun_id=r.pclgenrun_id
and sentmail_id=@tp_id
and l.logentry like '%error%'

if @@rowcount > 0
begin
  insert into #result 
  select distinct 'Unmapped tag: '+replace(replace(codetext,'®','<'),'¯','>')
  from fgpopcode_tp 
  where tp_ID=@tp_id 
  and codetext like '%¯%'

  insert into #result values ('')
end

insert into #result 
select top 1 'Client: ' + rtrim(strClient_nm) + ' (' + convert(varchar,client_id) + ')'
from clientstudysurvey_view where survey_id=@survey_id

insert into #result 
select top 1 'Study: ' + rtrim(strStudy_nm) + ' (' + convert(varchar,study_id) + ')'
from clientstudysurvey_view where survey_id=@survey_id

insert into #result 
select top 1 'Survey: ' + rtrim(strSurvey_nm) + ' (' + convert(varchar,@survey_id) + ')'
from clientstudysurvey_view where survey_id=@survey_id

insert into #result 
select 'Cover Letter: ' + sc.Description
from testprint_log tpl
inner join mailingstep ms on tpl.mailingstep_id=ms.mailingstep_id
inner join sel_cover sc on ms.SelCover_ID=sc.selcover_ID and ms.survey_id=sc.survey_id
where tp_id=@tp_id

declare @artifacts table (row_id int identity(1,1), ArtifactItem_label varchar(60))

insert into @artifacts (ArtifactItem_label)
select distinct map.ArtifactItem_label
from testprint_log tpl
inner join mailingstep ms on tpl.mailingstep_id=ms.mailingstep_id
inner join sel_cover sc on ms.SelCover_ID=sc.selcover_ID and ms.survey_id=sc.survey_id
inner join samplepop sp on tpl.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join CoverLetterItemArtifactUnitMapping map on ss.sampleunit_id=map.sampleunit_id and rtrim(sc.description)=rtrim(map.CoverLetter_dsc)
where tpl.tp_id=@tp_id

update @artifacts set ArtifactItem_label=left('Cover Alterations: '+ArtifactItem_label,60) where row_id=1
update @artifacts set ArtifactItem_label=left(' & '+ArtifactItem_label,60) where row_id>1

insert into #result 
select ArtifactItem_label
from @artifacts
order by row_id

insert into #result 
select top 1 'Language: ' + l.Language 
from testprint_log tpl, languages l
where tpl.language=l.langid
and tp_id=@tp_id

insert into #result 
select 'Pop ID: ' + convert(varchar,pop_id)
from testprint_log
where tp_id=@tp_id

insert into #result
select pc.codetext
from codeqstns cq, pcl_qstns_tp q, fgpopcode_tp pc
where cq.survey_id=q.survey_id
and cq.selqstns_id=q.selqstns_id
and cq.survey_id=@survey_id
and cq.language=q.language
and q.section_id=-1
and cq.survey_id=pc.survey_id
and cq.code=pc.code
and cq.language=pc.language
and pc.tp_id=@tp_id
and pc.codetext not like '|%'
order by tp_id, intstartpos

select strAddressInfo from #result

drop table #result
go
alter procedure [dbo].[sp_TP_PopInfo2]
@survey_id int, @tp_id int
as

set nocount on

declare @study_id int, @sampleplan_id int, @pop_id int, @sampleset_id int
select @study_id=max(study_id), @sampleplan_id=max(sampleplan_id) from clientstudysurvey_view where survey_id=@survey_id

create table #SampleUnits
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  intTreeOrder int)

exec sp_SampleUnits @SamplePlan_id

select @pop_id=pop_id, @sampleset_id=sampleset_id
from testprint_log 
where tp_id=@tp_id

update su
set intTier=null
from #sampleunits su, selectedsample ss 
where su.sampleunit_id=ss.sampleunit_id 
and ss.pop_id=@pop_id 
and ss.sampleset_id=@sampleset_id
and ss.study_id=@study_id

delete from #sampleunits where intTier is not null

select su.SampleUnit_id, convert(char(30),su.strSampleUnit_nm) as SampleUnit_nm, sq.Section_id, convert(char(30),sq.label) as Section_nm
from #sampleunits su
inner join sampleunitsection sus on su.sampleunit_id=sus.sampleunit_id
inner join sel_qstns sq on sus.selqstnssurvey_id = sq.survey_id and sus.selqstnssection = sq.section_id
where sus.selqstnssurvey_id = @survey_id
and sq.section_id>-1
and sq.language=1
and sq.subtype=3
order by su.intTreeOrder, sq.section_id

drop table #sampleunits
go
commit tran