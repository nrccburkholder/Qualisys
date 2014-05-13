Imports Nrc.Qualisys.Library
Public Class SamplePeriodsModule
    Inherits ConfigurationModule

    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mSurvey As Survey
    Private mIsLocked As Boolean
    Private mIsEditable As Boolean
    Private mInformation As String

#Region " Private/Public properties "
    Public Property Survey() As Library.Survey
        Get
            Return mSurvey
        End Get
        Set(ByVal value As Library.Survey)
            mSurvey = value
        End Set
    End Property

    Public Property IsEditable() As Boolean
        Get
            Return mIsEditable
        End Get
        Set(ByVal value As Boolean)
            mIsEditable = value
        End Set
    End Property

    Public Property Information() As String
        Get
            Return mInformation
        End Get
        Set(ByVal value As String)
            mInformation = value
        End Set
    End Property

    Private Property IsLocked() As Boolean
        Get
            Return mIsLocked
        End Get
        Set(ByVal value As Boolean)
            mIsLocked = value
        End Set
    End Property
#End Region

    Public Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Sample Periods"
        End Get
    End Property

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Calendar16
        End Get
    End Property

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Me.Reset()
        Dim studyId As Integer = selectedStudy.Id
        Dim surveyId As Integer = selectedSurvey.Id
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey

        Me.mEndConfigCallBack = endConfigCallback

        mSurvey = selectedSurvey.GetSurvey

        If selectedSurvey.IsValidated Then
            Me.IsEditable = False
            Me.Information = "You have to clear the survey validation flag before editing."
        Else
            If ConcurrencyManager.AcquireLock(lockCategory, surveyId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
                ConcurrencyManager.ReleaseLock(lockCategory, surveyId)
            Else
                Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, surveyId)
                Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
                Me.Information = lockCategoryName & " Locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName
            End If
        End If

        Me.ConfigPanel.Controls.Clear()
        Dim ctrl As PeriodEditor
        ctrl = New PeriodEditor(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        Me.ConfigPanel.Controls.Add(ctrl)

    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)
        If Me.IsLocked Then
            Me.IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, mSurvey.Id)
        End If
        Me.ConfigPanel.Controls.Clear()
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
    End Sub

    Private Sub Reset()
        mEndConfigCallBack = Nothing
        mSurvey = Nothing
        mIsEditable = True
        mInformation = Nothing
    End Sub

End Class
