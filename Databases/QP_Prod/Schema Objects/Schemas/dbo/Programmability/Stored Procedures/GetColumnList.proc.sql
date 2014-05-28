/*  
getcolumnlist 'metatable', '', 'table_id, strtable_nm'  
getcolumnlist 's1446.big_table_2007_4', '', 'table_id, strtable_nm'  
*/  
--DRM 5/23/2008    
CREATE procedure [dbo].[GetColumnList]     
 @pTableName varchar(50),    
 @pAlias varchar(20) = '',    
 @pExcludeColumnList varchar(200) = ''
as    
    
declare @ColumnName varchar(50)    
declare @Columns varchar(4000)    
declare @Alias varchar(20)    
declare @ExcludeColumnList varchar(200)    
declare @ExcludeColumn varchar(25)    
declare @i int    
    
create table #tmpColumns (ColumnName varchar(25))    
    
if @pExcludeColumnList <> ''    
begin    
 set @ExcludeColumnList = replace(@pExcludeColumnList, ' ', '')    
 set @i = patindex ('%,%', @ExcludeColumnList)    
    
 while @i > 0    
 begin    
  set @ExcludeColumn = left(@ExcludeColumnList, @i-1)    
  insert into #tmpColumns values (@ExcludeColumn)    
  set @ExcludeColumnList = right(@ExcludeColumnList, len(@ExcludeColumnList)-@i)    
  set @i = patindex ('%,%', @ExcludeColumnList)    
 end    
    
 insert into #tmpColumns values (@ExcludeColumnList)    
end    
    
if @pAlias = ''     
 set @Alias = @pAlias    
else     
 set @Alias = @pAlias + '.'    
    
declare cColumnName cursor    
for select name from syscolumns     
where id = object_id(@pTableName)    
and columnproperty(object_id(@pTableName), name, 'IsComputed') = 0    
and name not in (select * from #tmpColumns)    
order by colorder    
    
open cColumnName    
fetch next from cColumnName into @ColumnName    
set @Columns = @Alias + @ColumnName    
    
fetch next from cColumnName into @ColumnName    
    
while @@fetch_status = 0    
begin    
 set @Columns = @Columns + ', ' + @Alias + @ColumnName    
 fetch next from cColumnName into @ColumnName    
end    
    
close cColumnName    
deallocate cColumnName    
    
drop table #tmpColumns    
    
select @columns


