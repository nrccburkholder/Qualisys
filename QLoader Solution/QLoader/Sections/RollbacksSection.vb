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

End Class
