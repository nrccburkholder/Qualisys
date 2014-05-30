Friend Class HHCAHPSExporter
    Inherits CAHPSExporter

    Protected Overrides Function GetRecodeReader(ByVal rdr As System.Data.IDataReader) As System.Data.IDataReader
        Return New HHCAHPSRecodeReader(rdr)
    End Function


    Protected Overrides Sub WriteXmlHeader(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

        'Read the HDOSL record
        Dim strServiceline As String = reader("determination-of-service-line").ToString

        'Make sure there is another result set
        If Not reader.NextResult Then
            Throw New ExportFileCreationException("The CMS export is missing the header level result set.")
        End If

        'Read the header record
        reader.Read()

        'Collect data for TPS report
        Dim surveyMode As String = reader("survey-mode").ToString
        Dim sampleType As String = reader("sample-type").ToString
        Dim countPatInFile As Integer = CInt(reader("count-patients-in-file"))
        Dim countPatInFileServed As Integer = CInt(reader("count-patients-in-file-served"))
        Dim patientsHHA As Integer = CInt(reader("patients-hha"))
        Dim vendorSubmitted As Integer = CInt(reader("number-vendor-submitted"))
        Dim eligiblePatients As Integer = CInt(reader("number-eligible-patients"))
        Dim numberSampled As Integer = CInt(reader("number-sampled"))

        'Check to see if we have any TPS conditions
        If surveyMode = "" Then
            mTPSReport.AddValue("survey-mode can not be blank")
        ElseIf surveyMode = "5" Then
            mTPSReport.AddValue("survey-mode is custom")
        ElseIf surveyMode <> "1" AndAlso surveyMode <> "2" AndAlso surveyMode <> "3" Then
            mTPSReport.AddValue("survey-mode not equal to 1, 2, or 3")
        End If

        If sampleType <> "1" AndAlso sampleType <> "2" AndAlso sampleType <> "3" Then
            mTPSReport.AddValue("sample-type does not equal 1, 2, or 3")
        End If

        If countPatInFile > 1 Then
            mTPSReport.AddValue("count-patients-in-file is combined")
        End If

        If countPatInFileServed > 1 Then
            mTPSReport.AddValue("count-patients-in-file-served is combined")
        End If

        If patientsHHA <= 0 Then
            mTPSReport.AddValue("patients-hha less then or equal to 0")
        End If

        If vendorSubmitted <= 0 Then
            mTPSReport.AddValue("number-vendor-submitted less then or equal to 0")
        End If

        If eligiblePatients <= 0 Then
            mTPSReport.AddValue("number-eligible-patients less then or equal to 0")
        End If

        If numberSampled <= 0 Then
            mTPSReport.AddValue("number-sampled less then or equal to 0")
        End If


        'Write the start element
        writer.WriteStartElement("header")

        'Write the header section
        writer.WriteElementString("header-type", reader("header-type").ToString)
        writer.WriteElementString("provider-name", reader("provider-name").ToString)
        writer.WriteElementString("provider-id", reader("provider-id").ToString)
        'writer.WriteElementString("npi", reader("npi").ToString)
        writer.WriteElementString("sample-month", reader("sample-month").ToString)
        writer.WriteElementString("sample-yr", reader("sample-yr").ToString)
        writer.WriteElementString("survey-mode", surveyMode)
        writer.WriteElementString("sample-type", sampleType)
        writer.WriteElementString("patients-hha", patientsHHA.ToString)
        writer.WriteElementString("number-vendor-submitted", vendorSubmitted.ToString)
        writer.WriteElementString("number-eligible-patients", eligiblePatients.ToString)
        writer.WriteElementString("number-sampled", numberSampled.ToString)

        'Check for warnings
        If eligiblePatients > vendorSubmitted Then
            'The number of eligible should not be greater than the number of patients
            Dim newRow As ExceptionReportRow = mExceptionReport.AddRow("The column 'number-eligible-patients' should not be greater than the column 'number-vendor-submitted'")
            newRow.Values.Add("number-eligible-patients = " & eligiblePatients.ToString)
            newRow.Values.Add("number-vendor-submitted = " & vendorSubmitted.ToString)
        End If

        If vendorSubmitted > patientsHHA Then
            'The number of patients should not be greater than the number of patients served
            Dim newRow As ExceptionReportRow = mExceptionReport.AddRow("The column 'number-vendor-submitted' should not be greater than the column 'patients-hha'")
            newRow.Values.Add("number-vendor-submitted = " & vendorSubmitted.ToString)
            newRow.Values.Add("patients-hha = " & patientsHHA.ToString)
        End If

        writer.WriteEndElement()

    End Sub

    Protected Overrides Sub WriteXmlAdminElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet))

        'Collect data for TPS report
        Dim patientAge As String = reader("patient-age").ToString
        Dim gender As String = reader("gender").ToString
        Dim language As String = reader("language").ToString
        Dim proxy As String = reader("proxy").ToString
        Dim skilledVisitsString As String = reader("number-visits").ToString
        Dim lbVisitsString As String = reader("lb-visits").ToString
        Dim medicare As String = reader("payer-medicare").ToString
        Dim medicaid As String = reader("payer-medicaid").ToString
        Dim admissionSource1 As String = reader("admission-source-1").ToString
        Dim admissionSource2 As String = reader("admission-source-2").ToString
        Dim admissionSource3 As String = reader("admission-source-3").ToString
        Dim admissionSource4 As String = reader("admission-source-4").ToString
        Dim admissionSource5 As String = reader("admission-source-5").ToString
        Dim admissionSource6 As String = reader("admission-source-6").ToString
        Dim primaryDiagnosis As String = reader("primary-diagnosis").ToString
        Dim adlDeficits As String = reader("adl-deficits").ToString
        Dim adlDu As String = reader("adl-du").ToString
        Dim adlDl As String = reader("adl-dl").ToString
        Dim adlBathing As String = reader("adl-bathing").ToString
        Dim adlToilettransferring As String = reader("adl-toilet-transferring").ToString
        Dim adlTransfer As String = reader("adl-transfer").ToString
        Dim finalStatus As String = reader("final-status").ToString
        Dim requiredQuestionCount As Integer = GetRequiredQuestionCount(reader)
        Dim surveyMode As String = reader("survey-mode").ToString

        'Convert values
        Dim skilledVisits As Integer
        Dim lbVisits As Integer
        If Not Integer.TryParse(skilledVisitsString, skilledVisits) Then
            skilledVisits = 0
        End If
        If Not Integer.TryParse(lbVisitsString, lbVisits) Then 'In case this comes through as 'M' use -1 to indicate not to report number of lookback visits < 2
            lbVisits = -1
        End If

        'Check to see if we have any TPS conditions
        If TrimLeadingZeros(patientAge) = "0" OrElse patientAge = "M" Then mTPSReport.AddValue("patient-age equals 0 or M")

        If gender = "M" Then mTPSReport.AddValue("gender equals M")

        If skilledVisits < 1 Then mTPSReport.AddValue("number of skilled visits < 1")

        If lbVisits > -1 And lbVisits < 2 Then mTPSReport.AddValue("number of lookback visits < 2")

        If medicare = "M" AndAlso medicaid = "M" Then mTPSReport.AddValue("medicare and medicaid equals M")

        If primaryDiagnosis = "M" Then mTPSReport.AddValue("primary diagnosis equals M")

        If admissionSource1 = "M" AndAlso admissionSource2 = "M" AndAlso admissionSource3 = "M" AndAlso admissionSource4 = "M" AndAlso admissionSource5 = "M" AndAlso admissionSource6 = "M" Then
            mTPSReport.AddValue("all 6 admission source fields equal M")
        End If

        If adlDeficits = "M" AndAlso adlDu = "M" AndAlso adlDl = "M" AndAlso adlBathing = "M" AndAlso adlToilettransferring = "M" AndAlso adlTransfer = "M" Then
            mTPSReport.AddValue("all 7 adl fields equal M")
        End If

        If (finalStatus = "110" OrElse finalStatus = "120" OrElse finalStatus = "310") AndAlso language = "M" Then
            mTPSReport.AddValue("final-status equals 110, 120, or 310 and language is missing")
        End If

        If (finalStatus = "110" OrElse finalStatus = "120" OrElse finalStatus = "310") AndAlso proxy = "M" Then
            mTPSReport.AddValue("final-status equals 110, 120, or 310 and proxy is missing")
        End If

        If (finalStatus = "110" OrElse finalStatus = "120") AndAlso requiredQuestionCount < 10 Then
            mTPSReport.AddValue("final-status equals 110 or 120 and less than 10 required questions answered")
        End If

        If (finalStatus = "110" AndAlso surveyMode <> "1") OrElse (finalStatus = "120" AndAlso surveyMode <> "2") Then
            mTPSReport.AddValue("final-status doesn't match the survey-mode.")
        End If


        'Write the start element
        writer.WriteStartElement("administration")

        'Write the admin information
        writer.WriteElementString("provider-id", reader("provider-id").ToString)
        'writer.WriteElementString("npi", reader("npi").ToString)
        writer.WriteElementString("sample-month", reader("sample-month").ToString)
        writer.WriteElementString("sample-yr", reader("sample-yr").ToString)
        writer.WriteElementString("sample-id", reader("sample-id").ToString)
        writer.WriteElementString("patient-age", patientAge)
        writer.WriteElementString("gender", gender)
        writer.WriteElementString("number-visits", skilledVisitsString)
        writer.WriteElementString("lb-visits", lbVisitsString)
        writer.WriteElementString("admission-source-1", admissionSource1)
        writer.WriteElementString("admission-source-2", admissionSource2)
        writer.WriteElementString("admission-source-3", admissionSource3)
        writer.WriteElementString("admission-source-4", admissionSource4)
        writer.WriteElementString("admission-source-5", admissionSource5)
        writer.WriteElementString("admission-source-6", admissionSource6)
        writer.WriteElementString("payer-medicare", medicare)
        writer.WriteElementString("payer-medicaid", medicaid)
        writer.WriteElementString("payer-private", reader("payer-private").ToString)
        writer.WriteElementString("payer-other", reader("payer-other").ToString)
        writer.WriteElementString("hmo-enrollee", reader("hmo-enrollee").ToString)
        writer.WriteElementString("dual-eligible", reader("dual-eligible").ToString)
        writer.WriteElementString("primary-diagnosis", primaryDiagnosis)
        writer.WriteElementString("other-diagnosis-1", reader("other-diagnosis-1").ToString)
        writer.WriteElementString("other-diagnosis-2", reader("other-diagnosis-2").ToString)
        writer.WriteElementString("other-diagnosis-3", reader("other-diagnosis-3").ToString)
        writer.WriteElementString("other-diagnosis-4", reader("other-diagnosis-4").ToString)
        writer.WriteElementString("other-diagnosis-5", reader("other-diagnosis-5").ToString)
        writer.WriteElementString("surgical-discharge", reader("surgical-discharge").ToString)
        writer.WriteElementString("esrd", reader("esrd").ToString)
        writer.WriteElementString("adl-deficits", adlDeficits)
        writer.WriteElementString("adl-du", adlDu)
        writer.WriteElementString("adl-dl", adlDl)
        writer.WriteElementString("adl-bathing", adlBathing)
        writer.WriteElementString("adl-toilet-transferring", adlToilettransferring)
        writer.WriteElementString("adl-transfer", adlTransfer)
        writer.WriteElementString("final-status", finalStatus)
        writer.WriteElementString("language", language)
        writer.WriteElementString("proxy", proxy)

        'Write the end element
        writer.WriteEndElement()

        'Save the sampleset
        Dim sampleSetId As Integer = CType(reader("SampSet"), Integer)
        If Not sampleSets.ContainsKey(sampleSetId) Then
            sampleSets.Add(sampleSetId, SampleSet.GetSampleSet(sampleSetId))
        End If

    End Sub

    Protected Overrides Sub WriteXmlResponseElement(ByVal reader As System.Data.IDataReader, ByVal writer As System.Xml.XmlTextWriter)

        writer.WriteElementString("confirm-care", reader("confirm-care").ToString)
        writer.WriteElementString("what-care-get", reader("what-care-get").ToString)
        writer.WriteElementString("how-set-up-home", reader("how-set-up-home").ToString)
        writer.WriteElementString("talk-about-meds", reader("talk-about-meds").ToString)
        writer.WriteElementString("see-meds", reader("see-meds").ToString)
        writer.WriteElementString("nurse-provider", reader("nurse-provider").ToString)
        writer.WriteElementString("phys-occ-sp-ther", reader("phys-occ-sp-ther").ToString)
        writer.WriteElementString("personal-care", reader("personal-care").ToString)
        writer.WriteElementString("informed-up-to-date", reader("informed-up-to-date").ToString)
        writer.WriteElementString("talk-about-pain", reader("talk-about-pain").ToString)
        writer.WriteElementString("take-newmeds", reader("take-newmeds").ToString)
        writer.WriteElementString("talk-about-newmeds", reader("talk-about-newmeds").ToString)
        writer.WriteElementString("when-take-meds", reader("when-take-meds").ToString)
        writer.WriteElementString("med-side-effects", reader("med-side-effects").ToString)
        writer.WriteElementString("when-arrive", reader("when-arrive").ToString)
        writer.WriteElementString("treat-gently", reader("treat-gently").ToString)
        writer.WriteElementString("explain-things", reader("explain-things").ToString)
        writer.WriteElementString("listen-carefully", reader("listen-carefully").ToString)
        writer.WriteElementString("courtesy-respect", reader("courtesy-respect").ToString)
        writer.WriteElementString("rate-care", reader("rate-care").ToString)
        writer.WriteElementString("contact-office-screener", reader("contact-office-screener").ToString)
        writer.WriteElementString("get-help-needed", reader("get-help-needed").ToString)
        writer.WriteElementString("how-long-help-afterhours", reader("how-long-help-afterhours").ToString)
        writer.WriteElementString("problems-with-care-screener", reader("problems-with-care-screener").ToString)
        writer.WriteElementString("recommend", reader("recommend").ToString)
        writer.WriteElementString("overall-health", reader("overall-health").ToString)
        writer.WriteElementString("mental-health", reader("mental-health").ToString)
        writer.WriteElementString("live", reader("live").ToString)
        writer.WriteElementString("education", reader("education").ToString)
        writer.WriteElementString("ethnicity", reader("ethnicity").ToString)
        writer.WriteElementString("race-white", reader("race-white").ToString)
        writer.WriteElementString("race-african-amer", reader("race-african-amer").ToString)
        writer.WriteElementString("race-asian", reader("race-asian").ToString)
        writer.WriteElementString("race-native-hawaiian", reader("race-native-hawaiian").ToString)
        writer.WriteElementString("race-amer-indian", reader("race-amer-indian").ToString)
        writer.WriteElementString("language", reader("language-resp").ToString)
        writer.WriteElementString("help-you", reader("help-you").ToString)
        writer.WriteElementString("help-read", reader("help-read").ToString)
        writer.WriteElementString("help-wrote", reader("help-wrote").ToString)
        writer.WriteElementString("help-answer", reader("help-answer").ToString)
        writer.WriteElementString("help-translate", reader("help-translate").ToString)
        writer.WriteElementString("help-other", reader("help-other").ToString)
        writer.WriteElementString("help-none", reader("help-none").ToString)

    End Sub

    Protected Overrides Function GetRequiredQuestionCount(ByVal reader As IDataReader) As Integer

        Dim quantity As Integer = 0
        Dim requiredQuestions As String() = {"confirm-care", "what-care-get", "how-set-up-home", "talk-about-meds", "see-meds", "nurse-provider", _
                "phys-occ-sp-ther", "personal-care", "informed-up-to-date", "talk-about-pain", "take-newmeds", "talk-about-newmeds", _
                "when-arrive", "treat-gently", "explain-things", "listen-carefully", "courtesy-respect", "rate-care", _
                "contact-office-screener", "problems-with-care-screener", "recommend", "overall-health", "mental-health", _
                "live", "education", "ethnicity", "language", "help-you"}

        For Each column As String In requiredQuestions
            Dim value As Object = reader(column)
            If value IsNot DBNull.Value AndAlso value.ToString <> "M" Then
                quantity += 1
            End If
        Next

        Return quantity

    End Function

#Region " CMS Summary File Methods "

    Protected Overrides Sub CreateCmsSummaryFile(ByVal cmsFilePath As String, ByVal exportType As ExportSetType)

        Dim freqs As FrequencyTable = GetCmsFileFrequencies(cmsFilePath, exportType)
        Dim summaryPath As String = IO.Path.ChangeExtension(cmsFilePath, ".summary.html")
        Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

        Using writer As New IO.StreamWriter(summaryPath, False)
            WriteCmsSummaryHtml(freqs, writer, fileName, exportType)
        End Using

    End Sub

    Protected Overrides Sub WriteCmsSummaryHtml(ByVal freqTable As CAHPSExporter.FrequencyTable, ByVal writer As System.IO.TextWriter, ByVal fileName As String, ByVal exportType As ExportSetType)

        'Create the report styles and header row
        writer.WriteLine("<html>")
        writer.WriteLine("<head>")
        writer.WriteLine("<STYLE>.NotifyTable {FONT-SIZE: x-small; FONT-FAMILY: Tahoma, Verdana, Arial; BACKGROUND-COLOR: White;}")
        writer.WriteLine(".HeaderCell {PADDING: 2px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #ffffff; TEXT-ALIGN: center; BACKGROUND-COLOR: #64006E; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".NormalCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #C873FF; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".WarningCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: Red; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".FieldCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; BACKGROUND-COLOR: #AF4BFF; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".Title {FONT-SIZE: medium; FONT-WEIGHT: bold;}")
        writer.WriteLine("</STYLE>")
        writer.WriteLine("</head>")
        writer.WriteLine("<body>")
        writer.WriteLine(String.Format("<div class='Title'>Export Summary for {0}</div>", fileName))
        writer.WriteLine("<div style='font-size: xx-small;'><i>{0}</i></div>", Date.Now.ToString)
        writer.WriteLine("<table class='NotifyTable'>")
        writer.WriteLine("<tr><td class='HeaderCell'>Field Name</td><td class='HeaderCell'>Value</td><td class='HeaderCell'>Count</td><td class='HeaderCell'>Percentage</td></tr>")

        WriteCmsInnerHtml(freqTable, writer, fileName, exportType)

        'Finish up the report HTML
        writer.WriteLine("</table>")
        writer.WriteLine("</body>")
        writer.WriteLine("</html>")

    End Sub

    Protected Overridable Sub WriteCmsInnerHtml(ByVal freqTable As CAHPSExporter.FrequencyTable, ByVal writer As System.IO.TextWriter, ByVal fileName As String, ByVal exportType As ExportSetType)
        'Write contents of report
        WriteCmsSummaryRow(freqTable, writer, "patients-hha")
        WriteCmsSummaryRow(freqTable, writer, "number-vendor-submitted")
        WriteCmsSummaryRow(freqTable, writer, "number-eligible-patients")

        WriteCmsSummaryRow(freqTable, writer, "Patient Responses")

        'Summarize lag time and then write it
        'SummarizeLagTimeFreqs(freqTable)

        WriteCmsSummaryRow(freqTable, writer, "sample-yr")
        WriteCmsSummaryRow(freqTable, writer, "sample-month")
        WriteCmsSummaryRow(freqTable, writer, "final-status", True, "M")
        WriteCmsSummaryRow(freqTable, writer, "language")
        WriteCmsSummaryRow(freqTable, writer, "gender", True, "M")
        WriteCmsSummaryRow(freqTable, writer, "patient-age", True, "M")
    End Sub


    Protected Overrides Function GetCmsFileFrequencies(ByVal cmsFilePath As String, ByVal exportType As ExportSetType) As FrequencyTable

        Dim freqs As New FrequencyTable
        Dim settings As New Xml.XmlReaderSettings

        settings.IgnoreWhitespace = True

        Using stream As New IO.StreamReader(cmsFilePath)
            Using rdr As Xml.XmlReader = Xml.XmlReader.Create(stream, settings)
                'Jump to root node
                rdr.MoveToContent()

                'Read in the <montlyData> node
                rdr.Read()

                Dim doc As New Xml.XmlDocument
                Dim node As Xml.XmlNode
                Dim adminNode As Xml.XmlNode

                'Read the <header> node
                node = doc.ReadNode(rdr)

                freqs.AddValue("patients-hha", node.Item("patients-hha").InnerText)
                freqs.AddValue("number-vendor-submitted", node.Item("number-vendor-submitted").InnerText)
                freqs.AddValue("number-eligible-patients", node.Item("number-eligible-patients").InnerText)

                'Read through all the <patientleveldata> nodes
                Dim depth As Integer = rdr.Depth
                While rdr.Depth = depth
                    'read in the next <patientleveldata> node
                    node = doc.ReadNode(rdr)

                    'get the <administration> node
                    adminNode = node.ChildNodes(0)

                    'Count returns/non-returns
                    If node.ChildNodes.Count = 2 Then
                        freqs.AddValue("Patient Responses", "Respondents")
                    Else
                        freqs.AddValue("Patient Responses", "Non-Respondents")
                    End If

                    'Count up the frequencies
                    freqs.AddValue("sample-yr", adminNode.Item("sample-yr").InnerText)
                    freqs.AddValue("sample-month", adminNode.Item("sample-month").InnerText)
                    freqs.AddValue("final-status", adminNode.Item("final-status").InnerText)
                    freqs.AddValue("language", adminNode.Item("language").InnerText)
                    freqs.AddValue("gender", adminNode.Item("gender").InnerText)
                    freqs.AddValue("patient-age", adminNode.Item("patient-age").InnerText)
                End While

            End Using
        End Using

        'return the frequency table
        Return freqs

    End Function
#End Region

End Class
