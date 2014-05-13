Imports System.Data
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class TranslatorCSVBedside
    Inherits Translator

#Region "Private Fields"

    Private Shared mFixedColumns As Collection(Of FixedColumn)

#End Region

#Region "Public Methods"

    Public Overrides Function Translate(ByVal queueFile As QueuedTransferFile) As DataLoad

        'Move the file to a temp folder for reading
        queueFile.MoveToInProcess()

        'Read the file into a DataTable
        Dim table As DataTable = TranslatorProvider.Instance.GetDataTableCSVBedside(queueFile)

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

        Dim rowCount As Integer
        Dim qstnCore As Integer
        Dim multiResponse As Boolean
        Dim respValue As Integer
        Dim respString As String = String.Empty
        Dim cmntID As Integer
        Dim popMappingID As Integer
        Dim item As Integer
        Dim itemVal As Integer
        Dim line As Integer
        Dim itemColumn As String = String.Empty
        Dim dispoDate As Date
        Dim lithoCode As String = String.Empty
        Dim errorList As New List(Of TranslatorError)
        Dim langID As Nullable(Of Integer)
        Dim lithoCodeError As String = String.Empty
        Dim lithoCodeDup As String = String.Empty

        'Exit this place if we have no records to process
        If IsDataTableEmpty(table) Then
            'This data table is empty so throw an error
            Throw New InvalidFileException("File is empty.  File not processed!", queueFile.File.FullName)
        End If

        'Create the DataSet object
        Dim loadSet As DataSet = GetEmptyDataSet()

        'Get the schema of the table
        Dim schema As DataTable = table.CreateDataReader.GetSchemaTable

        'Add the FileInfo record
        loadSet.Tables("FileInfo").Rows.Add("1.0", "BD")

        'Loop through all of the records in the datatable and add them to the dataset
        For Each row As DataRow In table.Rows
            'Increment the row counter
            rowCount += 1

            'If this row is not empty then process it
            If Not IsDataRowEmpty(row) Then
                'Determine the LithoCode
                Select Case queueFile.Translator.LithoLookupType
                    Case LithoLookupTypes.MRNAdmitDate
                        'Try to get the LithoCode using the MRN and AdmitDate
                        lithoCode = TranslatorProvider.Instance.GetBedsideLithoCodeByMRNAdmitDate(row(GetFixedColumnName("MRN", queueFile)).ToString.Trim, _
                                                                                                  CDate(row(GetFixedColumnName("AdmitDate", queueFile)).ToString), _
                                                                                                  queueFile.Translator.StudyId, queueFile.Translator.SurveyId)

                        lithoCodeError = String.Format("LithoCode cannot be found for MRN {0} and AdmitDate {1}", row(GetFixedColumnName("MRN", queueFile)).ToString.Trim, row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                    Case LithoLookupTypes.VisitNumAdmitDateINPATIENT
                        'Try to get the LithoCode using the VisitNum, AdmitDate, and INPATIENT
                        lithoCode = TranslatorProvider.Instance.GetBedsideLithoCodeByVisitNumAdmitDateVisitType(row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, _
                                                                                                                CDate(row(GetFixedColumnName("AdmitDate", queueFile)).ToString), "INPATIENT", _
                                                                                                                queueFile.Translator.StudyId, queueFile.Translator.SurveyId)

                        lithoCodeError = String.Format("LithoCode cannot be found for VisitNum {0}, AdmitDate {1}, and VisitType INPATIENT", row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                    Case LithoLookupTypes.VisitNumAdmitDateICU
                        'Try to get the LithoCode using the VisitNum, AdmitDate, and ICU
                        lithoCode = TranslatorProvider.Instance.GetBedsideLithoCodeByVisitNumAdmitDateVisitType(row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, _
                                                                                                                CDate(row(GetFixedColumnName("AdmitDate", queueFile)).ToString), "ICU", _
                                                                                                                queueFile.Translator.StudyId, queueFile.Translator.SurveyId)

                        lithoCodeError = String.Format("LithoCode cannot be found for VisitNum {0}, AdmitDate {1}, and VisitType ICU", row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                    Case Else
                        'An invalid LithoLookupType was specified
                        lithoCode = String.Empty
                        lithoCodeError = String.Format("Invalid Translator LithoLookupType specified {0}", queueFile.Translator.LithoLookupType)

                End Select

                'Validate the LithoCode
                If String.IsNullOrEmpty(lithoCode) Then
                    lithoCode = "BLANK" & rowCount.ToString
                    errorList.Add(New TranslatorError(rowCount, lithoCode, lithoCodeError))
                End If

                'Add the Survey record if it does not already exist
                If loadSet.Tables("Survey").Select("SurveyID = " & queueFile.Translator.SurveyId.ToString).GetLength(0) = 0 Then
                    loadSet.Tables("Survey").Rows.Add(queueFile.Translator.SurveyId)
                End If

                'Determine the LangID
                Try
                    Dim colName As String = GetFixedColumnName("CultureCode", queueFile)
                    Dim cultureCode As String = RecodeResponse(colName, row(colName).ToString.Trim, queueFile)
                    Dim cultFromLangId As CultureToLanguage = CultureToLanguage.GetByCultureCode(cultureCode)
                    If Not cultFromLangId Is Nothing Then
                        langID = cultFromLangId.LangID
                    Else
                        'Invalid lang ID found.
                        langID = Nothing
                    End If

                Catch ex As Exception
                    'CultureCode column does not exist
                    langID = Nothing

                End Try

                'Add the Respondent record
                If loadSet.Tables("Respondent").Select(String.Format("LithoCode = '{0}'", lithoCode)).GetLength(0) = 0 Then
                    'This LithoCode does not exist in the table so add it
                    loadSet.Tables("Respondent").Rows.Add(queueFile.Translator.SurveyId, lithoCode, "Bed", langID)
                Else
                    'This LithoCode already exists in the table so add it with an error
                    Select Case queueFile.Translator.LithoLookupType
                        Case LithoLookupTypes.MRNAdmitDate
                            lithoCodeDup = String.Format("LithoCode {0} for MRN ({1}) {2} and AdmitDate ({3}) {4} already exists in the file.", lithoCode, GetFixedColumnName("MRN", queueFile), row(GetFixedColumnName("MRN", queueFile)).ToString.Trim, GetFixedColumnName("AdmitDate", queueFile), row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                        Case LithoLookupTypes.VisitNumAdmitDateINPATIENT
                            lithoCodeDup = String.Format("LithoCode {0} for VisitNum ({1}) {2} and AdmitDate ({3}) {4} already exists in the file.", lithoCode, GetFixedColumnName("VisitNum", queueFile), row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, GetFixedColumnName("AdmitDate", queueFile), row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                        Case LithoLookupTypes.VisitNumAdmitDateICU
                            lithoCodeDup = String.Format("LithoCode {0} for VisitNum ({1}) {2} and AdmitDate ({3}) {4} already exists in the file.", lithoCode, GetFixedColumnName("VisitNum", queueFile), row(GetFixedColumnName("VisitNum", queueFile)).ToString.Trim, GetFixedColumnName("AdmitDate", queueFile), row(GetFixedColumnName("AdmitDate", queueFile)).ToString)

                    End Select

                    'Add the error
                    lithoCode = "DUP" & rowCount.ToString
                    errorList.Add(New TranslatorError(rowCount, lithoCode, lithoCodeDup))
                    loadSet.Tables("Respondent").Rows.Add(queueFile.Translator.SurveyId, lithoCode, "Bed", langID)
                End If

                'Add the Disposition records
                If Not Date.TryParse(row(GetFixedColumnName("datReturned", queueFile)).ToString, dispoDate) Then
                    loadSet.Tables("Disposition").Rows.Add(lithoCode, "001", DBNull.Value, 1)
                Else
                    loadSet.Tables("Disposition").Rows.Add(lithoCode, "001", dispoDate, 1)
                End If

                'Parse the remainder of the record
                For Each schemaRow As DataRow In schema.Rows
                    If IsQuestionColumn(schemaRow("ColumnName").ToString, qstnCore, multiResponse, queueFile) Then
                        'Get the response value
                        If Integer.TryParse(row(schemaRow("ColumnName").ToString).ToString, respValue) Then
                            respString = respValue.ToString
                        Else
                            respString = row(schemaRow("ColumnName").ToString).ToString
                        End If

                        'Recode responses as required
                        respString = RecodeResponse(schemaRow("ColumnName").ToString, respString, queueFile)

                        'Add this question
                        loadSet.Tables("Bubble").Rows.Add(lithoCode, qstnCore, respString, multiResponse)

                    ElseIf IsHandEntryColumn(schemaRow("ColumnName").ToString, qstnCore, itemColumn, line, queueFile) Then
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

                    ElseIf IsCommentColumn(schemaRow("ColumnName").ToString, cmntID, queueFile) Then
                        'Add this comment
                        loadSet.Tables("Comment").Rows.Add(lithoCode, cmntID, row(schemaRow("ColumnName").ToString).ToString.Trim.Replace(Chr(147), String.Empty).Replace(Chr(148), String.Empty))

                    ElseIf IsPopMappingColumn(schemaRow("ColumnName").ToString, popMappingID, queueFile) Then
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

#End Region

#Region "Public Shared Methods"

    Public Shared Function DoAllFixedColumnsExist(ByVal schema As DataTable, ByRef missingColumns As String, ByVal fileVersion As Double, ByVal queueFile As QueuedTransferFile) As Boolean

        mFixedColumns = Nothing
        Dim fixedColumns As Collection(Of FixedColumn) = GetFixedColumns(queueFile)

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

    Public Shared Function GetSchemaFormatLine(ByVal columnName As String, ByVal queueFile As QueuedTransferFile) As String

        Dim formatLine As String = String.Empty

        'Determine the column type and return the schema line
        If IsFixedColumn(columnName, queueFile) Then
            formatLine = "Col{0}={1} " & GetFixedColumn(columnName, queueFile).DataType
        Else
            'We do not care about this column so just call it a char
            formatLine = "Col{0}={1} Char Width 255"
        End If

        Return formatLine

    End Function

#End Region

#Region "Protected Shared Methods"

    Protected Shared Function IsFixedColumn(ByVal columnName As String, ByVal queueFile As QueuedTransferFile) As Boolean

        If GetFixedColumn(columnName, queueFile) IsNot Nothing Then
            Return True
        End If

        Return False

    End Function

    Protected Overloads Shared Function IsQuestionColumn(ByVal columnName As String, ByRef qstnCore As Integer, ByRef multiResponse As Boolean, ByVal queueFile As QueuedTransferFile) As Boolean

        'Get the NRC column name
        Dim nrcColumnName As String = GetFixedColumnNRCName(columnName, queueFile)

        If nrcColumnName.ToUpper.StartsWith("Q") Then
            'This might be a question column
            If IsNumeric(nrcColumnName.Substring(1)) Then
                'This is a single response question
                qstnCore = CInt(nrcColumnName.Substring(1))
                multiResponse = False
                Return True
            ElseIf IsNumeric(nrcColumnName.Substring(1, nrcColumnName.Length - 2)) AndAlso _
                   CStr("ABCDEFGHIJKLMNOPQRSTUVWXYZ").IndexOf(nrcColumnName.ToUpper.Substring(nrcColumnName.Length - 1)) >= 0 Then
                'This is a multiple response question
                qstnCore = CInt(nrcColumnName.Substring(1, nrcColumnName.Length - 2))
                multiResponse = True
                Return True
            End If
        End If

        Return False

    End Function

    Protected Overloads Shared Function IsCommentColumn(ByVal columnName As String, ByRef cmntID As Integer, ByVal queueFile As QueuedTransferFile) As Boolean

        'Get the NRC column name
        Dim nrcColumnName As String = GetFixedColumnNRCName(columnName, queueFile)

        If nrcColumnName.ToUpper.StartsWith("C") AndAlso IsNumeric(nrcColumnName.Substring(1)) Then
            'This is a comment column
            cmntID = CInt(nrcColumnName.Substring(1))
            Return True
        End If

        Return False

    End Function

    Protected Overloads Shared Function IsHandEntryColumn(ByVal columnName As String, ByRef qstnCore As Integer, ByRef itemColumn As String, ByRef line As Integer, ByVal queueFile As QueuedTransferFile) As Boolean

        'Get the NRC column name
        Dim nrcColumnName As String = GetFixedColumnNRCName(columnName, queueFile)

        If nrcColumnName.ToUpper.StartsWith("H") AndAlso IsNumeric(nrcColumnName.Substring(1)) Then
            'This is a hand entry column on a single response question
            qstnCore = CInt(nrcColumnName.Substring(1))
            itemColumn = GetFixedColumnName(String.Format("Q{0}", nrcColumnName.Substring(1)), queueFile)
            line = 1
            Return True
        ElseIf nrcColumnName.ToUpper.StartsWith("H") AndAlso IsAllAlpha(nrcColumnName.Substring(nrcColumnName.Length - 1)) AndAlso IsNumeric(nrcColumnName.Substring(1, nrcColumnName.Length - 2)) Then
            'This is a hand entry column on a multiple response question
            qstnCore = CInt(nrcColumnName.Substring(1, nrcColumnName.Length - 2))
            itemColumn = GetFixedColumnName(String.Format("Q{0}", nrcColumnName.Substring(1)), queueFile)
            line = 1
            Return True
        End If

        Return False

    End Function

    Protected Overloads Shared Function IsPopMappingColumn(ByVal columnName As String, ByRef popMappingID As Integer, ByVal queueFile As QueuedTransferFile) As Boolean

        'Get the NRC column name
        Dim nrcColumnName As String = GetFixedColumnNRCName(columnName, queueFile)

        If nrcColumnName.ToUpper.StartsWith("M") AndAlso IsNumeric(nrcColumnName.Substring(1)) Then
            'This is a pop mapping column
            popMappingID = CInt(nrcColumnName.Substring(1))
            Return True
        End If

        Return False

    End Function

    Protected Shared Function RecodeResponse(ByVal columnName As String, ByVal respString As String, ByVal queueFile As QueuedTransferFile) As String

        'Get the column object
        Dim column As FixedColumn = GetFixedColumn(columnName, queueFile)

        'Determine the recoded value if required
        If column.Recodes.ContainsKey(respString) Then
            Return column.Recodes.Item(respString)
        Else
            Return respString
        End If

    End Function

#End Region

#Region "Private Shared Methods"

    '1-18-2010 - KC - Added the field SurveyLang to the fixed columns for version 2.0
    Private Shared Function GetFixedColumns(ByVal queueFile As QueuedTransferFile) As Collection(Of FixedColumn)

        If mFixedColumns Is Nothing Then
            mFixedColumns = New Collection(Of FixedColumn)

            'Get the Translation Module Mappings
            Dim mappingTable As DataTable = TranslatorProvider.Instance.SelectTranslationModuleMappings(queueFile.Translator.TranslationModuleId)

            'Populate the fixed column collection
            For Each mapping As DataRow In mappingTable.Rows
                If String.IsNullOrEmpty(mapping.Item("NRCColumnName").ToString) Then
                    mFixedColumns.Add(New FixedColumn(CInt(mapping.Item("TranslationModuleMapping_ID")), mapping.Item("OrigColumnName").ToString.ToUpper, mapping.Item("SchemaFormat").ToString))
                Else
                    mFixedColumns.Add(New FixedColumn(CInt(mapping.Item("TranslationModuleMapping_ID")), mapping.Item("OrigColumnName").ToString.ToUpper, mapping.Item("NRCColumnName").ToString.ToUpper, mapping.Item("SchemaFormat").ToString))
                End If
            Next
        Else
            'Reset the quantity
            For Each col As FixedColumn In mFixedColumns
                col.Quantity = 0
            Next
        End If

        Return mFixedColumns

    End Function

    Private Shared Function GetFixedColumn(ByVal columnName As String, ByVal queueFile As QueuedTransferFile) As FixedColumn

        For Each column As FixedColumn In GetFixedColumns(queueFile)
            If column.Name.ToUpper = columnName.ToUpper Then
                Return column
            End If
        Next

        Return Nothing

    End Function

    Private Shared Function GetFixedColumnName(ByVal nrcColumnName As String, ByVal queueFile As QueuedTransferFile) As String

        For Each column As FixedColumn In GetFixedColumns(queueFile)
            If column.NRCName.ToUpper = nrcColumnName.ToUpper Then
                Return column.Name
            End If
        Next

        Return String.Empty

    End Function

    Private Shared Function GetFixedColumnNRCName(ByVal columnName As String, ByVal queueFile As QueuedTransferFile) As String

        Dim column As FixedColumn = GetFixedColumn(columnName, queueFile)

        If column IsNot Nothing Then
            Return column.NRCName
        Else
            Return String.Empty
        End If

    End Function
#End Region


End Class
