/*
12/2/07 MWB
Purpose:
Generic CRUD Statement to Select records from SPU_FileTrackingLog
Version 1.0 Original
*/
Create PROCEDURE sp_SPU_GetFileTrackingLog    
 (@FileLogID  [int] = -1,   
  @FileName  varchar(100)  = '',   
  @NumRecordsInFile  [int]= -1,    
  @NumMissingEventCodes  [int]= -1,   
  @UpdateTypeID  [int]= -1,  
  @UserID  [int] = -1  
  )  
    
AS     
BEGIN    
  
declare @SQL varchar(8000)  
  
Set @SQL = 'Select * from SPU_FileTrackingLog Where '  
  
print 'before @FileLogID check ' + cast(@FileLogID as varchar(100))  
if @FileLogID not in (-1,0)  
 set @SQL = @SQL + 'FileLogID = ' + cast(@FileLogID as varchar(10)) + ' and '  
  
print 'before @FileName check ' + cast(@FileLogID as varchar(100))  
if @FileName <> ''  
 set @SQL = @SQL + 'FileName = ''' + @FileName + ''' and '  
  
print 'before @NumRecordsInFile check ' + cast(@NumRecordsInFile as varchar(100))  
if @NumRecordsInFile <> -1   
 set @SQL = @SQL + 'NumRecordsInFile = ' + cast(@NumRecordsInFile as varchar(10)) + ' and '  
  
print 'before @NumMissingEventCodes check ' + cast(@NumMissingEventCodes as varchar(100))  
if @NumMissingEventCodes <> -1   
 set @SQL = @SQL + 'NumMissingEventCodes = ' + cast(@NumMissingEventCodes as varchar(10)) + ' and '  
  
print 'before @UpdateTypeID check ' + cast(@UpdateTypeID as varchar(100))  
if @UpdateTypeID <> -1   
 set @SQL = @SQL + 'UpdateTypeID = ' + cast(@UpdateTypeID as varchar(10)) + ' and '  
  
print 'before @UserID check ' + cast(@UserID as varchar(100))  
if @UserID <> -1   
 set @SQL = @SQL + 'UserID = ' + cast(@UserID as varchar(10)) + ' and '  
  
if @SQL = 'Select * from SPU_FileTrackingLog Where '  
 set @SQL = left(@SQL, len(@SQL)-6)  
else  
 set @SQL = left(@SQL, len(@SQL)-4)  
  
print @SQL  
Exec (@SQL)  
  
end  