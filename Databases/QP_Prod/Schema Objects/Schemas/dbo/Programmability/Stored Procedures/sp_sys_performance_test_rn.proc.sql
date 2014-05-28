CREATE procedure sp_sys_performance_test_rn
as
set nocount on
--THis is a little procedure that will test for "system" slowness.
declare @Cntr int
declare @Start datetime, @End Datetime
select @Start = Getdate()

set @cntr = 1

While @Cntr <= 10000
   begin
	begin tran
	insert into performance_test
	values (@cntr, 'Test record # '+convert(varchar(5), @Cntr))
	commit tran
	select @cntr = @cntr + 1
   end
select @End = GetDate()
insert into performance_log (Tran_Desc, begintime, EndTime)
values ('Insert', @Start, @End)


