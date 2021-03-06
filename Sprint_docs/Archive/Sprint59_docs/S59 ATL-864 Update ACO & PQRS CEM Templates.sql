
USE NRC_Datamart_Extracts

GO

DECLARE @vendorName varchar(50) = 'NationalResearchCorp'
DECLARE @cahpstypename varchar(10) = 'ACO'

DECLARE @exportTemplateName varchar(200) = 'ACO CAHPS'
DECLARE @exportTemplateVersionMajor varchar(100) = 'ACO-12'
DECLARE @sourceColumnName VARCHAR(200) = 'ColumnName=''ACO_LangProt'''
DECLARE @exportTemplateVersionMinor int = 2
DECLARE @exportTemplateID int
DECLARE @submissionExportTemplateSectionID int
DECLARE @exportTemplateColumnID int

SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

if not exists (SELECT 1 FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor)
BEGIN

	EXEC [CEM].[CopyExportTemplate] @exportTemplateID

	-- get the new exporttemplateid
	SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

	-- Set new minor version and defaultnamingconvention
	UPDATE ets
		SET ExportTemplateVersionMinor = @exportTemplateVersionMinor,
		DefaultNamingConvention = @vendorName + '.' + @cahpstypename + '.{support.SUBMN}{support.SUBDY}{support.SUBYR}.{support.SUBNUM}'
	FROM CEM.ExportTemplate ets
	WHERE ets.ExportTemplateID = @exportTemplateID

	-- Get ExportTemplaceSectionID for the template's submission section
	SELECT @submissionExportTemplateSectionID = [ExportTemplateSectionID]
	  FROM [NRC_DataMart_Extracts].[CEM].[ExportTemplateSection]
	  where ExportTemplateID = @exportTemplateID
	  and ExportTemplateSectionName = 'submission'

	--Add LANG_PROT to ExportTemplateColumn
	begin tran

		-- change order of columns that follow the new LANG_PROT column
		update etc
			SET ColumnOrder = ColumnOrder + 1
		FROM [CEM].[ExportTemplateColumn] etc
		WHERE etc.ExportTemplateSectionID = @submissionExportTemplateSectionID
		and ColumnOrder >= 12

		INSERT INTO [CEM].[ExportTemplateColumn]
				   ([ExportTemplateSectionID]
				   ,[ExportTemplateColumnDescription]
				   ,[ColumnOrder]
				   ,[DatasourceID]
				   ,[ExportColumnName]
				   ,[SourceColumnName]
				   ,[SourceColumnType]
				   ,[DispositionProcessID]
				   ,[FixedWidthLength]
				   ,[ColumnSetKey]
				   ,[FormatID]
				   ,[MissingThresholdPercentage]
				   ,[CheckFrequencies]
				   ,[AggregateFunction])
			 VALUES
				   (@submissionExportTemplateSectionID
				   ,'Language protocol for survey'
				   ,12
				   ,4
				   ,'LANG_PROT'
				   ,@sourceColumnName
				   ,56
				   ,NULL
				   ,1
				   ,NULL
				   ,NULL
				   ,0.95
				   ,0
				   ,NULL)

		SET @exportTemplateColumnID = SCOPE_IDENTITY()

		INSERT INTO [CEM].[ExportTemplateColumnResponse]([ExportTemplateColumnID],[RawValue],[ExportColumnName],[RecodeValue],[ResponseLabel])
				VALUES (@exportTemplateColumnID,1,NULL,1,'Dual language mailings'),
					(@exportTemplateColumnID,2,NULL,2,'Instructions on letter or insert'),
					(@exportTemplateColumnID,3,NULL,3,'Language specific mailings'),
					(@exportTemplateColumnID,8,NULL,8,'Not applicable')

	  commit tran

  END

GO


USE NRC_Datamart_Extracts

GO

DECLARE @vendorName varchar(50) = 'NationalResearchCorp'
DECLARE @cahpstypename varchar(10) = 'ACO'

DECLARE @exportTemplateName varchar(200) = 'ACO CAHPS'
DECLARE @exportTemplateVersionMajor varchar(100) = 'ACO-9'
DECLARE @sourceColumnName VARCHAR(200) = 'ColumnName=''ACO_LangProt'''
DECLARE @exportTemplateVersionMinor int = 2
DECLARE @exportTemplateID int
DECLARE @submissionExportTemplateSectionID int
DECLARE @exportTemplateColumnID int


SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

if not exists (SELECT 1 FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor)
BEGIN

	EXEC [CEM].[CopyExportTemplate] @exportTemplateID

	-- get the new exporttemplateid
	SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

	-- Set new minor version and defaultnamingconvention
	UPDATE ets
		SET ExportTemplateVersionMinor = @exportTemplateVersionMinor,
		DefaultNamingConvention = @vendorName + '.' + @cahpstypename + '.{support.SUBMN}{support.SUBDY}{support.SUBYR}.{support.SUBNUM}'
	FROM CEM.ExportTemplate ets
	WHERE ets.ExportTemplateID = @exportTemplateID

	-- Get ExportTemplaceSectionID for the template's submission section
	SELECT @submissionExportTemplateSectionID = [ExportTemplateSectionID]
	  FROM [NRC_DataMart_Extracts].[CEM].[ExportTemplateSection]
	  where ExportTemplateID = @exportTemplateID
	  and ExportTemplateSectionName = 'submission'

	--Add LANG_PROT to ExportTemplateColumn
	begin tran

		-- change order of columns that follow the new LANG_PROT column
		update etc
			SET ColumnOrder = ColumnOrder + 1
		FROM [CEM].[ExportTemplateColumn] etc
		WHERE etc.ExportTemplateSectionID = @submissionExportTemplateSectionID
		and ColumnOrder >= 12

		INSERT INTO [CEM].[ExportTemplateColumn]
				   ([ExportTemplateSectionID]
				   ,[ExportTemplateColumnDescription]
				   ,[ColumnOrder]
				   ,[DatasourceID]
				   ,[ExportColumnName]
				   ,[SourceColumnName]
				   ,[SourceColumnType]
				   ,[DispositionProcessID]
				   ,[FixedWidthLength]
				   ,[ColumnSetKey]
				   ,[FormatID]
				   ,[MissingThresholdPercentage]
				   ,[CheckFrequencies]
				   ,[AggregateFunction])
			 VALUES
				   (@submissionExportTemplateSectionID
				   ,'Language protocol for survey'
				   ,12
				   ,4
				   ,'LANG_PROT'
				   ,@sourceColumnName
				   ,56
				   ,NULL
				   ,1
				   ,NULL
				   ,NULL
				   ,0.95
				   ,0
				   ,NULL)

		SET @exportTemplateColumnID = SCOPE_IDENTITY()

		INSERT INTO [CEM].[ExportTemplateColumnResponse]([ExportTemplateColumnID],[RawValue],[ExportColumnName],[RecodeValue],[ResponseLabel])
				VALUES (@exportTemplateColumnID,1,NULL,1,'Dual language mailings'),
					(@exportTemplateColumnID,2,NULL,2,'Instructions on letter or insert'),
					(@exportTemplateColumnID,3,NULL,3,'Language specific mailings'),
					(@exportTemplateColumnID,8,NULL,8,'Not applicable')

	  commit tran

  END

GO


USE NRC_Datamart_Extracts

GO

DECLARE @vendorName varchar(50) = 'NationalResearchCorp'
DECLARE @cahpstypename varchar(10) = 'PQRS'

DECLARE @exportTemplateName varchar(200) = 'PQRS CAHPS'
DECLARE @exportTemplateVersionMajor varchar(100) = '1.0'
DECLARE @sourceColumnName VARCHAR(200) = 'ColumnName=''PQRS_LangProt'''
DECLARE @exportTemplateVersionMinor int = 2
DECLARE @exportTemplateID int
DECLARE @submissionExportTemplateSectionID int
DECLARE @exportTemplateColumnID int

SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

if not exists (SELECT 1 FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor and ExportTemplateVersionMinor = @exportTemplateVersionMinor)
BEGIN

	EXEC [CEM].[CopyExportTemplate] @exportTemplateID

	-- get the new exporttemplateid
	SELECT @exportTemplateID = MAX(ExportTemplateID) FROM CEM.ExportTemplate WHERE ExportTemplateName = @exportTemplateName and ExportTemplateVersionMajor = @exportTemplateVersionMajor

	-- Set new minor version and defaultnamingconvention
	UPDATE ets
		SET ExportTemplateVersionMinor = @exportTemplateVersionMinor,
		DefaultNamingConvention = @vendorName + '.' + @cahpstypename + '.{support.SUBMN}{support.SUBDY}{support.SUBYR}.{support.SUBNUM}'
	FROM CEM.ExportTemplate ets
	WHERE ets.ExportTemplateID = @exportTemplateID

	-- Get ExportTemplaceSectionID for the template's submission section
	SELECT @submissionExportTemplateSectionID = [ExportTemplateSectionID]
	  FROM [NRC_DataMart_Extracts].[CEM].[ExportTemplateSection]
	  where ExportTemplateID = @exportTemplateID
	  and ExportTemplateSectionName = 'submission'

	--Add LANG_PROT to ExportTemplateColumn
	begin tran

		-- change order of columns that follow the new LANG_PROT column
		update etc
			SET ColumnOrder = ColumnOrder + 1
		FROM [CEM].[ExportTemplateColumn] etc
		WHERE etc.ExportTemplateSectionID = @submissionExportTemplateSectionID
		and ColumnOrder >= 11

		INSERT INTO [CEM].[ExportTemplateColumn]
				   ([ExportTemplateSectionID]
				   ,[ExportTemplateColumnDescription]
				   ,[ColumnOrder]
				   ,[DatasourceID]
				   ,[ExportColumnName]
				   ,[SourceColumnName]
				   ,[SourceColumnType]
				   ,[DispositionProcessID]
				   ,[FixedWidthLength]
				   ,[ColumnSetKey]
				   ,[FormatID]
				   ,[MissingThresholdPercentage]
				   ,[CheckFrequencies]
				   ,[AggregateFunction])
			 VALUES
				   (@submissionExportTemplateSectionID
				   ,'Language protocol for survey'
				   ,11
				   ,4
				   ,'LANG_PROT'
				   ,@sourceColumnName
				   ,56
				   ,NULL
				   ,1
				   ,NULL
				   ,NULL
				   ,0.95
				   ,0
				   ,NULL)

		SET @exportTemplateColumnID = SCOPE_IDENTITY()

		INSERT INTO [CEM].[ExportTemplateColumnResponse]([ExportTemplateColumnID],[RawValue],[ExportColumnName],[RecodeValue],[ResponseLabel])
				VALUES (@exportTemplateColumnID,1,NULL,1,'Dual language mailings'),
					(@exportTemplateColumnID,2,NULL,2,'Instructions on letter or insert'),
					(@exportTemplateColumnID,3,NULL,3,'Language specific mailings'),
					(@exportTemplateColumnID,8,NULL,8,'Not applicable')

	  commit tran

  END

GO
