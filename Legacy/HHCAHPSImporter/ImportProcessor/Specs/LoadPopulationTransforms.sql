DECLARE @idoc int
DECLARE @doc XML
SET @doc ='	<transform target="Population_Load">
          <field fieldname = "DataFile_id"><![CDATA[MacroValue("DATAFILE_ID")]]></field>
          <field fieldname = "DF_id"><![CDATA[serial(0)]]></field>
          <field fieldname = "MRN"><![CDATA[Records("R1").Fields("Medical Record Number")]]></field>
          <field fieldname = "LName"><![CDATA[Records("R1").Fields("Patient Last Name")]]></field>
          <field fieldname = "FName"><![CDATA[Records("R1").Fields("Patient First Name")]]></field>
          <field fieldname = "Addr"><![CDATA[Records("R1").Fields("Patient Mailing Address 1")]]></field>
          <field fieldname = "City"><![CDATA[Records("R1").Fields("Patient Address City")]]></field>
          <field fieldname = "ST"><![CDATA[Records("R1").Fields("Patient Address State")]]></field>
          <field fieldname = "ZIP5"><![CDATA[Select Case Records("R1").Fields("Language")
  Case "4"
    Return "99999"
  Case Else
    Return Left(Records("R1").Fields("Patient Address Zip Code"),5)
End Select]]></field>
          <field fieldname = "DOB"><![CDATA[If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
  Return DateValMask("0" & Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")
Else
  Return DateValMask(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")
End If]]></field>
          <field fieldname = "Sex"><![CDATA[If Records("R1").Fields("Gender") = "1" Then
  Return "M"
ElseIf Records("R1").Fields("Gender") = "2" Then
  Return "F"
End If]]></field>
          <field fieldname = "Age"><![CDATA[If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
  Return _AGEFROMDOB(DateValMask("0" & Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"))
Else
  Return _AGEFROMDOB(DateValMask(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"))
End If]]></field>
          <field fieldname = "AddrStat"><![CDATA[Null()]]></field>
          <field fieldname = "AddrErr"><![CDATA[Null()]]></field>
          <field fieldname = "Zip4"><![CDATA[Null()]]></field>
          <field fieldname = "NewRecordDate"><![CDATA[Now()]]></field>
          <field fieldname = "LangID"><![CDATA[Select Case Records("R1").Fields("Language")
                Case "2"
                    If contractedLanguages.Contains("S") Then
                        Return "19"
                    End If
                Case "3"
                    If contractedLanguages.Contains("C") Then
                        Return "99999"
                    End If
                Case "4"
                    If contractedLanguages.Contains("R") Then
                        Return "99999"
                    End If
                Case "5"
                    If contractedLanguages.Contains("V") Then
                        Return "99999"
                    End If
                Case "M"
                    Return "1"
                Case Else
                    Return "1"
            End Select
            Return "1"]]></field>
          <field fieldname = "Del_Pt"><![CDATA[Null()]]></field>
          <field fieldname = "Phone"><![CDATA[Right(Records("R1").Fields("Telephone Number including area code"),7)]]></field>
          <field fieldname = "PHONSTAT"><![CDATA[Null()]]></field>
          <field fieldname = "AreaCode"><![CDATA[Left(Records("R1").Fields("Telephone Number including area code"),3)]]></field>
          <field fieldname = "Addr2"><![CDATA[Records("R1").Fields("Patient Mailing Address 2")]]></field>
          <field fieldname = "NameStat"><![CDATA[Null()]]></field>
          <field fieldname = "Zip5_Foreign"><![CDATA[Left(Records("R1").Fields("Patient Address Zip Code"),5)]]></field>
          <field fieldname = "Province"><![CDATA[Null()]]></field>
          <field fieldname = "Postal_Code"><![CDATA[Null()]]></field>
          <field fieldname = "Pop_Mtch"><![CDATA[Records("R1").Fields("Medical Record Number") & _DATEFORMAT(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")]]></field>
          <field fieldname = "HHLangHandE"><![CDATA[Null()]]></field>
          <field fieldname = "HHHelpedHandE"><![CDATA[Null()]]></field>
          <field fieldname = "Middle"><![CDATA[Records("R1").Fields("Patient Middle Initial")]]></field>
          <field fieldname = "Pop_Mtch_Val"><![CDATA[Records("R1").Fields("Patient First Name") & Records("R1").Fields("Patient Last Name")]]></field>		
	</transform>'
	
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc
INSERT INTO dbo.TransformMapping
SELECT    2 as TransformTargetId, null as sourcefieldname, *, GETDATE(),'nrc\aaliabadi',null,null
FROM       OPENXML (@idoc, '/transform/field',1)
            WITH (TargetFieldName varchar(100) '@fieldname',
                  Transform varchar(7000) 'text()')
