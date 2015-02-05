Imports Nrc.QualiSys.Library.DataProvider

Namespace Navigation

    <DebuggerDisplay("{Name} ({Id})")> _
    Public Class ClientGroupNavNode
        Inherits NavigationNode

#Region " Private Members "

        Private mId As Integer
        Private mName As String
        Private mIsActive As Boolean

        Private mClients As New NavigationNodeList(Of ClientNavNode)
        Private mNavigationTree As NavigationTree

#End Region

#Region " Public Properties "

        Public Overrides Property Id() As Integer
            Get
                Return mId
            End Get
            Set(ByVal value As Integer)
                mId = value
            End Set
        End Property

        Public Overrides Property Name() As String
            Get
                Return mName
            End Get
            Set(ByVal value As String)
                mName = value
            End Set
        End Property

        Public Overrides Property IsActive() As Boolean
            Get
                Return mIsActive
            End Get
            Set(ByVal value As Boolean)
                mIsActive = value
            End Set
        End Property

#End Region

#Region " Public ReadOnly Properties "

        Public ReadOnly Property NavigationTree() As NavigationTree
            Get
                Return mNavigationTree
            End Get
        End Property

        Public Overrides ReadOnly Property NodeType() As NavigationNodeType
            Get
                Return NavigationNodeType.ClientGroup
            End Get
        End Property

        Public Overrides ReadOnly Property Nodes() As NavigationNodeList
            Get
                Return Clients
            End Get
        End Property

        Public ReadOnly Property Clients() As NavigationNodeList(Of ClientNavNode)
            Get
                Return mClients
            End Get
        End Property

#End Region

#Region " Constructors "

        Public Sub New(ByVal navTree As NavigationTree)

            mNavigationTree = navTree

        End Sub

#End Region

#Region " Public Methods "

        Public Function GetClientGroup() As Library.ClientGroup

            Return Library.ClientGroup.GetClientGroup(mId)

        End Function

        Public Function AllowDelete() As Boolean

            Return ClientGroupProvider.Instance.AllowDelete(mId)

        End Function

        Public Sub Refresh()

            Dim group As Library.ClientGroup = GetClientGroup()

            Name = group.Name
            IsActive = group.IsActive

        End Sub

#End Region

    End Class

End Namespace
