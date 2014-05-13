Namespace Data

    ''' <summary>
    ''' Represents a column in a DBF file that will be written using the DbfWriter class
    ''' </summary>
    Friend Class DbfColumn

#Region " Private Fields "
        Private Const COLUMN_MAX_LENGTH As Integer = 254
        Friend Const NAME_MAX_LENGTH As Integer = 10
        Private mName As String
        Private mColumnType As DbfColumnType
        Private mLength As Integer
        Private mDecimalCount As Integer
        Private mOrdinal As Integer
        Private mIsMasterColumn As Boolean
        Private mIgnoreColumn As Boolean
#End Region

#Region " Public Properties "
        ''' <summary>The name of the column</summary>
        Public Property Name() As String
            Get
                Return mName
            End Get
            Set(ByVal value As String)
                If value.Length > NAME_MAX_LENGTH Then
                    Throw New Exception("The column name '" & value & " ' cannot exceed " & NAME_MAX_LENGTH & " characters.")
                Else
                    mName = value
                End If
            End Set
        End Property

        ''' <summary>The data type of the column</summary>
        Public Property ColumnType() As DbfColumnType
            Get
                Return mColumnType
            End Get
            Set(ByVal value As DbfColumnType)
                mColumnType = value
            End Set
        End Property

        ''' <summary>The length, in bytes, of the column</summary>
        Public Property Length() As Integer
            Get
                Return mLength
            End Get
            Set(ByVal value As Integer)
                If value > COLUMN_MAX_LENGTH Then
                    Throw New Exception("The column length " & value.ToString & " is greater than the maximum allowed size of " & COLUMN_MAX_LENGTH & ".")
                Else
                    mLength = value
                End If
            End Set
        End Property

        ''' <summary>The number of decimals included in the column</summary>
        ''' <remarks>Applies only to numeric fields</remarks>
        Public Property DecimalCount() As Integer
            Get
                Return mDecimalCount
            End Get
            Set(ByVal value As Integer)
                mDecimalCount = value
            End Set
        End Property

        ''' <summary>The ordinal value of the column in the data source</summary>
        Public Property Ordinal() As Integer
            Get
                Return mOrdinal
            End Get
            Set(ByVal value As Integer)
                mOrdinal = value
            End Set
        End Property

        ''' <summary>Indicates if the column is a "Master Column" and should be 
        ''' repeated in every file created when the number of columns is greater 
        ''' than the DBF limit of 255</summary>
        Public Property IsMasterColumn() As Boolean
            Get
                Return mIsMasterColumn
            End Get
            Set(ByVal value As Boolean)
                mIsMasterColumn = value
            End Set
        End Property

        ''' <summary>Indicates that the column should not be output to the DBF file</summary>
        Public Property IgnoreColumn() As Boolean
            Get
                Return mIgnoreColumn
            End Get
            Set(ByVal value As Boolean)
                mIgnoreColumn = value
            End Set
        End Property
#End Region

    End Class
End Namespace


