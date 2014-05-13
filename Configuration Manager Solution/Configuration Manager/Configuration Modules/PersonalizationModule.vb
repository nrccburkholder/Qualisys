Imports Nrc.Qualisys.Library
Public Class PersonalizationModule
    Inherits ConfigurationModule

    Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)
        Dim studyId As Integer = selectedStudy.Id
        Dim surveyId As Integer = selectedSurvey.Id
        Dim personalize As New nrcTagField.clsSaveTagFields
        Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey

        If selectedSurvey.IsValidated Then
            MessageBox.Show("You have to clear the survey validation flag before editing.", "Survey Validated", MessageBoxButtons.OK, MessageBoxIcon.Information)
            personalize.Go(studyId, surveyId, False)
        Else
            If ConcurrencyManager.AcquireLock(lockCategory, surveyId, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
                personalize.Go(studyId, surveyId, True)
                ConcurrencyManager.ReleaseLock(lockCategory, surveyId)
            Else
                Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, surveyId)
                Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
                MessageBox.Show(lockCategoryName & " Locked by " & lock.UserName & "; process=" & lock.ProcessName & "; machineID=" & lock.MachineName, lockCategoryName & " Locked", MessageBoxButtons.OK)
                personalize.Go(studyId, surveyId, False)
            End If
        End If

        'Release the unmanaged resource.
        If personalize IsNot Nothing Then
            System.Runtime.InteropServices.Marshal.ReleaseComObject(personalize)
        End If
        endConfigCallback(ConfigResultActions.SurveyRefresh, Nothing)
    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Personalization16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Personalization"
        End Get
    End Property
End Class
