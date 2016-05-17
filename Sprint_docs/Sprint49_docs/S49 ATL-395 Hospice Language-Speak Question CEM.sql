/*
S49 ATL-395 Hospice CAHPS Lang Speak Question Update


As a Hospice CAHPS vendor, we must update the language spoken question, 
so that we are fielding according to protocols.

Update the CEM Export Template. Change the core for cHomeLang 54067 to 55137. 

*/

use NRC_Datamart_Extracts

begin tran

if not exists (select 1 from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
where ExportTemplateName = 'CAHPS Hospice'
and ExportTemplateVersionMajor = '2.0'
and ExportTemplateVersionMinor = 3)
begin
	declare @idToCopy int

	select @idToCopy = ExportTemplateID
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
	where ExportTemplateName = 'CAHPS Hospice'
	and ExportTemplateVersionMajor = '2.0'
	and ExportTemplateVersionMinor = 2

	exec [NRC_Datamart_Extracts].[CEM].[CopyExportTemplate] @idToCopy

	declare @newETId int

	select @newETId = max(ExportTemplateId) from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplate] set ExportTemplateVersionMinor = 3, CreatedOn = GetDate()
	where ExportTemplateId = @newETId

	declare @ETCId int

	select @ETCId = etc.ExportTemplateColumnID
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
	inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ets.ExportTemplateID = @newETId
	  and etc.SourceColumnName = 'OriginalQuestionCore = 54067'

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] 
		set SourceColumnName = Replace(SourceColumnName, '54067','55137') 
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
	inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ets.ExportTemplateID = @newETId
	  and etc.SourceColumnName = 'OriginalQuestionCore = 54067'

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] 
	set ResponseLabel = 'Vietnamese'
	where ExportTemplateColumnID = @ETCId
	and RawValue = 6

	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @ETCid, 7, NULL, 7, 'Some Other Language'

/*
ExportTemplateColumnResponseID	ExportTemplateColumnID	RawValue	ExportColumnName	RecodeValue	ResponseLabel
2783	796	1	NULL	1	English
2784	796	2	NULL	2	Spanish
2785	796	3	NULL	3	Chinese
2786	796	4	NULL	4	Some other language

select * from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
select * from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] where ExportColumnName = 'cHomeLang'
select * from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] where exporttemplatecolumnid = 1099

select etc.ExportTemplateColumnID
from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
where ets.ExportTemplateID = 9
  and etc.SourceColumnName = 'OriginalQuestionCore = 51620'
*/
end

--rollback tran
commit tran