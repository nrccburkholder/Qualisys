/****** Object:  Stored Procedure dbo.sp_temp_InsertParents    Script Date: 5/11/00 9:28:19 PM ******/
/****** Business Purpose:  Insert parent criteria for sampleunits ******/
CREATE PROCEDURE sp_temp_InsertParents
AS
declare @study_id int, @pop_id int, @sampleunit_id int, @sampleset_id int, @top bit

declare people cursor for
   select distinct ss.study_id, ss.pop_id, ss.sampleunit_id, ss.sampleset_id
   from selectedsample ss left outer join (
      select ss.* 
      from selectedsample ss, sampleunit su 
      where ss.sampleunit_id = su.sampleunit_id 
      and parentsampleunit_id is null ) as p
   on ss.sampleset_id = p.sampleset_id
   and ss.pop_id = p.pop_id
   where p.sampleunit_id is null

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
            select * from selectedsample 
            where sampleset_id = @sampleset_id
            and pop_id = @pop_id
            and sampleunit_id = @sampleunit_id)
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


