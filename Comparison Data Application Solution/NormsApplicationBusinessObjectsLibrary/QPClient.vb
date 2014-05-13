Public Class QPClient

#Region "Private Members"
    Private mID As Integer
    Private mName As String

#End Region

#Region "Public Properties"
    Public Property ID() As Integer
        Get
            Return mID
        End Get
        Set(ByVal Value As Integer)
            mID = Value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mName
        End Get
        Set(ByVal Value As String)
            mName = Value
        End Set
    End Property
#End Region

#Region "Public Methods"
    Public Shared Function getAllClients() As QPClientCollection
        Dim ds As DataSet = DataAccess.GetAllClients
        Dim clientCollection As New QPClientCollection
        For Each row As DataRow In ds.Tables(0).Rows
            clientCollection.Add(getClientFromRow(row))
        Next
        Return clientCollection
    End Function

    Public Shared Function getClientFromRow(ByVal row As DataRow) As QPClient
        Dim client As New QPClient
        With client
            .mID = row("client_id")
            .mName = row("strclient_nm")
        End With
        Return client
    End Function
#End Region

End Class
