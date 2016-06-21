/*
S13 US15 CEM Architecture Research

15.1	CEM Architecture Research

S13_US15_T1_Research_SP_Usage.sql
*/

USE [NRC_Datamart]
GO

exec CEM.SelectTemplate -- select all
exec CEM.SelectTemplate 1 -- by ExportTemplateId
exec CEM.SelectTemplate null, 8 --by SurveyTypeId
exec CEM.SelectTemplate null, null, 1 --no ClientId yet

exec CEM.SelectTemplateSection -- select all
exec CEM.SelectTemplateSection 1 --by ExportTemplateId
exec CEM.SelectTemplateSection null, 2 --by ExportTemplateSectionId
exec CEM.SelectTemplateSection 1, null, 'Header' --by ExportTemplateId, ExportTemplateSectionName

exec CEM.SelectExportTemplateColumn -- select all
exec CEM.SelectExportTemplateColumn 1 -- by ExportTemplateId
exec CEM.SelectExportTemplateColumn null, 2 --by ExportTemplateSectionId
exec CEM.SelectExportTemplateColumn null, null, 10 -- by exporttemplatecolumnid
exec CEM.SelectExportTemplateColumn 1, 2, null, 'facility-id' --by ExportTemplateId, ExportTemplateSectionId, ExportTemplateColumnName
exec CEM.SelectExportTemplateColumn null, null, null, null, 1 -- no Columnsetkey defined at the moment
exec CEM.SelectExportTemplateColumn 1, null, null, null, null, 4 -- by ExportTemplateId, DataSourceId

exec CEM.SelectExportTemplateColumnResponse -- select all
exec CEM.SelectExportTemplateColumnResponse 1 -- by ExportTemplateId
exec CEM.SelectExportTemplateColumnResponse null, 2 --by ExportTemplateSectionId
exec CEM.SelectExportTemplateColumnResponse null, null, 11 -- by exporttemplatecolumnid
exec CEM.SelectExportTemplateColumnResponse 1, 2, null, 'sem-survey' --by ExportTemplateId, ExportTemplateSectionId, ExportTemplateColumnName (null for now)


