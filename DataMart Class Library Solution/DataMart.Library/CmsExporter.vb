Imports Nrc.Framework.BusinessLogic.Configuration
Friend Class CmsExporter
    Inherits Exporter

#Region " Private Members "

    Private mHasMultipleFacility As Boolean
    Protected mExceptionReport As ExceptionReport
    Protected mTPSReport As TPSTable
    Private mExportType As ExportSetType
    Private mSurveyMode As String = String.Empty

#End Region

#Region " Friend Methods "

    Friend Sub DeleteExportFile(ByVal filePath As String)

        If System.IO.File.Exists(filePath) Then System.IO.File.Delete(filePath)

    End Sub

    Friend Sub UpdateExportTPSErrorMessage(ByVal id As Integer, ByVal errorMessage As String)

        DataProvider.Instance.UpdateExportFileErrorMessage(id, errorMessage)

    End Sub

    Friend Overrides Function CreateExportFile(ByVal exportSets As System.Collections.ObjectModel.Collection(Of ExportSet), _
                                          ByVal filePath As String, ByVal fileType As ExportFileType, _
                                          ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, _
                                          ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer

        Dim exportGuid As Guid = Guid.NewGuid
        Dim exportSuccessful As Boolean = False
        Dim errorMessage As String = ""
        Dim stackTrace As String = ""
        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim exportSetIds As New List(Of Integer)
        Dim clientName As String = ""
        Dim newId As Integer = 0
        Try
            'Get the client name
            Dim srvy As Survey = Survey.GetSurvey(exportSets(0).SurveyId)
            clientName = srvy.Study.Client.DisplayLabel

            'Get export type
            mExportType = exportSets(0).ExportSetType
            Dim saveData As Boolean = False
            If mExportType = ExportSetType.CmsHHcahps Then
                saveData = True
            End If

            'Build the list of ExportSet IDs
            For Each export As ExportSet In exportSets
                exportSetIds.Add(export.Id)

                'Determine if all of the export sets are for the same client
                If clientName <> Survey.GetSurvey(export.SurveyId).Study.Client.DisplayLabel Then
                    clientName = "MultiClient"
                End If
            Next

            'Determine if we have multiple facilities
            mHasMultipleFacility = exportSets.Count > 1

            'Get the export data reader
            Using rdr As IDataReader = GetRecodeReader(DataProvider.Instance.SelectExportFileData(exportSetIds.ToArray, includeOnlyReturns, includeOnlyDirects, includePhoneFields, exportGuid, saveData, True))
                'Get the path and filename for the header file
                Dim serviceLinePath As String = GetHDOSLPath(filePath)
                Dim headerPath As String = GetHeaderPath(filePath)
                Dim summaryPath As String = GetSummaryPath(filePath)


                'Generate the export file in the specified file type
                Select Case fileType
                    Case ExportFileType.DBase
                        Dim tempPart As Integer = 0

                        'Write out the HDOSL record
                        CreateExportDbfFile(rdr, serviceLinePath, tempPart)

                        'Make sure there is another result set
                        If Not rdr.NextResult Then
                            Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                        End If

                        'Write out the header record
                        CreateExportDbfFile(rdr, headerPath, tempPart)

                        ''Account for the strata result set
                        'If mHasMultipleFacility Then
                        '    If Not rdr.NextResult Then
                        '        Throw New ExportFileCreationException("Error finding Strata dataset.")
                        '    End If

                        '    'Write out the strata results records
                        '    tempPart = 0
                        '    Dim strataPath As String = GetStrataPath(filePath)
                        '    CreateExportDbfFile(rdr, strataPath, tempPart)
                        'End If

                        'Make sure there is another result set
                        If Not rdr.NextResult Then
                            Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                        End If

                        'Write out the patient results records
                        recordCount = CreateExportDbfFile(rdr, filePath, filePartCount)
                        exportSuccessful = True

                    Case ExportFileType.Csv
                        'Write out the HDOSL record
                        CreateExportCsvFile(rdr, serviceLinePath)

                        'Make sure there is another result set
                        If Not rdr.NextResult Then
                            Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                        End If

                        'Write out the header record
                        CreateExportCsvFile(rdr, headerPath)

                        ''Account for the strata result set
                        'If mHasMultipleFacility Then
                        '    If Not rdr.NextResult Then
                        '        Throw New ExportFileCreationException("Error finding Strata dataset.")
                        '    End If

                        '    'Write out the header record
                        '    Dim strataPath As String = GetStrataPath(filePath)
                        '    CreateExportCsvFile(rdr, strataPath)
                        'End If

                        'Make sure there is another result set
                        If Not rdr.NextResult Then
                            Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                        End If

                        'Write out the patient results records
                        recordCount = CreateExportCsvFile(rdr, filePath)
                        exportSuccessful = True

                    Case ExportFileType.Xml
                        'Create the exception report
                        Dim sampleSets As New Dictionary(Of Integer, SampleSet)
                        mExceptionReport = New ExceptionReport()
                        mTPSReport = New TPSTable

                        'Write out the XML file
                        recordCount = CreateExportCmsFile(rdr, filePath, sampleSets)

                        'Write the summary report
                        CreateCmsSummaryFile(filePath, mHasMultipleFacility, mExportType)

                        'Write the exception report
                        CreateCmsExceptionFile(rdr, filePath, exportSets, sampleSets)

                        'Write TPS Report
                        If mTPSReport.Count > 0 Then
                            mTPSReport.RecordCount = recordCount
                            Dim tpsPath As String = CreateTPSFile(filePath)

                            If Not Environment.UserInteractive Then
                                If System.IO.File.Exists(filePath) Then System.IO.File.Delete(filePath)
                                If System.IO.File.Exists(summaryPath) Then System.IO.File.Delete(summaryPath)
                            Else 'is UserInteractive 
                                If Not CurrentUser.IsTPSOverride Then
                                    If System.IO.File.Exists(filePath) Then System.IO.File.Delete(filePath)
                                    If System.IO.File.Exists(summaryPath) Then System.IO.File.Delete(summaryPath)
                                End If
                            End If

                            exportSuccessful = False
                            errorMessage = "Terminal conditions encountered."
                            stackTrace = String.Empty

                            'Perform interactive business service logic
                            If Environment.UserInteractive Then
                                Using dialog As New ExportErrorDialog(tpsPath)
                                    dialog.ShowDialog()

                                    If dialog.DialogResult = Windows.Forms.DialogResult.OK Then
                                        If CurrentUser.IsTPSOverride Then
                                            'Delete the XML File
                                            If System.IO.File.Exists(filePath) Then System.IO.File.Delete(filePath)
                                            If System.IO.File.Exists(summaryPath) Then System.IO.File.Delete(summaryPath)
                                        End If
                                    Else
                                        'Create Export File
                                        errorMessage = "Terminal conditions encountered. File created."
                                    End If
                                End Using
                            End If
                        Else
                            exportSuccessful = True
                        End If

                    Case Else
                        Throw New ArgumentException(String.Format("The file type {0} is not supported.", fileType))

                End Select
            End Using

        Catch ex As Exception
            exportSuccessful = False
            errorMessage = ex.Message
            stackTrace = ex.ToString
            MoveErrorFile(filePath, clientName)
            Throw New ExportFileCreationException("Export file creation failed: " & ex.Message, ex)

        Finally

            If exportSuccessful Then
                'Insert the success record into the ExportFile log
                newId = DataProvider.Instance.InsertExportFile(recordCount, createdEmployeeName, filePath, filePartCount, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, isScheduledExport)
            Else
                'Insert the failure record into the ExportFile log
                newId = DataProvider.Instance.InsertExportFile(0, createdEmployeeName, filePath, 0, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, False, errorMessage, stackTrace, isScheduledExport, "", "", "")
                errorMessage = ""
            End If

            'Insert the export sets for the export file
            For Each id As Integer In exportSetIds
                DataProvider.Instance.InsertExportFileExportSet(id, newId)
            Next
        End Try
        Return newId
    End Function

#End Region

#Region " Protected Methods "

    Protected Overridable Function GetRecodeReader(ByVal rdr As IDataReader) As IDataReader

        Return New CmsRecodeReader(rdr, mHasMultipleFacility)

    End Function

#End Region

#Region " Private Methods "

    Private Shared Function GetHeaderPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_header{1}", fileName, extension))

    End Function

    Private Shared Function GetSummaryPath(ByVal filePath As String) As String

        Return IO.Path.ChangeExtension(filePath, ".summary.html")

    End Function

    Private Shared Function GetStrataPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_strata{1}", fileName, extension))

    End Function

    Private Shared Function GetHDOSLPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_srvline{1}", fileName, extension))

    End Function

    Private Shared Function MoveErrorFile(ByVal filePath As String, ByVal clientName As String) As Boolean

        If IO.File.Exists(filePath) Then
            'Get the path and filename for the error file
            Dim destFolder As String = IO.Path.Combine(Config.ErroredFolderPath, clientName)
            Dim destFileName As String = IO.Path.Combine(destFolder, IO.Path.GetFileName(filePath))

            'Check to see if the error folder exists
            If Not System.IO.Directory.Exists(Config.ErroredFolderPath) Then
                Throw New IO.DirectoryNotFoundException(String.Format("Output folder '{0}' does not exist.", Config.ErroredFolderPath))
            End If

            'Make sure the destination folder exists
            If Not System.IO.Directory.Exists(destFolder) Then
                System.IO.Directory.CreateDirectory(destFolder)
            End If

            Try
                'Delete the file from error folder if it exists
                If System.IO.File.Exists(destFileName) Then System.IO.File.Delete(destFileName)

                'Move the file.  
                System.IO.File.Move(filePath, IO.Path.Combine(destFolder, destFileName))

            Catch ex As Exception
                Throw New ExportFileCreationException("Export file creation failed: Unable to move file to error folder.  " & ex.Message, ex)

            End Try
        End If

    End Function

#End Region

#Region " XML Output "

    Private Function CreateExportCmsFile(ByVal reader As IDataReader, ByVal filePath As String, _
                                         ByVal sampleSets As Dictionary(Of Integer, SampleSet)) As Integer

        Dim recordCount As Integer = 0

        'This will produce a UTF8 Encoding that doesn't write the BOM
        Dim encoding As System.Text.Encoding = New System.Text.UTF8Encoding(False)

        'Create the XML file
        Using stream As New IO.StreamWriter(filePath, False, encoding)
            Using writer As New System.Xml.XmlTextWriter(stream)
                'Write out the file header information
                writer.Formatting = Xml.Formatting.Indented
                writer.WriteRaw("<?xml version=""1.0"" encoding=""UTF-8""?>")
                writer.WriteStartElement("monthlydata", "")
                writer.WriteAttributeString("xmlns", "http://hcahps.ifmc.org")
                writer.WriteAttributeString("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")

                'Write the header section
                WriteXmlHeader(reader, writer)

                'Make sure there is another result set
                If Not reader.NextResult Then
                    Throw New ExportFileCreationException("The CMS export is missing the patient level result set.")
                End If

                'Write the patient section
                recordCount = WriteXmlPatientData(reader, writer, sampleSets)

                'Write the end element
                writer.WriteEndElement()

                'Close the XML file
                writer.Flush()
                writer.Close()
            End Using
        End Using

        Return recordCount

    End Function

    Protected Overridable Sub WriteXmlHeader(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

        'Read the HDOSL record
        Dim strServiceline As String = reader("determination-of-service-line").ToString

        'Make sure there is another result set
        If Not reader.NextResult Then
            Throw New ExportFileCreationException("The CMS export is missing the header level result set.")
        End If

        'Read the header record
        reader.Read()

        'Collect data for TPS report
        Dim strDischarge As String = String.Concat(reader("discharge-yr").ToString, reader("discharge-month").ToString.PadLeft(2, CChar("0")))
        mSurveyMode = reader("survey-mode").ToString
        Dim sampleType As String = reader("sample-type").ToString
        'Dim strataName As String
        'Dim dsrsEligible As String
        'Dim dsrsSamplesize As String

        'Check to see if we have any TPS on HDOSL conditions
        If CType(strDischarge, Integer) >= 200904 Then
            If strServiceline.Trim = String.Empty Then
                mTPSReport.AddValue("The HServiceDes field is not populated for one or more records")
            ElseIf strServiceline = "-1" Then
                mTPSReport.AddValue("The HServiceDes field is not in the study data structure")
                strServiceline = String.Empty
            ElseIf strServiceline = "R7" Then   'Recoded 7; DOSL list contained a 4, 5, and/or 6
                mTPSReport.AddValue("Service Line Determination combination resulted in a 7")
                strServiceline = "7"
            End If
        End If

        'Check to see if we have any TPS conditions
        If mSurveyMode = "" Then
            mTPSReport.AddValue("survey-mode can not be blank")
        ElseIf mSurveyMode <> "1" AndAlso mSurveyMode <> "2" Then
            mTPSReport.AddValue("survey-mode not equal to 1 or 2")
        End If

        If sampleType <> "1" AndAlso sampleType <> "2" AndAlso sampleType <> "3" Then
            mTPSReport.AddValue("sample-type does not equal 1, 2, or 3")
        End If

        'Write the start element
        writer.WriteStartElement("header")

        'Write the header section
        writer.WriteElementString("provider-name", reader("provider-name").ToString)
        writer.WriteElementString("provider-id", reader("provider-id").ToString)

        'Add PENumber to CHART extract.
        If mExportType = ExportSetType.CmsChart Then
            Dim peNumber As String = reader("pe-number").ToString
            If peNumber.Trim = String.Empty Then
                mTPSReport.AddValue("pe-number can not be blank")
            End If
            If CInt(reader("PENUMBERCOUNT")) > 1 Then
                mTPSReport.AddValue("multiple pe-numbers found for the header record")
            End If
            writer.WriteElementString("pe-number", peNumber)
        End If

        writer.WriteElementString("npi", reader("npi").ToString)
        writer.WriteElementString("discharge-yr", reader("discharge-yr").ToString)
        writer.WriteElementString("discharge-month", reader("discharge-month").ToString)
        writer.WriteElementString("survey-mode", mSurveyMode)
        'serivce line only added for those after April 1, 2009
        If CType(strDischarge, Integer) >= 200904 Then
            writer.WriteElementString("determination-of-service-line", strServiceline)
        End If
        writer.WriteElementString("number-eligible-discharge", reader("number-eligible-discharge").ToString)
        writer.WriteElementString("sample-size", reader("sample-size").ToString)
        writer.WriteElementString("sample-type", sampleType)

        'Check for warnings
        If CType(reader("number-eligible-discharge"), Integer) < CType(reader("sample-size"), Integer) Then
            'The NumberEligible should not be less than the SampleCount
            Dim newRow As ExceptionReportRow = mExceptionReport.AddRow("The column 'number-eligible-discharge' should not be less than the column 'sample-size'")
            newRow.Values.Add("number-eligible-discharge = " & reader("number-eligible-discharge").ToString)
            newRow.Values.Add("sample-size = " & reader("sample-size").ToString)
        End If

        'If we have multiple facilities than add the strata information
        'If mHasMultipleFacility Then
        '    'Make sure there is another result set
        '    If Not reader.NextResult Then
        '        Throw New ExportFileCreationException("The CMS export is missing sub header result set.")
        '    End If

        '    While reader.Read
        '        'Collect data for TPS report
        '        strataName = reader("strata-name").ToString
        '        dsrsEligible = reader("dsrs-eligible").ToString
        '        dsrsSamplesize = reader("dsrs-samplesize").ToString

        '        'Check to see if we have any TPS conditions
        '        If dsrsEligible = "0" Then
        '            mTPSReport.AddValue("Strata has dsrs-eligible equal to 0")
        '        End If

        '        If dsrsSamplesize = "0" Then
        '            mTPSReport.AddValue("Strata has dsrs-samplesize equal to 0")
        '        End If

        '        If CType(dsrsEligible, Integer) < CType(dsrsSamplesize, Integer) Then
        '            mTPSReport.AddValue("Strata has dsrs-eligible less than dsrs-samplesize")
        '        End If

        '        'Write the strata start element
        '        writer.WriteStartElement("dsrs-strata")

        '        'Write the strata data
        '        writer.WriteElementString("strata-name", strataName)
        '        writer.WriteElementString("dsrs-eligible", dsrsEligible)
        '        writer.WriteElementString("dsrs-samplesize", dsrsSamplesize)

        '        'Write the strata end element
        '        writer.WriteEndElement()
        '    End While
        'End If

        'Write the header end element
        writer.WriteEndElement()

    End Sub

    Private Function WriteXmlPatientData(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet)) As Integer

        Dim recordCount As Integer = 0

        'Write out the patient data for each patient
        While reader.Read
            'Write the start element
            writer.WriteStartElement("patientleveldata")

            'Write the admin section
            WriteXmlAdminElement(reader, writer, sampleSets)

            'Write the patient responce section if applicable
            'If CInt(reader("lag-time")) <> 888 Then 'IF IS A RESPONSE
            If CDate(reader("discharge-date").ToString) < AppConfig.Params("LagTimeColumnStartDate").DateValue Then
                If CInt(reader("lag-time")) <> 888 Then
                    BeginXmlResponseElement(writer)
                    WriteXmlResponseElement(reader, writer)
                    EndXmlResponseElement(writer)
                End If
            Else
                If CInt(reader("survey-status")) = 1 OrElse CInt(reader("survey-status")) = 6 Then
                    BeginXmlResponseElement(writer)
                    WriteXmlResponseElement(reader, writer)
                    EndXmlResponseElement(writer)
                End If
            End If

            'Increment the record count
            recordCount += 1

            'Write the end element
            writer.WriteEndElement()
        End While

        'Return the total record count
        Return recordCount

    End Function

    Public Shared Function TrimLeadingZeros(ByVal fieldAsString As String) As String

        Dim retval As String = fieldAsString

        If Microsoft.VisualBasic.IsNumeric(fieldAsString) Then
            retval = Microsoft.VisualBasic.Val(fieldAsString).ToString()
        End If

        Return retval

    End Function

    Protected Overridable Sub WriteXmlAdminElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet))

        'Collect data for TPS report
        Dim patientAge As String = reader("patient-age").ToString
        Dim gender As String = reader("gender").ToString
        Dim principalReasonAdmission As String = reader("principal-reason-admission").ToString
        Dim dischargeStatus As String = reader("discharge-status").ToString
        Dim surveyStatus As String = reader("survey-status").ToString
        Dim surveyStatusTrim As String = TrimLeadingZeros(surveyStatus)
        Dim language As String = reader("language").ToString
        Dim languageTrim As String = TrimLeadingZeros(language)
        Dim complete As Integer = CInt(IIf(IsDBNull(reader("complete")), -1, reader("complete")))
        Dim dischargeDate As Date = CDate(String.Format("{0}-1-{1}", reader("discharge-month").ToString, reader("discharge-yr").ToString))
        Dim requiredQuestionCount As Integer = GetRequiredQuestionCount(dischargeDate, reader)

        'Check to see if we have any TPS conditions
        If TrimLeadingZeros(patientAge) = "0" OrElse patientAge = "M" Then
            mTPSReport.AddValue("patient-age equals 0 or M")
        End If

        If gender = "1" AndAlso principalReasonAdmission = "1" Then
            mTPSReport.AddValue("gender equals 1 and principal-reason-admission equals 1")
        End If

        If gender = "M" Then
            mTPSReport.AddValue("gender equals M")
        End If

        If ((dischargeStatus = "20" OrElse dischargeStatus = "41") AndAlso (surveyStatusTrim = "1" OrElse surveyStatusTrim = "6")) Then
            mTPSReport.AddValue("discharge-status equals 20 or 41 and survey-status equals 1 or 6")
        End If

        If ((surveyStatusTrim = "1" OrElse surveyStatusTrim = "6") AndAlso (languageTrim <> "1" AndAlso languageTrim <> "2" AndAlso languageTrim <> "3" AndAlso languageTrim <> "4" AndAlso languageTrim <> "5")) Then
            mTPSReport.AddValue("survey-status equals 1 or 6 and language other than 1, 2, 3, 4, or 5")
        End If

        If ((surveyStatusTrim = "1" AndAlso complete <> 1) OrElse (surveyStatusTrim = "6" AndAlso complete <> 0)) Then
            mTPSReport.AddValue("survey-status does not match complete field")
        End If

        If surveyStatusTrim = "1" AndAlso requiredQuestionCount < 9 Then
            mTPSReport.AddValue("survey-status equals 1 and less than 9 required questions answered")
        End If
        'HCAHPS 2012 Audit Results. Requirement 15
        'Add Validation for number of attempts
        'TPS should include out-of-range values for number of attempts
        Dim nattemps As Integer = CType(IIf(reader("number-attempts") Is DBNull.Value, 0, reader("number-attempts").ToString), Integer)
        Select Case mSurveyMode
            Case CType(Mode.Mail, String) 'mail
                If nattemps < 1 Or nattemps > 2 Then
                    mTPSReport.AddValue(String.Format("invalid-number-survey-attempts-mail: {0}", nattemps.ToString))
                End If
            Case CType(Mode.Telephone, String)  'phone and IVR
                If nattemps < 1 Or nattemps > 5 Then
                    mTPSReport.AddValue(String.Format("invalid-number-survey-attempts-telephone:{0}", nattemps.ToString))
                End If

        End Select


        'Write the start element
        writer.WriteStartElement("administration")

        'Write the admin information
        writer.WriteElementString("provider-id", reader("provider-id").ToString)
        writer.WriteElementString("discharge-yr", reader("discharge-yr").ToString)
        writer.WriteElementString("discharge-month", reader("discharge-month").ToString)
        writer.WriteElementString("patient-id", reader("patient-id").ToString)
        writer.WriteElementString("admission-source", reader("admission-source").ToString)
        writer.WriteElementString("principal-reason-admission", principalReasonAdmission)
        writer.WriteElementString("discharge-status", dischargeStatus)
        'If mHasMultipleFacility Then
        '    'If we have multiple facilities then add the strata name
        '    writer.WriteElementString("strata-name", reader("strata-name").ToString)
        'End If
        writer.WriteElementString("survey-status", surveyStatus)

        'Add the number of attempts if we are past the specified date
        If dischargeDate >= AppConfig.Params("NumberAttemptsStartDate").DateValue Then
            If mSurveyMode = "2" Then
                writer.WriteElementString("number-survey-attempts-telephone", reader("number-attempts").ToString)
            Else
                writer.WriteElementString("number-survey-attempts-telephone", "8")
            End If
            If mSurveyMode = "1" Then
                writer.WriteElementString("number-survey-attempts-mail", reader("number-attempts").ToString)
            Else
                writer.WriteElementString("number-survey-attempts-mail", "8")
            End If
        End If
     

        writer.WriteElementString("language", language)
        writer.WriteElementString("lag-time", reader("lag-time").ToString)

        If dischargeDate >= Date.Parse("7/1/2013") Then
            If reader("supplemental-question-count").ToString = String.Empty Then
                writer.WriteElementString("supplemental-question-count", "M") '= missing: this is in case a patient was identified as TOCL during generation
            Else
                writer.WriteElementString("supplemental-question-count", reader("supplemental-question-count").ToString)
            End If
        End If

        writer.WriteElementString("gender", gender)
        writer.WriteElementString("patient-age", patientAge)

        'Write the end element
        writer.WriteEndElement()

        'Save the sampleset
        Dim sampleSetId As Integer = CType(reader("SampSet"), Integer)
        If Not sampleSets.ContainsKey(sampleSetId) Then
            sampleSets.Add(sampleSetId, SampleSet.GetSampleSet(sampleSetId))
        End If

    End Sub

    Private Shared Sub BeginXmlResponseElement(ByVal writer As Xml.XmlTextWriter)

        writer.WriteStartElement("patientresponse")

    End Sub

    Protected Overridable Sub WriteXmlResponseElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

        Dim dischargeDate As Date = CDate(reader("discharge-date").ToString)  '09-18-2012 - Added for checking conditions

        'Collect data for TPS report
        Dim languageSpeak As String = reader("language-speak").ToString
        Dim cmsReader As CmsRecodeReader = DirectCast(reader, CmsRecodeReader)

        'Check to see if we have any TPS conditions
        If cmsReader.LanguageSpeakOldCoreUsedTPS Then
            mTPSReport.AddValue("Survey contains old language-speak QstnCore 18952")
        End If

        'Write response information
        writer.WriteElementString("nurse-courtesy-respect", reader("nurse-courtesy-respect").ToString)
        writer.WriteElementString("nurse-listen", reader("nurse-listen").ToString)
        writer.WriteElementString("nurse-explain", reader("nurse-explain").ToString)
        writer.WriteElementString("call-button", reader("call-button").ToString)
        writer.WriteElementString("dr-courtesy-respect", reader("dr-courtesy-respect").ToString)
        writer.WriteElementString("dr-listen", reader("dr-listen").ToString)
        writer.WriteElementString("dr-explain", reader("dr-explain").ToString)
        writer.WriteElementString("cleanliness", reader("cleanliness").ToString)
        writer.WriteElementString("quiet", reader("quiet").ToString)
        writer.WriteElementString("bathroom-screener", reader("bathroom-screener").ToString)
        writer.WriteElementString("bathroom-help", reader("bathroom-help").ToString)
        writer.WriteElementString("med-screener", reader("med-screener").ToString)
        writer.WriteElementString("pain-control", reader("pain-control").ToString)
        writer.WriteElementString("help-pain", reader("help-pain").ToString)
        writer.WriteElementString("new-med-screener", reader("new-med-screener").ToString)
        writer.WriteElementString("med-for", reader("med-for").ToString)
        writer.WriteElementString("side-effects", reader("side-effects").ToString)
        writer.WriteElementString("discharge-screener", reader("discharge-screener").ToString)
        writer.WriteElementString("help-after-discharge", reader("help-after-discharge").ToString)
        writer.WriteElementString("symptoms", reader("symptoms").ToString)
        writer.WriteElementString("overall-rate", reader("overall-rate").ToString)
        writer.WriteElementString("recommend", reader("recommend").ToString)

        'Add optional columns
        If dischargeDate >= AppConfig.Params("HCAHPSNewQuestionsOptionalStartDate").DateValue AndAlso mExportType = ExportSetType.CmsHcahps Then
            Try
                writer.WriteElementString("ct-preferences", reader("ct-preferences").ToString)
            Catch ex As ExportFileOptionalColumnMissingException
                writer.WriteElementString("ct-preferences", "M")
                mExceptionReport.AddUniqueRow(ex.Message)
            Catch ex As ExportFileOptionalColumnNullException
                writer.WriteElementString("ct-preferences", "M")
                mTPSReport.AddValue(ex.Message)
            Catch ex As Exception
                Throw
            End Try

            Try
                writer.WriteElementString("ct-understanding", reader("ct-understanding").ToString)
            Catch ex As ExportFileOptionalColumnMissingException
                writer.WriteElementString("ct-understanding", "M")
                mExceptionReport.AddUniqueRow(ex.Message)
            Catch ex As ExportFileOptionalColumnNullException
                writer.WriteElementString("ct-understanding", "M")
                mTPSReport.AddValue(ex.Message)
            Catch ex As Exception
                Throw
            End Try

            Try
                writer.WriteElementString("ct-purpose-med", reader("ct-purpose-med").ToString)
            Catch ex As ExportFileOptionalColumnMissingException
                writer.WriteElementString("ct-purpose-med", "M")
                mExceptionReport.AddUniqueRow(ex.Message)
            Catch ex As ExportFileOptionalColumnNullException
                writer.WriteElementString("ct-purpose-med", "M")
                mTPSReport.AddValue(ex.Message)
            Catch ex As Exception
                Throw
            End Try

            Try
                writer.WriteElementString("er-admission", reader("er-admission").ToString)
            Catch ex As ExportFileOptionalColumnMissingException
                writer.WriteElementString("er-admission", "M")
                mExceptionReport.AddUniqueRow(ex.Message)
            Catch ex As ExportFileOptionalColumnNullException
                writer.WriteElementString("er-admission", "M")
                mTPSReport.AddValue(ex.Message)
            Catch ex As Exception
                Throw
            End Try
        End If

        writer.WriteElementString("overall-health", reader("overall-health").ToString)

        'Add optional columns
        If dischargeDate >= AppConfig.Params("HCAHPSNewQuestionsOptionalStartDate").DateValue AndAlso mExportType = ExportSetType.CmsHcahps Then
            Try
                writer.WriteElementString("mental-health", reader("mental-health").ToString)
            Catch ex As ExportFileOptionalColumnMissingException
                writer.WriteElementString("mental-health", "M")
                mExceptionReport.AddUniqueRow(ex.Message)
            Catch ex As ExportFileOptionalColumnNullException
                writer.WriteElementString("mental-health", "M")
                mTPSReport.AddValue(ex.Message)
            Catch ex As Exception
                Throw
            End Try
        End If

        writer.WriteElementString("education", reader("education").ToString)
        writer.WriteElementString("ethnic", reader("ethnic").ToString)
        writer.WriteElementString("race-white", reader("race-white").ToString)
        writer.WriteElementString("race-african-amer", reader("race-african-amer").ToString)
        writer.WriteElementString("race-asian", reader("race-asian").ToString)
        writer.WriteElementString("race-hi-pacific-islander", reader("race-hi-pacific-islander").ToString)
        writer.WriteElementString("race-amer-indian-ak", reader("race-amer-indian-ak").ToString)
        writer.WriteElementString("language-speak", languageSpeak)

    End Sub

    Private Shared Sub EndXmlResponseElement(ByVal writer As Xml.XmlTextWriter)

        writer.WriteEndElement()

    End Sub

    Private Function GetRequiredQuestionCount(ByVal dischargeDate As Date, ByVal reader As IDataReader) As Integer

        Dim quantity As Integer = 0
        Dim requiredQuestions As New List(Of String)
        requiredQuestions.AddRange(New String() {"nurse-courtesy-respect", "nurse-listen", "nurse-explain", "call-button", _
                                             "dr-courtesy-respect", "dr-listen", "dr-explain", "cleanliness", "quiet", _
                                             "bathroom-screener", "med-screener", "new-med-screener", "discharge-screener", _
                                             "overall-rate", "recommend"})

        '2013-0921 Fixing an omission that was made when "INC0018852 HCAHPS - New Calculation for Complete Surveys" was implemented
        '          the three additional required questions should only be considered if the dischargedate is past the configurable
        '          optional start date

        If dischargeDate >= AppConfig.Params("HCAHPSNewQuestionsMandatoryStartDate").DateValue AndAlso mExportType = ExportSetType.CmsHcahps Then
            requiredQuestions.AddRange(New String() {"ct-preferences", "ct-understanding", "ct-purpose-med"})
        End If

        For Each column As String In requiredQuestions
            Dim value As Object = reader(column)
            If value IsNot DBNull.Value AndAlso value.ToString <> "M" Then
                quantity += 1
            End If
        Next

        Return quantity

    End Function

#End Region

#Region " CMS Summary File Methods "

    Protected Overridable Sub CreateCmsSummaryFile(ByVal cmsFilePath As String, ByVal hasMultipleFacility As Boolean, ByVal exportType As ExportSetType)

        Dim freqs As FrequencyTable = GetCmsFileFrequencies(cmsFilePath, hasMultipleFacility, exportType)
        Dim summaryPath As String = IO.Path.ChangeExtension(cmsFilePath, ".summary.html")
        Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

        Using writer As New IO.StreamWriter(summaryPath, False)
            WriteCmsSummaryHtml(freqs, writer, fileName, hasMultipleFacility, exportType)
        End Using

    End Sub

    Private Shared Sub WriteCmsSummaryHtml(ByVal freqTable As FrequencyTable, ByVal writer As IO.TextWriter, ByVal fileName As String, ByVal hasMultipleFacility As Boolean, ByVal exportType As ExportSetType)

        'Create the report styles and header row
        writer.WriteLine("<html>")
        writer.WriteLine("<head>")
        writer.WriteLine("<STYLE>.NotifyTable {FONT-SIZE: x-small; FONT-FAMILY: Tahoma, Verdana, Arial; BACKGROUND-COLOR: White;}")
        writer.WriteLine(".HeaderCell {PADDING: 2px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #ffffff; TEXT-ALIGN: center; BACKGROUND-COLOR: #033791; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".NormalCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #CDE1FA; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".WarningCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: Red; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".FieldCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; BACKGROUND-COLOR: #AFC8F5; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".Title {FONT-SIZE: medium; FONT-WEIGHT: bold;}")
        writer.WriteLine("</STYLE>")
        writer.WriteLine("</head>")
        writer.WriteLine("<body>")
        writer.WriteLine("<div class='Title'>Export Summary for {0}</div>", fileName)
        writer.WriteLine("<div style='font-size: xx-small;'><i>{0}</i></div>", Date.Now.ToString)
        writer.WriteLine("<table class='NotifyTable'>")
        writer.WriteLine("<tr><td class='HeaderCell'>Field Name</td><td class='HeaderCell'>Value</td><td class='HeaderCell'>Count</td><td class='HeaderCell'>Percentage</td></tr>")

        'Write contents of report
        If exportType = ExportSetType.CmsChart Then
            WriteCmsSummaryRow(freqTable, writer, "pe-number")
        End If

        WriteCmsSummaryRow(freqTable, writer, "number-eligible-discharge")
        WriteCmsSummaryRow(freqTable, writer, "Patient Responses")

        Try
            WriteCmsSummaryRow(freqTable, writer, "determination-of-service-line")

        Catch ex As Exception
            'Ignore error because item doesn't exist in prior April 2009 XML files.

        End Try

        'Summarize lag time and then write it
        SummarizeLagTimeFreqs(freqTable)

        WriteCmsSummaryRow(freqTable, writer, "lag-time", True, ">84")
        WriteCmsSummaryRow(freqTable, writer, "discharge-yr")
        WriteCmsSummaryRow(freqTable, writer, "discharge-month")
        WriteCmsSummaryRow(freqTable, writer, "admission-source", True, "9")
        WriteCmsSummaryRow(freqTable, writer, "principal-reason-admission", True, "M")
        WriteCmsSummaryRow(freqTable, writer, "discharge-status", True, "M")

        'If hasMultipleFacility Then
        '    WriteCmsSummaryRow(freqTable, writer, "strata-name", True, "M")
        'End If

        WriteCmsSummaryRow(freqTable, writer, "survey-status", True, "M")
        WriteCmsSummaryRow(freqTable, writer, "language")
        WriteCmsSummaryRow(freqTable, writer, "gender", True, "M")
        WriteCmsSummaryRow(freqTable, writer, "patient-age", True, "M")

        'Finish up the report HTML
        writer.WriteLine("</table>")
        writer.WriteLine("</body>")
        writer.WriteLine("</html>")

    End Sub

    Protected Shared Sub SummarizeLagTimeFreqs(ByVal freqTable As FrequencyTable)

        Dim lagFreq As Frequency = freqTable("lag-time")
        Dim removeList As New List(Of String)
        Dim safeCount As Integer = 0
        Dim overCount As Integer = 0

        For Each value As String In lagFreq.Keys
            Dim intval As Integer

            If Integer.TryParse(value, intval) Then
                If intval > 0 AndAlso intval <= 84 Then
                    safeCount += lagFreq(value)
                    removeList.Add(value)
                ElseIf intval > 84 AndAlso intval <> 888 Then
                    overCount += lagFreq(value)
                    removeList.Add(value)
                End If
            End If
        Next

        For Each value As String In removeList
            lagFreq.Remove(value)
        Next

        If safeCount > 0 Then
            lagFreq.Add("1-84", safeCount)
        End If

        If overCount > 0 Then
            lagFreq.Add(">84", overCount)
        End If

    End Sub

    Protected Shared Sub WriteCmsSummaryRow(ByVal freqTable As FrequencyTable, ByVal writer As IO.TextWriter, ByVal fieldName As String)

        WriteCmsSummaryRow(freqTable, writer, fieldName, False, "")

    End Sub

    Protected Shared Sub WriteCmsSummaryRow(ByVal freqTable As FrequencyTable, ByVal writer As IO.TextWriter, ByVal fieldName As String, _
                                          ByVal highlightMissing As Boolean, ByVal missingValue As String)

        Dim freq As Frequency = freqTable(fieldName)
        Dim isFirst As Boolean = True

        For Each key As String In freq.Keys
            writer.WriteLine("<tr>")
            If isFirst Then
                writer.WriteLine("<td class='FieldCell' rowspan='{0}'>{1}</td>", freq.Keys.Count, fieldName)
            End If

            Dim className As String = "NormalCell"

            If highlightMissing AndAlso key = missingValue AndAlso freq.GetPercentage(key) >= 0.05 Then
                className = "WarningCell"
            End If

            If fieldName = "number-eligible-discharge" OrElse fieldName = "pe-number" OrElse fieldName = "number-eligible-patients" OrElse fieldName = "number-vendor-submitted" OrElse fieldName = "patients-hha" Then
                writer.WriteLine("<td class='{0}'>{1}</td>", className, key)
                writer.WriteLine("<td class='{0}'>{1}</td>", className, "")
                writer.WriteLine("<td class='{0}'>{1}</td>", className, "")
            Else
                writer.WriteLine("<td class='{0}'>{1}</td>", className, key)
                writer.WriteLine("<td class='{0}'>{1}</td>", className, freq.GetCount(key))
                writer.WriteLine("<td class='{0}'>{1}</td>", className, freq.GetPercentage(key).ToString("###.##%"))
            End If

            writer.WriteLine("</tr>")
            isFirst = False
        Next

    End Sub

    Private Shared Function GetCmsFileFrequencies(ByVal cmsFilePath As String, ByVal hasMultipleFacility As Boolean, ByVal exportType As ExportSetType) As FrequencyTable

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

                If exportType = ExportSetType.CmsChart Then
                    freqs.AddValue("pe-number", node.Item("pe-number").InnerText)
                End If

                freqs.AddValue("number-eligible-discharge", node.Item("number-eligible-discharge").InnerText)

                Try
                    freqs.AddValue("determination-of-service-line", node.Item("determination-of-service-line").InnerText)

                Catch ex As Exception
                    'Ignore error because item doesn't exist in prior April 2009 XML files.

                End Try

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
                    freqs.AddValue("discharge-yr", adminNode.Item("discharge-yr").InnerText)
                    freqs.AddValue("discharge-month", adminNode.Item("discharge-month").InnerText)
                    freqs.AddValue("admission-source", adminNode.Item("admission-source").InnerText)
                    freqs.AddValue("principal-reason-admission", adminNode.Item("principal-reason-admission").InnerText)
                    freqs.AddValue("discharge-status", adminNode.Item("discharge-status").InnerText)
                    'If hasMultipleFacility Then
                    '    freqs.AddValue("strata-name", adminNode.Item("strata-name").InnerText)
                    'End If
                    freqs.AddValue("survey-status", adminNode.Item("survey-status").InnerText)
                    freqs.AddValue("language", adminNode.Item("language").InnerText)
                    freqs.AddValue("gender", adminNode.Item("gender").InnerText)
                    freqs.AddValue("patient-age", adminNode.Item("patient-age").InnerText)
                    freqs.AddValue("lag-time", adminNode.Item("lag-time").InnerText)
                End While
            End Using
        End Using

        'return the frequency table
        Return freqs

    End Function

#End Region

#Region " Exception Report Methods "

    Private Sub CreateCmsExceptionFile(ByVal reader As IDataReader, ByVal cmsFilePath As String, _
                                       ByVal exportSets As Collection(Of ExportSet), _
                                       ByVal sampleSets As Dictionary(Of Integer, SampleSet))

        'Make sure there is another result set for the non-compliant record count
        If Not reader.NextResult Then
            Throw New ExportFileCreationException("The CMS export is missing the non-compliant record result set.")
        End If

        'Check to see if there are any non-compliant records
        reader.Read()
        If CType(reader("DeletedCount"), Integer) > 0 Then
            mExceptionReport.AddRow("The following number of records were not included due to non-compliance", reader("DeletedCount").ToString)
        End If

        'Check to see if the sample dates cover the whole export date range
        mExceptionReport.CheckForMissingSampleDaysInExports(exportSets, sampleSets)

        'Determine if we need to generate the exception report
        If mExceptionReport.Count > 0 Then
            Dim exceptionPath As String = IO.Path.ChangeExtension(cmsFilePath, ".exception.html")
            Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

            Using writer As New IO.StreamWriter(exceptionPath, False)
                WriteCmsExceptionHtml(writer, fileName)
            End Using
        End If

    End Sub

    Private Sub WriteCmsExceptionHtml(ByVal writer As IO.TextWriter, ByVal fileName As String)

        'Create the report styles and header row
        writer.WriteLine("<html>")
        writer.WriteLine("<head>")
        writer.WriteLine("<STYLE>.NotifyTable {FONT-SIZE: x-small; FONT-FAMILY: Tahoma, Verdana, Arial; BACKGROUND-COLOR: White;}")
        writer.WriteLine(".HeaderCell {PADDING: 2px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #ffffff; TEXT-ALIGN: center; BACKGROUND-COLOR: #033791; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".NormalCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #CDE1FA; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".ErrorCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; BACKGROUND-COLOR: #AFC8F5; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".Title {FONT-SIZE: medium; FONT-WEIGHT: bold;}")
        writer.WriteLine("</STYLE>")
        writer.WriteLine("</head>")
        writer.WriteLine("<body>")
        writer.WriteLine("<div class='Title'>Export Exceptions for {0}</div>", fileName)
        writer.WriteLine("<div style='font-size: xx-small;'><i>{0}</i></div>", Date.Now.ToString)
        writer.WriteLine("<table class='NotifyTable'>")
        writer.WriteLine("<tr><td class='HeaderCell'>Exception</td><td class='HeaderCell'>Value</td></tr>")

        'Write contents of report
        For Each reportRow As ExceptionReportRow In mExceptionReport
            WriteCmsExceptionRow(writer, reportRow)
        Next

        'Finish up the report HTML
        writer.WriteLine("</table>")
        writer.WriteLine("</body>")
        writer.WriteLine("</html>")

    End Sub

    Private Sub WriteCmsExceptionRow(ByVal writer As IO.TextWriter, ByVal reportRow As ExceptionReportRow)

        Dim isFirst As Boolean = True

        For Each value As String In reportRow.Values
            writer.WriteLine("<tr>")
            If isFirst Then
                writer.WriteLine("<td class='ErrorCell' rowspan='{0}'>{1}</td>", reportRow.Values.Count, reportRow.Message)
            End If

            writer.WriteLine("<td class='NormalCell'>{0}</td>", value)

            writer.WriteLine("</tr>")
            isFirst = False
        Next

    End Sub

#End Region

#Region " TPS File Methods "

    Private Function CreateTPSFile(ByVal cmsFilePath As String) As String

        Dim tpsPath As String = IO.Path.ChangeExtension(cmsFilePath, ".tps.html")
        Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

        Using writer As New IO.StreamWriter(tpsPath, False)
            WriteTPSHtml(writer, fileName)
        End Using

        Return tpsPath

    End Function

    Private Sub WriteTPSHtml(ByVal writer As IO.TextWriter, ByVal fileName As String)

        'Create the report styles and header row
        writer.WriteLine("<html>")
        writer.WriteLine("<head>")
        writer.WriteLine("<STYLE>.NotifyTable {FONT-SIZE: x-small; FONT-FAMILY: Tahoma, Verdana, Arial; BACKGROUND-COLOR: White;}")
        writer.WriteLine(".HeaderCell {PADDING: 2px; FONT-WEIGHT: bold; FONT-SIZE: x-small; COLOR: #ffffff; TEXT-ALIGN: center; BACKGROUND-COLOR: #FF6600; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".NormalCell {PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WHITE-SPACE: nowrap; BACKGROUND-COLOR: #FFCC99; BORDER-RIGHT: Solid 1px White; BORDER-TOP: Solid 1px White;}")
        writer.WriteLine(".Title {FONT-SIZE: medium; FONT-WEIGHT: bold;}")
        writer.WriteLine("</STYLE>")
        writer.WriteLine("</head>")
        writer.WriteLine("<body>")
        writer.WriteLine("<div class='Title'>TPS Report for {0}</div>", fileName)
        writer.WriteLine("<div style='font-size: xx-small;'><i>{0}</i></div>", Date.Now.ToString)
        writer.WriteLine("<table class='NotifyTable'>")
        writer.WriteLine("<tr><td class='HeaderCell'>Rule Name</td><td class='HeaderCell'>Count</td><td class='HeaderCell'>Percentage</td></tr>")

        'Write contents of report
        For Each key As String In mTPSReport.Keys
            writer.Write(String.Format("<tr><td class='NormalCell'>{0}</td><td class='NormalCell'>{1}</td><td class='NormalCell'>{2:###.##%}</td></tr>", key, mTPSReport.GetCount(key), mTPSReport.GetPercentage(key)))
        Next

        'Finish up the report HTML
        writer.WriteLine("</table>")
        writer.WriteLine("</body>")
        writer.WriteLine("</html>")

    End Sub

#End Region

#Region " Exception Report Classes "

    Protected Class ExceptionReport
        Inherits Collection(Of ExceptionReportRow)

        Public Function AddRow(ByVal message As String) As ExceptionReportRow

            Dim newRow As ExceptionReportRow = New ExceptionReportRow(message)
            Add(newRow)

            Return newRow

        End Function

        Public Function AddRow(ByVal message As String, ByVal value As String) As ExceptionReportRow

            Dim newRow As ExceptionReportRow = New ExceptionReportRow(message, value)
            Add(newRow)

            Return newRow

        End Function

        Public Function AddRow(ByVal message As String, ByVal values As Collection(Of String)) As ExceptionReportRow

            Dim newRow As ExceptionReportRow = New ExceptionReportRow(message, values)
            Add(newRow)

            Return newRow

        End Function

        Public Sub AddUniqueRow(ByVal message As String)

            'Determine if this row already exists
            For Each row As ExceptionReportRow In Me
                If row.Message = message Then
                    Exit Sub
                End If
            Next

            'Add the row
            AddRow(message)

        End Sub

        Public Sub CheckForMissingSampleDaysInExports(ByVal exportSets As Collection(Of ExportSet), ByVal sampleSets As Dictionary(Of Integer, SampleSet))

            'Determine if we have any missing sample dates
            Dim missingDates As New Collection(Of String)
            Dim exportDates As New Dictionary(Of String, Boolean)

            'Get a dictionary containing all dates that need to be covered
            For Each exSet As ExportSet In exportSets
                Dim currentDate As Date = exSet.StartDate.Date

                Do While currentDate.Date <= exSet.EndDate.Date
                    'Determine if this date needs to be added to the dictionary
                    Dim datString As String = currentDate.ToString("MM/dd/yyyy")
                    If Not exportDates.ContainsKey(datString) Then
                        exportDates.Add(datString, False)
                    End If

                    'Prepare for next pass
                    currentDate = currentDate.AddDays(1)
                Loop
            Next

            'Now mark all dates that are covered by the sample sets
            For Each sampSet As SampleSet In sampleSets.Values
                Dim currentDate As Date = sampSet.SampleFromDate.Date

                Do While currentDate.Date <= sampSet.SampleToDate.Date
                    Dim datString As String = currentDate.ToString("MM/dd/yyyy")
                    If exportDates.ContainsKey(datString) Then
                        exportDates.Item(datString) = True
                    End If

                    'Prepare for next pass
                    currentDate = currentDate.AddDays(1)
                Loop
            Next

            'Determine what dates are missing
            For Each exportDate As String In exportDates.Keys
                If Not exportDates.Item(exportDate) Then
                    missingDates.Add(exportDate)
                End If
            Next

            'Add the missing dates to the exception report collection
            If missingDates.Count > 0 Then
                AddRow("The following dates for this export were not included in any SampleSet", missingDates)
            End If

        End Sub

    End Class

    Protected Class ExceptionReportRow

        Private mMessage As String = String.Empty
        Private mValues As New Collection(Of String)

        Public Property Message() As String
            Get
                Return mMessage
            End Get
            Set(ByVal value As String)
                mMessage = value
            End Set
        End Property

        Public ReadOnly Property Values() As Collection(Of String)
            Get
                Return mValues
            End Get
        End Property

        Public Sub New()

        End Sub

        Public Sub New(ByVal message As String)

            mMessage = message
            mValues.Add(String.Empty)

        End Sub

        Public Sub New(ByVal message As String, ByVal value As String)

            mMessage = message
            mValues.Add(value)

        End Sub

        Public Sub New(ByVal message As String, ByVal values As Collection(Of String))

            mMessage = message
            mValues = values

        End Sub

    End Class

#End Region

#Region " Frequency Classes "

    Protected Class FrequencyTable
        Inherits Dictionary(Of String, Frequency)

        Public Sub AddValue(ByVal fieldName As String, ByVal value As String)

            If Not ContainsKey(fieldName) Then
                Add(fieldName, New Frequency)
            End If

            Me(fieldName).AddValue(value)

        End Sub

        Public Overrides Function ToString() As String

            Dim result As String = ""

            For Each key As String In Keys
                If result.Length > 0 Then
                    result &= Environment.NewLine
                End If

                result &= String.Format("--------{0}--------------------", key)
                result &= Environment.NewLine
                result &= Me(key).ToString
            Next

            Return result

        End Function

    End Class

    Protected Class Frequency
        Inherits SortedDictionary(Of String, Integer)

        Public Sub AddValue(ByVal value As String)

            If Not ContainsKey(value) Then
                Add(value, 1)
            Else
                Me(value) += 1
            End If

        End Sub

        Public Function GetCount(ByVal value As String) As Integer

            Return Me(value)

        End Function

        Public Function GetPercentage(ByVal value As String) As Double

            Dim totalCount As Integer = 0
            For Each key As String In Keys
                totalCount += Me(key)
            Next

            Return (Me(value) / totalCount)

        End Function

        Public Overrides Function ToString() As String

            Dim result As String = ""
            For Each key As String In Keys
                If result.Length > 0 Then
                    result &= Environment.NewLine
                End If

                result &= key & vbTab & GetCount(key) & vbTab & GetPercentage(key)
            Next

            Return result

        End Function

    End Class

#End Region

#Region " TPS Classes "

    Protected Class TPSTable
        Inherits Dictionary(Of String, Integer)

        Private mRecordCount As Integer

        Public Property RecordCount() As Integer
            Get
                Return mRecordCount
            End Get
            Set(ByVal value As Integer)
                mRecordCount = value
            End Set
        End Property

        Public Sub AddValue(ByVal ruleName As String)

            If Not ContainsKey(ruleName) Then
                Add(ruleName, 1)
            Else
                Me(ruleName) += 1
            End If

        End Sub

        Public Function GetCount(ByVal ruleName As String) As Integer

            Return Me(ruleName)

        End Function

        Public Function GetPercentage(ByVal ruleName As String) As Double

            Return (Me(ruleName) / mRecordCount)

        End Function

    End Class

#End Region

End Class
