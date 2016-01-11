/*
S40_US22.2 CAHPS - Hospice XML 2.10

user story 22:
As CMS we'd like to change your submission format so that our data is improved.

Tim Butler

Task 22.2 Create new template for the new XSD

*/
use NRC_DataMart_Extracts
go



declare @oldTemplateID int, @newTemplateID int

select @oldTemplateID=exporttemplateid from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.0' and ExportTemplateVersionMinor=2

if not exists (select * from cem.exporttemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='2.1' and ExportTemplateVersionMinor=1)
begin
	exec [CEM].[CopyExportTemplate] @oldTemplateID
	select @newTemplateID = max(exporttemplateid) from cem.exporttemplate 

	update cem.ExportTemplate 
		set ExportTemplateVersionMajor = '2.1'
		,ExportTemplateVersionMinor = 1
		,CreatedOn = GETDATE()
		,CreatedBy = 'tbutler'
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
	update decedent-primary-diagnosis
*/

Update etc
	SET FixedWidthLength = 8
	,SourceColumnName = 'M'
from cem.ExportTemplateColumn etc
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'decedent-primary-diagnosis'

/*
	insert Russian and Portuguese to language
*/

select @exporttemplatecolumnid = exporttemplatecolumnid from cem.ExportTemplateColumn 
where ExportTemplateSectionID = @decedentleveldatasectionid
and ExportColumnName = 'language'


if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = 4 and ResponseLabel = 'Russian')
begin
	-- insert Russian
	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 4, NULL, 4, 'Russian'
end

if not exists (select * 
				from [CEM].[ExportTemplateColumnResponse]
				where ExportTemplateColumnID =@exporttemplatecolumnid
				and RawValue = 5 and ResponseLabel = 'Portuguese')
begin
	-- insert Portuguese
	insert [NRC_Datamart_Extracts].[CEM].[ExportTemplateColumnResponse] (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
	select @exporttemplatecolumnid, 5, NULL, 5, 'Portuguese'

end




/*
Update the XMLSchemaDefinition in ExportTemplate
*/

Update CEM.ExportTemplate
	SET XMLSchemaDefinition = '<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="vendordata">
    <xs:annotation>
      <xs:documentation>CAHPS Hospice Survey XML File Specification
     Version 12.21.2015

     All data fields are defined as character.</xs:documentation>
    </xs:annotation>
    <xs:complexType>
      <xs:choice maxOccurs="unbounded" minOccurs="0">
        <xs:element type="xs:string" name="vendor-name"/>
        <xs:element type="xs:string" name="file-submission-yr"/>
        <xs:element type="xs:string" name="file-submission-month"/>
        <xs:element type="xs:string" name="file-submission-day"/>
        <xs:element type="xs:string" name="file-submission-number"/>
        <xs:element name="hospicedata" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="reference-yr"/>
              <xs:element type="xs:string" name="reference-month"/>
              <xs:element type="xs:string" name="provider-name"/>
              <xs:element type="xs:string" name="provider-id"/>
              <xs:element type="xs:string" name="npi"/>
              <xs:element type="xs:string" name="survey-mode"/>
              <xs:element type="xs:string" name="total-decedents"/>
              <xs:element type="xs:string" name="live-discharges"/>
              <xs:element type="xs:string" name="no-publicity"/>
              <xs:element type="xs:string" name="missing-dod"/>
              <xs:element type="xs:string" name="ineligible-presample"/>
              <xs:element type="xs:string" name="sample-size"/>
              <xs:element type="xs:string" name="ineligible-postsample"/>
              <xs:element type="xs:string" name="sample-type"/>
              <xs:element type="xs:string" name="number-offices"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="decedentleveldata" maxOccurs="unbounded" minOccurs="0">
          <xs:complexType>
            <xs:sequence>
              <xs:element type="xs:string" name="reference-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="reference-month" minOccurs="0"/>
              <xs:element type="xs:string" name="provider-name" minOccurs="0"/>
              <xs:element type="xs:string" name="provider-id"/>
              <xs:element type="xs:string" name="decedent-id" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-month" minOccurs="0"/>
              <xs:element type="xs:string" name="birth-day" minOccurs="0"/>
              <xs:element type="xs:string" name="death-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="death-month" minOccurs="0"/>
              <xs:element type="xs:string" name="death-day" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-yr" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-month" minOccurs="0"/>
              <xs:element type="xs:string" name="admission-day" minOccurs="0"/>
              <xs:element type="xs:string" name="sex" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-hispanic" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-race" minOccurs="0"/>
              <xs:element type="xs:string" name="caregiver-relationship" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-primary" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-secondary" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-payer-other" minOccurs="0"/>
              <xs:element type="xs:string" name="last-location" minOccurs="0"/>
              <xs:element type="xs:string" name="facility-name" minOccurs="0"/>
              <xs:element type="xs:string" name="decedent-primary-diagnosis" minOccurs="0"/>
              <xs:element type="xs:string" name="diagnosis-code-format" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-status" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-completion-mode" minOccurs="0"/>
              <xs:element type="xs:string" name="number-survey-attempts-telephone" minOccurs="0"/>
              <xs:element type="xs:string" name="number-survey-attempts-mail" minOccurs="0"/>
              <xs:element type="xs:string" name="language" minOccurs="0"/>
              <xs:element type="xs:string" name="lag-time" minOccurs="0"/>
              <xs:element type="xs:string" name="supplemental-question-count" minOccurs="0"/>
              <xs:element name="caregiverresponse" minOccurs="0">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element type="xs:string" name="provider-id"/>
                    <xs:element type="xs:string" name="decedent-id"/>
                    <xs:element type="xs:string" name="related"/>
                    <xs:element type="xs:string" name="location-home"/>
                    <xs:element type="xs:string" name="location-assisted"/>
                    <xs:element type="xs:string" name="location-nursinghome"/>
                    <xs:element type="xs:string" name="location-hospital"/>
                    <xs:element type="xs:string" name="location-hospice-facility"/>
                    <xs:element type="xs:string" name="location-other"/>
                    <xs:element type="xs:string" name="oversee"/>
                    <xs:element type="xs:string" name="needhelp"/>
                    <xs:element type="xs:string" name="gethelp"/>
                    <xs:element type="xs:string" name="h_informtime"/>
                    <xs:element type="xs:string" name="helpasan"/>
                    <xs:element type="xs:string" name="h_explain"/>
                    <xs:element type="xs:string" name="h_inform"/>
                    <xs:element type="xs:string" name="h_confuse"/>
                    <xs:element type="xs:string" name="h_dignity"/>
                    <xs:element type="xs:string" name="h_cared"/>
                    <xs:element type="xs:string" name="h_talk"/>
                    <xs:element type="xs:string" name="h_talklisten"/>
                    <xs:element type="xs:string" name="pain"/>
                    <xs:element type="xs:string" name="painhlp"/>
                    <xs:element type="xs:string" name="painrx"/>
                    <xs:element type="xs:string" name="painrxside"/>
                    <xs:element type="xs:string" name="painrxwatch"/>
                    <xs:element type="xs:string" name="painrxtrain"/>
                    <xs:element type="xs:string" name="breath"/>
                    <xs:element type="xs:string" name="breathhlp"/>
                    <xs:element type="xs:string" name="breathtrain"/>
                    <xs:element type="xs:string" name="constip"/>
                    <xs:element type="xs:string" name="constiphlp"/>
                    <xs:element type="xs:string" name="sad"/>
                    <xs:element type="xs:string" name="sadgethlp"/>
                    <xs:element type="xs:string" name="restless"/>
                    <xs:element type="xs:string" name="restlesstrain"/>
                    <xs:element type="xs:string" name="movetrain"/>
                    <xs:element type="xs:string" name="expectinfo"/>
                    <xs:element type="xs:string" name="receivednh"/>
                    <xs:element type="xs:string" name="cooperatehnh"/>
                    <xs:element type="xs:string" name="differhnh"/>
                    <xs:element type="xs:string" name="h_clisten"/>
                    <xs:element type="xs:string" name="cbeliefrespect"/>
                    <xs:element type="xs:string" name="cemotion"/>
                    <xs:element type="xs:string" name="cemotionafter"/>
                    <xs:element type="xs:string" name="ratehospice"/>
                    <xs:element type="xs:string" name="h_recommend"/>
                    <xs:element type="xs:string" name="pEdu"/>
                    <xs:element type="xs:string" name="pLatino"/>
                    <xs:element type="xs:string" name="race-white"/>
                    <xs:element type="xs:string" name="race-african-amer"/>
                    <xs:element type="xs:string" name="race-asian"/>
                    <xs:element type="xs:string" name="race-hi-pacific-islander"/>
                    <xs:element type="xs:string" name="race-amer-indian-ak"/>
                    <xs:element type="xs:string" name="cAge"/>
                    <xs:element type="xs:string" name="cSex"/>
                    <xs:element type="xs:string" name="cEdu"/>
                    <xs:element type="xs:string" name="cHomeLang"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element type="xs:string" name="npi" minOccurs="0"/>
              <xs:element type="xs:string" name="survey-mode" minOccurs="0"/>
              <xs:element type="xs:string" name="total-decedents" minOccurs="0"/>
              <xs:element type="xs:string" name="live-discharges" minOccurs="0"/>
              <xs:element type="xs:string" name="no-publicity" minOccurs="0"/>
              <xs:element type="xs:string" name="missing-dod" minOccurs="0"/>
              <xs:element type="xs:string" name="ineligible-presample" minOccurs="0"/>
              <xs:element type="xs:string" name="sample-size" minOccurs="0"/>
              <xs:element type="xs:string" name="ineligible-postsample" minOccurs="0"/>
              <xs:element type="xs:string" name="sample-type" minOccurs="0"/>
              <xs:element type="xs:string" name="number-offices" minOccurs="0"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:choice>
    </xs:complexType>
  </xs:element>
</xs:schema>'
WHERE ExportTemplateId = @newTemplateID

GO