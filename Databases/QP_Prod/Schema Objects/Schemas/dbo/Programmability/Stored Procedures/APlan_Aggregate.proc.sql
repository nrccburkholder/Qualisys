create procedure APlan_Aggregate
  @rootunit_id int =0
as
declare @Survey_id int, @QstnCore int, @SQL varchar(8000)

select @Survey_id=Survey_id 
from Sampleset 
where Sampleset_id = (select top 1 Sampset from #mrd)

declare curQ cursor for 
  select distinct QstnCore
  from #Valid
  where QstnCore not in (100001,100002) and bitMeanable<>2

open curQ
fetch next from curQ into @QstnCore
while @@fetch_status=0
begin
  select @SQL = 
    'insert into #Agg (SampUnit,QstnCore,Response,Cnt) '+
    'select SampUnit, '+convert(varchar,@QstnCore)+', -9, count(*) '+
    'from #MRD '+
    'where samptype=''D'' '+
    '  and q'+right('00000'+convert(varchar,@QstnCore),6)+' in (-8,-9) '+
    'group by SampUnit'
  execute (@SQL)
  select @SQL = 
    'insert into #Agg (SampUnit,QstnCore,Response,Cnt) '+
    'select SampUnit, '+convert(varchar,@QstnCore)+', -10, count(*) '+
    'from #MRD '+
    'where samptype=''D'' '+
    '  and isNULL(q'+right('00000'+convert(varchar,@QstnCore),6)+',-9)>-8 '+
    'group by SampUnit'
  execute (@SQL)
  fetch next from curQ into @QstnCore
end
close curQ
deallocate curQ

declare @MinResp int, @MaxResp int, @i int
declare curQ cursor for 
  select QstnCore, min(intResponseVal), max(intResponseVal)
  from #Valid
  where QstnCore not in (100001,100002) and bitMeanable=2
  group by QstnCore

open curQ
fetch next from curQ into @QstnCore, @MinResp, @MaxResp
while @@fetch_status=0
begin
  select @SQL='coalesce(', @i = @MinResp
  while @i <= @MaxResp 
  begin
    select @SQL = @SQL + 'q'+right('00000'+convert(varchar,@QstnCore),6)+case when @i between 1 and 26 then char(96+@i) else '' end + ','
    select @i=@i+1
  end
  select @SQL = left(@SQL,len(@SQL)-1) + ')'

  select @SQL = 
    'insert into #Agg (SampUnit,QstnCore,Response,Cnt,bitMeanable) '+
    'select SampUnit, '+convert(varchar,@QstnCore)+',-10, count(*),2 '+
    'from #MRD '+
    'where samptype=''D'''+
    '  and '+@SQL+' is not null '+
    'group by SampUnit'
  exec (@SQL)
  fetch next from curQ into @QstnCore, @MinResp, @MaxResp
end
close curQ
deallocate curQ

insert into #Agg (SampUnit, QstnCore, Response, Cnt, bitMeanable)
  select a.SampUnit, v.QstnCore, v.intResponseVal, 0, v.bitMeanable
  from #Valid v, (select SampUnit, QstnCore from #Agg where Response<-8 group by SampUnit,QstnCore having sum(Cnt)>0) a
  where v.QstnCore=a.QstnCore

declare curQV cursor for
  select distinct QstnCore
  from #Valid
  where QstnCore not in (100001,100002)
    and bitMeanable <> 2

open curQV
fetch next from curQV into @QstnCore
while @@fetch_status=0
begin
  select @SQL = 
     'update a '+
     'set Cnt = c.Cnt '+
     'from #Agg a, (select SampUnit, '+convert(varchar,@QstnCore)+' as QstnCore, q'+right('00000'+convert(varchar,@QstnCore),6)+' as Response, count(*) as Cnt '+
                   'from #MRD '+
                   'where samptype=''D'' '+
                   'group by SampUnit, q'+right('00000'+convert(varchar,@QstnCore),6)+') c '+
     'where a.SampUnit = c.SampUnit '+
     '  and a.QstnCore=c.QstnCore '+
     '  and a.Response=c.Response'
  execute (@SQL)
  fetch next from curQV into @QstnCore
end
close curQV
deallocate curQV

declare @resp int
declare curQV cursor for
  select distinct QstnCore, intResponseVal
  from #Valid
  where QstnCore not in (100001,100002)
    and bitMeanable = 2

open curQV
fetch next from curQV into @QstnCore, @resp
while @@fetch_status=0
begin
  select @SQL = 
     'update a '+
     'set Cnt = c.Cnt '+
     'from #Agg a, (select SampUnit, '+convert(varchar,@QstnCore)+' as QstnCore, '+convert(varchar,@resp)+' as Response, count(*) as Cnt '+
                   'from #MRD '+
                   'where samptype=''D'' '+
                   ' and q'+right('00000'+convert(varchar,@QstnCore),6)+case when @resp between 1 and 26 then char(96+@resp) else '' end+' is not NULL '+
                   'group by SampUnit) c '+
     'where a.SampUnit = c.SampUnit '+
     '  and a.QstnCore=c.QstnCore '+
     '  and a.Response=c.Response'
  exec (@SQL)
fetch next from curQV into @QstnCore, @resp
end
close curQV
deallocate curQV

insert into #Agg (SampUnit,QstnCore,Response,Cnt) 
  select SampUnit, 0, -11, count(*) from #MRD where samptype='D' group by SampUnit

insert into #Agg (sampunit,qstncore,response,cnt,bitMeanable)
  select A.Sampunit,A.QstnCore,-9,B.Cnt-A.Cnt,2
  from #Agg A, #Agg B
  where A.bitMeanable=2
    and A.Response=-10
    and B.Response=-11
    and A.Sampunit=B.Sampunit

insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100001,1,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100001,2,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100001,-9,0 from #mrd

insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,1,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,2,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,3,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,4,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,5,0 from #mrd
insert into #Agg (SampUnit,QstnCore,Response,Cnt)
  select distinct SampUnit,100002,-9,0 from #mrd

update a
  set Cnt = c.Cnt
from #Agg a, 
  (select SampUnit,100001 as QstnCore,case when sex='M' then 1 when sex='F' then 2 else -9 end as Response, count(*) as Cnt
   from #MRD where samptype='D'
   group by SampUnit,case when sex='M' then 1 when sex='F' then 2 else -9 end) c
where a.SampUnit=c.SampUnit
  and a.QstnCore=c.QstnCore
  and a.Response=c.Response

update a
  set Cnt = c.Cnt
from #Agg a,
  (select SampUnit,100002 as QstnCore,
          case when age < 18 then 1 
               when age between 18 and 34 then 2 
               when age between 35 and 44 then 3
               when age between 45 and 64 then 4
               when age >= 65 then 5
               else -9
          end as Response, count(*) as Cnt
  from #MRD where samptype='D'
  group by SampUnit, case when age < 18 then 1 
                          when age between 18 and 34 then 2 
                          when age between 35 and 44 then 3
                          when age between 45 and 64 then 4
                          when age >= 65 then 5
                          else -9
                     end) c
where a.SampUnit=c.SampUnit
  and a.QstnCore=c.QstnCore
  and a.Response=c.Response


if @Rootunit_id <> 0 
begin
  insert into #Agg (SampUnit,QstnCore,Response,Cnt) 
    select su.parentsampleunit_id, QstnCore, Response, sum(Cnt) 
    from #Agg, sampleunit su
    where #Agg.SampUnit=su.sampleunit_id
      and su.parentsampleunit_id <> @rootunit_id
    group by su.parentsampleunit_id, QstnCore, Response

  insert into #Agg (SampUnit,QstnCore,Response,Cnt) 
    select su.parentsampleunit_id, QstnCore, Response, sum(Cnt) 
    from #Agg, sampleunit su
    where #Agg.SampUnit=su.sampleunit_id
      and su.parentsampleunit_id = @rootunit_id
    group by su.parentsampleunit_id, QstnCore, Response
end

update #Agg
  set bitMeanable=b.bitMeanable
  from #boxes b
  where #Agg.QstnCore=b.QstnCore


