create proc sp_DBA_CreateTableScript @oName varchar(60), @newName varchar(60) = null
as 
--declare @oName varchar(20)
--set @oName = 'Cutoff'
declare @uName as varchar(10), @tName as varchar(20)
If (select charindex('.', @oName, 1)) > 1 
   begin
	If exists (select * from sysusers where name = substring(@oName, 1, charindex('.', @oName, 1) -1))
		select @uName = substring(@oName, 1, charindex('.', @oName, 1) -1)
	else 
	   begin
		print 'User does not exists in this database!'
		return
	   end
	If exists (select * from sysobjects where name = substring(@oName, charindex('.', @oName, 1) + 1, len(@oName) - charindex('.', @oName, 1) + 1))
		select @tName = substring(@oName, charindex('.', @oName, 1) + 1, len(@oName) - charindex('.', @oName, 1) + 1) 
	else
	   begin
		print 'Table does not exists in this database!'
		Goto AllTablesForUser
		Goto AllUsersForTable
	   end
   end
Else --No "." in variable provided 
   begin
	If exists (select * from sysusers where name = @oName)
		select @uName = 'dbo'
	Else if exists (select * from sysobjects where name = @oName)
		select @tName = @oName
   end

If @uName is not null and @tName is not null
	if exists (select * from sysobjects so, sysusers su where so.name = @tName and su.Name = @uName and su.uid = so.uid)
	   	Goto CreateScript
	else
	   begin
	        print 'The fully quilified name you provided does not exist!'
    		Goto Everything
		return
	   end
else if @uName is null and @tName is not null 
   begin 
	if (select count(*) from sysobjects where name = @tName) > 1 goto AllUsersForTable
	else select @uName = 'dbo'
   end
else if @uName is not null and @tName is null goto AllTablesForUser
else
   begin
	print 'Unable to identify the variable as a user or a table!'
	return
   end
CreateScript:
if @newName is null 
	set @newName = @tName
declare @tabName sysname, @colName sysname, @datType varchar(10),  @len int, @prec int, @scale int, @idcol int, @isnull int
declare @cState varchar (8000)
declare curScript cursor
for 
	select so.name, sc.name,  st.name, sc.length, sc.prec, sc.scale, sc.colstat, sc.isnullable
	from systypes st, sysobjects so, syscolumns sc, sysusers su
	where so.xtype ='U'
	and so.id = sc.id
	and sc.xtype = st.xtype
	and so.name = @tName
	and su.name = @uName
	and su.uid = so.uid
	order by sc.colorder
open curScript
fetch next from curScript
into @tabName, @colName, @datType, @len, @prec, @scale, @idcol, @isnull
select @cState = 'Create Table ' + @uName + '.[' + @newName + ']' + char(13) + '('
while @@fetch_status = 0
   begin
	select @cState = rtrim(@cState) +  
			 @colName + case  
				when len(rtrim(@colName)) < 8  then char(9) + char(9) + char(9)
				when len(rtrim(@colName)) > 8 and len(rtrim(@colName)) < 16 then char(9) + char(9)
				else char(9) 
				end
				+ @datType 
				+ case 
				when @datType in ('char', 'varchar', 'float') then '(' + rtrim(convert(char(4),@len)) + ')'
				when @datType = 'int' and @idCol = 1  then ' Identity(' + convert(char(1), ident_seed(@tabName))+ ', ' + convert(varchar(2), ident_incr(@tabName)) + ')'
				else ''
				end
				+ case @isNull
				when 1 then ' NULL,'
				else ' NOT NULL,'
				end
				+ char(13)
   	fetch next from curScript
	into @tabName, @colName, @datType, @len, @prec, @scale, @idCol, @isNull
   end
select @cState = stuff(@cState, len(rtrim(@cState)) -1, 1, ')')
print @cState
close curScript
deallocate curScript
Return
ALLTablesForUser:
	select su.name + '.' + so.name as 'All tables'
	from sysusers su, sysobjects so
	where su.name = @uName
	and su.uid = so.uid 
	and so.xtype = 'U'
	order by 1
Return
AllUsersForTable:
	Print 'Several tables that have this name please identify the one you wish to script.'
	select su.name + '.' + so.name as 'All users'
	from sysusers su, sysobjects so
	where so.name = @tName
	and su.uid = so.uid 
	and so.xtype = 'U'
	order by 1
Return
EveryThing:
select su.name + '.' + so.name as 'All Combo''s'
	from sysusers su, sysobjects so
	where su.name = @uName
	and su.uid = so.uid 
	and so.xtype = 'U'
	Union
	select su.name + '.' + so.name 
	from sysusers su, sysobjects so
	where so.name = @tName
	and su.uid = so.uid 
	and so.xtype = 'U'
	order by 1
Return


