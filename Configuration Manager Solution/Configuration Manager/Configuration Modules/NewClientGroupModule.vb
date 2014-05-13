Imports Nrc.QualiSys.Library

Public Class NewClientGroupModule
    Inherits ClientGroupPropertiesModule

#Region " Public Properties "

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "New Client Group"
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
        Dim clientGroup As ClientGroup = Library.ClientGroup.GetClientGroup(selectedClientGroup.Id)
        Me.ClientGroup = New ClientGroup
        With Me.ClientGroup
            .Name = Name
            .ReportName = Name
            .IsActive = True
        End With
        IsNew = True
        Me.EndConfigCallBack = endConfigCallback

        ConfigPanel.Controls.Clear()
        Dim ctrl As ClientGroupSection = New ClientGroupSection(Me, New EndConfigCallBackMethod(AddressOf EndConfig))
        ctrl.Dock = DockStyle.Fill
        ConfigPanel.Controls.Add(ctrl)

    End Sub

#End Region

#Region " Protected Methods "

    Protected Overrides Sub EndConfig(ByVal action As ConfigResultActions, ByVal data As Object)

        Try
            If IsEditable AndAlso action = ConfigResultActions.ClientGroupRefresh Then
                ClientGroup = Library.ClientGroup.CreateNew(ClientGroup.Name, ClientGroup.ReportName, ClientGroup.IsActive)
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
            ConcurrencyManager.ReleaseLock(ConcurrencyLockCategory.ClientGroup, ClientGroup.Id)
        End If

        ConfigPanel.Controls.Clear()

        Dim callBack As EndConfigCallBackMethod = EndConfigCallBack
        If (callBack IsNot Nothing) Then
            If (action = ConfigResultActions.ClientGroupRefresh) Then
                callBack(ConfigResultActions.ClientGroupAdded, ClientGroup)
            Else
                callBack(action, Nothing)
            End If
            EndConfigCallBack = Nothing
        End If

    End Sub

#End Region

End Class
