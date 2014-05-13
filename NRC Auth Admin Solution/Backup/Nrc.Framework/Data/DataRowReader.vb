Namespace Data

    ''' <summary>
    ''' This class implements an IDataReader that reads data from a set of DataRow objects from a DataTable
    ''' </summary>
    ''' <remarks>When reading directly from a DataTable the System.Data.DataTableReader should be sufficient
    ''' however, sometimes DataRows are accessed though DataTable Relationships such as the GetChildRows()
    ''' method that returns an array of DataRow objects.  In such a case it may still be disireable to read
    ''' the data though an IDataReader interface.  DataRowReader does exactly that.</remarks>
    Public Class DataRowReader
        Implements IDataReader

        ''' <summary>The index of the row that the reader is currently reading from</summary>
        Private mIndex As Integer = -1

        ''' <summary>The array of DataRows that the reader is reading from</summary>
        Private mRows() As DataRow

        ''' <summary>
        ''' Returns the DataRow object that the reader is currently reading from
        ''' </summary>
        Public ReadOnly Property CurrentRow() As DataRow
            Get
                If mRows IsNot Nothing Then
                    If mIndex > -1 AndAlso mIndex < mRows.Length Then
                        Return mRows(mIndex)
                    Else
                        Return Nothing
                    End If
                Else
                    Return Nothing
                End If
            End Get
        End Property

        ''' <summary>
        ''' Initializes the DataRowReader with a set of DataRow objects
        ''' </summary>
        ''' <param name="rows">The array of DataRow objects that the reader will read from</param>
        Public Sub New(ByVal rows() As DataRow)
            mRows = rows
        End Sub

        ''' <summary>
        ''' Initializes the DataRowReader with a collection of DataRow objects
        ''' </summary>
        ''' <param name="rows">The collection of DataRow objects that the reader will read from</param>
        Public Sub New(ByVal rows As DataRowCollection)
            Dim rowArray(rows.Count - 1) As DataRow
            rows.CopyTo(rowArray, 0)
            mRows = rowArray
        End Sub

        Public Sub Close() Implements System.Data.IDataReader.Close
            mRows = Nothing
            mIndex = -1
        End Sub

        Public ReadOnly Property Depth() As Integer Implements System.Data.IDataReader.Depth
            Get
                Throw New NotImplementedException
            End Get
        End Property

        Public Function GetSchemaTable() As System.Data.DataTable Implements System.Data.IDataReader.GetSchemaTable
            Throw New NotImplementedException
        End Function

        Public ReadOnly Property IsClosed() As Boolean Implements System.Data.IDataReader.IsClosed
            Get
                Return False
            End Get
        End Property

        Public Function NextResult() As Boolean Implements System.Data.IDataReader.NextResult
            Return False
        End Function

        Public Function Read() As Boolean Implements System.Data.IDataReader.Read
            If mIndex < mRows.Length - 1 Then
                mIndex += 1
                Return True
            Else
                Return False
            End If
        End Function

        Public ReadOnly Property RecordsAffected() As Integer Implements System.Data.IDataReader.RecordsAffected
            Get
                Return 0
            End Get
        End Property

        Public ReadOnly Property FieldCount() As Integer Implements System.Data.IDataRecord.FieldCount
            Get
                Return mRows(mIndex).ItemArray.Length
            End Get
        End Property

        Public Function GetBoolean(ByVal i As Integer) As Boolean Implements System.Data.IDataRecord.GetBoolean
            Me.ThrowIfNull(i)
            Return CType(Me.Item(i), Boolean)
        End Function

        Public Function GetByte(ByVal i As Integer) As Byte Implements System.Data.IDataRecord.GetByte
            Me.ThrowIfNull(i)
            Return Convert.ToByte(Me.Item(i))
        End Function

        Public Function GetBytes(ByVal i As Integer, ByVal fieldOffset As Long, ByVal buffer() As Byte, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataRecord.GetBytes
            'need to figure this one out still...should be easy
            Throw New NotImplementedException
        End Function

        Public Function GetChar(ByVal i As Integer) As Char Implements System.Data.IDataRecord.GetChar
            Me.ThrowIfNull(i)
            Return Convert.ToChar(Me.Item(i))
        End Function

        Public Function GetChars(ByVal i As Integer, ByVal fieldoffset As Long, ByVal buffer() As Char, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataRecord.GetChars
            'need to figure this one out still...should be easy
            Throw New NotImplementedException
        End Function

        Public Function GetData(ByVal i As Integer) As System.Data.IDataReader Implements System.Data.IDataRecord.GetData
            Throw New NotImplementedException
        End Function

        Public Function GetDataTypeName(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetDataTypeName
            Throw New NotImplementedException
        End Function

        Public Function GetDateTime(ByVal i As Integer) As Date Implements System.Data.IDataRecord.GetDateTime
            Me.ThrowIfNull(i)
            Return Convert.ToDateTime(Me.Item(i))
        End Function

        Public Function GetDecimal(ByVal i As Integer) As Decimal Implements System.Data.IDataRecord.GetDecimal
            Me.ThrowIfNull(i)
            Return Convert.ToDecimal(Me.Item(i))
        End Function

        Public Function GetDouble(ByVal i As Integer) As Double Implements System.Data.IDataRecord.GetDouble
            Me.ThrowIfNull(i)
            Return Convert.ToDouble(Me.Item(i))
        End Function

        Public Function GetFieldType(ByVal i As Integer) As System.Type Implements System.Data.IDataRecord.GetFieldType
            Return Me.Item(i).GetType
        End Function

        Public Function GetFloat(ByVal i As Integer) As Single Implements System.Data.IDataRecord.GetFloat
            Me.ThrowIfNull(i)
            Return Convert.ToSingle(Me.Item(i))
        End Function

        Public Function GetGuid(ByVal i As Integer) As System.Guid Implements System.Data.IDataRecord.GetGuid
            Me.ThrowIfNull(i)
            Return CType(Me.Item(i), Guid)
        End Function

        Public Function GetInt16(ByVal i As Integer) As Short Implements System.Data.IDataRecord.GetInt16
            Me.ThrowIfNull(i)
            Return Convert.ToInt16(Me.Item(i))
        End Function

        Public Function GetInt32(ByVal i As Integer) As Integer Implements System.Data.IDataRecord.GetInt32
            Me.ThrowIfNull(i)
            Return Convert.ToInt32(Me.Item(i))
        End Function

        Public Function GetInt64(ByVal i As Integer) As Long Implements System.Data.IDataRecord.GetInt64
            Me.ThrowIfNull(i)
            Return Convert.ToInt64(Me.Item(i))
        End Function

        Public Function GetName(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetName
            Return mRows(mIndex).Table.Columns(i).ColumnName
        End Function

        Public Function GetOrdinal(ByVal name As String) As Integer Implements System.Data.IDataRecord.GetOrdinal
            Return mRows(mIndex).Table.Columns(name).Ordinal
        End Function

        Public Function GetString(ByVal i As Integer) As String Implements System.Data.IDataRecord.GetString
            Me.ThrowIfNull(i)
            Return Convert.ToString(Me.Item(i))
        End Function

        Public Function GetValue(ByVal i As Integer) As Object Implements System.Data.IDataRecord.GetValue
            Me.ThrowIfNull(i)
            Return Me.Item(i)
        End Function

        Public Function GetValues(ByVal values() As Object) As Integer Implements System.Data.IDataRecord.GetValues
            Dim i As Integer = 0
            For i = 0 To Math.Min(values.Length - 1, Me.FieldCount - 1)
                values(i) = Me.Item(i)
            Next

            Return i
        End Function

        Public Function IsDBNull(ByVal i As Integer) As Boolean Implements System.Data.IDataRecord.IsDBNull
            Return (mRows(mIndex).Item(i) Is DBNull.Value)
        End Function

        Default Public Overloads ReadOnly Property Item(ByVal i As Integer) As Object Implements System.Data.IDataRecord.Item
            Get
                Return mRows(mIndex).Item(i)
            End Get
        End Property

        Default Public Overloads ReadOnly Property Item(ByVal name As String) As Object Implements System.Data.IDataRecord.Item
            Get
                Return mRows(mIndex).Item(name)
            End Get
        End Property

        Private disposedValue As Boolean = False        ' To detect redundant calls

        ' IDisposable
        Protected Overridable Sub Dispose(ByVal disposing As Boolean)
            If Not Me.disposedValue Then
                If disposing Then
                    ' TODO: free unmanaged resources when explicitly called
                End If

                ' TODO: free shared unmanaged resources
            End If
            Me.disposedValue = True
        End Sub

#Region " IDisposable Support "
        ' This code added by Visual Basic to correctly implement the disposable pattern.
        Public Sub Dispose() Implements IDisposable.Dispose
            ' Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(True)
            GC.SuppressFinalize(Me)
        End Sub
#End Region

        Private Sub ThrowIfNull(ByVal i As Integer)
            If IsDBNull(i) Then
                Throw New DataRowReaderNullValueException
            End If
        End Sub

    End Class

End Namespace
