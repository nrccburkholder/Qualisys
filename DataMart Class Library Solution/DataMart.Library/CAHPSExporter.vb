Friend MustInherit Class CAHPSExporter

    Protected mExceptionReport As ExceptionReport
    Protected mTPSReport As TPSTable
    Protected mExportType As ExportSetType

    Friend Shared Function GetExporter(ByVal exportType As ExportSetType) As CAHPSExporter

        Select Case exportType
            'Case ExportSetType.CmsHcahps
            '    Return New CmsExporter

            'Case ExportSetType.CmsChart
            '    Return New ChartExporter

            Case ExportSetType.CmsHHcahps
                Return New HHCAHPSExporter

            Case ExportSetType.OCSClient, ExportSetType.OCSNonClient
                Return New OCSExporter

            Case Else
                Throw New ArgumentOutOfRangeException("exportType")

        End Select

    End Function

    'Used for OCSExporter only
    'OCSExporter contains the overriding shadows method
    Friend Overridable Function CreateExportFile(ByVal ocsMedicareExportSet As MedicareExportSet, _
                                                 ByVal medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet), _
                                                 ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                                 ByVal isScheduledExport As Boolean) As Integer

        Throw New ExportFileCreationException("Accessing invalid CreateExportFile function in CAHPSExporter class")

    End Function

    Friend Overridable Function CreateExportFile(ByVal medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet), _
                                                 ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                                 ByVal isScheduledExport As Boolean) As Integer

        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim exportSuccessful As Boolean
        Dim errorMessage As String = String.Empty
        Dim stackTrace As String = String.Empty
        Dim newId As Integer = 0
        Dim filepath As String = String.Empty
        Dim failedCount As Integer = 0

        For Each medicareExportSet As MedicareExportSet In medicareExportSets
            Try
                errorMessage = "Export file creation failed: No records exported."
                stackTrace = String.Empty
                exportSuccessful = False
                mExportType = CType(medicareExportSet.ExportSetTypeID, ExportSetType)

                Dim saveData As Boolean = False
                If mExportType = ExportSetType.CmsHHcahps Then
                    saveData = True
                End If

                'Set the file name
                filepath = String.Format("{0}\{1}\{2}\{3}.{4}", folderPath, mExportType.ToString, medicareExportSet.ExportStartDate.ToString("yyyyMMM"), medicareExportSet.ExportName, fileExtension)
                If Not IO.Directory.Exists(IO.Path.GetDirectoryName(filepath)) Then IO.Directory.CreateDirectory(IO.Path.GetDirectoryName(filepath))

                'Get the export data reader
                Using rdr As IDataReader = GetRecodeReader(DataProvider.Instance.SelectMedicareExportFileData(medicareExportSet.MedicareExportSetId, saveData, True))
                    'Get the path and filename for the header file
                    errorMessage = String.Empty
                    Dim serviceLinePath As String = GetHDOSLPath(filepath)
                    Dim headerPath As String = GetHeaderPath(filepath)

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

                            'Make sure there is another result set
                            If Not rdr.NextResult Then
                                Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                            End If

                            'Write out the patient results records
                            recordCount = CreateExportDbfFile(rdr, filepath, filePartCount)
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

                            'Make sure there is another result set
                            If Not rdr.NextResult Then
                                Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                            End If

                            'Write out the patient results records
                            recordCount = CreateExportCsvFile(rdr, filepath)
                            exportSuccessful = True

                        Case ExportFileType.Xml
                            'Create the exception report
                            Dim sampleSets As New Dictionary(Of Integer, SampleSet)
                            mExceptionReport = New ExceptionReport()
                            mTPSReport = New TPSTable

                            'Write out the XML file
                            recordCount = CreateExportCmsFile(rdr, filepath, sampleSets)

                            'Write the summary report
                            CreateCmsSummaryFile(filepath, mExportType)

                            'Write the exception report
                            CreateCmsExceptionFile(rdr, filepath, medicareExportSet, sampleSets)

                            'Write TPS Report
                            If mTPSReport.Count > 0 Then
                                mTPSReport.RecordCount = recordCount
                                Dim tpsPath As String = CreateTPSFile(filepath)

                                errorMessage = "Terminal conditions encountered."
                                stackTrace = String.Empty
                            End If

                            'Write Exception Report Error
                            If mExceptionReport.Count > 0 AndAlso String.IsNullOrEmpty(errorMessage) Then
                                errorMessage = "Exception report generated."
                                stackTrace = String.Empty
                            End If

                            If mTPSReport.Count <= 0 AndAlso mExceptionReport.Count <= 0 Then
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

            Finally
                Dim tpsPath As String = String.Empty
                Dim summaryPath As String = String.Empty
                Dim exceptionPath As String = String.Empty

                If exportSuccessful Then
                    'Insert the success record into the ExportFile log
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filepath, ".summary.html")
                    newId = DataProvider.Instance.InsertExportFile(recordCount, medicareExportSet.CreatedEmployeeName, filepath, filePartCount, fileType, medicareExportSet.ExportFileGUID, medicareExportSet.ReturnsOnly, medicareExportSet.DirectsOnly, isScheduledExport, True, "", "", isScheduledExport, tpsPath, summaryPath, exceptionPath)
                Else
                    'Insert the failure record into the ExportFile log
                    MoveErrorFile(filepath)
                    filepath = String.Format("{0}\ExportErrors\{1}", IO.Path.GetDirectoryName(filepath), IO.Path.GetFileName(filepath))

                    If Not IO.File.Exists(filepath) Then filepath = String.Empty
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".tps.html")) Then tpsPath = IO.Path.ChangeExtension(filepath, ".tps.html")
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filepath, ".summary.html")
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".exception.html")) Then exceptionPath = IO.Path.ChangeExtension(filepath, ".exception.html")

                    newId = DataProvider.Instance.InsertExportFile(0, medicareExportSet.CreatedEmployeeName, filepath, 0, fileType, medicareExportSet.ExportFileGUID, medicareExportSet.ReturnsOnly, medicareExportSet.DirectsOnly, isScheduledExport, False, errorMessage, stackTrace, isScheduledExport, tpsPath, summaryPath, exceptionPath)
                    failedCount += 1
                End If

                'Insert the export sets for the export file
                DataProvider.Instance.InsertExportFileExportSet(0, medicareExportSet.MedicareExportSetId, newId)
            End Try

        Next

        Return failedCount

    End Function

    Friend Overridable Function CreateExportFile(ByVal exportSets As System.Collections.ObjectModel.Collection(Of ExportSet), _
                                          ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                          ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, _
                                          ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer

        Dim exportGuid As Guid
        Dim exportSetIds As List(Of Integer) = Nothing
        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim exportSuccessful As Boolean
        Dim errorMessage As String = String.Empty
        Dim stackTrace As String = String.Empty
        Dim newId As Integer = 0
        Dim filepath As String = String.Empty
        Dim failedCount As Integer = 0

        For Each exportSet As ExportSet In exportSets
            Try
                errorMessage = String.Empty
                stackTrace = String.Empty
                exportSetIds = New List(Of Integer)
                exportGuid = Guid.NewGuid
                exportSuccessful = False
                mExportType = exportSet.ExportSetType

                Dim saveData As Boolean = False
                If mExportType = ExportSetType.CmsHHcahps Then
                    saveData = True
                End If

                filepath = String.Format("{0}\{1}\{2}\{3}.{4}", folderPath, mExportType.ToString, exportSet.StartDate.ToString("yyyyMMM"), exportSet.Name, fileExtension)
                If Not IO.Directory.Exists(IO.Path.GetDirectoryName(filepath)) Then IO.Directory.CreateDirectory(IO.Path.GetDirectoryName(filepath))

                exportSetIds.Add(exportSet.Id)

                'Get the export data reader
                Using rdr As IDataReader = GetRecodeReader(DataProvider.Instance.SelectExportFileData(exportSetIds.ToArray, includeOnlyReturns, includeOnlyDirects, includePhoneFields, exportGuid, saveData, True))
                    'Get the path and filename for the header file
                    Dim serviceLinePath As String = GetHDOSLPath(filepath)
                    Dim headerPath As String = GetHeaderPath(filepath)

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

                            'Make sure there is another result set
                            If Not rdr.NextResult Then
                                Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                            End If

                            'Write out the patient results records
                            recordCount = CreateExportDbfFile(rdr, filepath, filePartCount)
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

                            'Make sure there is another result set
                            If Not rdr.NextResult Then
                                Throw New ExportFileCreationException("The CMS export must contain three result sets.")
                            End If

                            'Write out the patient results records
                            recordCount = CreateExportCsvFile(rdr, filepath)
                            exportSuccessful = True

                        Case ExportFileType.Xml
                            'Create the exception report
                            Dim sampleSets As New Dictionary(Of Integer, SampleSet)
                            mExceptionReport = New ExceptionReport()
                            mTPSReport = New TPSTable

                            'Write out the XML file
                            recordCount = CreateExportCmsFile(rdr, filepath, sampleSets)

                            'Write the summary report
                            CreateCmsSummaryFile(filepath, mExportType)

                            'Write the exception report
                            CreateCmsExceptionFile(rdr, filepath, exportSets, sampleSets)

                            'Write TPS Report
                            If mTPSReport.Count > 0 Then
                                mTPSReport.RecordCount = recordCount
                                Dim tpsPath As String = CreateTPSFile(filepath)

                                errorMessage = "Terminal conditions encountered."
                                stackTrace = String.Empty
                            End If

                            'Write Exception Report Error
                            If mExceptionReport.Count > 0 AndAlso String.IsNullOrEmpty(errorMessage) Then
                                errorMessage = "Exception report generated."
                                stackTrace = String.Empty
                            End If

                            If mTPSReport.Count <= 0 AndAlso mExceptionReport.Count <= 0 Then
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

            Finally
                Dim tpsPath As String = String.Empty
                Dim summaryPath As String = String.Empty
                Dim exceptionPath As String = String.Empty

                If exportSuccessful Then
                    'Insert the success record into the ExportFile log
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filepath, ".summary.html")
                    newId = DataProvider.Instance.InsertExportFile(recordCount, createdEmployeeName, filepath, filePartCount, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, True, "", "", isScheduledExport, tpsPath, summaryPath, exceptionPath)
                Else
                    'Insert the failure record into the ExportFile log
                    MoveErrorFile(filepath)
                    filepath = String.Format("{0}\ExportErrors\{1}", IO.Path.GetDirectoryName(filepath), IO.Path.GetFileName(filepath))

                    If Not IO.File.Exists(filepath) Then filepath = String.Empty
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".tps.html")) Then tpsPath = IO.Path.ChangeExtension(filepath, ".tps.html")
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".summary.html")) Then summaryPath = IO.Path.ChangeExtension(filepath, ".summary.html")
                    If IO.File.Exists(IO.Path.ChangeExtension(filepath, ".exception.html")) Then exceptionPath = IO.Path.ChangeExtension(filepath, ".exception.html")

                    newId = DataProvider.Instance.InsertExportFile(0, createdEmployeeName, filepath, 0, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, False, errorMessage, stackTrace, isScheduledExport, tpsPath, summaryPath, exceptionPath)
                    failedCount += 1
                End If

                'Insert the export sets for the export file
                For Each id As Integer In exportSetIds
                    DataProvider.Instance.InsertExportFileExportSet(id, newId)
                Next
            End Try

        Next

        Return failedCount

    End Function

#Region " Protected Methods "

    Protected Overridable Function GetRecodeReader(ByVal rdr As IDataReader) As IDataReader

        Return New CmsRecodeReader(rdr)

    End Function

    Protected Shared Function MoveErrorFile(ByVal filePath As String) As Boolean

        'Get all related export files
        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim files As String() = IO.Directory.GetFiles(folderName, String.Format("{0}*", IO.Path.GetFileNameWithoutExtension(filePath)))

        'Create error folder
        Dim errorFolder As String = String.Format("{0}\ExportErrors", folderName)
        If Not IO.Directory.Exists(errorFolder) Then IO.Directory.CreateDirectory(errorFolder)

        'Move files to error folder
        For Each fileName As String In files
            Dim fileInfo As New IO.FileInfo(fileName)
            Dim newFileName As String = String.Format("{0}\{1}", errorFolder, fileInfo.Name)

            If IO.File.Exists(newFileName) Then IO.File.Delete(newFileName)
            IO.File.Move(fileName, newFileName)
        Next

    End Function

#Region " File Paths "

    Protected Shared Function GetHeaderPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_header{1}", fileName, extension))

    End Function

    Protected Shared Function GetSummaryPath(ByVal filePath As String) As String

        Return IO.Path.ChangeExtension(filePath, ".summary.html")

    End Function

    Protected Shared Function GetStrataPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_strata{1}", fileName, extension))

    End Function

    Protected Shared Function GetHDOSLPath(ByVal filePath As String) As String

        Dim folderName As String = IO.Path.GetDirectoryName(filePath)
        Dim fileName As String = IO.Path.GetFileNameWithoutExtension(filePath)
        Dim extension As String = IO.Path.GetExtension(filePath)

        Return IO.Path.Combine(folderName, String.Format("{0}_srvline{1}", fileName, extension))

    End Function
#End Region


#Region " Protected Export Funtions "

    Protected Shared Function CreateExportDbfFile(ByVal reader As IDataReader, ByVal filePath As String, ByRef filePartCount As Integer) As Integer
        'Create the DBF writer
        Dim writer As New Nrc.Framework.Data.DbfWriter(reader)
        For Each col As Nrc.Framework.Data.DataWriterColumn In writer.Columns
            col.IsMasterColumn = Not col.Name.StartsWith("Q0")
        Next

        Dim recordCount As Integer = writer.Write(filePath, 1000, filePartCount)

        Return recordCount
    End Function

    ''' <summary>
    ''' Creates an export CSV file
    ''' </summary>
    ''' <param name="reader">The IDataReader containing the results to write</param>
    ''' <param name="filePath">The path of the file to be created</param>
    ''' <returns>Returns the count of records written to the file</returns>
    Protected Shared Function CreateExportCsvFile(ByVal reader As IDataReader, ByVal filePath As String) As Integer
        'Create the CSV writer
        Dim writer As New Nrc.Framework.Data.CsvWriter(reader)

        Dim recordCount As Integer = writer.Write(filePath)

        Return recordCount
    End Function

    ''' <summary>
    ''' Creates an export XML file
    ''' </summary>
    ''' <param name="reader">The IDataReader containing the results to write</param>
    ''' <param name="filePath">The path of the file to be created</param>
    ''' <returns>Returns the count of records written to the file</returns>
    Protected Shared Function CreateExportXmlFile(ByVal reader As IDataReader, ByVal filePath As String) As Integer
        'Create the XML writer
        Dim writer As New Nrc.Framework.Data.XmlWriter(reader, "SurveyResults", "RepondantData")

        Dim recordCount As Integer = writer.Write(filePath)

        Return recordCount
    End Function
#End Region


#Region " XML Output "

    Protected Overridable Function CreateExportCmsFile(ByVal reader As IDataReader, ByVal filePath As String, _
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
                Select Case mExportType
                    Case ExportSetType.CmsHHcahps, ExportSetType.OCSClient, ExportSetType.OCSNonClient
                        writer.WriteAttributeString("xmlns", "http://homehealthcahps.rti.org")
                    Case Else
                        writer.WriteAttributeString("xmlns", "http://hcahps.ifmc.org")
                End Select
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

    Protected MustOverride Sub WriteXmlHeader(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

    Protected Overridable Function WriteXmlPatientData(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet)) As Integer

        Dim recordCount As Integer = 0

        'Write out the patient data for each patient
        While reader.Read
            'Write the start element
            writer.WriteStartElement("patientleveldata")

            'Write the admin section
            WriteXmlAdminElement(reader, writer, sampleSets)

            'Write the patient responce section if applicable
            'If CInt(reader("lag-time")) <> 888 Then 'IF IS A RESPONSE
            If reader("final-status").ToString = "110" OrElse reader("final-status").ToString = "120" OrElse reader("final-status").ToString = "310" Then
                BeginXmlResponseElement(writer)
                WriteXmlResponseElement(reader, writer)
                EndXmlResponseElement(writer)
            End If

            'Increment the record count
            recordCount += 1

            'Write the end element
            writer.WriteEndElement()
        End While

        'Return the total record count
        Return recordCount

    End Function

    Protected Shared Function TrimLeadingZeros(ByVal fieldAsString As String) As String
        Dim retval As String = fieldAsString
        If Microsoft.VisualBasic.IsNumeric(fieldAsString) Then
            retval = Microsoft.VisualBasic.Val(fieldAsString).ToString()
        End If
        Return retval
    End Function

    Protected MustOverride Sub WriteXmlAdminElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet))

    Protected Shared Sub BeginXmlResponseElement(ByVal writer As Xml.XmlTextWriter)

        writer.WriteStartElement("patientresponse")

    End Sub

    Protected MustOverride Sub WriteXmlResponseElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

    Protected Shared Sub EndXmlResponseElement(ByVal writer As Xml.XmlTextWriter)

        writer.WriteEndElement()

    End Sub

    Protected MustOverride Function GetRequiredQuestionCount(ByVal reader As IDataReader) As Integer

#End Region


#Region " CMS Summary File Methods "

    Protected Overridable Sub CreateCmsSummaryFile(ByVal cmsFilePath As String, ByVal exportType As ExportSetType)

        Dim freqs As FrequencyTable = GetCmsFileFrequencies(cmsFilePath, exportType)
        Dim summaryPath As String = IO.Path.ChangeExtension(cmsFilePath, ".summary.html")
        Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

        Using writer As New IO.StreamWriter(summaryPath, False)
            WriteCmsSummaryHtml(freqs, writer, fileName, exportType)
        End Using

    End Sub

    Protected MustOverride Sub WriteCmsSummaryHtml(ByVal freqTable As FrequencyTable, ByVal writer As IO.TextWriter, ByVal fileName As String, ByVal exportType As ExportSetType)

    Protected Overridable Sub SummarizeLagTimeFreqs(ByVal freqTable As FrequencyTable)

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

    Protected MustOverride Function GetCmsFileFrequencies(ByVal cmsFilePath As String, ByVal exportType As ExportSetType) As FrequencyTable

#End Region


#Region " Exception Report Methods "

    Protected Sub CreateCmsExceptionFile(ByVal reader As IDataReader, ByVal cmsFilePath As String, _
                                       ByVal medicareExportSet As MedicareExportSet, _
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
        mExceptionReport.CheckForMissingSampleDaysInExports(medicareExportSet, sampleSets)

        'Determine if we need to generate the exception report
        If mExceptionReport.Count > 0 Then
            Dim exceptionPath As String = IO.Path.ChangeExtension(cmsFilePath, ".exception.html")
            Dim fileName As String = IO.Path.GetFileName(cmsFilePath)

            Using writer As New IO.StreamWriter(exceptionPath, False)
                WriteCmsExceptionHtml(writer, fileName)
            End Using
        End If

    End Sub

    Protected Sub CreateCmsExceptionFile(ByVal reader As IDataReader, ByVal cmsFilePath As String, _
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
        writer.WriteLine(String.Format("<div class='Title'>Export Exceptions for {0}</div>", fileName))
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

    Private Shared Sub WriteCmsExceptionRow(ByVal writer As IO.TextWriter, ByVal reportRow As ExceptionReportRow)

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

    Protected Function CreateTPSFile(ByVal cmsFilePath As String) As String

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
        writer.WriteLine(String.Format("<div class='Title'>TPS Report for {0}</div>", fileName))
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

        Public Sub CheckForMissingSampleDaysInExports(ByVal medicareExportSet As MedicareExportSet, ByVal sampleSets As Dictionary(Of Integer, SampleSet))

            'Determine if we have any missing sample dates
            Dim missingDates As New Collection(Of String)
            Dim exportDates As New Dictionary(Of String, Boolean)

            'Get a dictionary containing all dates that need to be covered
            Dim currentDate As Date = medicareExportSet.ExportStartDate.Date

            Do While currentDate.Date <= medicareExportSet.ExportEndDate.Date
                'Determine if this date needs to be added to the dictionary
                Dim datString As String = currentDate.ToString("MM/dd/yyyy")
                If Not exportDates.ContainsKey(datString) Then
                    exportDates.Add(datString, False)
                End If

                'Prepare for next pass
                currentDate = currentDate.AddDays(1)
            Loop

            'Now mark all dates that are covered by the sample sets
            For Each sampSet As SampleSet In sampleSets.Values
                currentDate = sampSet.SampleFromDate.Date

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

#End Region

End Class
