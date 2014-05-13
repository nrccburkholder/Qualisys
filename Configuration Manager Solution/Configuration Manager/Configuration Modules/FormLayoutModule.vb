Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class FormLayoutModule
    Inherits ConfigurationModule

    Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Dim path As String = IO.Path.Combine(AppConfig.Params("QualisysInstallPath").StringValue, "formlayout.exe")
        Dim surveyID As Integer = selectedSurvey.Id
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey

        If selectedSurvey.IsValidated Then
            MessageBox.Show("You have to clear the survey validation flag before editing.", "Survey Validated", MessageBoxButtons.OK, MessageBoxIcon.Information)
        ElseIf ConcurrencyManager.AcquireLock(lockCategory, surveyID, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
            'Check to see that the Form Layout exists in the current directory.
            'Launch it if the EXE exists, display message if it doesn't
            If IO.File.Exists(path) Then
                Dim args As String = String.Format("{0}", surveyID)
                Dim prcs As Process = Process.Start(path, args)
                prcs.WaitForExit()
            Else
                MessageBox.Show("Form Layout is not installed correctly. Contact the system administrator.", "Frequency Tool Not Found", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            End If
            ConcurrencyManager.ReleaseLock(lockCategory, surveyID)
        Else
            Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, surveyID)
            Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
            MessageBox.Show(String.Format("{0} Locked by {1}; process={2}; machineID={3}", lockCategoryName, lock.UserName, lock.ProcessName, lock.MachineName), lockCategoryName & " Locked", MessageBoxButtons.OK)
        End If

        endConfigCallback(ConfigResultActions.SurveyRefresh, Nothing)

    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.FormLayout16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Form Layout"
        End Get
    End Property

End Class
