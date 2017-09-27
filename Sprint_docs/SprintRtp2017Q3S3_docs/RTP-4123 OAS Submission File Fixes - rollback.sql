/*
	RTP-4123 OAS: Submission File Fixes - rollback

	Dave Gilsdorf

*/
use nrc_datamart_extracts
go

declare @newTemplateID int
select @newTemplateID = exporttemplateid from cem.ExportTemplate where ExportTemplateName = 'OAS CAHPS' and SurveyTypeID=16 and ExportTemplateVersionMajor='2017Q2' and ExportTemplateVersionMinor=2

if @newTemplateID is not null 
begin
	delete from cem.dispositioninlist where DispositionClauseID in (select DispositionClauseID from cem.DispositionProcess_view where ExportTemplateID=@newTemplateID)
	delete from cem.DispositionClause where DispositionClauseID in (select DispositionClauseID from cem.DispositionProcess_view where ExportTemplateID=@newTemplateID)
	delete from cem.DispositionProcess where DispositionProcessID in (select DispositionProcessID from cem.ExportTemplate_view where ExportTemplateID=@newTemplateID and DispositionProcessID is not null)

	delete from cem.ExportTemplateDefaultResponse where ExportTemplateID=@newTemplateID
	delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID=@newTemplateID))
	delete from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID=@newTemplateID)
	delete from cem.ExportTemplateSection where ExportTemplateID=@newTemplateID
	delete from cem.ExportTemplate where ExportTemplateID=@newTemplateID
end

select distinct DispositionClauseID,ListValue into #il from cem.DispositionInList
truncate table cem.DispositionInList
insert into cem.DispositionInList (DispositionClauseID,ListValue ) select DispositionClauseID,ListValue  from #IL order by DispositionClauseID,ListValue 

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

