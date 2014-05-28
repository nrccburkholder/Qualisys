create procedure APlan_CalcT
  @period1 int, @period2 int, @bitByUnit bit
as
if @bitByUnit=1  
  insert into #ttest (sampunit,qstncore,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.stat, s2.stat, s1.nsize, s2.nsize, s1.sumsq, s2.sumsq
    from #summary s1 left outer join #summary s2 on s1.sampunit=s2.sampunit and s1.qstncore=s2.qstncore
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=1
      and s2.bitMeanable=1
else
  insert into #ttest (sampunit,qstncore,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.stat, s2.stat, s1.nsize, s2.nsize, s1.sumsq, s2.sumsq
    from #summary s1 left outer join #summary s2 on s1.qstncore=s2.qstncore
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=1
      and s2.bitMeanable=1

exec APlan_CalcT95


