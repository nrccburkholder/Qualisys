create procedure sp_Export_Norm
  @survey_id int, @start_dt datetime = '1/1/1990', @stop_dt datetime = '12/31/3000'
as
create table #MyNorm (qstncore int, intresponseval int, nsize int)

select qstncore,val,missing
into #valid
from sel_qstns sq, sel_scls ss
where sq.survey_id=@survey_id
  and sq.survey_id=ss.survey_id
  and sq.scaleid=ss.qpc_id
  and sq.subtype=1
  and sq.language=1
  and ss.language=1

insert into #MyNorm
  select n.qstncore,n.intresponseval,sum(Nsize) as nsize
  from NRCNorms10192000 N, Sel_qstns sq, #Valid V
  where n.qstncore=sq.qstncore
    and sq.subtype=1
    and sq.language=1
    and sq.survey_id=@survey_id
    and sq.qstncore=v.qstncore
    and n.intresponseval=v.val
    and n.datreturned between @start_dt and @stop_dt
  group by n.qstncore,n.intresponseval

insert into #MyNorm
  select n.qstncore,n.intresponseval,sum(Nsize) as nsize
  from NRCNorms10192000 N, Sel_qstns sq
  where n.qstncore=sq.qstncore
    and sq.subtype=1
    and sq.language=1
    and sq.survey_id=@survey_id
    and n.intresponseval<=-8
    and n.datreturned between @start_dt and @stop_dt
  group by n.qstncore,n.intresponseval

--create table #freq (intresponseval int)
--create table #mean (stattype char(2))

declare @sql varchar(8000), @core char(7)

declare QstnCur cursor for 
  select distinct 'Q'+right('00000'+convert(varchar,qstncore),6) from #MyNorm 

set @SQL = ' add '
OPEN QstnCur
FETCH NEXT FROM QstnCur into @Core
WHILE @@FETCH_STATUS = 0
BEGIN
  set @SQL = @SQL + @core+' money, '
  FETCH NEXT FROM QstnCur into @Core
END
CLOSE QstnCur
DEALLOCATE QstnCur
set @SQL = left(@SQL,len(@SQL)-1)
exec ('alter table #Freq' + @SQL)
exec ('alter table #Mean' + @SQL)

insert into #Freq (intresponseval)
  select distinct intresponseval from #MyNorm order by intresponseval

insert #Freq (intresponseval) values (-1000)

insert #Mean (Stattype) values ('NU')
insert #Mean (Stattype) values ('NW')
insert #Mean (Stattype) values ('SM')
insert #Mean (Stattype) values ('SS')

declare QstnCur cursor for 
  select distinct right('00000'+convert(varchar,qstncore),6) from #MyNorm 
OPEN QstnCur
FETCH NEXT FROM QstnCur into @Core
WHILE @@FETCH_STATUS = 0
BEGIN
  set @SQL = 'update F set Q'+@core+'=NSize from #Freq F, #MyNorm N where f.intresponseval=N.intresponseval and N.Qstncore='+@core
  exec (@SQL)
  set @SQL = 'update #Freq set Q'+@core+' = Stat from (select stat=sum(q'+@core+') from #freq F, #valid V where v.qstncore='+@core+' and f.intresponseval=v.val and v.missing=0) sub where intResponseVal=-1000'
  exec (@SQL)
  set @SQL = 'update #Mean set Q'+@core+' = Stat from (select stat=sum(q'+@core+') from #freq F, #valid V where v.qstncore='+@core+' and f.intresponseval=v.val and v.missing=0) sub where stattype=''NU'' or stattype=''NW'''
  exec (@SQL)
  set @SQL = 'update #Mean set Q'+@core+' = Stat from (select stat=sum(intresponseval*q'+@core+') from #freq F, #valid V where v.qstncore='+@core+' and f.intresponseval=v.val and v.missing=0) sub where stattype=''SM'''
  exec (@SQL)
  set @SQL = 'update #Mean set Q'+@core+' = Stat from (select stat=sum(intresponseval*intresponseval*q'+@core+') from #freq F, #valid V where v.qstncore='+@core+' and f.intresponseval=v.val and v.missing=0) sub where stattype=''SS'''
  exec (@SQL)
  FETCH NEXT FROM QstnCur into @Core
END
CLOSE QstnCur
DEALLOCATE QstnCur

drop table #MyNorm
drop table #valid


