CREATE procedure sp_AlterLoadTables @Study_id varchar(10), @Function varchar(1)
as
declare @AlterPop varchar(200), @AlterEnc varchar(200)
/*	Create Date: 9-9-2
	Created by : Ron Niewohner
	Purppose   : New Loading procedures for Pep-C
	Assumptions : Every Population Load contains a MRN and every Encounter Load contains a VisitNum.
*/
--Checking for VisitNum and MRN
if @Function = 'A'
   begin
	If not exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Population_load' and so.uid = user_id('S'+ @Study_id) and so.id = sc.id and sc.name = 'VisitNum')
	begin
		set @AlterPop = 'Alter Table s' + @Study_id + '.Population_Load Add VisitNum varchar(40)'
		exec (@AlterPop)
		set @AlterPop = 'update s' + @Study_id + '.Population_Load set VisitNum = -999999'
		exec (@AlterPop)
	end

	If not exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Encounter_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'MRN')
	begin
		set @AlterEnc = 'Alter Table s' + @Study_id + '.Encounter_Load Add MRN varchar(40)'
		exec (@AlterEnc)
		set @AlterEnc = 'update s' + @Study_id + '.Encounter_Load set MRN = -999999'
		exec (@AlterEnc)
	end
   end
else
   begin
	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Population_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'VisitNum')
		set @AlterPop = 'Alter Table s' + @Study_id + '.Population_Load Drop Column VisitNum'
	exec (@AlterPop)
	
	If exists (select sc.name from sysobjects so, syscolumns sc where so.name = 'Encounter_load' and so.uid = user_id('S'+@Study_id) and so.id = sc.id and sc.name = 'MRN')
		set @AlterEnc = 'Alter Table s' + @Study_id + '.Encounter_Load Drop Column MRN'
	exec (@AlterEnc)
   end


