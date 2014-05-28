create procedure APlan_Summarize
  @period_id int
as
insert into #summary (period_id,sampunit,qstncore,response,TopBox,nSize,bitMeanable)
  select @period_id, a.sampunit,a.qstncore,v.intresponseval,0,0,v.bitMeanable
  from (select distinct sampunit, qstncore from #agg) a, #valid v
  where a.qstncore=v.qstncore and v.bitMeanable in (0,2) 

update #summary
  set TopBox=sub.cnt
  from (select a.sampUnit,a.Qstncore,a.response, sum(cnt) as cnt
        from #agg a, #valid v
        where a.qstncore=v.qstncore
          and a.response=v.intresponseval
          and v.bitMeanable in (0,2)
        group by a.sampUnit, a.Qstncore, a.response) sub
  where #summary.sampunit=sub.sampUnit
    and #summary.QstnCore=sub.Qstncore
    and #summary.response=sub.response
    and #summary.period_id=@period_id

update #summary
  set NSize=sub.cnt
  from (select a.sampUnit,a.Qstncore, sum(cnt) as cnt
        from #agg a, #valid v
        where a.qstncore=v.qstncore
          and a.response=v.intresponseval
          and v.bitMeanable=0
        group by a.sampUnit, a.Qstncore) sub
  where #summary.sampunit=sub.sampUnit
    and #summary.QstnCore=sub.Qstncore
    and #summary.period_id=@period_id

update S
  set NSize = A.Cnt
  from #Summary S, #Agg A
  where a.response=-10
    and a.bitMeanable=2
    and s.sampunit=a.sampunit
    and s.qstncore=a.qstncore
    and s.period_id=@period_id

--delete from #summary where nSize=0 and period_id=@period_id

insert into #summary (period_id,sampunit,qstncore,stat,NSize,SumSq,TopBox,Top2Box,BotBox,Bot2Box,bitMeanable)
  select @period_id, a.sampunit,a.qstncore,
    sum(a.response*a.cnt)/case sum(a.cnt) when 0 then null else sum(0.0+a.cnt) end as stat,
    sum(a.cnt) as NSize,
    sum(power(a.response,2)*a.cnt) as SumSq, 
    sum(case when a.response >= b.TopBox then cnt else 0 end) as TopBox,
    sum(case when a.response >= b.Top2Box then cnt else 0 end) as Top2Box,
    sum(case when a.response <= b.BotBox then cnt else 0 end) as BotBox,
    sum(case when a.response <= b.Bot2Box then cnt else 0 end) as Bot2Box,
    1
  from #agg a, #boxes b
  where a.response>-9 
    and a.qstncore=b.qstncore
    and b.bitMeanable=1
  group by a.sampunit,a.qstncore


