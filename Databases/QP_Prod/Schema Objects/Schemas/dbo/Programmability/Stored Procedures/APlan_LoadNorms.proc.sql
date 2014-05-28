CREATE procedure APlan_LoadNorms
  @period_id int, @NormStart datetime = '12/01/1999', @NormEnd datetime = '10/19/2000', @bitHCMG bit = 0, @percentilePeriod_id int = 0, @percentile float = 0.9
as

if (select count(*) from nrcnorms06302001 where datreturned between dateadd(month,-1,@NormEnd) and @normEnd)=0
begin
  RAISERROR ('Norms have not been compiled for that date range',17,1)  
  return
end

create table #norm (qstncore int, intResponseVal int, NSize float)

insert into #norm 
select N.qstncore,N.intresponseval,sum(N.nsize+0.0) as nsize
from nrcnorms06302001 N, #valid v
where N.qstncore=v.Qstncore and n.intresponseval=v.intresponseval
  and n.datreturned between @normstart and @normend
group by N.qstncore,N.intresponseval

if @bitHCMG=1
  insert into #norm
    select qe.qstncore,response,sum(wnsize)
    from hcmgnorm n, HCMGQuestionEquivalent qe, #valid v
    where n.hcmgqnmbr=qe.hcmgqnmbr
     and n.HCMGYear=QE.HCMGYear
     and qe.qstncore=v.qstncore
     and n.response=v.intresponseval
    group by qe.qstncore, response
    order by qe.qstncore, response

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

if @percentileperiod_id>0
begin

  create table #percentile (sampleunit_id int, qstncore int, Nsize float, summ float, mean float)

  /* I use -Hospital_id in case a hospital id happens to match a sampleunit_id from NRCNorms */
  if @bitHCMG=1 
    insert into #percentile
    select -Hospital_id,qe.qstncore,sum(wnsize),sum(wnsize*response),
       sum(wnSize*response)/sum(wNsize)
    from hcmgnorm n, HCMGQuestionEquivalent qe, #valid v
    where n.hcmgqnmbr=qe.hcmgqnmbr
     and n.HCMGYear=QE.HCMGYear
     and qe.qstncore=v.qstncore
     and n.response=v.intresponseval
    group by -Hospital_id,qe.qstncore
    having sum(wNsize)>=25.0

  insert into #Percentile
  select n.Sampleunit_id, N.qstncore,sum(n.nsize) as NSize,sum(n.nsize*n.intresponseval) as Summ, 
      sum(n.Nsize*n.intresponseval)/sum(n.nsize+0.0) as mean
  from nrcnorms06302001 N, #valid v
  where N.qstncore=v.Qstncore and n.intresponseval=v.intresponseval and v.bitmeanable=1
    and n.datreturned between @normstart and @normend
  group by n.sampleunit_id,N.qstncore

  declare curQ cursor for
    select qstncore, count(distinct sampleunit_id)
    from #percentile 
    group by qstncore
    having count(distinct sampleunit_id) >= 20

  declare @sql varchar(1000), @qstncore int, @numUnits int
  open curQ
  fetch next from curQ into @qstncore,@numUnits
  while @@fetch_status=0
  begin
    set @SQL = 
    'insert into #summary (period_id,sampunit,qstncore,stat,topbox,botbox,bitMeanable)
    select '+convert(varchar,@percentileperiod_id)+',0,'+convert(varchar,@qstncore)+',min(mean),0,'+convert(varchar,@numUnits)+',1 from 
    (select top '+convert(varchar,floor(@numUnits*(1-@percentile)))+' mean
    from #percentile
    where qstncore='+convert(varchar,@qstncore)+'
    order by mean desc) x'

--    print (@SQL)
exec (@sql) 
   fetch next from curQ into @qstncore,@numUnits
  end
  close curQ
  deallocate curQ

  update #Summary
    set topbox = sub.cnt
  from (select p.qstncore,count(*) as cnt
        from #Percentile P, #Summary s
        where s.period_id=1
          and s.qstncore=p.qstncore
          and s.stat>p.mean
        group by p.qstncore) sub
  where #summary.period_id=@percentileperiod_id
    and #summary.qstncore=sub.qstncore

  drop table #Percentile
end


