/*
MWB 11/08/2007
This procedure will return the status (Enabled or Disabled) for all triggers in the database.
*/
create Procedure sp_GetDBTriggerInfo (
@TABLENamePattern as sysname = NULL, @StatusToGet as varchar(10) = 'ALL'
)
as 
begin

create table #Trig (OwnerName varchar(100), TableName varchar(100), TriggerName varchar(100), Status varchar(100))      

insert into #Trig
SELECT TOP 100 PERCENT WITH TIES
USER_NAME(OBJECTPROPERTY(T.id, 'OwnerId')) AS OwnerName, T.[name] as TableName, TR.[Name] as TriggerName, 
CASE 
	WHEN 1=OBJECTPROPERTY(TR.[id], 'ExecIsTriggerDisabled')THEN 'Disabled' 
	ELSE 'Enabled' 
	END as Status
FROM sysobjects T
	INNER JOIN sysobjects TR on t.[ID] = TR.parent_obj 
WHERE (T.xtype = 'U' or T.XType = 'V')
    AND (@TableNamePattern IS NULL OR T.[name] LIKE @TableNamePattern)
    AND (TR.xtype = 'TR')
ORDER BY USER_NAME(OBJECTPROPERTY(T.id, 'OwnerId')), T.[name] , TR.[name]


if upper(@StatusToGet) = 'ALL'
	Select * from #Trig
else
	begin
		if upper(@StatusToGet) = 'ENABLED'
			Select * from #Trig where Status = 'Enabled'
		else
			Select * from #Trig where Status = 'Disabled'
	end

end

