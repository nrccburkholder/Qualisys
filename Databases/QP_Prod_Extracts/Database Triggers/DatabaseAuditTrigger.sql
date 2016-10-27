
create trigger DatabaseAuditTrigger
on database
with execute as 'server_audit'
for ddl_database_level_events
as 
begin
  --
  -- SQL 2008 DDL Auditing Solution
  --
  -- Database level DDL audit
  --
  -- Sean Elliott
  -- sean_p_elliott@yahoo.co.uk
  --
  -- July 2010
  --
  
  set nocount on 

  -- Needed for XML datatype
  set ansi_padding on
  set ansi_warnings on
  set arithabort on
  set concat_null_yields_null on
  set numeric_roundabort off
  
  declare @EventData xml
    
  set @EventData = eventdata()
  
  -- debug
--  select @EventData
  
  insert dbo.DatabaseAudit (AuditDate, LoginName, EventType, SchemaName, ObjectName, TSQLCommand, XMLEventData)
  select 
    getdate(),
    @EventData.value('data(/EVENT_INSTANCE/LoginName)[1]', 'sysname'),
    @EventData.value('data(/EVENT_INSTANCE/EventType)[1]', 'sysname'),
    isnull
    ( @EventData.value('data(/EVENT_INSTANCE/SchemaName)[1]', 'sysname'), 
      @EventData.value('data(/EVENT_INSTANCE/DefaultSchema)[1]', 'sysname')
    ),
    @EventData.value('data(/EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
    @EventData.value('data(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'varchar(max)'),
    @EventData
  
end   

