Imports Nrc.Qualisys.Library
Imports Nrc.Qualisys.SamplingTool.ODSDBDataAccess
Imports System.Linq

Public Class NewSampleDefinition

    Private mSurveys As Collection(Of Survey)
    Private mIsSampling As Boolean
    Private mIsClearing As Boolean = False
    Private mHoldTable As DataTable
    Private mIsHoldsAccessible As Boolean = True

    Private dragBoxFromMouseDown As Rectangle
    Private rowIndexFromMouseDown As Integer
    Private rowUnderDrag As DataGridViewRow
    Private mSampleDefinitions As Collection(Of SampleDefinition)
    Private mIsActiveHold As Boolean = False
    Private odsdb As ODSDBRepository

    Private WithEvents mDataSetFilterStartDate As ToolStripDateTimePicker
    Private WithEvents mDataSetFilterEndDate As ToolStripDateTimePicker
    Public Event SampleCompleted As EventHandler

#Region " Constructors "

    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        odsdb = New ODSDBRepository()

        ' Add any initialization after the InitializeComponent() call.
        Me.InitializeDataSetToolStrip()
        Me.InitializeColumnSortTypes()
        Me.InitializeSampleSeedSpecifier()

    End Sub

#End Region

#Region " Public Properties "

    Public ReadOnly Property IsSampling() As Boolean
        Get
            Return Me.mIsSampling
        End Get
    End Property

#End Region

#Region "Private Properties"

    Private ReadOnly Property IsSamplingButtonEnabled() As Boolean
        Get
            Return Me.GetSelectedDatasets.Count > 0 And mIsHoldsAccessible = True
        End Get
    End Property

#End Region


#Region " Public Methods "

    Public Sub Populate(ByVal surveys As Collection(Of Survey))

        'Store the survey list
        Me.mSurveys = surveys

        If mHoldTable IsNot Nothing Then
            mHoldTable.Clear()
        End If

        'Populate dataset list
        If mSurveys.Count > 0 Then

            'Populate the HoldSheet datatable for selected surveys
            Try
                PopulateHoldTable(mSurveys)
            Catch ex As Exception
                Globals.ReportException(ex)
            End Try


            Me.PopulateDatasets(mSurveys(0).Study)

        Else
            Me.DatasetGridView.Rows.Clear()
            Me.SampleButton.Enabled = False
            Me.SampleSeedSpecifiedTextBox.Enabled = False
        End If

        'Populate existing sample set list
        Me.PopulateNewSampleSets(mSurveys)

        SetHoldStatusButton()

    End Sub

    Public Sub RefreshNewSampleDefinition()

        Me.PopulateDatasets(mSurveys(0).Study)
        Me.RefreshNewSampleDataGridView()

    End Sub

#End Region

#Region " Control Event Handlers "

    Private Sub NewSampleGridView_Sorted(ByVal sender As Object, ByVal e As System.EventArgs) Handles NewSampleGridView.Sorted

        Me.PopulateNewSampleRowNumbers()

    End Sub

    Private Sub DatasetDate_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles mDataSetFilterStartDate.KeyUp, mDataSetFilterEndDate.KeyUp

        If e.KeyCode = System.Windows.Forms.Keys.Enter Then
            Me.PopulateDatasets(mSurveys(0).Study)
        End If

    End Sub

    Private Sub SampleButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SampleButton.Click

        Dim sampleDef As SampleDefinition
        Dim isOverSample As Boolean = False
        Dim surveyIDs As New System.Text.StringBuilder

        'Calling it at this point to ensure validation of seed value
        GetSpecificSampleSeed()

        'Set the wait cursor
        Me.Cursor = Cursors.WaitCursor
        Me.NewSampleGridView.Cursor = Cursors.WaitCursor
        Me.mIsSampling = True
        Me.SampleProgressBar.Visible = True
        Me.SampleStatusLabel.Visible = True
        Me.SampleProgressBar.Maximum = Me.NewSampleGridView.Rows.Count
        Me.SampleProgressBar.Value = 0
        Me.SampleStatusLabel.Text = ""
        Me.SampleButton.Enabled = False
        Me.SampleSeedSpecifiedTextBox.Enabled = False
        Me.NewSampleGridView.Enabled = False

        'Collect all the rows into a collection and build a list of survey ids
        mSampleDefinitions = New Collection(Of SampleDefinition)
        For Each row As DataGridViewRow In Me.NewSampleGridView.Rows
            'Create an object from the grid row and add it to the collection
            sampleDef = New SampleDefinition(Me, row)

            'Add this sample definition to the collection
            If sampleDef.Survey.CheckMedicareProportion Then 'IsHCAHPS Then 'Possible TODO: create separate property for CheckMedicareProportion CJB 7/3/2014
                'This is an HCAHPS survey so recalculate the Medicare Proportion(s)
                If sampleDef.RecalcMedicareProportion() Then
                    'Recalculation succeeded so add the sample definition to the collection
                    mSampleDefinitions.Add(sampleDef)

                    'Add this survey id to the list to be checked for sampling locks
                    surveyIDs.Append(sampleDef.Survey.Id)
                    If row.Index < NewSampleGridView.Rows.Count - 1 Then
                        surveyIDs.Append(",")
                    End If
                End If
            Else
                'This is not an HCAHPS survey so just add it to the collection
                mSampleDefinitions.Add(sampleDef)
            End If
        Next


        'check the SampleDefinitions to see if there is a holdlock

        Try
            Dim holdSampleDefs As New List(Of SampleDefinition)
            For Each sampleDef In mSampleDefinitions
                Dim encounterHoldDate As Date = GetMinEncounterHoldDate(sampleDef.Survey)
                If encounterHoldDate <> Date.MinValue Then
                    If sampleDef.StartDate >= encounterHoldDate Or sampleDef.EndDate >= encounterHoldDate Then
                        ' this one cannot be sampled
                        holdSampleDefs.Add(sampleDef)
                    End If
                End If
            Next

            If holdSampleDefs.Count > 0 Then
                ' there is a hold lock on one or more sampledefinitions
                ShowHoldsDialog()
                RemoveOnHoldSamplesFromSampleDefinitions(holdSampleDefs)
            End If
        Catch ex As Exception
            Globals.ReportException(ex)
            Exit Sub
        End Try
        


        'If we have any locked samples then show them and remove them from the
        '  mSampleDefinitions collection so that they don't get sampled.
        Dim lockedSamples As DataTable = MedicareNumber.GetSamplingLockedBySurveyIDs(surveyIDs.ToString)
        If lockedSamples IsNot Nothing AndAlso lockedSamples.Rows.Count > 0 Then
            'Display the dialog
            Dim lockedSamplesDialog As New LockedSamplesDialog(lockedSamples)
            lockedSamplesDialog.ShowDialog()

            'Remove the locked samples from the sampledefinitions collection
            RemoveLockedSamplesFromSampleDefinitions(lockedSamples)
        End If

        'Determine if any of the remaining sample definitions are oversamples
        For Each sampleDef In mSampleDefinitions
            If sampleDef.IsOverSample Then
                isOverSample = True
                Exit For
            End If
        Next

        'If we have any oversamples then we need to ask the user if they want to run the oversample
        '  If the user choses to run the oversample and it is an HCAHPS survey then we also ask if 
        '  they want to sample the HCAHPS units
        If isOverSample Then
            Dim overSampleDlg As New OverSampleDialog(mSampleDefinitions)
            If overSampleDlg.ShowDialog() = DialogResult.Cancel Then
                Me.Cursor = Cursors.Default
                Me.NewSampleGridView.Cursor = Cursors.Default
                Me.mIsSampling = False
                Me.SampleProgressBar.Visible = False
                Me.SampleStatusLabel.Visible = False
                Me.SampleButton.Enabled = True
                Me.SampleSeedSpecifiedTextBox.Enabled = True
                Me.NewSampleGridView.Enabled = True
                Exit Sub
            End If
        End If

        Try
            Me.SampleWorker.RunWorkerAsync()

        Catch ex As Exception
            ReportException(ex)

        End Try

    End Sub

    Private Sub RemoveLockedSamplesFromSampleDefinitions(ByVal lockedSamples As DataTable)

        For Each lockedSampleRow As DataRow In lockedSamples.Rows
            Dim i As Integer = 0
            Dim surveyID As Integer = CInt(lockedSampleRow("Survey_id"))

            While i < mSampleDefinitions.Count
                Dim sampleDefRow As SampleDefinition = mSampleDefinitions(i)
                If sampleDefRow.Survey.Id = surveyID Then
                    sampleDefRow.RowErrorText = "Sample Not Executed Due To Medicare Sample Lock."
                    mSampleDefinitions.RemoveAt(i)
                Else
                    i += 1
                End If
            End While
        Next

    End Sub

    Private Sub FilterDatasetsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterDatasetsButton2.Click

        Me.PopulateDatasets(mSurveys(0).Study)

    End Sub

    Private Sub DataGridViewComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)

        Dim cb As ComboBox = CType(sender, ComboBox)
        Dim currentCell As DataGridViewCell = NewSampleGridView.CurrentCell

        If currentCell.ColumnIndex = Me.NewSampleSetPeriodColumn.Index Then
            currentCell.Value = cb.SelectedValue

            Dim row As DataGridViewRow = Me.NewSampleGridView.Rows(currentCell.RowIndex)
            Dim period As SamplePeriod = SampleDefinition.GetSelectedPeriod(currentCell)
            Me.PopulateNewSamplePeriodInfo(row, period)
        End If

    End Sub

    Public Sub DataGridViewCheckBox_CheckedChanged(ByVal cell As DataGridViewCheckBoxCell)

        'Handle the SpecifyDates column 
        Dim isChecked As Boolean = DirectCast(cell.Value, Boolean)

        If cell.ColumnIndex = Me.DatasetSelectedColumn.Index Then
            Me.SampleButton.Enabled = Me.IsSamplingButtonEnabled
            Me.SampleSeedSpecifiedTextBox.Enabled = Me.IsSamplingButtonEnabled
        End If

        If cell.ColumnIndex = Me.NewSampleSetSpecifyDatesColumn.Index Then
            Me.ToggleNewSampleSpecifyDates(isChecked, Me.NewSampleGridView.CurrentRow)
        End If

    End Sub

    Private Sub DataSetGridView_CurrentCellDirtyStateChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles DatasetGridView.CurrentCellDirtyStateChanged

        'If this is a checkbox cell then commit changes right away so we can handle 
        'call the checkChanged event
        Dim checkBoxCell As DataGridViewCheckBoxCell = TryCast(Me.DatasetGridView.CurrentCell, DataGridViewCheckBoxCell)
        If checkBoxCell IsNot Nothing Then
            Me.DatasetGridView.CommitEdit(DataGridViewDataErrorContexts.Commit)
            Me.DataGridViewCheckBox_CheckedChanged(checkBoxCell)
        End If

    End Sub

    Private Sub NewSampleGridView_CellValidating(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellValidatingEventArgs) Handles NewSampleGridView.CellValidating

        If e.ColumnIndex = Me.NewSampleSetStartDateColumn.Index OrElse e.ColumnIndex = Me.NewSampleSetEndDateColumn.Index Then
            Dim row As DataGridViewRow = Me.NewSampleGridView.Rows(e.RowIndex)
            Dim cell As DataGridViewCell = row.Cells(e.ColumnIndex)
            Dim sampPeriod As SamplePeriod = SampleDefinition.GetSelectedPeriod(row.Cells(Me.NewSampleSetPeriodColumn.Index))
            row.Cells(Me.NewSampleSetSpecifyDatesColumn.Index).ErrorText = ""

            If CType(row.Cells(Me.NewSampleSetSpecifyDatesColumn.Index).Value, Boolean) = True Then
                Dim selectedDate As Date = CType(e.FormattedValue, Date)
                If sampPeriod.ExpectedStartDate.HasValue Then
                    If selectedDate < sampPeriod.ExpectedStartDate.Value OrElse selectedDate > sampPeriod.ExpectedEndDate.Value Then
                        row.Cells(Me.NewSampleSetSpecifyDatesColumn.Index).ErrorText = "You must specify a date within the period start and end dates"
                        e.Cancel = True
                    End If
                End If
            End If
        End If

    End Sub

    Private Sub NewSampleGridView_RowValidating(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles NewSampleGridView.RowValidating

        Dim row As DataGridViewRow = Me.NewSampleGridView.Rows(e.RowIndex)

        If mIsClearing Then Exit Sub

        For Each cell As DataGridViewCell In row.Cells
            If Not String.IsNullOrEmpty(cell.ErrorText) Then
                e.Cancel = True
                Exit For
            End If
        Next

    End Sub

    Private Sub NewSampleGridView_CurrentCellDirtyStateChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles NewSampleGridView.CurrentCellDirtyStateChanged

        'If this is a checkbox cell then commit changes right away so we can handle 
        'call the checkChanged event
        Dim checkBoxCell As DataGridViewCheckBoxCell = TryCast(Me.NewSampleGridView.CurrentCell, DataGridViewCheckBoxCell)
        If checkBoxCell IsNot Nothing Then
            Me.NewSampleGridView.CommitEdit(DataGridViewDataErrorContexts.Commit)
            Me.DataGridViewCheckBox_CheckedChanged(checkBoxCell)
            Exit Sub
        End If

        'If this is a date cell then commit changes right away so we can handle 
        'call the copy to all rows option
        Dim dateCell As CalendarCell = TryCast(Me.NewSampleGridView.CurrentCell, CalendarCell)
        If dateCell IsNot Nothing Then
            Me.NewSampleGridView.CommitEdit(DataGridViewDataErrorContexts.Commit)
        End If

    End Sub

    Private Sub NewSampleGridView_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles NewSampleGridView.EditingControlShowing

        Dim cmbBox As ComboBox = TryCast(e.Control, ComboBox)

        If cmbBox IsNot Nothing Then
            RemoveHandler cmbBox.SelectionChangeCommitted, AddressOf DataGridViewComboBox_SelectedIndexChanged
            AddHandler cmbBox.SelectionChangeCommitted, AddressOf DataGridViewComboBox_SelectedIndexChanged
        End If

    End Sub

    Private Sub SampleWorker_DoWork(ByVal sender As Object, ByVal e As System.ComponentModel.DoWorkEventArgs) Handles SampleWorker.DoWork

        'Get a list of selected data set objects
        Dim datasets As Collection(Of StudyDataset) = Me.GetSelectedDatasets
        Dim sampleCount As Integer = 1

        For Each sampleDef As SampleDefinition In mSampleDefinitions
            'Report Progress
            SampleWorker.ReportProgress(sampleCount)

            'Verify that the survey is still validated
            sampleDef.Survey.Refresh()
            If Not sampleDef.Survey.IsValidated Then
                sampleDef.RowErrorText = "This survey has been unvalidated since the tree was last refreshed."
            Else
                If sampleDef.IsOverSample AndAlso Not sampleDef.DoOverSample Then
                    sampleDef.RowErrorText = "You chose not to oversample this survey."
                Else
                    Dim specificSampleSeed As Integer = GetSpecificSampleSeed()
                    'Create the sample set
                    sampleDef.Period.CreateSampleSet(datasets, sampleDef.StartDate, sampleDef.EndDate, CurrentUser.Employee, sampleDef.DoHCAHPSOverSample, specificSampleSeed)
                End If
            End If

            'Increment count
            sampleCount += 1
        Next

    End Sub

    Private Sub SampleWorker_ProgressChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ProgressChangedEventArgs) Handles SampleWorker.ProgressChanged

        Me.SampleProgressBar.Value = e.ProgressPercentage
        Me.SampleStatusLabel.Text = String.Format("Creating sample {0} of {1}", e.ProgressPercentage, Me.NewSampleGridView.Rows.Count)
        Me.NewSampleGridView.Rows(e.ProgressPercentage - 1).DefaultCellStyle.ForeColor = Color.Gray

    End Sub

    Private Sub SampleWorker_RunWorkerCompleted(ByVal sender As Object, ByVal e As System.ComponentModel.RunWorkerCompletedEventArgs) Handles SampleWorker.RunWorkerCompleted

        'Reset cursor
        'Me.ParentForm.Cursor = Cursors.Default
        Me.Cursor = Me.DefaultCursor
        Me.NewSampleGridView.Cursor = Me.DefaultCursor
        Me.SampleProgressBar.Visible = False
        Me.NewSampleGridView.Enabled = True
        Me.SampleStatusLabel.Visible = False
        Me.mIsSampling = False
        RaiseEvent SampleCompleted(Me, EventArgs.Empty)
        If e.Error IsNot Nothing Then
            ReportException(e.Error, "Sampling Error")
        End If

        'Refresh the period information in the sample grid
        RefreshNewSampleDataGridView()

        'Refresh the Datasets grid
        Me.PopulateDatasets(mSurveys(0).Study)

    End Sub

    Private Sub RefreshNewSampleDataGridView()

        'Refresh the period information in the sample grid
        For Each row As DataGridViewRow In Me.NewSampleGridView.Rows
            Dim periodList As DataGridViewComboBoxCell = DirectCast(row.Cells(Me.NewSampleSetPeriodColumn.Index), DataGridViewComboBoxCell)
            Dim srvy As Survey = DirectCast(row.Tag, Survey)

            'Set the value to the first item in the collection before updating the datasourc.
            ' The value must be set to an item that exists in the combobox.  
            'We can be sure the the first item will always be there, since there has to be atleast one
            'Period for a survey.
            row.Cells(Me.NewSampleSetPeriodColumn.Index).Value = Nothing

            'Update the samplePeriods collection on the survey
            srvy.RefreshSamplePeriodsAfterSampling()
            periodList.DataSource = srvy.SampleablePeriods
            row.Cells(Me.NewSampleSetPeriodColumn.Index).Value = srvy.SampleablePeriods(0).Id
            periodList.DisplayMember = "Name"
            periodList.ValueMember = "Id"
            Me.PopulateNewSamplePeriodInfo(row, srvy.ActiveSamplePeriod)
            Me.ToggleNewSampleSpecifyDates(CBool(row.Cells(Me.NewSampleSetSpecifyDatesColumn.Index).Value), row)
        Next

    End Sub

    Private Sub MoveUpButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveUpButton.Click

        Me.MoveRows(1)

    End Sub

    Private Sub MoveDownButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveDownButton.Click

        Me.MoveRows(-1)

    End Sub

    Private Sub SampleDefinitionCopyDatesMenuItem_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleDefinitionCopyDatesMenuItem.Click

        Dim newValue As Object = Me.NewSampleGridView.CurrentCell.Value
        Dim currentColumn As Integer = Me.NewSampleGridView.CurrentCell.ColumnIndex

        For Each row As DataGridViewRow In NewSampleGridView.Rows
            row.Cells(currentColumn).Value = newValue
        Next

    End Sub

    ''' <summary>Selects all items in grid</summary>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK - 10/19/2008 - Initial Creation</revision>
    Private Sub SelectAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectAllButton.Click

        For Each row As DataGridViewRow In Me.DatasetGridView.Rows
            Dim cell As DataGridViewCheckBoxCell = DirectCast(row.Cells(Me.DatasetSelectedColumn.Index), DataGridViewCheckBoxCell)
            cell.Value = True
        Next
        Me.DatasetGridView.RefreshEdit()

    End Sub


    Private Sub DeSelectAllButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeSelectAllButton.Click

        For Each row As DataGridViewRow In Me.DatasetGridView.Rows
            Dim cell As DataGridViewCheckBoxCell = DirectCast(row.Cells(Me.DatasetSelectedColumn.Index), DataGridViewCheckBoxCell)
            cell.Value = False
        Next
        Me.DatasetGridView.RefreshEdit()

    End Sub

    Private Sub HoldStatusButton_Click(sender As Object, e As EventArgs) Handles HoldStatusButton.Click
        ShowHoldsDialog()
    End Sub

#Region " NewSampleGridView Drag and Drop"

    Private Sub NewSampleGridView_MouseMove(ByVal sender As Object, ByVal e As MouseEventArgs) Handles NewSampleGridView.MouseMove

        If ((e.Button And Windows.Forms.MouseButtons.Left) = Windows.Forms.MouseButtons.Left) Then
            ' If the mouse moves outside the rectangle, start the drag.
            If (dragBoxFromMouseDown <> Rectangle.Empty AndAlso Not dragBoxFromMouseDown.Contains(e.X, e.Y)) Then
                'Proceed with the drag and drop, passing in the list item.                    
                Dim dropEffect As DragDropEffects = NewSampleGridView.DoDragDrop(NewSampleGridView.Rows(rowIndexFromMouseDown), DragDropEffects.Move)
            End If
        End If

    End Sub

    Private Sub NewSampleGridView_MouseDown(ByVal sender As Object, ByVal e As MouseEventArgs) Handles NewSampleGridView.MouseDown

        ' Get the index of the item the mouse is below.
        rowIndexFromMouseDown = NewSampleGridView.HitTest(e.X, e.Y).RowIndex
        If (rowIndexFromMouseDown <> -1) Then
            ' Remember the point where the mouse down occurred. 
            ' The DragSize indicates the size that the mouse can move 
            ' before a drag event should be started.                
            Dim dragSize As Size = SystemInformation.DragSize

            ' Create a rectangle using the DragSize, with the mouse position being
            ' at the center of the rectangle.
            dragBoxFromMouseDown = New Rectangle(New Point(e.X - (dragSize.Width \ 2), e.Y - (dragSize.Height \ 2)), dragSize)
        Else
            ' Reset the rectangle if the mouse is not over an item in the ListBox.
            dragBoxFromMouseDown = Rectangle.Empty
        End If

    End Sub

    Private Sub NewSampleGridView_DragOver(ByVal sender As Object, ByVal e As DragEventArgs) Handles NewSampleGridView.DragOver

        e.Effect = DragDropEffects.Move

        Dim clientPoint As Point = NewSampleGridView.PointToClient(New Point(e.X, e.Y))
        Dim index As Integer = NewSampleGridView.HitTest(clientPoint.X, clientPoint.Y).RowIndex()
        Dim row As DataGridViewRow = Me.NewSampleGridView.Rows(index)

        If row IsNot rowUnderDrag Then
            Dim oldIndex As Integer = -1
            If rowUnderDrag IsNot Nothing Then
                oldIndex = rowUnderDrag.Index
            End If
            rowUnderDrag = row
            Me.NewSampleGridView.InvalidateRow(index)
            If oldIndex <> -1 Then
                Me.NewSampleGridView.InvalidateRow(oldIndex)
            End If
        End If

    End Sub

    Private Sub NewSampleGridView_DragDrop(ByVal sender As Object, ByVal e As DragEventArgs) Handles NewSampleGridView.DragDrop

        ' The mouse locations are relative to the screen, so they must be 
        ' converted to client coordinates.
        Dim clientPoint As Point = NewSampleGridView.PointToClient(New Point(e.X, e.Y))

        ' Get the row index of the item the mouse is below. 
        Dim rowIndexOfItemUnderMouseToDrop As Integer = NewSampleGridView.HitTest(clientPoint.X, clientPoint.Y).RowIndex()

        ' If the drag operation was a move then remove and insert the row.
        If (e.Effect = DragDropEffects.Move) Then
            Dim rowToMove As DataGridViewRow = TryCast(e.Data.GetData(GetType(DataGridViewRow)), DataGridViewRow)
            NewSampleGridView.Rows.RemoveAt(rowIndexFromMouseDown)
            NewSampleGridView.Rows.Insert(rowIndexOfItemUnderMouseToDrop, rowToMove)

            Me.PopulateNewSampleRowNumbers()
            Me.NewSampleGridView.ClearSelection()
            rowToMove.Selected = True
            Me.NewSampleGridView.CurrentCell = rowToMove.Cells(0)

            If rowUnderDrag IsNot Nothing Then
                rowUnderDrag = Nothing
            End If
        End If

    End Sub

    Private Sub NewSampleGridView_RowPostPaint(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowPostPaintEventArgs) Handles NewSampleGridView.RowPostPaint

        If Me.NewSampleGridView.Rows(e.RowIndex) Is rowUnderDrag Then
            Dim rowDraggingIndex As Integer = rowIndexFromMouseDown
            Dim rowUnderDragIndex As Integer = rowUnderDrag.Index
            Dim rect As Rectangle

            'If we are over a row below the drag row
            If rowUnderDragIndex > rowDraggingIndex Then
                rect = New Rectangle(e.RowBounds.Left, e.RowBounds.Bottom - 3, e.RowBounds.Width, 3)
            Else
                rect = New Rectangle(e.RowBounds.Left, e.RowBounds.Top, e.RowBounds.Width, 3)
            End If

            e.Graphics.FillRectangle(Brushes.Blue, rect)
        End If

    End Sub

#End Region

#End Region

#Region " Private Methods "

    ''' <summary>
    ''' Adds the date filters for datasets to the newSampleset tool strip
    ''' </summary>
    ''' <remarks></remarks>
    Private Sub InitializeDataSetToolStrip()

        Dim endDate As Date = Date.Today
        Dim startDate As Date = endDate.AddDays(-14)
        Dim lbl As ToolStripLabel

        'First remove the datasets filter button.  We will readd at the end
        Me.DatasetsToolStrip.Items.Clear()

        lbl = New ToolStripLabel("Datasets created between")
        lbl.Alignment = ToolStripItemAlignment.Left
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.DatasetsToolStrip.Items.Add(lbl)

        mDataSetFilterStartDate = New ToolStripDateTimePicker
        mDataSetFilterStartDate.Format = DateTimePickerFormat.Short
        mDataSetFilterStartDate.Alignment = ToolStripItemAlignment.Left
        mDataSetFilterStartDate.Overflow = ToolStripItemOverflow.Never
        mDataSetFilterStartDate.ToolTipText = "Start Date"
        mDataSetFilterStartDate.Value = startDate
        Me.DatasetsToolStrip.Items.Add(mDataSetFilterStartDate)

        lbl = New ToolStripLabel("and")
        lbl.Alignment = ToolStripItemAlignment.Left
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.DatasetsToolStrip.Items.Add(lbl)

        mDataSetFilterEndDate = New ToolStripDateTimePicker
        mDataSetFilterEndDate.Format = DateTimePickerFormat.Short
        mDataSetFilterEndDate.Alignment = ToolStripItemAlignment.Left
        mDataSetFilterEndDate.Overflow = ToolStripItemOverflow.Never
        mDataSetFilterEndDate.ToolTipText = "End Date"
        mDataSetFilterEndDate.Value = endDate
        Me.DatasetsToolStrip.Items.Add(mDataSetFilterEndDate)

        'Readd the filter button
        Me.DatasetsToolStrip.Items.Add(Me.FilterDatasetsButton2)

        Me.DatasetsToolStrip.Items.Add(Me.ToolStripSeparator2)
        Me.HoldStatusButton.Text = String.Empty
        Me.HoldStatusButton.Image = Nothing
        Me.DatasetsToolStrip.Items.Add(Me.HoldStatusButton)

        Me.DatasetsToolStrip.Items.Add(Me.DeSelectAllButton)
        Me.DatasetsToolStrip.Items.Add(Me.ToolStripSeparator1)
        Me.DatasetsToolStrip.Items.Add(Me.SelectAllButton)

    End Sub

    ''' <summary>
    ''' Returns the list of StudyDataset objects that are selected in the grid
    ''' </summary>
    Private Function GetSelectedDatasets() As Collection(Of StudyDataset)

        Dim datasets As New Collection(Of StudyDataset)
        For Each row As DataGridViewRow In Me.DatasetGridView.Rows
            Dim cell As DataGridViewCheckBoxCell = DirectCast(row.Cells(Me.DatasetSelectedColumn.Index), DataGridViewCheckBoxCell)
            If CBool(cell.Value) Then
                datasets.Add(DirectCast(row.Tag, StudyDataset))
            End If
        Next

        Return datasets

    End Function

    Private Sub InitializeColumnSortTypes()

        Me.DatasetIdColumn.ValueType = GetType(Integer)
        Me.DatasetRecordsColumn.ValueType = GetType(Integer)
        Me.DatasetCreationColumn.ValueType = GetType(Date)

    End Sub

    Private Sub PopulateDatasets(ByVal stdy As Study)

        'Clear existing datasets
        Me.DatasetGridView.Rows.Clear()

        'Clear any date columns we may have added
        While Me.DatasetGridView.Columns.Count > 5
            Me.DatasetGridView.Columns.RemoveAt(5)
        End While

        'Get the images
        Dim blankImg As New Bitmap(16, 16)
        Dim checkImg As New Bitmap(My.Resources.Check32, 16, 16)

        'Get the list of datasets
        Dim dataSets As Collection(Of StudyDataset) = stdy.GetStudyDatasets(Me.mDataSetFilterStartDate.Value, Me.mDataSetFilterEndDate.Value)

        'Get a list of cutoff date field IDs and field names for the selected surveys
        Dim sampleEncounterFields As New Dictionary(Of Integer, String)
        For Each srvy As Survey In Me.mSurveys
            If srvy.SampleEncounterField IsNot Nothing Then
                If Not sampleEncounterFields.ContainsKey(srvy.SampleEncounterField.Id) Then
                    sampleEncounterFields.Add(srvy.SampleEncounterField.Id, srvy.SampleEncounterField.Name)
                End If
            End If
        Next

        'Add the date columns
        Dim columns As New Dictionary(Of Integer, DataGridViewTextBoxColumn())
        For Each fieldId As Integer In sampleEncounterFields.Keys
            Dim cols(1) As DataGridViewTextBoxColumn
            cols(0) = New DataGridViewTextBoxColumn
            cols(0).HeaderText = "Min " & sampleEncounterFields(fieldId)
            cols(0).AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
            cols(0).ValueType = GetType(Date)

            cols(1) = New DataGridViewTextBoxColumn
            cols(1).HeaderText = "Max " & sampleEncounterFields(fieldId)
            cols(1).AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells
            cols(1).ValueType = GetType(Date)

            Me.DatasetGridView.Columns.Add(cols(0))
            Me.DatasetGridView.Columns.Add(cols(1))

            columns.Add(fieldId, cols)
        Next

        'For each dataset...
        If dataSets.Count = 0 Then
            NoDataSetsLabel.Visible = True
        Else
            NoDataSetsLabel.Visible = False
            For Each ds As StudyDataset In dataSets
                'Add a row with all the dataset info
                Dim img As Image
                If ds.HasBeenSampled Then
                    img = checkImg
                Else
                    img = blankImg
                End If

                Dim i As Integer = Me.DatasetGridView.Rows.Add(False, ds.Id, ds.DateLoaded, ds.RecordCount, img)

                'Tag the row with the dataset
                Dim row As DataGridViewRow = Me.DatasetGridView.Rows(i)
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

        Me.DatasetGridView.Sort(Me.DatasetCreationColumn, System.ComponentModel.ListSortDirection.Descending)
        Me.SampleButton.Enabled = Me.IsSamplingButtonEnabled
        Me.SampleSeedSpecifiedTextBox.Enabled = Me.IsSamplingButtonEnabled
    End Sub

    Private Sub PopulateNewSampleSets(ByVal surveys As Collection(Of Survey))

        Dim srvy As Survey = Nothing
        Try
            mIsClearing = True
            Me.NewSampleGridView.Rows.Clear()
            mIsClearing = False
            For Each srvy In Me.mSurveys
                Me.AddNewSampleRow(srvy)
            Next
            Me.NewSampleGridView.Sort(Me.NewSampleSetPriorityColumn, System.ComponentModel.ListSortDirection.Ascending)

            Me.PopulateNewSampleRowNumbers()

        Catch ex As Exception
            mIsClearing = True
            Me.NewSampleGridView.Rows.Clear()
            mIsClearing = False
            MessageBox.Show("Error on Survey " & srvy.Name & ".  " & ex.Message)

        End Try

    End Sub

    Private Sub AddNewSampleRow(ByVal srvy As Survey)

        Dim i As Integer = Me.NewSampleGridView.Rows.Add
        'Dim isHCAHPS As Boolean
        Dim row As DataGridViewRow = Me.NewSampleGridView.Rows(i)
        Dim periodList As DataGridViewComboBoxCell = DirectCast(row.Cells(Me.NewSampleSetPeriodColumn.Index), DataGridViewComboBoxCell)
        Dim sampleEncounterDateFieldLabel As String = "N/A"
        If srvy.SampleEncounterField IsNot Nothing Then sampleEncounterDateFieldLabel = String.Format("{0}.{1}", StudyTable.Get(srvy.SampleEncounterField.TableId).Name, srvy.SampleEncounterField.Name)
        'isHCAHPS = (srvy.SurveyType = SurveyTypes.Hcahps OrElse srvy.SurveyType = SurveyTypes.HHcahps)
        row.Cells(Me.NewSampleSetOrderColumn.Index).Value = (i + 1).ToString
        row.Cells(Me.NewSampleSetSurveyColumn.Index).Value = srvy.DisplayLabel
        row.Cells(Me.NewSampleEncounterFieldColumn.Index).Value = sampleEncounterDateFieldLabel
        row.Cells(Me.NewSampleSetSpecifyDatesColumn.Index).Value = True
        row.Cells(Me.NewSampleSetPriorityColumn.Index).Value = srvy.SamplingToolPriority
        If srvy.SampleablePeriods.Count > 0 Then
            periodList.DataSource = srvy.SampleablePeriods
            periodList.DisplayMember = "Name"
            periodList.ValueMember = "Id"
            Me.PopulateNewSamplePeriodInfo(row, srvy.ActiveSamplePeriod)
        End If
        row.Tag = srvy

    End Sub

    Private Sub PopulateNewSampleRowNumbers()

        For i As Integer = 0 To Me.NewSampleGridView.Rows.Count - 1
            Me.NewSampleGridView.Rows(i).Cells(Me.NewSampleSetOrderColumn.Index).Value = (i + 1).ToString
        Next

    End Sub

    Private Sub PopulateNewSamplePeriodInfo(ByVal row As DataGridViewRow, ByVal period As SamplePeriod)

        row.Cells(Me.NewSampleSetPeriodColumn.Index).Value = period.Id
        row.Cells(Me.NewSampleSetMethodColumn.Index).Value = Me.GetSamplingMethodLabel(period.SamplingMethod)
        Dim periodStatus As String = String.Format("{0} of {1}", period.SampleSets.Count, period.ExpectedSamples)
        row.Cells(Me.NewSampleSetPeriodStatusColumn.Index).Value = periodStatus
        row.Cells(Me.NewSampleSetStartDateColumn.Index).Value = period.ExpectedStartDate
        row.Cells(Me.NewSampleSetEndDateColumn.Index).Value = period.ExpectedEndDate

    End Sub

    Private Function GetSamplingMethodLabel(ByVal method As SampleSet.SamplingMethod) As String

        Select Case method
            Case SampleSet.SamplingMethod.Census
                Return "Census"

            Case SampleSet.SamplingMethod.SpecifyOutgo
                Return "Specify Outgo"

            Case SampleSet.SamplingMethod.SpecifyTargets
                Return "Specify Targets"

            Case Else
                Return ""

        End Select

    End Function

    Private Sub ToggleNewSampleSpecifyDates(ByVal specifyDates As Boolean, ByVal row As DataGridViewRow)

        row.Cells(Me.NewSampleSetStartDateColumn.Index).ReadOnly = Not specifyDates
        row.Cells(Me.NewSampleSetEndDateColumn.Index).ReadOnly = Not specifyDates

        If specifyDates Then
            Dim period As SamplePeriod = SampleDefinition.GetSelectedPeriod(row.Cells(Me.NewSampleSetPeriodColumn.Index))
            row.Cells(Me.NewSampleSetStartDateColumn.Index).Value = period.ExpectedStartDate
            row.Cells(Me.NewSampleSetEndDateColumn.Index).Value = period.ExpectedEndDate
        Else
            row.Cells(Me.NewSampleSetStartDateColumn.Index).Value = Nothing
            row.Cells(Me.NewSampleSetEndDateColumn.Index).Value = Nothing
        End If

    End Sub

    Private Sub MoveRows(ByVal increment As Integer)

        Dim selectedRows As New SortedList(Of Integer, DataGridViewRow)
        For Each row As DataGridViewRow In Me.NewSampleGridView.SelectedRows
            If increment > 0 Then
                selectedRows.Add(row.Index, row)
            Else
                selectedRows.Add(-row.Index, row)
            End If
        Next

        For Each pair As KeyValuePair(Of Integer, DataGridViewRow) In selectedRows
            Dim row As DataGridViewRow = pair.Value
            Dim index As Integer
            If increment > 0 Then
                index = pair.Key
            Else
                index = -pair.Key
            End If

            If increment > 0 AndAlso index >= increment Then
                Me.NewSampleGridView.Rows.Remove(row)
                Me.NewSampleGridView.Rows.Insert(index - increment, row)
            ElseIf increment < 0 AndAlso index < Me.NewSampleGridView.Rows.Count + increment Then
                Me.NewSampleGridView.Rows.Remove(row)
                Me.NewSampleGridView.Rows.Insert(index - increment, row)
            End If
        Next

        Me.PopulateNewSampleRowNumbers()

        Me.NewSampleGridView.ClearSelection()
        Me.NewSampleGridView.CurrentCell = selectedRows.Values(0).Cells(0)

        For Each pair As KeyValuePair(Of Integer, DataGridViewRow) In selectedRows
            pair.Value.Selected = True
        Next

    End Sub

    Private Sub InitializeSampleSeedSpecifier()
        Me.SampleSeedSpecifiedLabel.Visible = CurrentUser.CanSpecifyStaticPlusSeed
        Me.SampleSeedSpecifiedTextBox.Visible = CurrentUser.CanSpecifyStaticPlusSeed
    End Sub

    ''' <summary>
    ''' Returns a -1 for random seed, >= zero if valid or throws and Exception if invalid seed input
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Private Function GetSpecificSampleSeed() As Integer

        'Trim textbox input in place
        Me.SampleSeedSpecifiedTextBox.Text = Me.SampleSeedSpecifiedTextBox.Text.Trim()

        'If the specific seed feature is enabled & text has been specified
        If CurrentUser.CanSpecifyStaticPlusSeed And Not String.IsNullOrEmpty(Me.SampleSeedSpecifiedTextBox.Text) Then
            Dim specificSeed As Integer
            'We now either return a valid seed or throw an
            If Integer.TryParse(Me.SampleSeedSpecifiedTextBox.Text, specificSeed) And (specificSeed > 0) Then
                Return specificSeed
            Else
                Throw New ArgumentOutOfRangeException("Invalid seed value.")
            End If
        End If

        'Most cases we will just return -1 out of this
        Return -1
    End Function

#Region "hold sheet stuff"

    Private Sub PopulateHoldTable(ByVal surveys As Collection(Of Survey))

        mIsHoldsAccessible = True
        mHoldTable = Nothing
        mHoldTable = New DataTable()


        Dim clientid As Integer = surveys(0).Study.ClientId
        Dim clientName As String = surveys(0).Study.Client.Name

        Dim studyid As Integer = surveys(0).StudyId
        Dim studyName As String = surveys(0).Study.Name
        Dim surveyDict As New Dictionary(Of String, String)

        For Each srvy As Survey In surveys
            surveyDict.Add(srvy.Id.ToString(), srvy.Name)
        Next

        If surveyDict.Count > 0 Then
            Try
                mHoldTable = odsdb.GetHoldsTable(clientid, studyid, surveyDict)

                If mHoldTable IsNot Nothing Then
                    AddNameColumns()
                    AddNameValues(clientid, clientName, studyid, studyName, surveyDict)
                End If
            Catch ex As Exception
                mIsHoldsAccessible = False
                Throw
            End Try

        End If

    End Sub

    Private Sub AddNameColumns()
        Dim column As DataColumn


        column = New DataColumn
        With column
            .DataType = System.Type.GetType("System.String")
            .ColumnName = "ClientName"
            .Unique = False
        End With
        mHoldTable.Columns.Add(column)

        column = New DataColumn
        With column
            .DataType = System.Type.GetType("System.String")
            .ColumnName = "StudyName"
            .Unique = False
        End With
        mHoldTable.Columns.Add(column)

        column = New DataColumn
        With column
            .DataType = System.Type.GetType("System.String")
            .ColumnName = "SurveyName"
            .Unique = False
        End With
        mHoldTable.Columns.Add(column)

    End Sub

    Private Sub AddNameValues(ByVal clientid As Integer, ByVal clientname As String, ByVal studyid As Integer, ByVal studyname As String, ByVal surveydict As Dictionary(Of String, String))

        If mHoldTable.Rows.Count > 0 Then
            For Each r As DataRow In mHoldTable.Rows

                r("ClientName") = String.Format("{0} ({1})", clientname, clientid.ToString)
                r("StudyName") = String.Format("{0} ({1})", studyname, studyid.ToString)

                Dim surveyid As String = r("SurveyID").ToString

                If surveydict.ContainsKey(surveyid) Then
                    Dim surveyname As String = surveydict.Item(surveyid)
                    If surveyname <> String.Empty Then
                        r("SurveyName") = String.Format("{0} ({1})", surveyname, surveyid)
                    End If
                Else
                    r("SurveyName") = surveyid.ToString
                End If
            Next
        End If

    End Sub

    Private Function GetMinEncounterHoldDate(ByVal survey As Survey) As Date
        Try
            Dim studyid As Integer = survey.StudyId
            Dim clientid As Integer = survey.Study.ClientId
            Return odsdb.GetMinEncounterHoldDate(clientid, studyid, survey.Id)
        Catch ex As Exception
            Throw
        End Try

    End Function

    Private Sub SetHoldStatusButton()

        Me.HoldStatusButton.Text = String.Empty
        Me.HoldStatusButton.Image = Nothing
        Me.HoldStatusButton.Enabled = False

        If mIsHoldsAccessible = True Then
            If mHoldTable IsNot Nothing Then
                If mHoldTable.Rows.Count > 0 Then
                    Me.HoldStatusButton.Text = String.Format("Active Holds on this selection!")
                    Me.HoldStatusButton.Image = My.Resources.Caution16
                    Me.HoldStatusButton.Enabled = True
                End If
            End If
        Else
            Me.HoldStatusButton.Text = String.Format("Hold data is inaccessible!")
            Me.HoldStatusButton.Image = My.Resources.Error16
        End If


    End Sub

    Private Sub RemoveOnHoldSamplesFromSampleDefinitions(ByVal onHoldSamples As List(Of SampleDefinition))

        For Each sampledef As SampleDefinition In onHoldSamples
            Dim i As Integer = 0
            Dim surveyID As Integer = sampledef.Survey.Id

            While i < mSampleDefinitions.Count
                Dim sampleDefRow As SampleDefinition = mSampleDefinitions(i)
                If sampleDefRow.Survey.Id = surveyID Then
                    sampleDefRow.RowErrorText = "Sample Not Executed Due To Hold."
                    mSampleDefinitions.RemoveAt(i)
                Else
                    i += 1
                End If
            End While
        Next

    End Sub

    Private Sub ShowHoldsDialog()

        Try
            Dim studyid As Integer = mSurveys(0).StudyId
            Dim clientid As Integer = mSurveys(0).Study.ClientId

            Dim surveyList As New List(Of String)

            For Each svy As Survey In mSurveys
                surveyList.Add(svy.Id.ToString())

            Next

            PopulateHoldTable(mSurveys)

            If mHoldTable IsNot Nothing AndAlso mHoldTable.Rows.Count > 0 Then
                Dim holdDialog As New HoldsDialog(mHoldTable)
                holdDialog.ShowDialog()
            Else
                MessageBox.Show("No Holds to show", "Holds", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If

        Catch ex As Exception
            Globals.ReportException(ex)
        End Try

    End Sub

#End Region



#End Region



End Class
