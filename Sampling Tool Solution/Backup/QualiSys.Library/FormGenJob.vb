Imports Nrc.QualiSys.Library.DataProvider

Public Class FormGenJob

#Region " Private Fields "
    Private mClientId As Integer
    Private mClientName As String
    Private mStudyId As Integer
    Private mStudyName As String
    Private mSurveyId As Integer
    Private mSurveyName As String
    Private mMailStepId As Integer
    Private mMailStepName As String
    Private mSurveyType As String
    Private mOriginalGenerationDate As Date
    Private mGenerationDate As Date
    Private mPriority As Integer
    Private mFormCount As Integer
    Private mIsFormGenReleased As Boolean

    Private mIsDirty As Boolean
#End Region

#Region " Public Properties "
    Public Property ClientId() As Integer
        Get
            Return mClientId
        End Get
        Friend Set(ByVal value As Integer)
            If mClientId <> value Then
                mClientId = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property ClientName() As String
        Get
            Return mClientName
        End Get
        Friend Set(ByVal value As String)
            If mClientName <> value Then
                mClientName = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property StudyId() As Integer
        Get
            Return mStudyId
        End Get
        Friend Set(ByVal value As Integer)
            If mStudyId <> value Then
                mStudyId = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property StudyName() As String
        Get
            Return mStudyName
        End Get
        Friend Set(ByVal value As String)
            If mStudyName <> value Then
                mStudyName = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property SurveyId() As Integer
        Get
            Return mSurveyId
        End Get
        Friend Set(ByVal value As Integer)
            If mSurveyId <> value Then
                mSurveyId = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property SurveyName() As String
        Get
            Return mSurveyName
        End Get
        Friend Set(ByVal value As String)
            If mSurveyName <> value Then
                mSurveyName = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property MailStepId() As Integer
        Get
            Return mMailStepId
        End Get
        Friend Set(ByVal value As Integer)
            If mMailStepId <> value Then
                mMailStepId = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property MailStepName() As String
        Get
            Return mMailStepName
        End Get
        Friend Set(ByVal value As String)
            If mMailStepName <> value Then
                mMailStepName = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property SurveyType() As String
        Get
            Return mSurveyType
        End Get
        Set(ByVal value As String)
            If mSurveyType <> value Then
                mSurveyType = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property OriginalGenerationDate() As Date
        Get
            Return mOriginalGenerationDate
        End Get
        Friend Set(ByVal value As Date)
            If mOriginalGenerationDate <> value Then
                mOriginalGenerationDate = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property GenerationDate() As Date
        Get
            Return mGenerationDate
        End Get
        Set(ByVal value As Date)
            If mGenerationDate <> value Then
                mGenerationDate = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property Priority() As Integer
        Get
            Return mPriority
        End Get
        Set(ByVal value As Integer)
            If mPriority <> value Then
                mPriority = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property FormCount() As Integer
        Get
            Return mFormCount
        End Get
        Friend Set(ByVal value As Integer)
            If mFormCount <> value Then
                mFormCount = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public Property IsFormGenerationReleased() As Boolean
        Get
            Return mIsFormGenReleased
        End Get
        Friend Set(ByVal value As Boolean)
            If mIsFormGenReleased <> value Then
                mIsFormGenReleased = value
                OnPropertyValueChanged()
            End If
        End Set
    End Property

    Public ReadOnly Property ClientLabel() As String
        Get
            Return String.Format("{0} ({1})", mClientName, mClientId)
        End Get
    End Property

    Public ReadOnly Property StudyLabel() As String
        Get
            Return String.Format("{0} ({1})", mStudyName, mStudyId)
        End Get
    End Property

    Public ReadOnly Property SurveyLabel() As String
        Get
            Return String.Format("{0} ({1})", mSurveyName, mSurveyId)
        End Get
    End Property

#End Region

#Region " Constructors "
    Public Sub New()

    End Sub
#End Region

    Private Sub OnPropertyValueChanged()
        mIsDirty = True
    End Sub

    Public Sub ResetDirtyFlag()
        mIsDirty = False
    End Sub

#Region " DB CRUD Methods "
    Public Shared Function GetByGenerationDate(ByVal startDate As Date, ByVal endDate As Date) As Collection(Of FormGenJob)
        Return FormGenJobProvider.Instance.SelectByGenerationDate(startDate, endDate)
    End Function

    Public Sub UpdatePriority()
        If mIsDirty Then
            FormGenJobProvider.Instance.UpdatePriority(mSurveyId, priority)
        End If
    End Sub

    Public Sub UpdateGenerationDate()
        If mIsDirty Then
            FormGenJobProvider.Instance.UpdateGenerationDate(mSurveyId, mMailStepId, mOriginalGenerationDate, mGenerationDate)
        End If
    End Sub

    Public Shared Sub ScheduleNextMailSteps()
        FormGenJobProvider.Instance.ScheduleNextMailSteps()
    End Sub
#End Region

End Class
