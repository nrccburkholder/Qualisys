CREATE procedure sp_UpdateLoadTables_RN @Study_id varchar(10)
as
declare @SQL varchar(255)

set @SQL = 'delete s' + @study_id + '.population_load where mrn is null or visitnum is null'
exec (@SQL)
set @SQL = 'delete s' + @study_id + '.encounter_load where visitnum is null or mrn is null'
exec (@SQL)
set @SQL = 'update s' + @study_id + '.population_load set visitnum = null where visitnum = ''-999999'''
exec (@SQL)
set @SQL = 'update s' + @study_id + '.encounter_load set mrn = null where mrn = ''-999999'''
exec (@SQL)

set @SQL = 'Update e 
	set e.Pop_id = p.Pop_id 
	from s' + @Study_id + '.Encounter_load e,s' + @study_id +'.Population_load p 
	where p.VisitNum = e.VisitNum 
	and   p.MRN = e.MRN
	and   (p.mrn is not null
	or   p.visitnum is not null)'
exec (@SQL)


