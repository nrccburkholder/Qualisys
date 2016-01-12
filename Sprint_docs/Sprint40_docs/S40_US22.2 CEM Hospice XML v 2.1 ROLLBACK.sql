/*
S40_US22.2 CAHPS - Hospice XML 2.10

user story 22:
As CMS we'd like to change your submission format so that our data is improved.

Tim Butler

Task 22.2 Create new template for the new XSD

ROLLBACK

*/
use NRC_DataMart_Extracts
go


declare @newTemplateID int, @SQL varchar(max)

select @newTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=1


if @newTemplateID is not null
begin
	select object_name(object_id), * from sys.columns where name = 'exporttemplateid' order by 1
	delete from CEM.DispositionInList where DispositionClauseID in (select DispositionClauseID from CEM.DispositionClause where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)))
	delete from CEM.DispositionClause where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID))
	delete from CEM.DispositionProcess where DispositionProcessID in (select DispositionProcessID from CEM.ExportTemplateColumn where DispositionProcessID is not null and ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID))
	delete from CEM.ExportTemplateDefaultResponse where exporttemplateid=@newTemplateID
	delete from CEM.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)
	delete from CEM.ExportTemplateColumn where ExportTemplateColumnID in (select ExportTemplateColumnID from CEM.ExportTemplate_view where exporttemplateid=@newTemplateID)
	delete from CEM.ExportTemplateSection where exporttemplateid=@newTemplateID
	delete from CEM.ExportTemplate where exporttemplateid=@newTemplateID
	if exists (select * from sys.tables where name = 'ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8))
	begin
		set @SQL = 'delete from CEM.ExportQueueFile where exportqueueid in (select exportqueueID from CEM.ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8) + ')'
		exec (@SQL)
		set @sql=replace(@sql,'ExportQueueFile','ExportQueueSurvey')
		exec (@SQL)
		set @sql=replace(@sql,'ExportQueueSurvey','ExportQueue')
		exec (@SQL)
		set @sql = 'drop table CEM.ExportDataset' + right(convert(varchar,100000000+@newTemplateID),8) 
		exec (@SQL)
	end
	set @sql='ExportPostProcess' + right(convert(varchar,100000000+@newTemplateID),8) 
	if exists (select * from sys.procedures where name = @SQL)
	begin
		set @SQL = 'drop procedure CEM.'+@SQL
		exec (@SQL)
	end

end


declare @exportemplateid int,
@exporttemplatesectionid int,
@exporttemplatecolumnid int,
@exporttemplatecolumnresponseid int,
@exporttemplatedefaultresponseid int,
@dispositionprocessid int,
@dispositionclauseid int,
@dispositioninlistid int,
@datasourceid int

select @exportemplateid = max(exporttemplateid) from CEM.ExportTemplate -- 6
select @exporttemplatesectionid = max(exporttemplatesectionid) from CEM.ExportTemplateSection -- 16
select @exporttemplatecolumnid = max(exporttemplatecolumnid) from CEM.ExportTemplateColumn -- 604
select @exporttemplatecolumnresponseid = max(ExportTemplateColumnResponseid) from CEM.ExportTemplateColumnResponse -- 2017
select @exporttemplatedefaultresponseid = max(ExportTemplateDefaultResponseid) from CEM.ExportTemplateDefaultResponse -- 119
select @dispositionprocessid = max(dispositionprocessid) from CEM.DispositionProcess -- 12
select @dispositionclauseid = max(dispositionclauseid) from  CEM.DispositionClause -- 20
select @dispositioninlistid = max(dispositioninlistid) from  CEM.Dispositioninlist -- 103
select @datasourceid = max(datasourceid) from CEM.Datasource -- 9

DBCC CHECKIDENT ('CEM.ExportTemplate', RESEED, @exportemplateid )
DBCC CHECKIDENT ('CEM.ExportTemplateSection', RESEED, @exporttemplatesectionid) 
DBCC CHECKIDENT ('CEM.ExportTemplateColumn', RESEED, @exporttemplatecolumnid) 
DBCC CHECKIDENT ('CEM.ExportTemplateColumnResponse', RESEED, @exporttemplatecolumnresponseid) 
DBCC CHECKIDENT ('CEM.ExportTemplateDefaultResponse', RESEED, @exporttemplatedefaultresponseid) 

DBCC CHECKIDENT ('CEM.DispositionProcess', RESEED, @dispositionprocessid) 
DBCC CHECKIDENT ('CEM.DispositionClause', RESEED, @dispositionclauseid) 
DBCC CHECKIDENT ('CEM.Dispositioninlist', RESEED, @dispositioninlistid) 

DBCC CHECKIDENT ('CEM.Datasource', RESEED, @datasourceid) 


GO
