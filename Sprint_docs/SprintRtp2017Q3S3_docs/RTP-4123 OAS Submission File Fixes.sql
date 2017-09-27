/*
	RTP-4123 OAS: Submission File Fixes

	Dave Gilsdorf

*/
use nrc_datamart_extracts
go

/*
-- latest OAS template is #20
select * from cem.ExportTemplate where ExportTemplateName like 'oas%'

-- there's already a disposition process for finalstatus not in (110,120,310)
select * from cem.DispositionProcess_view where ExportTemplateID=20 -- DispositionProcessID=41
select * from cem.Dispositioninlist where DispositionClauseID=58

-- the OAS template already deals with language=2
select exportcolumnname, RawValue, RecodeValue, ResponseLabel
from cem.ExportTemplate_view 
where exporttemplateid=20 
and ExportTemplateSectionName='administration'
and ExportColumnName='language'

-- the surveymode and language columns do not currently use a disposition process
select distinct ExportTemplateSectionName, ExportColumnName, DispositionProcessID
from cem.ExportTemplate_view 
where exporttemplateid=20 
and ExportTemplateSectionName='administration'
and ExportColumnName in ('surveymode','language') 

*/

-- reset identity columns so there's no gaps.
declare @id int
select @id=max(dispositioninlistid) from cem.DispositionInList
DBCC CHECKIDENT ('cem.dispositioninlist', RESEED, @id);

select @id=max(DispositionClauseid) from cem.DispositionClause
DBCC CHECKIDENT ('cem.DispositionClause', RESEED, @id);

select @id=max(DispositionProcessID) from cem.DispositionProcess
DBCC CHECKIDENT ('cem.DispositionProcess', RESEED, @id);

select @id=max(ExportTemplateDefaultResponseID) from cem.ExportTemplateDefaultResponse
DBCC CHECKIDENT ('cem.ExportTemplateDefaultResponse', RESEED, @id);

select @id=max(ExportTemplateColumnResponseid) from cem.ExportTemplateColumnResponse
DBCC CHECKIDENT ('cem.ExportTemplateColumnResponse', RESEED, @id);

select @id=max(ExportTemplateColumnid) from cem.ExportTemplateColumn
DBCC CHECKIDENT ('cem.ExportTemplateColumn', RESEED, @id);

select @id=max(ExportTemplateSectionid) from cem.ExportTemplateSection
DBCC CHECKIDENT ('cem.ExportTemplateSection', RESEED, @id);

select @id=max(ExportTemplateID) from cem.ExportTemplate
DBCC CHECKIDENT ('cem.ExportTemplate', RESEED, @id);


-- make a copy of template #20
exec cem.CopyExportTemplate 20
declare @newTemplateID int
select @newTemplateID = max(exporttemplateid) from cem.ExportTemplate

-- update the new templates minor version to 2
update cem.ExportTemplate set ExportTemplateVersionMinor=2 where ExportTemplateID=@newTemplateID

-- update the old template so its valid end date is March 2017
update cem.ExportTemplate set validenddate='2017-03-31' where ExportTemplateID=20
-- update the new template so its valid start date is April 2017
update cem.ExportTemplate set validStartDate='2017-04-01',ValidEndDate='2222-12-31' where ExportTemplateID=@newTemplateID

declare @DispoID int, @col int, @c int
insert into cem.DispositionProcess (RecodeValue,DispositionActionID) values ('X',1)
set @DispoID=SCOPE_IDENTITY()
select @col=exporttemplatecolumnid from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and ExportColumnName='finalstatus'
insert into cem.DispositionClause (DispositionProcessID, DispositionPhraseKey, ExportTemplateColumnID, OperatorID) values (@DispoID,1,@col,12)
set @c=SCOPE_IDENTITY()
insert into cem.DispositionInList (DispositionClauseID, listvalue) values (@c, '110'), (@c, '120'), (@c,'310')


-- find the administration section
declare @sectionID int
select @sectionID = ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID=@newTemplateID and ExportTemplateSectionName='administration'

-- update the surveymode and language columns so they use the "finalstatus NOT IN" dispo
update cem.ExportTemplateColumn set DispositionProcessID=@DispoID where ExportTemplateSectionID=@sectionID and ExportColumnName in ('surveymode','language') 
GO