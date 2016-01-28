DECLARE @idoc int
DECLARE @doc XML
SET @doc ='<root>
<dbo.TransformMapping>
  <TransformMappingId>1</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>DataFile_id</TargetFieldname>
  <Transform>MacroValue("DATAFILE_ID")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>2</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>DF_id</TargetFieldname>
  <Transform>serial(0)</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>3</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>NewRecordDate</TargetFieldname>
  <Transform>Now()</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>4</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>AdmitSource</TargetFieldname>
  <Transform>Records("R1").Fields("Referral Source")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-04T13:36:50.990</UpdateDate>
  <UpdateUser></UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>5</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>DischargeDate</TargetFieldname>
  <Transform>If IsNull(Records("R1").Fields("Discharge Date")) Then
      Return ""
ElseIf Len(Records("R1").Fields("Discharge Date")) = 7 Then
      Return _DateFormat("0" &amp; Records("R1").Fields("Discharge Date"), "mmddyyyy")
Else
      Return _DateFormat(Records("R1").Fields("Discharge Date"), "mmddyyyy")
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:52:46.550</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>6</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9</TargetFieldname>
  <Transform>_GETHOMEHEALTHPRIMARYICD9(Records("R1").Fields("Primary Diagnosis ICD_A2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>7</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_2</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_B2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>8</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_3</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_C2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>9</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceDate</TargetFieldname>
  <Transform>If IsDate(Records("R1").Fields("MONTH") &amp; "/1/" &amp; Records("R1").Fields("YEAR")) Then
      Return CDate(Records("R1").Fields("MONTH") &amp; "/1/" &amp; Records("R1").Fields("YEAR"))
Else
      Return Null()
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T15:30:43.870</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>10</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>VisitType</TargetFieldname>
  <Transform>Records("R1").Fields("Home Health Visit Type")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>11</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_2</TargetFieldname>
  <Transform>Records("R1").Fields("NUMBER OF BRANCHES")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>12</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_3</TargetFieldname>
  <Transform>Records("R1").Fields("VERSION NUMBER")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>13</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_4</TargetFieldname>
  <Transform>Records("R1").Fields("Dialysis Indicator")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>14</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_5</TargetFieldname>
  <Transform>Records("R1").Fields("Skilled Nursing")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>15</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_6</TargetFieldname>
  <Transform>Records("R1").Fields("Physical Therapy")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>16</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_7</TargetFieldname>
  <Transform>Records("R1").Fields("Home Health Aide")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>17</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_8</TargetFieldname>
  <Transform>Records("R1").Fields("Social Service")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>18</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_9</TargetFieldname>
  <Transform>Records("R1").Fields("Occupational Therapy")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>19</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_10</TargetFieldname>
  <Transform>Records("R1").Fields("Companion/Homemaker")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>20</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ServiceInd_11</TargetFieldname>
  <Transform>Records("R1").Fields("Speech Therapy")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>21</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_4</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_D2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>22</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_5</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_E2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>23</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_6</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other diagnosis_F2"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>24</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_7</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Primary Payment Diagnosis ICD_A3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>25</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_8</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Primary Payment Diagnosis ICD_A4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>26</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_9</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_B3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>27</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_10</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_B4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>28</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_11</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_C3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>29</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_12</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_C4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>30</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_13</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_D3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>31</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_14</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_D4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>32</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_15</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_E3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>33</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_16</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_E4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>34</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>Enc_Mtch</TargetFieldname>
  <Transform>Records("R1").Fields("Medical Record Number") &amp; _DATEFORMAT(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy") &amp; Records("R1").Fields("MONTH") &amp; Records("R1").Fields("YEAR")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>35</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_17</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis  ICD_F3"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>36</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>ICD9_18</TargetFieldname>
  <Transform>_GETHOMEHEALTHICD9(Records("R1").Fields("Other Payment Diagnosis ICD_F4"))</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>37</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>NPI</TargetFieldname>
  <Transform>Records("R1").Fields("NPI")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>38</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAgencyNm</TargetFieldname>
  <Transform>Records("R1").Fields("PROVIDER NAME")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>39</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHSampleMonth</TargetFieldname>
  <Transform>Records("R1").Fields("MONTH")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>40</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHSampleYear</TargetFieldname>
  <Transform>Records("R1").Fields("YEAR")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>41</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPatServed</TargetFieldname>
  <Transform>Records("R1").Fields("TOTAL NUMBER OF PATIENT SERVED")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>42</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHVisitCnt</TargetFieldname>
  <Transform>Records("R1").Fields("Number of skilled visits")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>43</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHLookbackCnt</TargetFieldname>
  <Transform>Records("R1").Fields("Lookback Period Visits")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>44</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_Hosp</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - IPP S") = "1" Or Records("R1").Fields("Admission Source - LTCH") = "1" Or Records("R1").Fields("Admission Source - Pysch") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T15:33:01.937</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>45</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_Rehab</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - IRF") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:55:57.687</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>46</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_SNF</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - SNF") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:56:21.370</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>47</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_OthLTC</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - NF") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>48</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_OthIP</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - Other") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>49</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAdm_Comm</TargetFieldname>
  <Transform>If Records("R1").Fields("Admission Source - NA (Community)") = "1" Or Records("R1").Fields("Admission Source - Unknown") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:58:03.473</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>50</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPay_Mcare</TargetFieldname>
  <Transform>If Records("R1").Fields("Payer - Medicare FFS") = "1" Or Records("R1").Fields("Payer - Medicare HMO") = "1" Then
      Return "1"
Else
      Return "M"
End if</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:58:21.957</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>51</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPay_Mcaid</TargetFieldname>
  <Transform>If Records("R1").Fields("Payer - Medicaid FFS") = "1" Or Records("R1").Fields("Payer - Medicaid HMO") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:58:40.417</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>52</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPay_Ins</TargetFieldname>
  <Transform>If Records("R1").Fields("Payer - Private Ins") = "1" Or Records("R1").Fields("Payer - Private HMO") = "1" Or Records("R1").Fields("Payer - Self-pay") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:59:00.580</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>53</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPay_Other</TargetFieldname>
  <Transform>If Records("R1").Fields("Payer - Workers Comp") = "1" Or Records("R1").Fields("Payer - None") = "1" Or Records("R1").Fields("Payer - Title programs") = "1" Or Records("R1").Fields("Payer - Other Government") = "1" Or Records("R1").Fields("Payer - Other") = "1" Then
      Return "1"
Else
      Return "M"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:59:19.243</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>54</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHHMO</TargetFieldname>
  <Transform>Records("R1").Fields("HMO Indicator")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>55</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHDual</TargetFieldname>
  <Transform>Records("R1").Fields("Dually eligible for Medicare and Medicaid?")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>56</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHSurg</TargetFieldname>
  <Transform>If IsNumeric(Records("R1").Fields("Surgical Discharge")) Then
    return Records("R1").Fields("Surgical Discharge")
End If
Return "M"</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T18:10:08.073</UpdateDate>
  <UpdateUser>NRC\DPetersen</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>57</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHESRD</TargetFieldname>
  <Transform>Records("R1").Fields("End-Stage Renal Disease (ESRD)")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>58</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_Deficit</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>59</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_DressUp</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Dress Upper"),"dressup")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>60</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_DressLow</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Dress Lower"),"dresslow")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>61</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_Bath</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Bathing"),"bath")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>62</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_Toilet</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Toileting"),"toilet")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>63</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_Transfer</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Transferring"),"transfer")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>64</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHADL_Feed</TargetFieldname>
  <Transform>_GETHHADLALL(Records("R1").Fields("ADL_Feed"),"feed")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>65</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHBranchNum</TargetFieldname>
  <Transform>Records("R1").Fields("Branch ID")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>66</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHEOMAge</TargetFieldname>
  <Transform>If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
      Return AGEATMONTHEND(_DateFormat("0" &amp; Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR"))
Else
      Return AGEATMONTHEND(_DateFormat(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR"))
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T17:00:04.820</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>67</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHCatAge</TargetFieldname>
  <Transform>If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
      Return _GETHOMEHEALTHCATAGE(AGEATMONTHEND(_DateFormat("0" &amp; Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR")))
Else
      Return _GETHOMEHEALTHCATAGE(AGEATMONTHEND(_DateFormat(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"),Records("R1").Fields("MONTH"),Records("R1").Fields("YEAR")))
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T17:00:25.907</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>68</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHHospice</TargetFieldname>
  <Transform>If Records("R1").Fields("Hospice Indicator") = "1" Then
      Return "Y"
Else
      Return "N"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T15:33:38.473</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>69</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHDischargeStat</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>70</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHPatInFile</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>71</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHOASISPatID</TargetFieldname>
  <Transform>Records("R1").Fields("Patient ID")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>72</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHSOCDate</TargetFieldname>
  <Transform>_DateFormat(Records("R1").Fields("Start of Care Date"), "mmddyyyy")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:40:45.340</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>73</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHAssesReason</TargetFieldname>
  <Transform>Records("R1").Fields("Assessment Reason")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>74</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>CCN</TargetFieldname>
  <Transform>Records("R1").Fields("PROVIDER ID")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>75</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHMaternity</TargetFieldname>
  <Transform>If Records("R1").Fields("Maternity Care Only Indicator") = "1" Then
      Return "Y"
Else
      Return "N"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T17:00:56.107</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>76</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHDeceased</TargetFieldname>
  <Transform>If Records("R1").Fields("Deceased Indicator") = "1" Then
      Return "Y"
Else
      Return "N"
End If</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T17:01:14.777</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>77</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>Enc_Mtch_Val</TargetFieldname>
  <Transform>Records("R1").Fields("Lookback Period Visits") &amp; Records("R1").Fields("TOTAL NUMBER OF PATIENT SERVED") &amp; Records("R1").Fields("Start of Care Date") &amp; Records("R1").Fields("Number of skilled visits")</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>78</TransformMappingId>
  <TransformTargetId>1</TransformTargetId>
  <TargetFieldname>HHNQL</TargetFieldname>
  <Transform>Select Case Records("R1").Fields("Language")
	Case "3"
		If contractedLanguages.Contains("C") Then
			Return "Chinese"
		End If
	Case "4"
		If contractedLanguages.Contains("R") Then
			Return "Russian"
		End If
	Case "5"
		If contractedLanguages.Contains("V") Then
			Return "Vietnamese"
		End If
	Case Else
		Return Null()
End Select
Return Null()</Transform>
  <CreateDate>2010-12-16T13:48:20.457</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T13:16:57.437</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>79</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>DataFile_id</TargetFieldname>
  <Transform>MacroValue("DATAFILE_ID")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>80</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>DF_id</TargetFieldname>
  <Transform>serial(0)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>81</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>MRN</TargetFieldname>
  <Transform>Records("R1").Fields("Medical Record Number")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>82</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>LName</TargetFieldname>
  <Transform>Records("R1").Fields("Patient Last Name")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>83</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>FName</TargetFieldname>
  <Transform>Records("R1").Fields("Patient First Name")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>84</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Addr</TargetFieldname>
  <Transform>Left(Records("R1").Fields("Patient Mailing Address 1"),60)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T13:42:18.427</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>85</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>City</TargetFieldname>
  <Transform>Records("R1").Fields("Patient Address City")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>86</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>ST</TargetFieldname>
  <Transform>Records("R1").Fields("Patient Address State")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>87</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>ZIP5</TargetFieldname>
  <Transform>Select Case Records("R1").Fields("Language")
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
	Case Else
		Return Left(Records("R1").Fields("Patient Address Zip Code"),5)
End Select
Return Left(Records("R1").Fields("Patient Address Zip Code"),5)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T13:22:57.083</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>88</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>DOB</TargetFieldname>
  <Transform>If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
      Return _DateFormat("0" &amp; Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")
Else
      Return _DateFormat(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")
End If</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:49:13.983</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>89</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Sex</TargetFieldname>
  <Transform>If Records("R1").Fields("Gender") = "1" Then
      Return "M"
ElseIf Records("R1").Fields("Gender") = "2" Then
      Return "F"
End If</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:49:42.893</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>90</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Age</TargetFieldname>
  <Transform>If Len(Records("R1").Fields("Patient Date of Birth")) = 7 Then
      Return _AGEFROMDOB(_DateFormat("0" &amp; Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"))
Else
      Return _AGEFROMDOB(_DateFormat(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy"))
End If</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T16:50:00.007</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>91</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>AddrStat</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>92</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>AddrErr</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>93</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Zip4</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>94</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>NewRecordDate</TargetFieldname>
  <Transform>Now()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>95</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>LangID</TargetFieldname>
  <Transform>Select Case Records("R1").Fields("Language")
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
	Case Else
		Return "1"
End Select
Return "1"</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T13:30:41.433</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>96</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Del_Pt</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>97</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Phone</TargetFieldname>
  <Transform>Right(Records("R1").Fields("Telephone Number including area code"),7)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>98</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>PHONSTAT</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>99</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>AreaCode</TargetFieldname>
  <Transform>Left(Records("R1").Fields("Telephone Number including area code"),3)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>100</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Addr2</TargetFieldname>
  <Transform>Left(Records("R1").Fields("Patient Mailing Address 2"),42)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
  <UpdateDate>2011-02-08T13:42:52.343</UpdateDate>
  <UpdateUser>NRC\aaliabadi</UpdateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>101</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>NameStat</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>102</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Zip5_Foreign</TargetFieldname>
  <Transform>Left(Records("R1").Fields("Patient Address Zip Code"),5)</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>103</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Province</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>104</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Postal_Code</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>105</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Pop_Mtch</TargetFieldname>
  <Transform>Records("R1").Fields("Medical Record Number") &amp; _DATEFORMAT(Records("R1").Fields("Patient Date of Birth"),"mmddyyyy")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>106</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>HHLangHandE</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>107</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>HHHelpedHandE</TargetFieldname>
  <Transform>Null()</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>108</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Middle</TargetFieldname>
  <Transform>Records("R1").Fields("Patient Middle Initial")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
<dbo.TransformMapping>
  <TransformMappingId>109</TransformMappingId>
  <TransformTargetId>2</TransformTargetId>
  <TargetFieldname>Pop_Mtch_Val</TargetFieldname>
  <Transform>Records("R1").Fields("Patient First Name") &amp; Records("R1").Fields("Patient Last Name")</Transform>
  <CreateDate>2010-12-16T13:49:20.037</CreateDate>
  <CreateUser>nrc\aaliabadi</CreateUser>
</dbo.TransformMapping>
</root>'

EXEC sp_xml_preparedocument @idoc OUTPUT, @doc
INSERT INTO dbo.TransformMapping(TransformTargetId,SourceFieldName,TargetFieldname,Transform,CreateDate,CreateUser,UpdateDate,UpdateUser)
SELECT    *
FROM       OPENXML (@idoc, '/root/dbo.TransformMapping',1)
            WITH (	TransformTargetId int 'TransformTargetId/text()',
					SourceFieldName varchar(100) 'SourceFieldName/text()',
					TargetFieldname varchar(100) 'TargetFieldname/text()',
					Transform varchar(7000) 'Transform/text()',
					CreateDate DateTime 'CreateDate/text()',
					CreateUser varchar(100) 'CreateUser/text()',
					UpdateDate DateTime 'UpdateDate/text()',
					UpdateUser varchar(100) 'UpdateUser/text()' )
