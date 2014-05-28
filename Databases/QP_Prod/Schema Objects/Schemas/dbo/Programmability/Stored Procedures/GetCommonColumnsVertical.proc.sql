/*          
GetCommonColumnsVertical 's1607.arch_big_table_2009_1', 's2237.big_table_2009_1'    
*/          
--DRM 1/6/2011
create procedure [dbo].[GetCommonColumnsVertical]
 @pTableName1 varchar(50),            
 @pTableName2 varchar(50),            
 @pAlias varchar(20) = ''
as            
    
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
    
select t1.name as ColumnName
from #tmp1 t1 inner join #tmp2 t2    
 on t1.name = t2.name


