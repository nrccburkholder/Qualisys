CREATE procedure APlan_loadLabels
  @survey_id int = 0
as
if @survey_id=0 
  select @survey_id = sp.survey_id
  from sampleplan sp, sampleunit su, (select top 1 sampunit from #summary) s
  where sp.sampleplan_id=su.sampleplan_id
    and su.sampleunit_id=s.sampunit

insert into #labels
  select sq.qstncore, sq.label, ss.val, ss.label 
  from sel_qstns sq, sel_scls ss
  where sq.survey_id=ss.survey_id
    and sq.scaleid=ss.qpc_id
    and sq.subtype=1
    and sq.language=1 and ss.language=sq.language
    and sq.survey_id=@survey_id

insert #labels (qstncore,lblqstn,response,lblscale) values (100001,'Gender',1,'Male')
insert #labels (qstncore,lblqstn,response,lblscale) values (100001,'Gender',2,'Female')
insert #labels (qstncore,lblqstn,response,lblscale) values (100002,'Age',1,'Under 18')
insert #labels (qstncore,lblqstn,response,lblscale) values (100002,'Age',2,'18 - 34')
insert #labels (qstncore,lblqstn,response,lblscale) values (100002,'Age',3,'35 - 44')
insert #labels (qstncore,lblqstn,response,lblscale) values (100002,'Age',4,'45 - 64')
insert #labels (qstncore,lblqstn,response,lblscale) values (100002,'Age',5,'65/Over')

select distinct qstncore 
into #moreQstns
from #report 
where qstncore not in (select qstncore from #labels) and qstncore >0

if @@Rowcount>0
begin
  insert into #labels (qstncore,lblqstn,response,lblscale)
  select distinct qstncore,'unidentified question', response, 'unidentified response'
  from #report 
  where qstncore in (select qstncore from #moreqstns)

end


