'Todo: Add mass scheduling wizard
Imports Nrc.Qualisys.Library
Imports DevExpress.XtraGrid
Public Class PeriodEditor

    Private mSamplePeriods As SamplePeriodCollection
    Private mModule As SamplePeriodsModule
    Private mEndConfigCallBack As EndConfigCallBackMethod
    Private mSelectedSamplePeriods As New Collection(Of SamplePeriod)

#Region " Constructors "
    Public Sub New(ByVal samplePeriodsModule As SamplePeriodsModule, ByVal endConfigCallBack As EndConfigCallBackMethod)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mModule = samplePeriodsModule
        Me.mEndConfigCallBack = endConfigCallBack
    End Sub
#End Region

#Region " Private Methods "
    Private Sub PeriodEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Initialize()
    End Sub

    Private Sub Initialize()

        'Information bar
        Me.InformationBar.Information = Me.mModule.Information
        If Me.InformationBar.Information = String.Empty Then Me.WorkAreaPanel.Location = New Point(0, 0)

        'Hide date columns based on survey type
        Me.colMonth.Visible = Me.mModule.Survey.IsMonthlyOnly
        Me.colYear.Visible = Me.mModule.Survey.IsMonthlyOnly
        Me.colExpectedEndDate.Visible = Not Me.mModule.Survey.IsMonthlyOnly
        Me.colExpectedStartDate.Visible = Not Me.mModule.Survey.IsMonthlyOnly

        Dim override As String = mModule.Survey.SurveySubTypeOverrideName() 'will retrieve PCMH for example CJB 8/14/2014

        Me.colSamplingMethodLabel.ColumnEdit.ReadOnly = Me.mModule.Survey.IsSamplingMethodDisabled(override)

        'Get a list of all sample periods for this survey
        'Me.mSamplePeriods = Me.mModule.Survey.SamplePeriodsActiveAndFuture
        Me.mSamplePeriods = Me.mModule.Survey.SamplePeriods
        Me.colPeriodTimeFrame.FilterInfo = New DevExpress.XtraGrid.Columns.ColumnFilterInfo("[PeriodTimeFrame] = 'Active' Or [PeriodTimeFrame] = 'Future'")

        'Set the binding source for the available periods grid
        Me.SamplePeriodBindingSource.DataSource = Me.mSamplePeriods

        'Add all sampling Methods to the repository
        For Each i As Integer In System.Enum.GetValues(GetType(SampleSet.SamplingMethod))
            Me.SamplingMethodRepositoryItemComboBox.Items.Add(SampleSet.SamplingMethodLabel(DirectCast(i, SampleSet.SamplingMethod)))
        Next
        ToggleBasedOnIfSamplingHasStarted()

        'Disable all the fields when viewing properties
        Me.WorkAreaPanel.Enabled = Me.mModule.IsEditable
        Me.OKButton.Enabled = Me.mModule.IsEditable

    End Sub
#End Region

#Region "Private Methods"
    'Many buttons enabled value is dependent on whether or not we have pulled any samples for the period
    Private Sub ToggleBasedOnIfSamplingHasStarted()
        If Me.mSelectedSamplePeriods.Count = 1 AndAlso Not mSelectedSamplePeriods(0) Is Nothing Then
            Dim focusedSample As SamplePeriod = mSelectedSamplePeriods(0)
            ToggleSchedulingWizardButton()
            ToggleDeleteButton()
            ToggleCancelSamplesButton()
            ToggleUnCancelSamplesButton()
        ElseIf mSelectedSamplePeriods.Count > 1 Then
            ToggleDeleteButton()
            ToggleCancelSamplesButton()
            ToggleUnCancelSamplesButton()
            ToggleSchedulingWizardButton()
        Else
            Me.DeleteButton.Enabled = False
            Me.SchedulingWizardButton.Enabled = False
            Me.UnCancelSamplesButton.Enabled = False
            Me.CancelSamplesButton.Enabled = False
        End If
    End Sub

    Private Sub ToggleApplyButton()
        If Not Me.mSamplePeriods Is Nothing Then
            Me.ApplyButton.Enabled = (Me.mSamplePeriods.IsValid And Me.mSamplePeriods.IsDirty)
        Else
            Me.ApplyButton.Enabled = False
        End If
    End Sub

    'Delete is only available if all selected rows have not started sampling
    Private Sub ToggleDeleteButton()
        For Each focusedSample As SamplePeriod In mSelectedSamplePeriods
            If Not focusedSample.isDeletable Then
                Me.DeleteButton.Enabled = False
                Exit Sub
            End If
        Next

        Me.DeleteButton.Enabled = True
    End Sub

    'Scheduling is only available if all selected periods have not started sampling
    Private Sub ToggleSchedulingWizardButton()
        For Each focusedSample As SamplePeriod In mSelectedSamplePeriods
            If focusedSample.HasSamplesPulled Then
                Me.SchedulingWizardButton.Enabled = False
                Exit Sub
            End If
        Next
        Me.SchedulingWizardButton.Enabled = True
    End Sub
    Private Sub ToggleCancelSamplesButton()
        For Each focusedSample As SamplePeriod In mSelectedSamplePeriods
            If Not focusedSample.isCancelable Then
                Me.CancelSamplesButton.Enabled = False
                Exit Sub
            End If
        Next

        Me.CancelSamplesButton.Enabled = True
    End Sub

    Private Sub ToggleUnCancelSamplesButton()
        For Each focusedSample As SamplePeriod In mSelectedSamplePeriods
            If Not focusedSample.isUnCancelable Then
                Me.UnCancelSamplesButton.Enabled = False
                Exit Sub
            End If
        Next

        Me.UnCancelSamplesButton.Enabled = True
    End Sub

    Private Sub SelectedSamplePeriods(ByVal focusedView As Views.Grid.GridView)
        Dim periods As New Collection(Of SamplePeriod)
        Dim period As SamplePeriod

        If focusedView Is Me.SamplePeriodGridView Then
            'It's the master view so multiple rows may be selected
            For Each i As Integer In focusedView.GetSelectedRows
                period = DirectCast(focusedView.GetRow(i), SamplePeriod)
                If Not period Is Nothing Then periods.Add(period)
            Next
        Else
            'It's a detail view
            periods.Add(DirectCast(focusedView.SourceRow, SamplePeriod))
        End If
        mSelectedSamplePeriods = periods
    End Sub

#End Region

#Region "Event Handlers"
    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        Dim result As DialogResult
        If Me.mSamplePeriods.IsDirty Then
            result = MessageBox.Show("There are unsaved changes.  Would you like to save these before exiting?", "Confirm Save", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question)
            Select Case result
                Case DialogResult.Yes
                    If Me.mSamplePeriods.IsValid = False Then
                        MessageBox.Show("You cannot save at this time.  Not all periods have valid settings", "Invalid Settings", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Exit Sub
                    End If
                    Me.mSamplePeriods.Save()
                Case DialogResult.No
                    'Do nothing
                Case DialogResult.Cancel
                    Exit Sub
            End Select
        End If

        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub SchedulingWizardButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SchedulingWizardButton.Click
        Dim scheduledSample As SamplePeriodScheduledSample
        Dim counter As Integer
        Dim focusedPeriod As SamplePeriod
        Dim schedulingWizard As New SamplePeriodsSchedulingWizardDialog("Number of Samples", "Minimum Days after encounter start date (or today if no start date exists) for first sample to occur")
        Dim dates As Collection(Of Date)
        Dim existingSample As SamplePeriodScheduledSample
        Dim oldScheduledSamplesCount As Integer

        schedulingWizard.ShowDialog()
        If schedulingWizard.DialogResult = DialogResult.OK Then
            For Each focusedPeriod In Me.mSelectedSamplePeriods
                oldScheduledSamplesCount = focusedPeriod.SamplePeriodScheduledSamples.Count
                focusedPeriod.SamplingScheduleName = schedulingWizard.SamplingSchedule
                counter = 1
                If focusedPeriod.ExpectedStartDate.HasValue Then
                    dates = schedulingWizard.CalculateDates(focusedPeriod.ExpectedStartDate.Value)
                Else
                    dates = schedulingWizard.CalculateDates()
                End If
                For Each tmpDate As Date In dates
                    existingSample = Nothing

                    'Determine whether we need to update an existing sample or create a new one
                    For Each oldSample As SamplePeriodScheduledSample In focusedPeriod.SamplePeriodScheduledSamples
                        If oldSample.SampleNumber = counter Then
                            existingSample = oldSample
                            Exit For
                        End If
                    Next

                    If existingSample Is Nothing Then
                        scheduledSample = SamplePeriodScheduledSample.NewSamplePeriodScheduledSample
                        scheduledSample.SampleNumber = counter
                        scheduledSample.ScheduledSampleDate = tmpDate
                        scheduledSample.SamplePeriodId = focusedPeriod.Id
                        focusedPeriod.SamplePeriodScheduledSamples.Add(scheduledSample)
                    Else
                        existingSample.ScheduledSampleDate = tmpDate
                    End If

                    'Prepare for next scheduled sample to add
                    counter += 1
                Next

                'Delete any existing scheduled samples that weren't replaced
                For j As Integer = counter To oldScheduledSamplesCount
                    focusedPeriod.SamplePeriodScheduledSamples.RemoveBySampleNumber(j)
                Next

                'Adding scheduled samples does not revalidate the sample period, so we must 
                'force a revalidation and then force a refresh of the row
                focusedPeriod.ReValidate()
                Me.SamplePeriodGridView.RefreshRow(Me.SamplePeriodGridView.GetRowHandle(Me.mSamplePeriods.IndexOf(focusedPeriod)))

                'Force an update of all open detail views
                For Each View As Views.Grid.GridView In Me.SamplePeriodGridControl.Views
                    If Not View Is Me.SamplePeriodGridView Then
                        View.RefreshData()
                    End If
                Next
            Next
        End If
        Me.ToggleApplyButton()
    End Sub

    Private Sub NewSamplePeriodButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewSamplePeriodButton.Click
        Dim newSamplePeriod As SamplePeriod = SamplePeriod.NewSamplePeriod(Me.mModule.Survey, CurrentUser.Employee.Id)
        newSamplePeriod.Name = "New Period"
        mSamplePeriods.Add(newSamplePeriod)

        'Refresh grid and select newly added row
        Me.SamplePeriodGridView.RefreshData()
        Me.SamplePeriodGridView.ClearSelection()
        Me.SamplePeriodGridView.SelectRow(Me.SamplePeriodGridView.GetRowHandle(mSamplePeriods.IndexOf(newSamplePeriod)))
    End Sub

    Private Sub DeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteButton.Click
        'Confirm the delete
        If MessageBox.Show("Are you sure you want to delete the selected periods?", "Confirm Delete", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) = DialogResult.Cancel Then Exit Sub

        Dim focusedPeriod As SamplePeriod
        Dim reversedRowArray() As Integer = Me.SamplePeriodGridView.GetSelectedRows
        Dim MessageQueue As New System.Text.StringBuilder

        'Reverse the elements for we remove from highest row to lowest.  If we don't go in reverse
        'we have problems because the row numbers change after each item is deleted
        Array.Sort(reversedRowArray)
        Array.Reverse(reversedRowArray)

        For Each i As Integer In reversedRowArray
            focusedPeriod = DirectCast(Me.SamplePeriodGridView.GetRow(i), SamplePeriod)
            'Check isdeletable one more time.  A sample may have been run since the delete button was enabled,
            'and that would make this an undeletable period.
            If focusedPeriod.IsDeletable Then
                Me.mSamplePeriods.Remove(focusedPeriod)
            Else
                MessageQueue.Append(focusedPeriod.Name & " could not be deleted.  A sample has been pulled for it since the period" & _
                                " editor screen was opened.")
                MessageQueue.AppendLine()
            End If
        Next

        If MessageQueue.Length > 0 Then
            MessageBox.Show(MessageQueue.ToString, "Delete Failed", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Me.SamplePeriodGridView.RefreshData()
        End If

        If Me.SamplePeriodGridView.RowCount > 0 Then Me.SamplePeriodGridView.SelectRow(0)
        Me.ToggleBasedOnIfSamplingHasStarted()
        Me.ToggleApplyButton()
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        If mSamplePeriods.IsValid = False Then
            MessageBox.Show("You must fix all validation errors before you can save the changes and close period editor.", "Validation Errors", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        mSamplePeriods.Save()
        Me.mEndConfigCallBack(ConfigResultActions.None, Nothing)
        Me.mEndConfigCallBack = Nothing
    End Sub

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click
        mSamplePeriods.Save()
        ToggleApplyButton()
    End Sub

    Private Sub SamplePeriodBindingSource_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles SamplePeriodBindingSource.ListChanged
        ToggleApplyButton()
    End Sub

    Private Sub SamplePeriodGridControl_FocusedViewChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.ViewFocusEventArgs) Handles SamplePeriodGridControl.FocusedViewChanged
        SelectedSamplePeriods(DirectCast(e.View, Views.Grid.GridView))
        ToggleBasedOnIfSamplingHasStarted()
    End Sub

    Private Sub SamplePeriodGridView_SelectionChanged(ByVal sender As Object, ByVal e As DevExpress.Data.SelectionChangedEventArgs) Handles SamplePeriodGridView.SelectionChanged
        SelectedSamplePeriods(DirectCast(sender, Views.Grid.GridView))
        ToggleBasedOnIfSamplingHasStarted()
    End Sub

    ''' <summary>
    ''' This method is used to set editing in the currently selected cell.  Disabling edit is accomplished
    ''' by canceling the showing of the repository editor
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub SamplePeriodGridView_ShowingEditor(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles SamplePeriodGridView.ShowingEditor
        Dim view As Views.Grid.GridView = DirectCast(sender, Views.Grid.GridView)
        Dim focusedPeriod As SamplePeriod
        focusedPeriod = DirectCast(view.GetRow(view.FocusedRowHandle), SamplePeriod)

        'Cacel editing on the sampling method property is sampling has started.

        If Not view.FocusedColumn Is Me.colName Then
            e.Cancel = focusedPeriod.HasSamplesPulled
        End If
    End Sub

    'commit datetimepicker changes immediately, instead of when the control loses focus
    Private Sub ExpectedDateDateEdit_Modified(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExpectedDateEditRepositoryItem.Modified
        Dim datePicker As DevExpress.XtraEditors.DateEdit = DirectCast(sender, DevExpress.XtraEditors.DateEdit)
        datePicker.DoValidate()
    End Sub

    Private Sub ExpectedDateEditRepositoryItem_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles ExpectedDateEditRepositoryItem.EditValueChanging
        Dim selectedRow As Integer = SamplePeriodGridView.GetSelectedRows(0)
        Dim focusedPeriod As SamplePeriod = DirectCast(SamplePeriodGridView.GetRow(selectedRow), SamplePeriod)

        If SamplePeriodGridView.FocusedColumn Is Me.colExpectedStartDate Then
            focusedPeriod.ExpectedStartDate = CDate(e.NewValue)
        Else
            focusedPeriod.ExpectedEndDate = CDate(e.NewValue)
        End If

        'Refresh bindings to get updated value from object
        Me.SamplePeriodGridView.UpdateCurrentRow()
        Me.ToggleApplyButton()
    End Sub

    Private Sub SamplingMethodRepositoryItemComboBox_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles SamplingMethodRepositoryItemComboBox.EditValueChanging
        Dim selectedRow As Integer = SamplePeriodGridView.GetSelectedRows(0)
        Dim focusedPeriod As SamplePeriod = DirectCast(SamplePeriodGridView.GetRow(selectedRow), SamplePeriod)

        focusedPeriod.SamplingMethodLabel = CStr(e.NewValue)

        'Determine if OK button should be displayed
        Me.ToggleApplyButton()
    End Sub


    Private Sub NameRepositoryItemTextEdit_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles NameRepositoryItemTextEdit.EditValueChanging
        Dim selectedRow As Integer = SamplePeriodGridView.GetSelectedRows(0)
        Dim focusedPeriod As SamplePeriod = DirectCast(SamplePeriodGridView.GetRow(selectedRow), SamplePeriod)

        focusedPeriod.Name = CStr(e.NewValue)

        'Determine if OK button should be displayed
        Me.ToggleApplyButton()
    End Sub

    'Before saving the value, we need to catch it and manually update the encounter start and end dates
    'If we don't do this, we will get an exception because it tries to bind the month value to the 
    'encounterStartDate Property
    Private Sub YearComboBoxRepositoryItem_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles YearComboBoxRepositoryItem.EditValueChanging
        Dim selectedRow As Integer = SamplePeriodGridView.GetSelectedRows(0)
        Dim focusedPeriod As SamplePeriod = DirectCast(SamplePeriodGridView.GetRow(selectedRow), SamplePeriod)
        Dim month As String = SamplePeriodGridView.GetRowCellDisplayText(selectedRow, colMonth)
        Dim year As Integer

        Integer.TryParse(CStr(e.NewValue), year)

        If Not String.IsNullOrEmpty(month) AndAlso year > 0 Then
            focusedPeriod.ExpectedStartDate = DateTime.Parse(String.Format("{0} {1}, {2}", month, "01", year))
            focusedPeriod.ExpectedEndDate = focusedPeriod.ExpectedStartDate.Value.AddMonths(1).AddDays(-1)
        End If

        'Abort before trying to bind the new value to the encounterStartDate property
        e.Cancel = True

        'Refresh bindings to get updated value from object
        Me.SamplePeriodGridView.UpdateCurrentRow()
        Me.ToggleApplyButton()
    End Sub

    'Before saving the value, we need to catch it and manually update the encounter start and end dates
    'If we don't do this, we will get an exception because it tries to bind the month value to the 
    'encounterStartDate Property
    Private Sub MonthComboBoxRepositoryItem_EditValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles MonthComboBoxRepositoryItem.EditValueChanging
        Dim selectedRow As Integer = SamplePeriodGridView.GetSelectedRows(0)
        Dim focusedPeriod As SamplePeriod = DirectCast(SamplePeriodGridView.GetRow(selectedRow), SamplePeriod)
        Dim year As Integer
        Dim month As String = CStr(e.NewValue)

        Integer.TryParse(SamplePeriodGridView.GetRowCellDisplayText(selectedRow, colYear), year)
        If year = 0 Then year = Today.Year
        If year > 0 Then
            focusedPeriod.ExpectedStartDate = DateTime.Parse(String.Format("{0} {1}, {2}", month, "01", year))
            focusedPeriod.ExpectedEndDate = focusedPeriod.ExpectedStartDate.Value.AddMonths(1).AddDays(-1)
        End If

        'Abort before trying to bind the new value to the encounterStartDate property
        e.Cancel = True

        'Refresh bindings to get updated value from object
        Me.SamplePeriodGridView.UpdateCurrentRow()
        Me.ToggleApplyButton()
    End Sub

    Private Sub ScheduledSamplesGridView_CellValueChanging(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.CellValueChangedEventArgs) Handles ScheduledSamplesGridView.CellValueChanging
        Dim focusedPeriod As SamplePeriod
        Dim detailView As Views.Grid.GridView = DirectCast(sender, Views.Grid.GridView)

        focusedPeriod = DirectCast(detailView.SourceRow, SamplePeriod)
        Select Case e.Column.Name
            Case Me.colCanceled.Name
                'all remaining samples must be canceled or uncanceled
                If CBool(e.Value) = True Then
                    focusedPeriod.CancelRemainingSamplesInPeriod()
                Else
                    focusedPeriod.UnCancelRemainingSamplesInPeriod()
                End If
                detailView.RefreshData()
            Case Me.colScheduledSampleDate.Name
                Dim focusedSample As SamplePeriodScheduledSample
                focusedSample = DirectCast(detailView.GetRow(e.RowHandle), SamplePeriodScheduledSample)
                focusedSample.ScheduledSampleDate = CDate(e.Value)
                detailView.UpdateCurrentRow()
        End Select

        'Determine if OK button should be displayed
        Me.ToggleApplyButton()
    End Sub

    Private Sub ScheduledSamplesGridView_FocusedRowChanged(ByVal sender As Object, ByVal e As DevExpress.XtraGrid.Views.Base.FocusedRowChangedEventArgs) Handles ScheduledSamplesGridView.FocusedRowChanged
        SelectedSamplePeriods(DirectCast(sender, Views.Grid.GridView))
        ToggleBasedOnIfSamplingHasStarted()
    End Sub

    ''' <summary>
    ''' This is done to ensure that we correctly allow or disallow editing on specific columns.
    ''' Editing of a scheduled sample is not allowed once an actual date is present
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub ScheduledSamplesGridView_ShowingEditor(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles ScheduledSamplesGridView.ShowingEditor
        Dim view As Views.Grid.GridView = DirectCast(sender, Views.Grid.GridView)
        Dim focusedSample As SamplePeriodScheduledSample
        focusedSample = DirectCast(view.GetRow(view.FocusedRowHandle), SamplePeriodScheduledSample)

        e.Cancel = focusedSample.ActualSampleDate.HasValue
    End Sub

    Private Sub CancelSamplesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelSamplesButton.Click
        For Each Period As SamplePeriod In mSelectedSamplePeriods
            Period.CancelRemainingSamplesInPeriod()
        Next

        'refresh the data in the open detail grids
        For Each focusedView As Views.Grid.GridView In Me.SamplePeriodGridControl.Views
            If Not focusedView Is Me.SamplePeriodGridView Then
                focusedView.RefreshData()
                If focusedView.RowCount > 0 Then focusedView.FocusedRowHandle = 0
            End If
        Next

        ToggleBasedOnIfSamplingHasStarted()
        ToggleApplyButton()
    End Sub

    Private Sub UnCancelSamplesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnCancelSamplesButton.Click
        For Each Period As SamplePeriod In mSelectedSamplePeriods
            Period.UnCancelRemainingSamplesInPeriod()
        Next

        'refresh the data in the open detail grids
        For Each focusedView As Views.Grid.GridView In Me.SamplePeriodGridControl.Views
            If Not focusedView Is Me.SamplePeriodGridView Then
                focusedView.RefreshData()
                If focusedView.RowCount > 0 Then focusedView.FocusedRowHandle = 0
            End If
        Next

        ToggleBasedOnIfSamplingHasStarted()
        ToggleApplyButton()
    End Sub

    Private Sub MassCreatePeriodsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MassCreatePeriodsButton.Click
        Dim massCreator As New MassSamplePeriodCreator(Me.mModule.Survey)
        massCreator.ShowDialog()

        Me.SamplePeriodGridView.RefreshData()
    End Sub
#End Region

End Class
