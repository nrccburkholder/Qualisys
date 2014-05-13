'Used for review
Public Class ReviewColumn

#Region " Private Members "

    Private mTableName As String
    Private mOrdinal As Integer
    Private mColumnName As String

#End Region

#Region " Public Properties "

    Public Property TableName() As String
        Get
            Return mTableName
        End Get
        Set(ByVal Value As String)
            mTableName = Value
        End Set
    End Property

    Public Property Ordinal() As Integer
        Get
            Return mOrdinal
        End Get
        Set(ByVal Value As Integer)
            mOrdinal = Value
        End Set
    End Property

    Public Property ColumnName() As String
        Get
            Return mColumnName
        End Get
        Set(ByVal Value As String)
            mColumnName = Value
        End Set
    End Property

#End Region

#Region " Public Methods "

    Public Sub New()

    End Sub

    Public Sub New(ByVal tableName As String, _
                   ByVal ordinal As Integer, _
                   ByVal columnName As String)
        mTableName = tableName
        mOrdinal = ordinal
        mColumnName = columnName
    End Sub

    Public Sub New(ByVal ordinal As Integer, _
                   ByVal columnName As String)
        mOrdinal = ordinal
        mColumnName = columnName
    End Sub

#End Region

End Class