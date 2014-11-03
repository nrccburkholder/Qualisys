<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class USPSAddressUpdateSection
    Inherits QualiSys.QualiSysExplorer.ContentControlBase

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Dim GridLevelNode1 As DevExpress.XtraGrid.GridLevelNode = New DevExpress.XtraGrid.GridLevelNode()
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(USPSAddressUpdateSection))
        Me.gvOldAddresses = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridColumn13 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn14 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn15 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn16 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn17 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn18 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn19 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn20 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.gcPartialMatches = New DevExpress.XtraGrid.GridControl()
        Me.gvPartialMatches = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.GridColumn1 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn2 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn3 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn4 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn5 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn6 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn7 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn8 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn9 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn10 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn11 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.GridColumn12 = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.RepositoryItemRadioGroup1 = New DevExpress.XtraEditors.Repository.RepositoryItemRadioGroup()
        Me.RepositoryItemCheckEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit()
        Me.RepositoryItemCheckEdit2 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit()
        Me.RepositoryItemCheckedComboBoxEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckedComboBoxEdit()
        Me.gvNewAddresses = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.btnApply = New System.Windows.Forms.Button()
        Me.USPSSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.ActionPanel = New System.Windows.Forms.Panel()
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip()
        Me.btnExpandAll = New System.Windows.Forms.ToolStripButton()
        CType(Me.gvOldAddresses, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gcPartialMatches, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvPartialMatches, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemRadioGroup1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckEdit2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckedComboBoxEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.gvNewAddresses, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BottomPanel.SuspendLayout()
        Me.USPSSectionPanel.SuspendLayout()
        Me.ActionPanel.SuspendLayout()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'gvOldAddresses
        '
        Me.gvOldAddresses.Appearance.Row.BackColor = System.Drawing.Color.White
        Me.gvOldAddresses.Appearance.Row.BorderColor = System.Drawing.SystemColors.ActiveBorder
        Me.gvOldAddresses.Appearance.Row.Options.UseBackColor = True
        Me.gvOldAddresses.Appearance.Row.Options.UseBorderColor = True
        Me.gvOldAddresses.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.GridColumn13, Me.GridColumn14, Me.GridColumn15, Me.GridColumn16, Me.GridColumn17, Me.GridColumn18, Me.GridColumn19, Me.GridColumn20})
        Me.gvOldAddresses.GridControl = Me.gcPartialMatches
        Me.gvOldAddresses.Name = "gvOldAddresses"
        Me.gvOldAddresses.OptionsBehavior.Editable = False
        Me.gvOldAddresses.OptionsFilter.AllowFilterEditor = False
        Me.gvOldAddresses.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.gvOldAddresses.OptionsView.EnableAppearanceEvenRow = True
        Me.gvOldAddresses.OptionsView.EnableAppearanceOddRow = True
        Me.gvOldAddresses.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.gvOldAddresses.OptionsView.ShowGroupPanel = False
        Me.gvOldAddresses.OptionsView.ShowIndicator = False
        '
        'GridColumn13
        '
        Me.GridColumn13.Caption = "First Name"
        Me.GridColumn13.FieldName = "FName"
        Me.GridColumn13.Name = "GridColumn13"
        Me.GridColumn13.Visible = True
        Me.GridColumn13.VisibleIndex = 0
        '
        'GridColumn14
        '
        Me.GridColumn14.Caption = "Last Name"
        Me.GridColumn14.FieldName = "LName"
        Me.GridColumn14.Name = "GridColumn14"
        Me.GridColumn14.Visible = True
        Me.GridColumn14.VisibleIndex = 1
        '
        'GridColumn15
        '
        Me.GridColumn15.Caption = "Address"
        Me.GridColumn15.FieldName = "Addr"
        Me.GridColumn15.Name = "GridColumn15"
        Me.GridColumn15.Visible = True
        Me.GridColumn15.VisibleIndex = 2
        '
        'GridColumn16
        '
        Me.GridColumn16.Caption = "Address 2"
        Me.GridColumn16.FieldName = "Addr2"
        Me.GridColumn16.Name = "GridColumn16"
        Me.GridColumn16.Visible = True
        Me.GridColumn16.VisibleIndex = 3
        '
        'GridColumn17
        '
        Me.GridColumn17.Caption = "City"
        Me.GridColumn17.FieldName = "City"
        Me.GridColumn17.Name = "GridColumn17"
        Me.GridColumn17.Visible = True
        Me.GridColumn17.VisibleIndex = 4
        '
        'GridColumn18
        '
        Me.GridColumn18.Caption = "State"
        Me.GridColumn18.FieldName = "State"
        Me.GridColumn18.Name = "GridColumn18"
        Me.GridColumn18.Visible = True
        Me.GridColumn18.VisibleIndex = 5
        '
        'GridColumn19
        '
        Me.GridColumn19.Caption = "Zip5"
        Me.GridColumn19.FieldName = "Zip5"
        Me.GridColumn19.Name = "GridColumn19"
        Me.GridColumn19.Visible = True
        Me.GridColumn19.VisibleIndex = 6
        '
        'GridColumn20
        '
        Me.GridColumn20.Caption = "Plus 4 Zip"
        Me.GridColumn20.FieldName = "Plus4Zip"
        Me.GridColumn20.Name = "GridColumn20"
        Me.GridColumn20.Visible = True
        Me.GridColumn20.VisibleIndex = 7
        '
        'gcPartialMatches
        '
        Me.gcPartialMatches.Dock = System.Windows.Forms.DockStyle.Fill
        GridLevelNode1.LevelTemplate = Me.gvOldAddresses
        GridLevelNode1.RelationName = "FK_PopAddress_OldAddress"
        Me.gcPartialMatches.LevelTree.Nodes.AddRange(New DevExpress.XtraGrid.GridLevelNode() {GridLevelNode1})
        Me.gcPartialMatches.Location = New System.Drawing.Point(0, 0)
        Me.gcPartialMatches.MainView = Me.gvPartialMatches
        Me.gcPartialMatches.Name = "gcPartialMatches"
        Me.gcPartialMatches.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemRadioGroup1, Me.RepositoryItemCheckEdit1, Me.RepositoryItemCheckEdit2, Me.RepositoryItemCheckedComboBoxEdit1})
        Me.gcPartialMatches.Size = New System.Drawing.Size(975, 619)
        Me.gcPartialMatches.TabIndex = 1
        Me.gcPartialMatches.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.gvPartialMatches, Me.gvNewAddresses, Me.gvOldAddresses})
        '
        'gvPartialMatches
        '
        Me.gvPartialMatches.Appearance.EvenRow.BackColor = System.Drawing.Color.Khaki
        Me.gvPartialMatches.Appearance.EvenRow.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.OddRow.BackColor = System.Drawing.Color.LightBlue
        Me.gvPartialMatches.Appearance.OddRow.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.Row.BackColor = System.Drawing.Color.White
        Me.gvPartialMatches.Appearance.Row.BorderColor = System.Drawing.Color.FromArgb(CType(CType(64, Byte), Integer), CType(CType(64, Byte), Integer), CType(CType(64, Byte), Integer))
        Me.gvPartialMatches.Appearance.Row.Options.UseBackColor = True
        Me.gvPartialMatches.Appearance.Row.Options.UseBorderColor = True
        Me.gvPartialMatches.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.GridColumn1, Me.GridColumn2, Me.GridColumn3, Me.GridColumn4, Me.GridColumn5, Me.GridColumn6, Me.GridColumn7, Me.GridColumn8, Me.GridColumn9, Me.GridColumn10, Me.GridColumn11, Me.GridColumn12})
        Me.gvPartialMatches.DetailHeight = 550
        Me.gvPartialMatches.DetailTabHeaderLocation = DevExpress.XtraTab.TabHeaderLocation.Left
        Me.gvPartialMatches.GridControl = Me.gcPartialMatches
        Me.gvPartialMatches.Name = "gvPartialMatches"
        Me.gvPartialMatches.OptionsDetail.ShowDetailTabs = False
        Me.gvPartialMatches.RowHeight = 40
        '
        'GridColumn1
        '
        Me.GridColumn1.Caption = "Id"
        Me.GridColumn1.FieldName = "Id"
        Me.GridColumn1.Name = "GridColumn1"
        Me.GridColumn1.Visible = True
        Me.GridColumn1.VisibleIndex = 0
        '
        'GridColumn2
        '
        Me.GridColumn2.Caption = "Study Id"
        Me.GridColumn2.FieldName = "Study_id"
        Me.GridColumn2.Name = "GridColumn2"
        Me.GridColumn2.Visible = True
        Me.GridColumn2.VisibleIndex = 1
        Me.GridColumn2.Width = 52
        '
        'GridColumn3
        '
        Me.GridColumn3.Caption = "Pop Id"
        Me.GridColumn3.FieldName = "Pop_id"
        Me.GridColumn3.Name = "GridColumn3"
        Me.GridColumn3.Visible = True
        Me.GridColumn3.VisibleIndex = 2
        Me.GridColumn3.Width = 66
        '
        'GridColumn4
        '
        Me.GridColumn4.Caption = "Lithocode"
        Me.GridColumn4.FieldName = "Lithocode"
        Me.GridColumn4.Name = "GridColumn4"
        Me.GridColumn4.Visible = True
        Me.GridColumn4.VisibleIndex = 3
        Me.GridColumn4.Width = 66
        '
        'GridColumn5
        '
        Me.GridColumn5.Caption = "First Name"
        Me.GridColumn5.FieldName = "FirstName"
        Me.GridColumn5.Name = "GridColumn5"
        Me.GridColumn5.Visible = True
        Me.GridColumn5.VisibleIndex = 4
        Me.GridColumn5.Width = 66
        '
        'GridColumn6
        '
        Me.GridColumn6.Caption = "Last Name"
        Me.GridColumn6.FieldName = "LastName"
        Me.GridColumn6.Name = "GridColumn6"
        Me.GridColumn6.Visible = True
        Me.GridColumn6.VisibleIndex = 5
        Me.GridColumn6.Width = 66
        '
        'GridColumn7
        '
        Me.GridColumn7.Caption = "Address"
        Me.GridColumn7.FieldName = "Addr"
        Me.GridColumn7.Name = "GridColumn7"
        Me.GridColumn7.Visible = True
        Me.GridColumn7.VisibleIndex = 6
        Me.GridColumn7.Width = 66
        '
        'GridColumn8
        '
        Me.GridColumn8.Caption = "Address 2"
        Me.GridColumn8.FieldName = "Addr2"
        Me.GridColumn8.Name = "GridColumn8"
        Me.GridColumn8.Visible = True
        Me.GridColumn8.VisibleIndex = 7
        Me.GridColumn8.Width = 66
        '
        'GridColumn9
        '
        Me.GridColumn9.Caption = "City"
        Me.GridColumn9.FieldName = "City"
        Me.GridColumn9.Name = "GridColumn9"
        Me.GridColumn9.Visible = True
        Me.GridColumn9.VisibleIndex = 8
        Me.GridColumn9.Width = 118
        '
        'GridColumn10
        '
        Me.GridColumn10.Caption = "State"
        Me.GridColumn10.FieldName = "State"
        Me.GridColumn10.Name = "GridColumn10"
        Me.GridColumn10.Visible = True
        Me.GridColumn10.VisibleIndex = 9
        Me.GridColumn10.Width = 59
        '
        'GridColumn11
        '
        Me.GridColumn11.Caption = "Zip5"
        Me.GridColumn11.FieldName = "Zip"
        Me.GridColumn11.Name = "GridColumn11"
        Me.GridColumn11.Visible = True
        Me.GridColumn11.VisibleIndex = 10
        Me.GridColumn11.Width = 34
        '
        'GridColumn12
        '
        Me.GridColumn12.ColumnEdit = Me.RepositoryItemRadioGroup1
        Me.GridColumn12.FieldName = "Action"
        Me.GridColumn12.Name = "GridColumn12"
        Me.GridColumn12.OptionsColumn.ShowCaption = False
        Me.GridColumn12.OptionsFilter.AllowAutoFilter = False
        Me.GridColumn12.OptionsFilter.AllowFilter = False
        Me.GridColumn12.Visible = True
        Me.GridColumn12.VisibleIndex = 11
        '
        'RepositoryItemRadioGroup1
        '
        Me.RepositoryItemRadioGroup1.Columns = 1
        Me.RepositoryItemRadioGroup1.Items.AddRange(New DevExpress.XtraEditors.Controls.RadioGroupItem() {New DevExpress.XtraEditors.Controls.RadioGroupItem("1", "Update"), New DevExpress.XtraEditors.Controls.RadioGroupItem("2", "Ignore")})
        Me.RepositoryItemRadioGroup1.Name = "RepositoryItemRadioGroup1"
        '
        'RepositoryItemCheckEdit1
        '
        Me.RepositoryItemCheckEdit1.AutoHeight = False
        Me.RepositoryItemCheckEdit1.CheckStyle = DevExpress.XtraEditors.Controls.CheckStyles.Radio
        Me.RepositoryItemCheckEdit1.Name = "RepositoryItemCheckEdit1"
        '
        'RepositoryItemCheckEdit2
        '
        Me.RepositoryItemCheckEdit2.AutoHeight = False
        Me.RepositoryItemCheckEdit2.CheckStyle = DevExpress.XtraEditors.Controls.CheckStyles.Radio
        Me.RepositoryItemCheckEdit2.Name = "RepositoryItemCheckEdit2"
        '
        'RepositoryItemCheckedComboBoxEdit1
        '
        Me.RepositoryItemCheckedComboBoxEdit1.AutoHeight = False
        Me.RepositoryItemCheckedComboBoxEdit1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemCheckedComboBoxEdit1.DropDownRows = 2
        Me.RepositoryItemCheckedComboBoxEdit1.Items.AddRange(New DevExpress.XtraEditors.Controls.CheckedListBoxItem() {New DevExpress.XtraEditors.Controls.CheckedListBoxItem("1", "Update"), New DevExpress.XtraEditors.Controls.CheckedListBoxItem("2", "Ignore")})
        Me.RepositoryItemCheckedComboBoxEdit1.Name = "RepositoryItemCheckedComboBoxEdit1"
        Me.RepositoryItemCheckedComboBoxEdit1.SelectAllItemVisible = False
        '
        'gvNewAddresses
        '
        Me.gvNewAddresses.GridControl = Me.gcPartialMatches
        Me.gvNewAddresses.Name = "gvNewAddresses"
        Me.gvNewAddresses.OptionsFilter.AllowFilterEditor = False
        Me.gvNewAddresses.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.gvNewAddresses.OptionsView.ShowGroupPanel = False
        '
        'BottomPanel
        '
        Me.BottomPanel.Controls.Add(Me.btnApply)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 647)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(977, 49)
        Me.BottomPanel.TabIndex = 1
        '
        'btnApply
        '
        Me.btnApply.Location = New System.Drawing.Point(726, 6)
        Me.btnApply.Name = "btnApply"
        Me.btnApply.Size = New System.Drawing.Size(75, 23)
        Me.btnApply.TabIndex = 0
        Me.btnApply.Text = "Apply"
        Me.btnApply.UseVisualStyleBackColor = True
        '
        'USPSSectionPanel
        '
        Me.USPSSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.USPSSectionPanel.Caption = "Update Addresses"
        Me.USPSSectionPanel.Controls.Add(Me.ActionPanel)
        Me.USPSSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.USPSSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.USPSSectionPanel.Name = "USPSSectionPanel"
        Me.USPSSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.USPSSectionPanel.ShowCaption = True
        Me.USPSSectionPanel.Size = New System.Drawing.Size(977, 647)
        Me.USPSSectionPanel.TabIndex = 4
        '
        'ActionPanel
        '
        Me.ActionPanel.Controls.Add(Me.ToolStrip1)
        Me.ActionPanel.Controls.Add(Me.gcPartialMatches)
        Me.ActionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ActionPanel.Location = New System.Drawing.Point(1, 27)
        Me.ActionPanel.Name = "ActionPanel"
        Me.ActionPanel.Size = New System.Drawing.Size(975, 619)
        Me.ActionPanel.TabIndex = 1
        '
        'ToolStrip1
        '
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.btnExpandAll})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(975, 25)
        Me.ToolStrip1.TabIndex = 2
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'btnExpandAll
        '
        Me.btnExpandAll.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.btnExpandAll.Image = CType(resources.GetObject("btnExpandAll.Image"), System.Drawing.Image)
        Me.btnExpandAll.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.btnExpandAll.Name = "btnExpandAll"
        Me.btnExpandAll.Size = New System.Drawing.Size(66, 22)
        Me.btnExpandAll.Text = "Expand All"
        '
        'USPSAddressUpdateSection
        '
        Me.Controls.Add(Me.USPSSectionPanel)
        Me.Controls.Add(Me.BottomPanel)
        Me.Name = "USPSAddressUpdateSection"
        Me.Size = New System.Drawing.Size(977, 696)
        CType(Me.gvOldAddresses, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gcPartialMatches, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvPartialMatches, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemRadioGroup1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckEdit2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckedComboBoxEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.gvNewAddresses, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BottomPanel.ResumeLayout(False)
        Me.USPSSectionPanel.ResumeLayout(False)
        Me.ActionPanel.ResumeLayout(False)
        Me.ActionPanel.PerformLayout()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents USPSSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ActionPanel As System.Windows.Forms.Panel
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents gcPartialMatches As DevExpress.XtraGrid.GridControl
    Friend WithEvents gvOldAddresses As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridColumn13 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn14 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn15 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn16 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn17 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn18 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn19 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn20 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents gvPartialMatches As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridColumn1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn2 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn3 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn4 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn5 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn6 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn7 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn8 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn9 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn10 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn11 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents GridColumn12 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents RepositoryItemRadioGroup1 As DevExpress.XtraEditors.Repository.RepositoryItemRadioGroup
    Friend WithEvents RepositoryItemCheckEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents RepositoryItemCheckEdit2 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents RepositoryItemCheckedComboBoxEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckedComboBoxEdit
    Friend WithEvents gvNewAddresses As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents btnApply As System.Windows.Forms.Button
    Friend WithEvents btnExpandAll As System.Windows.Forms.ToolStripButton

End Class
