Friend Class HHCAHPSRecodeReader
    Inherits CmsRecodeReader

#Region " Constructors "

    Public Sub New(ByVal rdr As IDataReader)

        MyBase.New(rdr)

    End Sub

#End Region

#Region " Schema Initialization "

    Protected Overrides Sub InitResponseColumnAliases()

        'MyBase.InitResponseColumnAliases()

        AddResponseColumnAlias("confirm-care", "Q038694")
        AddResponseColumnAlias("what-care-get", "Q038695")
        AddResponseColumnAlias("how-set-up-home", "Q038696")
        AddResponseColumnAlias("talk-about-meds", "Q038697")
        AddResponseColumnAlias("see-meds", "Q038698")
        AddResponseColumnAlias("nurse-provider", "Q038699")
        AddResponseColumnAlias("phys-occ-sp-ther", "Q038700")
        AddResponseColumnAlias("personal-care", "Q038701")
        AddResponseColumnAlias("informed-up-to-date", "Q038702")
        AddResponseColumnAlias("talk-about-pain", "Q038703")
        AddResponseColumnAlias("take-newmeds", "Q038704")
        AddResponseColumnAlias("talk-about-newmeds", "Q038705")
        AddResponseColumnAlias("when-take-meds", "Q038706")
        AddResponseColumnAlias("med-side-effects", "Q038707")
        AddResponseColumnAlias("when-arrive", "Q038708")
        AddResponseColumnAlias("treat-gently", "Q038709")
        AddResponseColumnAlias("explain-things", "Q038710")
        AddResponseColumnAlias("listen-carefully", "Q038711")
        AddResponseColumnAlias("courtesy-respect", "Q038712")
        AddResponseColumnAlias("rate-care", "Q038713")
        AddResponseColumnAlias("contact-office-screener", "Q038714")
        AddResponseColumnAlias("get-help-needed", "Q038715")
        AddResponseColumnAlias("how-long-help-afterhours", "Q038716")
        AddResponseColumnAlias("problems-with-care-screener", "Q038717")
        AddResponseColumnAlias("recommend", "Q038718")
        AddResponseColumnAlias("overall-health", "Q038719")
        AddResponseColumnAlias("mental-health", "Q038720")
        AddResponseColumnAlias("live", "Q038721")
        AddResponseColumnAlias("education", "Q038722")
        AddResponseColumnAlias("ethnicity", "Q038723")
        AddResponseColumnAlias("race-white", "Q038724a")
        AddResponseColumnAlias("race-african-amer", "Q038724b")
        AddResponseColumnAlias("race-asian", "Q038724c")
        AddResponseColumnAlias("race-native-hawaiian", "Q038724d")
        AddResponseColumnAlias("race-amer-indian", "Q038724e")
        AddResponseColumnAlias("language-resp", "Q038725")
        AddResponseColumnAlias("help-you", "Q038726")
        AddResponseColumnAlias("help-read", "Q038727a")
        AddResponseColumnAlias("help-wrote", "Q038727b")
        AddResponseColumnAlias("help-answer", "Q038727c")
        AddResponseColumnAlias("help-translate", "Q038727d")
        AddResponseColumnAlias("help-other", "Q038727e")
        AddResponseColumnAlias("help-none", "Q038727f")

    End Sub

    Protected Overrides Sub InitSchemaTable()

        InitCoreSchemaTable()

        'Header Columns
        AddStringColumnToSchema("header-type", 1, CmsColumnType.Header)
        AddIntegerColumnToSchema("sample-month", CmsColumnType.Header)
        AddIntegerColumnToSchema("sample-yr", CmsColumnType.Header)
        AddIntegerColumnToSchema("patients-hha", CmsColumnType.Header)
        AddIntegerColumnToSchema("number-vendor-submitted", CmsColumnType.Header)
        AddIntegerColumnToSchema("number-eligible-patients", CmsColumnType.Header)
        AddIntegerColumnToSchema("number-sampled", CmsColumnType.Header)
        AddIntegerColumnToSchema("count-patients-in-file", CmsColumnType.Header)
        AddIntegerColumnToSchema("count-patients-in-file-served", CmsColumnType.Header)
        'The following header columns are initialized in the base class
        AddStringColumnToSchema("provider-name", 50, CmsColumnType.Header)
        AddStringColumnToSchema("provider-id", 20, CmsColumnType.Header)
        AddStringColumnToSchema("npi", 10, CmsColumnType.Header)
        AddStringColumnToSchema("survey-mode", 1, CmsColumnType.Header)
        AddIntegerColumnToSchema("sample-type", CmsColumnType.Header)

        'Results Schema
        'Admin section
        AddStringColumnToSchema("npi", 10, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("sample-month", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("sample-yr", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("sample-id", 16, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("number-visits", 2, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("lb-visits", 3, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-1", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-2", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-3", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-4", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-5", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("admission-source-6", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("payer-medicare", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("payer-medicaid", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("payer-private", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("payer-other", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("hmo-enrollee", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("dual-eligible", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("primary-diagnosis", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("other-diagnosis-1", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("other-diagnosis-2", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("other-diagnosis-3", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("other-diagnosis-4", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("other-diagnosis-5", 5, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("surgical-discharge", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("esrd", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-deficits", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-du", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-dl", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-bathing", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-toilet-transferring", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("adl-transfer", 1, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("final-status", CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("proxy", 1, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("survey-mode", 1, CmsColumnType.PatientAdmin)
        'The following admin columns are initialized in the base class
        AddStringColumnToSchema("provider-id", 20, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("patient-age", 2, CmsColumnType.PatientAdmin)
        AddStringColumnToSchema("gender", 1, CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("language", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("SampSet", CmsColumnType.PatientAdmin)
        AddIntegerColumnToSchema("lag-time", CmsColumnType.PatientAdmin)

        'Reponse Columns
        AddStringColumnToSchema("confirm-care", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("what-care-get", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("how-set-up-home", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("talk-about-meds", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("see-meds", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("nurse-provider", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("phys-occ-sp-ther", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("personal-care", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("informed-up-to-date", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("talk-about-pain", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("take-newmeds", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("talk-about-newmeds", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("when-take-meds", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("med-side-effects", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("when-arrive", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("treat-gently", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("explain-things", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("listen-carefully", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("courtesy-respect", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("rate-care", 2, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("contact-office-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("get-help-needed", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("how-long-help-afterhours", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("problems-with-care-screener", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("recommend", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("overall-health", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("mental-health", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("live", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("education", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("ethnicity", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("race-white", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-african-amer", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-asian", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-native-hawaiian", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("race-amer-indian", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("language-resp", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("help-you", 1, CmsColumnType.PatientResponse)
        AddStringColumnToSchema("help-read", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("help-wrote", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("help-answer", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("help-translate", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("help-other", 1, CmsColumnType.PatientResponseMarkAll)
        AddStringColumnToSchema("help-none", 1, CmsColumnType.PatientResponseMarkAll)

    End Sub

#End Region

#Region " Overrides Methods "

    Protected Overrides Function GetHeaderField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "HEADER-TYPE"
                Return "1" 'Standard

            Case "SAMPLE-YR"
                If String.IsNullOrEmpty(mReader("DisYear").ToString) Then
                    Throw New ExportFileCreationException("The column 'DisYear' (sample-yr) cannot be empty")
                End If
                Return mReader("DisYear")

            Case "SAMPLE-MONTH"
                If String.IsNullOrEmpty(mReader("DisMonth").ToString) Then
                    Throw New ExportFileCreationException("The column 'DisMonth' (sample-month) cannot be empty")
                End If
                Return SetLeadingZeros(mReader("DisMonth").ToString, 2)

            Case "SURVEY-MODE"
                Return RecodeSurveyMode(mReader("Method"))

            Case "PATIENTS-HHA"
                Return RecodeNumberToZero(mReader("PatientsInFileServed"))

            Case "NUMBER-VENDOR-SUBMITTED"
                Return RecodeNumberToZero(mReader("PatientsInFile"))

            Case "NUMBER-ELIGIBLE-PATIENTS"
                Return RecodeNumberToZero(mReader("NumberEligible"))

            Case "NUMBER-SAMPLED"
                Return RecodeNumberToZero(mReader("SampleCount"))

            Case "COUNT-PATIENTS-IN-FILE"
                Return RecodeNumberToZero(mReader("DistinctCountOfPatInFileRecords"))

            Case "COUNT-PATIENTS-IN-FILE-SERVED"
                Return RecodeNumberToZero(mReader("DistinctCountOfPatInFileServedRecords"))

            Case Else
                Return MyBase.GetHeaderField(columnName)

        End Select

    End Function

    Protected Overrides Function GetPatientAdminField(ByVal columnName As String) As Object

        Select Case columnName.ToUpper
            Case "NPI"
                Return ""

            Case "SAMPLE-MONTH"
                Return CType(mReader("SmpEncDt"), Date).Month.ToString.PadLeft(2, CChar("0"))

            Case "SAMPLE-YR"
                Return CType(mReader("SmpEncDt"), Date).Year

            Case "SAMPLE-ID"
                Return mReader("SampPop")

            Case "SURVEY-MODE"
                Return RecodeSurveyMode(mReader("Method"))

            Case "PATIENT-AGE"
                Return RecodeHHCatAge(mReader("HHCatAge"))

            Case "NUMBER-VISITS"
                Return RecodeSimple(mReader("HHVisCt"), 1, 99)

            Case "LB-VISITS"
                Return RecodeSimple(mReader("HHLBCt"), 2, 999)

            Case "ADMISSION-SOURCE-1"
                Return RecodeSimple(mReader("HHAdmHsp"), 1, 1)

            Case "ADMISSION-SOURCE-2"
                Return RecodeSimple(mReader("HHAdmRhb"), 1, 1)

            Case "ADMISSION-SOURCE-3"
                Return RecodeSimple(mReader("HHAdmSNF"), 1, 1)

            Case "ADMISSION-SOURCE-4"
                Return RecodeSimple(mReader("HHAdmLTC"), 1, 1)

            Case "ADMISSION-SOURCE-5"
                Return RecodeSimple(mReader("HHAdmOIP"), 1, 1)

            Case "ADMISSION-SOURCE-6"
                Return RecodeSimple(mReader("HHAdmCom"), 1, 1)

            Case "PAYER-MEDICARE"
                Return RecodeSimple(mReader("HHPayMcr"), 1, 1)

            Case "PAYER-MEDICAID"
                Return RecodeSimple(mReader("HHPayMcd"), 1, 1)

            Case "PAYER-PRIVATE"
                Return RecodeSimple(mReader("HHPayIns"), 1, 1)

            Case "PAYER-OTHER"
                Return RecodeSimple(mReader("HHPayOth"), 1, 1)

            Case "HMO-ENROLLEE"
                Return RecodeSimple(mReader("HHHMO"), 1, 2)

            Case "DUAL-ELIGIBLE"
                Return RecodeSimple(mReader("HHDual"), 1, 3)

            Case "PRIMARY-DIAGNOSIS"
                Dim icdval As String = RecodeICD(mReader, "ICD9", "ICD10_1", mReader("SmpEncDt")).ToString

                If icdval.ToUpper.StartsWith("V") OrElse icdval.ToUpper.StartsWith("W") _
                    OrElse icdval.ToUpper.StartsWith("X") OrElse icdval.ToUpper.StartsWith("Y") Then
                    Return "M"
                Else
                    Return icdval
                End If

            Case "OTHER-DIAGNOSIS-1"
                Return RecodeICD(mReader, "ICD9_2", "ICD10_2", mReader("SmpEncDt"))

            Case "OTHER-DIAGNOSIS-2"
                Return RecodeICD(mReader, "ICD9_3", "ICD10_3", mReader("SmpEncDt"))

            Case "OTHER-DIAGNOSIS-3"
                Return RecodeICD(mReader, "ICD9_4", "ICD10_4", mReader("SmpEncDt"))

            Case "OTHER-DIAGNOSIS-4"
                Return RecodeICD(mReader, "ICD9_5", "ICD10_5", mReader("SmpEncDt"))

            Case "OTHER-DIAGNOSIS-5"
                Return RecodeICD(mReader, "ICD9_6", "ICD10_6", mReader("SmpEncDt"))

            Case "SURGICAL-DISCHARGE"
                Return RecodeSimple(mReader("HHSurg"), 1, 2)

            Case "ESRD"
                Return RecodeSimple(mReader("HHESRD"), 1, 2)

            Case "ADL-DEFICITS"
                Return RecodeSimple(mReader("HHADLDef"), 0, 5)

            Case "ADL-DU"
                Return RecodeSimple(mReader("HHADLDUp"), 0, 3)

            Case "ADL-DL"
                Return RecodeSimple(mReader("HHADLDLo"), 0, 3)

            Case "ADL-BATHING"
                Return RecodeSimple(mReader("HHADLBth"), 0, 6)

            Case "ADL-TOILET-TRANSFERRING"
                Return RecodeSimple(mReader("HHADLToi"), 0, 4)

            Case "ADL-TRANSFER"
                Return RecodeSimple(mReader("HHADLTrn"), 0, 5)

            Case "FINAL-STATUS"
                Return RecodeHHDisposition(mReader("HHDispo"))

            Case "LAG-TIME"
                Return ComputeLagTime()

            Case "LANGUAGE"
                Dim dispo As String = RecodeHHDisposition(mReader("HHDispo")).ToString
                Try
                    'The HNQLDesc column may not always exist.
                    Return RecodeLanguage(mReader("LangID"), mReader("HHNQL"), dispo)

                Catch ex As Exception
                    Return RecodeLanguage(mReader("LangID"), String.Empty, dispo)

                End Try

            Case "PROXY"
                Dim dispo As String = RecodeHHDisposition(mReader("HHDispo")).ToString
                Try
                    'The "Q038727c" column may not always exist.
                    Return RecodeProxy("Q038726", mReader("Q038727c"), dispo, CType(mReader("Method"), String))

                Catch ex As Exception
                    If dispo <> "110" AndAlso dispo <> "120" AndAlso dispo <> "310" Then
                        Return "M"
                    Else
                        Return 2
                    End If

                End Try

            Case Else
                Return MyBase.GetPatientAdminField(columnName)

        End Select

    End Function

    Protected Overrides Function GetRecodedCoreValue(ByVal columnName As String, ByVal value As Object) As Object

        Select Case columnName.ToUpper
            Case "Q038694", "Q038699", "Q038700", "Q038701", "Q038703", "Q038704", "Q038714", "Q038717", "Q038721", "Q038723", "Q038726"
                'Standard Two point scale
                Return RecodeSimple(value, 1, 2)

            Case "Q038695", "Q038696", "Q038697", "Q038698", "Q038725"
                'Standard Three point scale
                Return RecodeSimple(value, 1, 3)

            Case "Q038708", "Q038709", "Q038710", "Q038711", "Q038712", "Q038718"
                'Standard Four point scale
                Return RecodeSimple(value, 1, 4)

            Case "Q038702", "Q038719", "Q038720"
                'Standard Five point scale
                Return RecodeSimple(value, 1, 5)

            Case "Q038722"
                'Standard Six point scale
                Return RecodeSimple(value, 1, 6)

            Case "Q038713"
                'Recode Rate Care
                Return RecodeRateCare(value, 0, 10)

            Case "Q038705", "Q038706", "Q038707"
                'Take new meds
                Return RecodeSkipable(value, "Q038704", 2, 1, 3)

            Case "Q038715"
                'Get help needed
                Return RecodeSkipable(value, "Q038714", 2, 1, 3)

            Case "Q038716"
                'How long help afterhours
                Return RecodeAfterHours(value, "Q038714", 2, "Q038715", 2, 1, 5)

            Case "Q038724A", "Q038724B", "Q038724C", "Q038724D", "Q038724E"
                'Race question
                Return RecodeRace(value, columnName.ToUpper)

            Case "Q038727A", "Q038727B", "Q038727C", "Q038727D", "Q038727E", "Q038727F"
                'Help you
                Return RecodeHelpRead(IIf(value Is DBNull.Value, -9, value), "Q038726", 2, 1, 6)

            Case Else
                Return MyBase.GetRecodedCoreValue(columnName, value)

        End Select

    End Function

#End Region

#Region " Recoding Methods "

    Private Function RecodeRateCare(ByVal value As Object, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        'If the value is > 10000 then we need to subtract it off
        If intVal >= 10000 Then intVal -= 10000
        If intVal >= minValue AndAlso intVal <= maxValue Then
            Return intVal.ToString.PadLeft(2, CChar("0"))
        Else
            Return "M"
        End If

    End Function

    Private Function RecodeAfterHours(ByVal value As Object, ByVal screenQuestion1 As String, ByVal skipValue1 As Integer, ByVal screenQuestion2 As String, ByVal skipValue2 As Integer, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Throw New ExportFileCreationException("Unexpected NULL value encountered.")
        End If

        Dim intVal As Integer = CType(value, Integer)
        'If question was skipped determine if it was correctly or incorrectly skipped
        If intVal = -9 Then
            'If screening question = skipValue recode to 8
            'otherwise return M (incorrectly skipped, blank, multi-marked)
            Dim screen As Integer = CType(mReader(screenQuestion1), Integer)
            If screen >= 10000 Then screen -= 10000
            If screen = skipValue1 Then
                Return 8
            Else
                'Check second screener question
                screen = CType(mReader(screenQuestion2), Integer)
                If screen >= 10000 Then screen -= 10000
                If screen = skipValue2 Then
                    Return 8
                Else
                    Return "M"
                End If
            End If
        ElseIf intVal = -8 Then
            Return "M"
        Else
            'If the value is > 10000 then we need to subtract it off
            If intVal >= 10000 Then intVal -= 10000
            'Verify the value is in the correct range
            If intVal >= minValue AndAlso intVal <= maxValue Then
                Return intVal
            Else
                Throw New ExportFileCreationException("An out of range value was encountered.")
            End If
        End If

    End Function

    Private Function RecodeRace(ByVal value As Object, ByVal columnName As String) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            'Dim raceQuestions As String() = New String() {"Q038724A", "Q038724B", "Q038724C", "Q038724D", "Q038724E"}
            'Check each corresponding question, if any was not null then return 0
            'For Each qstn As String In raceQuestions
            '    If qstn <> columnName Then
            '        If mReader(qstn) IsNot DBNull.Value Then
            '            Return 0
            '        End If
            '    End If
            'Next

            'If all other questions were null then return "M"
            Return "M"
        Else
            'Return a 1 if the value was between 1-5
            Dim intVal As Integer = CType(value, Integer)
            'If the value is > 10000 then we need to subtract it off
            If intVal >= 10000 Then intVal -= 10000
            If intVal >= 1 AndAlso intVal <= 5 Then
                Return 1
            Else
                Throw New ExportFileCreationException(String.Format("A value of {0} is not expected for question Q038724.", intVal))
            End If
        End If

    End Function

    Private Function RecodeHHCatAge(ByVal value As Object) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Return "M"
        End If

        Select Case value.ToString
            Case "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15"
                Return value.ToString

            Case Else
                Return "M"

        End Select

    End Function

    Private Function RecodeSimple(ByVal value As Object, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty OrElse value.ToString = "M" Then
            Return "M"
        End If

        Dim intVal As Integer = CType(value, Integer)
        'If the value is > 10000 then we need to subtract it off
        If intVal >= 10000 Then intVal -= 10000
        If intVal >= minValue AndAlso intVal <= maxValue Then
            Return intVal
        Else
            Return "M"
        End If

    End Function

    Private Function RecodeNull(ByVal value As Object) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Return "M"
        Else
            Return value
        End If

    End Function


    Private testedSchemaTable As DataTable
    Private testedCols As Dictionary(Of String, Boolean) = New Dictionary(Of String, Boolean)
    Private Function HasColumn(ByVal reader As IDataReader, ByVal col As String) As Boolean
        Dim schemaTable As DataTable = reader.GetSchemaTable()
        If testedSchemaTable Is Nothing Then testedSchemaTable = schemaTable

        If testedSchemaTable IsNot schemaTable Then
            testedSchemaTable = schemaTable
            testedCols.Clear()
        End If

        If testedCols.ContainsKey(col) Then Return testedCols(col)

        For Each row As DataRow In schemaTable.Rows
            If CType(row(0), String) = col Then
                testedCols.Add(col, True)
                Return True
            End If
        Next

        testedCols.Add(col, False)
        Return False
    End Function

    Private Function RecodeICD(ByVal reader As IDataReader, ByVal icd9col As String, ByVal icd10col As String, ByVal sampleEncounterDate As Object) As Object
        Dim icd9val As Object = DBNull.Value
        Dim icd10val As Object = DBNull.Value
        If HasColumn(reader, icd9col) Then icd9val = reader(icd9col)
        If HasColumn(reader, icd10col) Then icd10val = reader(icd10col)

        Dim useIcd9 As Boolean = False
        If Not sampleEncounterDate Is DBNull.Value AndAlso CType(sampleEncounterDate, Date) < New Date(2015, 10, 1) Then
            useIcd9 = True
        End If

        Dim icdval As Object
        If useIcd9 Then
            icdval = icd9val
        Else
            icdval = icd10val
        End If

        If icdval Is DBNull.Value OrElse String.IsNullOrEmpty(icdval.ToString.Trim) OrElse String.IsNullOrEmpty(icdval.ToString.Trim.Replace("0", String.Empty)) Then
            Return "M"
        Else
            Dim strVal As String = icdval.ToString.Replace(".", String.Empty)
            'Pad leading 0 if first character numeric
            If useIcd9 AndAlso IsNumeric(Left(strVal, 1)) Then
                Return strVal.PadLeft(5, CChar("0"))
            Else
                Return strVal
            End If
        End If

    End Function

    Private Function RecodeHHDisposition(ByVal value As Object) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Return "M"
        End If

        Select Case value.ToString
            Case "110", "120", "210", "220", "230", "240", "310", "320", "330", "340", "350"
                Return value.ToString

            Case Else
                Return "M"

        End Select

    End Function

    Private Function RecodeSkipable(ByVal value As Object, ByVal screenQuestion As String, ByVal skipValue As Integer, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Return "M"
        End If

        Dim intVal As Integer = CType(value, Integer)
        'If question was skipped determine if it was correctly or incorrectly skipped
        If intVal = -9 Then
            'If screening question = skipValue recode to 8
            'otherwise return M (incorrectly skipped, blank, multi-marked)
            Dim screen As Integer = CType(mReader(screenQuestion), Integer)
            'If the value is > 10000 then we need to subtract it off
            If screen >= 10000 Then screen -= 10000
            If screen = skipValue Then
                Return 8
            Else
                Return "M"
            End If
        ElseIf intVal = -8 Then
            Return "M"
        Else
            'If the value is > 10000 then we need to subtract it off
            If intVal >= 10000 Then intVal -= 10000
            'Verify the value is in the correct range
            If intVal >= minValue AndAlso intVal <= maxValue Then
                Return intVal
            Else
                Throw New ExportFileCreationException("An out of range value was encountered.")
            End If
        End If

    End Function

    Private Function RecodeHelpRead(ByVal value As Object, ByVal screenQuestion As String, ByVal skipValue As Integer, ByVal minValue As Integer, ByVal maxValue As Integer) As Object

        Dim intVal As Integer = CType(value, Integer)
        'If question was skipped determine if it was correctly or incorrectly skipped
        If intVal = -9 Then
            'If screening question = skipValue recode to 8
            'otherwise return M (incorrectly skipped, blank, multi-marked)
            Dim screen As Integer = CType(mReader(screenQuestion), Integer)
            If screen >= 10000 Then screen -= 10000
            If screen = skipValue Then
                Return 8
            Else
                Return "M"
            End If
        ElseIf intVal = -8 Then
            Return "M"
        Else
            'If the value is > 10000 then we need to subtract it off
            If intVal >= 10000 Then intVal -= 10000
            'Verify the value is in the correct range
            If intVal >= minValue AndAlso intVal <= maxValue Then
                Return 1
            Else
                Throw New ExportFileCreationException(String.Format("A value of {0} is not expected for question Q038727.", intVal))
            End If
        End If

    End Function

    Private Function IsEmpty(ByVal value As Object) As Boolean
        Return value Is DBNull.Value OrElse String.IsNullOrEmpty(value.ToString()) OrElse CType(value, Integer) = -9
    End Function

    Private Function RecodeProxy(ByVal someoneHelpedQuestion As String, ByVal howTheyHelpedQuestion As Object, ByVal disposition As String, ByVal method As String) As Object

        If (disposition = "110" Or disposition = "120" Or disposition = "310") Then
            Dim howTheyHelpedValue As Integer = CType(howTheyHelpedQuestion, Integer)

            If (method = "MAIL ONLY") Then
                If (IsEmpty(howTheyHelpedQuestion)) Then
                    If (Not IsEmpty(someoneHelpedQuestion) And CType(someoneHelpedQuestion, Integer) = 1) Then
                        Return 2
                    End If
                Else
                    If (howTheyHelpedValue = 3) Then
                        Return 1
                    Else
                        Return 2
                    End If
                End If
            ElseIf (method = "PHONE ONLY") Then
                If howTheyHelpedValue = 3 Then
                    Return 1
                Else
                    Return 2
                End If
            End If
        End If

        Return "M"
    End Function

    Private Function RecodeLanguage(ByVal value As Object, ByVal langdesc As Object, ByVal dispo As String) As Object

        If dispo <> "110" AndAlso dispo <> "120" AndAlso dispo <> "310" Then
            Return "M"
        End If

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty Then
            Return "M"
        End If

        If langdesc IsNot DBNull.Value AndAlso langdesc.ToString.Trim <> String.Empty Then
            Select Case langdesc.ToString.ToUpper.Trim
                Case "CHINESE"
                    Return 3

                Case "RUSSIAN"
                    Return 4

                Case "VIETNAMESE"
                    Return 5

            End Select
        End If

        Dim intVal As Integer = CType(value, Integer)
        Select Case intVal
            Case 1          'English
                Return 1

            Case 8, 18, 19  'Spanish
                Return 2

            Case 27         'Chinese
                Return 3

            Case 29         'Russian
                Return 4

            Case 30         'Vietnamese
                Return 5

            Case Else
                Return "M"

        End Select

    End Function

    Private Function RecodeNumberToZero(ByVal value As Object) As Object

        If value Is DBNull.Value OrElse value.ToString.Trim = String.Empty OrElse value.ToString.Trim = "M" Then
            Return 0
        Else
            Return value
        End If

    End Function

    Private Function ComputeLagTime() As Object

        Dim lagTime As Integer

        'Get the discharge date
        Dim dischargeDate As Date = CType(mReader("SmpEncDt"), Date)

        If mReader("Rtrn_dt") Is DBNull.Value Then
            Return 888
        Else
            Dim returnDate As Date = CType(mReader("Rtrn_dt"), Date)
            lagTime = returnDate.Subtract(dischargeDate).Days
            If lagTime >= 0 AndAlso lagTime <= 365 Then
                Return lagTime
            Else
                Throw New ExportFileCreationException(String.Format("{0} is an invalid value for field lag-time.  lag-time must be between 0-365.", lagTime))
            End If
        End If

    End Function

#End Region

End Class
