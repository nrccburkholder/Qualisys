DECLARE @idoc int
DECLARE @doc XML
SET @doc ='	<transform target="Encounter_Load">
          <field fieldname = "DataFile_id"><![CDATA[MacroValue("DATAFILE_ID")]]></field>
          <field fieldname = "DF_id"><![CDATA[serial(0)]]></field>
          <field fieldname = "NewRecordDate"><![CDATA[Now()]]></field>
          <field fieldname = "AdmitSource"><![CDATA[Records("R1").Fields("Referral Source")]]></field>
          <field fieldname = "DischargeDate"><![CDATA[If IsNull(Records("R1").Fields("Discharge Date")) Then
  Return ""
ElseIf Len(Records("R1").Fields("Discharge Date")) = 7 Then
  Return DateValMask("0" & Records("R1").Fields("Discharge Date"), "mmddyyyy")
Else
  Return DateValMask(Records("R1").Fields("Discharge Date"), "mmddyyyy")
End If]]></field>
          <field fieldname = "ICD9"><![CDATA[_GETHOMEHEALTHPRIMARYICD9(Records("R1").Fields("Primary Diagnosis ICD_A2"))]]></field>
          <field fieldname = "ICD9_2"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_B2"))]]></field>
          <field fieldname = "ICD9_3"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_C2"))]]></field>
          <field fieldname = "ServiceDate"><![CDATA[If IsDate(Records("R1").Fields("MONTH") & "/1/" & Records("R1").Fields("YEAR")) Then
  Return CDate(Records("R1").Fields("MONTH") & "/1/" & Records("R1").Fields("YEAR"))
Else
  Return Null()
End If]]></field>
          <field fieldname = "VisitType"><![CDATA[Records("R1").Fields("Home Health Visit Type")]]></field>
          <field fieldname = "ServiceInd_2"><![CDATA[Records("R1").Fields("NUMBER OF BRANCHES")]]></field>
          <field fieldname = "ServiceInd_3"><![CDATA[Records("R1").Fields("VERSION NUMBER")]]></field>
          <field fieldname = "ServiceInd_4"><![CDATA[Records("R1").Fields("Dialysis Indicator")]]></field>
          <field fieldname = "ServiceInd_5"><![CDATA[Records("R1").Fields("Skilled Nursing")]]></field>
          <field fieldname = "ServiceInd_6"><![CDATA[Records("R1").Fields("Physical Therapy")]]></field>
          <field fieldname = "ServiceInd_7"><![CDATA[Records("R1").Fields("Home Health Aide")]]></field>
          <field fieldname = "ServiceInd_8"><![CDATA[Records("R1").Fields("Social Service")]]></field>
          <field fieldname = "ServiceInd_9"><![CDATA[Records("R1").Fields("Occupational Therapy")]]></field>
          <field fieldname = "ServiceInd_10"><![CDATA[Records("R1").Fields("Companion/Homemaker")]]></field>
          <field fieldname = "ServiceInd_11"><![CDATA[Records("R1").Fields("Speech Therapy")]]></field>
          <field fieldname = "ICD9_4"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_D2"))]]></field>
          <field fieldname = "ICD9_5"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_E2"))]]></field>
          <field fieldname = "ICD9_6"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_F2"))]]></field>
          <field fieldname = "ICD9_7"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Primary Payment Diagnosis ICD_A3"))]]></field>
          <field fieldname = "ICD9_8"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Primary Payment Diagnosis ICD_A4"))]]></field>
          <field fieldname = "ICD9_9"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_B3"))]]></field>
          <field fieldname = "ICD9_10"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_B4"))]]></field>
          <field fieldname = "ICD9_11"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_C3"))]]></field>
          <field fieldname = "ICD9_12"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_C4"))]]></field>
          <field fieldname = "ICD9_13"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_D3"))]]></field>
          <field fieldname = "ICD9_14"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_D4"))]]></field>
          <field fieldname = "ICD9_15"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_E3"))]]></field>
          <field fieldname = "ICD9_16"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_E4"))]]></field>
          <field fieldname = "Enc_Mtch"><![CDATA[Records("R1").Fields("Medical Record Number") & _DATEFORMAT(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy") & Records("R1").Fields("MONTH") & Records("R1").Fields("YEAR")]]></field>
          <field fieldname = "ICD9_17"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_F3"))]]></field>
          <field fieldname = "ICD9_18"><![CDATA[_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_F4"))]]></field>
          <field fieldname = "NPI"><![CDATA[Records("R1").Fields("NPI")]]></field>
          <field fieldname = "HHAgencyNm"><![CDATA[Records("R1").Fields("PROVIDER NAME")]]></field>
          <field fieldname = "HHSampleMonth"><![CDATA[Records("R1").Fields("MONTH")]]></field>
          <field fieldname = "HHSampleYear"><![CDATA[Records("R1").Fields("YEAR")]]></field>
          <field fieldname = "HHPatServed"><![CDATA[Records("R1").Fields("TOTAL NUMBER OF PATIENT SERVED")]]></field>
          <field fieldname = "HHVisitCnt"><![CDATA[Records("R1").Fields("Number of skilled visits")]]></field>
          <field fieldname = "HHLookbackCnt"><![CDATA[Records("R1").Fields("Lookback Period Visits")]]></field>
          <field fieldname = "HHAdm_Hosp"><![CDATA[If Records("R1").Fields("Admission Source - IPP S") = "1" Or Records("R1").Fields("Admission Source - LTCH") = "1" Or Records("R1").Fields("Admission Source - Pysch") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHAdm_Rehab"><![CDATA[If Records("R1").Fields("Admission Source - IRF") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHAdm_SNF"><![CDATA[If Records("R1").Fields("Admission Source - SNF") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHAdm_OthLTC"><![CDATA[If Records("R1").Fields("Admission Source - NF") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHAdm_OthIP"><![CDATA[If Records("R1").Fields("Admission Source - Other") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHAdm_Comm"><![CDATA[If Records("R1").Fields("Admission Source - NA (Community)") = "1" Or Records("R1").Fields("Admission Source - Unknown") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHPay_Mcare"><![CDATA[If Records("R1").Fields("Payer - Medicare FFS") = "1" Or Records("R1").Fields("Payer - Medicare HMO") = "1" Then
  Return "1"
Else
  Return "M"
End if]]></field>
          <field fieldname = "HHPay_Mcaid"><![CDATA[If Records("R1").Fields("Payer - Medicaid FFS") = "1" Or Records("R1").Fields("Payer - Medicaid HMO") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHPay_Ins"><![CDATA[If Records("R1").Fields("Payer - Private Ins") = "1" Or Records("R1").Fields("Payer - Private HMO") = "1" Or Records("R1").Fields("Payer - Self-pay") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHPay_Other"><![CDATA[If Records("R1").Fields("Payer - Workers Comp") = "1" Or Records("R1").Fields("Payer - None") = "1" Or Records("R1").Fields("Payer - Title programs") = "1" Or Records("R1").Fields("Payer - Other Government") = "1" Or Records("R1").Fields("Payer - Other") = "1" Then
  Return "1"
Else
  Return "M"
End If]]></field>
          <field fieldname = "HHHMO"><![CDATA[Records("R1").Fields("HMO Indicator")]]></field>
          <field fieldname = "HHDual"><![CDATA[Records("R1").Fields("Dually eligible for Medicare and Medicaid?")]]></field>
          <field fieldname = "HHSurg"><![CDATA[Records("R1").Fields("Surgical Discharge")]]></field>
          <field fieldname = "HHESRD"><![CDATA[Records("R1").Fields("End-Stage Renal Disease (ESRD)")]]></field>
          <field fieldname = "HHADL_Deficit"><![CDATA[Null()]]></field>
          <field fieldname = "HHADL_DressUp"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Dress Upper"),"dressup")]]></field>
          <field fieldname = "HHADL_DressLow"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Dress Lower"),"dresslow")]]></field>
          <field fieldname = "HHADL_Bath"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Bathing"),"bath")]]></field>
          <field fieldname = "HHADL_Toilet"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Toileting"),"toilet")]]></field>
          <field fieldname = "HHADL_Transfer"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Transferring"),"transfer")]]></field>
          <field fieldname = "HHADL_Feed"><![CDATA[_GETHHADLALL(Records("R1").Fields("ADL_Feed"),"feed")]]></field>
          <field fieldname = "HHBranchNum"><![CDATA[Records("R1").Fields("Branch ID")]]></field>
          <field fieldname = "HHEOMAge"><![CDATA[If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
  Return AGEATMONTHEND(DateValMask("0" & Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR"))
Else
  Return AGEATMONTHEND(DateValMask(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR"))
End If]]></field>
          <field fieldname = "HHCatAge"><![CDATA[If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
  Return _GETHOMEHEALTHCATAGE(AGEATMONTHEND(DateValMask("0" & Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR")))
Else
  Return _GETHOMEHEALTHCATAGE(AGEATMONTHEND(DateValMask(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR")))
End If]]></field>
          <field fieldname = "HHHospice"><![CDATA[If Records("R1").Fields("Hospice Indicator") = "1" Then
  Return "Y"
Else
  Return "N"
End If]]></field>
          <field fieldname = "HHDischargeStat"><![CDATA[Null()]]></field>
          <field fieldname = "HHPatInFile"><![CDATA[Null()]]></field>
          <field fieldname = "HHOASISPatID"><![CDATA[Records("R1").Fields("Patient ID")]]></field>
          <field fieldname = "HHSOCDate"><![CDATA[If IsNull(Records("R1").Fields("Start of Care Date")) Then
  Return ""
ElseIf Len(Records("R1").Fields("Start of Care Date")) = 7 Then
  Return DateValMask("0" & Records("R1").Fields("Start of Care Date"), "mmddyyyy")
Else
  Return DateValMask(Records("R1").Fields("Start of Care Date"), "mmddyyyy")
End If]]></field>
          <field fieldname = "HHAssesReason"><![CDATA[Records("R1").Fields("Assessment Reason")]]></field>
          <field fieldname = "CCN"><![CDATA[Records("R1").Fields("PROVIDER ID")]]></field>
          <field fieldname = "HHMaternity"><![CDATA[If Records("R1").Fields("Maternity Care Only Indicator") = "1" Then
  Return "Y"
Else
  Return "N"
End If]]></field>
          <field fieldname = "HHDeceased"><![CDATA[If Records("R1").Fields("Deceased Indicator") = "1" Then
  Return "Y"
Else
  Return "N"
End If]]></field>
          <field fieldname = "Enc_Mtch_Val"><![CDATA[Records("R1").Fields("Lookback Period Visits") & Records("R1").Fields("TOTAL NUMBER OF PATIENT SERVED") & Records("R1").Fields("Start of Care Date") & Records("R1").Fields("Number of skilled visits")]]></field>
          <field fieldname = "HHNQL"><![CDATA[Select Case Records("R1").Fields("Language")
  Case "4"
    Return "Russian"
End Select]]></field>
	</transform>'
	
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc
INSERT INTO dbo.TransformMapping
SELECT    1 as TransformTargetId, null as sourcefieldname, *, GETDATE(),'nrc\aaliabadi',null,null
FROM       OPENXML (@idoc, '/transform/field',1)
            WITH (TargetFieldName varchar(100) '@fieldname',
                  Transform varchar(7000) 'text()')