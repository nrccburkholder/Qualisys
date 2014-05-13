Namespace Data
    Public Class DataWriterColumn

#Region " Private Members "
        Private mName As String
        Private mShortName As String
        Private mSize As Integer
        Private mDataType As String
        Private mOrdinal As Integer
        Private mIsMasterColumn As Boolean
        Private mIgnoreColumn As Boolean
#End Region

#Region " Public Properties "
        Public Property Name() As String
            Get
                Return mName
            End Get
            Set(ByVal value As String)
                mName = value
            End Set
        End Property
        Public Property ShortName() As String
            Get
                Return mShortName
            End Get
            Set(ByVal value As String)
                mShortName = value
            End Set
        End Property
        Public Property Size() As Integer
            Get
                Return mSize
            End Get
            Set(ByVal value As Integer)
                mSize = value
            End Set
        End Property
        Public Property DataType() As String
            Get
                Return mDataType
            End Get
            Set(ByVal value As String)
                mDataType = value
            End Set
        End Property
        Public Property Ordinal() As Integer
            Get
                Return mOrdinal
            End Get
            Set(ByVal value As Integer)
                mOrdinal = value
            End Set
        End Property
        Public Property IsMasterColumn() As Boolean
            Get
                Return mIsMasterColumn
            End Get
            Set(ByVal value As Boolean)
                mIsMasterColumn = value
            End Set
        End Property
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
