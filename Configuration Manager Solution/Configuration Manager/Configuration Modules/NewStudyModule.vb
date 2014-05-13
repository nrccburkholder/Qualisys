Imports Nrc.Qualisys.Library

Public Class NewStudyModule
    Inherits StudyPropertiesModule

    Public Sub New(ByVal configPanel As Panel, ByVal navCtrl As ClientStudySurveyNavigator)
        MyBase.New(configPanel, navCtrl)
    End Sub

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "New Study"
        End Get
    End Property

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.New16
        End Get
    End Property

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Me.Reset()
        Dim client As Client = Library.Client.GetClient(selectedClient.Id)
        Me.Study = New Library.Study(client)
        With Me.Study
            .CreateDate = Date.Today
            .Name = Me.Name
            .UseAddressCleaning = True
            .UseProperCase = True
            .IsActive = True
            .StudyEmployees = Library.STUDY_EMPLOYEE.GetAllWithFullAccess
        End With
        Me.EndConfigCallBack = endConfigCallback

        Me.ConfigPanel.Controls.Clear()
        Dim ctrl As StudySection
        ctrl = New StudySection(Me, New EndConfigCallBackMethod(AddressOf EndConfig), mNavigator)
        ctrl.Dock = DockStyle.Fill
        Me.ConfigPanel.Controls.Add(ctrl)

    End Sub

    Protected Overrides Sub Cleanup(ByVal action As ConfigResultActions)

        If Me.IsLocked Then
            Me.IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Survey, Me.Study.Id)
        End If
        Me.ConfigPanel.Controls.Clear()
        Dim EndConfigCallBack As EndConfigCallBackMethod = Me.EndConfigCallBack
        If (EndConfigCallBack IsNot Nothing) Then
            If (action = ConfigResultActions.StudyRefresh) Then
                EndConfigCallBack(ConfigResultActions.StudyAdded, Me.Study)
            Else
                EndConfigCallBack(action, Nothing)
            End If
            Me.EndConfigCallBack = Nothing
        End If

    End Sub
End Class
