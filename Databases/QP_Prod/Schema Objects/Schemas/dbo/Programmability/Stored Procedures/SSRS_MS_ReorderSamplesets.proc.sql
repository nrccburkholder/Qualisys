CREATE procedure [dbo].[SSRS_MS_ReorderSamplesets]  
 @samplesets nvarchar(max)  
  
as  
  
declare @ss nvarchar(max),@sampleset_id int,@sql nvarchar(max) --exec ssrs_ms_reordersamplesets '2,3,4,5'  
set @ss=''  
  
create table #ss (sampleset_id int,Done bit)  
  
set @sql=  
'insert #ss (sampleset_id,Done)'+char(10)+  
'select sampleset_id,0'+char(10)+  
'from sampleset (nolock)'+char(10)+  
'where sampleset_id in ('+@samplesets+')'+char(10)  
  
exec (@sql)  
  
select top 1 @sampleset_id=sampleset_id  
from #ss  
where Done=0  
order by sampleset_id  
  
while @@rowcount>0  
  
begin  
set @ss=@ss+convert(varchar,@sampleset_id)+','  
  
update #ss  
set Done=1  
where sampleset_id=@sampleset_id  
  
select top 1 @sampleset_id=sampleset_id  
from #ss  
where Done=0  
order by sampleset_id  
  
end  
  
select substring(@ss,1,len(@ss)-1) samplesets  
  
drop table #ss


