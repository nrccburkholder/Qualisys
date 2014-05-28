create procedure sp_DBM_Defrag @Threshold int = 75
as
set nocount on
declare @Table_nm varchar(100), @cmd varchar(100)
declare tablecur cursor 
for select Table_nm 
    from   qp_defrag
    where  Frag < @Threshold
      and  Pages > 1000
      and  DefragIt = 1
       or  defragIt = 1

open tablecur
fetch next from tablecur into @table_nm
while @@fetch_status = 0
   begin
	Update qp_defrag set Start_defrag = getdate(), End_defrag = null where table_nm = @Table_nm 
	set @cmd = 'dbcc dbreindex("'+@Table_nm+'")'
	exec(@cmd)
	Update qp_defrag set End_defrag = getdate(), Defragit = 0 where table_nm = @Table_nm 
	fetch next from tablecur into @table_nm
   end
close tablecur
deallocate tablecur


