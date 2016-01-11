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

declare @sql nvarchar(max)
select mf.field_id, mf.strField_nm, mf.strFieldDataType, mf.intFieldLength
into #newfields
from metafield mf 
left join METADATA_VIEW mdv on mdv.strfield_nm=mf.strfield_nm and mdv.study_id=@study_id
where (mf.strfield_nm like 'icd10_[1-9]' or mf.strfield_nm like 'icd10_1[0-8]')
and mdv.strfield_nm is null
order by mdv.strfield_nm

begin tran

insert into metastructure (Table_id,     FIELD_ID, BITKEYFIELD_FLG, BITUSERFIELD_FLG, BITMATCHFIELD_FLG, BITPOSTEDFIELD_FLG, bitPII, bitAllowUS)
select					   @encTable_id, field_id, 0,               1,                0,                 1,                  0,      1
from #newfields

-- QP_dataload encounter table
if exists (	SELECT * 
			from pervasive.qp_dataload.sys.schemas ss
			inner join pervasive.qp_dataload.sys.tables st on ss.name=@study and ss.schema_id=st.schema_id and st.name='Encounter_load')
begin
	set @sql='alter table '+@study+'.ENCOUNTER_load add '
	select @sql=@sql + md.strfield_nm + ' '+case md.strFielddataType when 'D' then 'DATETIME' when 'I' then 'INTEGER' when 'S' then 'VARCHAR('+convert(varchar,md.intFieldLength)+')' end+','
	-- declare @study_id int=3814, @study varchar(10)='s3814' select md.strfield_nm, md.intfieldlength, ql.*
	from METADATA_VIEW md
	left join (	select ss.name as Schema_nm, st.name as Table_nm, sc.name as column_nm
				from pervasive.qp_dataload.sys.schemas ss
				inner join pervasive.qp_dataload.sys.tables st on ss.name=@study and ss.schema_id=st.schema_id and st.name='Encounter_load'
				inner join pervasive.qp_dataload.sys.columns sc on st.object_id=sc.object_id) ql
		on md.strField_nm=ql.column_nm 
	where ql.column_nm is null
	and md.study_id=@study_id
	and md.strTable_nm='ENCOUNTER'

	if len(@SQL)>37
	begin
		set @sql=left(@sql,len(@sql)-1)
		print @sql
		EXECUTE pervasive.qp_dataload.dbo.sp_executesql  @SQL
	end
end

-- QLoader encounter table
if exists (	SELECT * 
			from qloader.qp_load.dbo.sysusers su
			inner join qloader.qp_load.dbo.sysobjects so on su.name=@study and su.uid=so.uid and so.name='Encounter_load')
begin
	set @sql='alter table '+@study+'.ENCOUNTER_load add '
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

	if len(@SQL)>37
	begin
		set @sql=left(@sql,len(@sql)-1)
		print @sql
		EXECUTE qloader.qp_load.dbo.sp_executesql  @SQL
	end
end

-- qp_prod encounter table
if exists (	select *
			from sys.schemas su
			inner join sys.tables so on su.name=@study and su.schema_id=so.schema_id and so.name='Encounter')
begin
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

	if len(@SQL)>32
	begin
		set @sql=left(@sql,len(@sql)-1)
		print @sql
		EXECUTE dbo.sp_executesql  @SQL
	end
end

-- QP_Prod encounter_load table
if exists (	select *
			from sys.schemas su
			inner join sys.tables so on su.name=@study and su.schema_id=so.schema_id and so.name='Encounter_load')
begin
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

	if len(@SQL)>37
	begin
		set @sql=left(@sql,len(@sql)-1)
		print @sql
		EXECUTE dbo.sp_executesql  @SQL
	end
end

-- QP_Prod Big_View
declare @v nvarchar(max)
if object_id(@study+'.BIG_VIEW') is NULL
	set @v='CREATE VIEW '+@study+'.BIG_VIEW AS 
	SELECT '
else
	set @v='ALTER VIEW '+@study+'.BIG_VIEW AS 
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

select @v=@v+ @study+'.'+strTable_nm+'.'+strField_nm+' = '+@study+'.'+lookuptablename+'.'+lookupfieldname + ' AND '
from METALOOKUP_VIEW where study_id=@study_id

set @V = left(@V,len(@V)-4)

print @v
EXECUTE dbo.sp_executesql  @v

commit tran

drop table #newfields