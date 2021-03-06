/*
S13 US15 CEM Architecture Research

15.1	CEM Architecture Research

S13_US15_Research_SP_Design_Select.sql

CREATE PROCEDURE [CEM].[SelectTemplate]
CREATE PROCEDURE [CEM].[SelectTemplateSection]
CREATE PROCEDURE [CEM].[SelectExportTemplateColumn]
CREATE PROCEDURE [CEM].[SelectExportTemplateColumnResponse]

Chris Burkholder
*/


USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [CEM].[SelectTemplateByTemplateId]    Script Date: 11/19/2014 1:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Tim Butler
-- Create date: 11/14/2014
-- Description:	Returns a template
-- =============================================
CREATE PROCEDURE [CEM].[SelectTemplate]
	@exportTemplateId int = null,
	@SurveyTypeId int = null,
	@ClientId int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--Template
	SELECT [ExportTemplateID]
		  ,[ExportTemplateName]
		  ,[SurveyTypeID]
		  ,[SurveySubTypeID]
		  ,[ValidDateType]
		  ,[ValidStartDate]
		  ,[ValidEndDate]
		  ,[ExportTemplateVersionMajor]
		  ,[ExportTemplateVersionMinor]
		  ,[CreatedBy]
		  ,[CreatedOn]
		  ,[ClientID]
		  ,[DefaultNotificationID]
		  ,[DefaultNamingConvention]
		  ,[State]
		  ,[ReturnsOnly]
		  ,[SampleUnitCahpsTypeID]
		  ,[XMLSchemaDefinition]
		  ,[isOfficial]
		  ,[DefaultFileMakerType]
	  FROM [CEM].[ExportTemplate] 
	  WHERE ((@exportTemplateId is null) or (ExportTemplateID = @exportTemplateId)) and
	        ((@SurveyTypeId is null) or (SurveyTypeId = @SurveyTypeId)) and
			((@ClientId is null) or (ClientId = @ClientId))
END
GO
    -- Sections
CREATE PROCEDURE [CEM].[SelectTemplateSection]
	@exportTemplateId int = null,
	@exportTemplateSectionID int = null,
	@exportTemplateSectionName varchar(100) = null
AS
BEGIN	
select ets.ExportTemplateSectionID,ets.ExportTemplateSectionName,ets.ExportTemplateID,ets.DefaultNamingConvention  
	from [CEM].[ExportTemplateSection] ets
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
	((@exportTemplateSectionID is null) or (ets.ExportTemplateSectionID = @exportTemplateSectionID)) and
	((@exportTemplateSectionName is null) or (ets.exportTemplateSectionName = @exportTemplateSectionName)) 
END
GO

	-- Columns
CREATE PROCEDURE [CEM].[SelectExportTemplateColumn]
@exportTemplateId as int = null,
@exportTemplateSectionId as int = null,
@exportTemplateColumnID as int = null,
@exportColumnName as varchar(100) = null,
@ColumnSetKey as int = null,
@DataSourceID as int = null
AS
BEGIN
	select ets.ExportTemplateSectionID
	,etc.ExportTemplateColumnID
	,etc.ExportTemplateColumnDescription
	,etc.ColumnOrder
	,etc.DatasourceID
	,etc.ExportColumnName
	,etc.DispositionProcessID
	,etc.FixedWidthLength
	,etc.ColumnSetKey
	,etc.FormatID
	,etc.MissingThresholdPercentage
	,etc.CheckFrequencies
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
		((@exportTemplateSectionId is null) or (ets.ExportTemplateSectionID=@exportTemplateSectionId)) and
		((@exportTemplateColumnId is null) or (etc.ExportTemplateColumnId = @exportTemplateColumnId)) and
		((@exportColumnName is null) or (etc.ExportColumnName = @exportColumnName)) and
		((@ColumnSetKey is null) or (etc.ColumnSetKey=@ColumnSetKey)) and
		((@DataSourceId is null) or (etc.DataSourceId=@DataSourceId))
END
GO

	-- Column Responses
CREATE 
--ALTER
PROCEDURE [CEM].[SelectExportTemplateColumnResponse]
@exportTemplateId as int = null,
@exportTemplateSectionId as int = null,
@exportTemplateColumnID as int = null,
@exportColumnName as varchar(100) = null
AS
BEGIN
	select distinct
	etcr.ExportTemplateColumnResponseID
	,etcr.ExportTemplateColumnID
	,etcr.ExportColumnName
	,etcr.RawValue
	,etcr.RecodeValue
	,etcr.ResponseLabel
	from [CEM].[ExportTemplateSection] ets 
	inner join [CEM].[ExportTemplateColumn] etc on etc.ExportTemplateSectionID = ets.ExportTemplateSectionID
	left join [CEM].[ExportTemplateColumnResponse] etcr on etcr.ExportTemplateColumnID = etc.ExportTemplateColumnID
	where ((@exportTemplateId is null) or (ets.ExportTemplateID=@exportTemplateId)) and
		((@exportTemplateSectionId is null) or (ets.ExportTemplateSectionID=@exportTemplateSectionId)) and
		((@exportTemplateColumnId is null) or (etc.ExportTemplateColumnId = @exportTemplateColumnId)) and
		((@exportColumnName is null) or (etc.ExportColumnName = @exportColumnName))

END

GO