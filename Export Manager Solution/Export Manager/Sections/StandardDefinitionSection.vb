Imports Nrc.DataMart.Library

Public Class StandardDefinitionSection

    Private mExportSetType As Library.ExportSetType
    Private WithEvents mNavigator As ClientStudySurveyNavigator

    Public Sub New(ByVal exportType As ExportSetType)

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mExportSetType = exportType
        Me.CreateDefinition.ExportSetType = mExportSetType
        Me.ExistingDefinitions.ExportSetType = mExportSetType
        Select Case mExportSetType
            Case ExportSetType.Standard
                Me.CreateDefinition.DateSelectionMode = CreateDefinitionControl.DateMode.StartAndEndDate
                Me.ExistingDefinitions.ShowCutoffFieldColumn = True
                Me.ExistingDefinitions.ShowStartDateColumn = True
                Me.ExistingDefinitions.ShowEndDateColumn = True
                Me.ExistingDefinitions.ShowStartMonthColumn = False
                Me.ExistingDefinitions.ShowUnitColumn = False
                Dim HasOryxPermission As Boolean = CurrentUser.IsOryxUser()
                Me.ExistingDefinitions.ORYXToolStripMenuItem.Visible = HasOryxPermission
                Me.ExistingDefinitions.ExportORYXDataToolStripMenuItem1.Visible = HasOryxPermission
            Case ExportSetType.CmsHcahps, ExportSetType.CmsChart, ExportSetType.CmsHHcahps
                Me.CreateDefinition.DateSelectionMode = CreateDefinitionControl.DateMode.SingleMonth
                Me.ExistingDefinitions.ShowCutoffFieldColumn = False
                Me.ExistingDefinitions.ShowStartDateColumn = False
                Me.ExistingDefinitions.ShowEndDateColumn = False
                Me.ExistingDefinitions.ShowStartMonthColumn = True
                Me.ExistingDefinitions.ShowUnitColumn = True
        End Select
    End Sub

#Region " Base Class Overrides "
    Public Overrides Sub ActivateSection()
        If mNavigator IsNot Nothing Then
            Me.ExistingDefinitions.Navigator = mNavigator
            Me.CreateDefinition.Navigator = mNavigator
            Me.ExistingDefinitions.RefreshExportList()
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        If mNavigator IsNot Nothing Then
            Me.ExistingDefinitions.Navigator = Nothing
            Me.CreateDefinition.Navigator = Nothing
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

#Region " Control Event Handlers "

#End Region


    Private Sub CreateDefinition_NewExportSetsCreated(ByVal sender As Object, ByVal e As CreateDefinitionControl.NewExportSetsCreatedEventArgs) Handles CreateDefinition.NewExportSetsCreated
        'If new exports are created then refresh the existing export list control so the new items show up
        Me.ExistingDefinitions.RefreshExportList()

        'Select all the new exports in the list of existing export sets
        Me.ExistingDefinitions.SelectExportSets(e.NewExportSets)

        Select Case e.CreationOptions
            Case CreateDefinitionControl.CreationOptions.ExportToIndividualFiles
                Me.ExistingDefinitions.ExportSelectedSetsToIndividualFiles()
            Case CreateDefinitionControl.CreationOptions.ExportToCombinedFile
                Me.ExistingDefinitions.ExportSelectedSetsToCombinedFile()
        End Select
    End Sub

End Class
