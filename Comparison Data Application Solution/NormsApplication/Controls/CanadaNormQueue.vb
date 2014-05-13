Option Explicit On 
Option Strict On

Imports System.Text
Imports NRC.WinForms

Public Class CanadaNormQueue
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        InitDayFilter()
    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents lvwList As NRC.WinForms.NRCListView
    Friend WithEvents cmnListMenu As System.Windows.Forms.ContextMenu
    Friend WithEvents btnRefresh As System.Windows.Forms.Button
    Friend WithEvents mniReport As System.Windows.Forms.MenuItem
    Friend WithEvents mniRemove As System.Windows.Forms.MenuItem
    Friend WithEvents cboFilterDay As System.Windows.Forms.ComboBox
    Friend WithEvents chdNormJobID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdNormName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdScheduler As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdStatus As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdScheduleDate As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdBeginDate As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdTimeUsed As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdScheduleStartTime As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdPromoteDate As NRC.WinForms.NRCColumnHeader
    Friend WithEvents pnlBack As NRC.WinForms.SectionPanel
    Friend WithEvents MenuItem1 As System.Windows.Forms.MenuItem
    Friend WithEvents mniRefresh As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lvwList = New NRC.WinForms.NRCListView
        Me.chdNormJobID = New NRC.WinForms.NRCColumnHeader
        Me.chdNormName = New System.Windows.Forms.ColumnHeader
        Me.chdStatus = New System.Windows.Forms.ColumnHeader
        Me.chdScheduler = New System.Windows.Forms.ColumnHeader
        Me.chdScheduleDate = New NRC.WinForms.NRCColumnHeader
        Me.chdBeginDate = New NRC.WinForms.NRCColumnHeader
        Me.chdTimeUsed = New NRC.WinForms.NRCColumnHeader
        Me.chdScheduleStartTime = New NRC.WinForms.NRCColumnHeader
        Me.chdPromoteDate = New NRC.WinForms.NRCColumnHeader
        Me.cmnListMenu = New System.Windows.Forms.ContextMenu
        Me.mniReport = New System.Windows.Forms.MenuItem
        Me.mniRemove = New System.Windows.Forms.MenuItem
        Me.MenuItem1 = New System.Windows.Forms.MenuItem
        Me.mniRefresh = New System.Windows.Forms.MenuItem
        Me.pnlBack = New NRC.WinForms.SectionPanel
        Me.cboFilterDay = New System.Windows.Forms.ComboBox
        Me.btnRefresh = New System.Windows.Forms.Button
        Me.pnlBack.SuspendLayout()
        Me.SuspendLayout()
        '
        'lvwList
        '
        Me.lvwList.AlternateColor1 = System.Drawing.Color.White
        Me.lvwList.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdNormJobID, Me.chdNormName, Me.chdStatus, Me.chdScheduler, Me.chdScheduleDate, Me.chdBeginDate, Me.chdTimeUsed, Me.chdScheduleStartTime, Me.chdPromoteDate})
        Me.lvwList.ContextMenu = Me.cmnListMenu
        Me.lvwList.FullRowSelect = True
        Me.lvwList.GridLines = True
        Me.lvwList.HideSelection = False
        Me.lvwList.Location = New System.Drawing.Point(16, 64)
        Me.lvwList.Name = "lvwList"
        Me.lvwList.Size = New System.Drawing.Size(752, 376)
        Me.lvwList.SortColumn = -1
        Me.lvwList.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwList.TabIndex = 0
        Me.lvwList.View = System.Windows.Forms.View.Details
        '
        'chdNormJobID
        '
        Me.chdNormJobID.DataType = NRC.WinForms.DataType._Unknown
        Me.chdNormJobID.Text = "Job ID"
        Me.chdNormJobID.Width = 65
        Me.chdNormJobID.WidthAutoAdjust = False
        Me.chdNormJobID.WidthProportion = 0
        '
        'chdNormName
        '
        Me.chdNormName.Text = "Norm Group"
        Me.chdNormName.Width = 100
        '
        'chdStatus
        '
        Me.chdStatus.Text = "Status"
        Me.chdStatus.Width = 100
        '
        'chdScheduler
        '
        Me.chdScheduler.Text = "Scheduler"
        Me.chdScheduler.Width = 100
        '
        'chdScheduleDate
        '
        Me.chdScheduleDate.DataType = NRC.WinForms.DataType._Unknown
        Me.chdScheduleDate.Text = "Date Queued"
        Me.chdScheduleDate.Width = 90
        Me.chdScheduleDate.WidthAutoAdjust = False
        Me.chdScheduleDate.WidthProportion = 0
        '
        'chdBeginDate
        '
        Me.chdBeginDate.DataType = NRC.WinForms.DataType._Unknown
        Me.chdBeginDate.Text = "Start Time"
        Me.chdBeginDate.Width = 100
        Me.chdBeginDate.WidthAutoAdjust = False
        Me.chdBeginDate.WidthProportion = 0
        '
        'chdTimeUsed
        '
        Me.chdTimeUsed.DataType = NRC.WinForms.DataType._Unknown
        Me.chdTimeUsed.Text = "Duration"
        Me.chdTimeUsed.Width = 65
        Me.chdTimeUsed.WidthAutoAdjust = False
        Me.chdTimeUsed.WidthProportion = 0
        '
        'chdScheduleStartTime
        '
        Me.chdScheduleStartTime.DataType = NRC.WinForms.DataType._Unknown
        Me.chdScheduleStartTime.Text = "Schd Start Time"
        Me.chdScheduleStartTime.Width = 90
        Me.chdScheduleStartTime.WidthAutoAdjust = False
        Me.chdScheduleStartTime.WidthProportion = 0
        '
        'chdPromoteDate
        '
        Me.chdPromoteDate.DataType = NRC.WinForms.DataType._Unknown
        Me.chdPromoteDate.Text = "Date Promoted"
        Me.chdPromoteDate.Width = 100
        Me.chdPromoteDate.WidthAutoAdjust = False
        Me.chdPromoteDate.WidthProportion = 0
        '
        'cmnListMenu
        '
        Me.cmnListMenu.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mniReport, Me.mniRemove, Me.MenuItem1, Me.mniRefresh})
        '
        'mniReport
        '
        Me.mniReport.Index = 0
        Me.mniReport.Text = "Summary Report"
        '
        'mniRemove
        '
        Me.mniRemove.Index = 1
        Me.mniRemove.Text = "Remove"
        '
        'MenuItem1
        '
        Me.MenuItem1.Index = 2
        Me.MenuItem1.Text = "-"
        '
        'mniRefresh
        '
        Me.mniRefresh.Index = 3
        Me.mniRefresh.Shortcut = System.Windows.Forms.Shortcut.F5
        Me.mniRefresh.Text = "Refresh"
        '
        'pnlBack
        '
        Me.pnlBack.AutoScroll = True
        Me.pnlBack.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlBack.Caption = "Norm Update Queue Status"
        Me.pnlBack.Controls.Add(Me.cboFilterDay)
        Me.pnlBack.Controls.Add(Me.btnRefresh)
        Me.pnlBack.Controls.Add(Me.lvwList)
        Me.pnlBack.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBack.DockPadding.All = 1
        Me.pnlBack.Location = New System.Drawing.Point(0, 0)
        Me.pnlBack.Name = "pnlBack"
        Me.pnlBack.ShowCaption = True
        Me.pnlBack.Size = New System.Drawing.Size(784, 448)
        Me.pnlBack.TabIndex = 1
        '
        'cboFilterDay
        '
        Me.cboFilterDay.DisplayMember = "Text"
        Me.cboFilterDay.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFilterDay.Location = New System.Drawing.Point(16, 40)
        Me.cboFilterDay.Name = "cboFilterDay"
        Me.cboFilterDay.Size = New System.Drawing.Size(104, 21)
        Me.cboFilterDay.TabIndex = 3
        Me.cboFilterDay.ValueMember = "Value"
        '
        'btnRefresh
        '
        Me.btnRefresh.Location = New System.Drawing.Point(128, 40)
        Me.btnRefresh.Name = "btnRefresh"
        Me.btnRefresh.Size = New System.Drawing.Size(80, 21)
        Me.btnRefresh.TabIndex = 2
        Me.btnRefresh.Text = "Refresh  (F5)"
        '
        'CanadaNormQueue
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.pnlBack)
        Me.Name = "CanadaNormQueue"
        Me.Size = New System.Drawing.Size(784, 448)
        Me.pnlBack.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Fields"

    Private mController As New CanadaNormQueueController

    Private Shared CAPTION As String = "Norm Update Queue Status"

    Private Enum ListField
        NormJobID = 0
        NormName = 1
        JobStatusLabel = 2
        SchedulerName = 3
        QueuedDate = 4
        StartTime = 5
        TimeUsed = 6
        ScheduledStartDate = 7
        PromoteDate = 8
        JobStatus = 9
        NormID = 10
    End Enum

    Private Enum JobStatus As Integer
        Queued = 1
        Schuduled = 5
        ToBeProcessed = 10
        BeginToProcess = 20
        Logging = 25
        Clearing = 30
        PopulateAgg = 35
        EndAgg = 40
        GenNorm = 45
        NormGened = 50
        GenEnd = 55
        Approved = 60
        Disapproved = 65
        Promoting = 70
        Promoted = 75

        ErrorSettingNotApproved = 100
        ErrorInitialize = 120
        ErrorLogging = 125
        ErrorClearing = 130
        ErrorPopulateAgg = 135
        ErrorGenNorm = 145
        ErrorPromote = 170

        ErrorOthers = 200

        Cancelled = 254
        Removed = 255

    End Enum

#End Region

#Region " Public Methods"

    Public Sub Start()
        lvwList.SortColumn = -1
        lvwList.SortOrder = SortOrder.NotSorted
        If (cboFilterDay.SelectedIndex <> 0) Then
            cboFilterDay.SelectedIndex = 0
        Else
            DisplayList()
        End If
    End Sub

#End Region

#Region " Event Handlers"

    Private Sub cboFilterDay_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cboFilterDay.SelectedValueChanged
        RefreshList()
    End Sub

    Private Sub btnRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnRefresh.Click
        RefreshList()
    End Sub

    Private Sub lvwList_Sorted(ByVal sender As Object, ByVal e As NRC.WinForms.ListViewSortedEventArgs) Handles lvwList.Sorted
        lvwList.BeginUpdate()
        AutoFitColumnWidth(lvwList, ListField.NormName)
        lvwList.PaintAlternatingBackColor()
        lvwList.EndUpdate()
    End Sub

    Private Sub lvwList_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lvwList.KeyDown, pnlBack.KeyDown, cboFilterDay.KeyDown, btnRefresh.KeyDown, MyBase.KeyDown
        If (e.KeyCode = Keys.F5) Then RefreshList()
    End Sub

    Private Sub cmnListMenu_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmnListMenu.Popup
        Dim showSummaryReportMenu As Boolean = True
        Dim showRemoveMenu As Boolean = True
        Dim item As ListViewItem
        Dim jobStatus As JobStatus

        'No job selected
        If (lvwList.SelectedItems.Count = 0) Then
            mniReport.Enabled = False
            mniRemove.Enabled = False
            Return
        End If

        'Do not show report menu if multiple jobs are selected
        If (lvwList.SelectedItems.Count > 1) Then
            showSummaryReportMenu = False
        End If

        'Check which menu items show be enabled
        For Each item In lvwList.SelectedItems
            jobStatus = CType(item.SubItems(ListField.JobStatus).Text, JobStatus)

            Select Case jobStatus
                Case jobStatus.Queued, jobStatus.Schuduled, jobStatus.ToBeProcessed
                    showSummaryReportMenu = False

                Case jobStatus.BeginToProcess, jobStatus.Logging, jobStatus.Clearing, _
                     jobStatus.PopulateAgg, jobStatus.EndAgg, jobStatus.GenNorm, _
                     jobStatus.NormGened

                    showSummaryReportMenu = False
                    showRemoveMenu = False

                Case jobStatus.GenEnd
                    'N/A

                Case jobStatus.Approved, jobStatus.Promoting, jobStatus.Promoted
                    showRemoveMenu = False

                Case jobStatus.Disapproved

                Case jobStatus.ErrorSettingNotApproved, jobStatus.ErrorInitialize, jobStatus.ErrorLogging, _
                     jobStatus.ErrorPopulateAgg, jobStatus.ErrorGenNorm, jobStatus.ErrorOthers
                    showSummaryReportMenu = False

                Case jobStatus.ErrorPromote

                Case jobStatus.Cancelled, jobStatus.Removed
                    showSummaryReportMenu = False
                    showRemoveMenu = False

            End Select

        Next

        mniReport.Enabled = showSummaryReportMenu
        mniRemove.Enabled = showRemoveMenu

    End Sub

    Private Sub mniReport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mniReport.Click
        If (lvwList.SelectedItems.Count = 0) Then Return

        Dim item As ListViewItem = lvwList.SelectedItems(0)
        Dim normID As Integer = CInt(item.SubItems(ListField.NormID).Text)
        Dim normName As String = item.SubItems(ListField.NormName).Text
        Dim normJobID As Integer = CInt(item.SubItems(ListField.NormJobID).Text)


        Dim isApprove As Boolean
        Dim reportViewer As New frmReportReviewer
        reportViewer.LoadNormQuestionScoreReport(normID, normName)
        Dim result As DialogResult = reportViewer.ShowDialog(Me)
        Select Case result
            Case DialogResult.Yes
                isApprove = True
            Case DialogResult.No
                isApprove = False
            Case Else
                Return
        End Select

        Me.mController.ApproveNormUpdate(normJobID, isApprove)

        DisplayList()
        For Each item In lvwList.Items
            If (normJobID = CInt(item.SubItems(ListField.NormJobID).Text)) Then
                item.Selected = True
                item.EnsureVisible()
                item.Focused = True
                Exit For
            End If
        Next

    End Sub

    Private Sub mniRemove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mniRemove.Click
        Dim item As ListViewItem
        Dim normJobID As Integer

        For Each item In lvwList.SelectedItems
            normJobID = CInt(item.SubItems(ListField.NormJobID).Text)
            Me.mController.RemoveJob(normJobID)
        Next

        DisplayList()
    End Sub

    Private Sub mniRefresh_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mniRefresh.Click
        DisplayList()
    End Sub

#End Region

#Region " Private Methods"

    Private Sub InitDayFilter()
        Dim items As New ArrayList
        Dim i As Integer

        items.Add(New ListBoxItem(1, "Today"))

        For i = 2 To 31
            items.Add(New ListBoxItem(i, "Last " & i & " Days"))
        Next
        cboFilterDay.DataSource = items
        cboFilterDay.SelectedIndex = 0
    End Sub

    Private Sub DisplayList()
        If (cboFilterDay.SelectedIndex = -1) Then
            cboFilterDay.SelectedIndex = 0
        End If
        Dim days As Integer = CInt(cboFilterDay.SelectedValue)

        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing
        Dim normJobID As String
        Dim normName As String
        Dim jobStatusLabel As String
        Dim schedulerName As String
        Dim queuedDate As String
        Dim startTime As String
        Dim timeUsed As String
        Dim scheduledStartDate As String
        Dim promoteDate As String
        Dim jobStatusValue As String
        Dim normID As String
        Dim status As JobStatus
        Dim item As ListViewItem
        Dim statusColor As Color

        Try
            rdr = Me.mController.SelectJobQueue()
            lvwList.BeginUpdate()
            lvwList.Items.Clear()
            Do While rdr.Read
                normJobID = CInt(rdr("NormJob_ID")).ToString
                normName = CStr(rdr("NormLabel")) + " (" & CInt(rdr("Norm_ID")) & ")"
                jobStatusLabel = CStr(rdr("StatusLabel"))
                schedulerName = CStr(rdr("SchedulerName"))
                queuedDate = CDate(rdr("DateScheduled")).ToString("MM/dd/yy HH:mm")
                If (IsDBNull(rdr("JobBeginTime"))) Then
                    startTime = ""
                Else
                    startTime = CDate(rdr("JobBeginTime")).ToString("MM/dd/yy HH:mm")
                End If
                If (IsDBNull(rdr("ProcessTimeUsed"))) Then
                    timeUsed = ""
                Else
                    timeUsed = CInt(rdr("ProcessTimeUsed")).ToString
                End If
                If (IsDBNull(rdr("ScheduledStartTime"))) Then
                    scheduledStartDate = ""
                Else
                    scheduledStartDate = CDate(rdr("ScheduledStartTime")).ToString("MM/dd/yy HH:mm")
                End If
                If (IsDBNull(rdr("PromoteEndTime"))) Then
                    promoteDate = ""
                Else
                    promoteDate = CDate(rdr("PromoteEndTime")).ToString("MM/dd/yy HH:mm")
                End If
                status = CType(rdr("Status"), JobStatus)
                jobStatusValue = CInt(status).ToString
                normID = CInt(rdr("Norm_ID")).ToString

                item = New ListViewItem(normJobID)
                item.SubItems.Add(normName)
                item.SubItems.Add(jobStatusLabel)
                item.SubItems.Add(schedulerName)
                item.SubItems.Add(queuedDate)
                item.SubItems.Add(startTime)
                item.SubItems.Add(timeUsed)
                item.SubItems.Add(scheduledStartDate)
                item.SubItems.Add(promoteDate)
                item.SubItems.Add(jobStatusValue)
                item.SubItems.Add(normID)

                Select Case status
                    Case JobStatus.Promoted
                        statusColor = Color.Blue
                    Case JobStatus.ErrorSettingNotApproved, JobStatus.ErrorInitialize, _
                         JobStatus.ErrorLogging, JobStatus.ErrorClearing, JobStatus.ErrorPopulateAgg, _
                         JobStatus.ErrorGenNorm, JobStatus.ErrorPromote
                        statusColor = Color.Red
                    Case Else
                        statusColor = Color.Black
                End Select
                item.SubItems(ListField.JobStatusLabel).ForeColor = statusColor
                item.UseItemStyleForSubItems = False

                lvwList.Items.Add(item)
            Loop

            If (lvwList.SortColumn = -1 OrElse lvwList.SortOrder = SortOrder.NotSorted) Then
                lvwList.SortColumn = ListField.NormJobID
                lvwList.SortOrder = SortOrder.Ascend
            Else
                lvwList.Sort()
            End If

            'lvwList.SortOrder = SortOrder.NotSorted
            'AutoResizeColumn(lvwList, ListField.NormName)

            'PaintAlternatingBackColor(lvwList, Color.White, Color.Gainsboro)

            lvwList.EndUpdate()

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
        End Try

    End Sub

    Private Sub AutoFitColumnWidth(ByVal lvw As NRCListView, ByVal resizableColumnIndex As Integer)
        lvw.AutoFitColumnWidth()

        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            If width > .Columns(resizableColumnIndex).Width Then
                .Columns(resizableColumnIndex).Width = width
            End If
        End With

    End Sub

    Private Sub RefreshList()
        If (cboFilterDay.Items.Count = 0) Then Return
        If (cboFilterDay.SelectedIndex = -1) Then
            cboFilterDay.SelectedIndex = -1
            Return
        End If
        Me.mController.Days = CInt(cboFilterDay.SelectedValue)
        DisplayList()
    End Sub

#End Region

End Class
