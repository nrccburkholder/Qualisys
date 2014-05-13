Imports Nrc.Qualisys.Library

Public Class NewClientModule
    Inherits ClientPropertiesModule

#Region " Public Properties "

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "New Client"
        End Get
    End Property

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.New16
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal configPanel As Panel)

        MyBase.New(configPanel)

    End Sub

#End Region

#Region " Public Methods "

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

        Reset()
        Dim client As Client = Library.Client.GetClient(selectedClient.Id)
        Me.Client = New Client
        With Me.Client
            .Name = Name
            .IsActive = True
        End With
        IsNew = True
        Me.EndConfigCallBack = endConfigCallback

        ConfigPanel.Controls.Clear()
        Dim ctrl As ClientSection = New ClientSection(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        ConfigPanel.Controls.Add(ctrl)

    End Sub

#End Region

#Region " Protected Methods "

    Protected Overrides Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If IsEditable AndAlso action = ConfigResultActions.ClientRefresh Then
                Client = Library.Client.CreateNew(Client.Name, Client.IsActive, Client.ClientGroupID)
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
            Cleanup(action)
            Return

        End Try

        Cleanup(action)

    End Sub

    Protected Overrides Sub Cleanup(ByVal action As ConfigResultActions)

        If IsLocked Then
            IsLocked = False
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.Client, Client.Id)
        End If

        ConfigPanel.Controls.Clear()

        Dim callBack As EndConfigCallBackMethod = EndConfigCallBack
        If (callBack IsNot Nothing) Then
            If (action = ConfigResultActions.ClientRefresh) Then
                callBack(ConfigResultActions.ClientAdded, Client)
            Else
                callBack(action, Nothing)
            End If
            EndConfigCallBack = Nothing
        End If

    End Sub

#End Region

End Class
