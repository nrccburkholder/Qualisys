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
select max(ExportTemplateColumnResponseid) from cem.ExportTemplateColumnResponse -- 4841 
select max(exporttemplatecolumnid) from cem.ExportTemplateColumn -- 1306 
select max(exporttemplatesectionid) from cem.ExportTemplateSection -- 44 
select max(exporttemplateid) from cem.ExportTemplate -- 13 
select max(ExportTemplateDefaultResponseid) from cem.ExportTemplateDefaultResponse -- 238 
select max(dispositionprocessid) from cem.DispositionProcess -- 29 
select max(dispositionclauseid) from  cem.DispositionClause -- 44 
select max(dispositioninlistid) from  cem.Dispositioninlist -- 196 


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
