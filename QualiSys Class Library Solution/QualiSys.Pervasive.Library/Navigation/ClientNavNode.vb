Namespace Navigation

    <DebuggerDisplay("{Name} ({Id})")> _
    Public Class ClientNavNode
        Inherits NavigationNode

#Region " Private Members "

        Private mId As Integer
        Private mName As String
        Private mIsActive As Boolean
        Private mClientGroupID As Integer

        Private mStudies As New NavigationNodeList(Of StudyNavNode)
        Private mNavigationTree As NavigationTree
        Private mClientGroup As ClientGroupNavNode

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

        Public Property ClientGroupID() As Integer
            Get
                Return mClientGroupID
            End Get
            Set(ByVal value As Integer)
                mClientGroupID = value
            End Set
        End Property
#End Region

#Region " Public ReadOnly Properties "

        Public ReadOnly Property NavigationTree() As NavigationTree
            Get
                If mNavigationTree Is Nothing Then
                    Return mClientGroup.NavigationTree
                Else
                    Return mNavigationTree
                End If
            End Get
        End Property

        Public Overrides ReadOnly Property NodeType() As NavigationNodeType
            Get
                Return NavigationNodeType.Client
            End Get
        End Property

        Public Overrides ReadOnly Property Nodes() As NavigationNodeList
            Get
                Return Studies
            End Get
        End Property

        Public ReadOnly Property Studies() As NavigationNodeList(Of StudyNavNode)
            Get
                Return mStudies
            End Get
        End Property

        Public ReadOnly Property ClientGroup() As ClientGroupNavNode
            Get
                Return mClientGroup
            End Get
        End Property

#End Region

#Region " Constructors "

        Public Sub New(ByVal navTree As NavigationTree)

            mNavigationTree = navTree
            mClientGroup = Nothing

        End Sub

        Public Sub New(ByVal clntGroup As ClientGroupNavNode)

            mClientGroup = clntGroup
            mNavigationTree = Nothing

        End Sub

#End Region

        '#Region " Public Methods "

        '        Public Function GetClient() As Library.Client

        '            Return Library.Client.GetClient(mId)

        '        End Function

        '        Public Function AllowDelete() As Boolean

        '            Return ClientProvider.Instance.AllowDelete(mId)

        '        End Function

        '        Public Sub Refresh()

        '            Dim clnt As Library.Client = GetClient()

        '            Name = clnt.Name
        '            IsActive = clnt.IsActive
        '            mClientGroupID = clnt.ClientGroupID

        '        End Sub

        '#End Region

    End Class

End Namespace
