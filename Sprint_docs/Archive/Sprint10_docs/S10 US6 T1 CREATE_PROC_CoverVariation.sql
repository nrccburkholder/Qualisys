/*
S10.US6	Change to TestPrints
		As an Implementation Associate, I want to do test prints for dynamically created Cover Letters, so that I know the coverletters are created correctly.

T6.1	Modify the SP to pick the representive sample from the study that produces each of the cover letters. 

Dave Gilsdorf

CREATE PROCEDURE dbo.CoverVariationGetMap
CREATE PROCEDURE dbo.CoverVariationList

*/
use qp_prod
go
begin tran
go
if exists (select * from sys.procedures where schema_id=1 and name = 'CoverVariationGetMap')
	drop procedure dbo.CoverVariationGetMap
go
if exists (select * from sys.procedures where schema_id=1 and name = 'CoverVariationList')
	drop procedure dbo.CoverVariationList
go
create procedure dbo.CoverVariationGetMap
@survey_id int 
as
-- this procedure expects the following temp table to already exist, but be empty:
/*
	CREATE TABLE #CoverLetterItemArtifactUnitMapping (
		[Survey_id] [int] NULL,
		[SampleUnit_id] [int] NULL,
		[CoverLetterItemType_id] [tinyint] NULL,
		[CoverLetter_dsc] [varchar](60) NULL,
		[CoverLetterItem_label] [varchar](60) NULL,
		[Artifact_dsc] [varchar](60) NULL,
		[ArtifactItem_label] [varchar](60) NULL,
		[Cover_id] [int] NULL,
		[CoverItem_id] [int] NULL,
		[ArtifactPage_id] [int] NULL,
		[Artifact_id] [int] NULL
	)
*/

insert into #CoverLetterItemArtifactUnitMapping (
	Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label
	, Cover_id, CoverItem_id, ArtifactPage_id, Artifact_id)
select Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label
	, -1 as Cover_id, -1 as CoverItem_id, -1 as ArtifactPage_id, -1 as Artifact_id
from dbo.CoverLetterItemArtifactUnitMapping 
where survey_id=@survey_id 

update m set Cover_id=sc.selcover_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_cover sc on m.survey_id=sc.survey_id and m.CoverLetter_dsc=sc.description

update m set artifactPage_id=sc.selcover_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_cover sc on m.survey_id=sc.survey_id and m.artifact_dsc=sc.description

update m set CoverItem_id=st.qpc_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_textbox st on m.survey_id=st.survey_id and m.cover_id=st.coverid and rtrim(m.CoverLetterItem_label)=rtrim(st.label) and st.language=1

update m set Artifact_id=st.qpc_id
from #CoverLetterItemArtifactUnitMapping m
inner join sel_textbox st on m.survey_id=st.survey_id and m.ArtifactPage_id=st.coverid and rtrim(m.ArtifactItem_label)=rtrim(st.label) and st.language=1

go
create procedure dbo.CoverVariationList
@survey_id int, @cover_id int
as

-- this procedure expects the following temp table to already exist:
-- create table #CoverVariation (CoverVariation_id int identity(101,1), survey_id int, cover_id int)

/*
declare @survey_id int, @cover_id int
select @survey_id=15787, @Cover_id=1
--*/

-- it also expects the #CoverLetterItemArtifactUnitMapping to exist and already be populated
/*
CREATE TABLE #CoverLetterItemArtifactUnitMapping (
	[Survey_id] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[CoverLetterItemType_id] [tinyint] NULL,
	[CoverLetter_dsc] [varchar](60) NULL,
	[CoverLetterItem_label] [varchar](60) NULL,
	[Artifact_dsc] [varchar](60) NULL,
	[ArtifactItem_label] [varchar](60) NULL,
	[Cover_id] [int] NULL,
	[CoverItem_id] [int] NULL,
	[ArtifactPage_id] [int] NULL,
	[Artifact_id] [int] NULL
)

exec dbo.CoverVariationGetMap @survey_id
*/


select distinct Cover_id, CoverItem_id
into #CoverLetterTextBoxes
from #CoverLetterItemArtifactUnitMapping
where Cover_id=@cover_id
and Survey_id=@survey_id

if @@rowcount=0 -- nothing on this textbox is mapped to any artifacts
	return

declare @tb int, @i int, @s varchar(4), @sql varchar(max), @insert varchar(max), @fieldlist varchar(max)
set @i=0
set @fieldlist=''
set @insert = 'insert into #CoverVariation (Survey_id, Cover_id<fieldlist>)
select '+convert(varchar,@survey_id)+' as survey_id, '+convert(varchar,@cover_id)+' as cover_id<fieldlist>
from $$'

select top 1 @tb=CoverItem_id, @i=@i+1 from #CoverLetterTextBoxes order by CoverItem_id
while @@rowcount>0 
begin
	set @s=convert(varchar, @i)
	
	set @fieldlist=@fieldlist + ', Art_'+@s
	
	IF not EXISTS (	select * 
					from tempdb.sys.columns sc 
					where sc.object_id = object_id('Tempdb..#CoverVariation')
					and name = 'TB_'+@s)
	begin
		set @SQL = 'alter table #CoverVariation add TB_'+@s+' int, Art_'+@s+' int'
		print @SQL
		exec (@SQL)
		-- #SurveyCoverVariation will exist during FormGen, but won't exist during sp_TestPrints
		if object_id('tempdb..#SurveyCoverVariation') is not null
		begin
			set @SQL = replace(@SQL,'#CoverVariation','#SurveyCoverVariation')
			exec (@SQL)
		end
	end
		
	set @insert=replace(@insert,'$$', 
	'(select distinct CoverItem_id as TB_'+@s+', Artifact_id as Art_'+@s+' from #CoverLetterItemArtifactUnitMapping m where m.survey_id='+convert(varchar,@survey_id)+' and CoverItem_id='+convert(varchar,@tb)+'
	union select '+convert(varchar,@tb)+', NULL) a'+@s+'
	,$$')
	
	delete from #CoverLetterTextBoxes where @tb=CoverItem_id 
	select top 1 @tb=CoverItem_id, @i=@i+1 from #CoverLetterTextBoxes order by CoverItem_id
end

set @insert = replace(@insert, ',$$', ' where coalesce(NULL'+@fieldlist+') is not null')
set @insert = replace(@insert, '<fieldlist>', @fieldlist + replace(@fieldlist,'Art','TB'))
print @insert
exec (@insert)

set identity_insert #CoverVariation on
set @SQL='insert into #CoverVariation (CoverVariation_id, survey_id, Cover_id'+replace(@fieldlist,'Art','TB')+')
select distinct Cover_id, survey_id, Cover_id'+replace(@fieldlist,'Art','TB')+'
from #CoverVariation where Cover_id='+convert(varchar,@cover_id)
print @SQL
exec (@SQL)
set identity_insert #CoverVariation off 

drop table #CoverLetterTextBoxes

go
commit tran