Create proc QCL_CopyStudyDataStructure @OrigStudy_ID int, @CopyStudy_ID int, @indebug int = 0
as

/*
--Test Code
--QCL_CopyStudyDataStructure 110, 114, 1


declare @OrigStudy_ID int, @CopyStudy_ID int, @indebug int
set @OrigStudy_ID=110  
set @CopyStudy_ID=114
set @indebug = 1
*/

declare @OrigTable_ID int, @OrigTABLE_NM varchar(100), @OrigTABLE_DSC varchar(250), @OrigBITUSESADDRESS bit
declare @CopyTable_ID int

create table #metaTable (TABLE_ID int, STRTABLE_NM varchar(100), STRTABLE_DSC varchar(250), STUDY_ID int, BITUSESADDRESS bit)
create table #metaTable_newStudy (TABLE_ID int, STRTABLE_NM varchar(100), STRTABLE_DSC varchar(250), STUDY_ID int, BITUSESADDRESS bit)
Create table #tbls (OrigTable_ID int, CopyTable_ID int)
Create table #lookups (NUMMASTERTABLE_ID int, NUMMASTERFIELD_ID int, NUMLKUPTABLE_ID int ,NUMLKUPFIELD_ID int,STRLKUP_TYPE varchar(1))


insert into #metaTable
select TABLE_ID,STRTABLE_NM,STRTABLE_DSC,STUDY_ID,BITUSESADDRESS
from METATABLE where STUDY_ID = @OrigStudy_ID

if @indebug = 1 select '#metatable for Table and Field Copy' [#metatable], * from #metatable

while (select COUNT(*) from #metaTable) > 0
begin

	Select top 1	@OrigTable_ID = Table_ID, 
					@OrigTABLE_NM = STRTABLE_NM, 
					@OrigTABLE_DSC = STRTABLE_DSC, 
					@OrigBITUSESADDRESS = BITUSESADDRESS
	from #metaTable
	
	if not exists 
		(
		select	'x' 
		from	METATABLE
		where	STUDY_ID = @CopyStudy_ID and
				STRTABLE_NM = @OrigTABLE_NM
		)
		BEGIN
			--Insert table since it does not exist
			insert into METATABLE (STRTABLE_NM,STRTABLE_DSC,STUDY_ID,BITUSESADDRESS)
			select @OrigTABLE_NM,@OrigTABLE_DSC, @CopyStudy_ID AS Study_ID, 0

			set @CopyTable_ID = scope_identity()
			
		END	
		
		ELSE
		
		BEGIN
			--since the record already exists we just need to get the Table_ID for the insert below
			select	@CopyTable_ID = TABLE_ID
			from	METATABLE
			where	STUDY_ID = @CopyStudy_ID and
					STRTABLE_NM = @OrigTABLE_NM

		END
	
		--now insert records into metastructure
		insert into METASTRUCTURE (TABLE_ID,FIELD_ID,BITKEYFIELD_FLG,BITUSERFIELD_FLG,BITMATCHFIELD_FLG,BITPOSTEDFIELD_FLG,bitPII,bitAllowUS)
		select	@CopyTable_ID as TABLE_ID, FIELD_ID, BITKEYFIELD_FLG, BITUSERFIELD_FLG, BITMATCHFIELD_FLG, 0 as BITPOSTEDFIELD_FLG, bitPII, bitAllowUS 
		from	METASTRUCTURE m1
		where	TABLE_ID = @OrigTable_ID and
				not exists (SELECT 'x' 
							from METASTRUCTURE m2
							where	m2.TABLE_ID = @CopyTable_ID and
									m1.FIELD_ID = m2.FIELD_ID)


	Delete 
	from	#metatable	
	where	Table_ID = @OrigTable_ID and 
			STRTABLE_NM = @OrigTABLE_NM and 
			STRTABLE_DSC = @OrigTABLE_DSC and
			BITUSESADDRESS = @OrigBITUSESADDRESS



end


--now need to populate the MetaLookup 
truncate table #metatable

insert into #metatable
Select TABLE_ID,STRTABLE_NM,STRTABLE_DSC,STUDY_ID,BITUSESADDRESS
from metatable
where study_ID = @OrigStudy_ID


if @indebug = 1 select '#metatable for Lookup Copy' [#metatable], * from #metatable


insert into #metaTable_newStudy
Select TABLE_ID,STRTABLE_NM,STRTABLE_DSC,STUDY_ID,BITUSESADDRESS
from metatable
where study_ID = @CopyStudy_ID

insert into #tbls
Select m1.Table_ID as OrigTable_ID, m2.TABLE_ID as CopyTable_ID
from #metatable m1, #metaTable_newStudy m2
where m1.STRTABLE_NM = m2.STRTABLE_NM

if @indebug = 1 select '#tbls for Lookup Copy' [#tbls], * from #tbls

insert into #lookups
Select NUMMASTERTABLE_ID,NUMMASTERFIELD_ID,NUMLKUPTABLE_ID,NUMLKUPFIELD_ID,STRLKUP_TYPE
from METALOOKUP
where NUMMASTERTABLE_ID in (SELECT table_ID from METATABLE where STUDY_ID = @OrigStudy_ID)

if @indebug = 1 select '#lookups before' [#lookups before], * from #lookups

update L
set  NUMMASTERTABLE_ID = t.CopyTable_ID
from #lookups L, #tbls t
where NUMMASTERTABLE_ID = t.OrigTable_ID

update L
set  NUMLKUPTABLE_ID = t.CopyTable_ID
from #lookups L, #tbls t
where NUMLKUPTABLE_ID = t.OrigTable_ID

if @indebug = 1 select '#lookups after' [#lookups after], * from #lookups

insert into METALOOKUP (NUMMASTERTABLE_ID,NUMMASTERFIELD_ID,NUMLKUPTABLE_ID,NUMLKUPFIELD_ID,STRLKUP_TYPE)
Select	NUMMASTERTABLE_ID,NUMMASTERFIELD_ID,NUMLKUPTABLE_ID,NUMLKUPFIELD_ID,STRLKUP_TYPE
from	#lookups
	

drop table #metaTable
drop table #metaTable_newStudy
drop table #tbls 
drop table #lookups


