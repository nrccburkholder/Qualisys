CREATE procedure [dbo].[APlan_Load_SubHCMGNorms]
  @period_id int, @where varchar(255)
as

declare @SQL varchar(1000)

create table #norm (qstncore int, intResponseVal int, NSize float)

set @SQL=
'insert into #norm
  select qe.qstncore,response,sum(wnsize)
  from HCMGNorm n, HCMGQuestionEquivalent qe, #valid v, HCMGHosp MG
  where n.hcmgqnmbr=qe.hcmgqnmbr
   and n.HCMGYear=QE.HCMGYear
   and qe.qstncore=v.qstncore
   and n.response=v.intresponseval
   and n.hospital_id=MG.Hospital_id
   and '+@where+'
  group by qe.qstncore, response
  order by qe.qstncore, response'
exec (@SQL)

select qstncore,intResponseVal,sum(NSize) as NSize
into #Norm2
from #Norm
group by qstncore,intResponseVal

drop table #norm

insert into #summary (period_id,sampunit,qstncore,stat,nsize,sumsq,topbox,top2box,botbox,bot2box,bitMeanable)
  select @period_id,0,N.qstncore,sum(intresponseval*nsize)/sum(0.0+nsize), sum(nsize), sum(intresponseval*intresponseval*nsize),
    sum(case when n.intresponseval >= b.TopBox then nsize else 0 end) as TopBox,
    sum(case when n.intresponseval >= b.Top2Box then nsize else 0 end) as Top2Box,
    sum(case when n.intresponseval <= b.BotBox then nsize else 0 end) as BotBox,
    sum(case when n.intresponseval <= b.Bot2Box then nsize else 0 end) as Bot2Box,
    1
  from #norm2 N, #boxes B
  where n.qstncore=b.qstncore and b.bitMeanable=1
  group by N.qstncore

insert into #summary (period_id,sampunit,qstncore,response,topbox,bitMeanable)
  select @period_id,0,n.qstncore,n.intresponseval,sum(nsize),0
  from #norm2 N, #valid v
  where n.qstncore=v.qstncore and n.intresponseval=v.intresponseval and v.bitMeanable=0
  group by N.qstncore, n.intresponseval

update #summary
  set nsize=sub.cnt
  from (select n.qstncore,sum(nsize) as cnt
        from #norm2 N, #valid v
        where n.qstncore=v.qstncore and n.intresponseval=v.intresponseval and v.bitMeanable=0
        group by N.qstncore) sub
  where #summary.period_id=@period_id
    and #summary.sampunit=0
    and #summary.qstncore=sub.qstncore

drop table #norm2


