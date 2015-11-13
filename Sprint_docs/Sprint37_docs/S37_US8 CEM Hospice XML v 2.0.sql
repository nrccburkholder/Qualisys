/*
S37_US8 CAHPS - Hospice XML 2.0

user story 8:
As an authorized Hospice CAHPS vendor, we must update our submission file to conform to XML File Specs 2.0 starting w/ Q3 2015 decedents, so that we can submit data for our clients

Tim Butler

Task 8.1 make changes to the Hospice CEM template

*/
use NRC_DataMart_Extracts
go


declare @oldTemplateID int, @newTemplateID int

select @oldTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.3' and ExportTemplateVersionMinor=1

if not exists (select * from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.0' and ExportTemplateVersionMinor=1)
begin
	exec [CEM].[CopyExportTemplate] @oldTemplateID
	select @newTemplateID = max(exporttemplateid) from cem.exporttemplate 

	update cem.ExportTemplate 
		set ExportTemplateVersionMajor = '2.0'
		,ExportTemplateVersionMinor = 1
	where ExportTemplateID=@newTemplateID

end

declare @hospicedatasectionid int
declare @caregiverresponsesectionid int
declare @decedentleveldatasectionid int

select @hospicedatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'hospicedata'
and ExportTemplateID = @newTemplateID

select @caregiverresponsesectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'caregiverresponse'
and ExportTemplateID = @newTemplateID

select @decedentleveldatasectionid = ExportTemplateSectionID
from cem.ExportTemplateSection
where ExportTemplateSectionName = 'decedentleveldata'
and ExportTemplateID = @newTemplateID


declare @exporttemplatecolumnid int
declare @columnOrder int
declare @RawValue int
declare @RecodeValue varchar(200)
declare @ResponseLabel varchar(200)


/*
New element: missing-dod [p. 5] 
*/
if not exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @hospicedatasectionid
				and ExportColumnName = 'missing-dod')
begin

	
	/* update column order for all columns that come AFTER missing-dod */

	SET @columnOrder = 11

	update etc
	set ColumnOrder = ColumnOrder + 1
	FROM [CEM].[ExportTemplateColumn] etc
	where etc.ExportTemplateSectionID = @hospicedatasectionid
	and ColumnOrder >= @columnOrder


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
			   (@hospicedatasectionid
			   ,'The number of decedents/caregivers not included in the sample frame for the month because any part (i.e., day, month, or year) of the decedent''s date of death is missing.'
			   ,@columnOrder
			   ,0
			   ,'missing-dod'
			   ,''
			   ,56
			   ,NULL
			   ,10
			   ,NULL
			   ,NULL
			   ,0.95
			   ,0
			   ,NULL)

end


/*
New element: number-offices. [p. 7] 
*/
if not exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @hospicedatasectionid
				and ExportColumnName = 'number-offices')
begin

	SELECT @columnOrder = max(ColumnOrder)
	from Cem.[ExportTemplateColumn] 
	WHERE ExportTemplateSectionID = @hospicedatasectionid

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
			   (@hospicedatasectionid
			   ,'The total number of hospice offices operating within this CCN.'
			   ,@columnOrder
			   ,0
			   ,'number-offices'
			   ,''
			   ,56
			   ,NULL
			   ,10
			   ,NULL
			   ,NULL
			   ,0.95
			   ,0
			   ,NULL)

	SET @exporttemplatecolumnid = SCOPE_IDENTITY()



end


/*
New element: diagnosis-code-format (ICD-9, ICD-10, or M). [p. 15] 
*/
if not exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @decedentleveldatasectionid
				and ExportColumnName = 'diagnosis-code-format')
begin

	/* update column order for all columns the come AFTER missing-dod */

	SET @columnOrder = 22

	update etc
	set ColumnOrder = ColumnOrder + 1
	FROM [CEM].[ExportTemplateColumn] etc
	where etc.ExportTemplateSectionID = @hospicedatasectionid
	and ColumnOrder >= @columnOrder

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
			   (@decedentleveldatasectionid
			   ,'This will indicate whether the <decedent-primary-diagnosis> variable is being submitted in ICD-9 format or ICD-10 format.'
			   ,@columnOrder
			   ,0
			   ,'diagnosis-code-format'
			   ,'M'
			   ,167
			   ,NULL
			   ,10
			   ,NULL
			   ,NULL
			   ,0.95
			   ,0
			   ,NULL)

	SET @exporttemplatecolumnid = SCOPE_IDENTITY()

end

/*
New element: diagnosis-code-format (ICD-9, ICD-10, or M). [p. 15] 
*/
if exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @decedentleveldatasectionid
				and ExportColumnName = 'decedent-primary-diagnosis')
begin

	--changing ExportColumn for decedent-primary-diagnosis to be literal for 'missing".  IC9 and ICD10 values will be assigned in post-processing.
	update cem.ExportTemplateColumn 
		SET [DatasourceID] = 0
		, [SourceColumnName] = 'MMMMMMM'
	where ExportTemplateSectionID = @decedentleveldatasectionid
				and ExportColumnName = 'decedent-primary-diagnosis'
end

/*
New element: ICD9 - only used to hold data - not for submission
*/
if not exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @decedentleveldatasectionid
				and ExportColumnName = 'icd9')
begin

	SET @columnOrder = 0

	update etc
	set ColumnOrder = ColumnOrder + 1
	FROM [CEM].[ExportTemplateColumn] etc
	where etc.ExportTemplateSectionID = @hospicedatasectionid
	and ColumnOrder >= @columnOrder

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
			   (@decedentleveldatasectionid
			   ,'placeholder for icd9 data'
			   ,@columnOrder
			   ,4
			   ,'icd9'
			   ,'columnname = ''ICD9'''
			   ,167
			   ,NULL
			   ,10
			   ,NULL
			   ,NULL
			   ,NULL
			   ,0
			   ,NULL)

	SET @exporttemplatecolumnid = SCOPE_IDENTITY()

end

/*
New element: ICD10 - only used to hold data - not for submission
*/
if not exists (select * 
				from cem.ExportTemplateColumn 
				where ExportTemplateSectionID = @decedentleveldatasectionid
				and ExportColumnName = 'icd10')
begin


	SET @columnOrder = 0

	update etc
	set ColumnOrder = ColumnOrder + 1
	FROM [CEM].[ExportTemplateColumn] etc
	where etc.ExportTemplateSectionID = @hospicedatasectionid
	and ColumnOrder >= @columnOrder

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
			   (@decedentleveldatasectionid
			   ,'placeholder for icd10 data'
			   ,@columnOrder
			   ,4
			   ,'icd10'
			   ,'columnname = ''ICD10_1'''
			   ,167
			   ,NULL
			   ,10
			   ,NULL
			   ,NULL
			   ,NULL
			   ,0
			   ,NULL)

	SET @exporttemplatecolumnid = SCOPE_IDENTITY()

end



/*
	Added all-8 values for missing to DOB. [pp. 8-9]  - already month and day, but not for year
*/
select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'birth-yr'


if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = -9)
begin

	SET @RawValue = -9
	SET @RecodeValue = '8888'
	SET @ResponseLabel = 'missing'



	INSERT INTO [CEM].[ExportTemplateColumnResponse]
			   ([ExportTemplateColumnID]
			   ,[RawValue]
			   ,[ExportColumnName]
			   ,[RecodeValue]
			   ,[ResponseLabel])
		 VALUES
			   (@exporttemplatecolumnid
			   ,@RawValue
			   ,NULL
			   ,@RecodeValue
			   ,@ResponseLabel)

end


/*
	Added all-8 values for missing to admit date. [pp. 10-11]  – need to add for day, month and year
*/
-- year
select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'admission-yr'

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = -9)
begin

	SET @RawValue = -9
	SET @RecodeValue = '8888'
	SET @ResponseLabel = 'missing'

	INSERT INTO [CEM].[ExportTemplateColumnResponse]
			   ([ExportTemplateColumnID]
			   ,[RawValue]
			   ,[ExportColumnName]
			   ,[RecodeValue]
			   ,[ResponseLabel])
		 VALUES
			   (@exporttemplatecolumnid
			   ,@RawValue
			   ,NULL
			   ,@RecodeValue
			   ,@ResponseLabel)
end

-- month
select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'admission-month'

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = -9)
begin

	SET @RawValue = -9
	SET @RecodeValue = '88'
	SET @ResponseLabel = 'missing'

	INSERT INTO [CEM].[ExportTemplateColumnResponse]
			   ([ExportTemplateColumnID]
			   ,[RawValue]
			   ,[ExportColumnName]
			   ,[RecodeValue]
			   ,[ResponseLabel])
		 VALUES
			   (@exporttemplatecolumnid
			   ,@RawValue
			   ,NULL
			   ,@RecodeValue
			   ,@ResponseLabel)
end


-- day
select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'admission-day'

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = -9)
begin

	SET @RawValue = -9
	SET @RecodeValue = '88'
	SET @ResponseLabel = 'missing'

	INSERT INTO [CEM].[ExportTemplateColumnResponse]
			   ([ExportTemplateColumnID]
			   ,[RawValue]
			   ,[ExportColumnName]
			   ,[RecodeValue]
			   ,[ResponseLabel])
		 VALUES
			   (@exporttemplatecolumnid
			   ,@RawValue
			   ,NULL
			   ,@RecodeValue
			   ,@ResponseLabel)
end

/*
	Adding hospice disavowal as a valid value for survey-status. [p. 16]  
*/
select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'survey-status'

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = 615 )
begin

	SET @RawValue = 615
	SET @RecodeValue = '15'
	SET @ResponseLabel = 'Non-Response: Hospice Disavowal'


	INSERT INTO [CEM].[ExportTemplateColumnResponse]
			   ([ExportTemplateColumnID]
			   ,[RawValue]
			   ,[ExportColumnName]
			   ,[RecodeValue]
			   ,[ResponseLabel])
		 VALUES
			   (@exporttemplatecolumnid
			   ,@RawValue
			   ,NULL
			   ,@RecodeValue
			   ,@ResponseLabel)
end



/*
Update the XMLSchemaDefinition in ExportTemplate
*/

Update CEM.ExportTemplate
	SET XMLSchemaDefinition = '<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" elementFormDefault="qualified" attributeFormDefault="unqualified">
  <xs:element name="vendordata">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="vendor-name" type="xs:string" />
        <xs:element name="file-submission-yr" type="xs:string" />
        <xs:element name="file-submission-month" type="xs:string" />
        <xs:element name="file-submission-day" type="xs:string" />
        <xs:element name="file-submission-number" type="xs:string" />
        <xs:element name="hospicedata">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="reference-yr" type="xs:string" />
              <xs:element name="reference-month" type="xs:string" />
              <xs:element name="provider-name" type="xs:string" />
              <xs:element name="provider-id" type="xs:string" />
              <xs:element name="npi" type="xs:string" />
              <xs:element name="survey-mode" type="xs:string" />
              <xs:element name="total-decedents" type="xs:string" />
              <xs:element name="live-discharges" type="xs:string" />
              <xs:element name="no-publicity" type="xs:string" />
              <xs:element name="missing-dod" type="xs:integer" />
              <xs:element name="ineligible-presample" type="xs:integer" />
              <xs:element name="sample-size" type="xs:integer" />
              <xs:element name="ineligible-postsample" type="xs:integer" />
              <xs:element name="sample-type" type="xs:integer" />
              <xs:element name="number-offices" type="xs:integer" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="decedentleveldata">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="provider-id" type="xs:string" />
              <xs:element name="decedent-id" type="xs:string" />
              <xs:element name="birth-yr" type="xs:integer" />
              <xs:element name="birth-month" type="xs:integer" />
              <xs:element name="birth-day" type="xs:integer" />
              <xs:element name="death-yr" type="xs:integer" />
              <xs:element name="death-month" type="xs:integer" />
              <xs:element name="death-day" type="xs:integer" />
              <xs:element name="admission-yr" type="xs:integer" />
              <xs:element name="admission-month" type="xs:integer" />
              <xs:element name="admission-day" type="xs:integer" />
              <xs:element name="sex" type="xs:string" />
              <xs:element name="decedent-hispanic" type="xs:string" />
              <xs:element name="decedent-race" type="xs:string" />
              <xs:element name="caregiver-relationship" type="xs:string" />
              <xs:element name="decedent-payer-primary" type="xs:string" />
              <xs:element name="decedent-payer-secondary" type="xs:string" />
              <xs:element name="decedent-payer-other" type="xs:string" />
              <xs:element name="last-location" type="xs:string" />
              <xs:element name="facility-name" type="xs:string" />
              <xs:element name="decedent-primary-diagnosis" type="xs:string" />
              <xs:element name="diagnosis-code-format" type="xs:string" />
              <xs:element name="survey-status" type="xs:string" />
              <xs:element name="survey-completion-mode" type="xs:integer" />
              <xs:element name="number-survey-attempts-telephone" type="xs:integer" />
              <xs:element name="number-survey-attempts-mail" type="xs:integer" />
              <xs:element name="language" type="xs:integer" />
              <xs:element name="lag-time" type="xs:integer" />
              <xs:element name="supplemental-question-count" type="xs:string" />
              <xs:element name="caregiverresponse">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="provider-id" type="xs:string" />
                    <xs:element name="decedent-id" type="xs:string" />
                    <xs:element name="related" type="xs:string" />
                    <xs:element name="location-home" type="xs:string" />
                    <xs:element name="location-assisted" type="xs:string" />
                    <xs:element name="location-nursinghome" type="xs:string" />
                    <xs:element name="location-hospital" type="xs:string" />
                    <xs:element name="location-hospice-facility" type="xs:string" />
                    <xs:element name="location-other" type="xs:string" />
                    <xs:element name="oversee" type="xs:string" />
                    <xs:element name="needhelp" type="xs:string" />
                    <xs:element name="gethelp" type="xs:string" />
                    <xs:element name="h_informtime" type="xs:string" />
                    <xs:element name="helpasan" type="xs:string" />
                    <xs:element name="h_explain" type="xs:string" />
                    <xs:element name="h_inform" type="xs:string" />
                    <xs:element name="h_confuse" type="xs:string" />
                    <xs:element name="h_dignity" type="xs:string" />
                    <xs:element name="h_cared" type="xs:string" />
                    <xs:element name="h_talk" type="xs:string" />
                    <xs:element name="h_talklisten" type="xs:string" />
                    <xs:element name="pain" type="xs:string" />
                    <xs:element name="painhlp" type="xs:string" />
                    <xs:element name="painrx" type="xs:string" />
                    <xs:element name="painrxside" type="xs:string" />
                    <xs:element name="painrxwatch" type="xs:string" />
                    <xs:element name="painrxtrain" type="xs:string" />
                    <xs:element name="breath" type="xs:string" />
                    <xs:element name="breathhlp" type="xs:string" />
                    <xs:element name="breathtrain" type="xs:string" />
                    <xs:element name="constip" type="xs:string" />
                    <xs:element name="constiphlp" type="xs:string" />
                    <xs:element name="sad" type="xs:string" />
                    <xs:element name="sadgethlp" type="xs:string" />
                    <xs:element name="restless" type="xs:string" />
                    <xs:element name="restlesstrain" type="xs:string" />
                    <xs:element name="movetrain" type="xs:string" />
                    <xs:element name="expectinfo" type="xs:string" />
                    <xs:element name="receivednh" type="xs:string" />
                    <xs:element name="cooperatehnh" type="xs:string" />
                    <xs:element name="differhnh" type="xs:string" />
                    <xs:element name="h_clisten" type="xs:string" />
                    <xs:element name="cbeliefrespect" type="xs:string" />
                    <xs:element name="cemotion" type="xs:string" />
                    <xs:element name="cemotionafter" type="xs:string" />
                    <xs:element name="ratehospice" type="xs:string" />
                    <xs:element name="h_recommend" type="xs:string" />
                    <xs:element name="pEdu" type="xs:string" />
                    <xs:element name="pLatino" type="xs:string" />
                    <xs:element name="race-white" type="xs:string" />
                    <xs:element name="race-african-amer" type="xs:string" />
                    <xs:element name="race-asian" type="xs:string" />
                    <xs:element name="race-hi-pacific-islander" type="xs:string" />
                    <xs:element name="race-amer-indian-ak" type="xs:string" />
                    <xs:element name="cAge" type="xs:string" />
                    <xs:element name="cSex" type="xs:string" />
                    <xs:element name="cEdu" type="xs:string" />
                    <xs:element name="cHomeLang" type="xs:string" />
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'
WHERE ExportTemplateId = @newTemplateID