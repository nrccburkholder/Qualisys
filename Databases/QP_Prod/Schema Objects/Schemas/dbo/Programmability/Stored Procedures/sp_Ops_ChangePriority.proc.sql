Create Procedure sp_Ops_ChangePriority @Survey_id int, @Priority int
as
if @Priority < 10 and @Priority > 0 
   begin 
	Update Survey_def
	set Priority_flg = @Priority
	Where Survey_id = @Survey_id
   end
Else
   begin
	Print 'Invalid Priority must be between 1 and 10.'
   end


