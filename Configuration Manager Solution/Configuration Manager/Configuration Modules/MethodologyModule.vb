Imports Nrc.QualiSys.Library
Public Class MethodologyModule
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

        mIsLocked = False
        mSurvey = selectedSurvey.GetSurvey
        mEndConfigCallback = endConfigCallback

        'Store off the lock category for convenience
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey
        Dim editor As MethodologyEditor

        'Clear any controls that may be loaded into the main configuration panel
        Me.ClearConfigPanel()

        Dim warningMessage As String = ""

        'If the survey is validated
        If selectedSurvey.IsValidated Then
            'We didn't lock it
            mIsLocked = False

            'Show a warning to the user and open in readonly mode
            warningMessage = "This survey has been validated.  You must first clear the validation flag before editing."
            editor = New MethodologyEditor(New EndConfigCallBackMethod(AddressOf EndConfig), mSurvey, warningMessage, True)
            Me.LoadConfigPanel(editor)
        Else    'If it is not validated
            'Try to acquire the lock
            If ConcurrencyManager.AcquireLock(lockCategory, selectedSurvey.Id, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
                'If we got the lock then remember so we can later release the lock
                mIsLocked = True

                'Load up the editor in read/write mode
                editor = New MethodologyEditor(New EndConfigCallBackMethod(AddressOf EndConfig), mSurvey)
                Me.LoadConfigPanel(editor)
            Else
                'We didn't lock it
                mIsLocked = False

                'Show the user a warning and open editor in readonly mode
                Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, selectedSurvey.Id)
                Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
                warningMessage = lockCategoryName & " locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName
                editor = New MethodologyEditor(New EndConfigCallBackMethod(AddressOf EndConfig), mSurvey, warningMessage, True)
                Me.LoadConfigPanel(editor)
            End If
        End If
    End Sub

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)
        If mIsLocked Then
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, mSurvey.Id)
        End If
        Me.ClearConfigPanel()
        Me.mEndConfigCallback(action, Nothing)
    End Sub

    Private Sub ClearConfigPanel()
        Me.ConfigPanel.Controls.Clear()
    End Sub
    Private Sub LoadConfigPanel(ByVal editor As MethodologyEditor)
        editor.Dock = DockStyle.Fill
        Me.ConfigPanel.Controls.Add(editor)
    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Methodology16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Methodology"
        End Get
    End Property

End Class
