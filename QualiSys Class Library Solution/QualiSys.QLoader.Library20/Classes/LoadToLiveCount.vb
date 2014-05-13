Friend Class LoadToLiveCount

#Region " Private Members "

    Private mTableName As String = String.Empty
    Private mQualiSysRecCount As Integer
    Private mDataMartRecCount As Integer
    Private mCatalystRecCount As Integer
    Private mUpdateFields As New List(Of String)

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property TableName() As String
        Get
            Return mTableName
        End Get
    End Property

    Public ReadOnly Property QualiSysRecCount() As Integer
        Get
            Return mQualiSysRecCount
        End Get
    End Property

    Public ReadOnly Property DataMartRecCount() As Integer
        Get
            Return mDataMartRecCount
        End Get
    End Property

    Public ReadOnly Property CatalystRecCount() As Integer
        Get
            Return mCatalystRecCount
        End Get
    End Property

    Public ReadOnly Property UpdateFields() As List(Of String)
        Get
            Return mUpdateFields
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal tableName As String, ByVal qualisysRecCount As Integer, ByVal datamartRecCount As Integer, ByVal catalystRecCount As Integer, ByVal updateFields As List(Of String))

        mTableName = tableName
        mQualiSysRecCount = qualisysRecCount
        mDataMartRecCount = datamartRecCount
        mCatalystRecCount = catalystRecCount
        mUpdateFields = updateFields

    End Sub

#End Region

End Class
