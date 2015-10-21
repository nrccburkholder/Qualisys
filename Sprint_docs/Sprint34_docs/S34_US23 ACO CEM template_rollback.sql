/*
S34_US23 ACO CEM template.sql

As a compliance analyst I want the ACO submission file to be created in CEM using the newest version of submission file layout

23.1 - create a new template in CEM for ACO

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

*/
use NRC_DataMart_Extracts
go

delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnID in (select ExportTemplateColumnID from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>3))
delete from cem.ExportTemplateColumn where ExportTemplateSectionID in (select ExportTemplateSectionID from cem.ExportTemplateSection where ExportTemplateID>3)
delete from cem.ExportTemplateSection where ExportTemplateID>3
delete from cem.ExportTemplate where ExportTemplateID>3
delete from cem.ExportTemplateDefaultResponse where ExportTemplateID>3

delete from cem.Dispositioninlist where DispositionClauseID in (select DispositionClauseID from cem.DispositionClause where DispositionProcessID>9)
delete from cem.DispositionClause where DispositionProcessID>9
delete from cem.DispositionProcess where DispositionProcessID>9

delete from cem.ExportTemplateColumnResponse where ExportTemplateColumnResponseID>1033
delete from cem.ExportTemplateColumn where ExportTemplateColumnID>268
delete from cem.ExportTemplateSection where ExportTemplateSectionID>10
delete from cem.ExportTemplate where isnull(ExportTemplateID,99)>3
delete from cem.ExportTemplateDefaultResponse where isnull(ExportTemplateID,99)>3

delete from cem.dispositionprocess where dispositionprocessid>9
delete from cem.dispositionclause where dispositionclauseid>16
delete from cem.dispositioninlist where dispositioninlistid>83

select max(exporttemplateid) from cem.ExportTemplate -- 3
select max(exporttemplatesectionid) from cem.ExportTemplateSection -- 10
select max(exporttemplatecolumnid) from cem.ExportTemplateColumn -- 268
select max(ExportTemplateColumnResponseid) from cem.ExportTemplateColumnResponse -- 1033
select max(ExportTemplateDefaultResponseid) from cem.ExportTemplateDefaultResponse -- 59
select max(dispositionprocessid) from cem.DispositionProcess -- 9
select max(dispositionclauseid) from  cem.DispositionClause -- 16
select max(dispositioninlistid) from  cem.Dispositioninlist -- 83

DBCC CHECKIDENT ('cem.ExportTemplate', RESEED, 3) 
DBCC CHECKIDENT ('cem.ExportTemplateSection', RESEED, 10) 
DBCC CHECKIDENT ('cem.ExportTemplateColumn', RESEED, 268) 
DBCC CHECKIDENT ('cem.ExportTemplateColumnResponse', RESEED, 1033) 
DBCC CHECKIDENT ('cem.ExportTemplateDefaultResponse', RESEED, 59) 

DBCC CHECKIDENT ('cem.DispositionProcess', RESEED, 9) 
DBCC CHECKIDENT ('cem.DispositionClause', RESEED, 17) 
DBCC CHECKIDENT ('cem.Dispositioninlist', RESEED, 83) 

declare @x varchar(max)
set @x=''
select @x=@x+'
drop procedure cem.'+name
from sys.procedures 
where name between 'ExportPostProcess00000004' and 'ExportPostProcess99999999'
print @x
exec (@X)
