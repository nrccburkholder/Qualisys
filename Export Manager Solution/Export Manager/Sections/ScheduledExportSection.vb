Imports Nrc.DataMart.Library
Imports System.ComponentModel
Public Class ScheduledExportSection

    Private WithEvents mNavigator As ClientStudySurveyNavigator
    Private mMasterList As New Dictionary(Of Integer, ScheduledExport)

    'Keeps track of what is selected.  This is used when they update or 
    'delete scheduled exports.  We want to update both grids, and reselect
    'the previously selected export sets
    Private mPreviouslySelectedExportSetsList As New List(Of ExportSet)
    Private mPreviouslySelectedListNeedsUpdate As Boolean = True

#Region " Base Class Overrides "
    Public Overrides Sub ActivateSection()
        If mNavigator IsNot Nothing Then
            AddHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
        End If
    End Sub

    Public Overrides Sub InactivateSection()
        If mNavigator IsNot Nothing Then
            RemoveHandler mNavigator.SelectionChanged, AddressOf mNavigator_SelectionChanged
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

#Region " Public Properties "
    <Browsable(False)> _
    Public Property Navigator() As ClientStudySurveyNavigator
        Get
            Return mNavigator
        End Get
        Set(ByVal value As ClientStudySurveyNavigator)
            mNavigator = value
        End Set
    End Property

#End Region

#Region " Constructors "
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub
#End Region

#Region " Private Properties "
    Private ReadOnly Property SelectedExportSets() As Collection(Of ExportSet)
        Get
            Dim sets As New Collection(Of ExportSet)
            For Each row As DataGridViewRow In Me.ExportSetsGrid.SelectedRows
                Dim export As ExportSet = TryCast(row.Tag, ExportSet)
                If export IsNot Nothing Then
                    sets.Add(export)
                End If
            Next

            Return sets
        End Get
    End Property
#End Region

#Region " Event Handlers "
    ''' <summary>Form Load Event</summary>
    Private Sub ExistingDefinitionsControl_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Initialize the filter date range
        'Default to last year
        Me.FilterEndDate.Value = Date.Parse(String.Format("{0}/{1}/{2}", Date.Now.Month, Date.Now.Day, Date.Now.Year))
        Me.FilterStartDate.Value = Me.FilterEndDate.Value.AddYears(-1)
    End Sub


    Private Sub mNavigator_SelectedFilterButtonChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectedFilterButtonChanged
        RefreshExportLists()
    End Sub

    ''' <summary>When the client, study, or survey is selected/changed</summary>
    Private Sub mNavigator_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles mNavigator.SelectionChanged
        mPreviouslySelectedExportSetsList.Clear()
        Me.PopulateExportList()
    End Sub

    Private Sub FilterDate_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles FilterStartDate.KeyUp, FilterEndDate.KeyUp
        If e.KeyCode = Keys.Enter Then
            mPreviouslySelectedExportSetsList.Clear()
            Me.PopulateExportList()
        End If
    End Sub

    Private Sub FilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterButton.Click
        RefreshExportLists()
    End Sub

    Private Sub ExistingExportsGrid_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ExportSetsGrid.MouseDown
        'Need to do some special handling when user right-clicks the datagridview
        GridMouseDown(sender, e, Me.ExportSetsGrid)
    End Sub

    Private Sub ScheduledExportDataGridView_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles ScheduledExportDataGridView.KeyDown
        If e.KeyCode = Keys.Delete Then DeleteScheduledExport()
    End Sub

    Private Sub ScheduledExportDataGridView_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ScheduledExportDataGridView.MouseDown
        'Need to do some special handling when user right-clicks the datagridview
        GridMouseDown(sender, e, Me.ScheduledExportDataGridView)
    End Sub

    Private Sub ExportSetsGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportSetsGrid.SelectionChanged
        If mPreviouslySelectedListNeedsUpdate Then UpdatePreviouslySelectedExportSetsList()
        PopulateScheduledExportGrid()
    End Sub

    Private Sub UpdateRunDateButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateRunDateButton.Click
        UpdateScheduledExportRunDate()
    End Sub

    Private Sub DeleteScheduledFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnScheduleFileButton.Click
        DeleteScheduledExport()
    End Sub

    Private Sub UpdateScheduledDateToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles UpdateScheduledDateToolStripMenuItem.Click
        UpdateScheduledExportRunDate()
    End Sub

    Private Sub DeleteToolStripMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DeleteToolStripMenuItem.Click
        DeleteScheduledExport()
    End Sub

    Private Sub ScheduledExportDataGridView_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ScheduledExportDataGridView.SelectionChanged
        ToggleUpdateButton()
        ToggleUnScheduleButton()
    End Sub
#End Region

#Region " Public Methods "
    Public Sub RefreshExportList()
        Me.PopulateExportList()
    End Sub

    Public Sub SelectExportSets(ByVal exportSets As Collection(Of ExportSet))
        'Get a list of the selected ids
        Dim selectedIds As New List(Of Integer)
        For Each es As ExportSet In exportSets
            selectedIds.Add(es.Id)
        Next

        'Select each row that is in the list of ids 
        For Each row As DataGridViewRow In Me.ExportSetsGrid.Rows
            Dim export As ExportSet = TryCast(row.Tag, ExportSet)
            If export IsNot Nothing AndAlso selectedIds.Contains(export.Id) Then
                row.Selected = True
            Else
                row.Selected = False
            End If
        Next
    End Sub
#End Region

#Region " Private Methods "
    Private Sub RefreshExportLists()
        Me.FilterStartDate.Focus()
        Me.FilterEndDate.Focus()
        mPreviouslySelectedExportSetsList.Clear()
        Me.PopulateExportList()
    End Sub

    Private Sub ToggleUpdateButton()
        Me.UpdateRunDateButton.Enabled = (Me.ScheduledExportDataGridView.SelectedRows.Count > 0)
    End Sub

    Private Sub ToggleUnScheduleButton()
        Me.UnScheduleFileButton.Enabled = (Me.ScheduledExportDataGridView.SelectedRows.Count > 0)
    End Sub

    Private Sub UpdatePreviouslySelectedExportSetsList()
        mPreviouslySelectedExportSetsList.Clear()

        For Each row As DataGridViewRow In Me.ExportSetsGrid.SelectedRows
            Dim expSet As ExportSet = DirectCast(row.Tag, ExportSet)
            mPreviouslySelectedExportSetsList.Add(expSet)
        Next
    End Sub

    Private Sub DeleteScheduledExport()
        'Confirm
        If MessageBox.Show("Are you sure you want to delete the selected scheduled export(s)?", "Delete Scheduled Export", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.Yes Then
            Dim selectedExport As ScheduledExport
            For Each row As DataGridViewRow In Me.ScheduledExportDataGridView.SelectedRows
                selectedExport = DirectCast(row.Tag, ScheduledExport)
                ScheduledExport.Delete(selectedExport.Id)
            Next
            PopulateExportList()
            PopulateScheduledExportGrid()
        End If
    End Sub

    Private Sub UpdateScheduledExportRunDate()
        Dim updater As New UpdateScheduledExportRunDateDialog
        Dim firstExport As New ScheduledExport


        'Set the datetime picker to the earliest date of the selected exports
        For Each row As DataGridViewRow In Me.ScheduledExportDataGridView.SelectedRows
            Dim checkExport As ScheduledExport = DirectCast(row.Tag, ScheduledExport)
            If checkExport.RunDate < firstExport.RunDate OrElse firstExport.RunDate = DateTime.MinValue Then firstExport = checkExport
        Next
        updater.RunDateDTP.Value = firstExport.RunDate

        If updater.ShowDialog = DialogResult.OK Then
            Dim selectedExport As ScheduledExport
            Dim selectedDate As DateTime = updater.RunDateDTP.Value
            For Each row As DataGridViewRow In Me.ScheduledExportDataGridView.SelectedRows
                selectedExport = DirectCast(row.Tag, ScheduledExport)
                selectedExport.RunDate = selectedDate
                selectedExport.Update()
            Next
            PopulateExportList()
            PopulateScheduledExportGrid()
        End If
    End Sub

    Private Sub PopulateExportList()
        'The previously selected list gets updated whenever the selection changed event fires
        'on the grid.  Clearing the grid fires the selection changed event, and this was
        'making the previously selected list empty.  To fix this, we created a boolean to 
        'track when we should be updating the list.  We don't update it after clearing the grid.
        mPreviouslySelectedListNeedsUpdate = False
        Me.ExportSetsGrid.Rows.Clear()

        mPreviouslySelectedListNeedsUpdate = True
        Me.mMasterList.Clear()

        If Me.mNavigator.ShowAllFiles = True Then
            For Each export As ScheduledExport In ScheduledExport.GetAll(Me.FilterStartDate.Value, Me.FilterEndDate.Value)
                mMasterList.Add(export.Id, export)
            Next
        Else
            Dim clients As Collection(Of Client) = Me.mNavigator.SelectedClients
            Dim studies As Collection(Of Study) = Me.mNavigator.SelectedStudies
            Dim surveys As Collection(Of Survey) = Me.mNavigator.SelectedSurveys

            If clients.Count > 0 Then
                For Each selectedClient As Client In clients
                    Dim tmpList As Collection(Of ScheduledExport)
                    tmpList = ScheduledExport.GetByClientId(selectedClient.Id, Me.FilterStartDate.Value, Me.FilterEndDate.Value)
                    For Each export As ScheduledExport In tmpList
                        If Not mMasterList.ContainsKey(export.Id) Then mMasterList.Add(export.Id, export)
                    Next
                Next
            End If

            If studies.Count > 0 Then
                For Each selectedstudy As Study In studies
                    Dim tmpList As Collection(Of ScheduledExport)
                    tmpList = ScheduledExport.GetByStudyId(selectedstudy.Id, Me.FilterStartDate.Value, Me.FilterEndDate.Value)
                    For Each export As ScheduledExport In tmpList
                        If Not mMasterList.ContainsKey(export.Id) Then mMasterList.Add(export.Id, export)
                    Next
                Next
            End If

            If surveys.Count > 0 Then
                For Each selectedsurvey As Survey In surveys
                    Dim tmpList As Collection(Of ScheduledExport)
                    tmpList = ScheduledExport.GetBySurveyId(selectedsurvey.Id, Me.FilterStartDate.Value, Me.FilterEndDate.Value)
                    For Each export As ScheduledExport In tmpList
                        If Not mMasterList.ContainsKey(export.Id) Then mMasterList.Add(export.Id, export)
                    Next
                Next
            End If
        End If

        Me.FillExportSetList(mMasterList)
        'Me.ExistingExportsGrid.Sort()
    End Sub

    Private Sub FillExportSetList(ByVal scheduledExports As Dictionary(Of Integer, ScheduledExport))
        Dim items(9) As String
        Dim srvy As Survey
        Dim unit As SampleUnit
        Dim newIndex As Integer
        Dim unduplicatedList As New Dictionary(Of Integer, ExportSet)

        For Each export As ScheduledExport In scheduledExports.Values
            For Each scheduledSet As ExportSet In export.ExportSets
                If Not unduplicatedList.ContainsKey(scheduledSet.Id) Then unduplicatedList.Add(scheduledSet.Id, scheduledSet)
            Next
        Next

        RemoveHandler ExportSetsGrid.SelectionChanged, AddressOf Me.ExportSetsGrid_SelectionChanged
        Me.ExportSetsGrid.ClearSelection()

        For Each expSet As ExportSet In unduplicatedList.Values
            srvy = Me.mNavigator.FindSurvey(expSet.SurveyId)
            unit = SampleUnit.Get(expSet.SampleUnitId)
            items(0) = srvy.Study.Client.DisplayLabel
            items(1) = srvy.Study.DisplayLabel
            items(2) = srvy.DisplayLabel
            If unit IsNot Nothing Then
                items(3) = unit.DisplayLabel
            Else
                items(3) = "All"
            End If
            items(4) = expSet.Name
            items(5) = expSet.CreatedDate.ToString
            items(6) = expSet.StartDate.ToShortDateString
            items(7) = expSet.EndDate.ToShortDateString
            items(8) = expSet.ExportSetType.ToString
            items(9) = expSet.ReportDateField

            newIndex = Me.ExportSetsGrid.Rows.Add(items)
            Me.ExportSetsGrid.Rows(newIndex).Tag = expSet

            'If they have updated or deleted a scheduled export file, then we need to
            'refresh the list of export sets.  We also want to reselect the same 
            'export sets as before.  If they have changed filter settings or changed their
            'selection in the tree, then IsPreviouslySelectedExportSet should return false
            'for all export sets so that nothing is selected
            If IsPreviouslySelectedExportSet(expSet) Then
                Me.ExportSetsGrid.Rows(newIndex).Selected = True
            Else
                Me.ExportSetsGrid.Rows(newIndex).Selected = False
            End If
        Next

        AddHandler ExportSetsGrid.SelectionChanged, AddressOf Me.ExportSetsGrid_SelectionChanged

        'If no rows were previously selected, then select the first
        If Me.ExportSetsGrid.SelectedRows.Count = 0 AndAlso Me.ExportSetsGrid.Rows.Count > 0 Then Me.ExportSetsGrid.Rows(0).Selected = True

        PopulateScheduledExportGrid()
    End Sub

    Private Function IsPreviouslySelectedExportSet(ByVal expSet As ExportSet) As Boolean
        Dim previouslySelectedSet As ExportSet
        For Each previouslySelectedSet In Me.mPreviouslySelectedExportSetsList
            If previouslySelectedSet.Id = expSet.Id Then
                Return True
            End If
        Next

        Return False
    End Function

    Private Sub PopulateScheduledExportGrid()
        Dim items(7) As Object
        Dim newIndex As Integer
        Dim scheduledExports As New Collection(Of ScheduledExport)
        Dim scheduledExportSelected As Boolean

        Me.ScheduledExportDataGridView.Rows.Clear()

        'Determine all of the unique files that need to be displayed
        For Each export As ScheduledExport In Me.mMasterList.Values
            scheduledExportSelected = False
            For Each scheduledSet As ExportSet In export.ExportSets
                For Each expSet As ExportSet In Me.mPreviouslySelectedExportSetsList
                    If scheduledSet.Id = expSet.Id Then
                        scheduledExports.Add(export)
                        scheduledExportSelected = True
                    End If
                    If scheduledExportSelected Then Exit For
                Next
                If scheduledExportSelected Then Exit For
            Next
        Next

        For Each export As ScheduledExport In scheduledExports
            items(0) = export.RunDate.ToShortDateString
            items(1) = export.IncludeOnlyReturns
            items(2) = export.IncludeOnlyDirects
            items(3) = export.ExportFileType.ToString
            items(4) = export.ScheduledDate
            items(5) = export.ScheduledBy


            Dim exportSetsString As String = ""
            For Each eSet As ExportSet In export.ExportSets
                exportSetsString += eSet.Name + ","
            Next
            items(6) = exportSetsString.Substring(0, exportSetsString.Length - 1)

            items(7) = export.ExportFileName.ToString

            newIndex = Me.ScheduledExportDataGridView.Rows.Add(items)
            Me.ScheduledExportDataGridView.Rows(newIndex).Tag = export
        Next

        'Select the first row
        Me.ScheduledExportDataGridView.ClearSelection()
        If Me.ScheduledExportDataGridView.Rows.Count > 0 Then Me.ScheduledExportDataGridView.Rows(0).Selected = True
    End Sub

    Private Function GetLastQuarterStartDate() As Date
        Dim qtrStart As Date = Date.Now
        qtrStart = qtrStart.AddMonths(-3)
        Dim qtrMonth As Integer = CType(Math.Ceiling(qtrStart.Month / 3), Integer)
        qtrMonth = (qtrMonth * 3) - 2

        Return Date.Parse(String.Format("{0}/1/{1}", qtrMonth, qtrStart.Year))
    End Function

    Private Sub DeselectAllRows(ByVal selectedGrid As DataGridView)
        Dim rowList As New List(Of DataGridViewRow)
        For Each row As DataGridViewRow In selectedGrid.SelectedRows
            rowList.Add(row)
        Next
        For Each row As DataGridViewRow In rowList
            row.Selected = False
        Next
    End Sub


    Private Sub GridMouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs, ByVal selectedGrid As DataGridView)
        'Need to do some special handling when user right-clicks the datagridview
        If e.Button = Windows.Forms.MouseButtons.Right Then
            Dim hitInfo As DataGridView.HitTestInfo
            hitInfo = selectedGrid.HitTest(e.X, e.Y)
            If hitInfo.Type = DataGridViewHitTestType.Cell Then
                Dim row As DataGridViewRow = selectedGrid.Rows(hitInfo.RowIndex)
                If Not row.Selected Then
                    If (Control.ModifierKeys And Keys.Control) = Keys.Control Then
                        row.Selected = True
                    Else
                        Me.DeselectAllRows(selectedGrid)
                        row.Selected = True
                    End If
                End If
            End If
        End If
    End Sub

#End Region

End Class
