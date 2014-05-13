update questionvals
set scaleorder=isnull(rr.rankorder,-1)
from questionvals qv left join qp_comments.dbo.responserankorder rr
	on qv.qstncore=rr.qstncore
		and qv.val=rr.val

update questionvals
set max_scaleorder=isnull(rr.max_scaleorder,-9)
from questionvals qv left join 
	(select qstncore, max(rankorder) as max_scaleorder 
		from qp_comments.dbo.responserankorder 
		group by qstncore
		having max(rankorder)>0) rr
	on qv.qstncore=rr.qstncore

update QuestionScaleCombos
set scaleorder=isnull(rr.rankorder,-1)
from QuestionScaleCombos qv left join qp_comments.dbo.responserankorder rr
	on qv.qstncore=rr.qstncore
		and qv.val=rr.val

update QuestionScaleCombos
set max_scaleorder=isnull(rr.max_scaleorder,-9)
from QuestionScaleCombos qv left join 
	(select qstncore, max(rankorder) as max_scaleorder 
		from qp_comments.dbo.responserankorder 
		group by qstncore
		having max(rankorder)>0) rr
	on qv.qstncore=rr.qstncore