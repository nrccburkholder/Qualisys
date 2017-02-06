/*

	S68 ATL-1363 Hospice CAHPS Survey Lang Question Update

	As the Manager of Corporate Compliance, I want all Hospice CAHPS questionnaires updated with the new Language Speak 
	question instead of the existing, so that we do not have discrepancies for fielding an incorrect question.


	Update the CEM Export Template. Change the core for cHomeLang 55137 to 56642

*/

use NRC_Datamart_Extracts

begin tran

if not exists (select 1 from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
where ExportTemplateName = 'CAHPS Hospice'
and ExportTemplateVersionMajor = '2.1.2'
and ExportTemplateVersionMinor = 4)
begin
	declare @idToCopy int

	select @idToCopy = ExportTemplateID
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
	where ExportTemplateName = 'CAHPS Hospice'
	and ExportTemplateVersionMajor = '2.1.2'
	and ExportTemplateVersionMinor = 3

	exec [NRC_Datamart_Extracts].[CEM].[CopyExportTemplate] @idToCopy

	declare @newETId int

	select @newETId = max(ExportTemplateId) from [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplate] 
		set ExportTemplateVersionMinor = 4, 
			CreatedOn = GetDate()
	where ExportTemplateId = @newETId

	declare @ETCId int

	select @ETCId = etc.ExportTemplateColumnID
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
	inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ets.ExportTemplateID = @newETId
	  and etc.SourceColumnName = 'OriginalQuestionCore in (54067,55137)'

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] 
		set SourceColumnName = 'OriginalQuestionCore in (56642)'
	from [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
	inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ets.ExportTemplateID = @newETId
	  and etc.SourceColumnName = 'OriginalQuestionCore in (54067,55137)'

	update [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] 
	set ResponseLabel = 'Polish'
	where ExportTemplateColumnID = @ETCId
	and RawValue = 7

	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @ETCid, 8, NULL, 8, 'Korean'

	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @ETCid, 9, NULL, 9, 'Some Other Language'


end

--rollback tran
commit tran