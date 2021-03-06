/*
S40_US23 CEM: ICH CAHPS Lang Speak Question
 
As an authorized ICH CAHPS vendor, we need to report the updated question for the language-spoken field in the submission file, so that we submit correct data.


Tim Butler

Task 1 Update script to the CEM table (ExportTemplateColumn)


ROLLBACK

*/
  begin tran

	  UPDATE etc
		SET SourceColumnName = 'MasterQuestionCore=51203'
	  FROM [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
	  inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on ets.ExportTemplateSectionID = etc.ExportTemplateSectionID
	  inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplate] et on et.ExportTemplateID = ets.ExportTemplateID
	  where [ExportTemplateColumnDescription] = 'Q57'
	  and [ExportColumnName] = 'language-spoken'
	  and [ExportTemplateName] = 'ICH CAHPS'
	  and [ExportTemplateVersionMajor] = '3.0'
	  and [ExportTemplateVersionMinor] = 1

commit tran




SELECT etc.*
  FROM [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumn] etc
  inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplateSection] ets on ets.ExportTemplateSectionID = etc.ExportTemplateSectionID
  inner join [NRC_Datamart_Extracts].[CEM].[ExportTemplate] et on et.ExportTemplateID = ets.ExportTemplateID
  where [ExportTemplateColumnDescription] = 'Q57'
  and [ExportColumnName] = 'language-spoken'
  and [ExportTemplateName] = 'ICH CAHPS'
  and [ExportTemplateVersionMajor] = '3.0'
  and [ExportTemplateVersionMinor] = 1
