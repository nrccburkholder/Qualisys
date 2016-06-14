/*
S34_US23 OAS CEM template.sql

As the Compliance Team, we want a tool to create submission files for OAS CAHPS, so that we can fulfill mandatory requirements.

ATL-414 Create a new template on the DB metadata

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
create procedure CEM.ExportPostProcess00000014

*/
use NRC_DataMart_Extracts
go
if object_id('tempdb..#OAS') is not null
   drop table #OAS

declare @ETid int, @ETSid int
insert into cem.ExportTemplate (ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType)
select 'OAS CAHPS' as ExportTemplateName
	, 16 as SurveyTypeID
	, null as SurveySubTypeID
	, 00 as ValidDateColumnID
	, '1/1/2016' as ValidStartDate
	, '3/31/2016' as ValidEndDate
	, '2016Q1' as ExportTemplateVersionMajor
	, 1 as ExportTemplateVersionMinor
	, system_user as CreatedBy
	, getdate() as CreatedOn
	, null as ClientID
	, null as DefaultNotificationID
	, 'OAS_{header.providername}_{header.providernum}_{header.sampleyear}_{header.samplemonth}' as DefaultNamingConvention
	, 1 as State
	, 0 as ReturnsOnly
	, 9 as SampleUnitCahpsTypeID
	, NULL as XMLSchemaDefinition
	, 1 as isOfficial
	, 1 as DefaultFileMakerType

set @ETid=SCOPE_IDENTITY()

update CEM.ExportTemplate
set XMLSchemaDefinition='<?xml version="1.0" encoding="UTF-8"?>
<xs:schema id="monthlydata" targetNamespace="http://oascahps.org" xmlns:mstns="http://oascahps.org" xmlns="http://oascahps.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" attributeFormDefault="qualified" elementFormDefault="qualified">

  <xs:element name="monthlydata" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">

    <xs:complexType>
      <xs:sequence>

        <xs:element name="header" minOccurs="1" maxOccurs="1">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="headertype" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="1"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="providername" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:minLength value="1"/><xs:maxLength value="100"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="providernum" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9A-Za-z]{6,10}"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="samplemonth" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="12"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="sampleyear" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="2016"/><xs:maxInclusive value="9998"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="surveymode" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="3"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="sampletype" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="4"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="patientsserved" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-9][0-9]{0,5}|[mM]"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="patientsfile" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="999999"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="eligiblepatients" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="999999"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="sampledpatients" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="999999"/></xs:restriction></xs:simpleType></xs:element>
		  </xs:sequence>
          </xs:complexType>
        </xs:element>

        <xs:element name="patientleveldata" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="administration" minOccurs="1" maxOccurs="1">
                <xs:complexType>
                  <xs:sequence>
                      <xs:element name="providernum" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9A-Za-z]{6,10}"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="samplemonth" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="12"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="sampleyear" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="2016"/><xs:maxInclusive value="9998"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="sampleid" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:minLength value="1"/><xs:maxLength value="16"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="surgicalcat" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="4"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="patientage" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-9]|1[0-5]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="patientgender" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="surveymode" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[xX]"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="lagtime" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]|[1-8][0-9]|90|[xX]"/></xs:restriction></xs:simpleType></xs:element>
				   <xs:element name="finalstatus" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:pattern value="110|120|210|220|230|240|310|320|330|340|350"/></xs:restriction></xs:simpleType></xs:element>
                      <xs:element name="language" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[xX]"/></xs:restriction></xs:simpleType></xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>

              <xs:element name="patientresponse" minOccurs="0" maxOccurs="1">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="informed" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="instructions" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="checkin" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="clean" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="clerkhelpful" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="clerkrespect" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="drrespect" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="drcomfort" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="drexplain" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="anesthesia" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="anesthesiaexplain" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="anesthesiaside" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dischargeinstructions" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="recovery" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="paininfo" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="painresult" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="nausea" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="nausearesult" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="bleedinginstruction" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="bleedingresult" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="infectioninfo" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="infectionsigns" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="ratefacility" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="0?[0-9]|10|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="recommend" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rateoverall" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rateoverallmental" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="age" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-9]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="gender" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="education" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-6]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="ethnicity" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="group" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racewhite-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceafricanamer-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceamerindian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceasianindian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racechinese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racefilipino-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racejapanese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racekorean-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racevietnamese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceotherasian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenativehawaiian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceguamanianchamorro-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racesamoan-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceotherpacificislander-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racewhite-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceafricanamer-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceamerindian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceasian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenativehawaiianpacificislander-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenoneofabove-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceasianindian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racechinese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racefilipino-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racejapanese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racekorean-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racevietnamese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceotherasian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenoneofaboveasianindian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenativehawaiian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceguamanianchamorro-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racesamoan-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="raceotherpacificislander-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="racenoneofabovepacific-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="speakenglish" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="speakother" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[mM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="speakotherspecify" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12]|[xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helpread" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helpwrote" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helpanswer" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helptranslate" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helpother" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="helpnone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/></xs:restriction></xs:simpleType></xs:element>
                  </xs:sequence>
                </xs:complexType>

              </xs:element>

            </xs:sequence>
          </xs:complexType>

        </xs:element>

      </xs:sequence>
    </xs:complexType>

    <xs:unique name="sampleid_unique" msdata:ConstraintName="sampleid_constraint">
      <xs:selector xpath=".//mstns:administration" />
      <xs:field xpath="mstns:sampleid" />
    </xs:unique>

  </xs:element>

</xs:schema>'
where ExportTemplateID=@ETid

insert into cem.ExportTemplateDefaultResponse (ExportTemplateID, RawValue, RecodeValue, ResponseLabel)
values (@ETid, -9,	' M',	'MISSING')
	, (@ETid, -8,	' M',	'MISSING')
	, (@ETid, -6,	'98',	'DON''T KNOW')
	, (@ETid, -5,	'99',	'REFUSED')
	, (@ETid, -4,	' M',	'NOT APPLICABLE')
	, (@ETid, 10000,' 0',	'(various)')
	, (@ETid, 10001,' 1',	'(various)')
	, (@ETid, 10002,' 2',	'(various)')
	, (@ETid, 10003,' 3',	'(various)')
	, (@ETid, 10004,' 4',	'(various)')
	, (@ETid, 10005,' 5',	'(various)')
	, (@ETid, 10006,' 6',	'(various)')
	, (@ETid, 10007,' 7',	'(various)')
	, (@ETid, 10008,' 8',	'(various)')
	, (@ETid, 10009,' 9',	'(various)')
	, (@ETid, 10010,'10',	'(various)')
	, (@ETid, 10011,'11',	'(various)')
	, (@ETid, 10012,'12',	'(various)')
	, (@ETid, 10013,'13',	'(various)')
	, (@ETid, 10014,'14',	'(various)')

insert into cem.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
select 'header' as ExportTemplateSectionName,
	@ETid as ExportTemplateID,
	NULL as DefaultNamingConvention
set @ETSid=SCOPE_IDENTITY()

insert into cem.ExportTemplateColumn 
	(ExportTemplateSectionID, ExportTemplateColumnDescription,	ColumnOrder,	DatasourceID,	ExportColumnName,	SourceColumnName,					SourceColumnType,	AggregateFunction,											DispositionProcessID,	FixedWidthLength,	ColumnSetKey,	FormatID,	MissingThresholdPercentage,	CheckFrequencies)
VALUES (@ETSid, 'Type of Header Record',						1, 				0, 				'headertype', 		'1', 								56, 				NULL, 														NULL, 					1, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Provider Name', 								2, 				9, 				'providername', 	'FacilityName', 					167,				NULL, 														NULL, 					100, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'CCN', 											3, 				9, 				'providernum', 		'MedicareNumber', 					167,				NULL, 														NULL, 					10, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sample Month', 								4, 				3, 				'samplemonth', 		'month([servicedate])', 			167,				NULL, 														NULL, 					2, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sample Year', 									5, 				3, 				'sampleyear', 		'year([servicedate])', 				167,				NULL, 														NULL, 					4, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Survey Mode', 									6, 				5, 				'surveymode', 		'StandardMethodologyID', 			56, 				NULL, 														NULL, 					1, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sampling Type', 								7, 				0, 				'sampletype', 		'3', 								56, 				NULL, 														NULL, 					1, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Number of Patients Served', 					8, 				4, 				'patientsserved', 	'columnname = ''OAS_PATSERVED''', 	56, 				NULL, 														NULL, 					6, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Number of Patients in File', 					9,  			10,				'patientsfile', 	'NumPatInFile', 					56, 				NULL, 														NULL, 					6, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Number of Eligible Patients', 					10, 			10,				'eligiblepatients', 'EligibleCount',					56, 				NULL, 														NULL, 					6, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Number of Sampled Patients', 					11, 			3, 				'sampledpatients', 	'SamplePopulationID', 				56, 				'count distinct [header.samplemonth],[header.providernum]', NULL, 					6, 					NULL, 			NULL, 		0.95, 						0)


declare @ETCid int
select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='surveymode'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values(@ETCid, '38','3','Mixed')
	, (@ETCid, '39','1','Mail Only')
	, (@ETCid, '40','2','Phone Only')	

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='samplemonth'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values(@ETCid, '1','01','January')
	, (@ETCid, '2','02','February')
	, (@ETCid, '3','03','March')
	, (@ETCid, '4','04','April')
	, (@ETCid, '5','05','May')
	, (@ETCid, '6','06','June')
	, (@ETCid, '7','07','July')
	, (@ETCid, '8','08','August')
	, (@ETCid, '9','09','September')
	, (@ETCid, '10','10','October')
	, (@ETCid, '11','11','November')
	, (@ETCid, '12','12','December')

insert into cem.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
select 'administration' as ExportTemplateSectionName,
	@ETid as ExportTemplateID,
	NULL as DefaultNamingConvention
set @ETSid=SCOPE_IDENTITY()

insert into cem.ExportTemplateColumn 
	(ExportTemplateSectionID, ExportTemplateColumnDescription,	ColumnOrder,	DatasourceID,	ExportColumnName,	SourceColumnName,				SourceColumnType,	AggregateFunction,	DispositionProcessID,	FixedWidthLength,	ColumnSetKey,	FormatID,	MissingThresholdPercentage,	CheckFrequencies)
VALUES (@ETSid, 'CCN', 											1, 				9, 				'providernum', 		'MedicareNumber', 				167, 				NULL, 				NULL, 					10, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sample Month', 								2, 				3, 				'samplemonth', 		'month([servicedate])', 		167, 				NULL, 				NULL, 					2,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sample Year', 									3, 				3, 				'sampleyear', 		'year([servicedate])', 			167, 				NULL, 				NULL, 					4,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Sample ID', 									4, 				3, 				'sampleid', 		'SamplePopulationID', 			167, 				NULL, 				NULL, 					16, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Surgical Category', 	 	 	 	 	 	 	5,  	 	 	0,  	 	 	'surgicalcat', 		'4', 							56,   	 	 	 	NULL,  	 	 	 	NULL,  	 	 	 	 	1,   	 	 	 	NULL,  	 	 	NULL,  	 	0.95,  	 	 	 	 	 	0)
	 , (@ETSid, 'Patient Age', 									6, 				4, 				'patientage', 		'columnname = ''OAS_VISITAGE''',167, 				NULL, 				NULL, 					2,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Patient Gender', 								7, 				3, 				'patientgender',	'isMale', 						167, 				NULL, 				NULL, 					1,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Survey Mode', 									8, 				1, 				'surveymode', 		'ReceiptTypeID', 				167, 				NULL, 				NULL, 					1,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Lag Time', 									9, 				0, 				'lagtime', 			'  ', 							167, 				NULL, 				NULL, 					2,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Final Survey Status', 							10,				3, 				'finalstatus', 		'CAHPSDispositionID', 			56,  				NULL, 				NULL, 					3,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Survey Language', 								11,				3, 				'language', 		'LanguageID', 					56,  				NULL, 				NULL, 					1,  				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'CPT4 (not submitted)', 						12,				4, 				'CPT4', 			'columnname = ''CPT4''', 		167, 				NULL, 				NULL, 					42, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'CPT4_2 (not submitted)', 		 				13,				4, 				'CPT4_2', 			'columnname = ''CPT4_2''',		167, 				NULL, 				NULL, 					42, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'CPT4_3 (not submitted)', 			 	 	 	14, 	 	 	4,  	 	 	'CPT4_3', 			'columnname = ''CPT4_3''',		167,  	 	 	 	NULL,  	 	 	 	NULL,  	 	 	 	 	42,  	 	 	 	NULL,  	 	 	NULL,  	 	0.95,  	 	 	 	 	 	0)
	 , (@ETSid, 'HCPCSLVL2CD (not submitted)', 					15,				4, 				'HCPCSLVL2CD', 		'columnname = ''HCPCSLVL2CD''',	167, 				NULL, 				NULL, 					42, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'HCPCSLVL2CD_2 (not submitted)',				16,				4, 				'HCPCSLVL2CD_2',	'columnname = ''HCPCSLVL2CD_2''',167, 				NULL, 				NULL, 					42, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'HCPCSLVL2CD_3 (not submitted)',				17,				4, 				'HCPCSLVL2CD_3',	'columnname = ''HCPCSLVL2CD_3''',167, 				NULL, 				NULL, 					42, 				NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'Service Date (not submitted)', 				13, 			3, 				'servicedate', 		'servicedate', 					61, 				NULL, 				NULL, 					8, 					NULL, 			NULL, 		0.95, 						0)
	 , (@ETSid, 'First Survey Mailed (not submitted)', 			14, 			5, 				'firstmailed', 		'datFirstMailed', 				61, 				NULL, 				NULL, 					8, 					NULL, 			NULL, 		0.95, 						0)

update et
set ValidDateColumnID=ExportTemplateColumnID
from cem.ExportTemplate ET, cem.ExportTemplateColumn etc
where et.ExportTemplateID=@ETid
and etc.ExportColumnName='servicedate'
and etc.ExportTemplateSectionID=@ETSid

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='samplemonth'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values(@ETCid, '1','01','January')
	, (@ETCid, '2','02','February')
	, (@ETCid, '3','03','March')
	, (@ETCid, '4','04','April')
	, (@ETCid, '5','05','May')
	, (@ETCid, '6','06','June')
	, (@ETCid, '7','07','July')
	, (@ETCid, '8','08','August')
	, (@ETCid, '9','09','September')
	, (@ETCid, '10','10','October')
	, (@ETCid, '11','11','November')
	, (@ETCid, '12','12','December')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='surgicalcat'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid,	1, 1, 'Gastrointestinal (GI)')
	 , (@ETCid, 2, 2, 'Orthopedic')
	 , (@ETCid, 3, 3, 'Ophthalmologic')
	 , (@ETCid, 4, 4, 'Other')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='patientage'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid, 18, ' 1', '18–24')
	 , (@ETCid, 19, ' 1', '18–24')
	 , (@ETCid, 20, ' 1', '18–24')
	 , (@ETCid, 21, ' 1', '18–24')
	 , (@ETCid, 22, ' 1', '18–24')
	 , (@ETCid, 23, ' 1', '18–24')
	 , (@ETCid, 24, ' 1', '18–24')
	 , (@ETCid, 25, ' 2', '25-29')
	 , (@ETCid, 26, ' 2', '25-29')
	 , (@ETCid, 27, ' 2', '25-29')
	 , (@ETCid, 28, ' 2', '25-29')
	 , (@ETCid, 29, ' 2', '25-29')
	 , (@ETCid, 30, ' 3', '30-34')
	 , (@ETCid, 31, ' 3', '30-34')
	 , (@ETCid, 32, ' 3', '30-34')
	 , (@ETCid, 33, ' 3', '30-34')
	 , (@ETCid, 34, ' 3', '30-34')
	 , (@ETCid, 35, ' 4', '35-39')
	 , (@ETCid, 36, ' 4', '35-39')
	 , (@ETCid, 37, ' 4', '35-39')
	 , (@ETCid, 38, ' 4', '35-39')
	 , (@ETCid, 39, ' 4', '35-39')
	 , (@ETCid, 40, ' 5', '40-44')
	 , (@ETCid, 41, ' 5', '40-44')
	 , (@ETCid, 42, ' 5', '40-44')
	 , (@ETCid, 43, ' 5', '40-44')
	 , (@ETCid, 44, ' 5', '40-44')
	 , (@ETCid, 45, ' 6', '45-49')
	 , (@ETCid, 46, ' 6', '45-49')
	 , (@ETCid, 47, ' 6', '45-49')
	 , (@ETCid, 48, ' 6', '45-49')
	 , (@ETCid, 49, ' 6', '45-49')
	 , (@ETCid, 50, ' 7', '50-54')
	 , (@ETCid, 51, ' 7', '50-54')
	 , (@ETCid, 52, ' 7', '50-54')
	 , (@ETCid, 53, ' 7', '50-54')
	 , (@ETCid, 54, ' 7', '50-54')
	 , (@ETCid, 55, ' 8', '55-59')
	 , (@ETCid, 56, ' 8', '55-59')
	 , (@ETCid, 57, ' 8', '55-59')
	 , (@ETCid, 58, ' 8', '55-59')
	 , (@ETCid, 59, ' 8', '55-59')
	 , (@ETCid, 60, ' 9', '60-64')
	 , (@ETCid, 61, ' 9', '60-64')
	 , (@ETCid, 62, ' 9', '60-64')
	 , (@ETCid, 63, ' 9', '60-64')
	 , (@ETCid, 64, ' 9', '60-64')
	 , (@ETCid, 65, '10', '65-69')
	 , (@ETCid, 66, '10', '65-69')
	 , (@ETCid, 67, '10', '65-69')
	 , (@ETCid, 68, '10', '65-69')
	 , (@ETCid, 69, '10', '65-69')
	 , (@ETCid, 70, '11', '70-74')
	 , (@ETCid, 71, '11', '70-74')
	 , (@ETCid, 72, '11', '70-74')
	 , (@ETCid, 73, '11', '70-74')
	 , (@ETCid, 74, '11', '70-74')
	 , (@ETCid, 75, '12', '75-79')
	 , (@ETCid, 76, '12', '75-79')
	 , (@ETCid, 77, '12', '75-79')
	 , (@ETCid, 78, '12', '75-79')
	 , (@ETCid, 79, '12', '75-79')
	 , (@ETCid, 80, '13', '80-84')
	 , (@ETCid, 81, '13', '80-84')
	 , (@ETCid, 82, '13', '80-84')
	 , (@ETCid, 83, '13', '80-84')
	 , (@ETCid, 84, '13', '80-84')
	 , (@ETCid, 85, '14', '85-89')
	 , (@ETCid, 86, '14', '85-89')
	 , (@ETCid, 87, '14', '85-89')
	 , (@ETCid, 88, '14', '85-89')
	 , (@ETCid, 89, '14', '85-89')
	 , (@ETCid, 90, '15', '90 or older')
	 , (@ETCid, 91, '15', '90 or older')
	 , (@ETCid, 92, '15', '90 or older')
	 , (@ETCid, 93, '15', '90 or older')
	 , (@ETCid, 94, '15', '90 or older')
	 , (@ETCid, 95, '15', '90 or older')
	 , (@ETCid, 96, '15', '90 or older')
	 , (@ETCid, 97, '15', '90 or older')
	 , (@ETCid, 98, '15', '90 or older')
	 , (@ETCid, 99, '15', '90 or older')
	 , (@ETCid, 100, '15', '90 or older')
	 , (@ETCid, 101, '15', '90 or older')
	 , (@ETCid, 102, '15', '90 or older')
	 , (@ETCid, 103, '15', '90 or older')
	 , (@ETCid, 104, '15', '90 or older')
	 , (@ETCid, 105, '15', '90 or older')
	 , (@ETCid, 106, '15', '90 or older')
	 , (@ETCid, 107, '15', '90 or older')
	 , (@ETCid, 108, '15', '90 or older')
	 , (@ETCid, 109, '15', '90 or older')
	 , (@ETCid, 110, '15', '90 or older')
	 , (@ETCid, 111, '15', '90 or older')
	 , (@ETCid, 112, '15', '90 or older')
	 , (@ETCid, 113, '15', '90 or older')
	 , (@ETCid, 114, '15', '90 or older')
	 , (@ETCid, 115, '15', '90 or older')
	 , (@ETCid, 116, '15', '90 or older')
	 , (@ETCid, 117, '15', '90 or older')
	 , (@ETCid, 118, '15', '90 or older')
	 , (@ETCid, 119, '15', '90 or older')
	 , (@ETCid, 120, '15', '90 or older')
	 , (@ETCid, NULL, 'M', 'Unknown/Missing')

/*
verifiy that 1->Male, 0->Female is sufficient for reporting patientgender. i.e. there are no other values besides 'M' and 'F' in the study tables:

create table #sexcheck (samplepopulationid int, isMale bit, SurveyID int, Survey_id int, Study_id int, Samplepop_id int, Pop_id int, sex varchar(42))

insert into #sexcheck (samplepopulationid, ismale, surveyid)
select sp.samplepopulationid, sp.ismale, su.surveyID
from NRC_Datamart.dbo.samplepopulation sp 
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
where su.SurveyID in (200765600,198935573,200765596,200765603,205907245,198474172,200765601,200765602,200765587,200765589,200765598,200765605,200765614,205146368,198935571,200765599,201383643,202263087,206031012,198935576,200765594,200765608,203605273,200765592,200765593,200765609,200765610,200765611,205906782,198935575,200765607,200765612,200765621,201970166,206031010,200765591,198935574,200765588,200765604,200765622,205341803,198770547,201970163,201970165,204811583,198935572,200765590,200765595,200765606,200765613,201588010,206031009,206031011,206187721)
order by 1

update sc set survey_id=css.survey_id, study_id=css.study_id
from #sexcheck sc
inner join nrc_datamart.etl.DataSourceKey dsk on sc.surveyid=dsk.DataSourceKeyID
inner join qualisys.qp_prod.dbo.clientstudysurvey_view css on dsk.DataSourceKey = css.survey_id

update sc set samplepop_id=dsk.DataSourceKey, pop_id=sp.pop_id
from #sexcheck sc
inner join nrc_datamart.etl.DataSourceKey dsk on sc.samplepopulationid=dsk.DataSourceKeyID
inner join qualisys.qp_prod.dbo.samplepop sp on dsk.DataSourceKey = sp.samplepop_id

declare @sql varchar(max), @study char(4)
select top 1 @study=study_id from #sexcheck where sex is null
while @@rowcount>0
begin
	set @sql = 'update sc set sex=p.sex from #sexcheck sc inner join qualisys.qp_prod.s'+@study+'.population p on sc.study_id='+@study+' and sc.pop_id=p.pop_id'
	exec (@sql)
	update #sexcheck set sex='?' where sex is null and study_id=@study
	select top 1 @study=study_id from #sexcheck where sex is null
end

select distinct ismale,sex from #sexcheck
*/

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='patientgender'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid,	1, '1', 'Male')
	 , (@ETCid, 0, '2', 'Female')
	 , (@ETCid, NULL, 'X', 'Unknown/Missing')
	 
select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='surveymode'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid,	17, '1', 'Mail only')
	 , (@ETCid, 12, '2', 'Telephone only')
	 , (@ETCid, NULL, 'X', 'Unknown/Missing')


select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='finalstatus'

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid,	9110, '110', 'Completed Mail Survey')
	 , (@ETCid, 9120, '120', 'Completed Phone Survey')
	 , (@ETCid, 9210, '210', 'Ineligible: Deceased')
	 , (@ETCid, 9220, '220', 'Ineligible: Does not Meet Eligibility criteria')
	 , (@ETCid, 9230, '230', 'Ineligible: Language Barrier')
	 , (@ETCid, 9240, '240', 'Ineligible: Mentally or Physically Incapacitated')
	 , (@ETCid, 9310, '310', 'Breakoff')
	 , (@ETCid, 9320, '320', 'Refusal')
	 , (@ETCid, 9330, '330', 'Bad Address/ Undeliverable Mail')
	 , (@ETCid, 9340, '340', 'Wrong/Disc/No Telephone Number')
	 , (@ETCid, 9350, '350', 'No response after Maximum attempts')

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='language'
insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
values (@ETCid,	1, '1', 'English')
	 , (@ETCid, 2, '2', 'Spanish')
	 , (@ETCid, 19, '2', 'Spanish')


create table #OAS (qstncore int, qstnlabel varchar(250), val varchar(50), responselabel varchar(200), intorder int, ExportTemplateColumnDescription varchar(40), ETCid int)
insert into #OAS (qstncore, intOrder, ExportTemplateColumnDescription, val, responselabel, qstnlabel)
values 
  (	54086,	1,	'informed',	'1',	'Yes, definitely',	'Q1 Before your procedure, did your doctor or anyone from the facility give you all the information you needed about your procedure?')
, (	54086,	1,	'informed',	'2',	'Yes, somewhat',	'Q1 Before your procedure, did your doctor or anyone from the facility give you all the information you needed about your procedure?')
, (	54086,	1,	'informed',	'3',	'No',	'Q1 Before your procedure, did your doctor or anyone from the facility give you all the information you needed about your procedure?')
, (	54086,	1,	'informed',	'M',	'MISSING/DK',	'Q1 Before your procedure, did your doctor or anyone from the facility give you all the information you needed about your procedure?')
, (	54087,	2,	'instructions',	'1',	'Yes, definitely',	'Q2 Before your procedure, did your doctor or anyone from the facility give you easy to understand instructions about getting ready for your procedure?')
, (	54087,	2,	'instructions',	'2',	'Yes, somewhat',	'Q2 Before your procedure, did your doctor or anyone from the facility give you easy to understand instructions about getting ready for your procedure?')
, (	54087,	2,	'instructions',	'3',	'No',	'Q2 Before your procedure, did your doctor or anyone from the facility give you easy to understand instructions about getting ready for your procedure?')
, (	54087,	2,	'instructions',	'M',	'MISSING/DK',	'Q2 Before your procedure, did your doctor or anyone from the facility give you easy to understand instructions about getting ready for your procedure?')
, (	54088,	3,	'checkin',	'1',	'Yes, definitely',	'Q3 Did the check-in process run smoothly?')
, (	54088,	3,	'checkin',	'2',	'Yes, somewhat',	'Q3 Did the check-in process run smoothly?')
, (	54088,	3,	'checkin',	'3',	'No',	'Q3 Did the check-in process run smoothly?')
, (	54088,	3,	'checkin',	'M',	'MISSING/DK',	'Q3 Did the check-in process run smoothly?')
, (	54089,	4,	'clean',	'1',	'Yes, definitely',	'Q4 Was the facility clean?')
, (	54089,	4,	'clean',	'2',	'Yes, somewhat',	'Q4 Was the facility clean?')
, (	54089,	4,	'clean',	'3',	'No',	'Q4 Was the facility clean?')
, (	54089,	4,	'clean',	'M',	'MISSING/DK',	'Q4 Was the facility clean?')
, (	54090,	5,	'clerkhelpful',	'1',	'Yes, definitely',	'Q5 Were the clerks and receptionists at the facility as helpful as you thought they should be?')
, (	54090,	5,	'clerkhelpful',	'2',	'Yes, somewhat',	'Q5 Were the clerks and receptionists at the facility as helpful as you thought they should be?')
, (	54090,	5,	'clerkhelpful',	'3',	'No',	'Q5 Were the clerks and receptionists at the facility as helpful as you thought they should be?')
, (	54090,	5,	'clerkhelpful',	'M',	'MISSING/DK',	'Q5 Were the clerks and receptionists at the facility as helpful as you thought they should be?')
, (	54091,	6,	'clerkrespect',	'1',	'Yes, definitely',	'Q6 Did the clerks and receptionists at the facility treat you with courtesy and respect?')
, (	54091,	6,	'clerkrespect',	'2',	'Yes, somewhat',	'Q6 Did the clerks and receptionists at the facility treat you with courtesy and respect?')
, (	54091,	6,	'clerkrespect',	'3',	'No',	'Q6 Did the clerks and receptionists at the facility treat you with courtesy and respect?')
, (	54091,	6,	'clerkrespect',	'M',	'MISSING/DK',	'Q6 Did the clerks and receptionists at the facility treat you with courtesy and respect?')
, (	54092,	7,	'drrespect',	'1',	'Yes, definitely',	'Q7 Did the doctors and nurses treat you with courtesy and respect?')
, (	54092,	7,	'drrespect',	'2',	'Yes, somewhat',	'Q7 Did the doctors and nurses treat you with courtesy and respect?')
, (	54092,	7,	'drrespect',	'3',	'No',	'Q7 Did the doctors and nurses treat you with courtesy and respect?')
, (	54092,	7,	'drrespect',	'M',	'MISSING/DK',	'Q7 Did the doctors and nurses treat you with courtesy and respect?')
, (	54093,	8,	'drcomfort',	'1',	'Yes, definitely',	'Q8 Did the doctors and nurses make sure you were as comfortable as possible?')
, (	54093,	8,	'drcomfort',	'2',	'Yes, somewhat',	'Q8 Did the doctors and nurses make sure you were as comfortable as possible?')
, (	54093,	8,	'drcomfort',	'3',	'No',	'Q8 Did the doctors and nurses make sure you were as comfortable as possible?')
, (	54093,	8,	'drcomfort',	'M',	'MISSING/DK',	'Q8 Did the doctors and nurses make sure you were as comfortable as possible?')
, (	54094,	9,	'drexplain',	'1',	'Yes, definitely',	'Q9 Did the doctors and nurses explain your procedure in a way that was easy to understand?')
, (	54094,	9,	'drexplain',	'2',	'Yes, somewhat',	'Q9 Did the doctors and nurses explain your procedure in a way that was easy to understand?')
, (	54094,	9,	'drexplain',	'3',	'No',	'Q9 Did the doctors and nurses explain your procedure in a way that was easy to understand?')
, (	54094,	9,	'drexplain',	'M',	'MISSING/DK',	'Q9 Did the doctors and nurses explain your procedure in a way that was easy to understand?')
, (	54095,	10,	'anesthesia',	'1',	'Yes',	'Q10 Anesthesia is something that would make you feel sleepy or go to sleep during your procedure. Were you given anesthesia?')
, (	54095,	10,	'anesthesia',	'2',	'No',	'Q10 Anesthesia is something that would make you feel sleepy or go to sleep during your procedure. Were you given anesthesia?')
, (	54095,	10,	'anesthesia',	'M',	'MISSING/DK',	'Q10 Anesthesia is something that would make you feel sleepy or go to sleep during your procedure. Were you given anesthesia?')
, (	54096,	11,	'anesthesiaexplain',	'1',	'Yes, definitely',	'Q11 Did your doctor or anyone from the facility explain the process of giving anesthesia in a way that was easy to understand?')
, (	54096,	11,	'anesthesiaexplain',	'2',	'Yes, somewhat',	'Q11 Did your doctor or anyone from the facility explain the process of giving anesthesia in a way that was easy to understand?')
, (	54096,	11,	'anesthesiaexplain',	'3',	'No',	'Q11 Did your doctor or anyone from the facility explain the process of giving anesthesia in a way that was easy to understand?')
, (	54096,	11,	'anesthesiaexplain',	'M',	'MISSING/DK',	'Q11 Did your doctor or anyone from the facility explain the process of giving anesthesia in a way that was easy to understand?')
, (	54096,	11,	'anesthesiaexplain',	'X',	'NOT APPLICABLE',	'Q11 Did your doctor or anyone from the facility explain the process of giving anesthesia in a way that was easy to understand?')
, (	54097,	12,	'anesthesiaside',	'1',	'Yes, definitely',	'Q12 Did your doctor or anyone from the facility explain the possible side effects of the anesthesia in a way that was easy to understand?')
, (	54097,	12,	'anesthesiaside',	'2',	'Yes, somewhat',	'Q12 Did your doctor or anyone from the facility explain the possible side effects of the anesthesia in a way that was easy to understand?')
, (	54097,	12,	'anesthesiaside',	'3',	'No',	'Q12 Did your doctor or anyone from the facility explain the possible side effects of the anesthesia in a way that was easy to understand?')
, (	54097,	12,	'anesthesiaside',	'M',	'MISSING/DK',	'Q12 Did your doctor or anyone from the facility explain the possible side effects of the anesthesia in a way that was easy to understand?')
, (	54097,	12,	'anesthesiaside',	'X',	'NOT APPLICABLE',	'Q12 Did your doctor or anyone from the facility explain the possible side effects of the anesthesia in a way that was easy to understand?')
, (	54098,	13,	'dischargeinstructions',	'1',	'Yes',	'Q13 Discharge instructions include things like symptoms you should watch for after your procedure, instructions about medicines, and home care. Before you left the facility, did you get written discharge instructions?')
, (	54098,	13,	'dischargeinstructions',	'2',	'No',	'Q13 Discharge instructions include things like symptoms you should watch for after your procedure, instructions about medicines, and home care. Before you left the facility, did you get written discharge instructions?')
, (	54098,	13,	'dischargeinstructions',	'M',	'MISSING/DK',	'Q13 Discharge instructions include things like symptoms you should watch for after your procedure, instructions about medicines, and home care. Before you left the facility, did you get written discharge instructions?')
, (	54099,	14,	'recovery',	'1',	'Yes, definitely',	'Q14 Did your doctor or anyone from the facility prepare you for what to expect during your recovery?')
, (	54099,	14,	'recovery',	'2',	'Yes, somewhat',	'Q14 Did your doctor or anyone from the facility prepare you for what to expect during your recovery?')
, (	54099,	14,	'recovery',	'3',	'No',	'Q14 Did your doctor or anyone from the facility prepare you for what to expect during your recovery?')
, (	54099,	14,	'recovery',	'M',	'MISSING/DK',	'Q14 Did your doctor or anyone from the facility prepare you for what to expect during your recovery?')
, (	54100,	15,	'paininfo',	'1',	'Yes, definitely',	'Q15 Some ways to control pain include prescription medicine, over-the-counter pain relievers or ice packs. Did your doctor or anyone from the facility give you information about what to do if you had pain as a result of your procedure?')
, (	54100,	15,	'paininfo',	'2',	'Yes, somewhat',	'Q15 Some ways to control pain include prescription medicine, over-the-counter pain relievers or ice packs. Did your doctor or anyone from the facility give you information about what to do if you had pain as a result of your procedure?')
, (	54100,	15,	'paininfo',	'3',	'No',	'Q15 Some ways to control pain include prescription medicine, over-the-counter pain relievers or ice packs. Did your doctor or anyone from the facility give you information about what to do if you had pain as a result of your procedure?')
, (	54100,	15,	'paininfo',	'M',	'MISSING/DK',	'Q15 Some ways to control pain include prescription medicine, over-the-counter pain relievers or ice packs. Did your doctor or anyone from the facility give you information about what to do if you had pain as a result of your procedure?')
, (	54101,	16,	'painresult',	'1',	'Yes',	'Q16 At any time after leaving the facility, did you have pain as a result of your procedure?')
, (	54101,	16,	'painresult',	'2',	'No',	'Q16 At any time after leaving the facility, did you have pain as a result of your procedure?')
, (	54101,	16,	'painresult',	'M',	'MISSING/DK',	'Q16 At any time after leaving the facility, did you have pain as a result of your procedure?')
, (	54102,	17,	'nausea',	'1',	'Yes, definitely',	'Q17 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had nausea or vomiting?')
, (	54102,	17,	'nausea',	'2',	'Yes, somewhat',	'Q17 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had nausea or vomiting?')
, (	54102,	17,	'nausea',	'3',	'No',	'Q17 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had nausea or vomiting?')
, (	54102,	17,	'nausea',	'M',	'MISSING/DK',	'Q17 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had nausea or vomiting?')
, (	54103,	18,	'nausearesult',	'1',	'Yes',	'Q18 At any time after leaving the facility, did you have nausea or vomiting as a result of either your procedure or the anesthesia?')
, (	54103,	18,	'nausearesult',	'2',	'No',	'Q18 At any time after leaving the facility, did you have nausea or vomiting as a result of either your procedure or the anesthesia?')
, (	54103,	18,	'nausearesult',	'M',	'MISSING/DK',	'Q18 At any time after leaving the facility, did you have nausea or vomiting as a result of either your procedure or the anesthesia?')
, (	54104,	19,	'bleedinginstruction',	'1',	'Yes, definitely',	'Q19 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had bleeding as a result of your procedure?')
, (	54104,	19,	'bleedinginstruction',	'2',	'Yes, somewhat',	'Q19 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had bleeding as a result of your procedure?')
, (	54104,	19,	'bleedinginstruction',	'3',	'No',	'Q19 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had bleeding as a result of your procedure?')
, (	54104,	19,	'bleedinginstruction',	'M',	'MISSING/DK',	'Q19 Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had bleeding as a result of your procedure?')
, (	54105,	20,	'bleedingresult',	'1',	'Yes',	'Q20 At any time after leaving the facility, did you have bleeding as a result of your procedure?')
, (	54105,	20,	'bleedingresult',	'2',	'No',	'Q20 At any time after leaving the facility, did you have bleeding as a result of your procedure?')
, (	54105,	20,	'bleedingresult',	'M',	'MISSING/DK',	'Q20 At any time after leaving the facility, did you have bleeding as a result of your procedure?')
, (	54106,	21,	'infectioninfo',	'1',	'Yes, definitely',	'Q21 Possible signs of infection include fever, swelling, heat, drainage or redness. Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had possible signs of infection?')
, (	54106,	21,	'infectioninfo',	'2',	'Yes, somewhat',	'Q21 Possible signs of infection include fever, swelling, heat, drainage or redness. Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had possible signs of infection?')
, (	54106,	21,	'infectioninfo',	'3',	'No',	'Q21 Possible signs of infection include fever, swelling, heat, drainage or redness. Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had possible signs of infection?')
, (	54106,	21,	'infectioninfo',	'M',	'MISSING/DK',	'Q21 Possible signs of infection include fever, swelling, heat, drainage or redness. Before you left the facility, did your doctor or anyone from the facility give you information about what to do if you had possible signs of infection?')
, (	54107,	22,	'infectionsigns',	'1',	'Yes',	'Q22 At any time after leaving the facility, did you have any signs of infection?')
, (	54107,	22,	'infectionsigns',	'2',	'No',	'Q22 At any time after leaving the facility, did you have any signs of infection?')
, (	54107,	22,	'infectionsigns',	'M',	'MISSING/DK',	'Q22 At any time after leaving the facility, did you have any signs of infection?')
, (	54108,	23,	'ratefacility',	' 0',	'Worst facility possible',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 1',	'1',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 2',	'2',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 3',	'3',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 4',	'4',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 5',	'5',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 6',	'6',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 7',	'7',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 8',	'8',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' 9',	'9',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	'10',	'Best facility possible',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54108,	23,	'ratefacility',	' M',	'MISSING/DK',	'Q23 Using any number from 0 to 10, where 0 is the worst facility possible and 10 is the best facility possible, what number would you use to rate this facility?')
, (	54109,	24,	'recommend',	'1',	'Definitely no',	'Q24 Would you recommend this facility to your friends and family?')
, (	54109,	24,	'recommend',	'2',	'Probably no',	'Q24 Would you recommend this facility to your friends and family?')
, (	54109,	24,	'recommend',	'3',	'Probably yes',	'Q24 Would you recommend this facility to your friends and family?')
, (	54109,	24,	'recommend',	'4',	'Definitely yes',	'Q24 Would you recommend this facility to your friends and family?')
, (	54109,	24,	'recommend',	'M',	'MISSING/DK',	'Q24 Would you recommend this facility to your friends and family?')
, (	54110,	25,	'rateoverall',	'1',	'Excellent',	'Q25 In general, how would you rate your overall health?')
, (	54110,	25,	'rateoverall',	'2',	'Very good',	'Q25 In general, how would you rate your overall health?')
, (	54110,	25,	'rateoverall',	'3',	'Good',	'Q25 In general, how would you rate your overall health?')
, (	54110,	25,	'rateoverall',	'4',	'Fair',	'Q25 In general, how would you rate your overall health?')
, (	54110,	25,	'rateoverall',	'5',	'Poor',	'Q25 In general, how would you rate your overall health?')
, (	54110,	25,	'rateoverall',	'M',	'MISSING/DK',	'Q25 In general, how would you rate your overall health?')
, (	54111,	26,	'rateoverallmental',	'1',	'Excellent',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54111,	26,	'rateoverallmental',	'2',	'Very good',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54111,	26,	'rateoverallmental',	'3',	'Good',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54111,	26,	'rateoverallmental',	'4',	'Fair',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54111,	26,	'rateoverallmental',	'5',	'Poor',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54111,	26,	'rateoverallmental',	'M',	'MISSING/DK',	'Q26 In general, how would you rate your overall mental or emotional health?')
, (	54112,	27,	'age',	'1',	'18 to 24',	'Q27 What is your age?')
, (	54112,	27,	'age',	'2',	'25 to 34',	'Q27 What is your age?')
, (	54112,	27,	'age',	'3',	'35 to 44',	'Q27 What is your age?')
, (	54112,	27,	'age',	'4',	'45 to 54',	'Q27 What is your age?')
, (	54112,	27,	'age',	'5',	'55 to 64',	'Q27 What is your age?')
, (	54112,	27,	'age',	'6',	'65 to 74',	'Q27 What is your age?')
, (	54112,	27,	'age',	'7',	'75 to 79',	'Q27 What is your age?')
, (	54112,	27,	'age',	'8',	'80 to 84',	'Q27 What is your age?')
, (	54112,	27,	'age',	'9',	'85 or older',	'Q27 What is your age?')
, (	54112,	27,	'age',	'M',	'MISSING/DK',	'Q27 What is your age?')
, (	54113,	28,	'gender',	'1',	'Male',	'Q28 Are you male or female?')
, (	54113,	28,	'gender',	'2',	'Female',	'Q28 Are you male or female?')
, (	54113,	28,	'gender',	'M',	'MISSING/DK',	'Q28 Are you male or female?')
, (	54114,	29,	'education',	'1',	'8th grade or less',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'2',	'Some high school, but did not graduate',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'3',	'High school graduate or GED',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'4',	'Some college or 2-year degree',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'5',	'4-year college graduate',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'6',	'More than 4-year college degree',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54114,	29,	'education',	'M',	'MISSING/DK',	'Q29 What is the highest grade or level of school that you have completed?')
, (	54115,	30,	'ethnicity',	'1',	'Yes',	'Q30 Are you of Hispanic, Latino, or Spanish origin?')
, (	54115,	30,	'ethnicity',	'2',	'No',	'Q30 Are you of Hispanic, Latino, or Spanish origin?')
, (	54115,	30,	'ethnicity',	'M',	'MISSING/DK',	'Q30 Are you of Hispanic, Latino, or Spanish origin?')
, (	54116,	31,	'group',	'1',	'Mexican, Mexican American, Chicano',	'Q31 Which group best describes you?')
, (	54116,	31,	'group',	'2',	'Puerto Rican',	'Q31 Which group best describes you?')
, (	54116,	31,	'group',	'3',	'Cuban',	'Q31 Which group best describes you?')
, (	54116,	31,	'group',	'4',	'Another Hispanic, Latino, or Spanish origin',	'Q31 Which group best describes you?')
, (	54116,	31,	'group',	'M',	'MISSING/DK',	'Q31 Which group best describes you?')
, (	54116,	31,	'group',	'X',	'NOT APPLICABLE',	'Q31 Which group best describes you?')
, (	54117,	32,	'racewhite-mail',		'1',	'White',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	32,	'racewhite-mail',		'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	32,	'racewhite-mail',		'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	33,	'raceafricanamer-mail',	'2',	'Black or African American',	'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	33,	'raceafricanamer-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	33,	'raceafricanamer-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	34,	'raceamerindian-mail',	'3',	'American Indian or Alaska Native',	'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	34,	'raceamerindian-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	34,	'raceamerindian-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	35,	'raceasianindian-mail',	'4',	'Asian Indian',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	35,	'raceasianindian-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	35,	'raceasianindian-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	36,	'racechinese-mail',		'5',	'Chinese',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	36,	'racechinese-mail',		'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	36,	'racechinese-mail',		'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	37,	'racefilipino-mail',	'6',	'Filipino',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	37,	'racefilipino-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	37,	'racefilipino-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	38,	'racejapanese-mail',	'7',	'Japanese',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	38,	'racejapanese-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	38,	'racejapanese-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	39,	'racekorean-mail',		'8',	'Korean',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	39,	'racekorean-mail',		'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	39,	'racekorean-mail',		'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	40,	'racevietnamese-mail',	'9',	'Vietnamese',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	40,	'racevietnamese-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	40,	'racevietnamese-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	41,	'raceotherasian-mail',	'10',	'Other Asian',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	41,	'raceotherasian-mail',	'M',	'MISSING/DK',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	41,	'raceotherasian-mail',	'X',	'NOT APPLICABLE',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	42,	'racenativehawaiian-mail',	'11',	'Native Hawaiian',			'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	42,	'racenativehawaiian-mail',	'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	42,	'racenativehawaiian-mail',	'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	43,	'raceguamanianchamorro-mail',	'12',	'Guamanian or Chamorro','Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	43,	'raceguamanianchamorro-mail',	'M',	'MISSING/DK',			'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	43,	'raceguamanianchamorro-mail',	'X',	'NOT APPLICABLE',		'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	44,	'racesamoan-mail',	'13',	'Samoan',							'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	44,	'racesamoan-mail',	'M',	'MISSING/DK',						'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	44,	'racesamoan-mail',	'X',	'NOT APPLICABLE',					'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	45,	'raceotherpacificislander-mail',	'14',	'Other Pacific Islander',	'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	45,	'raceotherpacificislander-mail',	'M',	'MISSING/DK',		'Q32 What is your race? You may select one or more categories. (mail only)')
, (	54117,	45,	'raceotherpacificislander-mail',	'X',	'NOT APPLICABLE',	'Q32 What is your race? You may select one or more categories. (mail only)')

, (	54181,	46,	'racewhite-phone',			'1',	'White',					'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	46,	'racewhite-phone',			'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	46,	'racewhite-phone',			'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	47,	'raceafricanamer-phone',	'2',	'Black or African American','Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	47,	'raceafricanamer-phone',	'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	47,	'raceafricanamer-phone',	'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	48,	'raceamerindian-phone',		'3',	'American Indian or Alaska Native',	'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	48,	'raceamerindian-phone',		'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	48,	'raceamerindian-phone',		'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	49,	'raceasian-phone',			'4',	'Asian',					'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	49,	'raceasian-phone',			'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	49,	'raceasian-phone',			'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	50,	'racenativehawaiianpacificislander-phone',	'5',	'Native Hawaiian or Pacific Islander',	'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	50,	'racenativehawaiianpacificislander-phone',	'M',	'MISSING/DK',							'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	50,	'racenativehawaiianpacificislander-phone',	'X',	'NOT APPLICABLE',						'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	51,	'racenoneofabove-phone',	'6',	'NONE OF ABOVE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	51,	'racenoneofabove-phone',	'M',	'MISSING/DK',				'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54181,	51,	'racenoneofabove-phone',	'X',	'NOT APPLICABLE',			'Q32 What is your race? You may select one or more categories. Are you… (phone only)')
, (	54182,	52,	'raceasianindian-phone',	'1',	'Asian Indian',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	52,	'raceasianindian-phone',	'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	52,	'raceasianindian-phone',	'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	53,	'racechinese-phone',		'2',	'Chinese',					'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	53,	'racechinese-phone',		'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	53,	'racechinese-phone',		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	54,	'racefilipino-phone',		'3',	'Filipino',					'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	54,	'racefilipino-phone',		'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	54,	'racefilipino-phone',		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	55,	'racejapanese-phone',		'4',	'Japanese',					'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	55,	'racejapanese-phone',		'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	55,	'racejapanese-phone',		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	56,	'racekorean-phone',			'5',	'Korean',					'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	56,	'racekorean-phone',			'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	56,	'racekorean-phone'	,		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	57,	'racevietnamese-phone',		'6',	'Vietnamese',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	57,	'racevietnamese-phone',		'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	57,	'racevietnamese-phone',		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	58,	'raceotherasian-phone',		'7',	'Other Asian',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	58,	'raceotherasian-phone',		'M',	'MISSING/DK',				'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	58,	'raceotherasian-phone',		'X',	'NOT APPLICABLE',			'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	59,	'racenoneofaboveasianindian-phone',	'8',	'NONE OF ABOVE',	'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	59,	'racenoneofaboveasianindian-phone',	'M',	'MISSING/DK',		'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54182,	59,	'racenoneofaboveasianindian-phone',	'X',	'NOT APPLICABLE',	'Q32a Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	60,	'racenativehawaiian-phone',	'1',	'Native Hawaiian',			'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	60,	'racenativehawaiian-phone',	'M',	'MISSING/DK',				'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	60,	'racenativehawaiian-phone',	'X',	'NOT APPLICABLE',			'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	61,	'raceguamanianchamorro-phone',	'2',	'Guamanian or Chamorro','Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	61,	'raceguamanianchamorro-phone',	'M',	'MISSING/DK',			'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	61,	'raceguamanianchamorro-phone',	'X',	'NOT APPLICABLE',		'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	62,	'racesamoan-phone',			'3',	'Samoan',					'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	62,	'racesamoan-phone',			'M',	'MISSING/DK',				'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	62,	'racesamoan-phone',			'X',	'NOT APPLICABLE',			'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	63,	'raceotherpacificislander-phone',	'4','Other Pacific Islander',	'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	63,	'raceotherpacificislander-phone',	'M',	'MISSING/DK',		'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	63,	'raceotherpacificislander-phone',	'X',	'NOT APPLICABLE',	'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	64,	'racenoneofabovepacific-phone',	'5',	'NONE OF ABOVE',		'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	64,	'racenoneofabovepacific-phone',	'M',	'MISSING/DK',			'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')
, (	54183,	64,	'racenoneofabovepacific-phone',	'X',	'NOT APPLICABLE',		'Q32b Which groups best describe you? You may select one or more categories. Are you… (phone only)')

, (	54118,	65,	'speakenglish',	'1',	'Very well',	'Q33 How well do you speak English? (Would you say…)')
, (	54118,	65,	'speakenglish',	'2',	'Well',	'Q33 How well do you speak English? (Would you say…)')
, (	54118,	65,	'speakenglish',	'3',	'Not well',	'Q33 How well do you speak English? (Would you say…)')
, (	54118,	65,	'speakenglish',	'4',	'Not at all',	'Q33 How well do you speak English? (Would you say…)')
, (	54118,	65,	'speakenglish',	'M',	'MISSING/DK',	'Q33 How well do you speak English? (Would you say…)')
, (	54119,	66,	'speakother',	'1',	'Yes, speak language other than English',	'Q34 Do you speak a language other than English at home?')
, (	54119,	66,	'speakother',	'2',	'No, speak English at home',	'Q34 Do you speak a language other than English at home?')
, (	54119,	66,	'speakother',	'M',	'MISSING/DK',	'Q34 Do you speak a language other than English at home?')
, (	54120,	67,	'speakotherspecify',	'1',	'Spanish',	'Q35 What is that language?')
, (	54120,	67,	'speakotherspecify',	'2',	'Other',	'Q35 What is that language?')
, (	54120,	67,	'speakotherspecify',	'M',	'MISSING/DK',	'Q35 What is that language?')
, (	54120,	67,	'speakotherspecify',	'X',	'NOT APPLICABLE',	'Q35 What is that language?')
, (	54121,	68,	'help',	'1',	'Yes',	'Q36 Did someone help you complete this survey? (mail only)')
, (	54121,	68,	'help',	'2',	'No',	'Q36 Did someone help you complete this survey? (mail only)')
, (	54121,	68,	'help',	'M',	'MISSING/DK',	'Q36 Did someone help you complete this survey? (mail only)')
, (	54121,	68,	'help',	'X',	'NOT APPLICABLE',	'Q36 Did someone help you complete this survey? (mail only)')
, (	54122,	69,	'helpread',	'1',	'Read the questions to me',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	69,	'helpread',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	69,	'helpread',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	70,	'helpwrote',	'2',	'Wrote down the answers I gave',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	70,	'helpwrote',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	70,	'helpwrote',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	71,	'helpanswer',	'3',	'Answered the questions for me',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	71,	'helpanswer',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	71,	'helpanswer',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	72,	'helptranslate',	'4',	'Translated the questions into my language',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	72,	'helptranslate',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	72,	'helptranslate',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	73,	'helpother',	'5',	'Helped in some other way',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	73,	'helpother',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	73,	'helpother',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	74,	'helpnone',	'6',	'No one helped me complete this survey',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	74,	'helpnone',	'M',	'MISSING/DK',	'Q37 How did that person help you? Check all that apply. (mail only)')
, (	54122,	74,	'helpnone',	'X',	'NOT APPLICABLE',	'Q37 How did that person help you? Check all that apply. (mail only)')


declare @DPid int, @DCid int
insert into cem.DispositionProcess (RecodeValue, DispositionActionID) values (' ',1)
set @DPid=SCOPE_IDENTITY()

select @ETCid=ExportTemplateColumnID
from CEM.ExportTemplateColumn  etc
where etc.ExportTemplateSectionID=@ETSid
and ExportColumnName='finalstatus'

insert into cem.DispositionClause (DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID)
values (@DPid, 1, @ETCid, 12) -- 12=Not In
set @DCid=SCOPE_IDENTITY()

insert into cem.DispositionInList (DispositionClauseID, ListValue) values (@DCid, '110'), (@DCid, '120'), (@DCid, '310')


insert into cem.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
select 'patientresponse' as ExportTemplateSectionName,
	@ETid as ExportTemplateID,
	NULL as DefaultNamingConvention
set @ETSid=SCOPE_IDENTITY()

insert into cem.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies)
select @ETSid
	, left(min(qstnlabel),200) as ExportTemplateColumnDescription
	, min(intorder) as ColumnOrder
	, 2 as DataSourceID
	, min(case when qstncore in (54117, 54122, 54181, 54182, 54183) then null else ExportTemplateColumnDescription end) as ExportColumnName
	, 'MasterQuestionCore='+convert(varchar,qstncore) as SourceColumnName
	, 56 as SourceColumnType
	, NULL as AggregateFunction
	, @DPid as DispositionProcessID
	, case qstncore 
		when 54108 then 2 
		when 54117 then 14
		when 54122 then 6
		when 54181 then 6
		when 54182 then 8
		when 54183 then 5	
		else 1 end as FixedWidthLength
	, null as ColumnSetKey
	, null as FormatID
	, .95 as MissingThresholdPercentage
	, 0 as CheckFrequencies
from #OAS
group by qstncore
order by 3

update oas
set ETCid=ExportTemplateColumnID
from #OAS oas
inner join cem.ExportTemplateColumn etc on 'MasterQuestionCore='+convert(varchar,qstncore)=SourceColumnName and etc.ExportTemplateSectionID=@ETSid

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select ETCid
	, case when ltrim(val) between '0' and '999' then val else null end as RawValue
	, case when qstncore in (54117, 54122, 54181, 54182, 54183) then ExportTemplateColumnDescription end as ExportColumnName
	, case when qstncore in (54117, 54122, 54181, 54182, 54183) then '1' else val end as RecodeValue 
	, ResponseLabel
from #OAS
where ltrim(val) between '0' and '999'
union 
select distinct ETCid, -9, 'unmarked', 'M', 'unmarked'
from #oas
where qstncore in (54117, 54122, 54181, 54182, 54183) 
order by 1,4

go
if exists (select * from sys.procedures where schema_name(schema_id)='CEM' and name = 'ExportPostProcess00000014')
	drop procedure CEM.ExportPostProcess00000014
go
create procedure CEM.ExportPostProcess00000014
@ExportQueueID int
as
begin
	-- patientsserved Unknown/Missing=M
	update CEM.ExportDataset00000014 
	set [header.patientsserved] = 'M'
	where [header.patientsserved] = ''
	and ExportQueueID = @ExportQueueID
	
	-- if a patient's sex doesn't fall into the gender binary or is missing, isMale will equal '0' but the patient's sex isn't Female. 
	-- check qualisys's study-owned population tables to see if all isMale='0' have SEX='F'. If not, recode patientgender to out-of-range 
	create table #sexcheck (samplepopulationid int, patientgender char(1), isMale bit, SurveyID int, Survey_id int, Study_id int, Samplepop_id int, Pop_id int, sex varchar(42))

	insert into #sexcheck (samplepopulationid, patientgender, ismale, surveyid)
	select sp.samplepopulationid, eds.[administration.patientgender], sp.ismale, su.surveyID
	from CEM.ExportDataset00000014 eds
	inner join NRC_Datamart.dbo.samplepopulation sp on sp.samplepopulationid=eds.samplepopulationid
	inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
	inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
	inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
	where eds.ExportQueueID=@ExportQueueID
	order by 1

	update sc set survey_id=css.survey_id, study_id=css.study_id
	from #sexcheck sc
	inner join nrc_datamart.etl.DataSourceKey dsk on sc.surveyid=dsk.DataSourceKeyID
	inner join qualisys.qp_prod.dbo.clientstudysurvey_view css on dsk.DataSourceKey = css.survey_id

	update sc set samplepop_id=dsk.DataSourceKey, pop_id=sp.pop_id
	from #sexcheck sc
	inner join nrc_datamart.etl.DataSourceKey dsk on sc.samplepopulationid=dsk.DataSourceKeyID
	inner join qualisys.qp_prod.dbo.samplepop sp on dsk.DataSourceKey = sp.samplepop_id

	declare @sql varchar(max), @study varchar(10)
	select top 1 @study=study_id from #sexcheck where sex is null
	while @@rowcount>0
	begin
		set @sql = 'update sc set sex=p.sex from #sexcheck sc inner join qualisys.qp_prod.s'+@study+'.population p on sc.study_id='+@study+' and sc.pop_id=p.pop_id'
		exec (@sql)
		update #sexcheck set sex='?' where sex is null and study_id=@study
		select top 1 @study=study_id from #sexcheck where sex is null
	end

	update #sexcheck set patientgender=char(7) where isMale=0 and sex <> 'F'
	update #sexcheck set patientgender='X' where sex is null
	
	update eds
	set [administration.patientgender]=sc.patientgender
	from CEM.ExportDataset00000014 eds
	inner join #sexcheck sc on sc.samplepopulationid=eds.samplepopulationid
	where [administration.patientgender]<>sc.patientgender


	-- administration.SurgicalCat coding
	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = NULL 
	WHERE  exportqueueid = @ExportQueueID 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '1' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '40000' AND '49999' 
				  OR [administration.cpt4_2] BETWEEN '40000' AND '49999' 
				  OR [administration.cpt4_3] BETWEEN '40000' AND '49999' 
				  OR [administration.hcpcslvl2cd] IN ( 'G0105', 'G0121', 'G0104' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( 'G0105', 'G0121', 'G0104' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( 'G0105', 'G0121', 'G0104' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '2' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '20000' AND '29999' 
				  OR [administration.cpt4_2] BETWEEN '20000' AND '29999' 
				  OR [administration.cpt4_3] BETWEEN '20000' AND '29999' 
				  OR [administration.hcpcslvl2cd] IN ( 'G0260' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( 'G0260' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( 'G0260' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '3' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '65000' AND '68899' 
				  OR [administration.cpt4_2] BETWEEN '65000' AND '68899' 
				  OR [administration.cpt4_3] BETWEEN '65000' AND '68899' ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '4' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
	
	-- administration.LagTime
	-- The number of calendar days between the date of eligible surgery/procedure and the date when this patient’s survey was initiated.
	update eds 
	set [administration.firstmailed]=convert(varchar,firstmailed,112)
	from CEM.ExportDataset00000014 eds
	inner join (select sc.samplepopulationid, min(datMailed) as firstMailed 
				from #sexcheck sc
				inner join qualisys.qp_prod.dbo.scheduledmailing scm on sc.samplepop_id=scm.samplepop_id
				inner join qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
				group by sc.samplepopulationid) q
			on eds.samplepopulationid=q.samplepopulationid
	where datediff(day,firstmailed,[administration.firstmailed]) <> 0

	update CEM.ExportDataset00000014 
	set [administration.lagtime]=datediff(day,[administration.servicedate],[administration.firstmailed])
	WHERE exportqueueid = @ExportQueueID 
	
	/*
	--Skip Pattern Coding
	--•	Keep all responses to follow-up questions, even if they should have been skipped
	--•	If the response to the screener question invokes the skip, and a follow-up question is blank,			code the follow-up “X” (not applicable)
	--•	If the response to the screener question does not invoke the skip, and a follow-up question is blank,	code the follow-up “M” (missing)
	--•	If the screener question is blank and a follow-up question is also blank,								code the follow-up “M” (missing)
	*/
	--                               set this question                        to an X if the skip was invoked, otherwise to an M               if the question wasn't otherwise answered					  and the survey was returned in the applicable mode(s)
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaexplain]= case when [patientresponse.anesthesia]='2' then 'X' else 'M' end where [patientresponse.anesthesiaexplain] not in ('1','2','3') and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaside]	= case when [patientresponse.anesthesia]='2' then 'X' else 'M' end where [patientresponse.anesthesiaside] not in ('1','2','3')	  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.group]			= case when [patientresponse.ethnicity]	='2' then 'X' else 'M' end where [patientresponse.group] not in ('1','2','3','4')		  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.raceasianindian-phone]			= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.raceasianindian-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racechinese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racechinese-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racefilipino-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racefilipino-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racejapanese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racejapanese-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racekorean-phone]					= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racekorean-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racevietnamese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racevietnamese-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherasian-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.raceotherasian-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofaboveasianindian-phone]	= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racenoneofaboveasianindian-phone]<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.racenativehawaiian-phone]		 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racenativehawaiian-phone]		<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceguamanianchamorro-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.raceguamanianchamorro-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racesamoan-phone]				 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racesamoan-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherpacificislander-phone]= case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.raceotherpacificislander-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofabovepacific-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racenoneofabovepacific-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.speakotherspecify]= case when [patientresponse.speakother]='2' then 'X' else 'M' end where [patientresponse.speakotherspecify] not in ('1','2')	  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.helpread]			= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpread] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpwrote]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpwrote] <>'1' 						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpanswer]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpanswer] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helptranslate]	= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helptranslate] <>'1'					  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpother]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpother] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpnone]			= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpnone] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID

	
	-- some questions are only fielded on mail the survey. code them "Not Applicable" for phone returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-mail]='X',
		[patientresponse.raceafricanamer-mail]='X',
		[patientresponse.raceamerindian-mail]='X',
		[patientresponse.raceasianindian-mail]='X',
		[patientresponse.racechinese-mail]='X',
		[patientresponse.racefilipino-mail]='X',
		[patientresponse.racejapanese-mail]='X',
		[patientresponse.racekorean-mail]='X',
		[patientresponse.racevietnamese-mail]='X',
		[patientresponse.raceotherasian-mail]='X',
		[patientresponse.racenativehawaiian-mail]='X',
		[patientresponse.raceguamanianchamorro-mail]='X',
		[patientresponse.racesamoan-mail]='X',
		[patientresponse.raceotherpacificislander-mail]='X',
		[patientresponse.help]='X',
		[patientresponse.helpread]='X',
		[patientresponse.helpwrote]='X',
		[patientresponse.helpanswer]='X',
		[patientresponse.helptranslate]='X',
		[patientresponse.helpother]='X',
		[patientresponse.helpnone]='X'
	where [administration.finalstatus] IN ('110','120','310')
	and [administration.surveymode]='2'
	and ExportQueueID=@ExportQueueID

	-- some questions are only fielded on the phone survey. code them "Not Applicable" for mail returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-phone]='X',
		[patientresponse.raceafricanamer-phone]='X',
		[patientresponse.raceamerindian-phone]='X',
		[patientresponse.raceasian-phone]='X',
		[patientresponse.racenativehawaiianpacificislander-phone]='X',
		[patientresponse.racenoneofabove-phone]='X',
		[patientresponse.raceasianindian-phone]='X',
		[patientresponse.racechinese-phone]='X',
		[patientresponse.racefilipino-phone]='X',
		[patientresponse.racejapanese-phone]='X',
		[patientresponse.racekorean-phone]='X',
		[patientresponse.racevietnamese-phone]='X',
		[patientresponse.raceotherasian-phone]='X',
		[patientresponse.racenoneofaboveasianindian-phone]='X',
		[patientresponse.racenativehawaiian-phone]='X',
		[patientresponse.raceguamanianchamorro-phone]='X',
		[patientresponse.racesamoan-phone]='X',
		[patientresponse.raceotherpacificislander-phone]='X',
		[patientresponse.racenoneofabovepacific-phone]='X'
	where [administration.finalstatus] IN ('110','120','310')
	and [administration.surveymode]='1'
	and ExportQueueID=@ExportQueueID

	-- if a respondent returned the survey but didn't answer a multiple response question at all and all responses are still blank, code all responses to 'M'
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, [ExportColumnName.MR], isnull(RawValue,'') as RawValue, RecodeValue, FixedWidthLength
	into #unansweredMR
	from cem.ExportTemplate_view
	where exportTemplateId=14
	and [ExportColumnName.MR] is not null 

	declare @sqlwhere varchar(max)	
	declare @etcID int
	select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	while @@rowcount>0
	begin
		set @sql='update CEM.ExportDataset00000014 set '
		set @SQLwhere = 'ExportQueueID='+convert(varchar,@ExportQueueID)+' and [administration.finalstatus] IN (''110'',''120'',''310'') and len('
		select @sql = @sql + '['+ExportTemplateSectionName+'.'+[ExportColumnName.MR]+']=''M'','
			, @sqlwhere=@sqlwhere + '['+ExportTemplateSectionName+'.'+[ExportColumnName.MR]+']+'
		from #unansweredMR
		where ExportTemplateColumnID = @etcID
		and [ExportColumnName.MR] <> 'unmarked'

		set @sqlwhere = left(@sqlwhere,len(@sqlwhere)-1) + ')=0'
		set @sql = left(@sql,len(@sql)-1) + ' where ' + @sqlwhere + char(10)
		
		print @SQL
		if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
		exec (@SQL)
		
		delete from #unansweredMR where ExportTemplateColumnID = @etcID
		select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	end

	drop table #unansweredMR
	
end
go