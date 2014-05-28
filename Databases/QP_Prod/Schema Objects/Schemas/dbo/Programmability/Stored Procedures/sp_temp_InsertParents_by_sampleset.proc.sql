CREATE   PROCEDURE sp_temp_InsertParents_by_sampleset @sampleset_id int, @Study_id int
AS
declare @pop_id int, @sampleunit_id int, @top bit

declare people cursor for
   select distinct @study_id, ss.pop_id, ss.sampleunit_id, @sampleset_id
   /*from selectedsample ss left outer join (*/
	  from #sampleunit_universe ss left outer join (
      select pop_Id, ss.sampleunit_Id 
      --from selectedsample ss, sampleunit su 
	  from #sampleunit_universe ss, sampleunit su 
      where ss.sampleunit_id = su.sampleunit_id 
      and parentsampleunit_id is null 
	  and strunitselecttype <> 'N' 
	  and removed_rule=0) as p
   on /*ss.sampleset_id = p.sampleset_id
   and */ss.pop_id = p.pop_id
   where p.sampleunit_id is null 
	  and ss.strunitselecttype <> 'N' 
	  and ss.removed_rule=0
    /*and ss.sampleset_id = @sampleset_id*/

open people

fetch next from people into @study_id, @pop_id, @sampleunit_id, @sampleset_id
while @@fetch_status = 0
begin
   set @top = 0
   while @top = 0
   begin
      set @sampleunit_id = (SELECT ParentSampleUnit_id
         FROM SampleUnit 
         WHERE SampleUnit_id = @sampleunit_id)
      if @sampleunit_id is not null and not exists(
            /*select * from selectedsample*/
			select top 1 pop_id from #sampleunit_universe 
            where /*sampleset_id = @sampleset_id
            and */pop_id = @pop_id
            and sampleunit_id = @sampleunit_id
			and strunitselecttype <> 'N' 
	  		and removed_rule=0)
	begin
         insert selectedsample (sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype)
         values (@sampleset_id, @study_id, @pop_id, @sampleunit_id, 'I')
         insert into tempinsertparents
	select @sampleset_id, @study_id, @pop_id, @sampleunit_id, 'I', getdate()
        end
      if @sampleunit_id is null
         set @top = 1
   end
   fetch next from people into @study_id, @pop_id, @sampleunit_id, @sampleset_id
end

close people
deallocate people


