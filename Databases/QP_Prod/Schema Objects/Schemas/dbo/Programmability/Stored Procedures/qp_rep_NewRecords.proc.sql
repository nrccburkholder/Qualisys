CREATE procedure qp_rep_NewRecords
  @associate varchar(50), @client varchar(50), @study varchar(50), @dataset datetime
as
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

create table #result (strRow varchar(2000))
declare @datThisDataSet datetime
declare @datPrevDataSet datetime
declare @study_id integer
declare @table_id integer
declare @lookuptable_nm varchar(20)
declare @sql varchar(2000), @hdr varchar(2000)

select @datThisDataSet=datLoad_dt, @study_id=study_id 
from data_set 
where datLoad_dt=@dataset

select top 1 @datPrevDataSet=isnull(datLoad_dt,'1/1/1900') 
from data_set 
where study_id=@study_id
  and datload_dt < @datThisDataSet 
order by datload_dt desc

declare curTbl cursor for
  select table_id, strtable_nm 
  from metatable 
  where study_id=@study_id 
    and strtable_nm <> 'POPULATION'
    and strtable_nm <> 'ENCOUNTER'
open curTbl
fetch next from curTbl into @table_id, @lookuptable_nm
if @@fetch_status=0
begin
  while @@fetch_status=0 
  begin
    insert #result values (upper(@lookuptable_nm))
    declare @fld varchar(20), @dtype char(1)
    declare curFld cursor for
      select rtrim(strfield_nm), strfielddatatype 
      from metastructure ms, metafield mf 
      where table_id=@table_id and ms.field_id=mf.field_id
    select @sql='', @hdr=''
    open curFld
    fetch next from curFld into @fld, @dtype
    while @@fetch_status=0
    begin
      select @sql=@sql+case when @dtype='S' then 'isnull('+@fld+','''')' else 'isnull(convert(varchar,'+@fld+'),'''')' end + '+char(9)+ '
      select @hdr = @hdr + @fld + char(9)
      fetch next from curFld into @fld, @dtype
    end
    close curFld
    deallocate curFld
    insert #result values (@hdr)
    select @sql= 'insert into #result select '+@sql+''''' from s'+convert(varchar,@study_id)+'.'+@lookuptable_nm+' where newrecorddate between '''+convert(varchar,@datPrevDataSet,109)+''' and '''+convert(varchar,@datThisDataSet,109)+''' order by newrecorddate'
    exec (@sql)
    insert #result values ('')
    fetch next from curTbl into @table_id, @lookuptable_nm
  end
end else
  insert #result values ('This study doesn''t use any lookup tables')

close curTbl
deallocate curTbl

select strRow as [New Records] from #result
drop table #result

insert dashboardlog (report, associate, client, study, procedurebegin, procedureend) 
values ('NewRecords', @associate, @client, @study, @procedurebegin, getdate())

set transaction isolation level read committed


