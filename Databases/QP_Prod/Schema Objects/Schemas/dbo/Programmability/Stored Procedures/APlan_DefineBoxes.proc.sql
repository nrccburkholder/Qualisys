CREATE procedure APlan_DefineBoxes 
@survey_id int = 0
as
if @survey_id=0
	select @survey_id=survey_id 
	from sampleset 
	where sampleset_id = (select top 1 sampset from #mrd)

insert into #valid (qstncore,intresponseval,bitMeanable)
  select sq.qstncore,ss.val,case sq.numMarkCount when 1 then sq.bitMeanable else 2 end
  from sel_qstns sq, sel_scls ss
  where sq.subtype=1 and sq.language=1 and sq.language=ss.language
    and sq.scaleid=ss.qpc_id and sq.survey_id=ss.survey_id and sq.survey_id=@survey_id

-- sex
insert #valid (qstncore,intresponseval,bitMeanable) values (100001,1,0)
insert #valid (qstncore,intresponseval,bitMeanable) values (100001,2,0)
-- age
insert #valid (qstncore,intresponseval,bitMeanable) values (100002,1,0)
insert #valid (qstncore,intresponseval,bitMeanable) values (100002,2,0)
insert #valid (qstncore,intresponseval,bitMeanable) values (100002,3,0)
insert #valid (qstncore,intresponseval,bitMeanable) values (100002,4,0)
insert #valid (qstncore,intresponseval,bitMeanable) values (100002,5,0)

insert into #boxes (qstncore,bitMeanable,TopBox)
  select sq.qstncore, case sq.numMarkCount when 1 then convert(int, sq.bitMeanable) else 2 end, max(val) 
  from sel_qstns sq, sel_scls ss
  where sq.scaleid=ss.qpc_id and sq.survey_id=ss.survey_id and sq.survey_id=@survey_id
  group by sq.qstncore, case sq.numMarkCount when 1 then convert(int, sq.bitMeanable) else 2 end

update #boxes
set Top2Box = sub.Top2Box
from (select sq.qstncore, max(val) as Top2Box
      from sel_qstns sq, sel_scls ss, #boxes b
      where sq.qstncore=b.qstncore
        and ss.val <> b.topbox
        and sq.scaleid=ss.qpc_id
        and sq.survey_id=ss.survey_id
        and sq.survey_id=@survey_id
      group by sq.qstncore) sub
where #boxes.qstncore = sub.qstncore

update #boxes
set BotBox = sub.BotBox
from (select sq.qstncore, min(val) as BotBox
      from sel_qstns sq, sel_scls ss
      where sq.scaleid=ss.qpc_id
        and sq.survey_id=ss.survey_id
        and sq.survey_id=@survey_id
      group by sq.qstncore) sub
where #boxes.qstncore = sub.qstncore

update #boxes
set Bot2Box = sub.Bot2Box
from (select sq.qstncore, min(val) as Bot2Box
      from sel_qstns sq, sel_scls ss, #boxes b
      where sq.qstncore=b.qstncore
        and ss.val <> b.botbox
        and sq.scaleid=ss.qpc_id
        and sq.survey_id=ss.survey_id
        and sq.survey_id=@survey_id
      group by sq.qstncore) sub
where #boxes.qstncore = sub.qstncore

insert #boxes (qstncore,bitMeanable) values (100001,0)
insert #boxes (qstncore,bitMeanable) values (100002,0)


