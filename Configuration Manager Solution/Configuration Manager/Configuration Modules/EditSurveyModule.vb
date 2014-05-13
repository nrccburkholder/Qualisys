Imports Nrc.QualiSys.Library

Public Class EditSurveyModule
    Inherits SurveyPropertiesModule

    Private mIsLocked As Boolean

    Private Property IsLocked() As Boolean
        Get
            Return mIsLocked
        End Get
        Set(ByVal value As Boolean)
            mIsLocked = value
        End Set
    End Property

    Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        If (selectedStudy Is Nothing OrElse selectedSurvey Is Nothing) Then Return

        Reset()
        Study = selectedStudy.GetStudy
        Survey = selectedSurvey.GetSurvey
        Me.EndConfigCallBack = endConfigCallback
        If (selectedSurvey IsNot Nothing) Then
            EditingSurvey = Library.Survey.[Get](selectedSurvey.Id)
        End If

        Try
            If Survey.IsValidated Then
                Information = "You have to clear the survey validation flag before editing."
                IsEditable = False
            Else
                Dim lockCategory As ConcurrencyLockCategory = ConcurrencyLockCategory.Survey
                If ConcurrencyManager.AcquireLock(lockCategory, Survey.Id, CurrentUser.UserName, Environment.MachineName, Process.GetCurrentProcess.ProcessName) Then
                    IsLocked = True
                Else
                    IsEditable = False
                    Dim lock As ConcurrencyLock = ConcurrencyManager.ViewLock(lockCategory, Survey.Id)
                    Dim lockCategoryName As String = System.Enum.GetName(lock.LockCategory.GetType, lockCategory)
                    Information = String.Format("{0} Locked by {1}; process={2}; machineID={3}", lockCategoryName, lock.UserName, lock.ProcessName, lock.MachineName)
                End If
            End If

            ConfigPanel.Controls.Clear()
            Dim ctrl As New SurveyPropertiesEditor(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
            ctrl.Dock = DockStyle.Fill
            ConfigPanel.Controls.Add(ctrl)

        Catch ex As Exception
            If IsLocked Then
                IsLocked = False
                ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, Survey.Id)
            End If
            Throw

        End Try

    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.Properties16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Survey Properties"
        End Get
    End Property

    Private Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If (IsEditable AndAlso action = ConfigResultActions.SurveyRefresh) Then
                EditingSurvey.Update()
            End If

        Catch ex As Exception
            Globals.ReportException(ex)

        Finally
            Cleanup(action)

        End Try

    End Sub

    Private Sub Cleanup(ByVal action As ConfigResultActions)

        If IsLocked Then
            IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, Survey.Id)
        End If

        ConfigPanel.Controls.Clear()

        Dim EndConfigCallBack As EndConfigCallBackMethod = Me.EndConfigCallBack
        If (EndConfigCallBack IsNot Nothing) Then
            EndConfigCallBack(action, Nothing)
            Me.EndConfigCallBack = Nothing
        End If

    End Sub

    Protected Overrides Sub Reset()

        MyBase.Reset()
        IsLocked = False

    End Sub

End Class





