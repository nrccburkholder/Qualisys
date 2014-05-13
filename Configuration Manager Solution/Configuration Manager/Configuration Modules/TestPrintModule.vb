Imports Nrc.Qualisys.Library
Public Class TestPrintModule
    Inherits ConfigurationModule

    Sub New(ByVal configPanel As Panel)
        MyBase.New(configPanel)
    End Sub

    Public Overrides Sub BeginConfig(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedClient As Navigation.ClientNavNode, ByVal selectedStudy As Navigation.StudyNavNode, ByVal selectedSurvey As Navigation.SurveyNavNode, ByVal endConfigCallback As EndConfigCallBackMethod)
        Dim studyId As Integer = selectedStudy.Id
        Dim surveyId As Integer = selectedSurvey.Id
        Dim testPrint As New TestPrint.nrcTestPrint
        Dim employeeID As Integer = CurrentUser.Employee.Id

        If selectedSurvey.IsValidated = False Then
            MessageBox.Show("You have to validate the survey before running test prints.", "Survey Unvalidated", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Else : testPrint.GetPrints(surveyId, employeeID)
        End If

        endConfigCallback(ConfigResultActions.SurveyRefresh, Nothing)
    End Sub

    Public Overrides ReadOnly Property Image() As System.Drawing.Image
        Get
            Return My.Resources.TestPrint16
        End Get
    End Property

    Public Overrides ReadOnly Property Name() As String
        Get
            Return "Test Prints"
        End Get
    End Property

    Public Overrides Function IsEnabled(ByVal selectedClientGroup As Navigation.ClientGroupNavNode, ByVal selectedStudy As Library.Navigation.StudyNavNode, ByVal selectedSurvey As Library.Navigation.SurveyNavNode, ByVal btn As ToolStripButton) As Boolean
        Dim periods As Collection(Of SamplePeriod) = SamplePeriod.GetBySurveyId(selectedSurvey.Id)

        'If 1 or more samplesets exists, we want to enable test prints
        For Each period As SamplePeriod In periods
            If period.SampleSets.Count > 0 Then
                Return True
                Exit Function
            End If
        Next
        Return False
    End Function

End Class
