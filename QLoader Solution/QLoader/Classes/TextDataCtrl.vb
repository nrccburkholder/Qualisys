Option Explicit On 
Option Strict On

Imports System.IO
Imports System.Text
Imports System.Collections.Specialized
Imports System.xml

Public Class TextDataCtrl

#Region " Private Constants "

    'Max line used for preview
    Private Const MAX_PREVIEW_LINE As Integer = 500

    'Max column count
    Private Const MAX_COLUMN_COUNT As Integer = 500

    'Max record length
    Private Const MAX_RECORD_LENGTH As Integer = 50000

    '---------------------------------------------
    ' KitchenSynk Profile
    '---------------------------------------------
    Private Const PROFILE_KITCHEN As Integer = 1
    '1st section name
    Private Const PROFILE_KITCHEN_HEAD_SECTION As String = "DEFINED TABLES"
    'text format
    Private Const PROFILE_KITCHEN_FORMAT As String = "TT"
    'delimiter
    Private Const PROFILE_KITCHEN_DELIMITER As String = "DC"
    'first row contains field name
    Private Const PROFILE_KITCHEN_HASHEADER As String = "FLN"
    'field
    Private Const PROFILE_KITCHEN_FIELD As String = "FIELD"

    '---------------------------------------------
    ' Gary's DTS Builder Profile
    '---------------------------------------------
    Private Const PROFILE_GARY As Integer = 2
    'File type
    Private Const PROFILE_GARY_FILE_TYPE As String = "FileType"
    'Data source
    Private Const PROFILE_GARY_DATA_SOURCE As String = "DataSource"
    'Has header
    Private Const PROFILE_GARY_HAS_COL_NAME As String = "HasColumnNames"
    'Text delimiter
    Private Const PROFILE_GARY_DELIMITER As String = "FileDelimiter"
    'Field
    Private Const PROFILE_GARY_FIELDS As String = "Fields"
    'Field
    Private Const PROFILE_GARY_FIELD As String = "Field"
    'Field - name
    Private Const PROFILE_GARY_FIELD_NAME As String = "Name"
    'Field - length
    Private Const PROFILE_GARY_FIELD_LENGTH As String = "Length"

    Private Const PROFILE_GARY_FIXED As String = "1"
    Private Const PROFILE_GARY_DELIMITED As String = "2"

    '---------------------------------------------
    ' New DTS Builder Profile
    '---------------------------------------------
    Private Const PROFILE_DTS As Integer = 3
    'section name
    Private Const PROFILE_DTS_SECTION As String = "TEXT FILE"
    'text format
    Private Const PROFILE_DTS_FORMAT As String = "TYPE"
    'delimiter
    Private Const PROFILE_DTS_DELIMITER As String = "DELIMITER"
    'text qualifier
    Private Const PROFILE_DTS_QUALIFIER As String = "QUALIFIER"
    'first row contains field name
    Private Const PROFILE_DTS_HASHEADER As String = "HASHEADER"
    'field
    Private Const PROFILE_DTS_FIELD As String = "FIELD"

    'valid value for text format 
    Private Const PROFILE_DTS_FIXED As String = "FIXED"
    Private Const PROFILE_DTS_DELIMITED As String = "DELIMITED"

    'valid value for first row contains field name
    Private Const PROFILE_DTS_HASHEADER_FALSE As String = "FALSE"
    Private Const PROFILE_DTS_HASHEADER_TRUE As String = "TRUE"
    Private Const PROFILE_DTS_HASHEADER_0 As String = "0"
    Private Const PROFILE_DTS_HASHEADER_1 As String = "1"

    'valid value for delimiter and qualifier
    Private Const PROFILE_DTS_TAB As String = "TAB"
    Private Const PROFILE_DTS_SEMICOLON As String = "SEMICOLON"
    Private Const PROFILE_DTS_COMMA As String = "COMMA"
    Private Const PROFILE_DTS_SPACE As String = "SPACE"

#End Region

#Region " Private Members "

    'DTS text data
    Private mTextData As DTSTextData

    'Members of raw text data
    Private mTemplateFile As String     'Path for the template file
    Private mLines(MAX_PREVIEW_LINE - 1) As String  'Raw text
    Private mMaxRowLength As Integer = 0 'Max row length
    Private mRowNum As Integer          'Row number

    'Member used for displaying text data
    Private mFields()() As String       'TextColumn control needs this type as input data,
    '                                    The 1st array layor is for rows, the 2nd array layor is for columns

#End Region

#Region " Public Properties "

    Public ReadOnly Property TemplateFile() As String
        Get
            Return (mTemplateFile)
        End Get
    End Property

    Public ReadOnly Property DataSet() As DTSTextData
        Get
            Dim col As SourceColumn
            Dim i As Integer = 1

            For Each col In mTextData.Columns
                col.DataType = DataTypes.Varchar
                col.Ordinal = i
                col.SourceID = 0
                If ((Not mTextData.IsDelimited) OrElse (Not mTextData.HasHeader)) Then
                    col.OriginalName = String.Format("{0}{1:D3}", _
                                                     Column.DEFAULT_COLUMN_NAME, _
                                                     i)
                End If
                i = i + 1
            Next

            Return (mTextData)
        End Get
    End Property

    Public ReadOnly Property RowNum() As Integer
        Get
            Return (mRowNum)
        End Get
    End Property

    Public Property IsDelimited() As Boolean
        Get
            Return (mTextData.IsDelimited)
        End Get
        Set(ByVal Value As Boolean)
            If (mTextData.IsDelimited = Value) Then Return
            mTextData.IsDelimited = Value
            If (mTextData.IsDelimited) Then
                ParseDelimitedText(True)
            Else
                InitFixedTextSettings()
            End If
        End Set
    End Property

    Public Property Delimiter() As String
        Get
            Return (mTextData.Delimiter)
        End Get
        Set(ByVal Value As String)
            If (mTextData.Delimiter = Value) Then Return
            If (Value.Length <> 1) Then
                Throw New ArgumentException("Delimiter can only have one character")
                Return
            End If
            mTextData.Delimiter = Value
            ParseDelimitedText(True)
        End Set
    End Property

    Public Property TextQualifier() As String
        Get
            Return (mTextData.TextQualifier)
        End Get
        Set(ByVal Value As String)
            If (mTextData.TextQualifier = Value) Then Return
            If (Value.Length > 1) Then
                Throw New ArgumentException("Text qualifier can be no longer than one character")
                Return
            End If
            mTextData.TextQualifier = Value
            ParseDelimitedText(True)
        End Set
    End Property

    Public Property HasHeader() As Boolean
        Get
            Return (mTextData.HasHeader)
        End Get
        Set(ByVal Value As Boolean)
            If (mTextData.HasHeader = Value) Then Return
            mTextData.HasHeader = Value
            ParseDelimitedText(True)
        End Set
    End Property

    Public Property RulerScale() As RulerScales
        Get
            Return (mTextData.RulerScale)
        End Get
        Set(ByVal Value As RulerScales)
            mTextData.RulerScale = Value
        End Set
    End Property

    Public ReadOnly Property MaxRowLength() As Integer
        Get
            Return (mMaxRowLength)
        End Get
    End Property

    Public Property Columns() As ColumnCollection
        Get
            Return (mTextData.Columns)
        End Get
        Set(ByVal Value As ColumnCollection)
            If (Value Is Nothing) Then Return
            mTextData.Columns = Value
            ParseText(False)
        End Set
    End Property

    'Get lines of raw text data
    Public ReadOnly Property Lines() As String()
        Get
            Return mLines
        End Get
    End Property

    'Get dield text data
    Public ReadOnly Property Fields() As String()()
        Get
            Return (mFields)
        End Get
    End Property

#End Region

#Region " Public Methods "

    Public Sub New(ByVal templateFile As String)
        If (templateFile Is Nothing) Then
            Throw New ArgumentException("Template file reference not set to an instance of an object")
        End If
        Me.SetDtsTextData(New DTSTextData)
        Me.SetTemplateFile(templateFile)
        ParseText(True)
    End Sub

    Public Sub New(ByVal dataSet As DTSTextData, ByVal templateFile As String)
        If (dataSet Is Nothing) Then
            Throw New ArgumentException("dataset reference not set to an instance of an object")
        End If
        If (templateFile Is Nothing) Then
            Throw New ArgumentException("Template file reference not set to an instance of an object")
        End If
        Me.SetDtsTextData(dataSet)
        Me.SetTemplateFile(templateFile)
        ParseText(False)
    End Sub

    'If column doesn't have name, give a default name
    Public Sub FillColumnNames()
        Dim i As Integer = 1
        Dim col As SourceColumn
        Dim name As String = ""

        For Each col In mTextData.Columns
            If (col.ColumnName Is Nothing OrElse col.ColumnName = "") Then
                Do While (True)
                    name = String.Format("{0}{1:D3}", _
                                         Column.DEFAULT_COLUMN_NAME, _
                                         i)
                    i += 1
                    If (Not ColumnNameExist(name)) Then Exit Do
                Loop
                col.ColumnName = name
            End If
        Next
    End Sub

    Public Function AreOriginalNameValid( _
                            ByRef errColumn As Integer, _
                            ByRef errMsg As String _
                    ) As Boolean

        If (Not mTextData.IsDelimited OrElse Not mTextData.HasHeader) Then Return (True)

        Dim columns As ColumnCollection = mTextData.Columns

        If (columns.OriginalColumnNameDuplicated(errColumn, errMsg)) Then
            errMsg += vbCrLf + Application.ProductName + " can not handle text file with duplicated column names."
            errMsg += vbCrLf + "Please modify the header row in text file."
            Return False
        Else
            Return True
        End If
    End Function

    Public Function ValidateColumnName( _
                            ByRef errColumn As Integer, _
                            ByRef errMsg As String _
                    ) As Boolean

        If (Not AreColumnNamesValid(errColumn, errMsg)) Then Return (False)
        If (mTextData.Columns.ColumnNameDuplicated(errColumn, errMsg)) Then Return (False)
        If (Not AreOriginalNameValid(errColumn, errMsg)) Then Return (False)
        Return (True)
    End Function

    Public Function IsKitchensynkProfile( _
                        ByVal iniPath As String, _
                        ByRef sectionList() As String _
                    ) As Boolean

        Dim profileType As Integer

        'Check profile type
        profileType = Me.ProfileType(iniPath)

        If (profileType = PROFILE_GARY OrElse profileType = PROFILE_DTS) Then Return False

        'Check if there are multiple sections in Kitchensync ini file
        Dim keys As StringCollection
        keys = IniWrapper.GetProfileKeys(iniPath, PROFILE_KITCHEN_HEAD_SECTION)

        'No key: error
        If keys.Count = 0 Then
            Throw New ArgumentException("No key define in section [Defined Tables]")
        End If

        'Have keys
        ReDim sectionList(keys.Count - 1)
        Dim i As Integer
        Dim value As String
        For i = 0 To keys.Count - 1
            value = IniWrapper.GetProfileValue(iniPath, PROFILE_KITCHEN_HEAD_SECTION, keys(i))
            If (value Is Nothing OrElse value = "") Then
                Throw New ArgumentException("No value for key """ + keys(i) + """")
            End If
            sectionList(i) = value
        Next

        Return True

    End Function

    Public Sub LoadProfile(ByVal iniPath As String, ByVal section As String)
        Dim profileType As Integer
        Dim profileDataset As DTSTextData
        Dim profileColumns As ColumnCollection
        Dim errMsg As String = ""

        Try

            'Check profile type
            profileType = Me.ProfileType(iniPath)

            'Load profile
            Select Case profileType
                Case PROFILE_KITCHEN
                    profileDataset = LoadKitchenProfile(iniPath, section)
                Case PROFILE_GARY
                    profileDataset = LoadPackageProfile(iniPath)
                Case PROFILE_DTS
                    profileDataset = LoadDtsProfile(iniPath)
                Case Else
                    Throw New Exception("Unknown profile type")
            End Select
            profileColumns = profileDataset.Columns

            'Validate profile
            If (Not IsProfileValid(profileColumns, errMsg)) Then
                Throw New ArgumentException(errMsg)
            End If

            'Parse template text file with settings of profile
            Dim dtsTextDataBak As DTSTextData = mTextData.Clone
            With mTextData
                .IsDelimited = profileDataset.IsDelimited
                .HasHeader = profileDataset.HasHeader
                .Delimiter = profileDataset.Delimiter
                .TextQualifier = profileDataset.TextQualifier
                .Columns = profileDataset.Columns.Clone
            End With
            ParseText(True)

            'For delimited file, check the column number in template text file is matched with that in profile
            If (mTextData.IsDelimited AndAlso (mTextData.Columns.Count <> profileColumns.Count)) Then
                mTextData = dtsTextDataBak
                Throw New ArgumentException("Profile error: column number in profile is different from that in template text file")
            End If

            'Copy profile field definitions to text data set
            Dim columns As ColumnCollection = mTextData.Columns
            Dim profileCol As SourceColumn
            Dim dtsCol As SourceColumn
            Dim i As Integer

            For i = 0 To profileColumns.Count - 1
                profileCol = CType(profileColumns(i), SourceColumn)
                dtsCol = CType(columns(i), SourceColumn)
                dtsCol.ColumnName = profileCol.ColumnName
            Next

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        End Try

    End Sub

    Public Sub SaveProfile(ByVal iniPath As String)
        'File type
        Dim type As String
        type = CStr(IIf(IsDelimited, PROFILE_DTS_DELIMITED, PROFILE_DTS_FIXED))
        IniWrapper.WriteProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_FORMAT, type)

        'Has header, delimiter, text qualifier
        If (IsDelimited) Then
            'Has 
            IniWrapper.WriteProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_HASHEADER, HasHeader)

            'delimiter
            Dim delimiter As String
            Select Case Me.Delimiter
                Case vbTab
                    delimiter = PROFILE_DTS_TAB
                Case ";"
                    delimiter = PROFILE_DTS_SEMICOLON
                Case ","
                    delimiter = PROFILE_DTS_COMMA
                Case " "
                    delimiter = PROFILE_DTS_SPACE
                Case Else
                    delimiter = Me.Delimiter
            End Select
            IniWrapper.WriteProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_DELIMITER, delimiter)

            'text qualifier
            Dim qualifier As String
            Select Case Me.TextQualifier
                Case vbTab
                    qualifier = PROFILE_DTS_TAB
                Case ";"
                    qualifier = PROFILE_DTS_SEMICOLON
                Case ","
                    qualifier = PROFILE_DTS_COMMA
                Case " "
                    qualifier = PROFILE_DTS_SPACE
                Case Else
                    qualifier = Me.TextQualifier
            End Select
            IniWrapper.WriteProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_QUALIFIER, qualifier)
        End If

        'Fields
        Dim col As Column
        Dim key As String
        Dim i As Integer = 1
        Dim value As String

        For Each col In Columns
            key = PROFILE_DTS_FIELD & i
            value = col.ColumnName
            If (Not IsDelimited) Then
                value += "," & col.Length
            End If
            IniWrapper.WriteProfileValue(iniPath, PROFILE_DTS_SECTION, key, value)
            i += 1
        Next

    End Sub

    ' This method is only used for testing/debugging
    Public Function IsValid(ByRef errMsg As String) As Boolean
        Dim columns As ColumnCollection = DataSet.Columns
        Dim col1 As SourceColumn
        Dim col2 As SourceColumn
        Dim i As Integer
        Dim j As Integer

        For i = 0 To columns.Count - 1
            col1 = CType(columns(i), SourceColumn)
            If (col1.DataType <> DataTypes.Varchar) Then
                errMsg = String.Format("field {0} ""{1}"": data type error. ({2})", i + 1, col1.ColumnName, col1.DataTypeStringFull)
                Return False
            End If
            If (col1.Length <= 0) Then
                errMsg = String.Format("field {0} ""{1}"": length error. ({2})", i + 1, col1.ColumnName, col1.Length)
                Return False
            End If
            If (col1.Ordinal <> i + 1) Then
                errMsg = String.Format("field {0} ""{1}"": ordinal number error. ({2})", i + 1, col1.ColumnName, col1.Ordinal)
                Return False
            End If
            For j = i + 1 To columns.Count - 1
                col2 = CType(columns(j), SourceColumn)
                If (col1.ColumnName.ToLower = col2.ColumnName.ToLower) Then
                    errMsg = String.Format("field {0} ""{1}"": column name is the same as field {2}.", i + 1, col1.ColumnName, j + 1)
                    Return False
                End If
                If (col1.OriginalName.ToLower = col2.OriginalName.ToLower) Then
                    errMsg = String.Format("field {0} ""{1}"": column original name is the same as field {2}. ({3})", i + 1, col1.ColumnName, j + 1, col1.OriginalName)
                    Return False
                End If
            Next j
        Next i

        Return True
    End Function

#End Region

#Region " Private Methods "

    Private Sub SetDtsTextData(ByVal dataset As DTSTextData)
        'Check the parameter
        If (dataset Is Nothing) Then Return

        'Copy DTSPackage setting to private members
        mTextData = dataset.Clone

        'Fix some obvious errors in format settings loaded
        Dim col As SourceColumn
        With mTextData

            If (.IsDelimited) Then
                If (.Delimiter Is Nothing OrElse .Delimiter = "") Then
                    .Delimiter = DTSTextData.DEFAULT_DELIMITER
                End If
                If (.TextQualifier Is Nothing) Then
                    .TextQualifier = DTSTextData.DEFAULT_QUALIFIER
                End If
            Else
                'Fixed width text should have a least 1 column
                If (.Columns Is Nothing) Then .Columns = New ColumnCollection
                If (.Columns.Count = 0) Then
                    col = New SourceColumn
                    col.Length = 1
                    .Columns.Add(col)
                End If
            End If

            'The column length should be >= 1
            For Each col In .Columns
                If col.Length <= 0 Then col.Length = 1
            Next

        End With

    End Sub

    Private Sub SetTemplateFile(ByVal templateFile As String)
        If (templateFile Is Nothing) Then Return
        If (templateFile = "") Then
            Throw New ArgumentException("The template text file name is blank")
            Return
        End If
        mTemplateFile = templateFile
        Dim sr As StreamReader = Nothing

        Try
            'read text file
            sr = New StreamReader(mTemplateFile)
            Dim i As Integer = 0
            mMaxRowLength = 0
            Do Until sr.Peek = -1
                mLines(i) = sr.ReadLine
                If (mMaxRowLength < mLines(i).Length) Then
                    mMaxRowLength = mLines(i).Length
                End If
                i += 1
                If (i > MAX_PREVIEW_LINE - 1) Then Exit Do
            Loop

            'check if there is data in the file
            If (i <= 0) Then
                Throw New ArgumentException("There is no data in template file " + mTemplateFile)
                Return
            End If

            'check if the length of all the lines are 0
            If (mMaxRowLength = 0) Then
                Throw New ArgumentException("All the lines are blank in template file " + mTemplateFile)
                Return
            End If

            'Shrink the mLines array to exact line number
            If (i <= MAX_PREVIEW_LINE - 1) Then
                ReDim Preserve mLines(i - 1)
            End If

            mRowNum = mLines.Length

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        Finally
            'Close the file
            If (Not sr Is Nothing) Then sr.Close()
        End Try

    End Sub

    'Init "columns" and "fields" for fixed width text
    'The method is used when user changed the format
    'from "Delimited" to "Fixed Width"
    Private Sub InitFixedTextSettings()
        'The init value of columns only has one column
        mTextData.Columns.Clear()
        Dim col As New SourceColumn
        col.Length = mMaxRowLength
        col.ColumnName = ""
        mTextData.Columns.Add(col)

        'Since we only have 1 column, all the text is distributed into this column
        ReDim mFields(mRowNum - 1)
        Dim i As Integer
        For i = 0 To mRowNum - 1
            mFields(i) = New String() {mLines(i)}
        Next i

    End Sub


    'Split the text line into fields.
    Private Sub ParseText(ByVal refreshColumns As Boolean)
        'Decide text file type and delimiter based on file extension
        If (refreshColumns) Then
            Dim file As IO.FileInfo = New IO.FileInfo(Me.mTemplateFile)
            Select Case file.Extension.ToLower
                Case ".csv"
                    mTextData.IsDelimited = True
                    mTextData.Delimiter = ","
                Case ".tab"
                    mTextData.IsDelimited = True
                    mTextData.Delimiter = vbTab
            End Select
        End If

        If (mTextData.IsDelimited) Then
            ParseDelimitedText(refreshColumns)
        Else
            ParseFixedText()
        End If
    End Sub

    'Split fixed width text into fields data based on columns' length settings
    Private Sub ParseFixedText()
        ReDim mFields(mRowNum - 1)
        Dim i As Integer
        Dim j As Integer
        Dim fields As New System.Collections.Specialized.StringCollection
        Dim beginPos As Integer
        Dim len As Integer
        Dim col As SourceColumn
        Dim totalLen As Integer = 0
        Dim columns As ColumnCollection = mTextData.Columns

        'if the sum of column length is less than the max line length of text data,
        'increase the length of the last column with the value "MaxRowLength-SumColumnLength"
        For Each col In columns
            totalLen += col.Length
        Next
        If (totalLen < mMaxRowLength) Then
            col = CType(columns(columns.Count - 1), SourceColumn)
            col.Length += mMaxRowLength - totalLen
        End If

        'Set column original name to default
        i = 1
        For Each col In columns
            col.OriginalName = String.Format("{0}{1:D3}", _
                                               Column.DEFAULT_COLUMN_NAME, _
                                               i)
            i += 1
        Next

        'Split each text line into fields
        For i = 0 To mRowNum - 1
            fields.Clear()
            beginPos = 0
            For j = 0 To columns.Count - 1
                If (beginPos >= mLines(i).Length) Then Exit For
                len = columns(j).Length
                If (mLines(i).Length - beginPos < len) Then
                    len = mLines(i).Length - beginPos
                End If
                fields.Add(mLines(i).Substring(beginPos, len))
                beginPos += columns(j).Length
            Next j

            Dim arr(fields.Count - 1) As String
            fields.CopyTo(arr, 0)
            For j = 0 To arr.Length - 1
                If (arr(j) Is Nothing) Then arr(j) = ""
            Next

            mFields(i) = arr
        Next i

    End Sub

    'Split text into fields based on delimiter and text qualifier.
    'Get the max length of the text data for each column and used as column length
    'If "Has Header":
    '   - Get the column name from first line text
    '   - Delete the first line data from fields
    Private Sub ParseDelimitedText(ByVal refreshColumns As Boolean)
        Dim i As Integer
        Dim j As Integer
        ReDim mFields(mRowNum - 1)
        Dim colNum As Integer = 0
        Dim col As SourceColumn
        Dim len As Integer
        Dim name As String = ""
        Dim fieldCnt As Integer = 1

        'split data text line into fields
        For i = 0 To mRowNum - 1
            mFields(i) = SplitDelimitedText(i)
            If (colNum < mFields(i).Length) Then
                colNum = mFields(i).Length
            End If
            j += 1
        Next i

        'Refresh column settings using the info from splitted text data
        If (refreshColumns) Then

            mTextData.Columns.Clear()
            For i = 0 To colNum - 1     'loop columns
                col = New SourceColumn

                'Find the max length for this column
                len = 0
                For j = 0 To mRowNum - 1        'loop rows
                    If (i < mFields(j).Length AndAlso mFields(j)(i).Length > len) Then
                        len = mFields(j)(i).Length
                    End If
                Next

                If (len <= 0) Then len = 1

                'Added 2/15/2005 - JPC - Addressing bug where delimited data gets cut off
                'These template columns might not contain the maximum column length possible
                'Force all columns to be at least 50 wide to reduce truncation risk
                If len < 50 Then
                    len = 50
                End If
                'End 2/15/2005 Modification

                col.Length = len

                'Find or set the column name
                If (mTextData.HasHeader AndAlso i < mFields(0).Length) Then
                    col.ColumnName = Trim(mFields(0)(i))
                Else
                    col.ColumnName = ""
                End If

                mTextData.Columns.Add(col)
            Next

            If (mTextData.HasHeader) Then
                'Fill blank column name
                j = 1
                For Each col In mTextData.Columns
                    If col.ColumnName = "" Then
                        Do While (True)
                            name = String.Format("{0}{1:D3}", _
                                                 Column.DEFAULT_COLUMN_NAME, _
                                                 j)
                            j += 1
                            If (Not ColumnNameExist(name)) Then Exit Do
                        Loop
                        col.ColumnName = name
                    End If
                Next

                'Copy column name to original name
                For Each col In mTextData.Columns
                    col.OriginalName = col.ColumnName
                Next
            End If
        End If

        'if has header, we need to delete the 1st line of mFields.
        'Since it is the header
        If (mTextData.HasHeader) Then
            If (mRowNum <= 1) Then
                'if only 1 line in text data,
                'add a blank line
                ReDim mFields(0)
                mFields(0) = New String() {""}
            Else
                'delete 1st row
                Array.Copy(mFields, 1, mFields, 0, mRowNum - 1)
                ReDim Preserve mFields(mRowNum - 2)
            End If
        End If

    End Sub

    'Split 1 line delimited text into fields 
    Private Function SplitDelimitedText(ByVal row As Integer) As String()
        If (mTextData.TextQualifier = "") Then
            Return (SplitDelimitedTextWithoutQualifier(row))
        Else
            Return (SplitDelimitedTextWithQualifier(row))
        End If
    End Function

    'If no text qualifier is selected,
    'use this method to split 1 line delimited text into fields 
    Private Function SplitDelimitedTextWithoutQualifier(ByVal row As Integer) As String()
        Return (mLines(row).Split(CChar(mTextData.Delimiter)))
    End Function

    'If text qualifier is selected,
    'use this method to split 1 line delimited text into fields 
    Private Function SplitDelimitedTextWithQualifier(ByVal row As Integer) As String()
        Dim columns As New System.Collections.Specialized.StringCollection
        Dim column As New StringBuilder(100)
        Dim text As String = mLines(row)
        Dim i As Integer
        Dim lastPos As Integer = text.Length - 1
        Dim betweenQualifier As Boolean
        Dim beginPos As Integer
        Dim endPos As Integer
        Dim delimiter As String = mTextData.Delimiter
        Dim qualifier As String = mTextData.TextQualifier

        If text Is Nothing Then Return (Nothing)

        i = 0
        beginPos = 0
        betweenQualifier = False

        Do While (i <= lastPos)
            Select Case text.Substring(i, 1)
                Case delimiter
                    'found column end
                    If (Not betweenQualifier) Then
                        endPos = i - 1
                        If (endPos < beginPos) Then
                            columns.Add("")
                        Else
                            columns.Add(StripQualifier(text.Substring(beginPos, endPos - beginPos + 1)))
                        End If
                        beginPos = i + 1
                    End If

                Case qualifier
                    If (Not betweenQualifier) Then      'Begin of qualified field
                        betweenQualifier = True
                    Else        'already in the qualified field
                        If (i < lastPos) Then
                            'double text qualifier means a normal char of qualifier
                            If (text.Substring(i + 1, 1) = qualifier) Then
                                i += 1
                            Else    'End of qualified field
                                betweenQualifier = False
                            End If
                        End If
                    End If

            End Select

            i += 1

        Loop

        'last column
        If (beginPos <= lastPos) Then
            columns.Add(StripQualifier(text.Substring(beginPos, lastPos - beginPos + 1)))
        End If

        'blank line
        If (columns.Count = 0) Then Return (New String() {""})

        'line has text
        Dim arr(columns.Count - 1) As String
        columns.CopyTo(arr, 0)
        Return (arr)

    End Function

    'Strip the text qualifier
    Private Function StripQualifier(ByVal str As String) As String
        Dim result As New StringBuilder
        Dim betweenQualifier As Boolean = False
        Dim i As Integer = 0
        Dim lastPos As Integer = str.Length - 1
        Dim qualifier As String = mTextData.TextQualifier

        Do While (i <= lastPos)
            Select Case str.Substring(i, 1)
                Case qualifier     'Qualifier char
                    If (Not betweenQualifier) Then      'Begin of qualified field
                        betweenQualifier = True
                    Else        'already in the qualified field
                        If (i < lastPos) Then
                            'double text qualifier means a normal char of qualifier
                            If (str.Substring(i + 1, 1) = qualifier) Then
                                result.Append(qualifier)
                                i += 1
                            Else    'End of qualified field
                                betweenQualifier = False
                            End If
                        End If
                    End If

                Case Else   'Char other than qualifier
                    result.Append(str.Substring(i, 1))

            End Select

            i += 1
        Loop

        Return (result.ToString)

    End Function

    Private Function AreColumnNamesValid( _
                            ByRef errColumn As Integer, _
                            ByRef errMsg As String _
                    ) As Boolean
        Dim i As Integer
        Dim columns As ColumnCollection = mTextData.Columns

        For i = 0 To columns.Count - 1
            If (Not columns(i).IsValidColumnName(errMsg)) Then
                errColumn = i
                Return (False)
            End If
        Next
        Return (True)
    End Function

    'Load KitchenSynk's DTS package
    Private Function LoadKitchenProfile( _
                        ByVal iniPath As String, _
                        ByVal section As String _
                    ) As DTSTextData

        Dim keys As StringCollection
        Dim key As String
        Dim value As String
        Dim errMsg As String = ""
        Dim columns As New ColumnCollection
        Dim column As SourceColumn
        Dim isDelimited As Boolean
        Dim delimiter As String = ""
        Dim hasHeader As Boolean

        'Get keys in section
        keys = IniWrapper.GetProfileKeys(iniPath, section, ProfileLetterCase.ToUpper)

        'Check the text format in the profile
        If (keys.IndexOf(PROFILE_KITCHEN_FORMAT) < 0) Then
            errMsg = String.Format("Profile error: text format ""{0}"" is missing in section ""{1}"".", _
                                   PROFILE_KITCHEN_FORMAT, _
                                   section)
            Throw New ArgumentException(errMsg)
        End If
        value = IniWrapper.GetProfileValue(iniPath, section, PROFILE_KITCHEN_FORMAT, ProfileLetterCase.ToUpper)
        Select Case value
            Case "FIXED"
                isDelimited = False
            Case "TAB"
                isDelimited = True '
                delimiter = vbTab
            Case "COMMA"
                isDelimited = True
                delimiter = ","
            Case "CHARACTER"
                isDelimited = True
                value = IniWrapper.GetProfileValue(iniPath, section, PROFILE_KITCHEN_DELIMITER)
                If (value Is Nothing Or value = "") Then
                    errMsg = String.Format("Profile error: delimiter definition is missing")
                    Throw New ArgumentException(errMsg)
                End If
                delimiter = value.Substring(0, 1)
            Case Else
                errMsg = String.Format("Profile error: text format ({0}) is invalid.", PROFILE_KITCHEN_FORMAT)
                Throw New ArgumentException(errMsg)
        End Select

        If (isDelimited) Then
            value = IniWrapper.GetProfileValue(iniPath, section, PROFILE_KITCHEN_HASHEADER)
            If (value Is Nothing Or value = "") Then
                errMsg = String.Format("Profile error: key ""{0}"" is missing", PROFILE_KITCHEN_HASHEADER)
                Throw New ArgumentException(errMsg)
            End If
            If (value = "1") Then
                hasHeader = True
            Else
                hasHeader = False
            End If
        End If

        'for each field, get field name.
        'if fixed-width text, get the field length
        Dim pieces() As String

        For Each key In keys
            If key.StartsWith(PROFILE_KITCHEN_FIELD) Then
                'Get setting for this field
                value = IniWrapper.GetProfileValue(iniPath, section, key)
                If (value = "") Then
                    errMsg = String.Format("Profile error: no definition for the field ""{0}"".", key)
                    Throw New ArgumentException(errMsg)
                End If
                pieces = value.Split(","c)
                column = New SourceColumn

                'Get the field name
                column.ColumnName = pieces(0)
                If (Not column.IsValidColumnName(errMsg)) Then
                    errMsg = String.Format("Profile error: field name error for the field ""{0}"".{1}{2}", _
                                           key, _
                                           vbCrLf + vbCrLf, _
                                           errMsg)
                    Throw New ArgumentException(errMsg)
                End If

                'Get the field length for fixed-width text file
                If (Not isDelimited) Then
                    If (pieces.Length < 5) Then
                        errMsg = String.Format("Profile error: field length is not defined for the field ""{0}"".", key)
                        Throw New ArgumentException(errMsg)
                    End If
                    Try
                        column.Length = Integer.Parse(pieces(4))
                    Catch ex As Exception
                        errMsg = String.Format("Profile error: field length error for the field ""{0}"".", key)
                        Throw New ArgumentException(errMsg)
                    End Try
                End If

                'It is valid field definition. Add to column collection
                columns.Add(column)
            End If
        Next

        Dim textData As New DTSTextData
        With textData
            .IsDelimited = isDelimited
            .HasHeader = hasHeader
            .Delimiter = delimiter
            .TextQualifier = """"
            .Columns = columns
        End With

        Return (textData)

    End Function

    'Load Gary's DTS package
    Private Function LoadPackageProfile(ByVal iniPath As String) As DTSTextData
        Dim xmldoc As New XmlDocument
        Dim xpath As String
        Dim xn As XmlNode
        Dim xnl As XmlNodeList
        Dim xmlEl As XmlElement
        Dim errMsg As String = ""
        Dim columns As New ColumnCollection
        Dim column As SourceColumn
        Dim isDelimited As Boolean
        Dim delimiter As String = ""
        Dim hasHeader As Boolean
        Dim columnCount As Integer
        Dim recordLength As Integer
        Dim columnName As String
        Dim columnLen As Integer
        Dim value As String
        Dim totalLen As Integer

        Try
            xmldoc.Load(iniPath)

            'File Type
            xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/FileType/text()"
            xn = xmldoc.SelectSingleNode(xpath)
            If (xn Is Nothing) Then
                errMsg = "Profile error: file type is missing"
                Throw New ArgumentException(errMsg)
            End If
            Select Case xn.InnerText.Trim
                Case PROFILE_GARY_FIXED
                    isDelimited = False
                Case PROFILE_GARY_DELIMITED
                    isDelimited = True
                Case Else
                    errMsg = "Profile error: invalid file type"
                    Throw New ArgumentException(errMsg)
            End Select

            Select Case isDelimited
                Case True   'Delimited
                    'Has header
                    xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/DataSource/HasColumnNames/text()"
                    xn = xmldoc.SelectSingleNode(xpath)
                    If (xn Is Nothing) Then
                        errMsg = "Profile error: ""HasColumnNames"" element is missing"
                        Throw New ArgumentException(errMsg)
                    End If
                    Select Case xn.InnerText.Trim.ToUpper
                        Case "TRUE"
                            hasHeader = True
                        Case "FALSE"
                            hasHeader = False
                        Case Else
                            errMsg = "Profile error: invalid ""HasColumnNames"" element"
                            Throw New ArgumentException(errMsg)
                    End Select

                    'Column count
                    xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/DataSource/ColumnCount/text()"
                    xn = xmldoc.SelectSingleNode(xpath)
                    If (xn Is Nothing) Then
                        errMsg = "Profile error: ""ColumnCount"" element is missing"
                        Throw New ArgumentException(errMsg)
                    End If
                    If (Not IsInteger(xn.InnerText)) Then
                        errMsg = "Profile error: invalid ""ColumnCount"" element"
                        Throw New ArgumentException(errMsg)
                    End If
                    columnCount = Integer.Parse(xn.InnerText)
                    If (columnCount <= 0 OrElse columnCount >= MAX_COLUMN_COUNT) Then
                        errMsg = "Profile error: invalid ""ColumnCount"" element"
                        Throw New ArgumentException(errMsg)
                    End If

                    'delimiter
                    xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/DataSource/FileDelimiter/text()"
                    xn = xmldoc.SelectSingleNode(xpath)
                    If (xn Is Nothing) Then
                        errMsg = "Profile error: ""FileDelimiter"" element is missing"
                        Throw New ArgumentException(errMsg)
                    End If
                    If (Not IsInteger(xn.InnerText)) Then
                        errMsg = "Profile error: invalid ""FileDelimiter"" element"
                        Throw New ArgumentException(errMsg)
                    End If
                    Dim ascii As Integer = Integer.Parse(xn.InnerText)
                    If (ascii <= 0 OrElse ascii >= 128) Then
                        errMsg = "Profile error: invalid ""FileDelimiter"" element"
                        Throw New ArgumentException(errMsg)
                    End If
                    delimiter = Chr(ascii)
                    If (Not DTSTextData.IsValidDelimiter(delimiter)) Then
                        errMsg = "Profile error: invalid ""FileDelimiter"" element"
                        Throw New ArgumentException(errMsg)
                    End If

                Case False  'Fixed-width
                    'Record Length
                    xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/DataSource/RecordLength/text()"
                    xn = xmldoc.SelectSingleNode(xpath)
                    If (xn Is Nothing) Then
                        errMsg = "Profile error: ""RecordLength"" element is missing"
                        Throw New ArgumentException(errMsg)
                    End If
                    If (Not IsInteger(xn.InnerText)) Then
                        errMsg = "Profile error: invalid ""RecordLength"" element"
                        Throw New ArgumentException(errMsg)
                    End If
                    recordLength = Integer.Parse(xn.InnerText)
                    If (recordLength <= 0 OrElse recordLength >= MAX_RECORD_LENGTH) Then
                        errMsg = "Profile error: invalid ""RecordLength"" element"
                        Throw New ArgumentException(errMsg)
                    End If
            End Select

            'Fields
            xpath = "//NrcDtsPackage/Connections/Connection[position()=1]/DataSource/Fields/Field"
            xnl = xmldoc.SelectNodes(xpath)
            If (isDelimited AndAlso (xnl.Count <> columnCount)) Then
                errMsg = "Profile error: column count value can not be matched with fields"
                Throw New ArgumentException(errMsg)
            End If


            For Each xn In xnl
                xmlEl = DirectCast(xn, XmlElement)
                'MessageBox.Show(msg, "Pkg", MessageBoxButtons.OK)

                column = New SourceColumn

                'Get the field name
                columnName = xmlEl.GetElementsByTagName("Name")(0).InnerText
                column.ColumnName = columnName
                If (Not column.IsValidColumnName(errMsg)) Then
                    errMsg = String.Format("Profile error: column name ""{0}"" is invalid", columnName)
                    Throw New ArgumentException(errMsg)
                End If

                'Get the field length for fixed-width text file
                If (Not isDelimited) Then
                    value = xmlEl.GetElementsByTagName("Length")(0).InnerText
                    If (Not IsInteger(value)) Then
                        errMsg = String.Format("Profile error: column length ""{0}"" is invalid", value)
                        Throw New ArgumentException(errMsg)
                    End If
                    columnLen = Integer.Parse(value)
                    If (columnLen <= 0) Then
                        errMsg = String.Format("Profile error: length of column ""{0}"" ({1}) is invalid", columnName, columnLen)
                        Throw New ArgumentException(errMsg)
                    End If
                    If (columnLen > recordLength) Then
                        errMsg = String.Format("Profile error: length of column ""{0}"" ({1}) is larger than record length ({2})", columnName, columnLen, recordLength)
                        Throw New ArgumentException(errMsg)
                    End If
                End If
                column.Length = columnLen

                'It is valid field definition. Add to column collection
                columns.Add(column)

            Next

            'Check sum of column length
            If (Not isDelimited) Then
                totalLen = 0
                For Each column In columns
                    totalLen += column.Length
                Next
                If (totalLen <> recordLength) Then
                    errMsg = String.Format("Profile error: sum of field lengths ({0}) is not equal to record length ({1})", totalLen, recordLength)
                    Throw New ArgumentException(errMsg)
                End If
            End If

            'Check column name duplicated
            Dim errColumn As Integer
            If (columns.ColumnNameDuplicated(errColumn, errMsg)) Then
                Throw New ArgumentException(errMsg)
            End If

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        End Try

        Dim textData As New DTSTextData
        With textData
            .IsDelimited = isDelimited
            .HasHeader = hasHeader
            .Delimiter = delimiter
            .TextQualifier = """"
            .Columns = columns
        End With

        Return (textData)

    End Function

    'Load new DTS Builder profile
    Private Function LoadDtsProfile(ByVal iniPath As String) As DTSTextData
        Dim keys As StringCollection
        Dim key As String
        Dim value As String
        Dim errMsg As String = ""
        Dim columns As New ColumnCollection
        Dim column As SourceColumn
        Dim isDelimited As Boolean
        Dim delimiter As String = ""
        Dim qualifier As String = ""
        Dim hasHeader As Boolean

        'Pull all keys
        keys = IniWrapper.GetProfileKeys(iniPath, PROFILE_DTS_SECTION, ProfileLetterCase.ToUpper)

        'Get the text format
        If (keys.IndexOf(PROFILE_DTS_FORMAT) < 0) Then
            errMsg = String.Format("Profile error: text format ({0}) is missing", _
                                   PROFILE_DTS_FORMAT)
            Throw New ArgumentException(errMsg)
        End If
        value = IniWrapper.GetProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_FORMAT, ProfileLetterCase.ToUpper)
        Select Case value
            Case PROFILE_DTS_FIXED
                isDelimited = False
            Case PROFILE_DTS_DELIMITED
                isDelimited = True
            Case Else
                errMsg = String.Format("Profile error: text format ({0}) definition error", _
                                       PROFILE_DTS_FORMAT)
                Throw New ArgumentException(errMsg)
        End Select

        If (isDelimited) Then
            'Get has header
            If (keys.IndexOf(PROFILE_DTS_HASHEADER) < 0) Then
                errMsg = String.Format("Profile error: first row constains field name ({0}) is missing", _
                                       PROFILE_DTS_HASHEADER)
                Throw New ArgumentException(errMsg)
            End If
            value = IniWrapper.GetProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_HASHEADER, ProfileLetterCase.ToUpper)
            Select Case value
                Case PROFILE_DTS_HASHEADER_FALSE, PROFILE_DTS_HASHEADER_0
                    hasHeader = False
                Case PROFILE_DTS_HASHEADER_TRUE, PROFILE_DTS_HASHEADER_1
                    hasHeader = True
                Case Else
                    errMsg = String.Format("Profile error: invalid definition in {0}", _
                                           PROFILE_DTS_HASHEADER)
                    Throw New ArgumentException(errMsg)
            End Select

            'Get delimiter
            If (keys.IndexOf(PROFILE_DTS_DELIMITER) < 0) Then
                errMsg = String.Format("Profile error: delimiter ({0}) is missing", _
                                       PROFILE_DTS_DELIMITER)
                Throw New ArgumentException(errMsg)
            End If
            value = IniWrapper.GetProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_DELIMITER)
            Select Case value.ToUpper
                Case PROFILE_DTS_TAB
                    delimiter = vbTab
                Case PROFILE_DTS_SEMICOLON
                    delimiter = ";"
                Case PROFILE_DTS_COMMA
                    delimiter = ","
                Case PROFILE_DTS_SPACE
                    delimiter = " "
                Case Else
                    If (value.Length >= 1) Then
                        delimiter = value.Substring(0, 1)
                    Else
                        errMsg = String.Format("Profile error: delimiter ({0}) definition is blank", _
                                               PROFILE_DTS_DELIMITER)
                        Throw New ArgumentException(errMsg)
                    End If
            End Select

            'Get text qualifier
            If (keys.IndexOf(PROFILE_DTS_QUALIFIER) >= 0) Then
                value = IniWrapper.GetProfileValue(iniPath, PROFILE_DTS_SECTION, PROFILE_DTS_QUALIFIER)
                Select Case value.ToUpper
                    Case PROFILE_DTS_TAB
                        qualifier = vbTab
                    Case PROFILE_DTS_SEMICOLON
                        qualifier = ";"
                    Case PROFILE_DTS_COMMA
                        qualifier = ","
                    Case PROFILE_DTS_SPACE
                        qualifier = " "
                    Case Else
                        If (value.Length >= 1) Then
                            qualifier = value.Substring(0, 1)
                        End If
                End Select
            End If
        End If

        'for each field, get field name.
        'if fixed-width text, get the field length
        Dim pieces() As String

        Try

            For Each key In keys
                If key.StartsWith(PROFILE_DTS_FIELD) Then
                    'Get setting for this field
                    value = IniWrapper.GetProfileValue(iniPath, PROFILE_DTS_SECTION, key)
                    If (value = "") Then
                        errMsg = String.Format("Profile error: no definition for the ""{0}"".", key)
                        Throw New ArgumentException(errMsg)
                    End If
                    pieces = value.Split(","c)
                    column = New SourceColumn

                    'Get the field name
                    column.ColumnName = pieces(0)
                    If (Not column.IsValidColumnName(errMsg)) Then
                        errMsg = String.Format("Profile error: field name error for the field ""{0}"".{1}{2}", _
                                               key, _
                                               vbCrLf + vbCrLf, _
                                               errMsg)
                        Throw New ArgumentException(errMsg)
                    End If

                    'Get the field length for fixed-width text file
                    If (Not isDelimited) Then
                        If (pieces.Length < 2) Then
                            errMsg = String.Format("Profile error: field length is not defined for the field ""{0}"".", key)
                            Throw New ArgumentException(errMsg)
                        End If
                        Try
                            column.Length = Integer.Parse(pieces(1))
                        Catch ex As Exception
                            errMsg = String.Format("Profile error: field length error for the field ""{0}"".", key)
                            Throw New ArgumentException(errMsg)
                        End Try
                    End If

                    'It is valid field definition. Add to column collection
                    columns.Add(column)
                End If
            Next

        Catch ex As Exception
            Throw New ArgumentException("Profile error: " + ex.Message)
        End Try

        Dim textData As New DTSTextData
        With textData
            .IsDelimited = isDelimited
            .HasHeader = hasHeader
            .Delimiter = delimiter
            .TextQualifier = qualifier
            .Columns = columns
        End With

        Return (textData)

    End Function

    Private Function IsProfileValid(ByVal profileColumns As ColumnCollection, _
                                    ByRef errMsg As String) As Boolean
        Select Case mTextData.IsDelimited
            Case True   'Delimited text file

            Case False  'Fixed-width text file
                Dim totalLen As Integer = 0
                Dim i As Integer

                'The sum of profiled field lengths (except the last field) 
                'must be less than the longest row in template file
                For i = 0 To profileColumns.Count - 2
                    totalLen += profileColumns(i).Length
                Next
                If (totalLen >= mMaxRowLength) Then
                    errMsg = "Profile error: sum of field lengths in profile exceeds the longest row in template file."
                    Return False
                End If

        End Select

        Return True

    End Function

    Private Function ProfileType(ByVal iniPath As String) As Integer
        Dim sections As StringCollection

        'Check profile type
        'Kitchensynk version has section of "Defined Tables"
        'Gary version has the file extension of ".pkg"
        'Others are new version
        Dim file As New IO.FileInfo(iniPath)
        If (file.Extension.ToLower = ".pkg") Then Return (PROFILE_GARY)

        sections = IniWrapper.GetProfileSectionNames(iniPath)
        If (sections(0).ToUpper = PROFILE_KITCHEN_HEAD_SECTION) Then
            Return PROFILE_KITCHEN
        Else
            Return PROFILE_DTS
        End If

    End Function

    Private Function ColumnNameExist(ByVal name As String) As Boolean
        Dim col As SourceColumn

        name = name.ToUpper
        For Each col In mTextData.Columns
            If (col.ColumnName.ToUpper = name) Then Return True
        Next
        Return False
    End Function

    Private Function IsInteger(ByVal str As String) As Boolean
        Try
            Integer.Parse(str)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

#End Region

End Class

