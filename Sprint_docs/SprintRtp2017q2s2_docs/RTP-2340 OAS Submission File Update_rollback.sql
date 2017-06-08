use nrc_datamart_extracts
GO

--select * from cem.ExportTemplate where exporttemplatename = 'oas cahps'
--select * from cem.ExportTemplate_view where exporttemplatename = 'oas cahps' and ExportColumnName in ('patientsserved','patientsfile','eligiblepatients','sampledpatients')

declare @newID int
select @newID = exporttemplateid
from cem.ExportTemplate 
where exporttemplatename = 'oas cahps' 
and ExportTemplateVersionMajor='2017Q2' 
and ExportTemplateVersionMinor=1

if @newID is not NULL
begin

	delete from cem.DispositionInList where DispositionClauseID in (select DispositionClauseID from cem.dispositionclause where DispositionProcessID in (select DispositionProcessID from cem.exporttemplate_view where ExportTemplateID=@newID))
	delete from cem.DispositionClause where DispositionProcessID in (select DispositionProcessID from cem.exporttemplate_view where ExportTemplateID=@newID)
	delete from cem.DispositionProcess where DispositionProcessID in (select DispositionProcessID from cem.exporttemplate_view where ExportTemplateID=@newID)

	delete from cem.ExportTemplateDefaultResponse where ExportTemplateID = @newID
	delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.exporttemplatesection where exporttemplateid=@newid))
	delete from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.exporttemplatesection where exporttemplateid=@newid)
	delete from cem.exporttemplatesection where exporttemplateid=@newid
	delete from cem.ExportTemplate where exporttemplateid=@newid

	delete from cem.exportqueuefile where exportqueueid in (select ExportQueueID from cem.exportqueue where exporttemplatename = 'oas cahps' and ExportTemplateVersionMajor='2017Q2' and ExportTemplateVersionMinor=1)
	delete from cem.ExportQueueSurvey where exportqueueid in (select ExportQueueID from cem.exportqueue where exporttemplatename = 'oas cahps' and ExportTemplateVersionMajor='2017Q2' and ExportTemplateVersionMinor=1)
	delete from cem.exportqueue where exporttemplatename = 'oas cahps' and ExportTemplateVersionMajor='2017Q2' and ExportTemplateVersionMinor=1

	declare @sql varchar(max)
	set @sql = '[CEM].[ExportPostProcess' + right('00000000'+convert(varchar,@newid),8) + ']'
	if object_id(@sql) is not null
	begin
		set @SQL = 'DROP procedure ' + @sql
		exec (@SQL)
	end

	set @sql = '[CEM].[ExportDataset' + right('00000000'+convert(varchar,@newid),8) + ']'
	if object_id(@sql) is not null
	begin
		set @SQL = 'DROP table ' + @sql
		exec (@SQL)
	end

END

GO