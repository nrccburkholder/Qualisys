-- drop procedure sp_UnitQuestions
create procedure sp_UnitQuestions
  @sampunit int
as

declare @parent int

create table #unit (sampunit int)

while @sampunit is not null
begin
  insert #unit values (@sampunit)
  select @parent=parentsampleunit_id 
  from sampleunit 
  where sampleunit_id=@sampunit
  set @sampunit=@parent
end

select sq.section_id, sq.subsection,
  case sq.subtype when 1 then '    Q'+right('00000'+convert(varchar,sq.qstncore),6) 
                  when 2 then '  Subsection' 
                  when 3 then 'Section' 
  end,
  rtrim(sq.label) + case when subtype=3 then ' (' + convert(varchar,u.sampunit)+':'+rtrim(su.strSampleUnit_nm)+')' else '' end
from #unit u, sampleunit su, sampleunitsection sus, sel_qstns sq
where u.sampunit=su.sampleunit_id
  and u.sampunit=sus.sampleunit_id
  and sus.selqstnssurvey_id=sq.survey_id
  and sus.selqstnssection=sq.section_id
  and sq.section_id > 0
  and subtype in (1,2,3)
  and sq.section_id in (select distinct x.section_id from sel_qstns x where x.survey_id=sus.selqstnssurvey_id and subtype=1)
order by sq.section_id,sq.subsection,sq.item

drop table #unit


