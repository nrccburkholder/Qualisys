/*
   CREATED 9/19/13 DG - calculates the number of supplmental (i.e. non-standard) questions on CAHPS surveys. Comment boxes are included in the count.
   The idea is to call this procedure after records are inserted into QuestionForm. @AfterQF is the pre-insert maximum questionform_id value

*/
create procedure dbo.CalcCAHPSSupplemental
@AfterQF int
as

create table #cahpsqstns (surveytype_id tinyint, questionform_id int, subtype tinyint, qstncore int, isSupplemental tinyint)

declare @surveytype table (surveytype_id tinyint)
insert into @surveytype (surveytype_id)
select distinct surveytype_id
from dbo.SurveyTypeQuestionMappings

insert into #cahpsqstns (surveytype_id, questionform_id, subtype, qstncore, isSupplemental)
select sd.surveytype_id, qf.questionform_id, sq.subtype, sq.qstncore, case when cahps.qstncore is null then 1 else 0 end as isSupplemental
from dbo.questionform qf
      inner join dbo.samplepop sp on qf.samplepop_id=sp.samplepop_id
      inner join dbo.survey_def sd on qf.survey_id=sd.survey_id
      inner join @surveytype st on sd.surveytype_id=st.surveytype_id
      inner join dbo.selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
      inner join dbo.sampleunitsection sus on ss.sampleunit_id=sus.sampleunit_id
      inner join dbo.sel_qstns sq on sus.selqstnssurvey_id=sq.survey_id and sus.selqstnssection=sq.section_id
      left outer join (select distinct surveytype_id, qstncore, datEncounterStart_dt, datEncounterEnd_dt
                       from dbo.SurveyTypeQuestionMappings) cahps
              on sq.qstncore=cahps.qstncore and sd.surveytype_id=cahps.surveytype_id and ss.SampleEncounterDate between cahps.datEncounterStart_dt and cahps.datEncounterEnd_dt
where qf.questionform_id > @AfterQF
and (sq.subtype=1 or (sq.subtype=4 and sq.height>0)) -- subtype=1 -> questions; subtype=4 and height>0 -> comment boxes
and sq.language=1
group by sd.surveytype_id, qf.questionform_id, sq.subtype, sq.qstncore, case when cahps.qstncore is null then 1 else 0 end

update qf
set numCAHPSSupplemental=numSupplemental
from dbo.QuestionForm qf
	inner join (select questionform_id,sum(isSupplemental) as numSupplemental
				from #cahpsqstns cq
				group by questionform_id) cq
		on cq.questionform_id=qf.questionform_id

drop table #cahpsqstns


