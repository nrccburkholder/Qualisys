/*
S34_US23 OAS CEM template.sql

As the Compliance Team, we want a tool to create submission files for OAS CAHPS, so that we can fulfill mandatory requirements.

ATL-414 Create a new template on the DB metadata

Dave Gilsdorf

NRC_DataMart_Extracts:
insert into cem.ExportTemplate
insert into cem.ExportTemplateSection 
insert into cem.ExportTemplateDefaultResponse 
insert into cem.ExportTemplateColumn
insert into cem.ExportTemplateColumnResponse
insert into cem.DispositionProcess
insert into cem.DispositionClause
insert into cem.DispositionInList
create procedure CEM.ExportPostProcess00000014

*/
use NRC_DataMart_Extracts
go
if exists (select * from sys.procedures where schema_name(schema_id)='CEM' and name = 'ExportPostProcess00000014')
	drop procedure CEM.ExportPostProcess00000014
go
-- prior to creating the OAS template, these queries returned these values in both Prod and Staging. Test returned some different values but they were all lower.
if (select ExportTemplateName+'.'+ExportTemplateVersionMajor+'.'+convert(varchar,ExportTemplateVersionMinor) from cem.ExportTemplate where exporttemplateid=14)<>'OAS CAHPS.2016Q1.1'
	or (select max(ExportTemplateColumnResponseid) from cem.ExportTemplate_view where exporttemplateid<>14) > 4841 
	or (select max(exporttemplatecolumnid) from cem.ExportTemplate_view where exporttemplateid<>14) > 1306 
	or (select max(exporttemplatesectionid) from cem.ExportTemplate_view where exporttemplateid<>14) > 44 
	or (select max(exporttemplateid) from cem.ExportTemplate_view where exporttemplateid<>14) > 13 
	or (select max(ExportTemplateDefaultResponseid) from cem.ExportTemplateDefaultResponse where exporttemplateid<>14) > 238 
	or (select max(dispositionprocessid) from cem.DispositionProcess_view where exporttemplateid<>14) > 29 
	or (select max(dispositionclauseid) from cem.DispositionProcess_view where exporttemplateid<>14) > 44 
	or (select max(dispositioninlistid) from cem.Dispositioninlist where DispositionClauseID not in (select dispositionclauseid from cem.DispositionProcess_view where exporttemplateid=14)) > 196 
	SELECT 'error' from [Something isn't right - do not continue with the rollback! Contact Dave Gilsdorf for guidance."]


delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnResponseID>4841
delete from cem.ExportTemplateColumn where ExportTemplateColumnID>1306
delete from cem.ExportTemplateSection where ExportTemplateSectionID>44
delete from cem.ExportTemplate where isnull(ExportTemplateID,99)>13
delete from cem.ExportTemplateDefaultResponse where isnull(ExportTemplateID,99)>13

delete from cem.dispositionprocess where DispositionProcessID>29
delete from cem.dispositionclause where dispositionclauseid>44
delete from cem.dispositioninlist where dispositioninlistid>196


DBCC CHECKIDENT ('cem.ExportTemplateColumnResponse', RESEED, 4841) 
DBCC CHECKIDENT ('cem.ExportTemplateColumn', RESEED, 1306) 
DBCC CHECKIDENT ('cem.ExportTemplateSection', RESEED, 44) 
DBCC CHECKIDENT ('cem.ExportTemplate', RESEED, 13) 
DBCC CHECKIDENT ('cem.ExportTemplateDefaultResponse', RESEED, 238) 

DBCC CHECKIDENT ('cem.DispositionProcess', RESEED, 29) 
DBCC CHECKIDENT ('cem.DispositionClause', RESEED, 44) 
DBCC CHECKIDENT ('cem.Dispositioninlist', RESEED, 196) 
