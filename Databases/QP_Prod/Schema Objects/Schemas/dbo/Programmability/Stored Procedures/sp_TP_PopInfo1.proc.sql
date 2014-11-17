CREATE procedure [dbo].[sp_TP_PopInfo1]
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


