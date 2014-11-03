Imports Nrc.QualiSys.Library.DataProvider

Namespace Navigation

    <DebuggerDisplay("{Name} ({Id})")> _
    Public Class StudyNavNode
        Inherits NavigationNode

#Region " Private Fields "

        Private mId As Integer
        Private mName As String
        Private mIsActive As Boolean

        Private mSurveys As New NavigationNodeList(Of SurveyNavNode)
        Private mClient As ClientNavNode

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
                Return Client.NavigationTree
            End Get
        End Property

        Public Overrides ReadOnly Property NodeType() As NavigationNodeType
            Get
                Return NavigationNodeType.Study
            End Get
        End Property

        Public Overrides ReadOnly Property Nodes() As NavigationNodeList
            Get
                Return Surveys
            End Get
        End Property

        Public ReadOnly Property Surveys() As NavigationNodeList(Of SurveyNavNode)
            Get
                Return mSurveys
            End Get
        End Property

        Public ReadOnly Property Client() As ClientNavNode
            Get
                Return mClient
            End Get
        End Property

        Public ReadOnly Property ClientGroup() As ClientGroupNavNode
            Get
                Return Client.ClientGroup
            End Get
        End Property

#End Region

#Region " Constructors "

        Public Sub New(ByVal clnt As ClientNavNode)

            mClient = clnt

        End Sub

#End Region

#Region " Public Methods "

        Public Function GetStudy() As Library.Study

            Return Library.Study.GetStudy(mId)

        End Function

        Public Function AllowDelete() As Boolean

            Return StudyProvider.Instance.AllowDelete(mId)

        End Function

        Public Sub Refresh()

            Dim stdy As Library.Study = GetStudy()
            mName = stdy.Name
            IsActive = stdy.IsActive

        End Sub
#End Region

    End Class

End Namespace