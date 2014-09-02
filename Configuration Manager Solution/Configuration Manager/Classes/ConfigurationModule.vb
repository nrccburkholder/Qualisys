Imports Nrc.QualiSys.Library

Public Delegate Sub EndConfigCallBackMethod(ByVal action As ConfigResultActions, ByVal data As Object)

Public MustInherit Class ConfigurationModule

    Private mConfigPanel As Panel

    Protected ReadOnly Property ConfigPanel() As Panel
        Get
            Return mConfigPanel
        End Get
    End Property

    Public Overridable Function IsEnabled(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal btn As ToolStripButton) As Boolean

        If Not selectedSurvey Is Nothing Then
            If Me.Name = "Mode Section Mappings" And selectedSurvey.HasModeMapping = False Then
                Return False
            End If
        End If

        Return True

    End Function


    Protected Sub New(ByVal configPanel As Panel)

        mConfigPanel = configPanel

    End Sub

    Public MustOverride ReadOnly Property Name() As String
    Public MustOverride ReadOnly Property Image() As Image
    Public MustOverride Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)

End Class
