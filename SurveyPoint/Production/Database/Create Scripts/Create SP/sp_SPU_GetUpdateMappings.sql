create procedure sp_SPU_GetUpdateMappings   
@UpdateTypeID int  
as  
begin  
 select * from SPU_UpdateMappings where updateTypeID = @UpdateTypeID order by intorder  
end