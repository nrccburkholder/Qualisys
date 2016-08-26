/*
S51 ATL-409 Hospice Language Speak changes for Submission CEM (August)

Question 55137

We currently submit a large file with multiple months.

As part of the prior release we added a new template with the new question core. This isn't going to fully work b/c we need to pull from prior fielded with old core.

Possible this is already supported by specifying two coreids in "where clause".


ATL-500 See if CEM.ExportTemplateColumn.SourceColumnName can use "OriginalQuestionCore in (#,#)" instead of just "OriginalQuestionCore=#"

Dave Gilsdorf

NRC_Datamart_Extracts
update CEM.ExportTemplateColumn
update/insert CEM.ExportTemplateColumnResponse

*/
use NRC_Datamart_Extracts
go
update etc 
set sourcecolumnname='OriginalQuestionCore in (54067,55137)'
from CEM.ExportTemplateColumn etc
where etc.SourceColumnName='OriginalQuestionCore = 54067'
and ExportTemplateColumnID in (select ExportTemplateColumnID
								from CEM.ExportTemplate_view
								where ValidEndDate>'1/1/16'
								and exporttemplatename = 'cahps hospice'
								and (SourceColumnName like '%54067%' or SourceColumnName like '%55137%'))

update etcr 
set responselabel = 'Some other language (qstncore=54067)/Vietnamese (qstncore=55137)'
from CEM.ExportTemplateColumnResponse etcr
where etcr.responselabel='Some other language'
and etcr.rawvalue = 6
and ExportTemplateColumnID in (select ExportTemplateColumnID
								from CEM.ExportTemplate_view
								where ValidEndDate>'1/1/16'
								and exporttemplatename = 'cahps hospice'
								and (SourceColumnName like '%54067%' or SourceColumnName like '%55137%'))


if not exists (	select * 
				from CEM.ExportTemplate_view
				where ValidEndDate>'1/1/16'
				and  exporttemplatename = 'cahps hospice'
				and (SourceColumnName like '%54067%' or SourceColumnName like '%55137%')
				and rawvalue=7)
	insert into CEM.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
	select distinct ExportTemplateColumnID, 7, 7, 'Some other language'
	from CEM.ExportTemplate_view
	where ValidEndDate>'1/1/16'
	and exporttemplatename = 'cahps hospice'
	and (SourceColumnName like '%54067%' or SourceColumnName like '%55137%')
