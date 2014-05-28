CREATE procedure SP_Teams_PopulateTables    
AS    
set nocount on    
declare @strprocedure_nm varchar(50), @strsql varchar(1000)    
    
declare procedures cursor for    
select name from sysobjects where name like 'sp_teams_%'    
and name NOT IN  ('SP_Teams_PopulateTables','SP_Teams_ProjectStartUp')  
    
open procedures    
    
fetch next from procedures into @strprocedure_nm    
while @@fetch_status = 0    
begin    
    
  print @strprocedure_nm    
    
  set @strsql = 'exec ' + @strprocedure_nm    
    
  exec (@strsql)    
    
fetch next from procedures into @strprocedure_nm    
    
end    
    
close procedures    
deallocate procedures


