CREATE procedure APlan_Correlate
 @depvar int, @rootunit_id int =0
as

create table #CorrTemp (sampunit int, samptype char(1), qstncore int, depvar int, N money, XY money, X money, XX money, Y money, YY money)

declare @survey_id int, @qstncore int, @SQL varchar(8000), @strCore char(6), @strDepVar char(6)
select @survey_id=survey_id 
from sampleset 
where sampleset_id = (select top 1 sampset from #mrd where sampset is not null)

select @strDepVar = right('000000' + convert(varchar,@depvar),6)

declare curQ cursor for
  select distinct qstncore
  from #valid
  where qstncore not in (100001,100002) and bitMeanable = 1

open curQ
fetch next from curQ into @qstncore
while @@fetch_status=0
begin
  select @strCore = right('000000' + convert(varchar,@qstncore),6)
  select @SQL = 
     'insert into #corrtemp (sampunit,samptype,qstncore,depvar,N,XY,X,XX,Y,YY)'+
     '  select sampunit, samptype, '+@strCore+', '+@strDepVar+','+
     '    count(*) as N,'+
     '    sum(q'+@strCore+'*q'+@strDepVar+') as XY,'+
     '    sum(q'+@strCore+') as X,'+
     '    sum(power(q'+@strCore+',2)) as XX,'+
     '    sum(q'+@strDepVar+') as Y,'+
     '    sum(power(q'+@strDepVar+',2)) as YY'+
     '  from #mrd'+
     '  where isnull(q'+@strDepVar+',-9) > -8 and isnull(q'+@strCore+',-9) > -8'+
     '  group by sampunit, samptype'
  exec (@SQL)
  fetch next from curQ into @qstncore
end
close curQ
deallocate curQ

if @RootUnit_id > 0 
begin
  insert into #corrtemp
    select su.parentsampleunit_id, 'D', qstncore, depvar, sum(n), sum(xy), sum(x), sum(xx), sum(y), sum(yy)
    from #corrtemp ct, sampleunit su
    where ct.sampunit=su.sampleunit_id
      and ct.samptype='D'
      and su.parentsampleunit_id <> @rootunit_id
    group by su.parentsampleunit_id, qstncore, depvar

  insert into #corrtemp
    select su.parentsampleunit_id, 'D', qstncore, depvar, sum(n), sum(xy), sum(x), sum(xx), sum(y), sum(yy)
    from #corrtemp ct, sampleunit su
    where ct.sampunit=su.sampleunit_id
      and ct.samptype='D'
      and su.parentsampleunit_id = @rootunit_id
    group by su.parentsampleunit_id, qstncore, depvar
end

insert into #correlation (sampunit,qstncore,depvar,corrcoef)
  select sampunit,qstncore,depvar,
    ((N*XY)-(X*Y))/sqrt(1.0*((N*XX)-(power(x,2)))*((N*YY)-(power(y,2))))
  from #corrtemp 
  where sqrt(1.0*((N*XX)-(power(x,2)))*((N*YY)-(power(y,2))))<>0

insert into #correlation (sampunit,qstncore,depvar,corrcoef)
  select sampunit,qstncore,depvar,-2
  from #corrtemp 
  where sqrt(1.0*((N*XX)-(power(x,2)))*((N*YY)-(power(y,2))))=0

drop table #CorrTemp


