/***********************************************************************************
	Procedure SP_SAMP_AddTreeIndex
	Description - This SP will add units to the SampleUnitTreeIndex table
	Input
		@sampleplan_id 

	v1.0 May 12, 2004 DC Initial Build
*************************************************************************************/
CREATE  procedure SP_SAMP_AddTreeIndex
	@sampleplan_id int
as
Declare @sampleunit_id int, @parentunit int

create table #units (sampleunit_id int)
create table #Ancestor (sampleunit_id int, ancestor_id int)

delete st
from SampleUnitTreeIndex st, sampleunit s
where st.sampleunit_id=s.sampleunit_Id and
	  s.sampleplan_id=@sampleplan_id

insert into #units
select sampleunit_id
from sampleunit 
where sampleplan_id=@sampleplan_id

select top 1 @sampleunit_id=sampleunit_id
from #units

while @@rowcount > 0
Begin

	select @parentunit=parentsampleunit_Id
	from sampleunit
	where sampleunit_id=@sampleunit_Id and
			parentsampleunit_id is not null

	While @@rowcount > 0
	Begin
		insert into #Ancestor values (@sampleunit_Id, @parentunit)

		select @parentunit=parentsampleunit_Id
		from sampleunit
		where sampleunit_id=@parentunit and
			parentsampleunit_id is not null

	End

	delete 
	from #units
	where sampleunit_id=@sampleunit_id

	select top 1 @sampleunit_id=sampleunit_id
	from #units
End

insert into SampleUnitTreeIndex
select * 
from #Ancestor

drop table #units
drop table #Ancestor


