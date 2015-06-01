/*
	S26.US11	ICHCAHPS submission file changes
		as an authorized ICHCAHPS vendor, we must remove records from the submission file that were sampled in error


	T11.3	create new template to match current specs

Dave Gilsdorf

NRC_DataMart_Extracts:
INSERT INTO CEM.ExportTemplate 
INSERT INTO CEM.ExportTemplateSection 
INSERT INTO CEM.ExportTemplateColumn 
INSERT INTO CEM.ExportTemplateColumnResponse 
INSERT INTO CEM.DispositionProcess 
INSERT INTO CEM.DispositionClause 
INSERT INTO CEM.DispositionInList 
CREATE PROCEDURE [CEM].[ExportPostProcess00000002]

*/

select *, 0 as [newID] 
into #ET 
from cem.ExportTemplate 
where ExportTemplateID=1

select *, 0 as [newID] 
into #ETS 
from cem.ExportTemplateSection 
where ExportTemplateID=1

select *, 0 as [newID] 
into #ETDR 
from cem.ExportTemplateDefaultResponse 
where ExportTemplateID=1

select etc.*, 0 as [newID] 
into #ETC
from cem.ExportTemplateColumn etc 
where ExportTemplateSectionID in (select ExportTemplateSectionID from #ETS)

select etcr.*, 0 as [newID] 
into #ETCR
from cem.ExportTemplateColumnResponse etcr
where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

select *, 0 as [newID]
into #DC
from cem.dispositionclause 
where ExportTemplateColumnID in (select ExportTemplateColumnID from #ETC)

select *, 0 as [newID]
into #DP
from cem.dispositionprocess 
where DispositionProcessID in (select DispositionProcessID from #DC)

select *, 0 as [newID]
into #DIL 
from cem.dispositioninlist
where dispositioninlistID in (select dispositioninlistID from #DP)

update #ETC set ExportTemplateColumnDescription='Q57' where SourceColumnName='MasterQuestionCore=51203' -- language-spoken
update #ETC set ExportTemplateColumnDescription='Q58-phone' where SourceColumnName='MasterQuestionCore=51261' -- not-hispanic-phone
update #ETC set ExportTemplateColumnDescription='Q58a-phone' where SourceColumnName='MasterQuestionCore=51262' -- hispanic-phone
update #ETC set ExportTemplateColumnDescription='Q58-mail' where SourceColumnName='MasterQuestionCore=51204' -- not-hispanic-mail
update #ETC set ExportTemplateColumnDescription='Q59-phone' where SourceColumnName='MasterQuestionCore=51263' -- race-*-phone
update #ETC set ExportTemplateColumnDescription='Q59a-phone' where SourceColumnName='MasterQuestionCore=51264' -- race-asian-*-phone
update #ETC set ExportTemplateColumnDescription='Q59b-phone' where SourceColumnName='MasterQuestionCore=51265' -- race-pacific-*-phone
update #ETC set ExportTemplateColumnDescription='Q59-mail' where SourceColumnName='MasterQuestionCore=51205' -- race-mail
update #ETC set ExportTemplateColumnDescription='Q60' where SourceColumnName='MasterQuestionCore=47212' -- help-you
update #ETC set ExportTemplateColumnDescription='Q61' where SourceColumnName='MasterQuestionCore=47213' -- who-helped
update #ETC set ExportTemplateColumnDescription='Q62' where SourceColumnName='MasterQuestionCore=47214' -- how-helped


---- DOCUMENTED SUBMISSION FILE CHANGES - SPRING 2015 ----


-- update ExportTemplate with new values, provided by CMS
UPDATE #ET SET ValidStartDate='1/1/15', ValidEndDate='6/30/15', ExportTemplateVersionMajor='3.0', createdon=getdate(), XMLSchemaDefinition='<?xml version="1.0" encoding="UTF-8"?>
<xs:schema id="perioddata" targetNamespace="http://ichcahps.org" xmlns:mstns="http://ichcahps.org" xmlns="http://ichcahps.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" attributeFormDefault="qualified" elementFormDefault="qualified">

  <xs:element name="perioddata" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">

    <xs:complexType>
      <xs:sequence>

        <xs:element name="header" minOccurs="1" maxOccurs="1">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="facility-name" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:minLength value="1"/><xs:maxLength value="100"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="facility-id" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]{6}"/><xs:minLength value="1"/><xs:maxLength value="6"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="sem-survey" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="2"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="survey-yr" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="2014"/><xs:maxInclusive value="9998"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="survey-mode" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="3"/></xs:restriction></xs:simpleType></xs:element>
              <xs:element name="number-sampled" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="999"/></xs:restriction></xs:simpleType></xs:element>
			  <xs:element name="dcstart-date" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="20140101"/><xs:maxInclusive value="88888888"/></xs:restriction></xs:simpleType></xs:element>
			  <xs:element name="dcend-date" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="20140101"/><xs:maxInclusive value="88888888"/></xs:restriction></xs:simpleType></xs:element>
			  </xs:sequence>
          </xs:complexType>
        </xs:element>

        <xs:element name="patientleveldata" minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="administration" minOccurs="1" maxOccurs="1">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="facility-id" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]{6}"/><xs:minLength value="1"/><xs:maxLength value="6"/></xs:restriction></xs:simpleType></xs:element>
					<xs:element name="sem-survey" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="1"/><xs:maxInclusive value="2"/></xs:restriction></xs:simpleType></xs:element>
					<xs:element name="survey-yr" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="2014"/><xs:maxInclusive value="9998"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="sample-id" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:minLength value="1"/><xs:maxLength value="10"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="final-status" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:pattern value="110|120|130|140|150|160|170|180|190|199|210|220|230|240|250"/></xs:restriction></xs:simpleType></xs:element>
					<xs:element name="date-completed" minOccurs="1"><xs:simpleType><xs:restriction base="xs:integer"><xs:minInclusive value="20140101"/><xs:maxInclusive value="88888888"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="language" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-6]|[xX]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="survey-mode" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xX]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>

              <xs:element name="patientresponse" minOccurs="0" maxOccurs="1">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element name="where-dialysis" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[123mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="how-long-care" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-listen" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-explain" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-respect" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-time" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-care" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rate-dr" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]|10|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="dr-informed" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="staff-listen" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="staff-explain" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="staff-respect" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="staff-time" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="staff-care" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="make-comfortable" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="info-private" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="ask-staff" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="ask-affects" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="take-care" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="connect-machine" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="little-pain" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="check-closely" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="problems" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="manage-problems" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="behave-professionally" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="talk-about-eat" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="explain-bloodtest" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="your-rights" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="review-rights" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="what-dohome" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="getoff-machine" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rate-staff" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]|10|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="onmachine-15min" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="center-clean" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rate-center" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[0-9]|10|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="talk-treatment" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="eligible-transplant" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-3]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="explain-ineligible" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="talk-peritoneal" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="choose-treatment" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="unhappy-care" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="talk-withstaff" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="satisfied-problems" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="make-complaint" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="overall-health" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="mental-health" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="high-bloodpressure" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="diabetes" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="heart-disease" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="deaf" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="blind" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="difficulty-concentrating" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="difficulty-walking" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="difficulty-dressing" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="difficulty-errands" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="education" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-8]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="language-spoken" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-8]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="not-hispanic-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="hispanic-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="not-hispanic-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-5]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-white-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-african-amer-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-amer-indian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-asian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-nativehawaiian-pacific-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-noneofabove-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-asian-indian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-chinese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-filipino-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-japanese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-korean-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-vietnamese-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-otherasian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-noneofabove-asian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-nativehawaiian-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-guam-chamarro-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-samoan-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-otherpacificislander-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-noneofabove-pacific-phone" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-white-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-african-amer-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-amer-indian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-asian-indian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-chinese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-filipino-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-japanese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-korean-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-vietnamese-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-otherasian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-nativehawaiian-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-guamanian-chamorro-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-samoan-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="race-other-pacificislander-mail" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-you" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="who-helped" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-read" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-wrote" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-answer" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-translate" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="help-other" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                  </xs:sequence>
                </xs:complexType>

              </xs:element>

            </xs:sequence>
          </xs:complexType>

        </xs:element>

      </xs:sequence>
    </xs:complexType>

    <xs:unique name="patient-id_constraint" msdata:ConstraintName="Constraint1">
      <xs:selector xpath=".//mstns:administration" />
      <xs:field xpath="mstns:sample-id" />
    </xs:unique>

  </xs:element>

</xs:schema>'

-- Removed <age> element (was Q56)
-- Removed <sex> element (was Q57)
-- Removed <speak-english> element (was Q59)
-- Removed <speak-other-language> element (was Q60)
delete from #etcr where ExportTemplateColumnID in (select ExportTemplateColumnID from #etc where exportcolumnname in ('age','sex','speak-english','speak-other-language'))
delete from #etc where exportcolumnname in ('age','sex','speak-english','speak-other-language')


-- <language>: removed “M” as a valid value.
delete from #etcr 
where ExportTemplateColumnID in (select ExportTemplateColumnID from #etc where exportcolumnname in ('language'))
and RecodeValue='M'


-- Changed <language-spoken> element (was Q60a, now Q57). Valid values have changed.
declare @etcid int
select @etcid=ExportTemplateColumnID 
from #ETC
where exportcolumnname = 'language-spoken'

delete
from #ETCR
where ExportTemplateColumnID = @etcid

insert into #ETCR (ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel,[newid])
values (@etcid, 1, NULL, '1', 'English',0)
	,  (@etcid, 2, NULL, '2', 'Spanish',0)
	,  (@etcid, 3, NULL, '3', 'Chinese',0)
	,  (@etcid, 4, NULL, '4', 'Samoan',0)
	,  (@etcid, 5, NULL, '5', 'Russian',0)
	,  (@etcid, 6, NULL, '6', 'Vietnamese',0)
	,  (@etcid, 7, NULL, '7', 'Portuguese',0)
	,  (@etcid, 8, NULL, '8', 'Some other language',0)
	,  (@etcid, -9, NULL, 'X', 'NOT APPLICABLE',0)
	--,(@etcid, 'M', NULL, 'M', 'MISSING/DK') --> taken care of in the post-process proc


-- Added “X” as a valid value for <race-noneofabove-phone>

-- TODO: when would race-noneofabove-phone be set to 'X' (not applicable)?
-- would this be done in the post-processing proc?

select *
from #etc 
where exporttemplatecolumnid=81

select *
from #ETCR
where exporttemplatecolumnid=81

---- Create the disposition process that deletes any records with final-status=999 ('CMS Removal') ----
declare @dpid int
insert into #DP (DispositionActionID,[newid]) values (2,0)
set @dpid=scope_identity()

insert into #dc (DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue,[newID])
select @dpid, 1, ExportTemplateColumnID, OperatorID, 999, null, 0 
from #etc, cem.operator
where exportcolumnname='final-status'
and strOperator = '='

-- assign the new disposition process to a column (doesn't matter which column -- we're deleting the entire record, not recoding a specific column -- it just needs to be one that doesn't already have a disposition process)
update #etc set DispositionProcessId=@dpid where DispositionProcessId is NULL and exportColumnName='sample-id'


---- INSERT THE MODIFIED TEMPLATE INTO THE TABLES ----

begin tran
declare @newID int

INSERT INTO CEM.ExportTemplate (ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType)
select ExportTemplateName, SurveyTypeID, SurveySubTypeID, ValidDateColumnID, ValidStartDate, ValidEndDate, ExportTemplateVersionMajor, ExportTemplateVersionMinor, CreatedBy, CreatedOn, ClientID, DefaultNotificationID, DefaultNamingConvention, State, ReturnsOnly, SampleUnitCahpsTypeID, XMLSchemaDefinition, isOfficial, DefaultFileMakerType
from #ET

set @newID = SCOPE_IDENTITY()
update #ET set [newID]=@newID
update #ETS set ExportTemplateID=@newID
update #ETDR set ExportTemplateID=@newID

declare @oldID int
select top 1 @oldID=ExportTemplateSectionID from #ETS where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateSection (ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention)
	select ExportTemplateSectionName,ExportTemplateID,DefaultNamingConvention
	from #ETS
	where ExportTemplateSectionID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ETC set ExportTemplateSectionID=@newID where ExportTemplateSectionID=@oldID
	update #ETS set [newid]=@newID where ExportTemplateSectionID=@oldID
	
	select top 1 @oldID=ExportTemplateSectionID from #ETS where [newid]=0
end

select top 1 @oldID=ExportTemplateColumnID from #ETC where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateColumn (ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies)
	select ExportTemplateSectionID, ExportTemplateColumnDescription, ColumnOrder, DatasourceID, ExportColumnName, SourceColumnName, SourceColumnType, AggregateFunction, DispositionProcessID, FixedWidthLength, ColumnSetKey, FormatID, MissingThresholdPercentage, CheckFrequencies
	from #ETC
	where ExportTemplateColumnID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ET set ValidDateColumnID=@newID where ValidDateColumnID=@oldID
	if @@rowcount>0
		update cem.ExportTemplate set ValidDateColumnID=@newID where ValidDateColumnID=@oldID and ExportTemplateId>1
	update #DC set ExportTemplateColumnID=@newID where ExportTemplateColumnID=@oldID
	update #ETCR set ExportTemplateColumnID=@newID where ExportTemplateColumnID=@oldID
	update #ETC set [newid]=@newID where ExportTemplateColumnID=@oldID
	
	select top 1 @oldID=ExportTemplateColumnID from #ETC where [newid]=0
end

select top 1 @oldID=ExportTemplateColumnResponseID from #ETCR where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.ExportTemplateColumnResponse (ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel)
	select ExportTemplateColumnID,RawValue,ExportColumnName,RecodeValue,ResponseLabel
	from #ETCR
	where ExportTemplateColumnResponseID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #ETCR set [newid]=@newID where ExportTemplateColumnResponseID=@oldID
	
	select top 1 @oldID=ExportTemplateColumnResponseID from #ETCR where [newid]=0
end

select top 1 @oldID=DispositionProcessID from #DP where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionProcess (RecodeValue,ExportErrorID,DispositionActionID)
	select RecodeValue,ExportErrorID,DispositionActionID
	from #DP
	where DispositionProcessID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DC set DispositionProcessID=@newID where DispositionProcessID=@oldID
	update #ETC set DispositionProcessID=@newID where DispositionProcessID=@oldID
	update #DP set [newid]=@newID where DispositionProcessID=@oldID
	
	select top 1 @oldID=DispositionProcessID from #DP where [newid]=0
end

update p set DispositionProcessID=t.DispositionProcessID
from #ETC t
inner join CEM.ExportTemplateColumn p on t.[newID]=p.ExportTemplateColumnID
where t.DispositionProcessID<>p.DispositionProcessID

select top 1 @oldID=DispositionClauseID from #DC where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionClause (DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue)
	select DispositionProcessID,DispositionPhraseKey,ExportTemplateColumnID,OperatorID,LowValue,HighValue
	from #DC
	where DispositionClauseID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DIL set DispositionClauseID=@newID where DispositionClauseID=@oldID
	update #DC set [newid]=@newID where DispositionClauseID=@oldID
	
	select top 1 @oldID=DispositionClauseID from #DC where [newid]=0
end

select top 1 @oldID=DispositionInListID from #DIL where [newid]=0
while @@rowcount>0
begin
	INSERT INTO CEM.DispositionInList (DispositionClauseID,ListValue)
	select DispositionClauseID,ListValue
	from #DIL
	where DispositionInListID=@oldID

	set @newID = SCOPE_IDENTITY()
	
	update #DIL set [newid]=@newID where DispositionInListID=@oldID
	
	select top 1 @oldID=DispositionInListID from #DIL where [newid]=0
end

commit tran

DROP TABLE #ET
DROP TABLE #ETS
DROP TABLE #ETDR
DROP TABLE #ETC 
DROP TABLE #ETCR
DROP TABLE #DP
DROP TABLE #DC
DROP TABLE #DIL


---- MAKE A COPY OF THE POST-PROCESS PROC ----

USE [NRC_DataMart_Extracts]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CEM].[ExportPostProcess00000002]
@ExportQueueID int
as
update CEM.ExportDataset00000002
set [patientresponse.race-white-phone]='M', [patientresponse.race-african-amer-phone]='M', [patientresponse.race-amer-indian-phone]='M', [patientresponse.race-asian-phone]='M', 
	[patientresponse.race-nativehawaiian-pacific-phone]='M', [patientresponse.race-noneofabove-phone]='M' 
where len([patientresponse.race-white-phone]+[patientresponse.race-african-amer-phone]+[patientresponse.race-amer-indian-phone]+[patientresponse.race-asian-phone]
	+[patientresponse.race-nativehawaiian-pacific-phone]+[patientresponse.race-noneofabove-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-asian-indian-phone]='M', [patientresponse.race-chinese-phone]='M', [patientresponse.race-filipino-phone]='M', [patientresponse.race-japanese-phone]='M', 
	[patientresponse.race-korean-phone]='M', [patientresponse.race-vietnamese-phone]='M', [patientresponse.race-otherasian-phone]='M', [patientresponse.race-noneofabove-asian-phone]='M'
where len([patientresponse.race-asian-indian-phone]+[patientresponse.race-chinese-phone]+[patientresponse.race-filipino-phone]+[patientresponse.race-japanese-phone]
	+[patientresponse.race-korean-phone]+[patientresponse.race-vietnamese-phone]+[patientresponse.race-otherasian-phone]+[patientresponse.race-noneofabove-asian-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-nativehawaiian-phone]='M', [patientresponse.race-guam-chamarro-phone]='M', [patientresponse.race-samoan-phone]='M', [patientresponse.race-otherpacificislander-phone]='M',
	[patientresponse.race-noneofabove-pacific-phone]='M'
where len([patientresponse.race-nativehawaiian-phone]+[patientresponse.race-guam-chamarro-phone]+[patientresponse.race-samoan-phone]+[patientresponse.race-otherpacificislander-phone]
	+[patientresponse.race-noneofabove-pacific-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-white-mail]='M', [patientresponse.race-african-amer-mail]='M', [patientresponse.race-amer-indian-mail]='M', [patientresponse.race-asian-indian-mail]='M', 
	[patientresponse.race-chinese-mail]='M', [patientresponse.race-filipino-mail]='M', [patientresponse.race-japanese-mail]='M', [patientresponse.race-korean-mail]='M', 
	[patientresponse.race-vietnamese-mail]='M', [patientresponse.race-otherasian-mail]='M', [patientresponse.race-nativehawaiian-mail]='M', [patientresponse.race-guamanian-chamorro-mail]='M', 
	[patientresponse.race-samoan-mail]='M', [patientresponse.race-other-pacificislander-mail]='M'
where len([patientresponse.race-white-mail]+[patientresponse.race-african-amer-mail]+[patientresponse.race-amer-indian-mail]+[patientresponse.race-asian-indian-mail]
	+[patientresponse.race-chinese-mail]+[patientresponse.race-filipino-mail]+[patientresponse.race-japanese-mail]+[patientresponse.race-korean-mail]+[patientresponse.race-vietnamese-mail]
	+[patientresponse.race-otherasian-mail]+[patientresponse.race-nativehawaiian-mail]+[patientresponse.race-guamanian-chamorro-mail]+[patientresponse.race-samoan-mail]
	+[patientresponse.race-other-pacificislander-mail])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.help-answer]='M', [patientresponse.help-other]='M', [patientresponse.help-read]='M', [patientresponse.help-translate]='M', [patientresponse.help-wrote]='M'
where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [header.dcstart-date]='20150324'
where [header.dcstart-date]=''
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [header.dcend-date]='20150714'
where [header.dcend-date]=''
and ExportQueueID=@ExportQueueID
GO
