Friend Class StandardExporter
    Inherits Exporter

    Friend Overrides Function CreateExportFile(ByVal exportSets As Collection(Of ExportSet), ByVal filePath As String, ByVal fileType As ExportFileType, ByVal includeOnlyReturns As Boolean, ByVal includeOnlyDirects As Boolean, ByVal includePhoneFields As Boolean, ByVal createdEmployeeName As String, ByVal isScheduledExport As Boolean) As Integer
        Dim exportGuid As Guid = Guid.NewGuid
        Dim exportSetIds As List(Of Int32) = Nothing
        Dim exportSuccessful As Boolean = False
        Dim errorMessage As String = ""
        Dim stackTrace As String = ""
        Dim recordCount As Integer = 0
        Dim filePartCount As Integer = 1
        Dim newId As Integer

        Try
            'Build the list of ExportSet IDs
            exportSetIds = BuildListOfExportSetIDs(exportSets)

            'Get the export data reader
            Using rdr As IDataReader = DataProvider.Instance.SelectExportFileData(exportSetIds.ToArray, includeOnlyReturns, includeOnlyDirects, includePhoneFields, exportGuid, False, True)
                'Write the file to the appropriate file type
                Select Case fileType
                    Case ExportFileType.DBase
                        recordCount = CreateExportDbfFile(rdr, filePath, filePartCount)
                    Case ExportFileType.Csv
                        recordCount = CreateExportCsvFile(rdr, filePath)
                    Case ExportFileType.Xml
                        recordCount = CreateExportXmlFile(rdr, filePath)
                    Case Else
                        'Throw New ArgumentException("The file type " & fileType.ToString & " is not supported.")
                End Select
            End Using

            exportSuccessful = True
        Catch ex As Exception
            exportSuccessful = False
            errorMessage = ex.Message
            stackTrace = ex.ToString
            Throw New ExportFileCreationException("Export file creation failed: " & ex.Message, ex)
        Finally

            If exportSuccessful Then
                'Insert the success record into the ExportFile log
                newId = DataProvider.Instance.InsertExportFile(recordCount, createdEmployeeName, filePath, filePartCount, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, isScheduledExport)
            Else
                'Insert the failure record into the ExportFile log
                newId = DataProvider.Instance.InsertExportFile(0, createdEmployeeName, filePath, 0, fileType, exportGuid, includeOnlyReturns, includeOnlyDirects, isScheduledExport, False, errorMessage, stackTrace, isScheduledExport, "", "", "")
            End If

            'Insert the export sets for the export file
            For Each id As Integer In exportSetIds
                DataProvider.Instance.InsertExportFileExportSet(id, newId)
            Next
        End Try
        Return newId
    End Function

End Class
