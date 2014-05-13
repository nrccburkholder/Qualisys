Imports System.Data

Public Class TranslatorCSVHorz
    Inherits Translator

#Region "Private Fields"

    Private Shared mFixedColumns As Collection(Of FixedColumn)
    Private Shared mDispoColumns As Collection(Of FixedColumn)

#End Region

#Region "Public Methods"

    Public Overrides Function Translate(ByVal queueFile As QueuedTransferFile) As DataLoad

        'Move the file to a temp folder for reading
        queueFile.MoveToInProcess()

        'Read the file into a DataTable
        Dim table As DataTable = TranslatorProvider.Instance.GetDataTableCSVHorz(queueFile)

        'Load the file into a properly structured dataset
        Dim loadSet As DataSet = PopulateDataSet(queueFile, table)

        'Now lets populate the database, validate, transfer valid records, and record errors
        Dim load As DataLoad = PopulateDataLoad(loadSet, queueFile)

        'Move the file to it's final location
        queueFile.MoveToArchive(load.DataLoadId.ToString)

        'Update the loaded file
        With load
            .CurrentFilePath = queueFile.File.FullName
            .DateLoaded = DateTime.Now
            .Save()
        End With

        'Return the file
        Return load

    End Function

#End Region

#Region "Private Methods"

    Protected Overrides Function PopulateDataSet(ByVal queueFile As QueuedTransferFile, ByVal table As DataTable) As DataSet

        'Exit this place if we have no records to process
        If IsDataTableEmpty(table) Then
            'This data table is empty so throw an error
            Throw New InvalidFileException("File is empty.  File not processed!", queueFile.File.FullName)
        End If

        'Determine the file version
        Dim fileVersion As Double
        If Double.TryParse(GetFirstNonEmptyDataRow(table).Item("FileVersion").ToString, fileVersion) Then
            Select Case fileVersion
                Case 1.0
                    Return PopulateDataSet_1_0(queueFile, table)

                Case 2.0
                    Return PopulateDataSet_2_0(queueFile, table)

                Case Else
                    Throw New InvalidFileException(String.Format("Invalid FileVersion ({0}) found.  File not processed!", fileVersion.ToString("0.0")), queueFile.File.FullName)

            End Select
        Else
            Throw New InvalidFileException(String.Format("Non-numeric FileVersion ({0}) found.  File not processed!", table.Rows(0)("FileVersion").ToString), queueFile.File.FullName)
        End If

    End Function

    Private Function PopulateDataSet_1_0(ByVal queueFile As QueuedTransferFile, ByVal table As DataTable) As DataSet

        Dim rowCount As Integer
        Dim surveyID As Integer
        Dim qstnCore As Integer
        Dim multiResponse As Boolean
        Dim respValue As Integer
        Dim respString As String = String.Empty
        Dim cmntID As Integer
        Dim popMappingID As Integer
        Dim item As Integer
        Dim itemVal As Integer
        Dim line As Integer
        Dim dispoDate As Date
        Dim lithoCode As String = String.Empty
        Dim itemColumn As String = String.Empty
        Dim errorList As New List(Of TranslatorError)

        'Create the DataSet object
        Dim loadSet As DataSet = GetEmptyDataSet()

        'Get the schema of the table
        Dim schema As DataTable = table.CreateDataReader.GetSchemaTable

        'Get the quantity of disposition column sets (DispositionCodeXX, DispositionDateXX, IsFinalXX)
        Dim dispoColumnSetQuantity As Integer = GetDispoColumnSetQuantity(schema)

        'Add the FileInfo record
        loadSet.Tables("FileInfo").Rows.Add(table.Rows(0)("FileVersion"), table.Rows(0)("VendorCode"))

        'Loop through all of the records in the datatable and add them to the dataset
        For Each row As DataRow In table.Rows
            'Increment the row counter
            rowCount += 1

            'If this row is not empty then process it
            If Not IsDataRowEmpty(row) Then
                'Determine the LithoCode
                lithoCode = row("LithoCode").ToString.Trim
                If String.IsNullOrEmpty(lithoCode) Then
                    lithoCode = "BLANK" & rowCount.ToString
                    errorList.Add(New TranslatorError(rowCount, lithoCode, "LithoCode cannot be blank"))
                End If

                'Determine the SurveyID
                If Not Integer.TryParse(row("SurveyID").ToString.Trim, surveyID) Then
                    'Invalid survey ID found.
                    surveyID = -1
                    errorList.Add(New TranslatorError(rowCount, lithoCode, String.Format("SurveyID must be numeric ({0})", row("SurveyID").ToString.Trim)))
                End If

                'Add the Survey record if it does not already exist
                If loadSet.Tables("Survey").Select("SurveyID = " & surveyID.ToString).GetLength(0) = 0 Then
                    loadSet.Tables("Survey").Rows.Add(surveyID)
                End If

                'Add the Respondent record
                loadSet.Tables("Respondent").Rows.Add(surveyID, lithoCode, row("ResponseType"))

                'Add the Disposition records
                For count As Integer = 1 To dispoColumnSetQuantity
                    If Not Date.TryParse(row("DispositionDate" & count.ToString).ToString, dispoDate) Then
                        loadSet.Tables("Disposition").Rows.Add(lithoCode, row("DispositionCode" & count.ToString), DBNull.Value, row("IsFinal" & count.ToString))
                    Else
                        loadSet.Tables("Disposition").Rows.Add(lithoCode, row("DispositionCode" & count.ToString), dispoDate, row("IsFinal" & count.ToString))
                    End If
                Next

                'Parse the remainder of the record
                For Each schemaRow As DataRow In schema.Rows
                    If IsQuestionColumn(schemaRow("ColumnName").ToString, qstnCore, multiResponse) Then
                        'Get the response value
                        If Integer.TryParse(row(schemaRow("ColumnName").ToString).ToString, respValue) Then
                            respString = respValue.ToString
                        Else
                            respString = row(schemaRow("ColumnName").ToString).ToString
                        End If

                        'Add this question
                        loadSet.Tables("Bubble").Rows.Add(lithoCode, qstnCore, respString, multiResponse)

                    ElseIf IsHandEntryColumn(schemaRow("ColumnName").ToString, qstnCore, itemColumn, line) Then
                        'This is a handentry column so lets make sure it has a value
                        If Not String.IsNullOrEmpty(row(schemaRow("ColumnName").ToString).ToString) Then
                            'The handentry column has a value in it so lets make sure the corresponding question column exists
                            If schema.Select(String.Format("ColumnName = '{0}'", itemColumn)).GetLength(0) <> 0 Then
                                'The corresponding question column exists so lets make sure it contains an integer value
                                If Integer.TryParse(row(itemColumn).ToString, itemVal) Then
                                    'Get the item number associated with this value
                                    item = HandEntry.GetItemNumberFromResponseValue(lithoCode, qstnCore, itemVal)
                                Else
                                    'The corresponding question column does not contain an integer value
                                    item = -1
                                End If

                                'Add this Hand Entry
                                loadSet.Tables("HandEntry").Rows.Add(lithoCode, qstnCore, item, line, row(schemaRow("ColumnName").ToString).ToString.Trim)
                            Else
                                'The corresponding question column does not exist for this hand entry
                                errorList.Add(New TranslatorError(rowCount, lithoCode, String.Format("HandEntry column ({0}) exists without corresponding Question column ({1})", schemaRow("ColumnName").ToString, itemColumn)))
                            End If
                        End If

                    ElseIf IsCommentColumn(schemaRow("ColumnName").ToString, cmntID) Then
                        'Add this comment
                        loadSet.Tables("Comment").Rows.Add(lithoCode, cmntID, row(schemaRow("ColumnName").ToString).ToString.Trim.Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty))

                    ElseIf IsPopMappingColumn(schemaRow("ColumnName").ToString, popMappingID) Then
                        'Add this comment
                        loadSet.Tables("PopMapping").Rows.Add(lithoCode, popMappingID, row(schemaRow("ColumnName").ToString).ToString.Trim.Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty))

                    End If
                Next
            End If
        Next

        'Determine if we have encountered any errors
        If errorList.Count > 0 Then
            'Throw the required error
            Throw New InvalidFileException("Errors encountered while importing file.  File not processed!", queueFile.File.FullName, errorList)
        End If

        'Return the dataset
        Return loadSet

    End Function

    '1-18-2010 - KC - Added the field SurveyLang to the file layout in version 2.0
    Private Function PopulateDataSet_2_0(ByVal queueFile As QueuedTransferFile, ByVal table As DataTable) As DataSet

        Dim rowCount As Integer
        Dim surveyID As Integer
        Dim qstnCore As Integer
        Dim multiResponse As Boolean
        Dim respValue As Integer
        Dim respString As String = String.Empty
        Dim cmntID As Integer
        Dim popMappingID As Integer
        Dim item As Integer
        Dim itemVal As Integer
        Dim line As Integer
        Dim dispoDate As Date
        Dim lithoCode As String = String.Empty
        Dim itemColumn As String = String.Empty
        Dim errorList As New List(Of TranslatorError)
        Dim langID As Nullable(Of Integer)

        'Create the DataSet object
        Dim loadSet As DataSet = GetEmptyDataSet()

        'Get the schema of the table
        Dim schema As DataTable = table.CreateDataReader.GetSchemaTable

        'Get the quantity of disposition column sets (DispositionCodeXX, DispositionDateXX, IsFinalXX)
        Dim dispoColumnSetQuantity As Integer = GetDispoColumnSetQuantity(schema)

        'Add the FileInfo record
        loadSet.Tables("FileInfo").Rows.Add(table.Rows(0)("FileVersion"), table.Rows(0)("VendorCode"))

        'Loop through all of the records in the datatable and add them to the dataset
        For Each row As DataRow In table.Rows
            'Increment the row counter
            rowCount += 1

            'If this row is not empty then process it
            If Not IsDataRowEmpty(row) Then
                'Determine the LithoCode
                lithoCode = row("LithoCode").ToString.Trim
                If String.IsNullOrEmpty(lithoCode) Then
                    lithoCode = "BLANK" & rowCount.ToString
                    errorList.Add(New TranslatorError(rowCount, lithoCode, "LithoCode cannot be blank"))
                End If

                'Determine the SurveyID
                If Not Integer.TryParse(row("SurveyID").ToString.Trim, surveyID) Then
                    'Invalid survey ID found.
                    surveyID = -1
                    errorList.Add(New TranslatorError(rowCount, lithoCode, String.Format("SurveyID must be numeric ({0})", row("SurveyID").ToString.Trim)))
                End If

                'Add the Survey record if it does not already exist
                If loadSet.Tables("Survey").Select("SurveyID = " & surveyID.ToString).GetLength(0) = 0 Then
                    loadSet.Tables("Survey").Rows.Add(surveyID)
                End If

                'Determine the LangID
                Dim cultFromLangId As CultureToLanguage = CultureToLanguage.GetByCultureCode(row("SurveyLang").ToString.Trim)
                If Not cultFromLangId Is Nothing Then
                    langID = cultFromLangId.LangID
                Else
                    'Invalid lang ID found.
                    langID = Nothing
                End If

                'Add the Respondent record
                loadSet.Tables("Respondent").Rows.Add(surveyID, lithoCode, row("ResponseType"), langID)

                'Add the Disposition records
                For count As Integer = 1 To dispoColumnSetQuantity
                    If Not Date.TryParse(row("DispositionDate" & count.ToString).ToString, dispoDate) Then
                        loadSet.Tables("Disposition").Rows.Add(lithoCode, row("DispositionCode" & count.ToString), DBNull.Value, row("IsFinal" & count.ToString))
                    Else
                        loadSet.Tables("Disposition").Rows.Add(lithoCode, row("DispositionCode" & count.ToString), dispoDate, row("IsFinal" & count.ToString))
                    End If
                Next

                'Parse the remainder of the record
                For Each schemaRow As DataRow In schema.Rows
                    If IsQuestionColumn(schemaRow("ColumnName").ToString, qstnCore, multiResponse) Then
                        'Get the response value
                        If Integer.TryParse(row(schemaRow("ColumnName").ToString).ToString, respValue) Then
                            respString = respValue.ToString
                        Else
                            respString = row(schemaRow("ColumnName").ToString).ToString
                        End If

                        'Add this question
                        loadSet.Tables("Bubble").Rows.Add(lithoCode, qstnCore, respString, multiResponse)

                    ElseIf IsHandEntryColumn(schemaRow("ColumnName").ToString, qstnCore, itemColumn, line) Then
                        'This is a handentry column so lets make sure it has a value
                        If Not String.IsNullOrEmpty(row(schemaRow("ColumnName").ToString).ToString) Then
                            'The handentry column has a value in it so lets make sure the corresponding question column exists
                            If schema.Select(String.Format("ColumnName = '{0}'", itemColumn)).GetLength(0) <> 0 Then
                                'The corresponding question column exists so lets make sure it contains an integer value
                                If Integer.TryParse(row(itemColumn).ToString, itemVal) Then
                                    'Get the item number associated with this value
                                    item = HandEntry.GetItemNumberFromResponseValue(lithoCode, qstnCore, itemVal)
                                Else
                                    'The corresponding question column does not contain an integer value
                                    item = -1
                                End If

                                'Add this Hand Entry
                                loadSet.Tables("HandEntry").Rows.Add(lithoCode, qstnCore, item, line, row(schemaRow("ColumnName").ToString).ToString.Trim)
                            Else
                                'The corresponding question column does not exist for this hand entry
                                errorList.Add(New TranslatorError(rowCount, lithoCode, String.Format("HandEntry column ({0}) exists without corresponding Question column ({1})", schemaRow("ColumnName").ToString, itemColumn)))
                            End If
                        End If

                    ElseIf IsCommentColumn(schemaRow("ColumnName").ToString, cmntID) Then
                        'Add this comment
                        loadSet.Tables("Comment").Rows.Add(lithoCode, cmntID, row(schemaRow("ColumnName").ToString).ToString.Trim.Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty))

                    ElseIf IsPopMappingColumn(schemaRow("ColumnName").ToString, popMappingID) Then
                        'Add this comment
                        loadSet.Tables("PopMapping").Rows.Add(lithoCode, popMappingID, row(schemaRow("ColumnName").ToString).ToString.Trim.Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty))

                    End If
                Next
            End If
        Next

        'Determine if we have encountered any errors
        If errorList.Count > 0 Then
            'Throw the required error
            Throw New InvalidFileException("Errors encountered while importing file.  File not processed!", queueFile.File.FullName, errorList)
        End If

        'Return the dataset
        Return loadSet

    End Function

    Private Function GetDispoColumnSetQuantity(ByVal schema As DataTable) As Integer

        Dim dispoColumns As Collection(Of FixedColumn) = GetDispoColumns()

        'Loop through all columns in the schema
        For Each row As DataRow In schema.Rows
            For Each column As FixedColumn In dispoColumns
                If row("ColumnName").ToString.ToUpper.StartsWith(column.Name) AndAlso IsNumeric(row("ColumnName").ToString.Substring(column.Name.Length)) Then
                    column.Quantity += 1
                End If
            Next
        Next

        'Return the quantity
        Return dispoColumns(0).Quantity

    End Function

#End Region

#Region "Public Shared Methods"

    Public Shared Function DoAllFixedColumnsExist(ByVal schema As DataTable, ByRef missingColumns As String, ByVal fileVersion As Double) As Boolean

        mFixedColumns = Nothing
        Dim fixedColumns As Collection(Of FixedColumn) = GetFixedColumns()

        'Remove columns not need for the version
        Select Case fileVersion
            Case 1.0
                fixedColumns.Remove(fixedColumns.Item(5)) 'Remove SURVEYLANG
            Case 2.0
                'Do Nothing
        End Select

        'Check all columns
        For Each row As DataRow In schema.Rows
            For Each column As FixedColumn In fixedColumns
                If column.Name = row("ColumnName").ToString.ToUpper Then
                    column.Quantity += 1
                End If
            Next
        Next

        'Determine if any of the fixed columns were not found
        missingColumns = String.Empty
        For Each column As FixedColumn In fixedColumns
            If column.Quantity = 0 Then
                If missingColumns.Length > 0 Then
                    missingColumns &= ","
                End If
                missingColumns &= column.Name
            End If
        Next

        Return (missingColumns.Length = 0)

    End Function

    Public Shared Function DoAllDispoColumnsExist(ByVal schema As DataTable, ByRef message As String) As Boolean

        Dim maxKey As Integer = 0
        Dim dispoSets As New Dictionary(Of Integer, Dictionary(Of String, Integer))

        'Check all columns
        For Each row As DataRow In schema.Rows
            For Each column As FixedColumn In GetDispoColumns()
                If row("ColumnName").ToString.ToUpper.StartsWith(column.Name) AndAlso IsNumeric(row("ColumnName").ToString.Substring(column.Name.Length)) Then
                    Dim key As Integer = CInt(row("ColumnName").ToString.Substring(column.Name.Length))
                    If key > maxKey Then maxKey = key
                    If Not dispoSets.ContainsKey(key) Then
                        dispoSets.Add(key, New Dictionary(Of String, Integer))
                        For Each col As FixedColumn In GetDispoColumns()
                            dispoSets.Item(key).Add(col.Name, 0)
                        Next
                    End If
                    dispoSets.Item(key).Item(column.Name) += 1
                End If
            Next
        Next

        'Check to see that we have all of the dispo columns for each numbered set starting at 1
        message = String.Empty
        For key As Integer = 1 To maxKey
            If Not dispoSets.ContainsKey(key) Then
                If message.Length > 0 Then message &= "," & vbCrLf
                message &= String.Format("Disposition columns must be sequentially numbered starting at 1.  Missing columns numbered ({0}).", key)
            Else
                For Each column As FixedColumn In GetDispoColumns()
                    If dispoSets.Item(key).Item(column.Name) = 0 Then
                        If message.Length > 0 Then message &= "," & vbCrLf
                        message &= String.Format("Missing disposition column ({0}{1}).", column.Name, key)
                    ElseIf dispoSets.Item(key).Item(column.Name) > 1 Then
                        If message.Length > 0 Then message &= "," & vbCrLf
                        message &= String.Format("Disposition column ({0}{1}) exists {2} times in file.", column.Name, key, dispoSets.Item(key).Item(column.Name))
                    End If
                Next
            End If
        Next

        Return (message.Length = 0)

    End Function

    Public Shared Function GetSchemaFormatLine(ByVal columnName As String) As String

        Dim formatLine As String = String.Empty

        'Determine the column type and return the schema line
        If IsFixedColumn(columnName) Then
            formatLine = "Col{0}={1} " & GetFixedColumn(columnName).DataType

        ElseIf IsDispoColumn(columnName) Then
            formatLine = "Col{0}={1} " & GetDispoColumn(columnName).DataType

        ElseIf IsQuestionColumn(columnName) Then
            formatLine = "Col{0}={1} Char Width 5"

        ElseIf IsCommentColumn(columnName) Then
            formatLine = "Col{0}={1} LongChar"

        ElseIf IsHandEntryColumn(columnName) Then
            formatLine = "Col{0}={1} Char Width 255"

        ElseIf IsPopMappingColumn(columnName) Then
            formatLine = "Col{0}={1} Char Width 255"

        End If

        Return formatLine

    End Function

#End Region

#Region "Protected Shared Methods"

    Protected Shared Function IsFixedColumn(ByVal columnName As String) As Boolean

        If GetFixedColumn(columnName) IsNot Nothing Then
            Return True
        End If

        Return False

    End Function

    Protected Shared Function IsDispoColumn(ByVal columnName As String) As Boolean

        If GetDispoColumn(columnName) IsNot Nothing Then
            Return True
        End If

        Return False

    End Function

#End Region

#Region "Private Shared Methods"

    '1-18-2010 - KC - Added the field SurveyLang to the fixed columns for version 2.0
    Private Shared Function GetFixedColumns() As Collection(Of FixedColumn)

        If mFixedColumns Is Nothing Then
            'Populate the fixed column collection
            mFixedColumns = New Collection(Of FixedColumn)

            With mFixedColumns
                .Add(New FixedColumn("VENDORCODE", "Char Width 255"))
                .Add(New FixedColumn("FILEVERSION", "Char Width 255"))
                .Add(New FixedColumn("SURVEYID", "Char Width 255"))
                .Add(New FixedColumn("LITHOCODE", "Char Width 255"))
                .Add(New FixedColumn("RESPONSETYPE", "Char Width 255"))
                .Add(New FixedColumn("SURVEYLANG", "Char Width 255"))
            End With
        Else
            'Reset the quantity
            For Each col As FixedColumn In mFixedColumns
                col.Quantity = 0
            Next
        End If

        Return mFixedColumns

    End Function

    Private Shared Function GetFixedColumn(ByVal columnName As String) As FixedColumn

        For Each column As FixedColumn In GetFixedColumns()
            If column.Name = columnName.ToUpper Then
                Return column
            End If
        Next

        Return Nothing

    End Function

    Private Shared Function GetDispoColumns() As Collection(Of FixedColumn)

        If mDispoColumns Is Nothing Then
            'Populate the fixed column collection
            mDispoColumns = New Collection(Of FixedColumn)

            With mDispoColumns
                .Add(New FixedColumn("DISPOSITIONCODE", "Char Width 255"))
                .Add(New FixedColumn("DISPOSITIONDATE", "Date"))
                .Add(New FixedColumn("ISFINAL", "Bit"))
            End With
        Else
            'Reset the quantity
            For Each col As FixedColumn In mDispoColumns
                col.Quantity = 0
            Next
        End If

        Return mDispoColumns

    End Function

    Private Shared Function GetDispoColumn(ByVal columnName As String) As FixedColumn

        For Each column As FixedColumn In GetDispoColumns()
            If columnName.ToUpper.StartsWith(column.Name) AndAlso IsNumeric(columnName.Substring(column.Name.Length)) Then
                Return column
            End If
        Next

        Return Nothing

    End Function

#End Region

End Class
