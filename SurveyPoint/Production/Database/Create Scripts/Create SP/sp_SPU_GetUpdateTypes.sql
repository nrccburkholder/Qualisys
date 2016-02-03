create procedure sp_SPU_GetUpdateTypes  
as  
begin  
 select * from SPU_UpdateTypes order by intorder  
end