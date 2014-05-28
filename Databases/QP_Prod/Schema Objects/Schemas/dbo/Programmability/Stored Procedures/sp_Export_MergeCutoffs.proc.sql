create procedure dbo.sp_Export_MergeCutoffs
@into int, @from int
as
begin transaction
update questionform set cutoff_id=@into where cutoff_id=@from
delete from cutoff where cutoff_id=@from
commit transaction


