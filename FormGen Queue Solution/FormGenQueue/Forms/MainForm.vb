Imports System.Collections.ObjectModel
Imports Nrc.Qualisys.Library

Public Class MainForm

    Private WithEvents mStartDate As ToolStripDateTimePicker
    Private WithEvents mEndDate As ToolStripDateTimePicker
    Private WithEvents mStartDateLabel As ToolStripLabel
    Private WithEvents mEndDateLabel As ToolStripLabel
    Private mShowToday As Boolean
    Private mFormCount As Integer
    Private mShowReleased As Boolean = True
    Private mShowUnreleased As Boolean = True
    Private mJobList As Collection(Of FormGenJob)
    Private mReleasedImage As Image
    Private mUnreleasedImage As Image

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.InitUI()
        Me.GenerationDateColumn.ValueType = GetType(Date)
        Me.InitializeToolStripDatePickers()
        Me.ReleaseFilterList.SelectedIndex = 0
        Me.FilterTypeList.SelectedIndex = 0
        Me.PopulateGrid()
        Me.ToggleToolStripButtons()
        Me.mReleasedImage = My.Resources.Check16
        Me.mUnreleasedImage = My.Resources.NoWay16
    End Sub

    Private Sub InitUI()
        Me.Text = My.Application.Info.Title
        Me.EnvironmentLabel.Text = Config.EnvironmentName
        Me.VersionLabel.Text = "v" & My.Application.Info.Version.ToString
        Me.UserNameLabel.Text = String.Format("{0} ({1})", CurrentUser.DisplayName, My.User.Name)
    End Sub

    Private Sub InitializeToolStripDatePickers()
        MainToolStrip.Items.Clear()
        MainToolStrip.Items.Add(ScheduleNextStepsButton)
        MainToolStrip.Items.Add(ToolStripSeparator2)
        MainToolStrip.Items.Add(ChangePriorityButton)
        MainToolStrip.Items.Add(RescheduleButton)
        MainToolStrip.Items.Add(FilterButton)

        mEndDate = New ToolStripDateTimePicker
        mEndDate.Value = Date.Today.AddDays(1)
        mEndDate.ToolTipText = "End Date"
        mEndDate.Format = DateTimePickerFormat.Short
        mEndDate.Alignment = ToolStripItemAlignment.Right
        mEndDate.DateTimePickerControl.Width = 85
        mEndDate.Margin = New Padding(0, 1, 5, 2)
        MainToolStrip.Items.Add(mEndDate)

        mEndDateLabel = New ToolStripLabel("End Date")
        mEndDateLabel.Alignment = ToolStripItemAlignment.Right
        mEndDateLabel.Margin = New Padding(10, 1, 0, 2)
        MainToolStrip.Items.Add(mEndDateLabel)

        mStartDate = New ToolStripDateTimePicker
        mStartDate.Value = Date.Today
        mStartDate.ToolTipText = "Start Date"
        mStartDate.Format = DateTimePickerFormat.Short
        mStartDate.Alignment = ToolStripItemAlignment.Right
        mStartDate.DateTimePickerControl.Width = 85
        MainToolStrip.Items.Add(mStartDate)

        mStartDateLabel = New ToolStripLabel("Start Date")
        mStartDateLabel.Alignment = ToolStripItemAlignment.Right
        MainToolStrip.Items.Add(mStartDateLabel)

        MainToolStrip.Items.Add(ToolStripSeparator1)
        MainToolStrip.Items.Add(FilterTypeList)
        MainToolStrip.Items.Add(ReleaseFilterList)
        MainToolStrip.Items.Add(FilterLabel)
    End Sub

    Private Sub PopulateGrid()
        Dim jobs As Collection(Of FormGenJob)
        If mShowToday Then
            'Send in the last two weeks just to ensure that we catch things that might
            'be a little old and waiting to gen today
            jobs = FormGenJob.GetByGenerationDate(Date.Today.AddDays(-14), Date.Today)
        Else
            jobs = FormGenJob.GetByGenerationDate(mStartDate.Value, mEndDate.Value)
        End If
        Me.PopulateGrid(jobs)
    End Sub


    Private Sub PopulateGrid(ByVal jobs As Collection(Of FormGenJob))
        Try
            Me.Cursor = Cursors.WaitCursor
            If jobs IsNot Nothing Then
                mFormCount = 0
                mJobList = jobs

                Me.QueueGrid.DataSource = Nothing
                Me.QueueGrid.Rows.Clear()
                Dim rowIndex As Integer
                For Each job As FormGenJob In jobs
                    If (job.IsFormGenerationReleased AndAlso mShowReleased) OrElse (Not job.IsFormGenerationReleased AndAlso mShowUnreleased) Then
                        rowIndex = Me.QueueGrid.Rows.Add(job.IsFormGenerationReleased, job.ClientLabel, job.StudyLabel, job.SurveyLabel, job.MailStepName, job.GenerationDate, job.Priority, job.FormCount, job.SurveyType)
                        Me.QueueGrid.Rows(rowIndex).Tag = job
                        mFormCount += job.FormCount
                    End If
                Next

                DeselectAllRows()
            End If
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try
    End Sub

    Private Sub SetDateFilter()
        mShowToday = Me.FilterTypeList.SelectedItem.ToString = "Today"
        mStartDateLabel.Enabled = Not mShowToday
        mStartDate.Enabled = Not mShowToday
        mEndDateLabel.Enabled = Not mShowToday
        mEndDate.Enabled = Not mShowToday
    End Sub

    Private Sub SetReleaseFilter()
        Dim selectedItem As String = Me.ReleaseFilterList.SelectedItem.ToString
        mShowReleased = (selectedItem = "Released" OrElse selectedItem = "All")
        mShowUnreleased = (selectedItem = "Unreleased" OrElse selectedItem = "All")
        Me.PopulateGrid(mJobList)
    End Sub

    Private Sub FilterButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterButton.Click
        Me.PopulateGrid()
    End Sub


    Private Sub GridMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles GridMenu.Opening
        If Me.QueueGrid.SelectedRows.Count = 0 Then
            e.Cancel = True
        End If
    End Sub

    Private Sub DeselectAllRows()
        If Me.QueueGrid.SelectedRows.Count > 0 Then
            Dim selectedRows As New List(Of DataGridViewRow)
            For Each row As DataGridViewRow In Me.QueueGrid.SelectedRows
                selectedRows.Add(row)
            Next
            For Each row As DataGridViewRow In selectedRows
                row.Selected = False
            Next
        End If
    End Sub

    Private Sub QueueGrid_CellFormatting(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellFormattingEventArgs) Handles QueueGrid.CellFormatting
        If Me.ReleasedColumn.Index = e.ColumnIndex Then
            Dim isReleased As Boolean = Convert.ToBoolean(e.Value)
            If isReleased Then
                e.Value = Me.mReleasedImage
            Else
                e.Value = Me.mUnreleasedImage
            End If
            e.FormattingApplied = True
        End If
    End Sub

    Private Sub QueueGrid_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles QueueGrid.MouseDown
        If (e.Button And Windows.Forms.MouseButtons.Right) = Windows.Forms.MouseButtons.Right Then
            Dim hit As DataGridView.HitTestInfo = Me.QueueGrid.HitTest(e.X, e.Y)
            If hit.Type = DataGridViewHitTestType.Cell Then
                Dim row As DataGridViewRow = Me.QueueGrid.Rows(hit.RowIndex)
                If Not row.Selected Then
                    If Not ModifierKeys = Keys.Control Then
                        DeselectAllRows()
                    End If
                    row.Selected = True
                End If
            End If
        End If
    End Sub


    Private Sub FilterTypeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterTypeList.SelectedIndexChanged
        SetDateFilter()
    End Sub

    Private Sub ReleaseFilterList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ReleaseFilterList.SelectedIndexChanged
        SetReleaseFilter()
    End Sub

    Private Sub ChangePriorityButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangePriorityButton.Click
        Me.ChangePriorityCommand()
    End Sub

    Private Sub RescheduleButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RescheduleButton.Click
        Me.RescheduleCommand()
    End Sub

    Private Sub ChangePriorityToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangePriorityToolStripMenuItem.Click
        Me.ChangePriorityCommand()
    End Sub

    Private Sub RescheduleToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RescheduleToolStripMenuItem.Click
        Me.RescheduleCommand()
    End Sub

    Private Sub QueueGrid_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles QueueGrid.SelectionChanged
        Me.ToggleToolStripButtons()
        Me.StatusLabel.Text = String.Format("{0} of {1} forms selected.", Me.GetSelectedFormCount, Me.mFormCount)
    End Sub

    Private Function GetSelectedFormCount() As Integer
        Dim formCount As Integer = 0

        For Each row As DataGridViewRow In Me.QueueGrid.SelectedRows
            Dim job As FormGenJob = TryCast(row.Tag, FormGenJob)
            If job IsNot Nothing Then
                formCount += job.FormCount
            End If
        Next

        Return formCount
    End Function

    Private Sub ToggleToolStripButtons()
        Me.RescheduleButton.Enabled = Me.QueueGrid.SelectedRows.Count > 0
        Me.ChangePriorityButton.Enabled = Me.QueueGrid.SelectedRows.Count > 0
    End Sub

    Private Sub ChangePriorityCommand()
        If Me.QueueGrid.SelectedRows.Count > 0 Then
            Try
                Me.Cursor = Cursors.WaitCursor
                Dim firstJob As FormGenJob = DirectCast(Me.QueueGrid.SelectedRows(0).Tag, FormGenJob)
                Dim initialPriority As Integer = firstJob.Priority
                Dim dialog As New ChangePriorityDialog
                dialog.PriorityValue = initialPriority
                If dialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                    Dim newPriority As Integer = dialog.PriorityValue
                    Dim job As FormGenJob
                    For Each row As DataGridViewRow In Me.QueueGrid.SelectedRows
                        job = DirectCast(row.Tag, FormGenJob)
                        row.Cells("PriorityColumn").Value = newPriority
                        job.Priority = newPriority
                        job.UpdatePriority()
                    Next
                End If
            Finally
                Me.Cursor = Me.DefaultCursor
            End Try
        End If
    End Sub

    Private Sub RescheduleCommand()
        If Me.QueueGrid.SelectedRows.Count > 0 Then
            Try
                Me.Cursor = Cursors.WaitCursor
                Dim firstJob As FormGenJob = DirectCast(Me.QueueGrid.SelectedRows(0).Tag, FormGenJob)
                Dim initialDate As Date = firstJob.GenerationDate
                Dim dialog As New RescheduleDialog
                dialog.GenerationDate = initialDate
                If dialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                    Dim newDate As Date = dialog.GenerationDate
                    Dim job As FormGenJob
                    For Each row As DataGridViewRow In Me.QueueGrid.SelectedRows
                        job = DirectCast(row.Tag, FormGenJob)
                        job.GenerationDate = newDate
                        job.UpdateGenerationDate()
                    Next
                End If
            Finally
                Me.Cursor = Me.DefaultCursor
            End Try

            'Repopulate grid
            Me.PopulateGrid()
        End If
    End Sub

    Private Sub ScheduleNextStepsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleNextStepsButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            FormGenJob.ScheduleNextMailSteps()
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try

        Me.PopulateGrid()
    End Sub

    Private Sub ReleaseFilterList_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ReleaseFilterList.Click

    End Sub
End Class