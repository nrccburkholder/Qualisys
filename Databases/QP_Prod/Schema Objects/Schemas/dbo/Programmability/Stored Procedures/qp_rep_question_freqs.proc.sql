CREATE procedure qp_rep_question_freqs
 @Associate varchar(50),
 @Qstncore varchar(50)
AS
set transaction isolation level read uncommitted
select qstncore, intresponseval, sum(nsize) as NSize
into #r 
from NRCNorm_view
where qstncore = @qstncore
--where qstncore = 336
and bitmissing = 0
group by qstncore, intresponseval
order by intresponseval desc

declare @count int
select @count = (select sum(nsize) from #r)

select QstnCore, intResponseVal, NSize, ((nsize*100.0)/@count) as Percentage
from #r
group by qstncore, intresponseval, nsize
order by intresponseval desc

drop table #r

set transaction isolation level read committed


