Namespace Navigation

    <DebuggerDisplay("{Name} ({Id})")> _
    Public Class DataFileNavNode
        Inherits NavigationNode


#Region " Private Fields "

        Private mId As Integer
        Private mName As String
        Private mIsActive As Boolean

        Private mChildNodes As New NavigationNodeList
        Private mSuvery As SurveyNavNode

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

        Public Overrides Property IsActive() As Boolean
            Get
                Return mIsActive
            End Get
            Set(ByVal value As Boolean)
                mIsActive = value
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

#End Region

#Region " Public ReadOnly Properties "

        Public ReadOnly Property NavigationTree() As NavigationTree
            Get
                Return Survey.Study.Client.NavigationTree
            End Get
        End Property

        Public Overrides ReadOnly Property Nodes() As NavigationNodeList
            Get
                Return mChildNodes
            End Get
        End Property

        Public Overrides ReadOnly Property NodeType() As NavigationNodeType
            Get
                Return NavigationNodeType.DataFile
            End Get
        End Property

        Public ReadOnly Property Survey() As SurveyNavNode
            Get
                Return mSuvery
            End Get
        End Property

        Public ReadOnly Property Study() As StudyNavNode
            Get
                Return Survey.Study
            End Get
        End Property

        Public ReadOnly Property Client() As ClientNavNode
            Get
                Return Study.Client
            End Get
        End Property

        Public ReadOnly Property ClientGroup() As ClientGroupNavNode
            Get
                Return Client.ClientGroup
            End Get
        End Property
#End Region

#Region " Constructors "

        Public Sub New(ByVal survey As SurveyNavNode)

            mSuvery = survey

        End Sub
#End Region

    End Class
End Namespace

