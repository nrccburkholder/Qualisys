Option Explicit On 
Option Strict On

Imports System.IO
Imports System.Text

Public Class DTSTextData
    Inherits DTSDataSet
    Implements ICloneable

#Region " Public Members "

    Public Shared DEFAULT_DELIMITED As Boolean = True
    Public Shared DEFAULT_DELIMITER As String = vbTab
    Public Shared DEFAULT_QUALIFIER As String = String.Empty
    Public Shared DEFAULT_HAS_HEADER As Boolean
    Public Shared DEFAULT_RULER_SCALE As RulerScales = RulerScales.ZeroBased

#End Region

#Region " Private Members "

    Protected mIsDelimited As Boolean = DEFAULT_DELIMITED
    Protected mDelimiter As String = DEFAULT_DELIMITER
    Protected mTextQualifier As String = DEFAULT_QUALIFIER
    Protected mHasHeader As Boolean = DEFAULT_HAS_HEADER
    Protected mRulerScale As RulerScales = DEFAULT_RULER_SCALE

#End Region

#Region " Public Properties "

    Public Property IsDelimited() As Boolean
        Get
            Return mIsDelimited
        End Get
        Set(ByVal Value As Boolean)
            mIsDelimited = Value
        End Set
    End Property

    Public Property Delimiter() As String
        Get
            Return mDelimiter
        End Get
        Set(ByVal Value As String)
            mDelimiter = Value
        End Set
    End Property

    Public Property TextQualifier() As String
        Get
            Return mTextQualifier
        End Get
        Set(ByVal Value As String)
            mTextQualifier = Value
        End Set
    End Property

    Public Property HasHeader() As Boolean
        Get
            Return mHasHeader
        End Get
        Set(ByVal Value As Boolean)
            mHasHeader = Value
        End Set
    End Property

    Public Property RulerScale() As RulerScales
        Get
            Return mRulerScale
        End Get
        Set(ByVal Value As RulerScales)
            mRulerScale = Value
        End Set
    End Property

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property ColumnLengths() As String
        Get
            Dim lengths As String = String.Empty

            For Each col As SourceColumn In Columns
                lengths &= String.Format("{0},", col.Length)
            Next

            If lengths.Length > 0 Then
                lengths = lengths.Substring(0, lengths.Length - 1)
            End If

            Return lengths
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        MyBase.New(DataSetTypes.Text)

        IsDelimited = DEFAULT_DELIMITED
        Delimiter = DEFAULT_DELIMITER
        TextQualifier = DEFAULT_QUALIFIER
        HasHeader = DEFAULT_HAS_HEADER

    End Sub

#End Region

#Region " Public Methods "

    Public Function CloneMe() As Object Implements ICloneable.Clone

        Return Clone()

    End Function

    Public Function Clone() As DTSTextData

        Dim textData As New DTSTextData

        With textData
            .TemplateFileName = TemplateFileName
            .mIsDelimited = mIsDelimited
            .mDelimiter = mDelimiter
            .mTextQualifier = TextQualifier
            .mHasHeader = mHasHeader
            .mRulerScale = mRulerScale

            If (Not mColumns Is Nothing) Then
                .mColumns = mColumns.Clone
            End If
        End With

        Return textData

    End Function

    Public Overrides Sub SplitSettings(ByVal settings As String)

        Dim c As String
        Dim args() As String = settings.Split(SEPARATOR)

        If args.Length < 6 Then
            Throw New ArgumentException("Setting string in source data set is incorrect")
        End If

        'template file
        TemplateFileName = args(0)

        'is delimited?
        IsDelimited = CBool(IIf(args(1) = "0", False, True))

        Select Case IsDelimited
            Case False      'Fixed-width
                'ruler scale
                RulerScale = CType(IIf(args(5) = "0", RulerScales.ZeroBased, RulerScales.OneBased), RulerScales)

            Case True       'Delimited
                'delimiter
                c = args(2)
                If (Not IsValidDelimiter(c)) Then
                    Throw New ArgumentException("Delimiter is invalid")
                End If
                Delimiter = c

                'has header?
                HasHeader = CBool(IIf(args(3) = "0", False, True))

                'text qualifier
                c = args(4)
                If c.Length > 1 Then
                    Throw New ArgumentException("Text qualifier is longer than one character")
                ElseIf c.Length = 1 Then
                    If (Not IsValidDelimiter(c)) Then
                        Throw New ArgumentException("Text qualifier is invalid")
                    End If

                    If (c = Delimiter) Then
                        Throw New ArgumentException("Text qualifier is the same as delimiter")
                    End If
                End If

                TextQualifier = c

        End Select

    End Sub

    Public Overrides Function ConcatSettings() As String

        Return String.Format("{0}{1}{2}{1}{3}{1}{4}{1}{5}{1}{6}", TemplateFileName, SEPARATOR, IIf(IsDelimited, 1, 0), Delimiter, IIf(HasHeader, 1, 0), TextQualifier, IIf(RulerScale = RulerScales.ZeroBased, 0, 1))

    End Function

    Public Overrides Function GetRecordCount(ByVal filePath As String) As Integer

        If (filePath Is Nothing OrElse filePath = "") Then
            Throw New ArgumentException("The text file name is blank")
        End If

        Dim sr As StreamReader = Nothing
        Try
            sr = New StreamReader(filePath)
            Dim count As Integer = 0

            Do Until sr.Peek = -1
                sr.ReadLine()
                count += 1
            Loop

            'decrease 1 for the header record
            If (IsDelimited And HasHeader And count > 0) Then count -= 1

            Return count

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)

        Finally
            If (Not sr Is Nothing) Then sr.Close()

        End Try

    End Function

    Public Sub CleanFile(ByVal inFilePath As String, ByVal outFilePath As String)

        If (inFilePath Is Nothing OrElse inFilePath = "" OrElse outFilePath Is Nothing OrElse outFilePath = "") Then
            Throw New ArgumentException("The text file name is blank")
        End If

        If mIsDelimited Then
            CleanDelimited(inFilePath, outFilePath)
        Else
            CleanFixedWidth(inFilePath, outFilePath)
        End If

    End Sub

    Public Overrides Function GetDataTable(ByVal filePath As String, ByVal rowCount As Integer) As DataTable

        If (filePath Is Nothing OrElse filePath = "") Then
            Throw New ArgumentException("The text file name is blank")
            Return Nothing
        End If

        'Create DataTable object
        Dim dt As New DataTable("Text")
        Dim cnt As Integer = 0

        For Each column As SourceColumn In Columns
            cnt += 1
            dt.Columns.Add(column.ColumnName, GetType(String))

            'for fixed width text file, set max column length for the columns except the last one.
            If ((Not mIsDelimited) AndAlso (cnt = Columns.Count)) Then
                dt.Columns(column.ColumnName).MaxLength = column.Length
            End If
        Next

        'Load text data
        Dim sr As StreamReader = Nothing
        cnt = 0

        Try
            sr = New StreamReader(filePath)
            Do Until sr.Peek = -1
                Dim line As String = sr.ReadLine
                cnt += 1

                'Parse text
                If (IsDelimited) Then
                    'Check if first line is header
                    If (cnt > 1 OrElse (Not HasHeader)) Then
                        LoadDelimitedText(dt, line)
                    End If
                Else
                    LoadFixedWidthText(dt, line)
                End If

                If (cnt >= rowCount) Then Exit Do
            Loop

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)

        Finally
            If (Not sr Is Nothing) Then sr.Close()

        End Try

        Return dt

    End Function

    Public Shared Function IsValidDelimiter(ByVal delimiter As String) As Boolean

        Dim c As Char = delimiter.Chars(0)

        If (Char.IsDigit(c) OrElse Char.IsUpper(c) OrElse Char.IsLower(c)) Then
            Return False
        Else
            Return True
        End If

    End Function

    Protected Overrides Function GetSchema(ByVal filePath As String) As DataTable

        'Text package can not get schema from file.
        Return Nothing

    End Function

    Public Overrides Function ValidateFile(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults

        If mIsDelimited Then
            Return ValidateDelimited(filePath, errMsg)
        Else
            Return ValidateFixedWidth(filePath, errMsg)
        End If

    End Function

    ' This method is only used for testing/debugging
    Public Overrides Function Settings() As String

        Dim str As New StringBuilder

        str.Append(String.Format("Dataset type: {0}{1}", DataSetType, vbCrLf))
        str.Append(String.Format("Format: {0}{1}", CStr(IIf(IsDelimited, "Delimited", "Fixed-width")), vbCrLf))
        str.Append(String.Format("Delimiter: {{{0}}}{1}", Delimiter, vbCrLf))
        str.Append(String.Format("Qualifier: {{{0}}}{1}", CStr(IIf(TextQualifier = "", "N/A", TextQualifier)), vbCrLf))
        str.Append(String.Format("Has header: {0}{1}", HasHeader, vbCrLf))
        str.Append(String.Format("Ruler scale: {0}{1}{1}", RulerScale, vbCrLf))
        str.Append(String.Format("Ordinal: Name  Type  Length  Original Name  Source ID{0}", vbCrLf))
        str.Append(String.Format("================================{0}", vbCrLf))

        For Each col As SourceColumn In Columns
            With col
                str.Append(String.Format("{0}:  ", .Ordinal))
                str.Append(String.Format("{0}    ", .ColumnName))
                str.Append(String.Format("{0} ({1})    ", .DataType, .DataTypeString))
                str.Append(String.Format("{0}    ", .Length))
                str.Append(String.Format("{0}    ", .OriginalName))
                str.Append(String.Format("{0}{1}", .SourceID, vbCrLf))
            End With
        Next

        Return str.ToString

    End Function

#End Region

#Region " Private Methods "

    Private Sub LoadFixedWidthText(ByVal dt As DataTable, ByVal line As String)

        Dim colPos As Integer = 0
        Dim lineLen As Integer = line.Length
        Dim colLen As Integer
        Dim dr As DataRow = dt.NewRow
        Dim cnt As Integer = 0

        For Each column As SourceColumn In Columns
            cnt += 1

            'start position is not within line
            If (colPos >= lineLen) Then Exit For

            colLen = column.Length

            'if start position plus length indicates a position not within line, decrease the length
            If (colPos + colLen > lineLen) Then
                colLen = lineLen - colPos
            End If

            'if it is the last column, include the rest text of the line into this column
            If (cnt = Columns.Count) Then 'last column
                colLen = lineLen - colPos
            End If

            'get column data
            dr(column.ColumnName) = line.Substring(colPos, colLen)

            colPos += column.Length
        Next

        dt.Rows.Add(dr)

    End Sub

    Private Sub LoadDelimitedText(ByVal dt As DataTable, ByVal line As String)

        'Split text into columns
        Dim colData() As String = SplitDelimitedText(line)

        'Set row data
        Dim dr As DataRow = dt.NewRow
        For cnt As Integer = 0 To colData.GetUpperBound(0)
            dr(cnt) = colData(cnt)
        Next

        dt.Rows.Add(dr)

    End Sub

    'split 1 line delimited text into fields
    Private Function SplitDelimitedText(ByVal line As String) As String()

        If (mTextQualifier = "") Then
            Return SplitDelimitedTextWithoutQualifier(line)
        Else
            Return SplitDelimitedTextWithQualifier(line)
        End If

    End Function

    'If no text qualifier is specified, use this method to split 1 line delimited text into fields 
    Private Function SplitDelimitedTextWithoutQualifier(ByVal line As String) As String()

        Return (line.Split(CChar(mDelimiter)))

    End Function

    'If text qualifier is specified, use this method to split 1 line delimited text into fields 
    Private Function SplitDelimitedTextWithQualifier(ByVal line As String) As String()

        Dim columns As New System.Collections.Specialized.StringCollection
        Dim lastPos As Integer = line.Length - 1
        Dim endPos As Integer
        Dim cnt As Integer = 0
        Dim beginPos As Integer = 0
        Dim betweenQualifier As Boolean = False

        If line Is Nothing Then
            Return Nothing
        End If

        Do While (cnt <= lastPos)
            Select Case line.Substring(cnt, 1)
                Case mDelimiter
                    'found column end
                    If (Not betweenQualifier) Then
                        endPos = cnt - 1
                        If (endPos < beginPos) Then
                            columns.Add("")
                        Else
                            columns.Add(StripQualifier(line.Substring(beginPos, endPos - beginPos + 1)))
                        End If
                        beginPos = cnt + 1
                    End If

                Case mTextQualifier
                    If (Not betweenQualifier) Then      'Begin of qualified field
                        betweenQualifier = True
                    Else        'already in the qualified field
                        If (cnt < lastPos) Then
                            'double text qualifier means a normal char of qualifier
                            If (line.Substring(cnt + 1, 1) = mTextQualifier) Then
                                cnt += 1
                            Else    'End of qualified field
                                betweenQualifier = False
                            End If
                        End If
                    End If

            End Select

            cnt += 1
        Loop

        'last column
        If (beginPos <= lastPos) Then
            columns.Add(StripQualifier(line.Substring(beginPos, lastPos - beginPos + 1)))
        End If

        'blank line
        If (columns.Count = 0) Then
            Return New String() {""}
        End If

        'line has text
        Dim arr(columns.Count - 1) As String
        columns.CopyTo(arr, 0)

        Return arr

    End Function

    'Strip the text qualifier
    Private Function StripQualifier(ByVal str As String) As String

        Dim result As New StringBuilder
        Dim betweenQualifier As Boolean = False
        Dim cnt As Integer = 0
        Dim lastPos As Integer = str.Length - 1

        Do While (cnt <= lastPos)
            Select Case str.Substring(cnt, 1)
                Case mTextQualifier     'Qualifier char
                    If (Not betweenQualifier) Then      'Begin of qualified field
                        betweenQualifier = True
                    Else        'already in the qualified field
                        If (cnt < lastPos) Then
                            'double text qualifier means a normal char of qualifier
                            If (str.Substring(cnt + 1, 1) = mTextQualifier) Then
                                result.Append(mTextQualifier)
                                cnt += 1
                            Else    'End of qualified field
                                betweenQualifier = False
                            End If
                        End If
                    End If

                Case Else   'Char other than qualifier
                    result.Append(str.Substring(cnt, 1))

            End Select

            cnt += 1
        Loop

        Return result.ToString

    End Function

    Private Function ValidateFixedWidth(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults

        Dim inStream As StreamReader = Nothing
        Dim length As Integer = 0
        Dim line As String
        Dim lineNum As Integer = 0
        Dim shortCount As Integer = 0

        'Determine the record length for each line by adding up all the individual column lengths
        For Each col As SourceColumn In mColumns
            length += col.Length
        Next

        Try
            'Open the file and also a temp file for cleaning
            inStream = New StreamReader(filePath)

            'Read each line
            Do Until inStream.Peek = -1
                'Pull in the line
                line = inStream.ReadLine()
                lineNum += 1        'Increment line number

                If line.Length > length Then
                    'If line is long then return false
                    errMsg = String.Format("Line number {0} is longer than defined in this package.", lineNum)
                    Return FileValidationResults.InvalidFile
                ElseIf line.Length < length Then
                    'If the length is too short then keep a count of how many
                    shortCount += 1
                End If
            Loop

            'If the shortCount is more than the threshold defined for the package then the package is not valid
            If shortCount > (lineNum * mBadRecordThreshold) Then
                errMsg = "Too many records contain less characters than the defined length for this package."
                Return FileValidationResults.FileWarning
            End If

            'Close the stream
            inStream.Close()
            inStream = Nothing

        Catch ex As Exception
            Throw New Exception(ex.Message)

        Finally
            If (Not inStream Is Nothing) Then inStream.Close()

        End Try

        Return FileValidationResults.ValidFile

    End Function

    Private Function ValidateDelimited(ByVal filePath As String, ByRef errMsg As String) As FileValidationResults

        Dim sr As StreamReader = Nothing
        Dim line As String
        Dim lineNum As Integer = 0
        Dim shortCount As Integer = 0
        Dim fields() As String
        Dim fileColumnName As String
        Dim dtsColumnName As String

        Try
            sr = New StreamReader(filePath)

            'If this source has a header then make sure it matches...
            If mHasHeader Then
                'Check if header row exists
                If (sr.Peek = -1) Then
                    errMsg = "There is no header line in this text file."
                    Return FileValidationResults.InvalidFile
                End If

                'Check column number
                line = sr.ReadLine()
                lineNum += 1
                fields = SplitDelimitedText(line)
                If (fields.Length <> mColumns.Count) Then
                    errMsg = "The number of header columns in the text file is different from that in DTS package"
                    Return FileValidationResults.InvalidFile
                End If

                'Check column original name
                For cnt As Integer = 0 To mColumns.Count - 1
                    fileColumnName = fields(cnt).Trim
                    dtsColumnName = CType(mColumns(cnt), SourceColumn).OriginalName

                    If ((fileColumnName = "" AndAlso Not SourceColumn.IsDefaultColumnName(dtsColumnName)) OrElse (fileColumnName <> "" AndAlso fileColumnName <> dtsColumnName)) Then
                        errMsg = String.Format("Name unmatched for column {0}.{1}Column name in DTS package is {2}.{1}Column name in loading file is {3}.", cnt + 1, vbCrLf, dtsColumnName, fileColumnName)
                        Return FileValidationResults.InvalidFile
                    End If
                Next
            End If

            'Now check every line after the header to make sure it doesn't have too many columns, also make sure the number of records with too FEW columns is within our threshold
            line = sr.ReadLine
            lineNum += 1
            While Not line Is Nothing
                'Split the line into columns
                fields = SplitDelimitedText(line)

                'If the count is too few then add it to the count. If the count is too high then RETURN FALSE
                If (fields.Length < mColumns.Count) Then
                    shortCount += 1
                ElseIf fields.Length > mColumns.Count Then
                    errMsg = "The number of columns in the text file is different from that in DTS package"
                    Return FileValidationResults.InvalidFile
                End If

                'Get the next line
                line = sr.ReadLine
                lineNum += 1
            End While

            'Now if the number of short records is above threshold RETURN FALSE
            If shortCount > (lineNum * mBadRecordThreshold) Then
                errMsg = "Too many records contain less columns than the defined package."
                Return FileValidationResults.FileWarning
            End If

            'If by some miracle we arrive here, everything must be fine
            Return FileValidationResults.ValidFile

        Catch ex As Exception
            errMsg = ex.Message
            Return FileValidationResults.InvalidFile

        Finally
            If Not sr Is Nothing Then
                sr.Close()
            End If

        End Try

    End Function

    'Reads through the file and if it finds a record that is too short it adds spaces to the end.  If a record is found that is too long an exception is thrown
    Private Sub CleanFixedWidth(ByVal inFilePath As String, ByVal outFilePath As String)

        Dim length As Integer = 0

        'Determine the record length for each line by adding up all the individual column lengths
        For Each col As SourceColumn In mColumns
            length += col.Length
        Next

        Try
            If File.Exists(outFilePath) Then
                Throw New FieldAccessException(String.Format("Cannot clean file.  The file {0} already exists.", outFilePath))
            End If

            'Open the file and also a temp file for cleaning
            Using reader As StreamReader = New StreamReader(inFilePath, Encoding.Default),
                writer As StreamWriter = New StreamWriter(outFilePath, False, Encoding.Default)

                'Read each line
                Dim lineNum As Integer = 0
                Do Until reader.Peek = -1
                    'Pull in the line
                    Dim line As String = reader.ReadLine()
                    line = line.Replace(vbLf, vbCrLf) 'TSB 11/14/2013  ENHC0010029

                    lineNum += 1        'Increment line number

                    If line.Length = length Then
                        'If line is correct length then just write it to temp file
                        writer.WriteLine(line)
                    ElseIf line.Length < length Then
                        'If line is short then pad it
                        writer.WriteLine(line.PadRight(length))
                    End If
                Loop

            End Using

        Catch ex As Exception
            Throw New Exception(ex.Message)
        End Try

    End Sub

    'Cleans a delimited text file because some files come with delimiters at the end of every record or also blank columns in the column header
    'This procedure will replace any blank columns in the header with a default column name
    Private Sub CleanDelimited(ByVal inFilePath As String, ByVal outFilePath As String)

        Try
            '' Because we need to modify LF to CRLF, regardless of whether there is a header or not
            '' we need to "clean" each row  -- TSB 11/14/2013  ENHC0010029

            'Open the streams
            Using reader As StreamReader = New StreamReader(inFilePath, Encoding.Default),
                writer As StreamWriter = New StreamWriter(outFilePath, False, Encoding.Default)

                Dim line As String = reader.ReadLine

                ' If there is a header
                If HasHeader Then

                    Dim fieldsUsed As Hashtable = New Hashtable

                    'Split the header
                    Dim fields() As String = SplitDelimitedText(line)

                    'Create a list of all the used column names
                    For cnt As Integer = 0 To fields.Length - 1
                        If Not fields(cnt) Is Nothing AndAlso Not fields(cnt) = "" Then
                            fieldsUsed.Add(fields(cnt), True)
                        End If
                    Next

                    'Check each field, if it is blank then replace with default name
                    Dim blankCount As Integer = 1
                    For cnt As Integer = 0 To fields.Length - 1
                        If fields(cnt) Is Nothing OrElse fields(cnt) = "" Then
                            Do
                                'Replace with a default column name until we find one that is not already used in the list
                                fields(cnt) = Column.GetDefaultColumnName(blankCount)
                                blankCount += 1
                            Loop While Not fieldsUsed(fields(cnt)) Is Nothing

                            'Add this field to our list of used column names
                            fieldsUsed.Add(fields(cnt), True)
                        End If

                        'Now add the text qualifier to the column name just to ensure that we didn't screw something up if the qualifiers were there originally
                        fields(cnt) = String.Format("{0}{1}{0}", mTextQualifier, fields(cnt))
                    Next

                    'Reform the line
                    line = String.Join(mDelimiter, fields)

                End If

                'Now write all the lines to the output file
                While Not line Is Nothing
                    Dim newLine As String = line.Replace(vbLf, vbCrLf) ' TSB 11/14/2013  ENHC0010029
                    writer.WriteLine(newLine)
                    line = reader.ReadLine
                End While

            End Using


        Catch ex As Exception
            Throw ex
        End Try

    End Sub


#End Region

End Class
