/*
S34_US08 - AddICD10fields.sql

Add OCS HH ICD-10 Fields to Studies	
As a Survey Management Associate, I want ICD-10 metafields added to all OCS study data structures, so that I do not have to manually update ~800 studies

ICD10_1 through ICD10_18. Client Group OCS only. 
Investigate if posting can be automated (but Service has agreed to post manually) 
10/9 deadline

8.1

Dave Gilsdorf

create procedure dbo.AddICD10fields
*/
use qp_prod
go
if exists (select * from sys.procedures where name = 'AddICD10fields' and schema_id=1)
	drop procedure dbo.AddICD10fields
go
create procedure dbo.AddICD10fields
@study_id int
as
--drop table #newfields

--declare @study_id int=3488--2165
declare @study varchar(10), @encTable_id int
set @study='S'+convert(varchar,@study_id)

select @encTable_id=table_id from metatable where study_id=@study_id and strTable_nm = 'encounter'

if @encTable_id is null
	return

declare @sql varchar(max)
select mf.field_id, mf.strField_nm, mf.strFieldDataType, mf.intFieldLength
into #newfields
from metafield mf 
left join METADATA_VIEW mdv on mdv.strfield_nm=mf.strfield_nm and mdv.study_id=@study_id
where (mf.strfield_nm like 'icd10_[1-9]' or mf.strfield_nm like 'icd10_1[0-8]')
and mdv.strfield_nm is null
order by mdv.strfield_nm

if @@rowcount=0
	return

begin tran

insert into metastructure (Table_id,     FIELD_ID, BITKEYFIELD_FLG, BITUSERFIELD_FLG, BITMATCHFIELD_FLG, BITPOSTEDFIELD_FLG, bitPII, bitAllowUS)
select					   @encTable_id, field_id, 0,               1,                0,                 1,                  0,      1
from #newfields

-- QLoader encounter table
set @sql='alter table qloader.qp_load.'+@study+'.ENCOUNTER_load add '
select @sql=@sql + md.strfield_nm + ' '+case md.strFielddataType when 'D' then 'DATETIME' when 'I' then 'INTEGER' when 'S' then 'VARCHAR('+convert(varchar,md.intFieldLength)+')' end+','
-- select md.strfield_nm, md.intfieldlength, ql.*
from METADATA_VIEW md
left join (	select su.name as Schema_nm, so.name as Table_nm, sc.name as column_nm
			from qloader.qp_load.dbo.sysusers su
			inner join qloader.qp_load.dbo.sysobjects so on su.name=@study and su.uid=so.uid and so.name='Encounter_load'
			inner join qloader.qp_load.dbo.syscolumns sc on so.id=sc.id
			where so.type='u') ql
	on md.strField_nm=ql.column_nm 
where ql.column_nm is null
and md.study_id=@study_id
and md.strTable_nm='ENCOUNTER'

set @sql=left(@sql,len(@sql)-1)
print @sql
exec (@sql)

-- qp_prod encounter table
set @sql='alter table '+@study+'.ENCOUNTER add '
select @sql=@sql + md.strfield_nm + ' '+case md.strFielddataType when 'D' then 'DATETIME' when 'I' then 'INTEGER' when 'S' then 'VARCHAR('+convert(varchar,md.intFieldLength)+')' end+','
from METADATA_VIEW md
left join (	select su.name as Schema_nm, so.name as Table_nm, sc.name as column_nm
			from sys.schemas su
			inner join sys.tables so on su.name=@study and su.schema_id=so.schema_id and so.name='Encounter'
			inner join sys.columns sc on so.object_id=sc.object_id) e on e.column_nm=md.strfield_nm 
where e.column_nm is null
and md.study_id=@study_id
and md.strTable_nm='ENCOUNTER'

set @sql=left(@sql,len(@sql)-1)
print @sql
exec (@sql)

-- QP_Prod encounter_load table
set @sql='alter table '+@study+'.ENCOUNTER_Load add '
select @sql=@sql + md.strfield_nm + ' '+case md.strFielddataType when 'D' then 'DATETIME' when 'I' then 'INTEGER' when 'S' then 'VARCHAR('+convert(varchar,md.intFieldLength)+')' end+','
from METADATA_VIEW md
left join (	select su.name as Schema_nm, so.name as Table_nm, sc.name as column_nm
			from sys.schemas su
			inner join sys.tables so on su.name=@study and su.schema_id=so.schema_id and so.name='Encounter_load'
			inner join sys.columns sc on so.object_id=sc.object_id) e on e.column_nm=md.strfield_nm 
where e.column_nm is null
and md.study_id=@study_id
and md.strTable_nm='ENCOUNTER'

set @sql=left(@sql,len(@sql)-1)
print @sql
exec (@sql)


-- QP_Prod Big_View
declare @v varchar(max)
set @v='CREATE VIEW '+@study+'.BIG_VIEW AS 
SELECT '

select @v = @v + strTable_nm+strField_nm+'='+@study+'.'+strTable_nm+'.'+strField_nm+', '
from METADATA_VIEW 
where study_id=@study_id

set @v=left(@v,len(@v)-1)+'
FROM '

select @v = @v + @study+'.'+strTable_nm + ', ' 
from metatable where study_id=@study_id

set @v=left(@v,len(@v)-1)+'
WHERE '

select @v=@v+ @study+'.'+strTable_nm+'.'+strField_nm+' = '+@study+'.'+lookuptablename+'.'+lookupfieldname
from METALOOKUP_VIEW where study_id=@study_id

print @v
exec (@v)

commit tran

drop table #newfields

go