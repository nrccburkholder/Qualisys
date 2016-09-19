Imports Nrc.Qualisys.Library
Imports System.Collections.ObjectModel

Public Class RollbacksSection

    Private WithEvents mPackageNavigator As PackageNavigator
    Private mStudyId As Integer


#Region " Base Class Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mPackageNavigator = TryCast(navCtrl, PackageNavigator)
        If mPackageNavigator Is Nothing Then
            Throw New ArgumentException("The Unsampled Datasets section control expects a navigator of type 'PackageNavigator'")
        End If

    End Sub

    Public Overrides Sub ActivateSection()

        If mPackageNavigator IsNot Nothing Then
            AddHandler Application.Idle, AddressOf IdleEvent
            AddHandler mPackageNavigator.SelectedNodeChanged, AddressOf mPackageNavigator_SelectedNodeChanged
            mPackageNavigator.AllowMultiSelect = False
            mPackageNavigator.RefreshTree(ClientTreeTypes.AllStudiesNoPackages)
            mPackageNavigator.TreeContextMenu = Nothing
        End If

    End Sub

    Public Overrides Sub InactivateSection()

        If mPackageNavigator IsNot Nothing Then
            RemoveHandler mPackageNavigator.SelectedNodeChanged, AddressOf mPackageNavigator_SelectedNodeChanged
            mPackageNavigator.TreeContextMenu = Nothing
        End If

    End Sub

#End Region

    Private Sub mPackageNavigator_SelectedNodeChanged(ByVal sender As Object, ByVal e As SelectedNodeChangedEventArgs)

        Try
            ParentForm.Cursor = Cursors.WaitCursor

            mStudyId = e.SelectedNode.StudyID
            PopulateDatasetGrid()
            PopulateRollbackGrid()

        Finally
            ParentForm.Cursor = Cursors.Default

        End Try

    End Sub

    Private Sub PopulateDatasetGrid()

        'Clear existing datasets
        DatasetGridView.Rows.Clear()

        If Not mStudyId > 0 Then
            Exit Sub
        End If

        'Get the list of datasets
        Dim datasets As Collection(Of StudyDataset) = GetUnsampledDataSets(mStudyId)

        'Clear any date columns we may have added
        While DatasetGridView.Columns.Count > 3
            DatasetGridView.Columns.RemoveAt(3)
        End While

        'Get a listing of all date fields in the study
        Dim allStudyDateFields As New Dictionary(Of Integer, StudyTableColumn)
        Dim studyTables As Collection(Of StudyTable) = StudyTable.GetAllStudyTables(mStudyId)
        For Each tbl As StudyTable In studyTables
            If Not tbl.IsView AndAlso tbl.Name.ToUpper = "ENCOUNTER" Then
                For Each col As StudyTableColumn In tbl.Columns
                    If col.IsUserField AndAlso col.DataType = StudyTableColumnDataTypes.DateTime Then
                        If Not allStudyDateFields.ContainsKey(col.Id) Then
                            allStudyDateFields.Add(col.Id, col)
                        End If
                    End If
                Next
            End If
        Next

        'Get a list of date field IDs and field names for the datsets date ranges
        Dim cutoffFields As New Dictionary(Of Integer, String)
        For Each ds As StudyDataset In datasets
            For Each range As StudyDatasetDateRange In ds.DateRanges
                If Not cutoffFields.ContainsKey(range.FieldId) Then
                    If allStudyDateFields.ContainsKey(range.FieldId) Then
                        cutoffFields.Add(range.FieldId, allStudyDateFields(range.FieldId).Name)
                    End If
                End If
            Next
        Next

        'Add the date columns
        Dim columns As New Dictionary(Of Integer, DataGridViewTextBoxColumn())
        For Each fieldId As Integer In cutoffFields.Keys
            Dim cols(1) As DataGridViewTextBoxColumn
            cols(0) = New DataGridViewTextBoxColumn
            cols(0).HeaderText = "Min " & cutoffFields(fieldId)
            cols(0).AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
            cols(0).ValueType = GetType(Date)

            cols(1) = New DataGridViewTextBoxColumn
            cols(1).HeaderText = "Max " & cutoffFields(fieldId)
            cols(1).AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
            cols(1).ValueType = GetType(Date)

            DatasetGridView.Columns.Add(cols(0))
            DatasetGridView.Columns.Add(cols(1))

            columns.Add(fieldId, cols)
        Next

        'For each dataset...
        If datasets.Count = 0 Then
            'NoDataSetsLabel.Visible = True
        Else
            'NoDataSetsLabel.Visible = False
            For Each ds As StudyDataset In datasets
                'Add a row with all the dataset info

                Dim i As Integer = DatasetGridView.Rows.Add(ds.Id, ds.DateLoaded, ds.RecordCount)

                'Tag the row with the dataset
                Dim row As DataGridViewRow = DatasetGridView.Rows(i)
                row.Tag = ds

                'For each cutoff date field we need to display
                For Each fieldId As Integer In columns.Keys
                    'Get the two columns (min and max)
                    Dim cols() As DataGridViewTextBoxColumn = columns(fieldId)

                    'Find the right field in the DataSetDateRange collection
                    For Each range As StudyDatasetDateRange In ds.DateRanges
                        If range.FieldId = fieldId Then
                            'Populate the cells with the dates
                            If range.MinimumDate <> Date.MinValue Then
                                row.Cells(cols(0).Index).Value = range.MinimumDate.ToShortDateString
                                row.Cells(cols(1).Index).Value = range.MaximumDate.ToShortDateString
                            End If
                        End If
                    Next
                Next
            Next
        End If

        DatasetGridView.Sort(DatasetCreationColumn, System.ComponentModel.ListSortDirection.Descending)
        DeleteDatasetButton.Enabled = (DatasetGridView.Rows.Count > 0)

    End Sub

    Private Function GetUnsampledDataSets(ByVal studyId As Integer) As Collection(Of StudyDataset)

        Dim list As Collection(Of StudyDataset) = StudyDataset.GetByStudyId(studyId, Date.Today.AddYears(-1), Date.Today)
        Dim unsampledList As New Collection(Of StudyDataset)

        For Each ds As StudyDataset In list
            If Not ds.HasBeenSampled Then
                unsampledList.Add(ds)
            End If
        Next

        Return unsampledList

    End Function

    Private Sub InitializeColumnSortTypes()

        DatasetIdColumn.ValueType = GetType(Integer)
        DatasetRecordsColumn.ValueType = GetType(Integer)
        DatasetCreationColumn.ValueType = GetType(Date)

    End Sub

    Private Sub DeleteDatasetButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteDatasetButton.Click

        Try
            'Show wait
            Cursor = Cursors.WaitCursor

            If DatasetGridView.SelectedRows.Count = 1 Then
                Dim ds As StudyDataset = TryCast(DatasetGridView.SelectedRows(0).Tag, StudyDataset)
                If ds IsNot Nothing Then
                    'Perform the roll-back
                    ds.Delete()

                    'Mark the data files as rolled back
                    DataFile.RollbackDataFiles(ds.Id, CurrentUser)

                    'Repopulate the grid
                    PopulateDatasetGrid()
                End If
            End If

        Catch ex As DatasetRollbackException
            'Show friendly message
            MessageBox.Show(ex.Message, "Error Deleting Dataset", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub RefreshButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshButton.Click

        Try
            ParentForm.Cursor = Cursors.WaitCursor
            PopulateDatasetGrid()

        Finally
            ParentForm.Cursor = DefaultCursor

        End Try

    End Sub

    Private Sub PopulateRollbackGrid()

        'Clear existing datasets
        RollbackGridView.Rows.Clear()

        If Not mStudyId > 0 Then
            Exit Sub
        End If

        Dim drgUpdateCollection As Collection(Of DRGUpdate) = DRGUpdate.SelectDRGUpdates(mStudyId)

        bsDRGUpdate.DataSource = drgUpdateCollection

        RollbackGridView.AutoGenerateColumns = True

        With RollbackGridView
            .Columns(0).HeaderText = "DataFile ID"
            .Columns(1).HeaderText = "Study ID"
            .Columns(2).HeaderText = "Original File Name"
            .Columns(3).HeaderText = "Min Encounter Date"
            .Columns(4).HeaderText = "Max Encounter Date"
            .Columns(5).HeaderText = "User"
            .Columns(6).HeaderText = "Member ID"
            .Columns(7).HeaderText = "Rolled Back"
            .Columns(8).HeaderText = "Status"
            .ColumnHeadersDefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter
            .AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells

            .Columns(6).Visible = False
            .Columns(7).Visible = False
        End With

    End Sub

    Private Sub RollbackGridView_CellFormatting(sender As Object, e As DataGridViewCellFormattingEventArgs) Handles RollbackGridView.CellFormatting

        Dim gridView As DataGridView = DirectCast(sender, DataGridView)

        If e.ColumnIndex = gridView.Columns("Status").Index Then
            If e.Value.ToString = "DRGRolledBack" Then
                gridView.Rows(e.RowIndex).DefaultCellStyle.BackColor = System.Drawing.Color.FromArgb(242, 243, 244)
                gridView.Rows(e.RowIndex).DefaultCellStyle.ForeColor = Color.DarkGray
            Else
                gridView.Rows(e.RowIndex).DefaultCellStyle.BackColor = Nothing
                gridView.Rows(e.RowIndex).DefaultCellStyle.ForeColor = Color.Black
            End If
        End If

    End Sub

    Private Sub RollbackGridView_SelectionChanged(sender As Object, e As EventArgs) Handles RollbackGridView.SelectionChanged

        Dim gridView As DataGridView = DirectCast(sender, DataGridView)

        If gridView.CurrentRow IsNot Nothing Then

            Dim isRolledBack As Boolean = CBool(gridView.CurrentRow.Cells("IsRollback").Value)

            If isRolledBack Then
                gridView.CurrentRow.Selected = False
            End If
        End If

    End Sub

    Private Sub RollbackGridView_DataBindingComplete(sender As Object, e As DataGridViewBindingCompleteEventArgs) Handles RollbackGridView.DataBindingComplete
        Dim gridView As DataGridView
        gridView = CType(sender, DataGridView)
        gridView.ClearSelection()
    End Sub

    Private Sub RefreshDRGButton_Click(sender As Object, e As EventArgs) Handles RefreshDRGButton.Click
        PopulateRollbackGrid()
        lbDRGResults.Items.Clear()
    End Sub

    Private Sub RollbackButton_Click(sender As Object, e As EventArgs) Handles RollbackButton.Click

        DoDRGRollback()

    End Sub

    Public Sub IdleEvent(ByVal sender As System.Object, ByVal e As System.EventArgs)

        RollbackButton.Enabled = RollbackGridView.SelectedRows.Count > 0

    End Sub

    Private Sub DoDRGRollback()

        Try
            'Show wait
            Cursor = Cursors.WaitCursor

            lbDRGResults.Items.Clear()

            If RollbackGridView.SelectedRows.Count > 0 Then

                Dim logString As List(Of String) = New List(Of String)
                For Each dgrow As DataGridViewRow In RollbackGridView.SelectedRows

                    Dim drg As DRGUpdate = DirectCast(dgrow.DataBoundItem, DRGUpdate)

                    Dim dt As DataTable = DRGUpdate.RollbackDRGUpdates(drg)  ' the resulting datatable contain the log information

                    If dt IsNot Nothing Then
                        For Each dr As DataRow In dt.Rows
                            logString.Add(String.Format("{0}: {1}", dr(0).ToString, dr(1).ToString))
                        Next
                    End If

                    Dim state_id As Integer = DataFileStates.DRGRolledBack
                    Dim stateparameter As String = String.Format("Rolled back by {0}", CurrentUser.LoginName)
                    Dim memberId As Integer = CurrentUser.MemberId
                    Dim statedescription As String = [Enum].GetName(GetType(DataFileStates), state_id)
                    DRGUpdate.UpdateFileState(drg.DataFileID, state_id, stateparameter, statedescription, memberId)

                Next

                For Each s As String In logString
                    lbDRGResults.Items.Add(s)
                Next

                PopulateRollbackGrid()

            End If

        Catch ex As Exception
            'Show friendly message
            MessageBox.Show(ex.Message, "Error Rolling Back Update(s)", MessageBoxButtons.OK, MessageBoxIcon.Error)

        Finally
            Cursor = DefaultCursor

        End Try

    End Sub

End Class
