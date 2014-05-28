CREATE procedure sp_SampleUnits
  @intSamplePlan_id int, @IndentSize int = 2
as 
declare @tier int, @indent varchar(100)
set @tier=0
set @indent=''

create table #SU
 (SampleUnit_id int,
  strSampleUnit_nm varchar(255),
  intTier int,
  strNode varchar(255),
  intTreeOrder int)

insert into #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode)
  select sampleunit_id,strsampleunit_nm,1,convert(varchar,sampleunit_id)
  from sampleunit where sampleplan_id=@intSamplePlan_id and parentsampleunit_id  is null

while (@@rowcount > 0)
begin
  set @tier = @tier + 1
  set @indent=@indent + replicate(' ',@indentsize)
  insert into #SU (SampleUnit_id, strSampleUnit_nm, intTier, strNode)
   select su.sampleunit_id,@indent+su.strsampleunit_nm,@tier+1,t.strNode+'.'+right('000000'+convert(varchar,su.sampleunit_id),7)
   from sampleunit su, #SU t
   where su.sampleplan_id=@intSamplePlan_id
     and su.parentsampleunit_id = t.sampleunit_id 
     and t.intTier=@tier
end

declare @treeorder int
set @treeorder = 1
update #SU 
 set intTreeOrder = @treeorder 
 where strNode = (select min(strNode) from #su where intTreeOrder is null)
while @@rowcount > 0
begin
  set @treeorder = @treeorder + 1
  update #SU 
   set intTreeOrder = @treeorder 
   where strNode = (select min(strNode) from #su where intTreeOrder is null)
end

insert into #SampleUnits (sampleunit_id,strSampleUnit_nm,intTier,intTreeOrder)
  Select sampleunit_id,strSampleUnit_nm,intTier,intTreeOrder
  from #SU
  order by strnode

drop table #SU


