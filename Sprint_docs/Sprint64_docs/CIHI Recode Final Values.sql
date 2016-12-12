/*
	Recode Final tables
*/
use qp_prod

DECLARE @sql nvarchar(max)


IF OBJECT_ID('tempdb..#Recode') IS NOT NULL DROP TABLE #Recode

select distinct [FinalTable],[FinalField]
INTO #Recode
from cihi.recode
order by FinalTable

select * from #recode

DECLARE @FinalTable varchar(50)
DECLARE @FinalField varchar(100)

SELECT top 1 @FinalTable = FinalTable, @FinalField = FinalField FROM #Recode
WHILE @@rowcount > 0
begin

	select distinct @sql ='
	update f 
		set f.['+r.Finalfield+'] = r.CIHIValue,f.['+r.FinalField+'System]=r.codesystem
	from cihi.[' + FinalTable + '] f
	join cihi.recode r on f.[' + r.FinalField + ']=r.nrcValue
	where r.finalTable=''' + r.FinalTable + ''' and r.finalField = ''' + r.FinalField + ''' '
	from cihi.Recode r
	WHERE r.FinalTable = @FinalTable
	and r.FinalField = @FinalField

	print @sql

	exec sp_executesql @sql

	DELETE FROM #Recode where FinalTable = @FinalTable and FinalField = @FinalField
	SELECT top 1 @FinalTable = FinalTable, @FinalField = FinalField FROM #Recode
end


GO