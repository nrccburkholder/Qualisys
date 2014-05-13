Imports NormsApplicationBusinessObjectsLibrary
Public Class USNormEditor
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
    Friend WithEvents ctmEditTopN As System.Windows.Forms.ContextMenu
    Friend WithEvents ctmEditPercentile As System.Windows.Forms.ContextMenu
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Friend WithEvents tbcUSNormEditor As System.Windows.Forms.TabControl
    Friend WithEvents SectionPanel9 As NRC.WinForms.SectionPanel
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents tbpFilter As System.Windows.Forms.TabPage
    Friend WithEvents FilterBuilder1 As NormsApplication.FilterBuilder
    Friend WithEvents tbpTopN As System.Windows.Forms.TabPage
    Friend WithEvents SectionPanel8 As NRC.WinForms.SectionPanel
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents txtBestDescription As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel4 As NRC.WinForms.SectionPanel
    Friend WithEvents chbTopNID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdTopNLabel As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdTopNDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdTopNParam As System.Windows.Forms.ColumnHeader
    Friend WithEvents SectionPanel3 As NRC.WinForms.SectionPanel
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents btnAddTopN As System.Windows.Forms.Button
    Friend WithEvents label6 As System.Windows.Forms.Label
    Friend WithEvents cmbTopNParams As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtTopNLabel As System.Windows.Forms.TextBox
    Friend WithEvents tbpPercentiles As System.Windows.Forms.TabPage
    Friend WithEvents SectionPanel7 As NRC.WinForms.SectionPanel
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents txtIndPercentileLabel As System.Windows.Forms.TextBox
    Friend WithEvents SectionPanel5 As NRC.WinForms.SectionPanel
    Friend WithEvents chdPercentileID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdPercentileLabel As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdPercentileDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdPercentileValue As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents btnPercentileAdd As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents NormList1 As NormsApplication.NormList
    Friend WithEvents txtNormLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtBestLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtTopNDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtIndPercentileDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtNormDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtPercentileDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtPercentileLabel As System.Windows.Forms.TextBox
    Friend WithEvents cmbPercentileValue As System.Windows.Forms.ComboBox
    Friend WithEvents mnuTopNRename As System.Windows.Forms.MenuItem
    Friend WithEvents mnuTopNChangeValue As System.Windows.Forms.MenuItem
    Friend WithEvents mnuTopNChangeDescription As System.Windows.Forms.MenuItem
    Friend WithEvents mnuPercentileRename As System.Windows.Forms.MenuItem
    Friend WithEvents mnuPercentileChangeValue As System.Windows.Forms.MenuItem
    Friend WithEvents mnuPercentileChangeDescription As System.Windows.Forms.MenuItem
    Friend WithEvents lsvTopNComparisons As System.Windows.Forms.ListView
    Friend WithEvents lsvExistingPercentiles As System.Windows.Forms.ListView
    Friend WithEvents tbpAverage As System.Windows.Forms.TabPage
    Friend WithEvents tbpGeneral As System.Windows.Forms.TabPage
    Friend WithEvents SectionPanel10 As NRC.WinForms.SectionPanel
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents txtAverageDescription As System.Windows.Forms.TextBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents txtAverageLabel As System.Windows.Forms.TextBox
    Friend WithEvents SectionPanel11 As NRC.WinForms.SectionPanel
    Friend WithEvents chkMinClientCheck As System.Windows.Forms.CheckBox
    Friend WithEvents chkOngoing As System.Windows.Forms.CheckBox
    Friend WithEvents cmbMonthSpan As System.Windows.Forms.ComboBox
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents mnuPercentileDelete As System.Windows.Forms.MenuItem
    Friend WithEvents mnuTopNDelete As System.Windows.Forms.MenuItem
    Friend WithEvents splAddNewPercentile As NRC.WinForms.SectionPanel
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents txtDecileDescription As System.Windows.Forms.TextBox
    Friend WithEvents txtDecileLabel As System.Windows.Forms.TextBox
    Friend WithEvents splAddDecile As NRC.WinForms.SectionPanel
    Friend WithEvents MainPanel As NRC.WinForms.SectionPanel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ctmEditTopN = New System.Windows.Forms.ContextMenu
        Me.mnuTopNRename = New System.Windows.Forms.MenuItem
        Me.mnuTopNChangeValue = New System.Windows.Forms.MenuItem
        Me.mnuTopNChangeDescription = New System.Windows.Forms.MenuItem
        Me.mnuTopNDelete = New System.Windows.Forms.MenuItem
        Me.ctmEditPercentile = New System.Windows.Forms.ContextMenu
        Me.mnuPercentileRename = New System.Windows.Forms.MenuItem
        Me.mnuPercentileChangeValue = New System.Windows.Forms.MenuItem
        Me.mnuPercentileChangeDescription = New System.Windows.Forms.MenuItem
        Me.mnuPercentileDelete = New System.Windows.Forms.MenuItem
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.tbcUSNormEditor = New System.Windows.Forms.TabControl
        Me.tbpGeneral = New System.Windows.Forms.TabPage
        Me.SectionPanel11 = New NRC.WinForms.SectionPanel
        Me.Label15 = New System.Windows.Forms.Label
        Me.cmbMonthSpan = New System.Windows.Forms.ComboBox
        Me.chkOngoing = New System.Windows.Forms.CheckBox
        Me.chkMinClientCheck = New System.Windows.Forms.CheckBox
        Me.SectionPanel9 = New NRC.WinForms.SectionPanel
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtNormDescription = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtNormLabel = New System.Windows.Forms.TextBox
        Me.tbpFilter = New System.Windows.Forms.TabPage
        Me.FilterBuilder1 = New NormsApplication.FilterBuilder
        Me.tbpAverage = New System.Windows.Forms.TabPage
        Me.SectionPanel10 = New NRC.WinForms.SectionPanel
        Me.Label9 = New System.Windows.Forms.Label
        Me.txtAverageDescription = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.txtAverageLabel = New System.Windows.Forms.TextBox
        Me.tbpTopN = New System.Windows.Forms.TabPage
        Me.SectionPanel8 = New NRC.WinForms.SectionPanel
        Me.Label11 = New System.Windows.Forms.Label
        Me.txtBestDescription = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.txtBestLabel = New System.Windows.Forms.TextBox
        Me.SectionPanel4 = New NRC.WinForms.SectionPanel
        Me.lsvTopNComparisons = New System.Windows.Forms.ListView
        Me.chbTopNID = New System.Windows.Forms.ColumnHeader
        Me.chdTopNLabel = New System.Windows.Forms.ColumnHeader
        Me.chdTopNDescription = New System.Windows.Forms.ColumnHeader
        Me.chdTopNParam = New System.Windows.Forms.ColumnHeader
        Me.SectionPanel3 = New NRC.WinForms.SectionPanel
        Me.Label13 = New System.Windows.Forms.Label
        Me.txtTopNDescription = New System.Windows.Forms.TextBox
        Me.btnAddTopN = New System.Windows.Forms.Button
        Me.label6 = New System.Windows.Forms.Label
        Me.cmbTopNParams = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.txtTopNLabel = New System.Windows.Forms.TextBox
        Me.tbpPercentiles = New System.Windows.Forms.TabPage
        Me.SectionPanel7 = New NRC.WinForms.SectionPanel
        Me.Label14 = New System.Windows.Forms.Label
        Me.txtIndPercentileDescription = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.txtIndPercentileLabel = New System.Windows.Forms.TextBox
        Me.SectionPanel5 = New NRC.WinForms.SectionPanel
        Me.lsvExistingPercentiles = New System.Windows.Forms.ListView
        Me.chdPercentileID = New System.Windows.Forms.ColumnHeader
        Me.chdPercentileLabel = New System.Windows.Forms.ColumnHeader
        Me.chdPercentileDescription = New System.Windows.Forms.ColumnHeader
        Me.chdPercentileValue = New System.Windows.Forms.ColumnHeader
        Me.splAddNewPercentile = New NRC.WinForms.SectionPanel
        Me.Label12 = New System.Windows.Forms.Label
        Me.txtPercentileDescription = New System.Windows.Forms.TextBox
        Me.btnPercentileAdd = New System.Windows.Forms.Button
        Me.Label4 = New System.Windows.Forms.Label
        Me.cmbPercentileValue = New System.Windows.Forms.ComboBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.txtPercentileLabel = New System.Windows.Forms.TextBox
        Me.splAddDecile = New NRC.WinForms.SectionPanel
        Me.Label16 = New System.Windows.Forms.Label
        Me.txtDecileDescription = New System.Windows.Forms.TextBox
        Me.Label17 = New System.Windows.Forms.Label
        Me.txtDecileLabel = New System.Windows.Forms.TextBox
        Me.btnSave = New System.Windows.Forms.Button
        Me.NormList1 = New NormsApplication.NormList
        Me.MainPanel = New NRC.WinForms.SectionPanel
        Me.SectionPanel2.SuspendLayout()
        Me.tbcUSNormEditor.SuspendLayout()
        Me.tbpGeneral.SuspendLayout()
        Me.SectionPanel11.SuspendLayout()
        Me.SectionPanel9.SuspendLayout()
        Me.tbpFilter.SuspendLayout()
        Me.tbpAverage.SuspendLayout()
        Me.SectionPanel10.SuspendLayout()
        Me.tbpTopN.SuspendLayout()
        Me.SectionPanel8.SuspendLayout()
        Me.SectionPanel4.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.tbpPercentiles.SuspendLayout()
        Me.SectionPanel7.SuspendLayout()
        Me.SectionPanel5.SuspendLayout()
        Me.splAddNewPercentile.SuspendLayout()
        Me.splAddDecile.SuspendLayout()
        Me.MainPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'ctmEditTopN
        '
        Me.ctmEditTopN.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuTopNRename, Me.mnuTopNChangeValue, Me.mnuTopNChangeDescription, Me.mnuTopNDelete})
        '
        'mnuTopNRename
        '
        Me.mnuTopNRename.Index = 0
        Me.mnuTopNRename.Text = "Rename"
        '
        'mnuTopNChangeValue
        '
        Me.mnuTopNChangeValue.Index = 1
        Me.mnuTopNChangeValue.Text = "Change Value"
        '
        'mnuTopNChangeDescription
        '
        Me.mnuTopNChangeDescription.Index = 2
        Me.mnuTopNChangeDescription.Text = "Change Description"
        '
        'mnuTopNDelete
        '
        Me.mnuTopNDelete.Index = 3
        Me.mnuTopNDelete.Text = "Delete"
        '
        'ctmEditPercentile
        '
        Me.ctmEditPercentile.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuPercentileRename, Me.mnuPercentileChangeValue, Me.mnuPercentileChangeDescription, Me.mnuPercentileDelete})
        '
        'mnuPercentileRename
        '
        Me.mnuPercentileRename.Index = 0
        Me.mnuPercentileRename.Text = "Rename"
        '
        'mnuPercentileChangeValue
        '
        Me.mnuPercentileChangeValue.Index = 1
        Me.mnuPercentileChangeValue.Text = "Change Value"
        '
        'mnuPercentileChangeDescription
        '
        Me.mnuPercentileChangeDescription.Index = 2
        Me.mnuPercentileChangeDescription.Text = "Change Description"
        '
        'mnuPercentileDelete
        '
        Me.mnuPercentileDelete.Index = 3
        Me.mnuPercentileDelete.Text = "Delete"
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = "Norm Properties"
        Me.SectionPanel2.Controls.Add(Me.tbcUSNormEditor)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(16, 136)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(832, 624)
        Me.SectionPanel2.TabIndex = 5
        '
        'tbcUSNormEditor
        '
        Me.tbcUSNormEditor.Controls.Add(Me.tbpGeneral)
        Me.tbcUSNormEditor.Controls.Add(Me.tbpFilter)
        Me.tbcUSNormEditor.Controls.Add(Me.tbpAverage)
        Me.tbcUSNormEditor.Controls.Add(Me.tbpTopN)
        Me.tbcUSNormEditor.Controls.Add(Me.tbpPercentiles)
        Me.tbcUSNormEditor.ItemSize = New System.Drawing.Size(90, 18)
        Me.tbcUSNormEditor.Location = New System.Drawing.Point(8, 32)
        Me.tbcUSNormEditor.Name = "tbcUSNormEditor"
        Me.tbcUSNormEditor.SelectedIndex = 0
        Me.tbcUSNormEditor.Size = New System.Drawing.Size(816, 584)
        Me.tbcUSNormEditor.TabIndex = 1
        '
        'tbpGeneral
        '
        Me.tbpGeneral.Controls.Add(Me.SectionPanel11)
        Me.tbpGeneral.Controls.Add(Me.SectionPanel9)
        Me.tbpGeneral.Location = New System.Drawing.Point(4, 22)
        Me.tbpGeneral.Name = "tbpGeneral"
        Me.tbpGeneral.Size = New System.Drawing.Size(808, 558)
        Me.tbpGeneral.TabIndex = 0
        Me.tbpGeneral.Text = "General Settings"
        '
        'SectionPanel11
        '
        Me.SectionPanel11.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel11.Caption = "Options"
        Me.SectionPanel11.Controls.Add(Me.Label15)
        Me.SectionPanel11.Controls.Add(Me.cmbMonthSpan)
        Me.SectionPanel11.Controls.Add(Me.chkOngoing)
        Me.SectionPanel11.Controls.Add(Me.chkMinClientCheck)
        Me.SectionPanel11.DockPadding.All = 1
        Me.SectionPanel11.Location = New System.Drawing.Point(124, 271)
        Me.SectionPanel11.Name = "SectionPanel11"
        Me.SectionPanel11.ShowCaption = True
        Me.SectionPanel11.Size = New System.Drawing.Size(560, 208)
        Me.SectionPanel11.TabIndex = 5
        '
        'Label15
        '
        Me.Label15.Location = New System.Drawing.Point(40, 160)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(128, 23)
        Me.Label15.TabIndex = 4
        Me.Label15.Text = "Months of Data to Use"
        '
        'cmbMonthSpan
        '
        Me.cmbMonthSpan.Items.AddRange(New Object() {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"})
        Me.cmbMonthSpan.Location = New System.Drawing.Point(168, 160)
        Me.cmbMonthSpan.Name = "cmbMonthSpan"
        Me.cmbMonthSpan.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmbMonthSpan.Size = New System.Drawing.Size(56, 21)
        Me.cmbMonthSpan.TabIndex = 3
        '
        'chkOngoing
        '
        Me.chkOngoing.Location = New System.Drawing.Point(48, 112)
        Me.chkOngoing.Name = "chkOngoing"
        Me.chkOngoing.Size = New System.Drawing.Size(208, 24)
        Me.chkOngoing.TabIndex = 2
        Me.chkOngoing.Text = "Refresh Each Quarter"
        '
        'chkMinClientCheck
        '
        Me.chkMinClientCheck.Location = New System.Drawing.Point(48, 56)
        Me.chkMinClientCheck.Name = "chkMinClientCheck"
        Me.chkMinClientCheck.Size = New System.Drawing.Size(208, 24)
        Me.chkMinClientCheck.TabIndex = 1
        Me.chkMinClientCheck.Text = "Perform Minimum Client Check"
        '
        'SectionPanel9
        '
        Me.SectionPanel9.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel9.Caption = "Norm Label and Description"
        Me.SectionPanel9.Controls.Add(Me.Label2)
        Me.SectionPanel9.Controls.Add(Me.txtNormDescription)
        Me.SectionPanel9.Controls.Add(Me.Label1)
        Me.SectionPanel9.Controls.Add(Me.txtNormLabel)
        Me.SectionPanel9.DockPadding.All = 1
        Me.SectionPanel9.Location = New System.Drawing.Point(124, 47)
        Me.SectionPanel9.Name = "SectionPanel9"
        Me.SectionPanel9.ShowCaption = True
        Me.SectionPanel9.Size = New System.Drawing.Size(560, 168)
        Me.SectionPanel9.TabIndex = 4
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(48, 96)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(208, 16)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Norm Description"
        '
        'txtNormDescription
        '
        Me.txtNormDescription.Location = New System.Drawing.Point(48, 120)
        Me.txtNormDescription.Name = "txtNormDescription"
        Me.txtNormDescription.Size = New System.Drawing.Size(440, 20)
        Me.txtNormDescription.TabIndex = 2
        Me.txtNormDescription.Text = ""
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(48, 40)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(168, 16)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Norm Label"
        '
        'txtNormLabel
        '
        Me.txtNormLabel.Location = New System.Drawing.Point(48, 64)
        Me.txtNormLabel.Name = "txtNormLabel"
        Me.txtNormLabel.Size = New System.Drawing.Size(440, 20)
        Me.txtNormLabel.TabIndex = 0
        Me.txtNormLabel.Text = ""
        '
        'tbpFilter
        '
        Me.tbpFilter.Controls.Add(Me.FilterBuilder1)
        Me.tbpFilter.Location = New System.Drawing.Point(4, 22)
        Me.tbpFilter.Name = "tbpFilter"
        Me.tbpFilter.Size = New System.Drawing.Size(808, 558)
        Me.tbpFilter.TabIndex = 3
        Me.tbpFilter.Text = "Criteria"
        '
        'FilterBuilder1
        '
        Me.FilterBuilder1.Location = New System.Drawing.Point(8, 8)
        Me.FilterBuilder1.Name = "FilterBuilder1"
        Me.FilterBuilder1.Size = New System.Drawing.Size(800, 512)
        Me.FilterBuilder1.TabIndex = 5
        Me.FilterBuilder1.UseProduction = False
        '
        'tbpAverage
        '
        Me.tbpAverage.Controls.Add(Me.SectionPanel10)
        Me.tbpAverage.Location = New System.Drawing.Point(4, 22)
        Me.tbpAverage.Name = "tbpAverage"
        Me.tbpAverage.Size = New System.Drawing.Size(808, 558)
        Me.tbpAverage.TabIndex = 4
        Me.tbpAverage.Text = "Average Settings"
        '
        'SectionPanel10
        '
        Me.SectionPanel10.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel10.Caption = "Average Comparison"
        Me.SectionPanel10.Controls.Add(Me.Label9)
        Me.SectionPanel10.Controls.Add(Me.txtAverageDescription)
        Me.SectionPanel10.Controls.Add(Me.Label10)
        Me.SectionPanel10.Controls.Add(Me.txtAverageLabel)
        Me.SectionPanel10.DockPadding.All = 1
        Me.SectionPanel10.Location = New System.Drawing.Point(88, 40)
        Me.SectionPanel10.Name = "SectionPanel10"
        Me.SectionPanel10.ShowCaption = True
        Me.SectionPanel10.Size = New System.Drawing.Size(576, 168)
        Me.SectionPanel10.TabIndex = 6
        '
        'Label9
        '
        Me.Label9.Location = New System.Drawing.Point(48, 96)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(208, 16)
        Me.Label9.TabIndex = 3
        Me.Label9.Text = "Average Comparison Description"
        '
        'txtAverageDescription
        '
        Me.txtAverageDescription.Location = New System.Drawing.Point(48, 120)
        Me.txtAverageDescription.Name = "txtAverageDescription"
        Me.txtAverageDescription.Size = New System.Drawing.Size(440, 20)
        Me.txtAverageDescription.TabIndex = 2
        Me.txtAverageDescription.Text = ""
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(48, 40)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(168, 16)
        Me.Label10.TabIndex = 1
        Me.Label10.Text = "Average Comparison Label"
        '
        'txtAverageLabel
        '
        Me.txtAverageLabel.Location = New System.Drawing.Point(48, 64)
        Me.txtAverageLabel.Name = "txtAverageLabel"
        Me.txtAverageLabel.Size = New System.Drawing.Size(440, 20)
        Me.txtAverageLabel.TabIndex = 0
        Me.txtAverageLabel.Text = ""
        '
        'tbpTopN
        '
        Me.tbpTopN.Controls.Add(Me.SectionPanel8)
        Me.tbpTopN.Controls.Add(Me.SectionPanel4)
        Me.tbpTopN.Controls.Add(Me.SectionPanel3)
        Me.tbpTopN.Location = New System.Drawing.Point(4, 22)
        Me.tbpTopN.Name = "tbpTopN"
        Me.tbpTopN.Size = New System.Drawing.Size(808, 558)
        Me.tbpTopN.TabIndex = 1
        Me.tbpTopN.Text = "Best/Top N % Settings"
        '
        'SectionPanel8
        '
        Me.SectionPanel8.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel8.Caption = "Best Comparison"
        Me.SectionPanel8.Controls.Add(Me.Label11)
        Me.SectionPanel8.Controls.Add(Me.txtBestDescription)
        Me.SectionPanel8.Controls.Add(Me.Label8)
        Me.SectionPanel8.Controls.Add(Me.txtBestLabel)
        Me.SectionPanel8.DockPadding.All = 1
        Me.SectionPanel8.Location = New System.Drawing.Point(20, 13)
        Me.SectionPanel8.Name = "SectionPanel8"
        Me.SectionPanel8.ShowCaption = True
        Me.SectionPanel8.Size = New System.Drawing.Size(768, 136)
        Me.SectionPanel8.TabIndex = 20
        '
        'Label11
        '
        Me.Label11.Location = New System.Drawing.Point(16, 80)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(208, 16)
        Me.Label11.TabIndex = 5
        Me.Label11.Text = "Best Comparison Description"
        '
        'txtBestDescription
        '
        Me.txtBestDescription.Location = New System.Drawing.Point(16, 104)
        Me.txtBestDescription.Name = "txtBestDescription"
        Me.txtBestDescription.Size = New System.Drawing.Size(728, 20)
        Me.txtBestDescription.TabIndex = 4
        Me.txtBestDescription.Text = ""
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(16, 32)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(296, 23)
        Me.Label8.TabIndex = 1
        Me.Label8.Text = "Label for Best Comparison"
        '
        'txtBestLabel
        '
        Me.txtBestLabel.Location = New System.Drawing.Point(16, 56)
        Me.txtBestLabel.Name = "txtBestLabel"
        Me.txtBestLabel.Size = New System.Drawing.Size(728, 20)
        Me.txtBestLabel.TabIndex = 0
        Me.txtBestLabel.Text = ""
        '
        'SectionPanel4
        '
        Me.SectionPanel4.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel4.Caption = "Existing Top N % Comparisons"
        Me.SectionPanel4.Controls.Add(Me.lsvTopNComparisons)
        Me.SectionPanel4.DockPadding.All = 1
        Me.SectionPanel4.Location = New System.Drawing.Point(20, 166)
        Me.SectionPanel4.Name = "SectionPanel4"
        Me.SectionPanel4.ShowCaption = True
        Me.SectionPanel4.Size = New System.Drawing.Size(768, 136)
        Me.SectionPanel4.TabIndex = 16
        '
        'lsvTopNComparisons
        '
        Me.lsvTopNComparisons.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chbTopNID, Me.chdTopNLabel, Me.chdTopNDescription, Me.chdTopNParam})
        Me.lsvTopNComparisons.ContextMenu = Me.ctmEditTopN
        Me.lsvTopNComparisons.FullRowSelect = True
        Me.lsvTopNComparisons.Location = New System.Drawing.Point(8, 40)
        Me.lsvTopNComparisons.Name = "lsvTopNComparisons"
        Me.lsvTopNComparisons.Size = New System.Drawing.Size(744, 88)
        Me.lsvTopNComparisons.TabIndex = 14
        Me.lsvTopNComparisons.View = System.Windows.Forms.View.Details
        '
        'chbTopNID
        '
        Me.chbTopNID.Text = "ID"
        Me.chbTopNID.Width = 41
        '
        'chdTopNLabel
        '
        Me.chdTopNLabel.Text = "Label"
        Me.chdTopNLabel.Width = 256
        '
        'chdTopNDescription
        '
        Me.chdTopNDescription.Text = "Description"
        Me.chdTopNDescription.Width = 391
        '
        'chdTopNParam
        '
        Me.chdTopNParam.Text = "Value"
        Me.chdTopNParam.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.chdTopNParam.Width = 50
        '
        'SectionPanel3
        '
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel3.Caption = "Add New Top N %"
        Me.SectionPanel3.Controls.Add(Me.Label13)
        Me.SectionPanel3.Controls.Add(Me.txtTopNDescription)
        Me.SectionPanel3.Controls.Add(Me.btnAddTopN)
        Me.SectionPanel3.Controls.Add(Me.label6)
        Me.SectionPanel3.Controls.Add(Me.cmbTopNParams)
        Me.SectionPanel3.Controls.Add(Me.Label5)
        Me.SectionPanel3.Controls.Add(Me.txtTopNLabel)
        Me.SectionPanel3.DockPadding.All = 1
        Me.SectionPanel3.Location = New System.Drawing.Point(20, 319)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(768, 195)
        Me.SectionPanel3.TabIndex = 15
        '
        'Label13
        '
        Me.Label13.Location = New System.Drawing.Point(16, 81)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(152, 23)
        Me.Label13.TabIndex = 18
        Me.Label13.Text = "Top N % Description"
        '
        'txtTopNDescription
        '
        Me.txtTopNDescription.Location = New System.Drawing.Point(16, 105)
        Me.txtTopNDescription.Name = "txtTopNDescription"
        Me.txtTopNDescription.Size = New System.Drawing.Size(736, 20)
        Me.txtTopNDescription.TabIndex = 17
        Me.txtTopNDescription.Text = ""
        '
        'btnAddTopN
        '
        Me.btnAddTopN.Location = New System.Drawing.Point(347, 152)
        Me.btnAddTopN.Name = "btnAddTopN"
        Me.btnAddTopN.TabIndex = 15
        Me.btnAddTopN.Text = "Add"
        '
        'label6
        '
        Me.label6.Location = New System.Drawing.Point(16, 136)
        Me.label6.Name = "label6"
        Me.label6.TabIndex = 13
        Me.label6.Text = "Top N % Value"
        '
        'cmbTopNParams
        '
        Me.cmbTopNParams.Items.AddRange(New Object() {"1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "99"})
        Me.cmbTopNParams.Location = New System.Drawing.Point(16, 160)
        Me.cmbTopNParams.Name = "cmbTopNParams"
        Me.cmbTopNParams.Size = New System.Drawing.Size(121, 21)
        Me.cmbTopNParams.TabIndex = 12
        Me.cmbTopNParams.Text = "25"
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(16, 32)
        Me.Label5.Name = "Label5"
        Me.Label5.TabIndex = 11
        Me.Label5.Text = "Top N % Label"
        '
        'txtTopNLabel
        '
        Me.txtTopNLabel.Location = New System.Drawing.Point(16, 56)
        Me.txtTopNLabel.Name = "txtTopNLabel"
        Me.txtTopNLabel.Size = New System.Drawing.Size(736, 20)
        Me.txtTopNLabel.TabIndex = 10
        Me.txtTopNLabel.Text = ""
        '
        'tbpPercentiles
        '
        Me.tbpPercentiles.Controls.Add(Me.SectionPanel7)
        Me.tbpPercentiles.Controls.Add(Me.SectionPanel5)
        Me.tbpPercentiles.Controls.Add(Me.splAddNewPercentile)
        Me.tbpPercentiles.Controls.Add(Me.splAddDecile)
        Me.tbpPercentiles.Location = New System.Drawing.Point(4, 22)
        Me.tbpPercentiles.Name = "tbpPercentiles"
        Me.tbpPercentiles.Size = New System.Drawing.Size(808, 558)
        Me.tbpPercentiles.TabIndex = 2
        Me.tbpPercentiles.Text = "Percentile Settings"
        '
        'SectionPanel7
        '
        Me.SectionPanel7.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel7.Caption = "Individual Percentile"
        Me.SectionPanel7.Controls.Add(Me.Label14)
        Me.SectionPanel7.Controls.Add(Me.txtIndPercentileDescription)
        Me.SectionPanel7.Controls.Add(Me.Label3)
        Me.SectionPanel7.Controls.Add(Me.txtIndPercentileLabel)
        Me.SectionPanel7.DockPadding.All = 1
        Me.SectionPanel7.Location = New System.Drawing.Point(16, 3)
        Me.SectionPanel7.Name = "SectionPanel7"
        Me.SectionPanel7.ShowCaption = True
        Me.SectionPanel7.Size = New System.Drawing.Size(776, 144)
        Me.SectionPanel7.TabIndex = 19
        '
        'Label14
        '
        Me.Label14.Location = New System.Drawing.Point(16, 83)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(296, 23)
        Me.Label14.TabIndex = 4
        Me.Label14.Text = "Description for Individual Percentile Comparison"
        '
        'txtIndPercentileDescription
        '
        Me.txtIndPercentileDescription.Location = New System.Drawing.Point(16, 112)
        Me.txtIndPercentileDescription.Name = "txtIndPercentileDescription"
        Me.txtIndPercentileDescription.Size = New System.Drawing.Size(744, 20)
        Me.txtIndPercentileDescription.TabIndex = 3
        Me.txtIndPercentileDescription.Text = ""
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(16, 32)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(296, 23)
        Me.Label3.TabIndex = 1
        Me.Label3.Text = "Label for Individual Percentile Comparison"
        '
        'txtIndPercentileLabel
        '
        Me.txtIndPercentileLabel.Location = New System.Drawing.Point(16, 56)
        Me.txtIndPercentileLabel.Name = "txtIndPercentileLabel"
        Me.txtIndPercentileLabel.Size = New System.Drawing.Size(744, 20)
        Me.txtIndPercentileLabel.TabIndex = 0
        Me.txtIndPercentileLabel.Text = ""
        '
        'SectionPanel5
        '
        Me.SectionPanel5.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel5.Caption = "Existing Percentile Comparisons"
        Me.SectionPanel5.Controls.Add(Me.lsvExistingPercentiles)
        Me.SectionPanel5.DockPadding.All = 1
        Me.SectionPanel5.Location = New System.Drawing.Point(16, 292)
        Me.SectionPanel5.Name = "SectionPanel5"
        Me.SectionPanel5.ShowCaption = True
        Me.SectionPanel5.Size = New System.Drawing.Size(776, 112)
        Me.SectionPanel5.TabIndex = 18
        '
        'lsvExistingPercentiles
        '
        Me.lsvExistingPercentiles.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdPercentileID, Me.chdPercentileLabel, Me.chdPercentileDescription, Me.chdPercentileValue})
        Me.lsvExistingPercentiles.ContextMenu = Me.ctmEditPercentile
        Me.lsvExistingPercentiles.FullRowSelect = True
        Me.lsvExistingPercentiles.Location = New System.Drawing.Point(16, 35)
        Me.lsvExistingPercentiles.MultiSelect = False
        Me.lsvExistingPercentiles.Name = "lsvExistingPercentiles"
        Me.lsvExistingPercentiles.Size = New System.Drawing.Size(744, 69)
        Me.lsvExistingPercentiles.TabIndex = 16
        Me.lsvExistingPercentiles.View = System.Windows.Forms.View.Details
        '
        'chdPercentileID
        '
        Me.chdPercentileID.Text = "ID"
        Me.chdPercentileID.Width = 46
        '
        'chdPercentileLabel
        '
        Me.chdPercentileLabel.Text = "Label"
        Me.chdPercentileLabel.Width = 242
        '
        'chdPercentileDescription
        '
        Me.chdPercentileDescription.Text = "Description"
        Me.chdPercentileDescription.Width = 402
        '
        'chdPercentileValue
        '
        Me.chdPercentileValue.Text = "Value"
        Me.chdPercentileValue.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        Me.chdPercentileValue.Width = 50
        '
        'splAddNewPercentile
        '
        Me.splAddNewPercentile.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.splAddNewPercentile.Caption = "Add New Percentile"
        Me.splAddNewPercentile.Controls.Add(Me.Label12)
        Me.splAddNewPercentile.Controls.Add(Me.txtPercentileDescription)
        Me.splAddNewPercentile.Controls.Add(Me.btnPercentileAdd)
        Me.splAddNewPercentile.Controls.Add(Me.Label4)
        Me.splAddNewPercentile.Controls.Add(Me.cmbPercentileValue)
        Me.splAddNewPercentile.Controls.Add(Me.Label7)
        Me.splAddNewPercentile.Controls.Add(Me.txtPercentileLabel)
        Me.splAddNewPercentile.DockPadding.All = 1
        Me.splAddNewPercentile.Location = New System.Drawing.Point(16, 408)
        Me.splAddNewPercentile.Name = "splAddNewPercentile"
        Me.splAddNewPercentile.ShowCaption = True
        Me.splAddNewPercentile.Size = New System.Drawing.Size(776, 144)
        Me.splAddNewPercentile.TabIndex = 17
        '
        'Label12
        '
        Me.Label12.Location = New System.Drawing.Point(16, 88)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(152, 23)
        Me.Label12.TabIndex = 18
        Me.Label12.Text = "Percentile Description"
        '
        'txtPercentileDescription
        '
        Me.txtPercentileDescription.Location = New System.Drawing.Point(16, 112)
        Me.txtPercentileDescription.Name = "txtPercentileDescription"
        Me.txtPercentileDescription.Size = New System.Drawing.Size(560, 20)
        Me.txtPercentileDescription.TabIndex = 17
        Me.txtPercentileDescription.Text = ""
        '
        'btnPercentileAdd
        '
        Me.btnPercentileAdd.Location = New System.Drawing.Point(640, 112)
        Me.btnPercentileAdd.Name = "btnPercentileAdd"
        Me.btnPercentileAdd.TabIndex = 15
        Me.btnPercentileAdd.Text = "Add"
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(624, 48)
        Me.Label4.Name = "Label4"
        Me.Label4.TabIndex = 13
        Me.Label4.Text = "Percentile Value"
        '
        'cmbPercentileValue
        '
        Me.cmbPercentileValue.Items.AddRange(New Object() {"1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "99"})
        Me.cmbPercentileValue.Location = New System.Drawing.Point(624, 72)
        Me.cmbPercentileValue.Name = "cmbPercentileValue"
        Me.cmbPercentileValue.Size = New System.Drawing.Size(121, 21)
        Me.cmbPercentileValue.TabIndex = 12
        Me.cmbPercentileValue.Text = "75"
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(16, 40)
        Me.Label7.Name = "Label7"
        Me.Label7.TabIndex = 11
        Me.Label7.Text = "Percentile Label"
        '
        'txtPercentileLabel
        '
        Me.txtPercentileLabel.Location = New System.Drawing.Point(16, 64)
        Me.txtPercentileLabel.Name = "txtPercentileLabel"
        Me.txtPercentileLabel.Size = New System.Drawing.Size(560, 20)
        Me.txtPercentileLabel.TabIndex = 10
        Me.txtPercentileLabel.Text = ""
        '
        'splAddDecile
        '
        Me.splAddDecile.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.splAddDecile.Caption = "Decile"
        Me.splAddDecile.Controls.Add(Me.Label16)
        Me.splAddDecile.Controls.Add(Me.txtDecileDescription)
        Me.splAddDecile.Controls.Add(Me.Label17)
        Me.splAddDecile.Controls.Add(Me.txtDecileLabel)
        Me.splAddDecile.DockPadding.All = 1
        Me.splAddDecile.Enabled = False
        Me.splAddDecile.Location = New System.Drawing.Point(16, 149)
        Me.splAddDecile.Name = "splAddDecile"
        Me.splAddDecile.ShowCaption = True
        Me.splAddDecile.Size = New System.Drawing.Size(776, 138)
        Me.splAddDecile.TabIndex = 20
        '
        'Label16
        '
        Me.Label16.Location = New System.Drawing.Point(16, 83)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(296, 23)
        Me.Label16.TabIndex = 4
        Me.Label16.Text = "Description for Decile Comparison"
        '
        'txtDecileDescription
        '
        Me.txtDecileDescription.Location = New System.Drawing.Point(16, 112)
        Me.txtDecileDescription.Name = "txtDecileDescription"
        Me.txtDecileDescription.Size = New System.Drawing.Size(744, 20)
        Me.txtDecileDescription.TabIndex = 3
        Me.txtDecileDescription.Text = ""
        '
        'Label17
        '
        Me.Label17.Location = New System.Drawing.Point(16, 32)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(296, 23)
        Me.Label17.TabIndex = 1
        Me.Label17.Text = "Label for Decile Comparison"
        '
        'txtDecileLabel
        '
        Me.txtDecileLabel.Location = New System.Drawing.Point(16, 56)
        Me.txtDecileLabel.Name = "txtDecileLabel"
        Me.txtDecileLabel.Size = New System.Drawing.Size(744, 20)
        Me.txtDecileLabel.TabIndex = 0
        Me.txtDecileLabel.Text = ""
        '
        'btnSave
        '
        Me.btnSave.Location = New System.Drawing.Point(392, 768)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.TabIndex = 4
        Me.btnSave.Text = "Save"
        '
        'NormList1
        '
        Me.NormList1.includeNew = True
        Me.NormList1.Location = New System.Drawing.Point(16, 40)
        Me.NormList1.Name = "NormList1"
        Me.NormList1.Size = New System.Drawing.Size(832, 88)
        Me.NormList1.TabIndex = 2
        Me.NormList1.UseProduction = False
        '
        'MainPanel
        '
        Me.MainPanel.AutoScroll = True
        Me.MainPanel.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.MainPanel.Caption = "US Norm Editor"
        Me.MainPanel.Controls.Add(Me.SectionPanel2)
        Me.MainPanel.Controls.Add(Me.btnSave)
        Me.MainPanel.Controls.Add(Me.NormList1)
        Me.MainPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MainPanel.DockPadding.All = 1
        Me.MainPanel.Location = New System.Drawing.Point(0, 0)
        Me.MainPanel.Name = "MainPanel"
        Me.MainPanel.ShowCaption = True
        Me.MainPanel.Size = New System.Drawing.Size(880, 800)
        Me.MainPanel.TabIndex = 0
        '
        'USNormEditor
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.MainPanel)
        Me.Name = "USNormEditor"
        Me.Size = New System.Drawing.Size(880, 800)
        Me.SectionPanel2.ResumeLayout(False)
        Me.tbcUSNormEditor.ResumeLayout(False)
        Me.tbpGeneral.ResumeLayout(False)
        Me.SectionPanel11.ResumeLayout(False)
        Me.SectionPanel9.ResumeLayout(False)
        Me.tbpFilter.ResumeLayout(False)
        Me.tbpAverage.ResumeLayout(False)
        Me.SectionPanel10.ResumeLayout(False)
        Me.tbpTopN.ResumeLayout(False)
        Me.SectionPanel8.ResumeLayout(False)
        Me.SectionPanel4.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.tbpPercentiles.ResumeLayout(False)
        Me.SectionPanel7.ResumeLayout(False)
        Me.SectionPanel5.ResumeLayout(False)
        Me.splAddNewPercentile.ResumeLayout(False)
        Me.splAddDecile.ResumeLayout(False)
        Me.MainPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region
    Private mSelectedNorm As USNormSetting
    Private mStandardComparison As USComparisonType
    Private mBestComparison As USComparisonType
    Private mIndividualPercentileComparison As USComparisonType
    Private mDecileComparison As USComparisonType

    Private Sub NormList1_SelectedNormChanged(ByVal SelectedNorm As NormsApplicationBusinessObjectsLibrary.USNormSetting) Handles NormList1.SelectedNormChanged
        If Not mSelectedNorm Is Nothing Then
            If mSelectedNorm.Changed = True And mSelectedNorm.NormLabel <> " New" Then
                If MessageBox.Show("Would you like to save changes to " & mSelectedNorm.NormLabel & "?", "Save Changes", MessageBoxButtons.YesNo, MessageBoxIcon.Information) = DialogResult.Yes Then
                    Save()
                Else
                    mSelectedNorm.Changed = False
                    StoreSingleComparisons()
                End If
            End If
        End If
        mSelectedNorm = SelectedNorm
        Reset()
    End Sub

    Private Sub Reset()
        mStandardComparison = New USComparisonType
        mStandardComparison.USNormType = USComparisonType.NormType.StandardNorm
        mBestComparison = New USComparisonType
        mBestComparison.USNormType = USComparisonType.NormType.BestNorm
        mIndividualPercentileComparison = New USComparisonType
        mIndividualPercentileComparison.USNormType = USComparisonType.NormType.IndividualPercentile
        mDecileComparison = New USComparisonType
        mDecileComparison.USNormType = USComparisonType.NormType.DecileNorm
        ClearPrevious()
        UpdateProperties()
    End Sub

    Private Sub ClearPrevious()
        txtAverageLabel.Text = ""
        txtAverageDescription.Text = ""
        txtTopNLabel.Text = ""
        txtTopNDescription.Text = ""
        txtIndPercentileDescription.Text = ""
        txtIndPercentileLabel.Text = ""
        txtPercentileLabel.Text = ""
        txtPercentileDescription.Text = ""
        txtBestLabel.Text = ""
        txtBestDescription.Text = ""
        txtDecileLabel.Text = ""
        txtDecileDescription.Text = ""
        FilterBuilder1.txtCriteria.Text = ""
        cmbTopNParams.Text = "25"
        cmbPercentileValue.Text = "75"
    End Sub

    Private Sub SelectNormInFilterList()
        FilterBuilder1.RefreshNormsList()
        For Each tmpNorm As USNormSetting In FilterBuilder1.lstNormsList.Items
            If mSelectedNorm.NormID = tmpNorm.NormID Then
                FilterBuilder1.lstNormsList.SelectedItem = tmpNorm
                FilterBuilder1.txtCriteria.Text = tmpNorm.CriteriaStatement
                Exit For
            End If
        Next
    End Sub

    Private Sub UpdateProperties()
        lsvTopNComparisons.Items.Clear()
        lsvExistingPercentiles.Items.Clear()
        txtNormLabel.Text = mSelectedNorm.NormLabel
        txtNormDescription.Text = mSelectedNorm.NormDescription
        chkMinClientCheck.Checked = mSelectedNorm.MinClientCheck
        chkOngoing.Checked = mSelectedNorm.Ongoing
        cmbMonthSpan.Text = mSelectedNorm.MonthSpan.ToString
        SelectNormInFilterList()
        For Each comparison As USComparisonType In mSelectedNorm.Comparisons
            If comparison.USNormType = USComparisonType.NormType.StandardNorm Then
                mStandardComparison = comparison
                txtAverageLabel.Text = comparison.SelectionBox
                txtAverageDescription.Text = comparison.Description
            ElseIf comparison.USNormType = USComparisonType.NormType.BestNorm Then
                mBestComparison = comparison
                txtBestLabel.Text = comparison.SelectionBox
                txtBestDescription.Text = comparison.Description
            ElseIf comparison.USNormType = USComparisonType.NormType.IndividualPercentile Then
                mIndividualPercentileComparison = comparison
                txtIndPercentileLabel.Text = comparison.SelectionBox
                txtIndPercentileDescription.Text = comparison.Description
            ElseIf comparison.USNormType = USComparisonType.NormType.DecileNorm Then
                mDecileComparison = comparison
                txtDecileLabel.Text = comparison.SelectionBox
                txtDecileDescription.Text = comparison.Description
            ElseIf comparison.USNormType = USComparisonType.NormType.TopNPercent Then
                Dim tmpListView As New Windows.Forms.ListViewItem(comparison.CompTypeID)
                tmpListView.Tag = comparison
                tmpListView.SubItems.Add(comparison.SelectionBox)
                tmpListView.SubItems.Add(comparison.Description)
                tmpListView.SubItems.Add(comparison.NormParam)
                lsvTopNComparisons.Items.Add(tmpListView)
            ElseIf comparison.USNormType = USComparisonType.NormType.StandardPercentile Then
                Dim tmpListView As New Windows.Forms.ListViewItem(comparison.CompTypeID)
                tmpListView.Tag = comparison
                tmpListView.SubItems.Add(comparison.SelectionBox)
                tmpListView.SubItems.Add(comparison.Description)
                tmpListView.SubItems.Add(comparison.NormParam)
                lsvExistingPercentiles.Items.Add(tmpListView)
            End If
        Next
    End Sub

    Private Sub txtAverageDescription_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAverageDescription.TextChanged
        mStandardComparison.Description = txtAverageDescription.Text
    End Sub

    Private Sub txtAverageLabel_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtAverageLabel.TextChanged
        mStandardComparison.SelectionBox = txtAverageLabel.Text
    End Sub

    Private Sub txtBestDescription_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBestDescription.TextChanged
        mBestComparison.Description = txtBestDescription.Text
    End Sub

    Private Sub txtBestLabel_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtBestLabel.TextChanged
        mBestComparison.SelectionBox = txtBestLabel.Text
    End Sub

    Private Sub txtIndPercentileDescription_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtIndPercentileDescription.TextChanged
        mIndividualPercentileComparison.Description = txtIndPercentileDescription.Text
    End Sub

    Private Sub txtIndPercentileLabel_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtIndPercentileLabel.TextChanged
        mIndividualPercentileComparison.SelectionBox = txtIndPercentileLabel.Text
        If txtIndPercentileLabel.Text = "" Then
            splAddNewPercentile.Enabled = False
            Me.splAddDecile.Enabled = False
        Else
            splAddNewPercentile.Enabled = True
            Me.splAddDecile.Enabled = True
        End If
    End Sub

    Private Sub txtDecileDescription_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtDecileDescription.TextChanged
        mDecileComparison.Description = txtDecileDescription.Text
    End Sub

    Private Sub txtDecileLabel_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtDecileLabel.TextChanged
        mDecileComparison.SelectionBox = txtDecileLabel.Text
    End Sub

    Private Sub txtNormDescription_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtNormDescription.TextChanged
        mSelectedNorm.NormDescription = txtNormDescription.Text
    End Sub

    Private Sub txtNormLabel_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtNormLabel.TextChanged
        mSelectedNorm.NormLabel = txtNormLabel.Text
    End Sub

    Private Sub cmbMonthSpan_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbMonthSpan.TextChanged
        If Not mSelectedNorm Is Nothing And cmbMonthSpan.Text <> "" Then
            mSelectedNorm.MonthSpan = CInt(cmbMonthSpan.Text)
        End If
    End Sub

    Private Sub btnAddTopN_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddTopN.Click
        Dim newComparison As New USComparisonType
        newComparison.SelectionBox = txtTopNLabel.Text
        newComparison.SelectionType = "N"
        newComparison.Description = txtTopNDescription.Text
        newComparison.USNormType = USComparisonType.NormType.TopNPercent
        newComparison.NormParam = CInt(cmbTopNParams.Text)
        mSelectedNorm.Comparisons.Add(newComparison)
        UpdateProperties()
    End Sub

    Private Sub btnPercentileAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnPercentileAdd.Click
        Dim newComparison As New USComparisonType
        newComparison.SelectionBox = txtPercentileLabel.Text
        newComparison.SelectionType = "P"
        newComparison.Description = txtPercentileDescription.Text
        newComparison.USNormType = USComparisonType.NormType.StandardPercentile
        newComparison.NormParam = CInt(cmbPercentileValue.Text)
        mSelectedNorm.Comparisons.Add(newComparison)
        UpdateProperties()
    End Sub

    Private Sub StoreSingleComparisons()
        If Not mSelectedNorm.Comparisons.Contains(mStandardComparison) Then mSelectedNorm.Comparisons.Add(mStandardComparison)
        If mBestComparison.SelectionBox <> "" And Not mSelectedNorm.Comparisons.Contains(mBestComparison) Then
            mSelectedNorm.Comparisons.Add(mBestComparison)
        End If
        If mIndividualPercentileComparison.SelectionBox <> "" And Not mSelectedNorm.Comparisons.Contains(mIndividualPercentileComparison) Then
            mSelectedNorm.Comparisons.Add(mIndividualPercentileComparison)
        End If
        If mDecileComparison.SelectionBox <> "" And Not mSelectedNorm.Comparisons.Contains(mDecileComparison) Then
            mSelectedNorm.Comparisons.Add(mDecileComparison)
        End If
    End Sub

    Private Sub Save()
        mSelectedNorm.CriteriaStatement = FilterBuilder1.txtCriteria.Text
        If Validation() = True Then
            StoreSingleComparisons()
            mSelectedNorm.Save(CurrentUser.Member.MemberId)
            'If it is a new norm, we need to reload the norms list and choose this norm
            ReloadNormsList()
        End If
    End Sub

    Private Sub ReloadNormsList()
        'We need to remove the handler SelectedNormChanged is triggered when we repopulate the list
        RemoveHandler NormList1.SelectedNormChanged, AddressOf NormList1_SelectedNormChanged
        NormList1.Populate()
        NormList1.lstNormsList.Refresh()
        AddHandler NormList1.SelectedNormChanged, AddressOf NormList1_SelectedNormChanged
        For Each tmpNorm As USNormSetting In NormList1.lstNormsList.Items
            If mSelectedNorm.NormLabel = tmpNorm.NormLabel Then
                NormList1.lstNormsList.SelectedItem = tmpNorm
                Exit For
            End If
        Next
        SelectNormInFilterList()
    End Sub

    Private Sub btnSave_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSave.Click
        Save()
    End Sub

    Private Sub USNormEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        cmbMonthSpan.Text = "36"
        If txtIndPercentileLabel.Text = "" Then splAddNewPercentile.Enabled = False
    End Sub

    Private Function Validation() As Boolean
        Dim message As New Collections.ArrayList
        Dim aggregateMessage As String = String.Empty
        Dim count As Integer
        Dim ComparisonNames As New ArrayList

        'Get a list of the comparison names currently in use
        For Each tmpNorm As USNormSetting In NormList1.lstNormsList.Items
            If Not tmpnorm Is mSelectedNorm Then
                For Each comp As USComparisonType In tmpNorm.Comparisons
                    ComparisonNames.Add(comp.SelectionBox.Trim)
                Next
            End If
        Next

        If txtNormDescription.Text.Length > 256 Then message.Add("Norm Description cannot excede 256 characters")
        If txtAverageLabel.Text.Length > 50 Then message.Add("Average Comparison Label cannot excede 50 characters")
        If txtAverageDescription.Text.Length > 300 Then message.Add("Average Comparison Description cannot excede 300 characters")
        If txtBestLabel.Text.Length > 50 Then message.Add("Best Comparison Label cannot excede 50 characters")
        If txtBestDescription.Text.Length > 300 Then message.Add("Best Comparison Description cannot excede 300 characters")
        If txtIndPercentileLabel.Text.Length > 50 Then message.Add("Individual Percentile Comparison Label cannot excede 50 characters")
        If txtIndPercentileDescription.Text.Length > 300 Then message.Add("Individual Percentile Comparison Description cannot excede 300 characters")
        If txtDecileLabel.Text.Length > 50 Then message.Add("Decile Comparison Label cannot excede 50 characters")
        If txtDecileDescription.Text.Length > 300 Then message.Add("Decile Comparison Description cannot excede 300 characters")
        If FilterBuilder1.txtCriteria.Text.Length > 7000 Then message.Add("Criteria cannot excede 7000 characters")

        For Each tmpListViewItem As ListViewItem In lsvTopNComparisons.Items
            If DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Length > 50 Then message.Add("Standard Percentile Comparison Label cannot excede 50 characters")
            If DirectCast(tmpListViewItem.Tag, USComparisonType).Description.Length > 300 Then message.Add("Standard Percentile Comparison Description cannot excede 300 characters")
            If DirectCast(tmpListViewItem.Tag, USComparisonType).NormParam > 99 Then message.Add("Top N % Value cannot excede 99")
            For Each name As String In ComparisonNames
                If DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Trim = name Then
                    message.Add("The norm name " & DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Trim & " is already in use.  Please choose another name.")
                    Exit For
                End If
            Next
        Next

        For Each tmpListViewItem As ListViewItem In lsvExistingPercentiles.Items
            If DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Length > 50 Then message.Add("Standard Percentile Comparison Label cannot excede 50 characters")
            If DirectCast(tmpListViewItem.Tag, USComparisonType).Description.Length > 300 Then message.Add("Standard Percentile Comparison Description cannot excede 300 characters")
            If DirectCast(tmpListViewItem.Tag, USComparisonType).NormParam > 99 Then message.Add("Percentile Value cannot excede 99")
            For Each name As String In ComparisonNames
                If DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Trim = name Then
                    message.Add("The norm name " & DirectCast(tmpListViewItem.Tag, USComparisonType).SelectionBox.Trim & " is already in use.  Please choose another name.")
                    Exit For
                End If
            Next
        Next

        For Each name As String In ComparisonNames
            If mStandardComparison.SelectionBox = name Then
                message.Add("A comparison named " & name & " already exists.  Please choose another name.")
                Exit For
            End If
        Next

        For Each name As String In ComparisonNames
            If mBestComparison.SelectionBox <> "" AndAlso mBestComparison.SelectionBox = name Then
                message.Add("A comparison named " & name & " already exists.  Please choose another name.")
                Exit For
            End If
        Next

        For Each name As String In ComparisonNames
            If mIndividualPercentileComparison.SelectionBox <> "" AndAlso mIndividualPercentileComparison.SelectionBox = name Then
                message.Add("A comparison named " & name & " already exists.  Please choose another name.")
                Exit For
            End If
        Next

        For Each name As String In ComparisonNames
            If mDecileComparison.SelectionBox <> "" AndAlso mDecileComparison.SelectionBox = name Then
                message.Add("A comparison named " & name & " already exists.  Please choose another name.")
                Exit For
            End If
        Next
        If txtNormLabel.Text.Length > 50 Then message.Add("Norm Label cannot excede 50 characters")
        For Each tmpNorm As USNormSetting In NormList1.lstNormsList.Items
            If mSelectedNorm.NormLabel = tmpNorm.NormLabel And Not mSelectedNorm Is tmpNorm Then
                message.Add("A norm named " & mSelectedNorm.NormLabel & " already exists.  Please choose another name.")
                Exit For
            End If
        Next

        For Each tmpMessage As String In message
            count += 1
            aggregateMessage += vbCrLf + count.ToString + " " + tmpMessage
        Next

        If message.Count > 0 Then
            MessageBox.Show(aggregateMessage, "Validation Errors", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End If

        Return True
    End Function

    Private Sub mnuPercentileChangeDescription_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPercentileChangeDescription.Click
        Dim input As New InputDialog(InputDialog.InputType.TextBox)
        input.Title = "Change Percentile Description"
        input.Prompt = "Please specify a new description"
        input.Input = lsvExistingPercentiles.SelectedItems(0).SubItems(2).Text
        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.Input <> "" Then
                lsvExistingPercentiles.SelectedItems(0).SubItems(2).Text = CStr(input.Input)
                DirectCast(lsvExistingPercentiles.SelectedItems(0).Tag, USComparisonType).Description = CStr(input.Input)
            End If
        End If
    End Sub

    Private Sub PopulateListBox(ByVal list As Windows.Forms.ListBox.ObjectCollection)
        Dim i As Integer
        list.Add("1")
        For i = 5 To 95 Step 5
            list.Add(i.ToString)
        Next
        list.Add("99")
    End Sub

    Private Sub mnuPercentileChangeValue_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPercentileChangeValue.Click
        Dim input As New InputDialog(InputDialog.InputType.ListBox)
        input.Title = "Change Percentile Value"
        input.Prompt = "Please specify a new value"
        input.MultiSelect = False

        'Populate list box
        PopulateListBox(input.Items)

        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.SelectedItems.Count = 1 Then
                lsvExistingPercentiles.SelectedItems(0).SubItems(3).Text = CStr(input.Input)
                DirectCast(lsvExistingPercentiles.SelectedItems(0).Tag, USComparisonType).NormParam = CInt(CStr(input.Input))
            End If
        End If
    End Sub

    Private Sub mnuPercentileRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPercentileRename.Click
        Dim input As New InputDialog(InputDialog.InputType.TextBox)
        input.Title = "Change Percentile Label"
        input.Prompt = "Please specify a new Label"
        input.Input = lsvExistingPercentiles.SelectedItems(0).SubItems(1).Text
        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.Input <> "" Then
                lsvExistingPercentiles.SelectedItems(0).SubItems(1).Text = CStr(input.Input)
                DirectCast(lsvExistingPercentiles.SelectedItems(0).Tag, USComparisonType).SelectionBox = CStr(input.Input)
            End If
        End If
    End Sub

    Private Sub mnuTopNChangeDescription_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTopNChangeDescription.Click
        Dim input As New InputDialog(InputDialog.InputType.TextBox)
        input.Title = "Change Top N% Description"
        input.Prompt = "Please specify a new description"
        input.Input = lsvTopNComparisons.SelectedItems(0).SubItems(2).Text
        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.Input <> "" Then
                lsvTopNComparisons.SelectedItems(0).SubItems(2).Text = CStr(input.Input)
                DirectCast(lsvTopNComparisons.SelectedItems(0).Tag, USComparisonType).Description = CStr(input.Input)
            End If
        End If
    End Sub

    Private Sub mnuTopNChangeValue_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTopNChangeValue.Click
        Dim input As New InputDialog(InputDialog.InputType.ListBox)
        input.Title = "Change Top N% Value"
        input.Prompt = "Please specify a new value"
        input.MultiSelect = False

        'Populate list box
        PopulateListBox(input.Items)

        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.SelectedItems.Count = 1 Then
                lsvTopNComparisons.SelectedItems(0).SubItems(3).Text = CStr(input.Input)
                DirectCast(lsvTopNComparisons.SelectedItems(0).Tag, USComparisonType).NormParam = CInt(CStr(input.Input))
            End If
        End If
    End Sub

    Private Sub mnuTopNRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTopNRename.Click
        Dim input As New InputDialog(InputDialog.InputType.TextBox)
        input.Title = "Change Top N% Label"
        input.Prompt = "Please specify a new Label"
        input.Input = lsvTopNComparisons.SelectedItems(0).SubItems(1).Text
        input.ShowDialog()
        If input.DialogResult = DialogResult.OK Then
            If input.Input <> "" Then
                lsvTopNComparisons.SelectedItems(0).SubItems(1).Text = CStr(input.Input)
                DirectCast(lsvTopNComparisons.SelectedItems(0).Tag, USComparisonType).SelectionBox = CStr(input.Input)
            End If
        End If
    End Sub

    Private Sub mnuPercentileDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuPercentileDelete.Click
        mSelectedNorm.Comparisons.Remove(DirectCast(lsvExistingPercentiles.SelectedItems(0).Tag, USComparisonType))
        lsvExistingPercentiles.Items.Remove(lsvExistingPercentiles.SelectedItems(0))
    End Sub

    Private Sub mnuTopNDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuTopNDelete.Click
        mSelectedNorm.Comparisons.Remove(DirectCast(lsvTopNComparisons.SelectedItems(0).Tag, USComparisonType))
        lsvTopNComparisons.Items.Remove(lsvTopNComparisons.SelectedItems(0))
    End Sub

    Private Sub lsvExistingPercentiles_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lsvExistingPercentiles.SelectedIndexChanged
        If lsvExistingPercentiles.SelectedItems.Count > 0 Then
            If lsvExistingPercentiles.SelectedItems(0).SubItems(0).Text = "0" Then
                mnuPercentileDelete.Enabled = True
            Else : mnuPercentileDelete.Enabled = False
            End If
        End If
    End Sub

    Private Sub lsvTopNComparisons_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lsvTopNComparisons.SelectedIndexChanged
        If lsvTopNComparisons.SelectedItems.Count > 0 Then
            If lsvTopNComparisons.SelectedItems(0).SubItems(0).Text = "0" Then
                mnuTopNDelete.Enabled = True
            Else : mnuTopNDelete.Enabled = False
            End If
        End If
    End Sub

    Private Sub chkMinClientCheck_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkMinClientCheck.CheckedChanged
        mSelectedNorm.MinClientCheck = chkMinClientCheck.Checked
    End Sub

    Private Sub chkOngoing_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles chkOngoing.CheckedChanged
        mSelectedNorm.Ongoing = chkOngoing.Checked
    End Sub

    Private Sub FilterBuilder1_Leave(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterBuilder1.Leave
        mSelectedNorm.CriteriaStatement = FilterBuilder1.txtCriteria.Text
    End Sub
End Class
