Option Explicit On 
Option Strict On

Imports System.Text
'Imports System.Data.SqlClient
Imports NormsApplicationBusinessObjectsLibrary
Imports NRC.WinForms

Public Class CanadaNormSchedule
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

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
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents Label32 As System.Windows.Forms.Label
    Friend WithEvents Label33 As System.Windows.Forms.Label
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnSubmit As System.Windows.Forms.Button
    Friend WithEvents optSchedule As System.Windows.Forms.RadioButton
    Friend WithEvents optImmediately As System.Windows.Forms.RadioButton
    Friend WithEvents dtpSchedule As System.Windows.Forms.DateTimePicker
    Friend WithEvents lvwList As NRC.WinForms.NRCListView
    Friend WithEvents chdName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents lnkDeselectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lblSelectCount As System.Windows.Forms.Label
    Friend WithEvents lblTotalCount As System.Windows.Forms.Label
    Friend WithEvents lnkSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkSelectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(CanadaNormSchedule))
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.lvwList = New NRC.WinForms.NRCListView
        Me.chdName = New System.Windows.Forms.ColumnHeader
        Me.chdID = New NRC.WinForms.NRCColumnHeader
        Me.chdDescription = New System.Windows.Forms.ColumnHeader
        Me.lnkDeselectHighlight = New System.Windows.Forms.LinkLabel
        Me.lblSelectCount = New System.Windows.Forms.Label
        Me.Label33 = New System.Windows.Forms.Label
        Me.lblTotalCount = New System.Windows.Forms.Label
        Me.Label32 = New System.Windows.Forms.Label
        Me.lnkSelectAll = New System.Windows.Forms.LinkLabel
        Me.lnDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkSelectHighlight = New System.Windows.Forms.LinkLabel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnSubmit = New System.Windows.Forms.Button
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.dtpSchedule = New System.Windows.Forms.DateTimePicker
        Me.optSchedule = New System.Windows.Forms.RadioButton
        Me.optImmediately = New System.Windows.Forms.RadioButton
        Me.SectionPanel1.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.AutoScroll = True
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Norm Update Scheduler"
        Me.SectionPanel1.Controls.Add(Me.Panel2)
        Me.SectionPanel1.Controls.Add(Me.Panel1)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(712, 440)
        Me.SectionPanel1.TabIndex = 0
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.Label2)
        Me.Panel2.Controls.Add(Me.Label6)
        Me.Panel2.Controls.Add(Me.lvwList)
        Me.Panel2.Controls.Add(Me.lnkDeselectHighlight)
        Me.Panel2.Controls.Add(Me.lblSelectCount)
        Me.Panel2.Controls.Add(Me.Label33)
        Me.Panel2.Controls.Add(Me.lblTotalCount)
        Me.Panel2.Controls.Add(Me.Label32)
        Me.Panel2.Controls.Add(Me.lnkSelectAll)
        Me.Panel2.Controls.Add(Me.lnDeselectAll)
        Me.Panel2.Controls.Add(Me.lnkSelectHighlight)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel2.Location = New System.Drawing.Point(1, 27)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(710, 276)
        Me.Panel2.TabIndex = 0
        '
        'Label2
        '
        Me.Label2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(16, 40)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(672, 16)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "List only contains norms that are approved but not scheduled"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'Label6
        '
        Me.Label6.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(16, 16)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(312, 23)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "Which norms do you want to update?"
        '
        'lvwList
        '
        Me.lvwList.AlternateColor1 = System.Drawing.Color.White
        Me.lvwList.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwList.CheckBoxes = True
        Me.lvwList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdName, Me.chdID, Me.chdDescription})
        Me.lvwList.FullRowSelect = True
        Me.lvwList.GridLines = True
        Me.lvwList.HideSelection = False
        Me.lvwList.Location = New System.Drawing.Point(16, 56)
        Me.lvwList.Name = "lvwList"
        Me.lvwList.Size = New System.Drawing.Size(672, 184)
        Me.lvwList.SortColumn = -1
        Me.lvwList.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwList.TabIndex = 2
        Me.lvwList.View = System.Windows.Forms.View.Details
        '
        'chdName
        '
        Me.chdName.Text = "Norm Group Name"
        Me.chdName.Width = 130
        '
        'chdID
        '
        Me.chdID.DataType = NRC.WinForms.DataType._Unknown
        Me.chdID.Text = "ID"
        Me.chdID.WidthAutoAdjust = False
        Me.chdID.WidthProportion = 0
        '
        'chdDescription
        '
        Me.chdDescription.Text = "Description"
        Me.chdDescription.Width = 175
        '
        'lnkDeselectHighlight
        '
        Me.lnkDeselectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkDeselectHighlight.Image = CType(resources.GetObject("lnkDeselectHighlight.Image"), System.Drawing.Image)
        Me.lnkDeselectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkDeselectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkDeselectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkDeselectHighlight.Location = New System.Drawing.Point(288, 248)
        Me.lnkDeselectHighlight.Name = "lnkDeselectHighlight"
        Me.lnkDeselectHighlight.Size = New System.Drawing.Size(116, 16)
        Me.lnkDeselectHighlight.TabIndex = 6
        Me.lnkDeselectHighlight.TabStop = True
        Me.lnkDeselectHighlight.Text = "Deselect Highlights"
        Me.lnkDeselectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkDeselectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lblSelectCount
        '
        Me.lblSelectCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblSelectCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSelectCount.Location = New System.Drawing.Point(608, 248)
        Me.lblSelectCount.Name = "lblSelectCount"
        Me.lblSelectCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSelectCount.TabIndex = 9
        Me.lblSelectCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label33
        '
        Me.Label33.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label33.Location = New System.Drawing.Point(640, 248)
        Me.Label33.Name = "Label33"
        Me.Label33.Size = New System.Drawing.Size(48, 16)
        Me.Label33.TabIndex = 10
        Me.Label33.Text = "selected"
        Me.Label33.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblTotalCount
        '
        Me.lblTotalCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblTotalCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblTotalCount.Location = New System.Drawing.Point(530, 248)
        Me.lblTotalCount.Name = "lblTotalCount"
        Me.lblTotalCount.Size = New System.Drawing.Size(32, 16)
        Me.lblTotalCount.TabIndex = 7
        Me.lblTotalCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label32
        '
        Me.Label32.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label32.Location = New System.Drawing.Point(568, 248)
        Me.Label32.Name = "Label32"
        Me.Label32.Size = New System.Drawing.Size(32, 16)
        Me.Label32.TabIndex = 8
        Me.Label32.Text = "total"
        Me.Label32.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lnkSelectAll
        '
        Me.lnkSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkSelectAll.Image = CType(resources.GetObject("lnkSelectAll.Image"), System.Drawing.Image)
        Me.lnkSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkSelectAll.Location = New System.Drawing.Point(16, 248)
        Me.lnkSelectAll.Name = "lnkSelectAll"
        Me.lnkSelectAll.Size = New System.Drawing.Size(68, 16)
        Me.lnkSelectAll.TabIndex = 3
        Me.lnkSelectAll.TabStop = True
        Me.lnkSelectAll.Text = "Select All"
        Me.lnkSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnDeselectAll
        '
        Me.lnDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnDeselectAll.Image = CType(resources.GetObject("lnDeselectAll.Image"), System.Drawing.Image)
        Me.lnDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnDeselectAll.Location = New System.Drawing.Point(88, 248)
        Me.lnDeselectAll.Name = "lnDeselectAll"
        Me.lnDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnDeselectAll.TabIndex = 4
        Me.lnDeselectAll.TabStop = True
        Me.lnDeselectAll.Text = "Deselect All"
        Me.lnDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkSelectHighlight
        '
        Me.lnkSelectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSelectHighlight.Image = CType(resources.GetObject("lnkSelectHighlight.Image"), System.Drawing.Image)
        Me.lnkSelectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSelectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSelectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkSelectHighlight.Location = New System.Drawing.Point(176, 248)
        Me.lnkSelectHighlight.Name = "lnkSelectHighlight"
        Me.lnkSelectHighlight.Size = New System.Drawing.Size(104, 16)
        Me.lnkSelectHighlight.TabIndex = 5
        Me.lnkSelectHighlight.TabStop = True
        Me.lnkSelectHighlight.Text = "Select Highlights"
        Me.lnkSelectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSelectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.btnCancel)
        Me.Panel1.Controls.Add(Me.btnSubmit)
        Me.Panel1.Controls.Add(Me.GroupBox1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel1.Location = New System.Drawing.Point(1, 303)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(710, 136)
        Me.Panel1.TabIndex = 1
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(608, 88)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(80, 23)
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        '
        'btnSubmit
        '
        Me.btnSubmit.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSubmit.Location = New System.Drawing.Point(520, 88)
        Me.btnSubmit.Name = "btnSubmit"
        Me.btnSubmit.Size = New System.Drawing.Size(80, 23)
        Me.btnSubmit.TabIndex = 1
        Me.btnSubmit.Text = "Submit"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Controls.Add(Me.dtpSchedule)
        Me.GroupBox1.Controls.Add(Me.optSchedule)
        Me.GroupBox1.Controls.Add(Me.optImmediately)
        Me.GroupBox1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox1.Location = New System.Drawing.Point(16, 16)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(392, 96)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Schedule Norm Updating Time"
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(264, 56)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(96, 24)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "( Recommended )"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'dtpSchedule
        '
        Me.dtpSchedule.CustomFormat = "MM/dd/yyyy HH:mm"
        Me.dtpSchedule.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.dtpSchedule.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.dtpSchedule.Location = New System.Drawing.Point(128, 58)
        Me.dtpSchedule.Name = "dtpSchedule"
        Me.dtpSchedule.Size = New System.Drawing.Size(128, 19)
        Me.dtpSchedule.TabIndex = 2
        '
        'optSchedule
        '
        Me.optSchedule.Checked = True
        Me.optSchedule.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.optSchedule.Location = New System.Drawing.Point(40, 56)
        Me.optSchedule.Name = "optSchedule"
        Me.optSchedule.TabIndex = 1
        Me.optSchedule.TabStop = True
        Me.optSchedule.Text = "Update on"
        '
        'optImmediately
        '
        Me.optImmediately.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.optImmediately.Location = New System.Drawing.Point(40, 28)
        Me.optImmediately.Name = "optImmediately"
        Me.optImmediately.Size = New System.Drawing.Size(168, 24)
        Me.optImmediately.TabIndex = 0
        Me.optImmediately.Text = "Update Immediately"
        '
        'CanadaNormSchedule
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "CanadaNormSchedule"
        Me.Size = New System.Drawing.Size(712, 440)
        Me.AutoScrollMinSize = Me.Size
        Me.SectionPanel1.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Fields"

    Private mController As New CanadaNormScheduleController
    Private mTriggeredByProgram As Boolean

    Private Shared CAPTION As String = "Canadian Norm Update Scheduler"

    Private Enum ListField
        NormLabel = 0
        NormID = 1
        NormDescription = 2
    End Enum


#End Region

#Region " Event Handlers"

    Private Sub lvwList_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwList.SizeChanged
        ListViewResize(lvwList, ListField.NormLabel, 2, ListField.NormDescription, 3)
    End Sub

    Private Sub lvwList_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwList.ItemCheck
        If (Me.mTriggeredByProgram) Then Return

        Dim lvw As ListView = CType(sender, ListView)
        Dim count As Integer = lvw.CheckedItems.Count
        If (e.CurrentValue <> e.NewValue) Then
            If (e.NewValue = CheckState.Checked) Then count += 1
            If (e.NewValue = CheckState.Unchecked) Then count -= 1
        End If
        lblSelectCount.Text = count.ToString

    End Sub

    Private Sub lnkSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSelectAll.LinkClicked
        mTriggeredByProgram = True
        lvwList.SetAllChecked(True)
        lblSelectCount.Text = lvwList.CheckedItems.Count.ToString
        lvwList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnDeselectAll.LinkClicked
        mTriggeredByProgram = True
        lvwList.SetAllChecked(False)
        lblSelectCount.Text = lvwList.CheckedItems.Count.ToString
        lvwList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkSelectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSelectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwList.SetSelectedChecked(True)
        lblSelectCount.Text = lvwList.CheckedItems.Count.ToString
        lvwList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkDeselectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkDeselectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwList.SetSelectedChecked(False)
        lblSelectCount.Text = lvwList.CheckedItems.Count.ToString
        lvwList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub optImmediately_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optImmediately.CheckedChanged
        dtpSchedule.Enabled = False
    End Sub

    Private Sub optSchedule_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optSchedule.CheckedChanged
        dtpSchedule.Enabled = True
    End Sub

    Private Sub btnSubmit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Dim item As ListViewItem
        Dim normID As Integer
        Dim scheduledStartTime As Date = Date.MinValue
        Dim scheduledCount As Integer = lvwList.CheckedItems.Count
        Dim msg As String

        'Check if any norm is selected
        If (scheduledCount = 0) Then
            MessageBox.Show("You must select at least one norm.", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        'Confirm
        If (optSchedule.Checked) Then scheduledStartTime = dtpSchedule.Value
        msg = scheduledCount & " norm(s) are scheduled to update "
        If (optSchedule.Checked) Then
            msg += "at " + scheduledStartTime.ToString("MM/dd/yyyy HH:mm")
        Else
            msg += "immediately"
        End If
        If (MessageBox.Show(msg, _
                            CAPTION, _
                            MessageBoxButtons.OKCancel, _
                            MessageBoxIcon.Question _
                           ) <> DialogResult.OK) Then
            Return
        End If

        'Schedule
        For Each item In lvwList.CheckedItems
            normID = CInt(item.SubItems(ListField.NormID).Text)
            Try
                Me.mController.ScheduleJob(normID, scheduledStartTime)
            Catch ex As Exception
                Dim result As DialogResult
                Dim normName As String = item.SubItems(ListField.NormLabel).Text
                msg = "Can not update norm " + normName + " (" & normID & ")" + vbCrLf
                msg += ex.Message + vbCrLf + vbCrLf
                msg += "Do you want to continue?"
                result = MessageBox.Show(msg, CAPTION, MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
                If (result = DialogResult.No) Then Exit For
            End Try
        Next

        DisplayNormList()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.Start()
    End Sub

#End Region

#Region " Public Methods"

    Public Sub Start()
        DisplayNormList()
        DisplayOtherData()
    End Sub

#End Region

#Region " Private Methods"

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex1 As Integer, ByVal proportion1 As Double, ByVal resizableColumnIndex2 As Integer, ByVal proportion2 As Double)
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex1 AndAlso _
                    columnId <> resizableColumnIndex2) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            Dim width1 As Integer = CInt(Math.Round(width * proportion1 / (proportion1 + proportion2), 0))
            Dim width2 As Integer = width - width1
            If width1 < 50 Then width1 = 50
            .Columns(resizableColumnIndex1).Width = width1
            If width2 < 50 Then width2 = 50
            .Columns(resizableColumnIndex2).Width = width2
        End With

    End Sub

    Private Sub DisplayNormList()
        Dim itmListItem As ListViewItem
        Dim name As String
        Dim normID As Integer
        Dim description As String
        Dim count As Integer = 0

        Dim dr As System.Data.SqlClient.SqlDataReader = Me.mController.SelectSchedulableNorm

        lvwList.BeginUpdate()
        lvwList.Items.Clear()
        Do While dr.Read
            name = CStr(dr("NormLabel"))
            normID = CInt(dr("Norm_ID"))
            description = CStr(dr("NormDescription"))

            itmListItem = New ListViewItem(name)
            itmListItem.SubItems.Add(normID.ToString)
            itmListItem.SubItems.Add(description)
            lvwList.Items.Add(itmListItem)

            count += 1
        Loop
        dr.Close()

        lvwList.SortColumn = ListField.NormLabel
        lvwList.SortOrder = SortOrder.Ascend
        If (lvwList.Items.Count > 0) Then
            lvwList.Items(0).Selected = True
        End If
        lvwList.EndUpdate()

        lblTotalCount.Text = count.ToString
        lblSelectCount.Text = "0"
    End Sub

    Private Sub DisplayOtherData()
        Dim year As Integer = Date.Today.Year
        Dim month As Integer = Date.Today.Month
        Dim day As Integer = Date.Today.Day

        optSchedule.Checked = True
        dtpSchedule.Value = New Date(year, month, day, 18, 0, 0)
    End Sub

#End Region

End Class
