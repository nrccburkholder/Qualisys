Imports Nrc.QualiSys.Library.DataProvider

Namespace Navigation

    Public Class NavigationTree

#Region " Private Fields "

        Dim mClients As New NavigationNodeList(Of ClientNavNode)
        Dim mClientGroups As New NavigationNodeList(Of ClientGroupNavNode)

#End Region

#Region " Public Properties "

        Public ReadOnly Property Nodes() As NavigationNodeList
            Get
                If mClients.Count > 0 Then
                    Return Clients
                Else
                    Return ClientGroups
                End If
            End Get
        End Property

        Public ReadOnly Property Clients() As NavigationNodeList(Of ClientNavNode)
            Get
                Return mClients
            End Get
        End Property

        Public ReadOnly Property ClientGroups() As NavigationNodeList(Of ClientGroupNavNode)
            Get
                Return mClientGroups
            End Get
        End Property

#End Region

#Region " Constructors "

        Public Sub New()

        End Sub

#End Region

#Region " Public Methods "

        Public Shared Function GetByUser(ByVal userName As String, ByVal depth As InitialPopulationDepth, ByVal includeGroups As Boolean) As NavigationTree

            Return NavigationProvider.Instance.GetNavigationTreeByUser(userName, depth, includeGroups)

        End Function

#End Region

    End Class

End Namespace