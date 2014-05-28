CREATE Procedure SP_SplitExportDBF
@Cutoff_id int, @TableNum int OUTPUT
as
--declare @cutoff_id int
--set @cutoff_id = 3949

set nocount on
declare @strCutoff_id varchar(10), @Study_id int, @strStudy_id varchar(10), @MRDTable_id int, @MRDTable_nm varchar(200), @SQL varchar(8000), @SQLInsert varchar(8000)

set @strCutoff_id = convert(varchar,@Cutoff_id)
select @Study_id = sd.study_id
from cutoff c, survey_def sd
where c.survey_id = sd.survey_id
and c.cutoff_id = @Cutoff_id

set @strStudy_id = convert(varchar,@Study_id)

--print 'Table s' + @strStudy_id + '.' + @MRDTable_nm + ' created.'
set @SQL = 'sp_export_newmrd3 ' + @strCutoff_id + ' , 1 , 1'
exec(@SQL)


set @MRDTable_nm = 'MRD_' + @strCutoff_id

select @MRDTable_id = id from sysobjects where name = @MRDTable_nm

select sc.name, case st.name when 'char' then 'char(' + convert(varchar,sc.length) + ')' when 'varchar' then 'varchar(' + convert(varchar,sc.length) + ')'else st.name end as Type, 0 as bitUsed
into #Background
from syscolumns sc, systypes st
where sc.xtype = st.xtype
and id = @MRDTable_id
and left(sc.name,2) <> 'Q0'
order by sc.colorder

select sc.name, case st.name when 'char' then 'char(' + convert(varchar,sc.length) + ')' when 'varchar' then 'varchar(' + convert(varchar,sc.length) + ')'else st.name end as Type, 0 as bitUsed
into #Questions
from syscolumns sc, systypes st
where sc.xtype = st.xtype
and id = @MRDTable_id
and left(sc.name,2) = 'Q0'
order by sc.colorder

declare @ColumnNum int
set @ColumnNum = 0
set @TableNum = 0
create table #Temp (name varchar(100), type varchar(100))

while (select count(*) from #Questions where bitUsed = 0) > 0
begin
 set @TableNum = @TableNum + 1
 set @SQL = 'create table s' + @strStudy_id + '.' + @MRDTable_nm + '_' + convert(varchar,@TableNum) + ' ('
 set @SQLInsert = 'Insert into s' + @strStudy_id + '.' + @MRDTable_nm + '_' + + convert(varchar,@TableNum) + ' select '
 while (select count(*) from #Background where bitUsed = 0) > 0
 begin
  insert into #temp
  select top 1 name, type
  from #Background where bitused = 0
  set @SQL = @SQL + (select name from #temp) + ' ' + (select type from #temp) + ', '
  set @SQLInsert = @SQLInsert + (select name from #temp) + ', '

  update b set bitUsed = 1 from #Background b, #temp t where t.name = b.name
  truncate table #temp
  set @ColumnNum = @ColumnNum + 1
 end
 
 while (@ColumnNum <= 250) and ((select count(*) from #Questions where bitUsed = 0) > 0)
 begin
  insert into #temp
  select top 1 name, type
  from #Questions where bitused = 0
  set @SQL = @SQL + (select name from #temp) + ' ' + (select type from #temp)
  set @SQLInsert = @SQLInsert + (select name from #temp)

  update q set bitUsed = 1 from #Questions q, #temp t where t.name = q.name
  truncate table #temp

  if (@ColumnNum = 250) or ((select count(*) from #Questions where bitUsed = 0) = 0)
  begin
   set @SQL = @SQL + ')'
   set @SQLInsert = @SQLInsert + ' from s' + @strStudy_id + '.' + @MRDTable_nm
  end
  else
  begin
   set @SQL = @SQL + ', '
   set @SQLInsert = @SQLInsert + ', '
  end

  set @ColumnNum = @ColumnNum + 1

 end

-- print 'Table s' + @strStudy_id + '.' + @MRDTable_nm + '_' + convert(varchar, @TableNum) + ' created.'
 exec(@SQL)
 exec(@SQLInsert)
 update #Background set bitused = 0
 set @ColumnNum = 0
end

set @SQL = 'drop table s' + @strStudy_id + '.' + @MRDTable_nm
--print 'Table s' + @strStudy_id + '.' + @MRDTable_nm + ' dropped.'
exec(@SQL)

drop table #temp
drop table #Background
drop table #Questions

--print 'Tables created = ' + convert(varchar,@TableNum)


