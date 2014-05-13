Imports System.Collections.ObjectModel
Imports System.Text
Imports System.IO

Namespace Data

    Public Class DbfWriter
        Inherits DataWriter

#Region " Private Fields "
        Const EOF_MARKER As Integer = 26
        Const LANGUAGE_DRIVER_CODE As Integer = 27
        Const MAX_COLUMNS As Integer = 254

        Private mDbfColumns As Collection(Of DbfColumn)
        Private mColSets As List(Of List(Of DbfColumn))
        Private mWriters As List(Of BinaryWriter)
        Private mFileCount As Integer

#End Region

#Region " Constructors "
        ''' <summary>
        ''' Initializes the DbfWriter instance.
        ''' </summary>
        ''' <param name="reader">The data reader to be used in creating the DBF file.</param>
        Public Sub New(ByVal reader As IDataReader)
            MyBase.New(reader)
        End Sub

#End Region

#Region " Protected Properties "
        Protected Overrides ReadOnly Property ColumnNameMaxLength() As Integer
            Get
                Return 10
            End Get
        End Property
#End Region

        ''' <summary>
        ''' Creates a DBF file (or multiple files) from the specified IDataReader and schema column collection
        ''' </summary>
        ''' <param name="filePath">The full path of the file to create</param>
        ''' <param name="reportProgressInterval">Indicates the number of records that should be written before the ReportProgress event is raised</param>
        ''' <param name="filesCreated">The ByRef filesCreated will contain the number of files created after the operation completes.</param>
        ''' <returns>Returns the number of records written</returns>
        Public Overloads Function Write(ByVal filePath As String, ByVal reportProgressInterval As Integer, ByRef filesCreated As Integer) As Integer
            Dim recordCount As Integer = MyBase.Write(filePath, reportProgressInterval)
            filesCreated = Me.mFileCount
            Return recordCount
        End Function

        Protected Overrides Sub BeginWrite()
            MyBase.BeginWrite()

            'Initialize the DbfColumn Schema
            Me.InitDbfSchema()

            'Break up all the columns into sets.  One column set per file defines all the columns in a file
            mColSets = Me.BuildColumnSets
            mWriters = New List(Of BinaryWriter)

            'The file count is the number of column sets that we have
            Me.mFileCount = mColSets.Count


            'If the file needs to be split then create writers with a file number appended to the name
            If mFileCount > 1 Then
                'Create all the binary writers
                Dim splitFilePath As String = Path.GetDirectoryName(FilePath) & "\" & Path.GetFileNameWithoutExtension(FilePath) & "_{0}" & Path.GetExtension(FilePath)
                For i As Integer = 1 To mFileCount
                    mWriters.Add(New BinaryWriter(New FileStream(String.Format(splitFilePath, i), FileMode.Create)))
                Next
            Else
                'Write single file with original name
                mWriters.Add(New BinaryWriter(New FileStream(FilePath, FileMode.Create)))
            End If

            'Write out all the file headers
            For i As Integer = 0 To mFileCount - 1
                mWriters(i).Write(GetHeaderBytes(mColSets(i)))
            Next

        End Sub
        Protected Overrides Sub WriteRow(ByVal reader As System.Data.IDataReader)
            'Write the record to each of the files
            For i As Integer = 0 To mFileCount - 1
                mWriters(i).Write(GetRecordBytes(mColSets(i), reader))
            Next
        End Sub

        Protected Overrides Sub EndWrite(ByVal recordsWritten As Integer)
            MyBase.EndWrite(recordsWritten)

            'For each binary writer
            For i As Integer = 0 To mFileCount - 1
                'Write the end of file marker
                mWriters(i).Write(BitConverter.GetBytes(EOF_MARKER)(0))

                'Move to byte four where we need to store the record count
                mWriters(i).Seek(4, SeekOrigin.Begin)

                'Write the total record count to the header
                mWriters(i).Write(BitConverter.GetBytes(recordsWritten))
            Next

            'Close any file streams
            For i As Integer = 0 To mFileCount - 1
                If mWriters(i) IsNot Nothing Then
                    mWriters(i).Close()
                End If
            Next
        End Sub

#Region " Private Methods "

        ''' <summary>
        ''' Splits up all of the columns in the schema into sets of columns 
        ''' that define all of the columns in each DBF that will be created.
        ''' </summary>
        ''' <returns>Returns the list of column sets</returns>
        ''' <remarks>This function essentially splits the data set into multiple
        ''' files in order to accomodate the DBF column number limit</remarks>
        Private Function BuildColumnSets() As List(Of List(Of DbfColumn))
            'We need to build a list of column collections
            Dim columnSets As New List(Of List(Of DbfColumn))
            Dim masterColumns As New List(Of DbfColumn)
            Dim normalColumns As New List(Of DbfColumn)

            'For each column determine if it should be ignored and if it is a "master column"
            'A "master column" will be included in any file that is split to accomodate the 255 column limit
            For Each col As DbfColumn In Me.mDbfColumns
                If Not col.IgnoreColumn Then
                    If col.IsMasterColumn Then
                        masterColumns.Add(col)
                    Else
                        normalColumns.Add(col)
                    End If
                End If
            Next

            If masterColumns.Count >= MAX_COLUMNS Then
                Throw New Exception("The number of master columns cannot exceed the DBF column limit of " & MAX_COLUMNS.ToString)
            End If

            'If there are no "normal columns" then the only column set is the master columns
            If normalColumns.Count = 0 Then
                columnSets.Add(masterColumns)
            Else        'There are normal columns

                'As long as there are still normal columns in the list that need
                'to be assinged to a column set...
                While normalColumns.Count > 0
                    'Keep track of the count in this column set
                    Dim colCount As Integer = 0
                    Dim colSet As New List(Of DbfColumn)

                    'Add all of the master columns to the column set
                    For Each col As DbfColumn In masterColumns
                        colSet.Add(col)
                        colCount += 1
                    Next

                    'Keep adding column as long as we are under the column limit
                    'and there are still normal columns unassigned
                    While colCount < MAX_COLUMNS AndAlso normalColumns.Count > 0
                        'Add the column to the column set 
                        colSet.Add(normalColumns(0))
                        normalColumns.RemoveAt(0)
                        colCount += 1
                    End While

                    'Add the column set to the collection
                    columnSets.Add(colSet)
                End While
            End If

            'Return all of the column sets
            Return columnSets
        End Function

#Region " Header Methods "
        Private Enum HeaderIndex
            FileVersion = 0
            DateModified = 1
            HeaderLength = 8
            RecordLength = 10
            LanguageDriver = 29
            ColumnDefinitions = 32
        End Enum
        ''' <summary>
        ''' Builds the binary data for the Header of a DBF file that will contain the list of columns specified
        ''' </summary>
        ''' <param name="columnList">The list of columns in this DBF file</param>
        ''' <returns>Returns an array of bytes representing the DBF file header</returns>
        ''' <remarks>Many of the fields in the header are left blank</remarks>
        Private Function GetHeaderBytes(ByVal columnList As List(Of DbfColumn)) As Byte()
            'Calculate the total length of the header data
            '32 bytes for the initial header, 32 bytes per column, and a 1 byte terminator
            Dim totalLength As Integer = 32 + (32 * columnList.Count) + 1

            'Create the header data array
            Dim headerData(totalLength - 1) As Byte

            'Write the file version
            headerData(HeaderIndex.FileVersion) = BitConverter.GetBytes(DbfVersion.File_Without_DBT)(0)

            'Write the date modified
            Me.GetCurrentDateBytes.CopyTo(headerData, HeaderIndex.DateModified)

            'Header length
            Dim headerLength As Byte() = BitConverter.GetBytes(totalLength)
            headerData(HeaderIndex.HeaderLength) = headerLength(0)
            headerData(HeaderIndex.HeaderLength + 1) = headerLength(1)

            Dim recordLength As Byte() = BitConverter.GetBytes(Me.GetTotalRecordLength(columnList))
            'Record length
            headerData(HeaderIndex.RecordLength) = recordLength(0)
            headerData(HeaderIndex.RecordLength + 1) = recordLength(1)

            'Set the "Language Driver" 
            headerData(HeaderIndex.LanguageDriver) = LANGUAGE_DRIVER_CODE


            'Now write out the data for each column definition
            Dim i As Integer = HeaderIndex.ColumnDefinitions
            For Each col As DbfColumn In columnList
                'Get the column definition data
                Dim columnDef As Byte() = Me.GetColumnHeaderBytes(col)
                columnDef.CopyTo(headerData, i)
                i += 32
            Next

            'Write the header terminator
            headerData(totalLength - 1) = BitConverter.GetBytes(13)(0)

            Return headerData
        End Function

        ''' <summary>
        ''' Gets the data for the column definition of the DBF header
        ''' </summary>
        ''' <param name="col">The column for the definition data</param>
        ''' <returns>Returns an array of bytes representing the column definition data</returns>
        Private Function GetColumnHeaderBytes(ByVal col As DbfColumn) As Byte()
            'Column definition data is 32 bytes
            Dim header(31) As Byte

            'Encode the column name
            Dim colName As Byte() = ASCIIEncoding.ASCII.GetBytes(col.Name)
            colName.CopyTo(header, 0)

            'Write the column type character code
            header(11) = Convert.ToByte(Me.GetColumnTypeCode(col.ColumnType))

            'Write the column length 
            header(16) = BitConverter.GetBytes(col.Length)(0)

            'Write the decimal count
            header(17) = BitConverter.GetBytes(col.DecimalCount)(0)

            Return header
        End Function

        ''' <summary>
        ''' Computes the total length of a record for the specified column list
        ''' </summary>
        ''' <param name="columnList">The set of columns that defines the DBF file</param>
        ''' <returns>Returns the length of each record in the file</returns>
        Private Function GetTotalRecordLength(ByVal columnList As List(Of DbfColumn)) As Integer
            Dim sum As Integer = 0
            For Each col As DbfColumn In columnList
                sum += col.Length
            Next

            Return sum + 1
        End Function

        ''' <summary>
        ''' Returns a byte array containing the current date
        ''' </summary>
        Private Function GetCurrentDateBytes() As Byte()
            Dim year As Integer = Date.Now.Year
            Dim month As Integer = Date.Now.Month
            Dim day As Integer = Date.Now.Day

            year = year - 1900

            Dim dateBytes(2) As Byte
            dateBytes(0) = BitConverter.GetBytes(year)(0)
            dateBytes(1) = BitConverter.GetBytes(month)(0)
            dateBytes(2) = BitConverter.GetBytes(day)(0)

            Return dateBytes
        End Function
#End Region

        ''' <summary>
        ''' Builds the binary data for an individual record in the DBF
        ''' </summary>
        ''' <param name="columnList">The column set defining the DBF file</param>
        ''' <param name="rdr">The IDataReader that contains the data to be written</param>
        ''' <returns>Returns an array of bytes representing the record data</returns>
        Private Function GetRecordBytes(ByVal columnList As List(Of DbfColumn), ByVal rdr As IDataReader) As Byte()
            Dim record As New System.Text.StringBuilder
            Dim value As String = ""
            Dim dateValue As Date
            Dim decimalValue As Decimal

            'Start the record with the delete flag
            record.Append(" ")

            For Each col As DbfColumn In columnList
                If IsDBNull(rdr(col.Ordinal)) OrElse String.IsNullOrEmpty(rdr(col.Ordinal).ToString) Then
                    value = " ".PadLeft(col.Length)
                Else
                    value = rdr(col.Ordinal).ToString

                    Select Case col.ColumnType
                        Case DbfColumnType.Number
                            'We are using a default of 5 decimals
                            decimalValue = Decimal.Round(Decimal.Parse(value), 5)
                            value = decimalValue.ToString.PadLeft(col.Length)
                        Case DbfColumnType.Integer
                            value = value.PadLeft(col.Length)
                        Case DbfColumnType.Character
                            value = value.PadRight(col.Length)
                        Case DbfColumnType.Date
                            'DBF requires YYYYMMDD format
                            dateValue = DateTime.Parse(value)
                            value = dateValue.Year.ToString & dateValue.Month.ToString.PadLeft(2, Char.Parse("0")) & dateValue.Day.ToString.PadLeft(2, Char.Parse("0"))
                        Case DbfColumnType.Logical
                            value = value.Substring(0, 1)
                    End Select
                End If

                'Make sure we haven't exceeded the maximum length for the column
                If value.Length > col.Length Then
                    Throw New Exception("Value for column " & col.Name & "exceeds the maximum length for data type " & col.ColumnType.ToString)
                Else
                    record.Append(value)
                End If
            Next

            'Check the array for 0 values because these are not valid
            'SqlDataReader appears to return a string containing bytes of 0's when a 
            'Char(x) column contains the empty string.  We couldn't find a good 
            'way of detecting them so this clean up check was written. :(
            Dim result As Byte() = System.Text.ASCIIEncoding.ASCII.GetBytes(record.ToString)
            For i As Integer = 0 To result.Length - 1
                'If the byte is zero then replace it with an ASCII space
                If result(i) = 0 Then
                    result(i) = 32
                End If
            Next
            Return result
        End Function

        ''' <summary>
        ''' Converts a DbfColumnType to the single character code for DBF
        ''' </summary>
        ''' <param name="columnType">The DbfColumnType to convert</param>
        ''' <returns>A character representing the DBF code for the data type</returns>
        Public Function GetColumnTypeCode(ByVal columnType As DbfColumnType) As Char
            Select Case columnType
                Case DbfColumnType.Character
                    Return Char.Parse("C")
                Case DbfColumnType.Date
                    Return Char.Parse("D")
                Case DbfColumnType.Integer
                    Return Char.Parse("N")
                Case DbfColumnType.Logical
                    Return Char.Parse("L")
                Case DbfColumnType.Number
                    Return Char.Parse("N")
                Case Else
                    Throw New Exception("Unknown column type " & columnType.ToString & ".")
            End Select
        End Function

        ''' <summary>
        ''' Converts a string representation of a .NET type to an equivalent DbfColumnType
        ''' </summary>
        ''' <param name="dataType">The name of the .NET type to convert</param>
        ''' <returns>Returns the compatible DbfColumnType</returns>
        Private Function GetDbfColumnType(ByVal dataType As String) As DbfColumnType
            Select Case dataType
                Case "System.String"
                    Return DbfColumnType.Character
                Case "System.Int32", "System.Byte", "System.Int16"
                    Return DbfColumnType.Integer
                Case "System.DateTime"
                    Return DbfColumnType.Date
                Case "System.Boolean"
                    Return DbfColumnType.Logical
                Case "System.Decimal", "System.Double", "System.Single"
                    Return DbfColumnType.Number
                Case Else
                    Throw New ArgumentException("Unknown data type " & dataType & ".")
            End Select
        End Function

        Private Sub InitDbfSchema()
            Me.mDbfColumns = New Collection(Of DbfColumn)

            For Each col As DataWriterColumn In Me.Columns
                Dim dbfCol As New DbfColumn
                dbfCol.Name = col.ShortName
                dbfCol.ColumnType = Me.GetDbfColumnType(col.DataType)
                dbfCol.Ordinal = col.Ordinal
                dbfCol.IsMasterColumn = col.IsMasterColumn
                dbfCol.IgnoreColumn = col.IgnoreColumn
                Select Case dbfCol.ColumnType
                    Case DbfColumnType.Character
                        dbfCol.Length = col.Size
                        dbfCol.DecimalCount = 0
                    Case DbfColumnType.Date
                        dbfCol.Length = 8
                        dbfCol.DecimalCount = 0
                    Case DbfColumnType.Integer
                        dbfCol.Length = 11
                        dbfCol.DecimalCount = 0
                    Case DbfColumnType.Logical
                        dbfCol.Length = 1
                        dbfCol.DecimalCount = 0
                    Case DbfColumnType.Number
                        dbfCol.Length = 20
                        dbfCol.DecimalCount = 5
                    Case Else
                        Throw New Exception("Unrecognized data type " & dbfCol.ColumnType.ToString & ".")
                End Select

                Me.mDbfColumns.Add(dbfCol)
            Next
        End Sub
#End Region

    End Class
End Namespace