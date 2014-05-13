Option Explicit On 
Option Strict On

'Imports System.Data.SqlClient
Imports System.text
Imports NRC.WinForms

Public Class CanadaRollup
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
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents btnEdit As System.Windows.Forms.Button
    Friend WithEvents btnNew As System.Windows.Forms.Button
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents lvwRollup As NRC.WinForms.NRCListView
    Friend WithEvents lvwSurvey As NRC.WinForms.NRCListView
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents chdRollupID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdRollupName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdRollupDescription As NRC.WinForms.NRCColumnHeader
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lblRollupID As System.Windows.Forms.Label
    Friend WithEvents txtRollupDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtRollupName As System.Windows.Forms.TextBox
    Friend WithEvents chdClientName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdClientID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdStudyName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdStudyID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents Label32 As System.Windows.Forms.Label
    Friend WithEvents Label33 As System.Windows.Forms.Label
    Friend WithEvents lblTotalCount As System.Windows.Forms.Label
    Friend WithEvents lblSelectCount As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.Label32 = New System.Windows.Forms.Label
        Me.lblTotalCount = New System.Windows.Forms.Label
        Me.Label33 = New System.Windows.Forms.Label
        Me.lblSelectCount = New System.Windows.Forms.Label
        Me.lblRollupID = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.btnSave = New System.Windows.Forms.Button
        Me.lvwSurvey = New NRC.WinForms.NRCListView
        Me.chdClientName = New NRC.WinForms.NRCColumnHeader
        Me.chdClientID = New NRC.WinForms.NRCColumnHeader
        Me.chdStudyName = New NRC.WinForms.NRCColumnHeader
        Me.chdStudyID = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyName = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyID = New NRC.WinForms.NRCColumnHeader
        Me.txtRollupDescription = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtRollupName = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.btnDelete = New System.Windows.Forms.Button
        Me.btnNew = New System.Windows.Forms.Button
        Me.btnEdit = New System.Windows.Forms.Button
        Me.lvwRollup = New NRC.WinForms.NRCListView
        Me.chdRollupID = New NRC.WinForms.NRCColumnHeader
        Me.chdRollupName = New NRC.WinForms.NRCColumnHeader
        Me.chdRollupDescription = New NRC.WinForms.NRCColumnHeader
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.AutoScroll = True
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Canadian Rollup Setup"
        Me.SectionPanel1.Controls.Add(Me.Label32)
        Me.SectionPanel1.Controls.Add(Me.lblTotalCount)
        Me.SectionPanel1.Controls.Add(Me.Label33)
        Me.SectionPanel1.Controls.Add(Me.lblSelectCount)
        Me.SectionPanel1.Controls.Add(Me.lblRollupID)
        Me.SectionPanel1.Controls.Add(Me.Label3)
        Me.SectionPanel1.Controls.Add(Me.btnSave)
        Me.SectionPanel1.Controls.Add(Me.lvwSurvey)
        Me.SectionPanel1.Controls.Add(Me.txtRollupDescription)
        Me.SectionPanel1.Controls.Add(Me.Label2)
        Me.SectionPanel1.Controls.Add(Me.txtRollupName)
        Me.SectionPanel1.Controls.Add(Me.Label1)
        Me.SectionPanel1.Controls.Add(Me.SectionPanel2)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(704, 464)
        Me.SectionPanel1.TabIndex = 0
        '
        'Label32
        '
        Me.Label32.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label32.Location = New System.Drawing.Point(56, 424)
        Me.Label32.Name = "Label32"
        Me.Label32.Size = New System.Drawing.Size(32, 16)
        Me.Label32.TabIndex = 9
        Me.Label32.Text = "total"
        Me.Label32.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblTotalCount
        '
        Me.lblTotalCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblTotalCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblTotalCount.Location = New System.Drawing.Point(16, 424)
        Me.lblTotalCount.Name = "lblTotalCount"
        Me.lblTotalCount.Size = New System.Drawing.Size(32, 16)
        Me.lblTotalCount.TabIndex = 8
        Me.lblTotalCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label33
        '
        Me.Label33.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label33.Location = New System.Drawing.Point(128, 424)
        Me.Label33.Name = "Label33"
        Me.Label33.Size = New System.Drawing.Size(48, 16)
        Me.Label33.TabIndex = 11
        Me.Label33.Text = "selected"
        Me.Label33.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblSelectCount
        '
        Me.lblSelectCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblSelectCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSelectCount.Location = New System.Drawing.Point(96, 424)
        Me.lblSelectCount.Name = "lblSelectCount"
        Me.lblSelectCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSelectCount.TabIndex = 10
        Me.lblSelectCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblRollupID
        '
        Me.lblRollupID.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblRollupID.Location = New System.Drawing.Point(88, 224)
        Me.lblRollupID.Name = "lblRollupID"
        Me.lblRollupID.Size = New System.Drawing.Size(52, 20)
        Me.lblRollupID.TabIndex = 2
        Me.lblRollupID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(16, 224)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(52, 20)
        Me.Label3.TabIndex = 1
        Me.Label3.Text = "Rollup ID"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnSave
        '
        Me.btnSave.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSave.Location = New System.Drawing.Point(613, 424)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 12
        Me.btnSave.Text = "Save"
        '
        'lvwSurvey
        '
        Me.lvwSurvey.AlternateColor1 = System.Drawing.Color.White
        Me.lvwSurvey.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwSurvey.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwSurvey.CheckBoxes = True
        Me.lvwSurvey.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdClientName, Me.chdClientID, Me.chdStudyName, Me.chdStudyID, Me.chdSurveyName, Me.chdSurveyID})
        Me.lvwSurvey.FullRowSelect = True
        Me.lvwSurvey.GridLines = True
        Me.lvwSurvey.HideSelection = False
        Me.lvwSurvey.Location = New System.Drawing.Point(16, 288)
        Me.lvwSurvey.Name = "lvwSurvey"
        Me.lvwSurvey.Size = New System.Drawing.Size(672, 128)
        Me.lvwSurvey.SortColumn = 0
        Me.lvwSurvey.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwSurvey.TabIndex = 7
        Me.lvwSurvey.View = System.Windows.Forms.View.Details
        '
        'chdClientName
        '
        Me.chdClientName.DataType = NRC.WinForms.DataType._String
        Me.chdClientName.Text = "Client Name"
        Me.chdClientName.Width = 140
        Me.chdClientName.WidthAutoAdjust = True
        Me.chdClientName.WidthProportion = 8
        '
        'chdClientID
        '
        Me.chdClientID.DataType = NRC.WinForms.DataType._Integer
        Me.chdClientID.Text = "ID"
        Me.chdClientID.Width = 50
        Me.chdClientID.WidthAutoAdjust = False
        Me.chdClientID.WidthProportion = 0
        '
        'chdStudyName
        '
        Me.chdStudyName.DataType = NRC.WinForms.DataType._String
        Me.chdStudyName.Text = "Study Name"
        Me.chdStudyName.Width = 120
        Me.chdStudyName.WidthAutoAdjust = True
        Me.chdStudyName.WidthProportion = 3
        '
        'chdStudyID
        '
        Me.chdStudyID.DataType = NRC.WinForms.DataType._Integer
        Me.chdStudyID.Text = "ID"
        Me.chdStudyID.Width = 50
        Me.chdStudyID.WidthAutoAdjust = False
        Me.chdStudyID.WidthProportion = 0
        '
        'chdSurveyName
        '
        Me.chdSurveyName.DataType = NRC.WinForms.DataType._String
        Me.chdSurveyName.Text = "Survey Name"
        Me.chdSurveyName.Width = 120
        Me.chdSurveyName.WidthAutoAdjust = True
        Me.chdSurveyName.WidthProportion = 4
        '
        'chdSurveyID
        '
        Me.chdSurveyID.DataType = NRC.WinForms.DataType._Integer
        Me.chdSurveyID.Text = "ID"
        Me.chdSurveyID.Width = 50
        Me.chdSurveyID.WidthAutoAdjust = False
        Me.chdSurveyID.WidthProportion = 0
        '
        'txtRollupDescription
        '
        Me.txtRollupDescription.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtRollupDescription.Location = New System.Drawing.Point(88, 256)
        Me.txtRollupDescription.MaxLength = 256
        Me.txtRollupDescription.Name = "txtRollupDescription"
        Me.txtRollupDescription.Size = New System.Drawing.Size(600, 20)
        Me.txtRollupDescription.TabIndex = 6
        Me.txtRollupDescription.Text = ""
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(16, 256)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(64, 20)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Description"
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtRollupName
        '
        Me.txtRollupName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtRollupName.Location = New System.Drawing.Point(216, 224)
        Me.txtRollupName.MaxLength = 64
        Me.txtRollupName.Name = "txtRollupName"
        Me.txtRollupName.Size = New System.Drawing.Size(472, 20)
        Me.txtRollupName.TabIndex = 4
        Me.txtRollupName.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(168, 224)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(40, 20)
        Me.Label1.TabIndex = 3
        Me.Label1.Text = "Name"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SectionPanel2
        '
        Me.SectionPanel2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel2.BackColor = System.Drawing.SystemColors.ActiveBorder
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = ""
        Me.SectionPanel2.Controls.Add(Me.btnDelete)
        Me.SectionPanel2.Controls.Add(Me.btnNew)
        Me.SectionPanel2.Controls.Add(Me.btnEdit)
        Me.SectionPanel2.Controls.Add(Me.lvwRollup)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(16, 40)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = False
        Me.SectionPanel2.Size = New System.Drawing.Size(672, 160)
        Me.SectionPanel2.TabIndex = 0
        '
        'btnDelete
        '
        Me.btnDelete.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnDelete.Location = New System.Drawing.Point(494, 128)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(76, 23)
        Me.btnDelete.TabIndex = 2
        Me.btnDelete.Text = "Delete"
        '
        'btnNew
        '
        Me.btnNew.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNew.Location = New System.Drawing.Point(573, 128)
        Me.btnNew.Name = "btnNew"
        Me.btnNew.TabIndex = 3
        Me.btnNew.Text = "New"
        '
        'btnEdit
        '
        Me.btnEdit.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnEdit.Location = New System.Drawing.Point(416, 128)
        Me.btnEdit.Name = "btnEdit"
        Me.btnEdit.TabIndex = 1
        Me.btnEdit.Text = "Edit"
        '
        'lvwRollup
        '
        Me.lvwRollup.AlternateColor1 = System.Drawing.Color.White
        Me.lvwRollup.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwRollup.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwRollup.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdRollupID, Me.chdRollupName, Me.chdRollupDescription})
        Me.lvwRollup.FullRowSelect = True
        Me.lvwRollup.GridLines = True
        Me.lvwRollup.HideSelection = False
        Me.lvwRollup.Location = New System.Drawing.Point(24, 16)
        Me.lvwRollup.Name = "lvwRollup"
        Me.lvwRollup.Size = New System.Drawing.Size(624, 104)
        Me.lvwRollup.SortColumn = -1
        Me.lvwRollup.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwRollup.TabIndex = 0
        Me.lvwRollup.View = System.Windows.Forms.View.Details
        '
        'chdRollupID
        '
        Me.chdRollupID.DataType = NRC.WinForms.DataType._Integer
        Me.chdRollupID.Text = "Rollup ID"
        Me.chdRollupID.WidthAutoAdjust = False
        Me.chdRollupID.WidthProportion = 0
        '
        'chdRollupName
        '
        Me.chdRollupName.DataType = NRC.WinForms.DataType._String
        Me.chdRollupName.Text = "Name"
        Me.chdRollupName.Width = 120
        Me.chdRollupName.WidthAutoAdjust = True
        Me.chdRollupName.WidthProportion = 2
        '
        'chdRollupDescription
        '
        Me.chdRollupDescription.DataType = NRC.WinForms.DataType._String
        Me.chdRollupDescription.Text = "Description"
        Me.chdRollupDescription.Width = 120
        Me.chdRollupDescription.WidthAutoAdjust = True
        Me.chdRollupDescription.WidthProportion = 3
        '
        'CanadaRollup
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "CanadaRollup"
        Me.Size = New System.Drawing.Size(704, 464)
        Me.AutoScrollMinSize = Me.Size
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Fields"

    Private mController As New CanadaRollupController
    Private mTriggeredByProgram As Boolean = False

    Private Shared CAPTION As String = "Canadian Rollup Setup"

    Private Enum RollupListField
        RollupID = 0
        RollupName = 1
        Description = 2
    End Enum

    Private Enum SurveyListField
        ClientName = 0
        ClientID = 1
        StudyName = 2
        StudyID = 3
        SurveyName = 4
        SurveyID = 5
    End Enum


#End Region

#Region " Public Methods"

    Public Sub Start()
        DisplayRollupList()
    End Sub

#End Region

#Region " Event Handlers"

    Private Sub lvwRollup_Sorted(ByVal sender As Object, ByVal e As NRC.WinForms.ListViewSortedEventArgs) Handles lvwRollup.Sorted
        Dim lvw As NRCListView = CType(sender, NRCListView)
        lvw.BeginUpdate()
        lvw.AutoFitColumnWidth()
        lvw.AutoAdjustColumnWidth()
        lvw.EndUpdate()
    End Sub

    Private Sub lvwRollup_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwRollup.SelectedIndexChanged
        If (lvwRollup.SelectedItems.Count = 0 OrElse lvwRollup.SelectedItems.Count > 1) Then
            btnEdit.Enabled = False
        Else
            btnEdit.Enabled = True
        End If
        If (lvwRollup.SelectedItems.Count = 0) Then
            btnDelete.Enabled = False
        Else
            btnDelete.Enabled = True
        End If
    End Sub

    Private Sub btnEdit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEdit.Click
        EditRollup()
    End Sub

    Private Sub btnNew_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNew.Click
        NewRollup()
    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Delete()
    End Sub

    Private Sub lvwRollup_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwRollup.DoubleClick
        EditRollup()
    End Sub

    Private Sub lvwSurvey_Sorted(ByVal sender As Object, ByVal e As NRC.WinForms.ListViewSortedEventArgs) Handles lvwSurvey.Sorted
        Dim lvw As NRCListView = CType(sender, NRCListView)
        lvw.BeginUpdate()
        lvw.AutoFitColumnWidth()
        lvw.AutoAdjustColumnWidth()
        lvw.PaintAlternatingBackColor()
        lvw.EndUpdate()
    End Sub

    Private Sub lvwSurvey_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwSurvey.ItemCheck
        If (Me.mTriggeredByProgram) Then Return

        Dim lvw As ListView = CType(sender, ListView)
        Dim count As Integer = lvw.CheckedItems.Count
        If (e.CurrentValue <> e.NewValue) Then
            If (e.NewValue = CheckState.Checked) Then count += 1
            If (e.NewValue = CheckState.Unchecked) Then count -= 1
        End If
        lblSelectCount.Text = count.ToString
    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Save()
    End Sub

#End Region

#Region " Private Methods"

    Private Sub DisplayRollupList()
        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing
        Me.Cursor = Cursors.WaitCursor

        Try
            rdr = mController.SelectAllRollup
            Dim rollupID As Integer
            Dim rollupName As String
            Dim description As String
            Dim item As ListViewItem

            lvwRollup.BeginUpdate()
            lvwRollup.Items.Clear()
            Do While rdr.Read
                rollupID = CInt(rdr("Rollup_ID"))
                rollupName = CStr(rdr("Label"))
                description = CStr(rdr("Description"))

                item = New ListViewItem(rollupID.ToString)
                item.SubItems.Add(rollupName)
                item.SubItems.Add(description)

                lvwRollup.Items.Add(item)
            Loop

            If (lvwRollup.SortColumn = -1 OrElse lvwRollup.SortOrder = SortOrder.NotSorted) Then
                lvwRollup.SortColumn = RollupListField.RollupID
                lvwRollup.SortOrder = SortOrder.Ascend
            Else
                lvwRollup.Sort()
            End If

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            lvwRollup.EndUpdate()
            Me.Cursor = Cursors.Default
        End Try

        btnEdit.Enabled = False
        btnDelete.Enabled = False
    End Sub

    Private Sub EditRollup()
        If (lvwRollup.SelectedItems.Count = 0 OrElse _
            lvwRollup.SelectedItems.Count > 1) Then Return

        Dim item As ListViewItem = lvwRollup.SelectedItems(0)
        Dim rollupID As Integer = CInt(item.SubItems(RollupListField.RollupID).Text)
        Dim rollupName As String = item.SubItems(RollupListField.RollupName).Text
        Dim description As String = item.SubItems(RollupListField.Description).Text

        lblRollupID.Text = rollupID.ToString
        txtRollupName.Text = rollupName
        txtRollupDescription.Text = description

        DisplaySurveyList(rollupID)
    End Sub

    Private Sub NewRollup()
        lblRollupID.Text = ""
        txtRollupName.Text = ""
        txtRollupDescription.Text = ""

        DisplaySurveyList(0)
    End Sub

    Private Sub DisplaySurveyList(ByVal rollupID As Integer)
        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing
        Dim clientName As New StringBuilder
        Dim clientID As Integer
        Dim studyName As New StringBuilder
        Dim studyID As Integer
        Dim surveyName As New StringBuilder
        Dim surveyID As Integer
        Dim isSelected As Boolean
        Dim item As ListViewItem
        Dim totalCount As Integer = 0
        Dim selectedCount As Integer = 0

        Try
            Me.Cursor = Cursors.WaitCursor
            mTriggeredByProgram = True

            Me.mController.RollupID = rollupID
            rdr = Me.mController.SelectRollupSurvey()

            lvwSurvey.BeginUpdate()
            lvwSurvey.Items.Clear()

            Do While rdr.Read
                clientName.Remove(0, clientName.Length)
                clientName.Append(rdr("strClient_NM"))
                clientID = CInt(rdr("Client_ID"))
                studyName.Remove(0, studyName.Length)
                studyName.Append(rdr("strStudy_NM"))
                studyID = CInt(rdr("Study_ID"))
                surveyName.Remove(0, surveyName.Length)
                surveyName.Append(rdr("strSurvey_NM"))
                surveyID = CInt(rdr("Survey_ID"))
                isSelected = CBool(rdr("IsSelected"))

                item = New ListViewItem(clientName.ToString)
                item.SubItems.Add(clientID.ToString)
                item.SubItems.Add(studyName.ToString)
                item.SubItems.Add(studyID.ToString)
                item.SubItems.Add(surveyName.ToString)
                item.SubItems.Add(surveyID.ToString)
                item.Checked = isSelected
                lvwSurvey.Items.Add(item)

                totalCount += 1
                If (isSelected) Then selectedCount += 1
            Loop

            If (lvwSurvey.SortColumn = -1 OrElse lvwSurvey.SortOrder = SortOrder.NotSorted) Then
                lvwSurvey.SortColumn = SurveyListField.ClientName
                lvwSurvey.SortOrder = SortOrder.Ascend
            Else
                lvwSurvey.Sort()
            End If

            lblTotalCount.Text = totalCount.ToString
            lblSelectCount.Text = selectedCount.ToString

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            lvwSurvey.EndUpdate()
            mTriggeredByProgram = False
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub Save()
        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing
        If (lvwSurvey.Items.Count = 0) Then Return

        Try
            Me.Cursor = Cursors.WaitCursor

            'Get parameters input
            Dim rollupID As Integer = CInt(IIf(lblRollupID.Text = "", 0, lblRollupID.Text))
            Dim rollupName As String = txtRollupName.Text.Trim
            Dim description As String = txtRollupDescription.Text.Trim
            Dim selectedCount As Integer = lvwSurvey.CheckedItems.Count
            Dim surveys As New StringBuilder
            Dim item As ListViewItem

            'Check parameters
            If (rollupName = "") Then
                txtRollupName.Focus()
                MessageBox.Show("Rollup name is a required field", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If (rollupName = "") Then
                txtRollupName.Focus()
                MessageBox.Show("Rollup description is a required field", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If (selectedCount < 2) Then
                lvwSurvey.Focus()
                MessageBox.Show("Rollup requires at least 2 surveys", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            'Get selected surveys
            For Each item In lvwSurvey.CheckedItems
                surveys.Append(item.SubItems(SurveyListField.SurveyID).Text + ",")
            Next
            surveys.Remove(surveys.Length - 1, 1)


            'Update to DB
            rdr = mController.UpdateCanadaRollup(rollupID, rollupName, description, surveys)

            'Check if rollup is still available
            If (Not rdr.Read) Then
                MessageBox.Show("Rollup " & rollupID & " is not longer exists.", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Information)
                DisplayRollupList()
                Return
            End If

            'Refresh
            rollupID = CInt(rdr("Rollup_ID"))
            DisplayRollupList()
            item = lvwRollup.MatchedItems(RollupListField.RollupID, rollupID)(0)
            item.Selected = True
            item.EnsureVisible()
            item.Focused = True

            lblRollupID.Text = rollupID.ToString

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub Delete()
        If (lvwRollup.SelectedItems.Count = 0) Then Return
        Dim rollups As String = ""
        Dim item As ListViewItem
        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing

        Try
            Me.Cursor = Cursors.WaitCursor
            'Collect selected rollups
            For Each item In lvwRollup.SelectedItems
                rollups += item.SubItems(RollupListField.RollupID).Text + ","
            Next
            rollups = rollups.Substring(0, rollups.Length - 1)

            'Check if any rollup is used and can not be deleted
            Dim msg As String = "The following rollups are being used in the norm settings and can not be deleted." + vbCrLf
            Dim existUsedRollup As Boolean = False
            Dim rollupID As Integer
            Dim rollupName As String
            Dim usedRollups As New ArrayList

            rdr = mController.SelectUsedRollup(rollups)
            Do While rdr.Read
                existUsedRollup = True
                rollupID = CInt(rdr("Rollup_ID"))
                rollupName = CStr(rdr("Label"))
                usedRollups.Add(rollupID)
                msg += String.Format("    {0:#####}    {1}{2}", rollupID, rollupName, vbCrLf)
            Loop

            If (existUsedRollup) Then
                msg += vbCrLf + "Do you want to exclude these rollups and continue to delete the others?"
                Dim result As DialogResult
                result = MessageBox.Show(msg, CAPTION, MessageBoxButtons.YesNo, MessageBoxIcon.Information)
                If result = DialogResult.No Then Return

                'exclude these used rollups from selection list
                For Each item In lvwRollup.SelectedItems
                    rollupID = CInt(item.SubItems(RollupListField.RollupID).Text)
                    If (usedRollups.IndexOf(rollupID) >= 0) Then
                        item.Selected = False
                    End If
                Next

                'Recall "Delete" method to do delete
                Delete()
                Return
            End If

            'Delete process
            CanadaRollupController.DeleteRollup(rollups)
            DisplayRollupList()

            'If editting rollup is deleted, clear the setting fields
            If (lblRollupID.Text = "") Then Return
            Dim editRollupID As Integer = CInt(lblRollupID.Text)
            If (lvwRollup.MatchedItems(RollupListField.RollupID, editRollupID).Count = 0) Then
                ClearSettings()
            End If
        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ClearSettings()
        lblRollupID.Text = ""
        txtRollupName.Text = ""
        txtRollupDescription.Text = ""
        lvwSurvey.Items.Clear()
        lblTotalCount.Text = ""
        lblSelectCount.Text = ""
    End Sub
#End Region

End Class
