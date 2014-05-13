Public Interface IQuestionContent
    Property QuestionId() As Integer
    Property ContentSetGuid() As Guid
End Interface

<Serializable()> _
Public Class QuestionContent
    Implements IQuestionContent

#Region " Private Fields "
    Private mQuestionId As Integer
    Private mQuestionText As String
    Private mContentSetGuid As Guid

    Private mImportanceHtml As String = String.Empty
    Private mQuickCheckHtml As String = String.Empty
    Private mRecommendationsHtml As String = String.Empty
    Private mResourcesHtml As String = String.Empty

    Private mImportanceIsNew As Boolean
    Private mQuickCheckIsNew As Boolean
    Private mRecommendationsIsNew As Boolean
    Private mResourcesIsNew As Boolean

    Private mImportanceIsDirty As Boolean
    Private mQuickCheckIsDirty As Boolean
    Private mRecommendationsIsDirty As Boolean
    Private mResourcesIsDirty As Boolean
#End Region

#Region " Public Properties "
    Public Property ContentSetGuid() As Guid Implements IQuestionContent.ContentSetGuid
        Get
            Return mContentSetGuid
        End Get
        Set(ByVal value As Guid)
            mContentSetGuid = value
        End Set
    End Property
    Public Property QuestionId() As Integer Implements IQuestionContent.QuestionId
        Get
            Return mQuestionId
        End Get
        Private Set(ByVal value As Integer)
            mQuestionId = value
        End Set
    End Property
    Public Property QuestionText() As String
        Get
            Return mQuestionText
        End Get
        Set(ByVal value As String)
            mQuestionText = value
        End Set
    End Property


    Public Property ImportanceHtml() As String
        Get
            Return mImportanceHtml
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mImportanceHtml <> value Then
                mImportanceHtml = value
                mImportanceIsDirty = True
            End If
        End Set
    End Property
    Public Property QuickCheckHtml() As String
        Get
            Return mQuickCheckHtml
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mQuickCheckHtml <> value Then
                mQuickCheckHtml = value
                mQuickCheckIsDirty = True
            End If
        End Set
    End Property
    Public Property RecommendationsHtml() As String
        Get
            Return mRecommendationsHtml
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mRecommendationsHtml <> value Then
                mRecommendationsHtml = value
                mRecommendationsIsDirty = True
            End If
        End Set
    End Property
    Public Property ResourcesHtml() As String
        Get
            Return mResourcesHtml
        End Get
        Set(ByVal value As String)
            If value Is Nothing Then value = String.Empty
            If mResourcesHtml <> value Then
                mResourcesHtml = value
                mResourcesIsDirty = True
            End If
        End Set
    End Property

    Public Property ImportanceIsNew() As Boolean
        Get
            Return mImportanceIsNew
        End Get
        Set(ByVal value As Boolean)
            mImportanceIsNew = value
        End Set
    End Property
    Public Property QuickCheckIsNew() As Boolean
        Get
            Return mQuickCheckIsNew
        End Get
        Set(ByVal value As Boolean)
            mQuickCheckIsNew = value
        End Set
    End Property
    Public Property RecommendationsIsNew() As Boolean
        Get
            Return mRecommendationsIsNew
        End Get
        Set(ByVal value As Boolean)
            mRecommendationsIsNew = value
        End Set
    End Property
    Public Property ResourcesIsNew() As Boolean
        Get
            Return mResourcesIsNew
        End Get
        Set(ByVal value As Boolean)
            mResourcesIsNew = value
        End Set
    End Property

    Public ReadOnly Property ImportanceIsDirty() As Boolean
        Get
            Return mImportanceIsDirty
        End Get
    End Property
    Public ReadOnly Property QuickCheckIsDirty() As Boolean
        Get
            Return mQuickCheckIsDirty
        End Get
    End Property
    Public ReadOnly Property ReccomendationsIsDirty() As Boolean
        Get
            Return mRecommendationsIsDirty
        End Get
    End Property
    Public ReadOnly Property ResourcesIsDirty() As Boolean
        Get
            Return mResourcesIsDirty
        End Get
    End Property

    Public ReadOnly Property IsNewContentSet() As Boolean
        Get
            Return (mContentSetGuid = Guid.Empty)
        End Get
    End Property

#End Region

    Public Sub BeginPopulate()

    End Sub

    Public Sub EndPopulate()
        Me.mImportanceIsDirty = False
        Me.mQuickCheckIsDirty = False
        Me.mRecommendationsIsDirty = False
        Me.mResourcesIsDirty = False
    End Sub

    Public Shared Function GetByQuestionId(ByVal questionId As Integer) As QuestionContent
        Return DataProvider.Instance.SelectQuestionContentByQuestionId(questionId)
    End Function

    Public Sub Save(ByVal contentType As QuestionContentType)
        Dim html As String = ""
        Dim isNew As Boolean

        Select Case contentType
            Case QuestionContentType.QuestionImportance
                html = mImportanceHtml
                isNew = mImportanceIsNew
                mImportanceIsNew = False
            Case QuestionContentType.QuickCheck
                html = mQuickCheckHtml
                isNew = mQuickCheckIsNew
                mQuickCheckIsNew = False
            Case QuestionContentType.Recommendations
                html = mRecommendationsHtml
                isNew = mRecommendationsIsNew
                mRecommendationsIsNew = False
            Case QuestionContentType.Resources
                html = mResourcesHtml
                isNew = mResourcesIsNew
                mResourcesIsNew = False
        End Select

        If Me.IsNewContentSet Then
            Me.mContentSetGuid = Guid.NewGuid()
            DataProvider.Instance.InsertQuestionContent(mQuestionId, mContentSetGuid, contentType, html, isNew)
        Else
            DataProvider.Instance.UpdateQuestionContent(mContentSetGuid, contentType, html, isNew)
        End If
    End Sub


    Public Shared Sub RelateQuestionContent(ByVal sourceQuestionId As Integer, ByVal relatedQuestionId As Integer, ByVal useRelatedQuestionContent As Boolean)
        DataProvider.Instance.RelateQuestionContent(sourceQuestionId, relatedQuestionId, useRelatedQuestionContent)
    End Sub

    Public Shared Sub UnrelateQuestionContent(ByVal questionId As Integer)
        DataProvider.Instance.UnrelateQuestionContent(questionId)
    End Sub

    Public Shared Function GetRelatedQuestions(ByVal questionId As Integer) As DataTable
        Return DataProvider.Instance.SelectRelatedQuestions(questionId)
    End Function

End Class

