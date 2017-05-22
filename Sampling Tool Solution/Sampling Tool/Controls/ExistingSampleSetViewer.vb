Imports System
Imports Nrc.Qualisys.Library
Imports Nrc.Framework.BusinessLogic.Configuration

Public Class ExistingSampleSetViewer

    Private mSurveys As Collection(Of Survey)
    Private mSurveyTypes As SurveyTypeCollection
    Private WithEvents mSampleSetFilterStartDate As ToolStripDateTimePicker
    Private WithEvents mSampleSetFilterEndDate As ToolStripDateTimePicker
    Public Event SampleSetDeleted As EventHandler

#Region " Constructors "
    Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.SampleSetFilter.SelectedIndex = 1
        Me.InitializeSampleSetToolStrip()
        Me.InitializeColumnSortTypes()
    End Sub

#End Region


    Public Sub Populate(ByVal surveys As Collection(Of Survey))
        Me.mSurveys = surveys
        Me.PopulateSampleSets(surveys)
        Me.EnableDisableSampleSetButtons()
        Me.mSurveyTypes = SurveyType.GetAll()
    End Sub

#Region " Private Properties "
    Private ReadOnly Property SelectedSampleSet() As SampleSet
        Get
            If SampleSetGridView.SelectedRows.Count = 1 Then
                Return SampleSet.GetSampleSet(CInt(SampleSetGridView.SelectedRows(0).Tag))
            Else
                Return Nothing
            End If
        End Get
    End Property
    Private ReadOnly Property IsFrequencyCommandEnabled() As Boolean
        Get
            Return Me.SampleSetGridView.SelectedRows.Count = 1
        End Get
    End Property
    Private ReadOnly Property IsReportCommandEnabled() As Boolean
        Get
            Return Me.SampleSetGridView.SelectedRows.Count = 1
        End Get
    End Property
    Private ReadOnly Property IsScheduleCommandEnabled() As Boolean
        Get
            If Me.SampleSetGridView.SelectedRows.Count = 0 Then
                Return False
            End If
            For Each row As DataGridViewRow In Me.SampleSetGridView.SelectedRows
                If row.Cells(Me.SampleSetDateScheduledColumn.Index).Value.ToString <> "" OrElse row.Cells(Me.SampleSetSampledCountColumn.Index).Value.ToString = "0" Then
                    Return False
                End If
            Next
            Return True
        End Get
    End Property
    Private ReadOnly Property IsUnscheduleCommandEnabled() As Boolean
        Get
            If Me.SampleSetGridView.SelectedRows.Count = 0 Then
                Return False
            End If
            For Each row As DataGridViewRow In Me.SampleSetGridView.SelectedRows
                If row.Cells(Me.SampleSetDateScheduledColumn.Index).Value.ToString = "" Then
                    Return False
                End If
            Next
            Return True
        End Get
    End Property
    Private ReadOnly Property IsDeleteCommandenabled() As Boolean
        Get
            If Me.SampleSetGridView.SelectedRows.Count = 0 Then Return False
            For Each row As DataGridViewRow In SampleSetGridView.SelectedRows
                If row.Cells(Me.SampleSetDateScheduledColumn.Index).Value.ToString <> "" Then
                    Return False
                End If
            Next
            Return True
        End Get
    End Property
#End Region

#Region " Control Event Handlers "

    Private Sub SampleSetFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleSetFilter.SelectedIndexChanged
        If mSurveys IsNot Nothing Then
            Me.PopulateSampleSets(mSurveys)
        End If
    End Sub

    Private Sub SampleSetFilterDate_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles mSampleSetFilterStartDate.KeyUp, mSampleSetFilterEndDate.KeyUp
        If e.KeyCode = System.Windows.Forms.Keys.Enter Then
            Me.PopulateSampleSets(mSurveys)
        End If
    End Sub

    Private Sub SampleSetGridView_SelectionChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SampleSetGridView.SelectionChanged
        Me.EnableDisableSampleSetButtons()
    End Sub

    Private Sub FrequenciesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FrequenciesButton.Click
        Me.ShowFrequenciesCommand()
    End Sub

    Private Sub FrequenciesMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FrequenciesMenuItem.Click
        Me.ShowFrequenciesCommand()
    End Sub

    Private Sub ReportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ReportButton.Click
        Me.ShowReportCommand()
    End Sub

    Private Sub ReportMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ReportMenuItem.Click
        Me.ShowReportCommand()
    End Sub

    Private Sub ScheduleButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleButton.Click
        Me.ScheduleSampleSetCommand()
    End Sub

    Private Sub UnscheduleButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnscheduleButton.Click
        Me.UnscheduledSampleSetCommand()
    End Sub

    Private Sub UnscheduleMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UnscheduleMenuItem.Click
        Me.UnscheduledSampleSetCommand()
    End Sub

    Private Sub ScheduleMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ScheduleMenuItem.Click
        Me.ScheduleSampleSetCommand()
    End Sub

    Private Sub DeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteButton.Click
        If MessageBox.Show("Are you sure you want to delete the selected sample set(s)?", "Delete sample set(s)", MessageBoxButtons.YesNo) = DialogResult.Yes Then
            Me.DeleteSampleSetCommand()
        End If
    End Sub

    Private Sub DeleteMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteMenuItem.Click
        Me.DeleteSampleSetCommand()
    End Sub

    Private Sub FilterSampleSetsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterSampleSetsButton.Click
        Me.PopulateSampleSets(Me.mSurveys)
    End Sub
#End Region

#Region " Private Methods "

    Private Sub PopulateSampleSets(ByVal surveys As Collection(Of Survey))
        Dim selectedIds As List(Of Integer) = Me.GetSelectedSampleSetIds
        Me.SampleSetGridView.Rows.Clear()

        Dim blankImg As New Bitmap(16, 16)
        'Dim scheduledImg As Image = My.Resources.Schedule
        Dim scheduledImg As New Bitmap(My.Resources.Schedule32, 16, 16)
        Dim CantScheduleImg As New Bitmap(My.Resources.NoWay, 16, 16)

        For Each srvy As Survey In surveys
            Dim showOnlyUnscheduled As Boolean = (Me.SampleSetFilter.Text = "Unscheduled")
            Dim tbl As DataTable = srvy.GetExistingSampleSetData(Me.mSampleSetFilterStartDate.Value, Me.mSampleSetFilterEndDate.Value, showOnlyUnscheduled)
            Dim i As Integer = 0
            For Each row As DataRow In tbl.Rows


                Dim srvyName As String = String.Format("{0} ({1})", row("strSurvey_nm").ToString.Trim, row("Survey_id").ToString)
                Dim periodName As String = row("strPeriodDef_nm").ToString
                Dim createDate As Date = CType(row("datSampleCreate_dt"), Date)
                Dim creator As String = row("strNTLogin_nm").ToString.Trim
                Dim scheduledDate As String = ""
                If row("datScheduled") IsNot DBNull.Value Then
                    scheduledDate = CType(row("datScheduled"), Date).ToShortDateString
                End If
                Dim sampleSetId As Integer = CType(row("SampleSet_id"), Integer)
                Dim sampledCount As Integer
                If row("sampledCount") IsNot DBNull.Value Then
                    sampledCount = CType(row("sampledCount"), Integer)
                End If

                Dim img As Image
                If row("datScheduled") Is DBNull.Value AndAlso sampledCount > 0 Then
                    img = blankImg
                ElseIf row("datScheduled") Is DBNull.Value AndAlso sampledCount = 0 Then
                    img = CantScheduleImg
                Else
                    img = scheduledImg
                End If

                i = Me.SampleSetGridView.Rows.Add(img, srvyName, periodName, createDate, creator, scheduledDate, sampledCount)
                Me.SampleSetGridView.Rows(i).Tag = sampleSetId
                If selectedIds.Contains(sampleSetId) Then
                    Me.SampleSetGridView.Rows(i).Selected = True
                Else
                    Me.SampleSetGridView.Rows(i).Selected = False
                End If
            Next
        Next

        Me.SampleSetGridView.Sort(Me.SamplesetCreatedColumn, System.ComponentModel.ListSortDirection.Descending)
    End Sub

    Private Function GetSelectedSampleSetIds() As List(Of Integer)
        Dim list As New List(Of Integer)
        For Each row As DataGridViewRow In Me.SampleSetGridView.SelectedRows
            list.Add(CType(row.Tag, Integer))
        Next

        Return list
    End Function

    Private Sub InitializeSampleSetToolStrip()
        Dim endDate As Date = Date.Today
        Dim startDate As Date = endDate.AddDays(-14)
        Dim lbl As ToolStripLabel

        mSampleSetFilterEndDate = New ToolStripDateTimePicker
        mSampleSetFilterEndDate.Format = DateTimePickerFormat.Short
        mSampleSetFilterEndDate.Alignment = ToolStripItemAlignment.Right
        mSampleSetFilterEndDate.Overflow = ToolStripItemOverflow.Never
        mSampleSetFilterEndDate.ToolTipText = "End Date"
        mSampleSetFilterEndDate.Value = endDate
        Me.SampleSetToolStrip.Items.Add(mSampleSetFilterEndDate)

        lbl = New ToolStripLabel("and")
        lbl.Alignment = ToolStripItemAlignment.Right
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.SampleSetToolStrip.Items.Add(lbl)

        mSampleSetFilterStartDate = New ToolStripDateTimePicker
        mSampleSetFilterStartDate.Format = DateTimePickerFormat.Short
        mSampleSetFilterStartDate.Alignment = ToolStripItemAlignment.Right
        mSampleSetFilterStartDate.Overflow = ToolStripItemOverflow.Never
        mSampleSetFilterStartDate.ToolTipText = "Start Date"
        mSampleSetFilterStartDate.Value = startDate
        Me.SampleSetToolStrip.Items.Add(mSampleSetFilterStartDate)

        lbl = New ToolStripLabel("Created between")
        lbl.Alignment = ToolStripItemAlignment.Right
        lbl.Overflow = ToolStripItemOverflow.Never
        Me.SampleSetToolStrip.Items.Add(lbl)
    End Sub

    Private Sub InitializeColumnSortTypes()
        Me.SamplesetCreatedColumn.ValueType = GetType(Date)
    End Sub

    Private Sub ShowFrequenciesCommand()
        Dim freqPath As String = IO.Path.Combine(AppConfig.Params("QualisysInstallPath").StringValue, "FrequencyTool.exe")
        Dim ss As SampleSet = SelectedSampleSet()
        If ss Is Nothing Then
            Dim errMsg As String
            Dim row As DataGridViewRow = SampleSetGridView.SelectedRows(0)
            errMsg = String.Format("Sample set {0} for survey {1} has been deleted by someone else.", row.Cells(Me.SamplesetCreatedColumn.Index).Value.ToString, row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString)
            MessageBox.Show(errMsg, "Deleted Sample", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If

        'Check to see that the Frequency Tool exists in the current directory.
        'Launch it if the EXE exists, display message if it doesn't
        If IO.File.Exists(freqPath) Then
            Dim srvy As Survey = Survey.Get(ss.SurveyId)
            Dim args As String = String.Format("caller=Sampling;study={0};survey={1}", srvy.Study.Id, srvy.Id)
            Process.Start(freqPath, args)
        Else
            MessageBox.Show("Frequency Tool is not installed correctly. Contact the system administrator.", "Frequency Tool Not Found", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
        End If

    End Sub

    ''' <summary>This method will now use reporting serivces rather than dashboard.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ShowReportCommand()

        Dim clnt As Client
        Dim stdy As Study
        Dim srvy As Survey

        'Get the sampleset, client, study, and survey objects
        Dim ss As SampleSet = SelectedSampleSet()

        If ss Is Nothing Then
            Dim errMsg As String
            Dim row As DataGridViewRow = SampleSetGridView.SelectedRows(0)
            errMsg = String.Format("Sample set {0} for survey {1} has been deleted by someone else.", row.Cells(Me.SamplesetCreatedColumn.Index).Value.ToString, row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString)
            MessageBox.Show(errMsg, "Deleted Sample", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If

        srvy = Survey.Get(ss.SurveyId)
        stdy = srvy.Study
        clnt = stdy.Client

        Dim path As String = String.Format("{0}&client_id={1}&study_id={2}&survey_id={3}&samplesets={4}&ShowLink=True", AppConfig.Params("SPWPath").StringValue, clnt.Id, stdy.Id, srvy.Id, ss.Id)
        System.Diagnostics.Process.Start("IExplore.exe", path)

    End Sub

    Private Sub ScheduleSampleSetCommand()
        Dim errMsg As String = ""
        Try
            Me.Cursor = Cursors.WaitCursor
            Dim affectsMultipleRows As Boolean = SampleSetGridView.SelectedRows.Count > 1

            ' warn the user when multiple rows are selected
            If affectsMultipleRows AndAlso MessageBox.Show("Multiple sample set dates will be set.",
                                                           "Multiple selection",
                                                           MessageBoxButtons.OKCancel,
                                                           MessageBoxIcon.Warning) <> DialogResult.OK Then
                Return
            End If

            For Each row As DataGridViewRow In SampleSetGridView.SelectedRows
                Dim sampleSetId As Integer = CType(row.Tag, Integer)
                Dim theSampleSet As SampleSet = SampleSet.GetSampleSet(sampleSetId)
                If theSampleSet Is Nothing Then
                    errMsg = String.Format("Sample set {0} for survey {1} has been deleted by someone else and will not be scheduled.",
                                           row.Cells(Me.SamplesetCreatedColumn.Index).Value.ToString,
                                           row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString)
                    MessageBox.Show(errMsg, "Deleted Sample", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Return
                End If

                Dim theSurvey As Survey = Survey.Get(theSampleSet.SurveyId)
                Dim defaultAdjustment As Integer = theSurvey.DefaultScheduleDateAdjustmentByMonths
                Dim generationDate As Date = Date.Today

                If defaultAdjustment <> 0 Then
                    Dim startDate As DateTime = Convert.ToDateTime(theSampleSet.DateRangeFrom.Value)
                    generationDate = startDate.AddMonths(defaultAdjustment).AddDays(-1)
                End If

                ' only confirm the date when one row has been selected
                If Not affectsMultipleRows Then
                    Dim dateConfirmationDialog As New GenerationDateDialog
                    dateConfirmationDialog.SelectedDate = generationDate

                    If dateConfirmationDialog.ShowDialog <> DialogResult.OK Then
                        Return
                    End If

                    generationDate = dateConfirmationDialog.SelectedDate
                End If

                Try
                    theSampleSet.ScheduleSampleSetGeneration(generationDate)
                Catch ex As Exception
                    errMsg = String.Format("Sample set {0} for survey {1} could not be scheduled.  {2}{3}",
                                           theSampleSet.DateCreated.ToString,
                                           row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString,
                                           Environment.NewLine,
                                           ex.Message)
                    MessageBox.Show(errMsg, "Scheduling Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            Next

            Me.PopulateSampleSets(mSurveys)
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try
    End Sub

    Private Sub UnscheduledSampleSetCommand()
        Dim errMsg As String = ""
        Try
            Me.Cursor = Cursors.WaitCursor

            For Each row As DataGridViewRow In SampleSetGridView.SelectedRows
                Dim sampleSetId As Integer = CType(row.Tag, Integer)
                Dim sample As SampleSet = SampleSet.GetSampleSet(sampleSetId)
                If sample Is Nothing Then
                    errMsg = String.Format("Sample set {0} for survey {1} has been deleted by someone else.", row.Cells(Me.SamplesetCreatedColumn.Index).Value.ToString, row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString)
                    MessageBox.Show(errMsg, "Deleted Sample", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Else
                    Try
                        sample.UnscheduleSampleSetGeneration()
                    Catch ex As Exception
                        errMsg = String.Format("Sample set {0} for survey {1} could not be unscheduled.  {2}{3}", sample.DateCreated.ToString, row.Cells(Me.SampleSetSurveyColumn.Index).Value.ToString, Environment.NewLine, ex.Message)
                        MessageBox.Show(errMsg, "Unscheduling Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    End Try
                End If
            Next

            Me.PopulateSampleSets(mSurveys)
        Finally
            Me.Cursor = Me.DefaultCursor
        End Try
    End Sub

    Private Sub DeleteSampleSetCommand()
        For Each dgr As DataGridViewRow In SampleSetGridView.SelectedRows
            SampleSet.DeleteSampleSet(CInt(dgr.Tag))
        Next

        For Each srvy As Survey In mSurveys
            srvy.Refresh()
        Next
        RaiseEvent SampleSetDeleted(Me, EventArgs.Empty)

        Me.PopulateSampleSets(mSurveys)
    End Sub

    Public Sub EnableDisableSampleSetButtons()
        Me.FrequenciesButton.Enabled = Me.IsFrequencyCommandEnabled
        Me.FrequenciesMenuItem.Enabled = Me.IsFrequencyCommandEnabled

        Me.ReportButton.Enabled = Me.IsReportCommandEnabled
        Me.ReportMenuItem.Enabled = Me.IsReportCommandEnabled

        Dim hasConnectSurveys As Boolean = Me.HasConnectSurveys()
        Me.ScheduleButton.Enabled = Me.IsScheduleCommandEnabled And Not hasConnectSurveys
        Me.ScheduleMenuItem.Enabled = Me.IsScheduleCommandEnabled And Not hasConnectSurveys

        Me.UnscheduleButton.Enabled = Me.IsUnscheduleCommandEnabled
        Me.UnscheduleMenuItem.Enabled = Me.IsUnscheduleCommandEnabled

        Me.DeleteButton.Enabled = Me.IsDeleteCommandenabled
        Me.DeleteMenuItem.Enabled = Me.IsDeleteCommandenabled
    End Sub

    Private Function HasConnectSurveys() As Boolean
        Dim list As List(Of Survey) = New List(Of Survey)(Me.mSurveys)
        Return list.Exists(Function(s) s.IsSamplesetSchedulingDisabled)
    End Function
#End Region
End Class
