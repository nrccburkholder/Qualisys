Imports NRC.Data

<AutoPopulate(), Serializable()> _
Public Class Client

    <SQLField("Client_id")> Private mClientId As Integer
    <SQLField("strClient_nm")> Private mClientName As String

    Public Property Id() As Integer
        Get
            Return mClientId
        End Get
        Set(ByVal Value As Integer)
            mClientId = Value
        End Set
    End Property

    Public Property Name() As String
        Get
            Return mClientName
        End Get
        Set(ByVal Value As String)
            mClientName = Value
        End Set
    End Property

    Public ReadOnly Property DisplayLabel() As String
        Get
            Return String.Format("{0} ({1})", mClientName.Trim, mClientId)
        End Get
    End Property

    Public Sub New()

    End Sub

End Class

<Serializable()> _
Public Class ClientCollection
    Inherits CollectionBase

    Default Public ReadOnly Property Item(ByVal index As Integer) As Client
        Get
            Return DirectCast(MyBase.List(index), Client)
        End Get
    End Property

    Public Function Add(ByVal c As Client) As Integer
        Return MyBase.List.Add(c)
    End Function

    Public Shared Function GetClients() As ClientCollection
        Dim rdr As IDataReader = DAL.SelectClientList
        Dim clients As IList
        clients = New ClientCollection
        Return DirectCast(Populator.FillCollection(rdr, GetType(Client), clients), ClientCollection)
    End Function

End Class