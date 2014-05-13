Public Class CmsDefinitionSection

    Private WithEvents mNavigator As ClientStudySurveyNavigator

#Region " Base Class Overrides "
    Public Overrides Sub ActivateSection()
        If mNavigator IsNot Nothing Then
            AddHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
            Me.ExistingDefinitionsControl1.Navigator = mNavigator
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        If mNavigator IsNot Nothing Then
            RemoveHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
            Me.ExistingDefinitionsControl1.Navigator = Nothing
        End If
    End Sub

    Public Overrides Function AllowInactivate() As Boolean
        Return True
    End Function

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = TryCast(navCtrl, ClientStudySurveyNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("ExportDefinitionSection expects a navigation control of type ClientStudySurveyNavigator")
        End If
    End Sub
#End Region

    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub

#Region " Control Event Handlers "
    ''' <summary>When the client, study, or survey is selected/changed</summary>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        If Me.mNavigator.SelectedClientIds.Count > 0 _
            OrElse Me.mNavigator.SelectedStudyIds.Count > 0 Then
            Me.CreateDefinitionControl1.Enabled = False
        Else
            Me.CreateDefinitionControl1.Enabled = True
        End If

        'Me.CreateDefinitionControl1.NewDefinitionCount = Me.mClientStudySurveyNavigator.SelectedSurveyIds.Count
    End Sub
#End Region

    Private Sub CreateDefinitionControl1_NewExportSetsCreated(ByVal sender As Object, ByVal e As CreateDefinitionControl.NewExportSetsCreatedEventArgs) Handles CreateDefinitionControl1.NewExportSetsCreated
        'If new exports are created then refresh the existing export list control so the new items show up
        Me.ExistingDefinitionsControl1.RefreshExportList()

        'Select all the new exports in the list of existing export sets
        Me.ExistingDefinitionsControl1.SelectExportSets(e.NewExportSets)

        Select Case e.CreationOptions
            Case CreateDefinitionControl.CreationOptions.ExportToIndividualFiles
                Me.ExistingDefinitionsControl1.ExportSelectedSetsToIndividualFiles()
            Case CreateDefinitionControl.CreationOptions.ExportToCombinedFile
                Me.ExistingDefinitionsControl1.ExportSelectedSetsToCombinedFile()
        End Select
    End Sub

End Class
