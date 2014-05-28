create procedure SP_FG_Fix_RespCol
as

update sq
set scaleflipped=maxlen
from sel_qstns sq, (	select survey_id,qpc_id,max(len(ss.val)) as maxlen
			from sel_scls ss
			group by survey_id,qpc_id) sub
where sq.survey_id=sub.survey_id
and sq.scaleid=sub.qpc_id
and sq.subtype=1
and sq.scaleflipped <> sub.maxlen


