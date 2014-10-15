Friend Class ACOCAHPSExporter
    Inherits HHCAHPSExporter

    ''' <summary>
    ''' Constants
    ''' </summary>
    ''' <remarks>Some constants perform a simple mapping (YES = "1 "), others just substitute directly (_88 = "88")</remarks>
    Dim ZERO As String = "0 "
    Dim YES As String = "1 "
    Dim NO As String = "2 "
    Dim NA As String = "  "
    Dim _98 As String = "98"
    Dim _99 As String = "99"
    Dim _88 As String = "88"
    Dim _M As String = "M "

    ''' <summary>
    ''' Integer enum mapping Question Reponse to integer slot in the Qs array
    ''' </summary>
    ''' <remarks>Q01 naming convention follows ACO response data nomenclature</remarks>
    Enum QMap
        Q01 = 0
        Q02 = 1
        Q03 = 2
        Q04 = 3
        Q05 = 4
        Q06 = 5
        Q07 = 6
        Q08 = 7
        Q09 = 8
        Q10 = 9
        Q11 = 10
        Q12 = 11
        Q13 = 12
        Q14 = 13
        Q15 = 14
        Q16 = 15
        Q17 = 16
        Q18 = 17
        Q19 = 18
        Q20 = 19
        Q21 = 20
        Q22 = 21
        Q23 = 22
        Q24 = 23
        Q25 = 24
        Q26 = 25
        Q27 = 26
        Q28 = 27
        Q29 = 28
        Q30 = 29
        Q31 = 30
        Q32 = 31
        Q33 = 32
        Q34 = 33
        Q35 = 34
        Q36 = 35
        Q37 = 36
        Q38 = 37
        Q39 = 38
        Q40 = 39
        Q41 = 40
        Q42 = 41
        Q43 = 42
        Q44 = 43
        Q45 = 44
        Q46 = 45
        Q47 = 46
        Q48 = 47
        Q49 = 48
        Q50 = 49
        Q51 = 50
        Q52 = 51
        Q53 = 52
        Q54 = 53
        Q55 = 54
        Q56 = 55
        Q57a = 56
        Q57b = 57
        Q57c = 58
        Q58 = 59
        Q59 = 60
        Q60 = 61
        Q61 = 62
        Q62 = 63
        Q63 = 64
        Q64 = 65
        Q65 = 66
        Q66 = 67
        Q67 = 68
        Q68 = 69
        Q69 = 70
        Q70 = 71
        Q71 = 72
        Q72 = 73
        Q73 = 74
        Q74 = 75
        Q75 = 76
        Q76 = 77
        Q77 = 78
        Q78 = 79
        Q79a = 80
        Q79b = 81
        Q79c = 82
        Q79d = 83
        Q79d1 = 84
        Q79d2 = 85
        Q79d3 = 86
        Q79d4 = 87
        Q79d5 = 88
        Q79d6 = 89
        Q79d7 = 90
        Q79e = 91
        Q79e1 = 92
        Q79e2 = 93
        Q79e3 = 94
        Q79e4 = 95
        Q80 = 96
        Q81a = 97
        Q81b = 98
        Q81c = 99
        Q81d = 100
        Q81e = 101
    End Enum

    Dim SummaryInfo As List(Of String) = New List(Of String)
    Dim freqs As New FrequencyTable

    ''' <summary>
    ''' Manages the ACO CAHPS export file creation of a single file containing 1 to many surveys
    ''' </summary>
    ''' <param name="ACOCAHPSExportSets">Each set represents a survey</param>
    ''' <param name="filePath">Folder location for the output file</param>
    ''' <param name="fileType"></param>
    ''' <param name="isScheduledExport"></param>
    ''' <param name="isInterimFile">Indicator of whether this export is interim, stored in the export file log</param>
    ''' <returns>Failed Count</returns>
    ''' <remarks>One to many surveys are passed in here, and each one is sent, record by record to the RecodeAndWriteExportFile method
    ''' Two exceptions are reported at this (summary) level: no records found for the given time period, and duplicate finder id for records in a 
    ''' single survey</remarks>
    Friend Overrides Function CreateExportFile(ByVal ACOCAHPSExportSets As System.Collections.ObjectModel.Collection(Of ExportSet), _
                                             ByVal filePath As String, ByVal fileType As ExportFileType, _
                                             ByVal isScheduledExport As Boolean, ByVal isInterimFile As Boolean) As Integer

        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim exportSuccessful As Boolean
        Dim errorMessage As String = String.Empty
        Dim stackTrace As String = String.Empty
        Dim newId As Integer = 0
        Dim exportSetIds As New List(Of Integer)
        Dim failedCount As Integer = 0
        Dim encoding As System.Text.Encoding = New System.Text.UTF8Encoding(False)
        mExceptionReport = New ExceptionReport()

        'Build the list of ExportSet IDs
        For Each export As ExportSet In ACOCAHPSExportSets
            exportSetIds.Add(export.Id)
        Next

        Try
            Using stream As New IO.StreamWriter(filePath, False, encoding)
                For Each acoCAHPSExportSet As ExportSet In ACOCAHPSExportSets
                    Dim htFinder As Hashtable = New Hashtable()

                    SummaryInfo.Add(acoCAHPSExportSet.Name & "(" & acoCAHPSExportSet.SurveyId & ") for dates " & acoCAHPSExportSet.StartDate & " to " & acoCAHPSExportSet.EndDate)
                    For Each acoCAHPSExport As ACOCAHPSExport In DataProvider.Instance.SelectAllACOCAHPSBySurveyID(acoCAHPSExportSet.SurveyId, acoCAHPSExportSet.StartDate, acoCAHPSExportSet.EndDate)
                        RecodeAndWriteExportFile(stream, acoCAHPSExport, acoCAHPSExport.SurveyId)
                        Try
                            htFinder.Add(acoCAHPSExport.Finder, "existing")
                        Catch
                            Dim newRow As ExceptionReportRow = mExceptionReport.AddRow("Duplicate Finder numbers found")
                            newRow.Values.Add(String.Format("{0}({1}) Finder: {2} is a Duplicate", acoCAHPSExportSet.Name, acoCAHPSExportSet.SurveyId.ToString(), acoCAHPSExport.Finder))
                        End Try
                        recordCount += 1
                    Next
                    If recordCount = 0 Then
                        Dim newRow As ExceptionReportRow = mExceptionReport.AddRow("Selected survey and time period had no records")
                        newRow.Values.Add(String.Format("{0} {1} had no records", acoCAHPSExportSet.Name, acoCAHPSExportSet.SurveyId.ToString()))
                        '	0 records found for survey in selection list
                    End If
                Next
                exportSuccessful = mExceptionReport.Count = 0
            End Using

            'Write the summary report (have to look elsewhere for frequencies than in an XML file...)
            CreateCmsSummaryFile(filePath, mExportType)

            'Write the exception report
            CreateCmsExceptionFile(filePath)

        Catch ex As Exception
            exportSuccessful = False
            errorMessage = ex.Message
            stackTrace = ex.ToString

        Finally
            Dim tpsPath As String = String.Empty
            Dim summaryPath As String = String.Empty
            Dim exceptionPath As String = String.Empty

            If exportSuccessful Then
                'Insert the success record into the ExportFile log
                If IO.File.Exists(IO.Path.ChangeExtension(filePath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filePath, ".summary.html")
                newId = DataProvider.Instance.InsertExportFile(recordCount, CurrentUser.UserName, filePath, filePartCount, fileType, New Guid(), False, False, isScheduledExport, True, "", "", isScheduledExport, tpsPath, summaryPath, exceptionPath, isInterimFile)
            Else
                'Insert the failure record into the ExportFile log
                MoveErrorFile(filePath)
                filePath = String.Format("{0}\ExportErrors\{1}", IO.Path.GetDirectoryName(filePath), IO.Path.GetFileName(filePath))

                If Not IO.File.Exists(filePath) Then filePath = String.Empty
                If IO.File.Exists(IO.Path.ChangeExtension(filePath, ".tps.html")) Then tpsPath = IO.Path.ChangeExtension(filePath, ".tps.html")
                If IO.File.Exists(IO.Path.ChangeExtension(filePath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filePath, ".summary.html")
                If IO.File.Exists(IO.Path.ChangeExtension(filePath, ".exception.html")) Then exceptionPath = IO.Path.ChangeExtension(filePath, ".exception.html")

                newId = DataProvider.Instance.InsertExportFile(0, CurrentUser.UserName, filePath, 0, fileType, New Guid(), False, False, isScheduledExport, False, errorMessage, stackTrace, isScheduledExport, tpsPath, summaryPath, exceptionPath, isInterimFile)
                failedCount += 1
            End If

            'Insert the export sets for the export file
            For Each id As Integer In exportSetIds
                DataProvider.Instance.InsertExportFileExportSet(id, newId)
            Next
        End Try

        Return failedCount

    End Function

    ''' <summary>
    ''' This is where summary rows go in the summary.html report
    ''' </summary>
    ''' <param name="freqTable">Where frequencies are found</param>
    ''' <param name="writer">Output stream</param>
    ''' <param name="fileName"></param>
    ''' <param name="exportType"></param>
    ''' <remarks>This is where the requested frequencies and cross-tabs go</remarks>
    Protected Overrides Sub WriteCmsInnerHtml(ByVal freqTable As CAHPSExporter.FrequencyTable, ByVal writer As System.IO.TextWriter, ByVal fileName As String, ByVal exportType As ExportSetType)
        'Retrieve ACO_ID & Disposition, ACO_ID & Mode, ACO_ID & Language from freqTable
        writer.WriteLine("<BR>")

        For Each summary As String In Me.SummaryInfo
            writer.WriteLine("<div style='font-size: xx-small;'>" & summary & "</div>")
        Next

        If freqTable.ContainsKey("ACO_ID") Then
            WriteCmsSummaryRow(freqTable, writer, "ACO_ID")
        End If
        If freqTable.ContainsKey("ACO_ID & Disposition") Then
            WriteCmsSummaryRow(freqTable, writer, "ACO_ID & Disposition")
        End If
        If freqTable.ContainsKey("ACO_ID & Mode") Then
            WriteCmsSummaryRow(freqTable, writer, "ACO_ID & Mode")
        End If
        If freqTable.ContainsKey("ACO_ID & Language") Then
            WriteCmsSummaryRow(freqTable, writer, "ACO_ID & Language")
        End If
    End Sub


    ''' <summary>
    ''' Get the store of frequencies to be reported on
    ''' </summary>
    ''' <param name="cmsFilePath"></param>
    ''' <param name="exportType"></param>
    ''' <returns>Frequencies</returns>
    ''' <remarks>In this case, we preferred to maintain a frequency table class variable to accumulate the frequencies and just pass it back</remarks>
    Protected Overrides Function GetCmsFileFrequencies(ByVal cmsFilePath As String, ByVal exportType As ExportSetType) As FrequencyTable
        'freqs.AddValue("ACO_ID", "frequency of ACO_ID")
        'freqs.AddValue("ACO_ID & Disposition", "X-Tab of ACO_ID & Disposition")
        'freqs.AddValue("ACO_ID & Mode", "X-Tab of ACO_ID & Mode")
        'freqs.AddValue("ACO_ID & Language", "X-Tab of ACO_ID & Language")
        Return freqs
    End Function


    ''' <summary>
    ''' Set88Step2 is a component of Step88 broken out
    ''' </summary>
    ''' <param name="Qs">Question array</param>
    ''' <param name="target">Child of skip relationahip</param>
    ''' <param name="driver">Parent of skip relationship</param>
    ''' <param name="checkVal">Value to check for skip logic enforcement</param>
    ''' <param name="dontSkipFor98and99">Switch to turn off Skip processing on 98 and 99</param>
    ''' <remarks>When both are called it comes after Set88Step1</remarks>
    Private Sub Set88step2(ByRef Qs As List(Of String), ByVal target As Integer, ByVal driver As Integer, ByVal checkVal As String, Optional ByVal dontSkipFor98and99 As Boolean = False)
        If dontSkipFor98and99 Then
            If (Qs(target).ToString = _M) And (Qs(driver).ToString = checkVal) Then
                Qs(target) = _88
            End If
        Else
            If ((Qs(target).ToString = _98) Or (Qs(target).ToString = _99) _
            Or (Qs(target).ToString = _M)) And (Qs(driver).ToString = checkVal) Then
                Qs(target) = _88
            End If
        End If
    End Sub

    ''' <summary>
    ''' Set88Step1 is a component of Step88 broken out
    ''' </summary>
    ''' <param name="Qs">Question array</param>
    ''' <param name="target">Child of skip relationahip</param>
    ''' <param name="driver">Parent of skip relationship</param>
    ''' <remarks>When both are called it comes before Set88Step2</remarks>
    Private Sub Set88Step1(ByRef Qs As List(Of String), ByVal target As Integer, ByVal driver As Integer)
        If (Qs(driver).ToString = _98) Or (Qs(driver).ToString = _99) Then
            Qs(target) = _88
        End If
    End Sub

    ''' <summary>
    ''' Set88 is a utility method to perform basic skip logic functionality
    ''' </summary>
    ''' <param name="Qs">Question array</param>
    ''' <param name="target">Child of skip relationahip</param>
    ''' <param name="driver">Parent of skip relationship</param>
    ''' <param name="checkVal">Value to check for skip logic enforcement</param>
    ''' <param name="dontSkipFor98and99">Switch to turn off Skip processing on 98 and 99</param>
    ''' <remarks></remarks>
    Private Sub Set88(ByRef Qs As List(Of String), ByVal target As Integer, ByVal driver As Integer, ByVal checkVal As String, Optional ByVal dontSkipFor98and99 As Boolean = False)
        If (Qs(driver).ToString = NO) Then
            Qs(target) = NA
        End If

        Set88Step1(Qs, target, driver)

        Set88step2(Qs, target, driver, checkVal, dontSkipFor98and99)
    End Sub

    ''' <summary>
    ''' The workhorse which enforces skip patterns, validation, and writes out the formatted record
    ''' </summary>
    ''' <param name="stream">Output file</param>
    ''' <param name="acoCAHPSExport">Individual record to recode, validate, and write</param>
    ''' <param name="Survey_Id">Survey Id to report for exceptions</param>
    ''' <remarks>This is an evolutionary step forward from the original temporary method of reporting ACO CAHPS results using SPs.
    ''' Dave Gilsdorf deserves credit for crafting and enforcing the skip logic in his SPs which was duplicated here.
    ''' Dave G's original stored procedures: ACOCAHPSFinalSubmissionFile, ACOCAHPSInterimSubmissionFile
    ''' The new stored procedure: DCL_SelectACOCAHPSBySurveyId
    ''' The original stored procedures may be used for side by side comparisons of the output files as a testing exercise</remarks>
    Private Sub RecodeAndWriteExportFile(ByVal stream As IO.StreamWriter, ByVal acoCAHPSExport As ACOCAHPSExport, ByVal Survey_Id As Integer)
        For i As Integer = acoCAHPSExport.Qs.Count - 1 To 0 Step -1
            If (acoCAHPSExport.Qs(i).ToString = "-8") Or (acoCAHPSExport.Qs(i).ToString = "-9") Then
                acoCAHPSExport.Qs(i) = _M
            End If
            If (acoCAHPSExport.Qs(i).ToString = "-6") Then
                acoCAHPSExport.Qs(i) = _98
            End If
            If (acoCAHPSExport.Qs(i).ToString = "-5") Then
                acoCAHPSExport.Qs(i) = _99
            End If
        Next

        '-- Q80(2) skips to end 
        Set88(acoCAHPSExport.Qs, QMap.Q81a, QMap.Q80, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q81b, QMap.Q80, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q81c, QMap.Q80, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q81d, QMap.Q80, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q81e, QMap.Q80, NO)

        '-- Q79e(2) skips to Q80 (only asked on the phone survey)
        Set88(acoCAHPSExport.Qs, QMap.Q79e1, QMap.Q79e, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79e2, QMap.Q79e, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79e3, QMap.Q79e, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79e4, QMap.Q79e, NO)

        '-- Q79d(2) skips to Q79e (only asked on the phone survey)
        Set88(acoCAHPSExport.Qs, QMap.Q79d1, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d2, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d3, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d4, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d5, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d6, QMap.Q79d, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q79d7, QMap.Q79d, NO)

        '-- Q77(2) skips to Q79
        Set88(acoCAHPSExport.Qs, QMap.Q78, QMap.Q77, NO)

        '-- Q69(2) skips to Q71
        Set88(acoCAHPSExport.Qs, QMap.Q70, QMap.Q69, NO)

        '-- Q62(2) skips to Q64
        Set88(acoCAHPSExport.Qs, QMap.Q63, QMap.Q62, NO)

        '-- Q60(2) skips to Q62
        Set88(acoCAHPSExport.Qs, QMap.Q61, QMap.Q60, NO)

        '-- Q52(2) skips to Q55
        Set88(acoCAHPSExport.Qs, QMap.Q53, QMap.Q52, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q54, QMap.Q52, NO)

        '-- Q45(2) skips to Q48
        Set88(acoCAHPSExport.Qs, QMap.Q46, QMap.Q45, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q47, QMap.Q45, NO)

        '-- Q44(1) skips to Q48 (and don't know/refused DON'T)
        Set88(acoCAHPSExport.Qs, QMap.Q45, QMap.Q44, YES, True)
        Set88(acoCAHPSExport.Qs, QMap.Q46, QMap.Q44, YES, True)
        Set88(acoCAHPSExport.Qs, QMap.Q47, QMap.Q44, YES, True)

        '-- Q35(2) skips to Q39
        Set88(acoCAHPSExport.Qs, QMap.Q36, QMap.Q35, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q37, QMap.Q35, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q38, QMap.Q35, NO)

        '-- Q32(2) skips to Q34
        Set88(acoCAHPSExport.Qs, QMap.Q33, QMap.Q32, NO)

        '-- Q30(2) skips to Q35
        Set88(acoCAHPSExport.Qs, QMap.Q31, QMap.Q30, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q32, QMap.Q30, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q33, QMap.Q30, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q34, QMap.Q30, NO)

        '-- Q26(2) skips to Q35
        Set88(acoCAHPSExport.Qs, QMap.Q27, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q28, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q29, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q30, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q31, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q32, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q33, QMap.Q26, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q34, QMap.Q26, NO)

        '-- Q24(2) skips to Q26
        Set88(acoCAHPSExport.Qs, QMap.Q25, QMap.Q24, NO)

        '-- Q18(2) skips to Q20
        Set88(acoCAHPSExport.Qs, QMap.Q19, QMap.Q18, NO)

        '-- Q13(2) skips to Q15
        Set88(acoCAHPSExport.Qs, QMap.Q14, QMap.Q13, NO)

        '-- Q11(2) skips to Q13
        Set88(acoCAHPSExport.Qs, QMap.Q12, QMap.Q11, NO)

        '-- Q09(2) skips to Q11
        Set88(acoCAHPSExport.Qs, QMap.Q10, QMap.Q09, NO)

        '-- Q07(2) skips to Q09
        Set88(acoCAHPSExport.Qs, QMap.Q08, QMap.Q07, NO)

        '-- Q05(2) skips to q07
        Set88(acoCAHPSExport.Qs, QMap.Q06, QMap.Q05, NO)

        '-- Q04(0) skips to q44
        Set88(acoCAHPSExport.Qs, QMap.Q05, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q06, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q07, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q08, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q09, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q10, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q11, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q12, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q13, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q14, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q15, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q16, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q17, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q18, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q19, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q20, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q21, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q22, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q23, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q24, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q25, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q26, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q27, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q28, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q29, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q30, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q31, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q32, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q33, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q34, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q35, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q36, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q37, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q38, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q39, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q40, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q41, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q42, QMap.Q04, ZERO)
        Set88(acoCAHPSExport.Qs, QMap.Q43, QMap.Q04, ZERO)

        '-- Q01(2) skips to Q44
        Set88(acoCAHPSExport.Qs, QMap.Q02, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q03, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q04, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q05, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q06, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q07, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q08, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q09, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q10, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q11, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q12, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q13, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q14, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q15, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q16, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q17, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q18, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q19, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q20, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q21, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q22, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q23, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q24, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q25, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q26, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q27, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q28, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q29, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q30, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q31, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q32, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q33, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q34, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q35, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q36, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q37, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q38, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q39, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q40, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q41, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q42, QMap.Q01, NO)
        Set88(acoCAHPSExport.Qs, QMap.Q43, QMap.Q01, NO)

        '-- •	Race Question, Mail return:
        '--	o	If selected >= 1 item, code items not selected as “2” (No)
        '--	o	If selected 0 items, code all “M” (Missing)
        If (Trim(acoCAHPSExport.Qs(QMap.Q79a).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79b).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79c).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d1).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d2).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d3).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d4).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d5).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d6).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79d7).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79e1).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79e2).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79e3).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q79e4).ToString()) = Trim(YES)) Then
            acoCAHPSExport.Qs(QMap.Q79a) = IIf(acoCAHPSExport.Qs(QMap.Q79a).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79b) = IIf(acoCAHPSExport.Qs(QMap.Q79b).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79c) = IIf(acoCAHPSExport.Qs(QMap.Q79c).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d1) = IIf(acoCAHPSExport.Qs(QMap.Q79d1).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d2) = IIf(acoCAHPSExport.Qs(QMap.Q79d2).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d3) = IIf(acoCAHPSExport.Qs(QMap.Q79d3).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d4) = IIf(acoCAHPSExport.Qs(QMap.Q79d4).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d5) = IIf(acoCAHPSExport.Qs(QMap.Q79d5).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d6) = IIf(acoCAHPSExport.Qs(QMap.Q79d6).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79d7) = IIf(acoCAHPSExport.Qs(QMap.Q79d7).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79e1) = IIf(acoCAHPSExport.Qs(QMap.Q79e1).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79e2) = IIf(acoCAHPSExport.Qs(QMap.Q79e2).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79e3) = IIf(acoCAHPSExport.Qs(QMap.Q79e3).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q79e4) = IIf(acoCAHPSExport.Qs(QMap.Q79e4).ToString() = _M, NO, YES).ToString()
        End If

        '-- and let's do the same for the how you helped question. why not?
        If (Trim(acoCAHPSExport.Qs(QMap.Q81a).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q81b).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q81c).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q81d).ToString()) = Trim(YES)) Or _
           (Trim(acoCAHPSExport.Qs(QMap.Q81e).ToString()) = Trim(YES)) Then
            acoCAHPSExport.Qs(QMap.Q81a) = IIf(acoCAHPSExport.Qs(QMap.Q81a).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q81b) = IIf(acoCAHPSExport.Qs(QMap.Q81b).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q81c) = IIf(acoCAHPSExport.Qs(QMap.Q81c).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q81d) = IIf(acoCAHPSExport.Qs(QMap.Q81d).ToString() = _M, NO, YES).ToString()
            acoCAHPSExport.Qs(QMap.Q81e) = IIf(acoCAHPSExport.Qs(QMap.Q81e).ToString() = _M, NO, YES).ToString()
        End If

        '	Record has dispo 10, 31, or 34, but has no results
        If ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31")) Then ' Removed for blank surveys per Dana: Or (acoCAHPSExport.Dispositn = "34")) Then
            Dim iQuestion As Integer = 0
            While iQuestion < acoCAHPSExport.Qs.Count
                If String.IsNullOrEmpty(acoCAHPSExport.Qs(iQuestion)) Or acoCAHPSExport.Qs(iQuestion) = _M Then
                    iQuestion += 1
                Else
                    iQuestion = acoCAHPSExport.Qs.Count + 1
                End If
            End While
            If iQuestion = acoCAHPSExport.Qs.Count Then 'we found only null or empty strings
                LogValidationException(acoCAHPSExport, "Return disposition has no results")
            End If
        End If

        '	Record has dispo not in 10, 31, or 34, and has results
        If Not ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) Then
            Dim iQuestion As Integer = 0
            While iQuestion < acoCAHPSExport.Qs.Count
                If String.IsNullOrEmpty(acoCAHPSExport.Qs(iQuestion)) Or acoCAHPSExport.Qs(iQuestion) = _M Then
                    iQuestion = acoCAHPSExport.Qs.Count + 1
                Else
                    iQuestion += 1
                End If
            End While
            If iQuestion = acoCAHPSExport.Qs.Count Then 'we found only null or empty strings
                LogValidationException(acoCAHPSExport, "Non-return disposition has results")
            End If
        End If

        '   Record has dispo 10, 31, or 34, and language = 8
        If ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Dispo_Lang.Trim() = "8") Then
            LogValidationException(acoCAHPSExport, "Return disposition missing language")
        End If

        '   Record has dispo not in 10, 31, or 34, and has lang <> 8
        If Not ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Dispo_Lang.Trim() <> "8") Then
            LogValidationException(acoCAHPSExport, "Non-return disposition has language populated")
        End If

        '   Record has dispo 10, 31, or 34, and received date = 88888888
        If ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Received = "88888888") Then
            LogValidationException(acoCAHPSExport, "Return disposition missing return date")
        End If

        '   Record has dispo not in 10, 31, or 34, and received date <> 88888888
        If Not ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Received <> "88888888") Then
            LogValidationException(acoCAHPSExport, "Non-return disposition has return date")
        End If

        '   Record has dispo 10, 31, or 34, and Mode = 8
        If ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Mode.Trim() = "8") Then
            LogValidationException(acoCAHPSExport, "Return disposition missing mode")
        End If

        '	Record has dispo not in 10, 31, or 34, and mode <> 8
        If Not ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) _
            And (acoCAHPSExport.Mode.Trim() <> "8") Then
            LogValidationException(acoCAHPSExport, "Non-return disposition has mode populated")
        End If

        '	Record has bitComplete = 1 and dispo <> 10
        If acoCAHPSExport.BitComplete.HasValue Then
            If (acoCAHPSExport.BitComplete.Value = True) And (acoCAHPSExport.Dispositn <> "10") Then
                LogValidationException(acoCAHPSExport, "Record has bitComplete = 1, but disposition is not 10")
            End If
        End If

        '	Record has bitComplete = 0 and dispo <> 31 or 34
        If acoCAHPSExport.BitComplete.HasValue Then
            If (acoCAHPSExport.BitComplete.Value = False) And Not ((acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) Then
                LogValidationException(acoCAHPSExport, "Record has bitComplete = 0, but disposition is not 31 or 34")
            End If
        End If

        '   Record has bitComplete = NULL and dispo 10, 31, or 34
        If (Not acoCAHPSExport.BitComplete.HasValue) And ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) Then
            LogValidationException(acoCAHPSExport, "Return disposition missing bitComplete")
        End If

        '   count(*) having count > 1
        If False Then
            LogValidationException(acoCAHPSExport, "Duplicate Finder numbers found	ACO ID, Finder")
        End If

        '   Record has a NULL or empty string for ACO_ID
        If String.IsNullOrEmpty(acoCAHPSExport.ACO_Id) Then
            LogValidationException(acoCAHPSExport, "Record is missing ACO_ID")
        End If

        '   Record has a NULL or empty string for Finder
        If String.IsNullOrEmpty(acoCAHPSExport.Finder) Then
            LogValidationException(acoCAHPSExport, "Record is missing Finder number")
        End If

        '   Record has a NULL or empty string for Disposition
        If String.IsNullOrEmpty(acoCAHPSExport.Dispositn) Then
            LogValidationException(acoCAHPSExport, "Record is missing Disposition")
        End If

        '   Record has a NULL or empty string for Mode
        If String.IsNullOrEmpty(acoCAHPSExport.Mode) Then
            LogValidationException(acoCAHPSExport, "Record is missing Mode")
        End If

        '	Record has a NULL or empty string for Language
        If String.IsNullOrEmpty(acoCAHPSExport.Dispo_Lang) Then
            LogValidationException(acoCAHPSExport, "Record is missing Language")
        End If

        '   Record has a NULL or empty string for Received
        If String.IsNullOrEmpty(acoCAHPSExport.Received) Then
            LogValidationException(acoCAHPSExport, "Record is missing Received Date")
        End If

        '   Record has a NULL or empty string for Focal Type
        If String.IsNullOrEmpty(acoCAHPSExport.FocalType) Then
            LogValidationException(acoCAHPSExport, "Record is missing Focal Type")
        End If

        '   Record has a NULL or empty string for PRTitle
        If String.IsNullOrEmpty(acoCAHPSExport.PRTitle) Then
            LogValidationException(acoCAHPSExport, "Record is missing Provider Title")
        End If

        '   Record has a NULL or empty string for PRFName
        If String.IsNullOrEmpty(acoCAHPSExport.PRFName) Then
            LogValidationException(acoCAHPSExport, "Record is missing Provider FName")
        End If

        '   Record has a NULL or empty stringPRLName
        If String.IsNullOrEmpty(acoCAHPSExport.PRLName) Then
            LogValidationException(acoCAHPSExport, "Record is missing Provider LName")
        End If

        '   Record has a NULL or empty QVersion
        If String.IsNullOrEmpty(acoCAHPSExport.QVersion) Then
            LogValidationException(acoCAHPSExport, "Record is missing Version")
        End If

        '   Record w/ dispo 10, 31, or 34 has any question w/ a NULL or empty string
        If ((acoCAHPSExport.Dispositn = "10") Or (acoCAHPSExport.Dispositn = "31") Or (acoCAHPSExport.Dispositn = "34")) Then
            Dim iQuestion As Integer = 0
            While iQuestion < acoCAHPSExport.Qs.Count
                If String.IsNullOrEmpty(acoCAHPSExport.Qs(iQuestion)) Then
                    LogValidationException(acoCAHPSExport, "Record is missing data for one or more question responses")
                    iQuestion = acoCAHPSExport.Qs.Count
                Else
                    iQuestion += 1
                End If
            End While
        End If

        'Freqs & X-Tabs
        'Always display frequencies and cross-tabs.
        '        Type(Field(s))
        '        Freq(ACO_ID)
        'X-Tab	ACO_ID & Disposition
        'X-Tab	ACO_ID & Mode
        'X-Tab	ACO_ID & Language

        freqs.AddValue("ACO_ID", acoCAHPSExport.ACO_Id)
        freqs.AddValue("ACO_ID & Disposition", acoCAHPSExport.ACO_Id + " - " + acoCAHPSExport.Dispositn)
        freqs.AddValue("ACO_ID & Mode", acoCAHPSExport.ACO_Id + " - " + acoCAHPSExport.Mode)
        freqs.AddValue("ACO_ID & Language", acoCAHPSExport.ACO_Id + " - " + acoCAHPSExport.Dispo_Lang)

        stream.Write(acoCAHPSExport.Finder.PadLeft(8, CChar("0")))
        stream.Write(String.Format("{0,5}", acoCAHPSExport.ACO_Id))
        stream.Write(String.Format("{0,2}", acoCAHPSExport.Dispositn))
        stream.Write(String.Format("{0,1}", acoCAHPSExport.Mode))
        stream.Write(String.Format("{0,1}", acoCAHPSExport.Dispo_Lang))
        stream.Write(String.Format("{0,8}", acoCAHPSExport.Received))
        stream.Write(String.Format("{0,1}", acoCAHPSExport.FocalType))
        stream.Write(String.Format("{0,-35}", acoCAHPSExport.PRTitle))
        stream.Write(String.Format("{0,-30}", acoCAHPSExport.PRFName))
        stream.Write(String.Format("{0,-50}", acoCAHPSExport.PRLName))
        If (acoCAHPSExport.QVersion <> "NA") Then
            stream.Write(String.Format("{0,2}", acoCAHPSExport.QVersion))
        End If

        For Each qx As String In acoCAHPSExport.Qs
            If (qx <> "-3") Then
                stream.Write(String.Format("{0,-2}", qx))
            End If
        Next
        stream.WriteLine()
    End Sub

    ''' <summary>
    ''' Where validation exceptions get added to the Exception store
    ''' </summary>
    ''' <param name="aco">record being validated</param>
    ''' <param name="message">description of exception</param>
    ''' <remarks>This is needed because the newRow.Values.Add is required in order to report the exception</remarks>
    Private Sub LogValidationException(ByVal aco As ACOCAHPSExport, ByVal message As String)
        Dim newRow As ExceptionReportRow = mExceptionReport.AddRow(message)
        newRow.Values.Add("Finder: " & aco.Finder)
        newRow.Values.Add("ACO_Id: " & aco.ACO_Id)
    End Sub

End Class
