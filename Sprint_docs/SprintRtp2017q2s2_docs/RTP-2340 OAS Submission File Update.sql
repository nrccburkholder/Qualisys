use nrc_datamart_extracts

--select * from cem.ExportTemplate where exporttemplatename = 'oas cahps'
--select * from cem.ExportTemplate_view where exporttemplatename = 'oas cahps' and ExportColumnName in ('patientsserved','patientsfile','eligiblepatients','sampledpatients')

if not exists (select * from cem.ExportTemplate where exporttemplatename = 'oas cahps' and ExportTemplateVersionMajor='2017Q2' and ExportTemplateVersionMinor=1)
begin
	exec cem.CopyExportTemplate 14

	declare @newID int
	select @newID = max(exporttemplateid) from cem.ExportTemplate

	update cem.ExportTemplate
	set ExportTemplateVersionMajor='2017Q2', ExportTemplateVersionMinor=1, ValidStartDate='4/1/2017', ValidEndDate='12/31/2222', CreatedBy='NRC\dgilsdorf', CreatedOn=getdate()
		, XMLSchemaDefinition='<xs:schema xmlns:mstns="http://oascahps.org" xmlns="http://oascahps.org" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:msdata="urn:schemas-microsoft-com:xml-msdata" id="monthlydata" targetNamespace="http://oascahps.org" attributeFormDefault="qualified" elementFormDefault="qualified">
    <xs:element name="monthlydata" msdata:IsDataSet="true" msdata:UseCurrentLocale="true">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="header" minOccurs="1" maxOccurs="1">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="headertype" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="1" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="providername" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:minLength value="1" />
                                        <xs:maxLength value="100" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="providernum" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:pattern value="[0-9A-Za-z]{6,10}" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="samplemonth" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="12" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="sampleyear" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="2016" />
                                        <xs:maxInclusive value="9998" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="surveymode" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="3" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="sampletype" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="4" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="patientsserved" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:string">
                                        <xs:pattern value="[1-9][0-9]{0,5}|[mM]" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="patientsfile" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="999999" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="eligiblepatients" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="999999" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                            <xs:element name="sampledpatients" minOccurs="1">
                                <xs:simpleType>
                                    <xs:restriction base="xs:integer">
                                        <xs:minInclusive value="1" />
                                        <xs:maxInclusive value="999999" />
                                    </xs:restriction>
                                </xs:simpleType>
                            </xs:element>
                        </xs:sequence>
                    </xs:complexType>
                </xs:element>
                <xs:element name="patientleveldata" minOccurs="0" maxOccurs="unbounded">
                    <xs:complexType>
                        <xs:sequence>
                            <xs:element name="administration" minOccurs="1" maxOccurs="1">
                                <xs:complexType>
                                    <xs:sequence>
                                        <xs:element name="providernum" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[0-9A-Za-z]{6,10}" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="samplemonth" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:integer">
                                                    <xs:minInclusive value="1" />
                                                    <xs:maxInclusive value="12" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="sampleyear" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:integer">
                                                    <xs:minInclusive value="2016" />
                                                    <xs:maxInclusive value="9998" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="sampleid" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:minLength value="1" />
                                                    <xs:maxLength value="16" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="surgicalcat" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:integer">
                                                    <xs:minInclusive value="1" />
                                                    <xs:maxInclusive value="5" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="patientage" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-9]|1[0-5]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="patientgender" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="surveymode" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[xX]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="lagtime" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[0-9]|[1-8][0-9]|90|[xX]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="finalstatus" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:integer">
                                                    <xs:pattern value="110|120|210|220|230|240|310|320|330|340|350" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="language" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[xX]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                    </xs:sequence>
                                </xs:complexType>
                            </xs:element>
                            <xs:element name="patientresponse" minOccurs="0" maxOccurs="1">
                                <xs:complexType>
                                    <xs:sequence>
                                        <xs:element name="informed" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="instructions" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="checkin" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="clean" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="clerkhelpful" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="clerkrespect" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="drrespect" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="drcomfort" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="drexplain" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="anesthesia" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="anesthesiaexplain" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="anesthesiaside" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="dischargeinstructions" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="recovery" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="paininfo" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="painresult" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="nausea" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="nausearesult" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="bleedinginstruction" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="bleedingresult" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="infectioninfo" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[123]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="infectionsigns" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="ratefacility" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="0?[0-9]|10|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="recommend" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-4]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="rateoverall" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-5]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="rateoverallmental" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-5]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="age" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-9]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="gender" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="education" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-6]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="ethnicity" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="group" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-4]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racewhite-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceafricanamer-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceamerindian-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceasianindian-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racechinese-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racefilipino-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racejapanese-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racekorean-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racevietnamese-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceotherasian-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenativehawaiian-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceguamanianchamorro-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racesamoan-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceotherpacificislander-mail" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racewhite-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceafricanamer-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceamerindian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceasian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenativehawaiianpacificislander-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenoneofabove-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceasianindian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racechinese-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racefilipino-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racejapanese-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racekorean-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racevietnamese-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceotherasian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenoneofaboveasianindian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenativehawaiian-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceguamanianchamorro-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racesamoan-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="raceotherpacificislander-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="racenoneofabovepacific-phone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="speakenglish" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1-4]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="speakother" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[mM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="speakotherspecify" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="help" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[12]|[xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helpread" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helpwrote" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helpanswer" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helptranslate" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helpother" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
                                        <xs:element name="helpnone" minOccurs="1">
                                            <xs:simpleType>
                                                <xs:restriction base="xs:string">
                                                    <xs:pattern value="[1xXmM]" />
                                                </xs:restriction>
                                            </xs:simpleType>
                                        </xs:element>
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
	where ExportTemplateID = @newID

	--Added valid value "5" (Missing) to Surgical Cat field. This should be assigned when all CPT & HCPCS fields are NULL.
	declare @surgCatCol int

	select @surgCatCol = ExportTemplateColumnID
	from cem.ExportTemplate_view 
	where exporttemplateid=@newID
	and ExportColumnName = 'surgicalcat' 
	--SELECT * FROM cem.ExportTemplateColumnResponse WHERE ExportTemplateColumnID=@surgCatCol

	insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, RecodeValue, ResponseLabel)
	values (@surgCatCol, 5, '5', 'Missing')

	--Count fields cannot be zero (Patients Served, Patients File, Eligible Patients, Sampled Patients). Minimum valid value for all is now 1. Process should throw an error if any of these fields are null.
	declare @sql varchar(max)
	set @sql = 'ALTER procedure [CEM].[ExportPostProcess00000014]
@ExportQueueID int
as
begin
	-- patientsserved Unknown/Missing=M
	update CEM.ExportDataset00000014 
	set [header.patientsserved] = ''M''
	where [header.patientsserved] = ''''
	and ExportQueueID = @ExportQueueID

	--Count fields cannot be zero (Patients Served, Patients File, Eligible Patients, Sampled Patients). Minimum valid value for all is now 1. Process should throw an error if any of these fields are null.
	update CEM.ExportDataset00000014 
	set [header.patientsserved] = CHAR(7)
	where [header.patientsserved] IN (''0'')
	and ExportQueueID = @ExportQueueID

	update CEM.ExportDataset00000014 
	set [header.patientsfile] = CHAR(7)
	where [header.patientsfile] IN (''0'', '''')
	and ExportQueueID = @ExportQueueID

	update CEM.ExportDataset00000014 
	set [header.eligiblepatients] = CHAR(7)
	where [header.eligiblepatients] IN (''0'', '''')
	and ExportQueueID = @ExportQueueID

	update CEM.ExportDataset00000014 
	set [header.sampledpatients] = CHAR(7)
	where [header.sampledpatients] IN (''0'', '''')
	and ExportQueueID = @ExportQueueID
	
	
	-- if a patient''s sex doesn''t fall into the gender binary or is missing, isMale will equal ''0'' but the patient''s sex isn''t Female. 
	-- check qualisys''s study-owned population tables to see if all isMale=''0'' have SEX=''F''. If not, recode patientgender to out-of-range 
	create table #sexcheck (samplepopulationid int, patientgender char(1), isMale bit, SurveyID int, Survey_id int, Study_id int, Samplepop_id int, Pop_id int, sex varchar(42))

	insert into #sexcheck (samplepopulationid, patientgender, ismale, surveyid)
	select distinct sp.samplepopulationid, eds.[administration.patientgender], sp.ismale, su.surveyID
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
		set @sql = ''update sc set sex=p.sex from #sexcheck sc inner join qualisys.qp_prod.s''+@study+''.population p on sc.study_id=''+@study+'' and sc.pop_id=p.pop_id''
		exec (@sql)
		update #sexcheck set sex=''?'' where sex is null and study_id=@study
		select top 1 @study=study_id from #sexcheck where sex is null
	end

	update #sexcheck set patientgender=''M'' where sex not in (''M'',''F'')
	update #sexcheck set patientgender=''X'' where sex is null
	update #sexcheck set patientgender=''1'' where sex=''M'' and patientgender<>''1''
	update #sexcheck set patientgender=''2'' where sex=''F'' and patientgender<>''2''
	
	update eds
	set [administration.patientgender]=sc.patientgender
	from CEM.ExportDataset00000014 eds
	inner join #sexcheck sc on sc.samplepopulationid=eds.samplepopulationid
	where [administration.patientgender]<>sc.patientgender
	and eds.ExportQueueID=@ExportQueueID
	
	-- administration.SurgicalCat coding
	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = NULL 
	WHERE  exportqueueid = @ExportQueueID 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = ''1'' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN ''40000'' AND ''49999'' 
				  OR [administration.cpt4_2] BETWEEN ''40000'' AND ''49999'' 
				  OR [administration.cpt4_3] BETWEEN ''40000'' AND ''49999'' 
				  OR [administration.hcpcslvl2cd] IN ( ''G0105'', ''G0121'', ''G0104'' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( ''G0105'', ''G0121'', ''G0104'' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( ''G0105'', ''G0121'', ''G0104'' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = ''2'' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN ''20000'' AND ''29999'' 
				  OR [administration.cpt4_2] BETWEEN ''20000'' AND ''29999'' 
				  OR [administration.cpt4_3] BETWEEN ''20000'' AND ''29999'' 
				  OR [administration.hcpcslvl2cd] IN ( ''G0260'' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( ''G0260'' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( ''G0260'' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = ''3'' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN ''65000'' AND ''68899'' 
				  OR [administration.cpt4_2] BETWEEN ''65000'' AND ''68899'' 
				  OR [administration.cpt4_3] BETWEEN ''65000'' AND ''68899'' ) 

	-- Surgical Cat field should be assigned "5" (Missing) when all CPT & HCPCS fields are NULL.
	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = ''5'' 
	WHERE  exportqueueid = @ExportQueueID 
	AND [administration.cpt4]+[administration.cpt4_2]+[administration.cpt4_3]+[administration.hcpcslvl2cd]+[administration.hcpcslvl2cd_2]+[administration.hcpcslvl2cd_3] = ''''

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = ''4'' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
	
	-- administration.LagTime
	-- The number of calendar days between the date of eligible surgery/procedure and the date when this patient''s survey was initiated.
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
	--*	Keep all responses to follow-up questions, even if they should have been skipped
	--*	If the response to the screener question invokes the skip, and a follow-up question is blank,			code the follow-up "X" (not applicable)
	--*	If the response to the screener question does not invoke the skip, and a follow-up question is blank,	code the follow-up "M" (missing)
	--*	If the screener question is blank and a follow-up question is also blank,								code the follow-up "M" (missing)
	*/
	--                               set this question                        to an X if the skip was invoked, otherwise to an M               if the question wasn''t otherwise answered					  and the survey was returned in the applicable mode(s)
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaexplain]= case when [patientresponse.anesthesia]=''2'' then ''X'' else ''M'' end where [patientresponse.anesthesiaexplain] not in (''1'',''2'',''3'') and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] in (''1'',''2'') and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaside]	= case when [patientresponse.anesthesia]=''2'' then ''X'' else ''M'' end where [patientresponse.anesthesiaside] not in (''1'',''2'',''3'')	  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] in (''1'',''2'') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.group]			= case when [patientresponse.ethnicity]	=''2'' then ''X'' else ''M'' end where [patientresponse.group] not in (''1'',''2'',''3'',''4'')		  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] in (''1'',''2'') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.raceasianindian-phone]			= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.raceasianindian-phone]			<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racechinese-phone]				= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racechinese-phone]				<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racefilipino-phone]				= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racefilipino-phone]				<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racejapanese-phone]				= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racejapanese-phone]				<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racekorean-phone]					= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racekorean-phone]				<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racevietnamese-phone]				= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racevietnamese-phone]			<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherasian-phone]				= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.raceotherasian-phone]			<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofaboveasianindian-phone]	= case when [patientresponse.raceasian-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racenoneofaboveasianindian-phone]<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.racenativehawaiian-phone]		 = case when [patientresponse.racenativehawaiianpacificislander-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racenativehawaiian-phone]		<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceguamanianchamorro-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.raceguamanianchamorro-phone]	<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racesamoan-phone]				 = case when [patientresponse.racenativehawaiianpacificislander-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racesamoan-phone]				<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherpacificislander-phone]= case when [patientresponse.racenativehawaiianpacificislander-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.raceotherpacificislander-phone]	<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofabovepacific-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]=''M'' then ''X'' else ''M'' end where [patientresponse.racenoneofabovepacific-phone]	<> ''1'' and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode]=''2'' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.speakotherspecify]= case when [patientresponse.speakother]=''2'' then ''X'' else ''M'' end where [patientresponse.speakotherspecify] not in (''1'',''2'')	  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] in (''1'',''2'') and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.helpread]			= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helpread] <>''1''						  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpwrote]		= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helpwrote] <>''1'' 						  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpanswer]		= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helpanswer] <>''1''						  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helptranslate]	= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helptranslate] <>''1''					  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpother]		= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helpother] <>''1''						  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpnone]			= case when [patientresponse.help]		=''2'' then ''X'' else ''M'' end where [patientresponse.helpnone] <>''1''						  and [administration.finalstatus] IN (''110'',''120'',''310'') and [administration.surveymode] =''1'' and ExportQueueID=@ExportQueueID

	
	-- some questions are only fielded on mail the survey. code them "Not Applicable" for phone returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-mail]=''X'',
		[patientresponse.raceafricanamer-mail]=''X'',
		[patientresponse.raceamerindian-mail]=''X'',
		[patientresponse.raceasianindian-mail]=''X'',
		[patientresponse.racechinese-mail]=''X'',
		[patientresponse.racefilipino-mail]=''X'',
		[patientresponse.racejapanese-mail]=''X'',
		[patientresponse.racekorean-mail]=''X'',
		[patientresponse.racevietnamese-mail]=''X'',
		[patientresponse.raceotherasian-mail]=''X'',
		[patientresponse.racenativehawaiian-mail]=''X'',
		[patientresponse.raceguamanianchamorro-mail]=''X'',
		[patientresponse.racesamoan-mail]=''X'',
		[patientresponse.raceotherpacificislander-mail]=''X'',
		[patientresponse.help]=''X'',
		[patientresponse.helpread]=''X'',
		[patientresponse.helpwrote]=''X'',
		[patientresponse.helpanswer]=''X'',
		[patientresponse.helptranslate]=''X'',
		[patientresponse.helpother]=''X'',
		[patientresponse.helpnone]=''X''
	where [administration.finalstatus] IN (''110'',''120'',''310'')
	and [administration.surveymode]=''2''
	and ExportQueueID=@ExportQueueID

	-- some questions are only fielded on the phone survey. code them "Not Applicable" for mail returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-phone]=''X'',
		[patientresponse.raceafricanamer-phone]=''X'',
		[patientresponse.raceamerindian-phone]=''X'',
		[patientresponse.raceasian-phone]=''X'',
		[patientresponse.racenativehawaiianpacificislander-phone]=''X'',
		[patientresponse.racenoneofabove-phone]=''X'',
		[patientresponse.raceasianindian-phone]=''X'',
		[patientresponse.racechinese-phone]=''X'',
		[patientresponse.racefilipino-phone]=''X'',
		[patientresponse.racejapanese-phone]=''X'',
		[patientresponse.racekorean-phone]=''X'',
		[patientresponse.racevietnamese-phone]=''X'',
		[patientresponse.raceotherasian-phone]=''X'',
		[patientresponse.racenoneofaboveasianindian-phone]=''X'',
		[patientresponse.racenativehawaiian-phone]=''X'',
		[patientresponse.raceguamanianchamorro-phone]=''X'',
		[patientresponse.racesamoan-phone]=''X'',
		[patientresponse.raceotherpacificislander-phone]=''X'',
		[patientresponse.racenoneofabovepacific-phone]=''X''
	where [administration.finalstatus] IN (''110'',''120'',''310'')
	and [administration.surveymode]=''1''
	and ExportQueueID=@ExportQueueID

	-- if a respondent returned the survey but didn''t answer a multiple response question at all and all responses are still blank, code all responses to ''M''
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, [ExportColumnName.MR], isnull(RawValue,'''') as RawValue, RecodeValue, FixedWidthLength
	into #unansweredMR
	from cem.ExportTemplate_view
	where exportTemplateId=14
	and [ExportColumnName.MR] is not null 

	declare @sqlwhere varchar(max)	
	declare @etcID int
	select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	while @@rowcount>0
	begin
		set @sql=''update CEM.ExportDataset00000014 set ''
		set @SQLwhere = ''ExportQueueID=''+convert(varchar,@ExportQueueID)+'' and [administration.finalstatus] IN (''''110'''',''''120'''',''''310'''') and len(''
		select @sql = @sql + ''[''+ExportTemplateSectionName+''.''+[ExportColumnName.MR]+'']=''''M'''',''
			, @sqlwhere=@sqlwhere + ''[''+ExportTemplateSectionName+''.''+[ExportColumnName.MR]+'']+''
		from #unansweredMR
		where ExportTemplateColumnID = @etcID
		and [ExportColumnName.MR] <> ''unmarked''

		set @sqlwhere = left(@sqlwhere,len(@sqlwhere)-1) + '')=0''
		set @sql = left(@sql,len(@sql)-1) + '' where '' + @sqlwhere + char(10)
		
		print @SQL
		if len(@Sql)>8000 print ''~''+substring(@sql,8001,7000)
		exec (@SQL)
		
		delete from #unansweredMR where ExportTemplateColumnID = @etcID
		select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	end

	drop table #unansweredMR;

	-- some sampleplans changed which units were their CAHPS units to accomodate requirements for systematic sampling.
	-- those samplesets'' NumPatInFile and EligibleCount values are stored at the unit that was the cahps unit at time of sampling
	-- the data is submitted under whatever the current cahps unit is, so these values are appearing in the submission file as NULL or 0
	-- we''re adding code to the post process to grab the values from the non-cahps unit, but just for Q2/2016 submission
	with Q2SS as (
		-- get the sampleset(s) for each CCN/month
		Select distinct [header.providernum],[header.sampleyear],[header.samplemonth], sp.samplesetid
		FROM CEM.ExportDataset00000014 eds
		inner join NRC_Datamart.dbo.samplepopulation sp on eds.samplepopulationid=sp.samplepopulationid
		where exportqueueid = @ExportQueueID
		and [header.sampleyear]=''2016'' 
		and [header.samplemonth] between ''04'' and ''06''
		and [header.providernum] in (''050159'',''080006'',''100002'',''100034'',''100090'',''110024'',''110043'',''140052'',''180013'',''180048'',''181315'',''181318'',''181324'',''190263'',''200009''
									,''250102'',''280003'',''281354'',''330238'',''360013'',''360051'',''360052'',''360076'',''360084'',''360174'',''361323'',''370008'',''370023'',''450352'')
	)
	update eds set [header.patientsfile]=agg.numPatInFile, [header.eligiblepatients]=agg.EligibleCount
	--select eds.samplepopulationid, eds.[header.sampleyear], eds.[header.samplemonth], eds.[header.providernum], [header.patientsfile],agg.numPatInFile, [header.eligiblepatients],agg.EligibleCount
	from CEM.ExportDataset00000014 eds
	join (-- get the non-CAHPS unit(s) for each sampleset and SUM the numPatinFile and EligibleCount
		  -- for Q2/2016 the units that have info in numPatInFile and EligibleCount are not the CAHPS units
		Select [header.providernum],[header.sampleyear],[header.samplemonth], sum(suss.NumPatInFile) as NumPatInFile, sum(suss.EligibleCount) as EligibleCount
		FROM Q2ss Q2
		inner join NRC_Datamart.dbo.SampleUnitBySampleset suss on Q2.samplesetid=suss.samplesetid
		inner join NRC_Datamart.dbo.sampleunit su on suss.sampleunitid=su.sampleunitid
		where isCAHPS=0
		group by [header.providernum],[header.sampleyear],[header.samplemonth]) agg
	on eds.[header.providernum]=agg.[header.providernum] and eds.[header.sampleyear]=agg.[header.sampleyear] and eds.[header.samplemonth]=agg.[header.samplemonth] 
	where exportqueueid = @ExportQueueID

	-- MedicareLookup.MedicareName is not currently brought over to Catalyst, just the suFacility.FacilityName. 
	-- but MedicareName is more accurate, esp when two facilities use the same CCN.
	update eds set [header.providername] = mlu.MedicareName
	from [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] eds
	join qualisys.qp_prod.dbo.medicarelookup mlu on eds.[header.providernum] = mlu.medicarenumber
	where eds.ExportQueueID = @ExportQueueID
	and eds.[header.providername] <> mlu.MedicareName

	--Numerous CCNs had erroneous rollup counts for Q4 2016 submission due to setup issues; these are the hard-code fixes:
	--CCN 030012
	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsfile] = 173, [header.patientsserved] = 253
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''030012'' and [header.samplemonth] = ''10''

	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsfile] = 167, [header.patientsserved] = 245
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''030012'' and [header.samplemonth] = ''11''

	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsfile] = 214, [header.patientsserved] = 308
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''030012'' and [header.samplemonth] = ''12''

	--CCN 050121
	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsserved] = 809
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''050121'' and [header.samplemonth] = ''12''

	--CCN 100034
	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsserved] = 961
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''100034'' and [header.samplemonth] = ''10''

	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsserved] = 1155
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''100034'' and [header.samplemonth] = ''11''

	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsserved] = 1158
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''100034'' and [header.samplemonth] = ''12''

	--CCN 450834
	update [NRC_DataMart_Extracts].[CEM].[ExportDataset00000014] set [header.patientsserved] = 689
	where ExportQueueID = @ExportQueueID and [header.providernum] = ''450834'' and [header.samplemonth] = ''10''

end'

	set @SQL = replace(@SQL, '00000014', right('00000000'+convert(varchar,@newid),8))
	exec (@SQL)

END