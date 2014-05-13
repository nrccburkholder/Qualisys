Imports System.IO

Friend MustInherit Class Exporter

    Friend Shared Function GetExporter(ByVal exportType As ExportSetType) As Exporter
        Select Case exportType
            Case ExportSetType.Standard
                Return New StandardExporter
            Case ExportSetType.CmsHcahps
                Return New CmsExporter
                'Case ExportSetType.CmsHHcahps
                '    Return New HHCAHPSExporter
            Case ExportSetType.CmsChart
                Return New ChartExporter
                'Case ExportSetType.OCS
                '    Return New OCSExporter

            Case Else
                Throw New ArgumentOutOfRangeException("exportType")
        End Select
    End Function
    
    
    Friend MustOverride Function CreateExportFile(ByVal exportSets As Collection(Of ExportSet), _
                                    ByVal filePath As String, _
                                    ByVal fileType As ExportFileType, _
                                    ByVal includeOnlyReturns As Boolean, _
                                    ByVal includeOnlyDirects As Boolean, _
                                    ByVal includePhoneFields As Boolean, _
                                    ByVal createdEmployeeName As String, _
                                    ByVal isScheduledExport As Boolean) As Integer

   

#Region " Protected Methods "
    Protected Shared Function BuildListOfExportSetIDs(ByVal exportSets As Collection(Of ExportSet)) As List(Of Int32)
        Dim IDList As New List(Of Int32)
        For Each export As ExportSet In exportSets
            IDList.Add(export.Id)
        Next
        Return IDList
    End Function


    Protected Shared Function CreateExportDbfFile(ByVal reader As IDataReader, ByVal filePath As String, ByRef filePartCount As Integer) As Integer
        'Create the DBF writer
        Dim writer As New Nrc.Framework.Data.DbfWriter(reader)
        For Each col As Nrc.Framework.Data.DataWriterColumn In writer.Columns
            col.IsMasterColumn = Not col.Name.StartsWith("Q0")
        Next

        Dim recordCount As Integer = 0
        recordCount = writer.Write(filePath, 1000, filePartCount)

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

#Region "commented code"
    '''' <summary>
    '''' Creates an SPSS syntax file that automatically recodes the System Missing scale values
    '''' </summary>
    '''' <param name="exports">The collection of export sets to include in the file</param>
    '''' <param name="filePath">The path of the export file</param>
    '''' <remarks></remarks>
    'Protected Shared Sub CreatePadFile(ByVal exports As Collection(Of ExportSet), ByVal filePath As String)
    '    Dim surveys As New Dictionary(Of Integer, Survey)
    '    Dim studies As New Dictionary(Of Integer, String)
    '    Dim clients As New Dictionary(Of Integer, String)
    '    Dim questions As New Dictionary(Of Integer, Question)

    '    Dim SPSSSyntax As New System.Text.StringBuilder
    '    Dim svy As Survey
    '    Dim stdy As Study
    '    Dim writer As BinaryWriter

    '    filePath = Path.GetDirectoryName(filePath) & "\" & Path.GetFileNameWithoutExtension(filePath) & ".pad"
    '    writer = New BinaryWriter(New FileStream(filePath, FileMode.Create))

    '    For Each es As ExportSet In exports
    '        If Not surveys.ContainsKey(es.SurveyId) Then
    '            'create a collection of unique surveys
    '            svy = Survey.GetSurvey(es.SurveyId)
    '            surveys.Add(es.SurveyId, svy)

    '            'create a collection of the unique questions
    '            For Each qstn As Question In svy.Questions
    '                If Not questions.ContainsKey(qstn.Id) Then
    '                    questions.Add(qstn.Id, qstn)
    '                End If
    '            Next

    '            If Not studies.ContainsKey(svy.StudyId) Then
    '                'create a collection of unique studies
    '                stdy = Study.GetStudy(svy.StudyId)
    '                studies.Add(svy.StudyId, stdy.Name)

    '                If Not clients.ContainsKey(stdy.ClientId) Then
    '                    'create a collection of unique client names
    '                    clients.Add(stdy.ClientId, stdy.Client.Name)
    '                End If
    '            End If
    '        End If
    '    Next

    '    'Add the clientName(s)
    '    SPSSSyntax.Append("*")
    '    For Each name As String In clients.Values
    '        SPSSSyntax.Append(name & ",")
    '    Next
    '    SPSSSyntax.Remove(SPSSSyntax.Length - 1, 1)
    '    SPSSSyntax.Append("." & vbCrLf)

    '    'Add the study(s)
    '    SPSSSyntax.Append("*")
    '    Dim studyLabel As String = "{0} ({1}), "
    '    For Each id As Integer In studies.Keys
    '        SPSSSyntax.Append(String.Format(studyLabel, studies.Item(id), id))
    '    Next
    '    SPSSSyntax.Remove(SPSSSyntax.Length - 2, 2)
    '    SPSSSyntax.Append("." & vbCrLf)

    '    'Add the survey(s)
    '    SPSSSyntax.Append("*")
    '    Dim surveyLabel As String = "{0} ({1}), "
    '    For Each id As Integer In surveys.Keys
    '        SPSSSyntax.Append(String.Format(surveyLabel, surveys.Item(id).Name, id))
    '    Next
    '    SPSSSyntax.Remove(SPSSSyntax.Length - 2, 2)
    '    SPSSSyntax.Append("." & vbCrLf)

    '    'Add the date
    '    SPSSSyntax.Append("*")
    '    SPSSSyntax.Append(DateTime.Now)
    '    SPSSSyntax.Append("." & vbCrLf & vbCrLf)

    '    'Add Question Recodes
    '    Dim recode As System.Text.StringBuilder
    '    For Each qstn As Question In questions.Values
    '        recode = New System.Text.StringBuilder
    '        recode.Append("recode " & qstn.ColumnName & " (-9=sysmis) (-8=sysmis) (-7=sysmis) ")
    '        For Each rsp As Response In qstn.Scale.Responses
    '            recode.Append("(" & rsp.Value.ToString & "=" & rsp.Value.ToString & ") ")
    '        Next
    '        recode.Append("(else=sysmis)." & vbCrLf)
    '        SPSSSyntax.Append(recode.ToString)
    '    Next

    '    'Add Mean Scoring
    '    SPSSSyntax.Append("agg /outfile = """"" & vbCrLf)
    '    SPSSSyntax.Append("/break = x" & vbCrLf)
    '    For Each qstn As Question In questions.Values
    '        SPSSSyntax.Append("/" & qstn.ColumnName.Replace("Q", "m") & " = mean(" & qstn.ColumnName.ToString & ")" & vbCrLf)
    '    Next
    '    SPSSSyntax.Remove(SPSSSyntax.Length - 2, 2)
    '    SPSSSyntax.Append("." & vbCrLf)

    '    'Add Percents Scoring
    '    SPSSSyntax.Append("agg /outfile = """"" & vbCrLf)
    '    SPSSSyntax.Append("/break = x" & vbCrLf)
    '    Dim percentName As String
    '    For Each qstn As Question In questions.Values
    '        For Each rsp As Response In qstn.Scale.Responses
    '            percentName = "p" & qstn.Id.ToString & "_" & rsp.Value.ToString
    '            If percentName.Length > 8 Then
    '                'shorten long names
    '                percentName = percentName.Replace("_", "")
    '            End If
    '            SPSSSyntax.Append("/" & percentName & " = pin(" & qstn.ColumnName & "," & rsp.Value.ToString & "," & rsp.Value.ToString & ")" & vbCrLf)
    '        Next
    '    Next
    '    SPSSSyntax.Remove(SPSSSyntax.Length - 2, 2)
    '    SPSSSyntax.Append(".")

    '    writer.Write(System.Text.ASCIIEncoding.ASCII.GetBytes(SPSSSyntax.ToString))
    '    writer.Close()

    'End Sub
#End Region
#End Region

End Class
