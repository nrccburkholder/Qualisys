
DECLARE @myxml as varchar(max)

SET @myXML = '<?xml version="1.0" encoding="UTF-8"?>
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
                    <xs:element name="language" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-6]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
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
                    <xs:element name="rate-dr" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="^0?[0-9]$|^10$|^[xXmM]$"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
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
                    <xs:element name="rate-staff" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="^0?[0-9]$|^10$|^[xXmM]$"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="onmachine-15min" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="center-clean" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="rate-center" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="^0?[0-9]$|^10$|^[xXmM]$"/><xs:minLength value="1"/><xs:maxLength value="2"/></xs:restriction></xs:simpleType></xs:element>
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
                    <xs:element name="age" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-7]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="sex" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="education" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-8]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="speak-english" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="speak-other-language" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[12mM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
                    <xs:element name="language-spoken" minOccurs="1"><xs:simpleType><xs:restriction base="xs:string"><xs:pattern value="[1-4]|[xXmM]"/><xs:minLength value="1"/><xs:maxLength value="1"/></xs:restriction></xs:simpleType></xs:element>
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


update [CEM].[ExportTemplate]
SET [XMLSchemaDefinition] = @myxml
where [ExportTemplateID] = 1