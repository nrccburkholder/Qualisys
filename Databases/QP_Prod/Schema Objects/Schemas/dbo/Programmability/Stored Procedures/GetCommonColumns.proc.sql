/*          
getcommoncolumns 's1607.arch_big_table_2009_1', 's2237.big_table_2009_1'    
*/          
--DRM 4/9/2010    
CREATE procedure [dbo].[GetCommonColumns]    
 @pTableName1 varchar(50),            
 @pTableName2 varchar(50),            
 @pAlias varchar(20) = ''
 --,@pShowLength bit = 1
as            
    
/*    
--for testing    
declare @ptablename1 varchar(50)    
declare @ptablename2 varchar(50)    
declare @palias varchar(20)    
set @ptablename1 = 's1607.big_table_2009_1'    
set @ptablename2 = 's2237.big_table_2009_1'    
*/    
    
    
declare @ColumnName varchar(50)            
declare @Columns varchar(8000)            
declare @Alias varchar(20)            
declare @i int            
            
if @pAlias = ''             
 set @Alias = @pAlias            
else             
 set @Alias = @pAlias + '.'            
    
    
select name into #tmp1    
from syscolumns     
where id = object_id(@pTableName1)            
and columnproperty(object_id(@pTableName1), name, 'IsComputed') = 0            
order by colorder      
    
select name into #tmp2    
from syscolumns     
where id = object_id(@pTableName2)            
and columnproperty(object_id(@pTableName2), name, 'IsComputed') = 0            
order by colorder      
    
declare cColumnName cursor            
for select t1.name     
from #tmp1 t1 inner join #tmp2 t2    
 on t1.name = t2.name    
            
open cColumnName            
fetch next from cColumnName into @ColumnName            
set @Columns = @Alias + @ColumnName            
            
fetch next from cColumnName into @ColumnName            
            
while @@fetch_status = 0            
begin            
 set @Columns = @Columns + ',' + @Alias + @ColumnName            
 fetch next from cColumnName into @ColumnName            
end            
            
close cColumnName            
deallocate cColumnName            
    

--if @pShowLength = 1 select len(@columns) as [Length of column list]
if len(@columns) >= 8000
begin
	print 'Error: return string too long.'
	return -1
end

select @columns  as [Column list]


