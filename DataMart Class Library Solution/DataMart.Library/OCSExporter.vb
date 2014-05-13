Friend Class OCSExporter
    Inherits HHCAHPSExporter

    Friend Overrides Function CreateExportFile(ByVal ocsMedicareExportSet As MedicareExportSet, _
                                               ByVal medicareExportSets As System.Collections.ObjectModel.Collection(Of MedicareExportSet), _
                                               ByVal folderPath As String, ByVal fileExtension As String, ByVal fileType As ExportFileType, _
                                               ByVal isScheduledExport As Boolean) As Integer

        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim exportSuccessful As Boolean
        Dim errorMessage As String = String.Empty
        Dim stackTrace As String = String.Empty
        Dim fileCount As Integer = 0
        Dim encoding As System.Text.Encoding = New System.Text.UTF8Encoding(False)
        Dim stream As IO.StreamWriter = Nothing
        Dim writer As System.Xml.XmlTextWriter = Nothing

        'Set export type
        mExportType = CType(ocsMedicareExportSet.ExportSetTypeID, ExportSetType)

        'Set the file name
        Dim filepath As String = String.Format("{0}\{1}\{2}\{3}.{4}", folderPath, "OCS", ocsMedicareExportSet.ExportStartDate.ToString("yyyyMMM"), ocsMedicareExportSet.ExportName, fileExtension)

        'Build output directory
        If Not IO.Directory.Exists(IO.Path.GetDirectoryName(filepath)) Then IO.Directory.CreateDirectory(IO.Path.GetDirectoryName(filepath))

        'Clear any existing files in output directory
        ClearPathFolder(filepath, fileExtension)

        Try
            For Each medicareExportSet As MedicareExportSet In medicareExportSets
                If IO.File.Exists(filepath) Then
                    Dim fileInfo As New IO.FileInfo(filepath)

                    'Check file size, not to exceed 100 MB, so build new one after 90 MB
                    If fileInfo.Length >= 90000000 Then
                        'Add closing element to file </monthlydata>
                        writer.WriteEndElement()

                        'Close the XML file
                        writer.Flush()
                        writer.Close()
                        stream.Close()

                        'Insert ExportFile record
                        InsertExportFileLog(exportSuccessful, ocsMedicareExportSet, filepath, recordCount, filePartCount, isScheduledExport, errorMessage, stackTrace, fileType)

                        'Get new file name
                        fileCount += 1
                        filepath = String.Format("{0}\{1}_{2}.{3}", IO.Path.GetDirectoryName(filepath), IO.Path.GetFileNameWithoutExtension(filepath), fileCount, fileExtension)

                        'Create new file
                        stream = New IO.StreamWriter(filepath, True, encoding)
                        writer = New System.Xml.XmlTextWriter(stream)

                        'Write out the file header information
                        writer.Formatting = Xml.Formatting.Indented
                        writer.WriteRaw("<?xml version=""1.0"" encoding=""UTF-8""?>")
                        writer.WriteStartElement("monthlydata")
                        writer.WriteAttributeString("xmlns", "http://homehealthcahps.rti.org")
                        writer.WriteAttributeString("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")

                        'Reset variables
                        recordCount = 0
                        exportSuccessful = False
                        errorMessage = String.Empty
                        stackTrace = String.Empty
                        filePartCount = 1
                    End If
                Else
                    'Create new file
                    stream = New IO.StreamWriter(filepath, True, encoding)
                    writer = New System.Xml.XmlTextWriter(stream)

                    'Write out the file header information
                    writer.Formatting = Xml.Formatting.Indented
                    writer.WriteRaw("<?xml version=""1.0"" encoding=""UTF-8""?>")
                    writer.WriteStartElement("monthlydata")
                    writer.WriteAttributeString("xmlns", "http://homehealthcahps.rti.org")
                    writer.WriteAttributeString("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
                End If

                'Get the export data reader
                Using rdr As IDataReader = GetRecodeReader(DataProvider.Instance.SelectOCSExportFileData(medicareExportSet.ExportFileGUID))
                    'Check for records
                    If rdr.Read Then
                        'Generate the export file in the specified file type
                        Select Case fileType
                            Case ExportFileType.Xml
                                'Create the exception report
                                Dim sampleSets As New Dictionary(Of Integer, SampleSet)
                                mExceptionReport = New ExceptionReport()
                                mTPSReport = New TPSTable

                                'Write out the XML file
                                recordCount += CreateExportCmsFile(rdr, writer, sampleSets)

                                exportSuccessful = True

                            Case Else
                                Throw New ArgumentException(String.Format("The file type {0} is not supported.", fileType))

                        End Select
                    End If
                End Using
            Next

        Catch ex As Exception
            exportSuccessful = False
            errorMessage = ex.Message
            stackTrace = ex.ToString
            recordCount = 0
            filePartCount = 0

        Finally
            If writer IsNot Nothing Then
                'Add closing element to file </monthlydata>
                writer.WriteEndElement()
                writer.Flush()
                writer.Close()
                stream.Close()
            End If

            'Insert ExportFile record
            InsertExportFileLog(exportSuccessful, ocsMedicareExportSet, filepath, recordCount, filePartCount, isScheduledExport, errorMessage, stackTrace, fileType)
        End Try

        Return fileCount + 1

    End Function

#Region " Protected Overrides "

    Protected Overrides Function GetRecodeReader(ByVal rdr As System.Data.IDataReader) As System.Data.IDataReader

        Return New OCSRecodeReader(rdr, mExportType)

    End Function

    Protected Shadows Function CreateExportCmsFile(ByVal reader As IDataReader, ByVal writer As System.Xml.XmlTextWriter, _
                                                   ByVal sampleSets As Dictionary(Of Integer, SampleSet)) As Integer

        Dim recordCount As Integer = 0

        'Write the header section
        WriteXmlHeader(reader, writer)

        'Make sure there is another result set
        If Not reader.NextResult Then
            Throw New ExportFileCreationException("The CMS export is missing the patient level result set.")
        End If

        'Write the patient section
        recordCount = WriteXmlPatientData(reader, writer, sampleSets)

        writer.Flush()

        Return recordCount

    End Function

    Protected Overrides Function WriteXmlPatientData(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter, ByVal sampleSets As Dictionary(Of Integer, SampleSet)) As Integer

        Dim recordCount As Integer = 0

        'Write out the patient data for each patient
        While reader.Read
            'Write the start element
            writer.WriteStartElement("patientleveldata")

            'Write the admin section
            WriteXmlAdminElement(reader, writer, sampleSets)

            'Write the patient responce section if applicable
            If CInt(reader("lag-time")) <> 888 Then 'IF IS A RESPONSE
                BeginXmlResponseElement(writer)
                WriteXmlResponseElement(reader, writer)
                EndXmlResponseElement(writer)
            End If

            'Write the OCS section
            If mExportType = ExportSetType.OCSClient Then
                WriteXmlOCSElement(reader, writer)
            End If

            'Increment the record count
            recordCount += 1

            'Write the end element
            writer.WriteEndElement()
        End While

        'Return the total record count
        Return recordCount

    End Function

#End Region

#Region " Private Methods "

    Private Shared Sub WriteXmlOCSElement(ByVal reader As IDataReader, ByVal writer As Xml.XmlTextWriter)

        'Write the start element
        writer.WriteStartElement("ocs")

        'Write the admin information
        writer.WriteElementString("patient-id", reader("patient-id").ToString)
        writer.WriteElementString("soc-date", reader("soc-date").ToString)
        writer.WriteElementString("branch-id", reader("branch-id").ToString)

        'Write the end element
        writer.WriteEndElement()

    End Sub

    Private Shared Sub InsertExportFileLog(ByVal exportSuccessful As Boolean, ByVal ocsMedicareExportSet As MedicareExportSet, ByVal filepath As String, ByVal recordCount As Integer, ByVal filePartCount As Integer, ByVal isScheduledExport As Boolean, ByVal errorMessage As String, ByVal StackTrace As String, ByVal fileType As ExportFileType)

        Dim newId As Integer = DataProvider.Instance.InsertExportFile(recordCount, ocsMedicareExportSet.CreatedEmployeeName, filepath, filePartCount, fileType, ocsMedicareExportSet.ExportFileGUID, ocsMedicareExportSet.ReturnsOnly, ocsMedicareExportSet.DirectsOnly, isScheduledExport, exportSuccessful, errorMessage, StackTrace, isScheduledExport, String.Empty, String.Empty, String.Empty)

        'Insert the export sets for the export file
        DataProvider.Instance.InsertExportFileExportSet(0, ocsMedicareExportSet.MedicareExportSetId, newId)

    End Sub

    Private Shared Sub ClearPathFolder(ByVal filepath As String, ByVal fileExtension As String)

        'Delete all existing files in output folder
        For Each fileName As String In IO.Directory.GetFiles(IO.Path.GetDirectoryName(filepath), String.Format("{0}*.{1}", IO.Path.GetFileNameWithoutExtension(filepath), fileExtension))
            IO.File.Delete(fileName)
        Next

    End Sub

#End Region

End Class
