CREATE procedure SP_DBM_UnArchive_Big_View @study INT
as
declare @sql varchar(1000), @strsql varchar(8000), @survey int, @fld varchar(50), @short varchar(42), @lookup varchar(42)
declare @sel varchar(8000), @table varchar(42), @strfrom varchar(2000), @strwhere varchar(8000), @master varchar(42)

set @strsql = 'if exists (select * from sysobjects where id = object_id(N''[S' + convert(varchar,@study)+'].[BIG_VIEW]'') ' +
	' and OBJECTPROPERTY(id, N''IsView'') = 1) drop view [S' + convert(varchar,@study) + '].[BIG_VIEW]'
exec(@strsql)

/*
select @table = table_id from metatable where study_id = @study and strtable_nm = 'ENCOUNTER'
if @@rowcount = 0
  begin
	select @table = table_id from metatable where study_id = @study and strtable_nm = 'POPULATION'
	select @sql = 'and uk.table_id = '+ convert(varchar,@table)
	end
  else
	select @sql = 'and uk.table_id = '+ convert(varchar,@table) + ' and uk.keyvalue = bv.encounterenc_id '
*/

--list of fields
select distinct mt.table_id, ms.field_id, strfield_nm as short, strTable_nm, convert(varchar(60),'') as fldnm 
into #selclause
from metatable mt, metastructure ms, metafield mf
where mt.table_id = ms.table_id
and ms.field_id = mf.field_id
and mt.study_id = @study
and ms.bitpostedfield_flg = 1

update #selclause
set fldnm = mt.strtable_nm + mf.strfield_nm
from metatable mt, metastructure ms, metafield mf
where mt.table_id = ms.table_id
and ms.field_id = mf.field_id
and mt.study_id = @study
and #selclause.short = mf.strfield_nm
and ms.bitpostedfield_flg = 1

--list of distinct tables
select distinct strtable_nm
into #table
from #selclause

set @sel = ''
set @strfrom = ''

While (select count(*) from #table) > 0
begin
set @table = (select top 1 strtable_nm from #table)
  if @strfrom = ''
     begin
       select @strfrom = @strfrom + 's' + CONVERT(VARCHAR,@study) + '.' + @table 
     end
  else
     begin
       select @strfrom = @strfrom + ', s' + CONVERT(VARCHAR,@study) + '.' + @table 
     end
 delete #table where strtable_nm = @table
 print @strfrom
end

while (select count(*) from #selclause) > 0
begin  --1

set rowcount 1

select @short = short, @table = strtable_nm, @fld = fldnm
from #selclause order by 1,2

set rowcount 0

if @sel = ''
begin  --2
	select @sel = @sel + @fld + '=s' + CONVERT(VARCHAR,@study) + '.' + @table + '.' + @short 
end  --2
else
begin  --3
	select @sel = @sel + ',' + @fld + '=s' + CONVERT(VARCHAR,@study) + '.' + @table + '.' + @short 
end  --3

delete #selclause where short = @short and strtable_nm = @table and fldnm = @fld

print 'Here I am'

end  --1

set @strwhere = ''

select strtable_nm Master, strfield_nm MField, lookuptablename Lookup, lookupfieldname LField
into #where
from metalookup_view 
where study_id = @study

while (select count(*) from #where) > 0
begin  --4

set @table = (select top 1 lookup from #where)
set @fld = (select top 1 lfield from #where where lookup = @table)
set @master = (select master from #where where lookup = @table and lfield = @fld)

delete #where where lookup = @table and lfield = @fld

if @strwhere = ''
begin  --5
set @strwhere = 'where s' + convert(varchar,@study) + '.' + @master + '.' + @fld + ' = s' + convert(varchar,@study) + '.' + @lookup + '.' + @fld
print @strwhere
end  --5

else
begin  --6
set @strwhere = @strwhere + ' and s' + convert(varchar,@study) + '.' + @master + '.' + @fld + ' = s' + convert(varchar,@study) + '.' + @lookup + '.' + @fld
print @strwhere
end  --6

end  --4

print '@sel = ' + @sel
print '@strfrom = ' + @strfrom
print '@strwhere = ' + @strwhere

set @strsql = 'alter VIEW S' + convert(varchar,@study) + '.BIG_VIEW AS ' +
		' select ' + @sel +
		' from ' + @strfrom +
		@strwhere

print @strsql

drop table #selclause
drop table #where


