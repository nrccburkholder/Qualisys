
Create procedure dbo.sp_SPU_GetRespondentsUpdated
(
	@RespondentID int = -1,
	@FileLogID int = -1,
	@UpdatedDate datetime = '1900-01-01 00:00:00'  
)
as
BEGIN    

declare @SQL varchar(8000)  
  
Set @SQL = 'Select Distinct * from SPU_RespondentsUpdated Where '  
  
if @RespondentID not in (-1,0)  
 set @SQL = @SQL + 'RespondentID = ' + cast(@RespondentID as varchar(10)) + ' and '  
  

if @FileLogID <> -1 
 set @SQL = @SQL + 'FileLogID = ' + cast(@FileLogID as varchar(10)) + ' and '  
  
if @UpdatedDate <> '1900-01-01 00:00:00'   
 set @SQL = @SQL + 'convert(varchar, UpdatedDate, 101) = convert(varchar, ''' + cast(convert(varchar, @UpdatedDate,101) as varchar(30)) + ''', 101) and '  

if @SQL = 'Select Distinct * from SPU_RespondentsUpdated Where '  
 set @SQL = left(@SQL, len(@SQL)-6)  
else  
 set @SQL = left(@SQL, len(@SQL)-4)  
  
print @SQL  
Exec (@SQL)  
  
END    
