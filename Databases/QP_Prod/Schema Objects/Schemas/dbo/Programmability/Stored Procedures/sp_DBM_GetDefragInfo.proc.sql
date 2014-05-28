create procedure sp_DBM_GetDefragInfo @Threshold int = 75
as
set nocount on

create table tempdb..contig(crap varchar(255) null)

declare @id int, @cmd varchar(100), @density varchar(255), @pages varchar(255)
declare contigcur cursor
for select table_id from qp_defrag 

print 'Opening cursor with all tables in qp_defrag...'
open contigcur
fetch next from contigcur into @id
while @@fetch_status = 0
   begin
	set @cmd = 'master..xp_cmdshell '+ "'"+ 'isql /E /dQP_Prod /Q"dbcc showcontig('+convert(varchar(30), @id)+')"' + ' /oshowcontig.txt'+"'"
	--the showcontig file will exists on the C:\WINNT\system32 directory of the SQL server
	exec(@cmd)
	set @cmd = 'master..xp_cmdshell '+"'"+'bcp tempdb..contig in showcontig.txt /c /T'+"'"
	exec(@cmd)
	set @cmd = 'master..xp_cmdshell ''del showcontig.txt'''
	exec(@cmd)	
	--Checking the scan denisity
	select @density = crap from tempdb..contig where crap like '%Scan Density%'
	set @density = substring(@density,charindex('...:',@density), 10)
	set @density = substring(@density,5, 6)
	select  @pages = crap from tempdb..contig where crap like '%Pages Scanned%'
	set @pages = substring(@pages,charindex('...:',@pages), 10)
	set @pages = substring(@pages, 5,6)
	update qp_defrag set frag = convert(decimal(5,2), @density), pages = convert(int, @Pages) where Table_id = @id
	truncate table tempdb..contig
	fetch next from contigcur into @id
   end
close contigcur 
deallocate contigcur

Drop table tempdb..contig


