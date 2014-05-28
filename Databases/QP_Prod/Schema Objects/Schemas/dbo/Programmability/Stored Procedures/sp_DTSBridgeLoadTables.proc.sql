CREATE procedure sp_DTSBridgeLoadTables @Study_id varchar(10), @Function varchar(1)
as
declare @SQL varchar(200)
/*	Create Date: 11-19-02
	Created by : Ron Niewohner, Joe Camp
	Purppose   : New Loading procedures for DTSCreator Application
	Process : Create a field called LoadBridge in POP and ENC tables to bridge the two during loading
*/
if @Function = 'A'
   begin
	If not exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Population_load' and so.uid = user_id('S'+ @Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
	begin
		set @SQL = 'Alter Table s' + @Study_id + '.Population_Load Add LoadBridge varchar(100)'
		exec (@SQL)
		set @SQL = 'Update s' + @Study_id + '.Population_Load set LoadBridge = -999999'
		exec (@SQL)
	end
	If not exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Encounter_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
	begin
		set @SQL = 'Alter Table s' + @Study_id + '.Encounter_Load Add LoadBridge varchar(100)'
		exec (@SQL)
		set @SQL = 'Update s' + @Study_id + '.Encounter_Load set LoadBridge = -999999'
		exec (@SQL)
	end
   end
else
   begin
	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Population_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
	begin
		set @SQL = 'delete s' + @Study_id + '.population_load where LoadBridge is null'
		exec (@SQL)
		set @SQL = 'update s' + @Study_id + '.population_load set LoadBridge = null where LoadBridge = -999999'
		exec (@SQL)
	end
	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Encounter_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
	begin
		set @SQL = 'delete s' + @Study_id + '.encounter_load where LoadBridge is null'
		exec (@SQL)
		set @SQL = 'update s' + @Study_id + '.encounter_load set LoadBridge = null where LoadBridge = -999999'
		exec (@SQL)
		create table #CheckBridge (BadBridge varchar(100))
		set @SQL = 'insert into #CheckBridge select LoadBridge from s' + @Study_id + '.Encounter_Load group by LoadBridge having count(*) > 1'
		
		if (select count(*) from #CheckBridge) > 0
		begin
			set @SQL = 'delete s' + @Study_id + '.Population_Load where LoadBridge is not null'
			exec (@SQL)
			set @SQL = 'delete s' + @Study_id + '.Encounter_Load where LoadBridge is not null'
			exec (@SQL)
		end
		else
		begin
			set @SQL = 'Update e 
				set e.Pop_id = p.Pop_id 
				from s' + @Study_id + '.Encounter_load e,s' + @study_id +'.Population_load p 
				where p.LoadBridge = e.LoadBridge'
			exec (@SQL)
		end
	end

	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Population_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
		set @SQL = 'Alter Table s' + @Study_id + '.Population_Load Drop Column LoadBridge'
	exec (@SQL)
	
	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Encounter_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'LoadBridge')
		set @SQL = 'Alter Table s' + @Study_id + '.Encounter_Load Drop Column LoadBridge'
	exec (@SQL)
   end


