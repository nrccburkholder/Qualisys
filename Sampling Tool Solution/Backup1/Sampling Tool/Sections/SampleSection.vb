Imports Nrc.Qualisys.Library

Public Class SampleSection

#Region " Private Instance Fields "
    Private WithEvents mNavigator As ClientStudySurveyNavigator
#End Region

#Region " Constructors "
    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub

#End Region

#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        Dim nav As ClientStudySurveyNavigator = TryCast(navCtrl, ClientStudySurveyNavigator)
        If nav Is Nothing Then
            Throw New ArgumentException("The SampleSection class expects a navigation control of type ClientStudySurveyNavigator")
        End If

        Me.mNavigator = nav
    End Sub

    Public Overrides Function AllowUnload() As Boolean
        Return Not Me.SampleDefinition.IsSampling
    End Function
#End Region

#Region " Control Event Handlers "
    Private Sub SampleSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Enabled = False
    End Sub

    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged
        Me.Enabled = (Me.mNavigator.SelectedSurveys.Count > 0)

        Me.SampleDefinition.Populate(Me.mNavigator.SelectedSurveys)
        Me.ExistingSamples.Populate(Me.mNavigator.SelectedSurveys)
    End Sub

    Private Sub SampleDefinition_SampleCompleted(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleDefinition.SampleCompleted
        Me.ExistingSamples.Populate(Me.mNavigator.SelectedSurveys)
    End Sub

    Private Sub ExistingSamples_SampleSetDeleted(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExistingSamples.SampleSetDeleted
        'Me.SampleDefinition.Populate(Me.mNavigator.SelectedSurveys)
        Me.SampleDefinition.RefreshNewSampleDefinition()
    End Sub

#End Region

End Class

