/*      
MWB 11/08/2007      
This procedure will Enable or Disable all triggers in the database.      
Version 1.0 Origional      
*/      
CREATE procedure dbo.sp_ChangeAllTriggerStatus (      
@EnableDisableFlag varchar(10)      
)      
as      
begin      
      
declare @ReverseFlag varchar(10)      
declare @OwnerName varchar(100), @TableName varchar(100), @TriggerName varchar(100)      
Declare @SQL varchar(8000)      
Declare @SQLEnableDisableFlag varchar(100)    
      
set @SQLEnableDisableFlag = @EnableDisableFlag    
    
if @EnableDisableFlag = 'Enable'      
 begin      
  set @EnableDisableFlag = 'Enabled'      
  set @ReverseFlag = 'Disabled'      
 end      
else      
 begin      
  set @EnableDisableFlag = 'Disabled'      
  set @ReverseFlag = 'Enabled'      
 end      
      
      
--create temp table to hold status of all triggers in DB      
create table #Trig (OwnerName varchar(100), TableName varchar(100), TriggerName varchar(100), Status varchar(100))            
           
--now populate table with values       
insert into #Trig exec sp_GetDBTriggerInfo      
      
      
/*      
--now create a new temp table to hold only the triggers that were previously enabled.      
--We will use this later to re-enable triggers      
select *       
into #TrigWasEnabled      
from #Trig       
where Status = 'Enabled'      
*/      
      
DECLARE TrigCursor CURSOR FOR       
SELECT OwnerName, TableName, TriggerName from #Trig where Status = @ReverseFlag      
      
OPEN TrigCursor      
FETCH NEXT FROM TrigCursor       
INTO @OwnerName, @TableName, @TriggerName      
      
WHILE @@FETCH_STATUS = 0      
BEGIN      
      
 set @SQL = 'Alter Table ' + @OwnerName + '.' + @TableName + ' ' + @SQLEnableDisableFlag + ' TRIGGER ' + @TriggerName      
 print @SQL      
 Exec (@SQL)      
      
 FETCH NEXT FROM TrigCursor       
 INTO @OwnerName, @TableName, @TriggerName      
      
END      
      
CLOSE TrigCursor      
DEALLOCATE TrigCursor      
      
end      