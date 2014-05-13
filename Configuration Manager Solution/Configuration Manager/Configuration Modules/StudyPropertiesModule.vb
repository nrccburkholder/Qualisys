Imports Nrc.QualiSys.Library
Public Class StudyPropertiesModule
    Inherits ConfigurationModule

    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mStudy As Library.Study
    Private mIsNew As Boolean
    Private mIsEditable As Boolean = True
    Private mInformation As String
    Private mIsLocked As Boolean
    Protected mNavigator As ClientStudySurveyNavigator

#Region " Private/Public properties "

    Protected Property EndConfigCallBack() As EndConfigCallBackMethod
        Get
            Return mEndConfigCallBack
        End Get
        Set(ByVal value As EndConfigCallBackMethod)
            mEndConfigCallBack = value
        End Set
    End Property

    Public Property Study() As Library.Study
        Get
            Return mStudy
        End Get
        Protected Set(ByVal value As Library.Study)
            mStudy = value
        End Set
    End Property

    Public Property IsNew() As Boolean
        Get
            Return mIsNew
        End Get
        Protected Set(ByVal value As Boolean)
            mIsNew = value
        End Set
    End Property

    Public Property IsEditable() As Boolean
        Get
            Return mIsEditable
        End Get
        Protected Set(ByVal value As Boolean)
            mIsEditable = value
        End Set
    End Property

    Public Property Information() As String
        Get
            Return mInformation
        End Get
        Protected Set(ByVal value As String)
            mInformation = value
        End Set
    End Property

    Protected Property IsLocked() As Boolean
        Get
            Return mIsLocked
        End Get
        Set(ByVal value As Boolean)
            mIsLocked = value
        End Set
    End Property

#End Region

    Sub New(ByVal configPanel As Panel, ByVal navCtrl As ClientStudySurveyNavigator)

        MyBase.New(configPanel)
        mNavigator = navCtrl

    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Me.Reset()
        Dim studyId As Integer = selectedStudy.Id
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.StudyProperties

        Me.mEndConfigCallBack = endConfigCallback

        mStudy = selectedStudy.GetStudy

        If ConcurrencyManager.AcquireLock(lockCategory, studyId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            ConcurrencyManager.ReleaseLock(lockCategory, studyId)
        Else
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, studyId)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            Me.Information = lockCategoryName & " Locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName
        End If

        Me.ConfigPanel.Controls.Clear()
        Dim ctrl As StudySection
        ctrl = New StudySection(Me, New EndConfigCallBackMethod(AddressOf EndConfig), mNavigator)
        ctrl.Dock = DockStyle.Fill
        Me.ConfigPanel.Controls.Add(ctrl)

    End Sub

    Protected Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)
        Try
            If (Me.IsEditable AndAlso (action = ConfigResultActions.StudyRefresh _
                    OrElse action = ConfigResultActions.StudyAdded)) Then
                Me.Study.Save()
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
            Cleanup(action)
            Return
        End Try

        Cleanup(action)

    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Properties16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Study Properties"
        End Get
    End Property

    Protected Overridable Sub Cleanup(ByVal action As ConfigResultActions)

        If Me.IsLocked Then
            Me.IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, mStudy.Id)
        End If
        Me.ConfigPanel.Controls.Clear()
        Dim EndConfigCallBack As EndConfigCallBackMethod = Me.EndConfigCallBack
        If (EndConfigCallBack IsNot Nothing) Then
            EndConfigCallBack(action, Nothing)
            Me.EndConfigCallBack = Nothing
        End If

    End Sub

    Protected Overridable Sub Reset()
        mEndConfigCallBack = Nothing
        mStudy = Nothing
        mIsNew = False
        mIsEditable = True
        mInformation = Nothing
    End Sub
End Class
