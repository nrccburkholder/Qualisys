Imports System.Data
Imports System.IO
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification
Imports system.Text.RegularExpressions

Public Class TranslatorVovici

#Region "Private Fields"

    Private msurveyInfo As DataSet

#End Region

#Region "Constructors"

    Public Sub New(ByVal surveyInfo As DataSet)

        msurveyInfo = surveyInfo

    End Sub

#End Region

#Region "Public Methods"

    ''' <summary>
    ''' Takes a result dataset from a Vovici survey and converts it into a CSV file format
    '''  for the transfer results service to pick up and process.
    ''' </summary>
    ''' <param name="projectID">The Vovici survey ID</param>
    ''' <param name="fileName">The file path and name for the output files</param>
    ''' <param name="results">The dataset returned from Vovici with the survey result data</param>
    ''' <remarks></remarks>
    Public Sub Translate(ByVal projectID As Integer, ByVal fileName As String, ByVal results As DataView)

        'Load the file into a properly structured dataset
        Dim outputSet As DataSet = PopulateDataSet(results)

        'Generate formated output CSV file for dataset
        CreateCSVOutputFile(projectID, String.Concat(fileName, ".csv"), outputSet)

    End Sub

    Public Sub SendNQLNotification(ByVal fileFullName As String, ByVal fileName As String, ByVal cultureCode As String)

        Dim toList As New List(Of String)
        Dim ccList As New List(Of String)
        Dim bccList As New List(Of String)
        Dim environmentName As String = String.Empty
        Dim langID As String = String.Empty
        Dim language As String = String.Empty

        Dim cultFromLangId As CultureToLanguage = CultureToLanguage.GetByCultureCode(cultureCode)
        If cultFromLangId Is Nothing Then
            langID = "0"
            language = String.Concat("Unknown - culture code ", cultureCode)
        Else
            langID = cultFromLangId.LangID.ToString
            language = cultFromLangId.Language
        End If

        'Add toList group
        toList.Add("Translators@nationalresearch.com")

        'Determine recipients bases on the environment
        If AppConfig.EnvironmentType <> EnvironmentTypes.Production Then
            'We are not in production
            'Clear the lists
            toList.Clear()
            ccList.Clear()
            bccList.Clear()

            'Populate the toList with the Testing group only
            toList.Add("Testing@NRCPicker.com")

            'Set the environment string
            environmentName = String.Format("({0})", AppConfig.EnvironmentName)
        End If

        'Create the message object
        Dim msg As Message = New Message("NQLFileNotice", AppConfig.SMTPServer)

        'Set the message properties
        With msg
            'To recipient
            For Each email As String In toList
                .To.Add(email)
            Next

            'Cc recipient
            For Each email As String In ccList
                .Cc.Add(email)
            Next

            'Bcc recipient
            For Each email As String In bccList
                .Bcc.Add(email)
            Next

            'Add the replacement values
            With .ReplacementValues
                .Add("Environment", environmentName)
                .Add("Language", language)
                .Add("LanguageID", langID)
                .Add("DateRecieved", Now.ToString("MM/dd/yyyy"))
                .Add("FileName", fileName)
                .Add("FileLink", fileFullName)
            End With

            'Merge the template
            .MergeTemplate()

            'Send the message
            .Send()
        End With

    End Sub

#End Region

#Region "Private Methods"

    Private Function GetEmptyDataSet() As DataSet

        Dim empty As New DataSet
        Dim table As DataTable

        'Add the FileInfo table
        table = New DataTable("FileInfo")
        With table.Columns
            .Add("VendorCode", GetType(String))
            .Add("FileVersion", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the Survey table
        table = New DataTable("Litho")
        With table.Columns
            .Add("SurveyID", GetType(Integer))
            .Add("LithoCode", GetType(String))
            .Add("ResponseType", GetType(String))
            .Add("SurveyLang", GetType(String))
            .Add("DispositionCode", GetType(String))
            .Add("DispositionDate", GetType(Date))
            .Add("IsFinal", GetType(Integer))
        End With
        empty.Tables.Add(table)

        'Add the Bubble table
        table = New DataTable("Bubble")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("QstnCore", GetType(String))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and Bubble
        empty.Relations.Add("LithoBubble", empty.Tables("Litho").Columns("LithoCode"), empty.Tables("Bubble").Columns("LithoCode"), True)

        'Add the HandEntry table
        table = New DataTable("HandEntry")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("QstnCore", GetType(String))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and HandEntry
        empty.Relations.Add("LithoHandEntry", empty.Tables("Litho").Columns("LithoCode"), empty.Tables("HandEntry").Columns("LithoCode"), True)

        'Add the Comment table
        table = New DataTable("Comment")
        With table.Columns
            .Add("LithoCode", GetType(String))
            .Add("QstnCore", GetType(String))
            .Add("Value", GetType(String))
        End With
        empty.Tables.Add(table)

        'Add the relationship between Respondent and Comment
        empty.Relations.Add("LithoComment", empty.Tables("Litho").Columns("LithoCode"), empty.Tables("Comment").Columns("LithoCode"), True)

        'Make sure we are enforcing the constraints
        empty.EnforceConstraints = True

        'Return the empty dataset
        Return empty

    End Function

    Private Function PopulateDataSet(ByVal table As DataView) As DataSet

        Dim rowCount As Integer
        Dim lithoCode As String = String.Empty
        Dim surveyID As Integer
        Dim sampleSetID As Integer
        Dim dispoDate As Date
        Dim questionValue As Integer
        Dim validateSampleSets As New Dictionary(Of Integer, DataSet)
        Dim scaleTable As DataTable = Nothing
        Dim multiResponse As Boolean

        'Create the DataSet object
        Dim loadSet As DataSet = GetEmptyDataSet()

        'Get the schema of the table
        Dim schema As DataTable = table.Table.CreateDataReader.GetSchemaTable

        'Add the FileInfo record
        loadSet.Tables("FileInfo").Rows.Add("003", "2.0")

        For Each row As DataRowView In table
            'Increment the row counter
            rowCount += 1

            'Determine the LithoCode
            lithoCode = row("Q2_1").ToString.Trim
            If String.IsNullOrEmpty(lithoCode) Then
                lithoCode = String.Concat("BLANK", rowCount.ToString)
            End If

            'Get the SurveyID
            Dim vendorWebFileData As VendorWebFile_Data = VendorWebFile_Data.GetByLitho(lithoCode)
            If vendorWebFileData Is Nothing Then
                'Invalid survey ID found.
                surveyID = -1
                sampleSetID = -1
            Else
                surveyID = vendorWebFileData.SurveyId
                sampleSetID = vendorWebFileData.SamplesetId
            End If

            'Get survey scale value data
            If Not validateSampleSets.ContainsKey(sampleSetID) Then
                validateSampleSets.Add(sampleSetID, TranslatorProvider.Instance.GetVoviciSurveyScaleValues(surveyID, sampleSetID))
            End If
            scaleTable = validateSampleSets.Item(sampleSetID).Tables(0)

            'Add the Disposition Date
            If Not Date.TryParse(row("COMPLETED").ToString, dispoDate) Then
                loadSet.Tables("Litho").Rows.Add(surveyID, lithoCode, "Web", row("Culture").ToString.Trim, "001", DBNull.Value, 1)
            Else
                loadSet.Tables("Litho").Rows.Add(surveyID, lithoCode, "Web", row("Culture").ToString.Trim, "001", dispoDate.ToLocalTime, 1)
            End If

            'Add the question results
            For Each schemaRow As DataRow In schema.Rows
                Dim colName As String = schemaRow("ColumnName").ToString
                Dim surveyRow As DataRow
                Dim qstnIdRow As DataRow() = Nothing

                If colName.StartsWith("Q") Then
                    'Check the "Question" table
                    If msurveyInfo.Tables.Contains("Question") Then
                        qstnIdRow = msurveyInfo.Tables("Question").Select(String.Format("column = '{0}'", colName.Replace("SPECIFIED", "")))
                    End If

                    'Check the choosemany table "Choice"
                    If qstnIdRow Is Nothing OrElse qstnIdRow.GetLength(0) <= 0 Then
                        If msurveyInfo.Tables.Contains("Choice") Then
                            '2013-1202 Defect found while doing Canada Qualisys Upgrade UAT
                            'The current logic had a bug which requires any Vovici survey which has a ChooseOne with HandEntry question
                            'to have at least one other ChooseMany question. Which causes the underlying Choice table to have a "column" Column
                            'otherwise doing a Select() on the database based con "column" threw an exception.
                            'Column [column] not found.
                            Dim choiceTable As DataTable = msurveyInfo.Tables("Choice")
                            If choiceTable.Columns.Contains("column") Then
                                Dim whereChoice As String = String.Format("column = '{0}'", colName.Replace("SPECIFIED", ""))
                                qstnIdRow = choiceTable.Select(whereChoice)
                            End If
                        End If
                    End If

                    'Not found, so last check the "Option" table
                    If qstnIdRow Is Nothing OrElse qstnIdRow.GetLength(0) <= 0 Then
                        If msurveyInfo.Tables.Contains("Option") Then
                            qstnIdRow = msurveyInfo.Tables("Option").Select(String.Format("column = '{0}'", colName.Replace("SPECIFIED", "")))
                        End If
                    End If

                    'Check the choosemany table "Choice"
                    If qstnIdRow Is Nothing OrElse qstnIdRow.GetLength(0) <= 0 Then
                        If msurveyInfo.Tables.Contains("Choice") Then
                            If msurveyInfo.Tables("Choice").Columns.Contains("specify") Then
                                qstnIdRow = msurveyInfo.Tables("Choice").Select(String.Format("specify = '{0}'", colName))
                            End If
                        End If
                    End If

                    Dim qstnId As Integer = CInt(CType(qstnIdRow.GetValue(0), DataRow).Item("Question_Id"))
                    qstnIdRow = Nothing

                    surveyRow = CType(msurveyInfo.Tables("Question").Select("Question_Id = " & qstnId.ToString).GetValue(0), DataRow)
                    Dim qstnCore As String = surveyRow("heading").ToString

                    If (qstnCore.StartsWith("Q") OrElse qstnCore.StartsWith("C")) AndAlso IsNumeric(qstnCore.Substring(1)) Then
                        If IsQuestionColumn(colName, qstnCore, multiResponse) Then
                            'Add this question
                            If Integer.TryParse(row(colName).ToString.Trim, questionValue) Then
                                If questionValue > 99000 Then
                                    questionValue = questionValue - 100000
                                End If

                                loadSet.Tables("Bubble").Rows.Add(lithoCode, qstnCore, FindMultiResponseScaleValue(multiResponse, colName, qstnCore, questionValue.ToString, scaleTable))
                            Else
                                loadSet.Tables("Bubble").Rows.Add(lithoCode, qstnCore, FindMultiResponseScaleValue(multiResponse, colName, qstnCore, row(colName).ToString.Trim, scaleTable))
                            End If

                        ElseIf IsHandEntryColumn(colName, qstnCore, multiResponse) Then
                            'I added the multiresponse. Multiresponse will have the value from the previous question. If it is true it is a multi-response question.
                            'Add this Hand Entry
                            '2013-1001 Hand Entry was missing the double quote wrapping logic that Comment has and therefore
                            'caused the CSV files to be broken.
                            'Discovered during UAT of INC for special characters
                            loadSet.Tables("HandEntry").Rows.Add(lithoCode, qstnCore, EscapeFreeText(row(colName).ToString))

                        ElseIf IsCommentColumn(colName, qstnCore) Then
                            'Add this comment
                            loadSet.Tables("Comment").Rows.Add(lithoCode, qstnCore, EscapeFreeText(row(colName).ToString))

                        End If
                    End If
                End If
            Next
        Next

        Return loadSet
    End Function

    ''' <summary>
    ''' Refactored escape quote logic for comment and hand-entries.
    ''' </summary>
    ''' <param name="value"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Shared Function EscapeFreeText(ByVal value As String) As String
        Dim escaped As String
        escaped = String.Concat("""", value.Replace(vbCrLf, " ").Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty).Trim.Replace("""", "'"), """")
        EscapeFreeText = escaped
    End Function

    Private Sub CreateCSVOutputFile(ByVal projectID As Integer, ByVal fileName As String, ByVal outputSet As DataSet)

        Using sw As StreamWriter = New StreamWriter(fileName)
            'Build header record
            Dim sb As New Text.StringBuilder

            'Add file information columns to header
            For Each col As DataColumn In outputSet.Tables("FileInfo").Columns
                sb.Append(col.ColumnName.ToString).Append(",")
            Next

            'Add litho columns to header
            For Each col As DataColumn In outputSet.Tables("Litho").Columns
                sb.Append(col.ColumnName.ToString).Append(",")
            Next

            sb.Remove(sb.Length - 1, 1) 'Remove end comma

            'Add bubble columns to header
            For Each row As DataRow In outputSet.Tables("Bubble").Select(String.Format("LithoCode = '{0}'", outputSet.Tables("Litho").Rows(0).Item("LithoCode").ToString))
                sb.Append(",").Append(row("QstnCore").ToString)
            Next

            'Add comment columns to header
            For Each row As DataRow In outputSet.Tables("Comment").Select(String.Format("LithoCode = '{0}'", outputSet.Tables("Litho").Rows(0).Item("LithoCode").ToString))
                sb.Append(",").Append(row("QstnCore").ToString)
            Next

            'Add handentry columns to header
            For Each row As DataRow In outputSet.Tables("HandEntry").Select(String.Format("LithoCode = '{0}'", outputSet.Tables("Litho").Rows(0).Item("LithoCode").ToString))
                sb.Append(",").Append(row("QstnCore").ToString)
            Next

            'write header record.
            sw.WriteLine(sb.ToString)


            'Build question results
            For Each lithoRow As DataRow In outputSet.Tables("Litho").Rows
                sb = New Text.StringBuilder

                'Add file information
                For Each fileInfoRow As DataRow In outputSet.Tables("FileInfo").Rows
                    sb.Append(fileInfoRow("VendorCode").ToString).Append(",")
                    sb.Append(fileInfoRow("FileVersion").ToString).Append(",")
                Next

                'Add litho information
                If CInt(lithoRow("SurveyID")) = -1 Then
                    sb.Append(String.Empty).Append(",")
                Else
                    sb.Append(lithoRow("SurveyID").ToString).Append(",")
                End If
                If lithoRow("LithoCode").ToString.StartsWith("BLANK") Then
                    sb.Append(String.Empty).Append(",")
                Else
                    sb.Append(lithoRow("LithoCode").ToString).Append(",")
                End If
                sb.Append(lithoRow("ResponseType").ToString).Append(",")
                sb.Append(lithoRow("SurveyLang").ToString).Append(",")
                sb.Append(lithoRow("DispositionCode").ToString).Append(",")
                If lithoRow("DispositionCode").ToString.Trim = String.Empty Then
                    sb.Append(String.Empty).Append(",")
                Else
                    sb.Append(CDate(lithoRow("DispositionDate")).ToString("MM/dd/yyyy HH:mm")).Append(",")
                End If

                sb.Append(lithoRow("IsFinal").ToString)

                'Add bubble results
                For Each bubbleRow As DataRow In lithoRow.GetChildRows("LithoBubble")
                    sb.Append(",").Append(bubbleRow("Value").ToString)
                Next

                'Add comment results
                For Each commentRow As DataRow In lithoRow.GetChildRows("LithoComment")
                    sb.Append(",").Append(commentRow("Value").ToString)
                Next

                'Add handentry results
                For Each handEntryRow As DataRow In lithoRow.GetChildRows("LithoHandEntry")
                    sb.Append(",").Append(handEntryRow("Value").ToString)
                Next

                'Write question result record.
                sw.WriteLine(sb.ToString)
            Next

            sw.Flush()
            sw.Close()
        End Using

    End Sub

    Private Function IsQuestionColumn(ByVal columnName As String, ByRef qstnCore As String, ByRef multiResponse As Boolean) As Boolean

        If qstnCore.StartsWith("Q") AndAlso Not columnName.Contains("SPECIFIED") Then
            'This is a question column
            If Not columnName.Contains("_") Then
                qstnCore = qstnCore
                multiResponse = False
                Return True
            Else
                qstnCore = String.Concat(qstnCore, Chr(64 + CInt(columnName.Split("_".ToCharArray).GetValue(1))))
                multiResponse = True
                Return True
            End If
        End If

        Return False

    End Function

    Private Function IsCommentColumn(ByVal columnName As String, ByRef qstnCore As String) As Boolean

        If qstnCore.StartsWith("C") Then
            'This is a comment column
            qstnCore = qstnCore
            Return True
        End If

        Return False

    End Function

    Private Function IsHandEntryColumn(ByVal columnName As String, ByRef qstnCore As String, ByVal multiResponse As Boolean) As Boolean

        If columnName.Contains("SPECIFIED") Then
            'This is a hand entry column
            If columnName.Contains("_") And Not multiResponse Then
                qstnCore = qstnCore.Replace("Q", "H")
                Return True
            Else
                qstnCore = qstnCore.Substring(0, 1).Replace("Q", "H") & qstnCore.Substring(1)
                qstnCore = String.Concat(qstnCore, Chr(64 + CInt(columnName.Split("_".ToCharArray).GetValue(1))))
                Return True
            End If

        End If

        Return False

    End Function

    Private Function FindMultiResponseScaleValue(ByVal multiResponse As Boolean, ByVal columnName As String, ByVal qstnCore As String, ByVal value As String, ByVal scaleTable As DataTable) As String

        If multiResponse AndAlso value = "1" Then
            'Strip out alpha characters
            qstnCore = Regex.Replace(qstnCore, "[^0-9]", String.Empty)

            Dim scale As DataRow() = scaleTable.Select(String.Format("QSTNCORE = {0} AND Item = {1}", qstnCore.Replace("Q", String.Empty), columnName.Split("_".ToCharArray).GetValue(1).ToString))
            If scale.GetLength(0) = 0 Then
                Return value
            Else
                Return scale(0).Item("Val").ToString
            End If
        ElseIf multiResponse AndAlso value = "0" Then
            Return String.Empty
        Else
            Return value
        End If

    End Function

#End Region

End Class
