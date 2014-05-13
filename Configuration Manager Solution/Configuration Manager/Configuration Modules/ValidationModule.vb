Imports Nrc.QualiSys.Library
Public Class ValidationModule
    Inherits ConfigurationModule

    Private mIsLocked As Boolean
    Private mSurvey As Survey
    Private mEndConfigCallback As EndConfigCallBackMethod

    Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)
        'Validate input parameters
        If selectedClient Is Nothing Then
            Throw New ArgumentNullException("selectedClient")
        End If
        If selectedStudy Is Nothing Then
            Throw New ArgumentNullException("selectedStudy")
        End If
        If selectedSurvey Is Nothing Then
            Throw New ArgumentNullException("selectedSurvey")
        End If
        Dim warningMessage As String = ""

        mIsLocked = False
        mSurvey = selectedSurvey.GetSurvey
        mEndConfigCallback = endConfigCallback

        Dim editor As SurveyValidator

        'Clear any controls that may be loaded into the main configuration panel
        Me.ClearConfigPanel()


        'Try to acquire the lock
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey
        If ConcurrencyManager.AcquireLock(lockCategory, selectedSurvey.Id, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            'If we got the lock then remember so we can later release the lock
            mIsLocked = True

            'Load up the editor in read/write mode
            editor = New SurveyValidator(New EndConfigCallBackMethod(AddressOf EndConfig), mSurvey)
            Me.LoadConfigPanel(editor)
        Else
            'We didn't lock it
            mIsLocked = False

            'Show the user a warning and open editor in readonly mode
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(ConcurrencyLockCategory.Survey, selectedSurvey.Id)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            warningMessage = lockCategoryName & " locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName
            editor = New SurveyValidator(New EndConfigCallBackMethod(AddressOf EndConfig), mSurvey, warningMessage, True)
            Me.LoadConfigPanel(editor)
        End If


        ''''''

        'Dim surveyId As Integer = selectedSurvey.Id
        'Dim validator As New ValidateSurvey.Validation
        'Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.SurveyValidation

        'If ConcurrencyManager.AcquireLock(lockCategory, surveyId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
        '    validator.Go(surveyId)
        '    ConcurrencyManager.ReleaseLock(lockCategory, surveyId)
        'Else
        '    Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, surveyId)
        '    Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
        '    MessageBox.Show(lockCategoryName & " Locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName, lockCategoryName & " Locked", MessageBoxButtons.OK)
        '    validator.Go(surveyId)
        'End If

        ''Release the unmanaged resource.
        'If validator IsNot Nothing Then
        '    System.Runtime.InteropServices.Marshal.ReleaseComObject(validator)
        'End If

        'endConfigCallback(ConfigResultAction.SurveyRefresh, Nothing)
    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)
        If mIsLocked Then
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, mSurvey.Id)
        End If
        Me.ClearConfigPanel()
        Me.mEndConfigCallback(action, Nothing)
        Me.mIsLocked = False
        Me.mSurvey = Nothing
    End Sub

    Private Sub ClearConfigPanel()
        Me.ConfigPanel.Controls.Clear()
    End Sub
    Private Sub LoadConfigPanel(ByVal ctrl As SurveyValidator)
        ctrl.Dock = DockStyle.Fill
        Me.ConfigPanel.Controls.Add(ctrl)
    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Validation16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Validation"
        End Get
    End Property

End Class
