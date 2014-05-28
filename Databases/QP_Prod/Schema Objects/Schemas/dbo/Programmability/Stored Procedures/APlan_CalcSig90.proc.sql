CREATE procedure APlan_CalcSig90
  @period1 int, @period2 int, @bitByUnit bit
as
if @bitByUnit=1  
begin
  insert into #sigtest (sampunit,qstncore,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.stat, s2.stat, s1.nsize, s2.nsize, s1.sumsq, s2.sumsq
    from #summary s1 left outer join #summary s2 on s1.sampunit=s2.sampunit and s1.qstncore=s2.qstncore
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=1
      and s2.bitMeanable=1

  insert into #sigtest (sampunit,qstncore,response,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.response, 100*s1.topbox/(s1.nsize+0.0), 100*s2.topbox/(s2.nsize+0.0), 
        s1.nsize, s2.nsize, s1.TopBox, s2.TopBox
    from #summary s1 left outer join #summary s2 on s1.sampunit=s2.sampunit and s1.qstncore=s2.qstncore and s1.response=s2.response
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=0
      and s2.bitMeanable=0
      and s1.nsize > 0 
      and s2.nsize > 0
end
else
begin
  insert into #sigtest (sampunit,qstncore,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.stat, s2.stat, s1.nsize, s2.nsize, s1.sumsq, s2.sumsq
    from #summary s1 left outer join #summary s2 on s1.qstncore=s2.qstncore
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=1
      and s2.bitMeanable=1

  insert into #sigtest (sampunit,qstncore,response,m1,m2,n1,n2,ss1,ss2)
    select s1.sampunit, s1.qstncore, s1.response, 100*s1.topbox/(s1.nsize+0.0), 100*s2.topbox/(s2.nsize+0.0), 
         s1.nsize, s2.nsize, s1.topbox, s2.topbox
    from #summary s1 left outer join #summary s2 on s1.qstncore=s2.qstncore and s1.response=s2.response
    where s1.period_id=@period1
      and s2.period_id=@period2
      and s1.bitMeanable=0
      and s2.bitMeanable=0
      and s1.nsize > 0 
      and s2.nsize > 0
end

exec APlan_CalcT90
exec APlan_CalcChi90


