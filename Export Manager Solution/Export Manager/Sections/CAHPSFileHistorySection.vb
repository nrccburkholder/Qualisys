Imports Nrc.DataMart.Library

Public Class CAHPSFileHistorySection
    Private WithEvents mNavigator As CAHPSNavigator
    Private mExportSetType As ExportSetType

#Region " Base Class Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        mNavigator = TryCast(navCtrl, CAHPSNavigator)
        If mNavigator Is Nothing Then
            Throw New Exception("CAHPSDefinitionSection expects a navigation control of type CAHPSNavigator")
        End If
    End Sub

#End Region

#Region " Constructors "

    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub
#End Region

#Region " Navigator Events "

    Private Sub mNavigator_ExportSetTypeSelectionChanged(ByVal sender As Object, ByVal e As ExportSetTypeSelectionChangedEventArgs) Handles mNavigator.ExportSetTypeSelectionChanged

        'Set member variables
        mExportSetType = e.ExportSetType

        'Populate file history
        PopulateFileHistory()

    End Sub
#End Region

#Region " Private Methods "

    Private Sub PopulateFileHistory()

        Dim medicareExportSets As Collection(Of ExportFileView) = ExportFileView.GetByExportTypeAllDetails(mExportSetType, FilterStartDate.Value.Date, FilterEndDate.Value.Date)

        If mExportSetType = ExportSetType.OCSClient Then
            For Each exportFile As ExportFileView In ExportFileView.GetByExportTypeAllDetails(ExportSetType.OCSNonClient, FilterStartDate.Value.Date, FilterEndDate.Value.Date)
                medicareExportSets.Add(exportFile)
            Next
        End If

        FileHistoryBindingSource.DataSource = medicareExportSets

        'Add Default sorting
        FileHistoryGridView.Columns("CreatedDate").SortOrder = DevExpress.Data.ColumnSortOrder.Descending
        FileHistoryGridView.Columns("MedicareNumber").SortOrder = DevExpress.Data.ColumnSortOrder.Ascending

        'Add Default grouping
        FileHistoryGridView.Columns("ClientGroupName").Group()
        FileHistoryGridView.ExpandAllGroups()

    End Sub

#End Region

#Region " Private Events "

    Private Sub CAHPSFileHistorySection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        FilterStartDate.Value = Now.AddDays(-7)

        'Populate file history
        PopulateFileHistory()

    End Sub

    Private Sub FilterToolStripButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterToolStripButton.Click

        PopulateFileHistory()

    End Sub
#End Region

End Class
