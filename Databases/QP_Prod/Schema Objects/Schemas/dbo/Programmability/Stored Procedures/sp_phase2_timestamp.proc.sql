create procedure sp_phase2_timestamp
as
declare @oldmax binary(8)
select @oldmax = isnull(max(endtimestamp),0x0000000000000001) from phase2etl

insert into phase2etl (extractdate, starttimestamp)
select getdate(), @oldmax


