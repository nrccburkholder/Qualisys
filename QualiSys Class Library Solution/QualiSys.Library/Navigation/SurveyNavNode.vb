Imports Nrc.QualiSys.Library.DataProvider

Namespace Navigation

    <DebuggerDisplay("{Name} ({Id})")> _
    Public Class SurveyNavNode
        Inherits NavigationNode

#Region " Private Fields "

        Private mId As Integer
        Private mName As String
        Private mIsActive As Boolean
        Private mIsValidated As Boolean
        Private mSurveyType As SurveyTypes

        Private mChildNodes As New NavigationNodeList
        Private mStudy As StudyNavNode

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

        Public Property IsValidated() As Boolean
            Get
                Return mIsValidated
            End Get
            Set(ByVal value As Boolean)
                mIsValidated = value
            End Set
        End Property

        Public Property SurveyType() As SurveyTypes
            Get
                Return mSurveyType
            End Get
            Set(ByVal value As SurveyTypes)
                mSurveyType = value
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
                Return Study.Client.NavigationTree
            End Get
        End Property

        Public Overrides ReadOnly Property NodeType() As NavigationNodeType
            Get
                Return NavigationNodeType.Survey
            End Get
        End Property

        Public Overrides ReadOnly Property Nodes() As NavigationNodeList
            Get
                Return mChildNodes
            End Get
        End Property

        Public ReadOnly Property Study() As StudyNavNode
            Get
                Return mStudy
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

        Public Sub New(ByVal stdy As StudyNavNode)

            mStudy = stdy

        End Sub
#End Region

#Region " Public Methods "

        Public Function GetSurvey() As Library.Survey

            Return Library.Survey.Get(mId)

        End Function

        Public Function AllowDelete() As Boolean

            Return SurveyProvider.Instance.AllowDelete(mId)

        End Function

        Public Sub Refresh()

            Dim srvy As Library.Survey = GetSurvey()

            mName = srvy.Name
            mIsValidated = srvy.IsValidated
            mSurveyType = srvy.SurveyType
            IsActive = srvy.IsActive

        End Sub

#End Region

    End Class

End Namespace
