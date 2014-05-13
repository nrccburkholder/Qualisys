Imports System.Data.SqlClient

Namespace Data
    ''' <summary>
    ''' This is a DataReader that 'fixes' any null values before
    ''' they are returned to our business code.
    ''' </summary>
    Public Class SafeDataReader
        Implements IDataReader

        Private mDataReader As IDataReader
        'Private mIndex As Integer = -1
        'Private mOrdinals As New System.Collections.Hashtable

        ''' <summary>
        ''' Initializes the SafeDataReader object to use data from
        ''' the provided DataReader object.
        ''' </summary>
        ''' <param name="DataReader">The source DataReader object containing the data.</param>
        Public Sub New(ByVal DataReader As IDataReader)
            mDataReader = DataReader
        End Sub

#Region " Typed ""Get"" Methods "

#Region " GetString "
        ''' <summary>
        ''' Gets a string value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns empty string for null.
        ''' </remarks>
        Public Function GetString(ByVal i As Integer) As String Implements IDataReader.GetString
            Return GetString(i, "")
        End Function
        ''' <summary>
        ''' Gets a string value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns empty string for null.
        ''' </remarks>
        Public Function GetString(ByVal i As Integer, ByVal nullString As String) As String
            If mDataReader.IsDBNull(i) Then
                Return nullString
            Else
                Return mDataReader.GetString(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a string value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns "" for null.
        ''' </remarks>
        Public Function GetString(ByVal name As String) As String
            Return Me.GetString(name, "")
        End Function
        ''' <summary>
        ''' Gets a string value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns "" for null.
        ''' </remarks>
        Public Function GetString(ByVal name As String, ByVal nullString As String) As String
            Return Me.GetString(Me.GetOrdinal(name), nullString)
        End Function
#End Region

#Region " GetInt32 "
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetInt32(ByVal i As Integer) As Integer Implements IDataReader.GetInt32
            GetInt32(i, 0)
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        Public Function GetInt32(ByVal i As Integer, ByVal nullValue As Integer) As Integer
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetInt32(i)
            End If
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetInt32(ByVal name As String) As Integer
            Return Me.GetInt32(name)
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetInt32(ByVal name As String, ByVal nullValue As Integer) As Integer
            Return Me.GetInt32(Me.GetOrdinal(name), nullValue)
        End Function

        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetInteger(ByVal i As Integer) As Integer
            GetInteger(i, 0)
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        Public Function GetInteger(ByVal i As Integer, ByVal nullValue As Integer) As Integer
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetInt32(i)
            End If
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetInteger(ByVal name As String) As Integer
            Return Me.GetInteger(name, 0)
        End Function
        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        Public Function GetInteger(ByVal name As String, ByVal nullValue As Integer) As Integer
            Return Me.GetInteger(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#Region " GetDouble "
        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetDouble(ByVal i As Integer) As Double Implements IDataReader.GetDouble
            Return GetDouble(i, 0)
        End Function
        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        Public Function GetDouble(ByVal i As Integer, ByVal nullValue As Double) As Double
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetDouble(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns 0 for null.
        ''' </remarks>
        Public Function GetDouble(ByVal name As String) As Double
            Return Me.GetDouble(name)
        End Function
        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        Public Function GetDouble(ByVal name As String, ByVal nullValue As Double) As Double
            Return Me.GetDouble(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#Region " GetGuid "
        ''' <summary>
        ''' Gets a Guid value from the datareader.
        ''' </summary>
        Public Function GetGuid(ByVal i As Integer) As Guid Implements IDataReader.GetGuid
            If mDataReader.IsDBNull(i) Then
                Return NullGuid
            Else
                Return mDataReader.GetGuid(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a Guid value from the datareader.
        ''' </summary>
        Public Function GetGuid(ByVal Name As String) As Guid
            Return Me.GetGuid(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetBoolean "
        ''' <summary>
        ''' Gets a boolean value from the datareader.
        ''' </summary>
        Public Function GetBoolean(ByVal i As Integer) As Boolean Implements System.Data.IDataReader.GetBoolean
            If mDataReader.IsDBNull(i) Then
                Return False
            Else
                Return mDataReader.GetBoolean(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a boolean value from the datareader.
        ''' </summary>
        Public Function GetBoolean(ByVal Name As String) As Boolean
            Return Me.GetBoolean(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetByte "
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetByte(ByVal i As Integer) As Byte Implements System.Data.IDataReader.GetByte
            Return GetByte(i, CType(0, Byte))
        End Function
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetByte(ByVal i As Integer, ByVal nullValue As Byte) As Byte
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetByte(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetByte(ByVal name As String) As Byte
            Return Me.GetByte(name, CType(0, Byte))
        End Function
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetByte(ByVal name As String, ByVal nullValue As Byte) As Byte
            Return Me.GetByte(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#Region " GetBytes "
        ''' <summary>
        ''' Invokes the GetBytes method of the underlying datareader.
        ''' </summary>
        Public Function GetBytes(ByVal name As String) As Byte()
            Return GetBytes(GetOrdinal(name))
        End Function
        ''' <summary>
        ''' Invokes the GetBytes method of the underlying datareader.
        ''' </summary>
        Public Function GetBytes(ByVal i As Integer) As Byte()
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return CType(mDataReader(i), Byte())
            End If
        End Function
        ''' <summary>
        ''' Invokes the GetBytes method of the underlying datareader.
        ''' </summary>
        Public Function GetBytes(ByVal i As Integer, ByVal fieldOffset As Long, ByVal buffer() As Byte, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataReader.GetBytes
            If mDataReader.IsDBNull(i) Then
                Return 0
            Else
                Return mDataReader.GetBytes(i, fieldOffset, buffer, bufferoffset, length)
            End If
        End Function

        ''' <summary>
        ''' Invokes the GetBytes method of the underlying datareader.
        ''' </summary>
        Public Function GetBytes(ByVal Name As String, ByVal fieldOffset As Long, ByVal buffer() As Byte, ByVal bufferoffset As Integer, ByVal length As Integer) As Long
            Return Me.GetBytes(Me.GetOrdinal(Name), fieldOffset, buffer, bufferoffset, length)
        End Function
#End Region

#Region " GetChar "
        ''' <summary>
        ''' Gets a char value from the datareader.
        ''' </summary>
        Public Function GetChar(ByVal i As Integer) As Char Implements System.Data.IDataReader.GetChar
            If mDataReader.IsDBNull(i) Then
                Return NullChar
            Else
                Return mDataReader.GetChar(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a char value from the datareader.
        ''' </summary>
        Public Function GetChar(ByVal Name As String) As Char
            Return Me.GetChar(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetChars "
        ''' <summary>
        ''' Invokes the GetChars method of the underlying datareader.
        ''' </summary>
        Public Function GetChars(ByVal i As Integer, ByVal fieldoffset As Long, ByVal buffer() As Char, ByVal bufferoffset As Integer, ByVal length As Integer) As Long Implements System.Data.IDataReader.GetChars
            If mDataReader.IsDBNull(i) Then
                Return 0
            Else
                Return mDataReader.GetChars(i, fieldoffset, buffer, bufferoffset, length)
            End If
        End Function

        ''' <summary>
        ''' Invokes the GetChars method of the underlying datareader.
        ''' </summary>
        Public Function GetChars(ByVal Name As String, ByVal fieldoffset As Long, ByVal buffer() As Char, ByVal bufferoffset As Integer, ByVal length As Integer) As Long
            Return Me.GetChars(Me.GetOrdinal(Name), fieldoffset, buffer, bufferoffset, length)
        End Function
#End Region

#Region " GetDate "
        ''' <summary>
        ''' Gets a date value from the datareader.
        ''' </summary>
        Public Function GetDate(ByVal i As Integer) As Date Implements System.Data.IDataReader.GetDateTime
            If mDataReader.IsDBNull(i) Then
                Return NullDate
            Else
                Return mDataReader.GetDateTime(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a date value from the datareader.
        ''' </summary>
        Public Function GetDate(ByVal Name As String) As Date
            Return Me.GetDate(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetDecimal "
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetDecimal(ByVal i As Integer) As Decimal Implements System.Data.IDataReader.GetDecimal
            Return GetDecimal(i, 0)
        End Function
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetDecimal(ByVal i As Integer, ByVal nullValue As Decimal) As Decimal
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetDecimal(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetDecimal(ByVal name As String) As Decimal
            Return Me.GetDecimal(name, 0)
        End Function
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetDecimal(ByVal name As String, ByVal nullValue As Decimal) As Decimal
            Return Me.GetDecimal(Me.GetOrdinal(name), nullValue)
        End Function

#End Region

#Region " GetFloat "
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetFloat(ByVal i As Integer) As Single Implements System.Data.IDataReader.GetFloat
            Return GetFloat(i, 0)
        End Function
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetFloat(ByVal i As Integer, ByVal nullValue As Single) As Single
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetFloat(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetFloat(ByVal name As String) As Single
            Return Me.GetFloat(name, 0)
        End Function
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetFloat(ByVal name As String, ByVal nullValue As Single) As Single
            Return Me.GetFloat(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#Region " GetInt16 "
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetInt16(ByVal i As Integer) As Short Implements System.Data.IDataReader.GetInt16
            Return GetInt16(i, CType(0, Short))
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetInt16(ByVal i As Integer, ByVal nullValue As Short) As Short
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetInt16(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetInt16(ByVal name As String) As Short
            Return Me.GetInt16(name, CType(0, Short))
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetInt16(ByVal name As String, ByVal nullValue As Short) As Short
            Return Me.GetInt16(Me.GetOrdinal(name), nullValue)
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetShort(ByVal i As Integer) As Short
            Return GetShort(i, CType(0, Short))
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetShort(ByVal i As Integer, ByVal nullValue As Short) As Short
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetInt16(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetShort(ByVal name As String) As Short
            Return Me.GetShort(name, CType(0, Short))
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetShort(ByVal name As String, ByVal nullValue As Short) As Short
            Return Me.GetShort(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#Region " GetInt64 "
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetInt64(ByVal i As Integer) As Long Implements System.Data.IDataReader.GetInt64
            Return GetInt64(i, 0)
        End Function
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetInt64(ByVal i As Integer, ByVal nullValue As Long) As Long
            If mDataReader.IsDBNull(i) Then
                Return nullValue
            Else
                Return mDataReader.GetInt64(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetInt64(ByVal name As String) As Long
            Return Me.GetInt64(name, 0)
        End Function
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetInt64(ByVal name As String, ByVal nullValue As Long) As Long
            Return Me.GetInt64(Me.GetOrdinal(name), nullValue)
        End Function
#End Region

#End Region

#Region " ""Get"" Nullable Methods "

#Region " GetInt32 "

        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        Public Function GetNullableInteger(ByVal i As Integer) As Nullable(Of Integer)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetInt32(i)
            End If
        End Function

        ''' <summary>
        ''' Gets an integer from the datareader.
        ''' </summary>
        Public Function GetNullableInteger(ByVal name As String) As Nullable(Of Integer)
            Return Me.GetNullableInteger(Me.GetOrdinal(name))
        End Function
#End Region

#Region " GetDouble "
        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        Public Function GetNullableDouble(ByVal i As Integer) As Nullable(Of Double)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetDouble(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a double from the datareader.
        ''' </summary>
        Public Function GetNullableDouble(ByVal name As String) As Nullable(Of Double)
            Return Me.GetNullableDouble(Me.GetOrdinal(name))
        End Function
#End Region

#Region " GetBoolean "
        ''' <summary>
        ''' Gets a boolean value from the datareader.
        ''' </summary>
        Public Function GetNullableBoolean(ByVal i As Integer) As Nullable(Of Boolean)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetBoolean(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a boolean value from the datareader.
        ''' </summary>
        Public Function GetNullableBoolean(ByVal Name As String) As Nullable(Of Boolean)
            Return Me.GetNullableBoolean(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetByte "
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetNullableByte(ByVal i As Integer) As Nullable(Of Byte)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetByte(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a byte value from the datareader.
        ''' </summary>
        Public Function GetNullableByte(ByVal name As String) As Nullable(Of Byte)
            Return Me.GetNullableByte(Me.GetOrdinal(name))
        End Function
#End Region

#Region " GetChar "
        ''' <summary>
        ''' Gets a char value from the datareader.
        ''' </summary>
        Public Function GetNullableChar(ByVal i As Integer) As Nullable(Of Char)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetChar(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a char value from the datareader.
        ''' </summary>
        Public Function GetNullableChar(ByVal Name As String) As Nullable(Of Char)
            Return Me.GetNullableChar(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetDate "
        ''' <summary>
        ''' Gets a date value from the datareader.
        ''' </summary>
        Public Function GetNullableDate(ByVal i As Integer) As Nullable(Of Date)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetDateTime(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a date value from the datareader.
        ''' </summary>
        Public Function GetNullableDate(ByVal Name As String) As Nullable(Of Date)
            Return Me.GetNullableDate(Me.GetOrdinal(Name))
        End Function
#End Region

#Region " GetDecimal "
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetNullableDecimal(ByVal i As Integer) As Nullable(Of Decimal)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetDecimal(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a decimal value from the datareader.
        ''' </summary>
        Public Function GetNullableDecimal(ByVal name As String) As Nullable(Of Decimal)
            Return Me.GetNullableDecimal(Me.GetOrdinal(name))
        End Function

#End Region

#Region " GetFloat "
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetNullableFloat(ByVal i As Integer) As Nullable(Of Single)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetFloat(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Single value from the datareader.
        ''' </summary>
        Public Function GetNullableFloat(ByVal name As String) As Nullable(Of Single)
            Return Me.GetNullableFloat(Me.GetOrdinal(name))
        End Function
#End Region

#Region " GetInt16 "
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetNullableInt16(ByVal i As Integer) As Nullable(Of Short)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetInt16(i)
            End If
        End Function
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetNullableInt16(ByVal name As String) As Nullable(Of Short)
            Return Me.GetNullableInt16(Me.GetOrdinal(name))
        End Function

        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetNullableShort(ByVal i As Integer) As Nullable(Of Short)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetInt16(i)
            End If
        End Function
    
        ''' <summary>
        ''' Gets a Short value from the datareader.
        ''' </summary>
        Public Function GetNullableShort(ByVal name As String) As Nullable(Of Short)
            Return Me.GetNullableShort(Me.GetOrdinal(name))
        End Function
#End Region

#Region " GetInt64 "
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetNullableInt64(ByVal i As Integer) As Nullable(Of Long)
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetInt64(i)
            End If
        End Function
      
        ''' <summary>
        ''' Gets a Long value from the datareader.
        ''' </summary>
        Public Function GetNullableInt64(ByVal name As String) As Nullable(Of Long)
            Return Me.GetNullableInt64(Me.GetOrdinal(name))
        End Function
#End Region

#End Region

#Region " GetEnum "

        Public Function GetEnum(Of T)(ByVal i As Integer) As T
            Dim val As T = CType(mDataReader.GetValue(i), T)
            If Not System.Enum.IsDefined(GetType(T), val) Then
                Throw New InvalidCastException("Value cannot be converted to an enum of type " & GetType(T).ToString)
            End If

            Return val
        End Function

        Public Function GetEnum(Of T)(ByVal name As String) As T
            Return Me.GetEnum(Of T)(Me.GetOrdinal(name))
        End Function

#End Region

#Region " Null Definitions "
        Public Shared ReadOnly Property NullDate() As Date
            Get
                Return Date.MinValue
            End Get
        End Property
        Public Shared ReadOnly Property NullGuid() As Guid
            Get
                Return Guid.Empty
            End Get
        End Property
        Public Shared ReadOnly Property NullChar() As Char
            Get
                Return Char.MinValue
            End Get
        End Property
        Public Shared Function IsNull(ByVal dataValue As Date) As Boolean
            Return dataValue.Equals(NullDate)
        End Function
        Public Shared Function IsNull(ByVal datavalue As Guid) As Boolean
            Return datavalue.Equals(NullGuid)
        End Function
        Public Shared Function IsNull(ByVal datavalue As Char) As Boolean
            Return datavalue.Equals(NullChar)
        End Function
#End Region

#Region " ToDBValue Methods "
        Public Shared Function ToDBValue(ByVal dataValue As Date) As Object
            If IsNull(dataValue) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Guid) As Object
            If IsNull(dataValue) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Char) As Object
            If IsNull(dataValue) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Integer, ByVal nullValue As Integer) As Object
            If dataValue.Equals(nullValue) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As String, ByVal nullValue As String) As Object
            If dataValue.Equals(nullValue) Then
                Return DBNull.Value
            Else
                Return dataValue
            End If
        End Function

        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Char)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Date)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Integer)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Double)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Boolean)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Byte)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Decimal)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Single)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Int16)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
        Public Shared Function ToDBValue(ByVal dataValue As Nullable(Of Int64)) As Object
            If dataValue.HasValue Then
                Return dataValue
            Else
                Return DBNull.Value
            End If
        End Function
#End Region

        ''' <summary>
        ''' Gets a value of type <see cref="System.Object" /> from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns Nothing for null.
        ''' </remarks>
        Public Function GetValue(ByVal i As Integer) As Object Implements IDataReader.GetValue
            If mDataReader.IsDBNull(i) Then
                Return Nothing
            Else
                Return mDataReader.GetValue(i)
            End If
        End Function

        ''' <summary>
        ''' Gets a value of type <see cref="System.Object" /> from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns Nothing for null.
        ''' </remarks>
        Public Function GetValue(ByVal name As String) As Object
            Return Me.GetValue(Me.GetOrdinal(name))
        End Function


        ''' <summary>
        ''' Reads the next row of data from the datareader.
        ''' </summary>
        Public Function Read() As Boolean Implements IDataReader.Read
            Return mDataReader.Read
        End Function

        ''' <summary>
        ''' Moves to the next result set in the datareader.
        ''' </summary>
        Public Function NextResult() As Boolean Implements IDataReader.NextResult
            Return mDataReader.NextResult()
        End Function

        ''' <summary>
        ''' Closes the datareader.
        ''' </summary>
        Public Sub Close() Implements IDataReader.Close
            mDataReader.Close()
        End Sub

        ''' <summary>
        ''' Returns the depth property value from the datareader.
        ''' </summary>
        Public ReadOnly Property Depth() As Integer Implements System.Data.IDataReader.Depth
            Get
                Return mDataReader.Depth
            End Get
        End Property

        ''' <summary>
        ''' Calls the Dispose method on the underlying datareader.
        ''' </summary>
        Public Sub Dispose() Implements System.IDisposable.Dispose
            mDataReader.Dispose()
        End Sub

        ''' <summary>
        ''' Returns the FieldCount property from the datareader.
        ''' </summary>
        Public ReadOnly Property FieldCount() As Integer Implements System.Data.IDataReader.FieldCount
            Get
                Return mDataReader.FieldCount
            End Get
        End Property

        ''' <summary>
        ''' Invokes the GetData method of the underlying datareader.
        ''' </summary>
        Public Function GetData(ByVal i As Integer) As System.Data.IDataReader Implements System.Data.IDataReader.GetData
            Return mDataReader.GetData(i)
        End Function

        ''' <summary>
        ''' Invokes the GetData method of the underlying datareader.
        ''' </summary>
        Public Function GetData(ByVal name As String) As System.Data.IDataReader
            Return Me.GetData(Me.GetOrdinal(name))
        End Function

        ''' <summary>
        ''' Invokes the GetDataTypeName method of the underlying datareader.
        ''' </summary>
        Public Function GetDataTypeName(ByVal i As Integer) As String Implements System.Data.IDataReader.GetDataTypeName
            Return mDataReader.GetDataTypeName(i)
        End Function

        ''' <summary>
        ''' Invokes the GetDataTypeName method of the underlying datareader.
        ''' </summary>
        Public Function GetDataTypeName(ByVal name As String) As String
            Return Me.GetDataTypeName(Me.GetOrdinal(name))
        End Function

        ''' <summary>
        ''' Invokes the GetFieldType method of the underlying datareader.
        ''' </summary>
        Public Function GetFieldType(ByVal i As Integer) As System.Type Implements System.Data.IDataReader.GetFieldType
            Return mDataReader.GetFieldType(i)
        End Function

        ''' <summary>
        ''' Invokes the GetFieldType method of the underlying datareader.
        ''' </summary>
        Public Function GetFieldType(ByVal name As String) As System.Type
            Return Me.GetFieldType(Me.GetOrdinal(name))
        End Function

        ''' <summary>
        ''' Invokes the GetName method of the underlying datareader.
        ''' </summary>
        Public Function GetName(ByVal i As Integer) As String Implements System.Data.IDataReader.GetName
            Return mDataReader.GetName(i)
        End Function

        ''' <summary>
        ''' Gets an ordinal value from the datareader.
        ''' </summary>
        Public Function GetOrdinal(ByVal name As String) As Integer Implements System.Data.IDataReader.GetOrdinal
            Return mDataReader.GetOrdinal(name)
        End Function

        ''' <summary>
        ''' Invokes the GetSchemaTable method of the underlying datareader.
        ''' </summary>
        Public Function GetSchemaTable() As System.Data.DataTable Implements System.Data.IDataReader.GetSchemaTable
            Return mDataReader.GetSchemaTable
        End Function

        ''' <summary>
        ''' Invokes the GetValues method of the underlying datareader.
        ''' </summary>
        Public Function GetValues(ByVal values() As Object) As Integer Implements System.Data.IDataReader.GetValues
            Return mDataReader.GetValues(values)
        End Function

        ''' <summary>
        ''' Returns the IsClosed property value from the datareader.
        ''' </summary>
        Public ReadOnly Property IsClosed() As Boolean Implements System.Data.IDataReader.IsClosed
            Get
                Return mDataReader.IsClosed
            End Get
        End Property

        ''' <summary>
        ''' Invokes the IsDBNull method of the underlying datareader.
        ''' </summary>
        Public Function IsDBNull(ByVal i As Integer) As Boolean Implements System.Data.IDataReader.IsDBNull
            Return mDataReader.IsDBNull(i)
        End Function

        ''' <summary>
        ''' Invokes the IsDBNull method of the underlying datareader.
        ''' </summary>
        Public Function IsDBNull(ByVal name As String) As Boolean
            Return Me.IsDBNull(Me.GetOrdinal(name))
        End Function

        ''' <summary>
        ''' Returns a value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns Nothing if the value is null.
        ''' </remarks>
        Default Public Overloads ReadOnly Property Item(ByVal name As String) As Object Implements System.Data.IDataReader.Item
            Get
                Dim value As Object = mDataReader.Item(name)
                If DBNull.Value.Equals(value) Then
                    Return Nothing
                Else
                    Return value
                End If
            End Get
        End Property

        ''' <summary>
        ''' Returns a value from the datareader.
        ''' </summary>
        ''' <remarks>
        ''' Returns Nothing if the value is null.
        ''' </remarks>
        Default Public Overloads ReadOnly Property Item(ByVal i As Integer) As Object Implements System.Data.IDataReader.Item
            Get
                If mDataReader.IsDBNull(i) Then
                    Return Nothing
                Else
                    Return mDataReader.Item(i)
                End If
            End Get
        End Property

        ''' <summary>
        ''' Returns the RecordsAffected property value from the underlying datareader.
        ''' </summary>
        Public ReadOnly Property RecordsAffected() As Integer Implements System.Data.IDataReader.RecordsAffected
            Get
                Return mDataReader.RecordsAffected
            End Get
        End Property

    End Class

End Namespace
