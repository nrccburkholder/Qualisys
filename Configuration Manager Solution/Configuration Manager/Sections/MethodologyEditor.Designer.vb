<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MethodologyEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.components = New System.ComponentModel.Container()
        Me.OKButton = New System.Windows.Forms.Button()
        Me.CancelButton = New System.Windows.Forms.Button()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.SplitContainer = New System.Windows.Forms.SplitContainer()
        Me.MethSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.MethToolStrip = New System.Windows.Forms.ToolStrip()
        Me.MethNewTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethDeleteTSButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethEditTSButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethActivateTSButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator5 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethUndoTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethDataGrid = New System.Windows.Forms.DataGridView()
        Me.MethActiveColumn = New System.Windows.Forms.DataGridViewImageColumn()
        Me.MethNameColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.MethTypeColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethCreatedColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.MethMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.MethNewMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MethDeleteMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator6 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethEditMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator7 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethActivateMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator8 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethUndoMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer()
        Me.MethStepSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.MethStepToolStrip = New System.Windows.Forms.ToolStrip()
        Me.MethStepNewTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethStepDeleteTSButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethStepMoveUpTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethStepMoveDownTSButton = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethStepApplyTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethStepUndoTSButton = New System.Windows.Forms.ToolStripButton()
        Me.MethStepDataGrid = New System.Windows.Forms.DataGridView()
        Me.MethStepTypeTextBoxColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.MethStepTypeComboBoxColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethStepDaysSincePrevColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.MethStepCoverLetterColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethStepLanguageColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethStepIncludeWithPrevColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethStepExpirationDaysColumn = New System.Windows.Forms.DataGridViewTextBoxColumn()
        Me.MethStepExpireFromStepColumn = New System.Windows.Forms.DataGridViewComboBoxColumn()
        Me.MethStepMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.MethStepNewMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MethStepDeleteMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator9 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethStepMoveUpMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MethStepMoveDownMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ToolStripSeparator10 = New System.Windows.Forms.ToolStripSeparator()
        Me.MethStepApplyMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MethStepUndoMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MethPropsSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.MethodologyPropsWebPanel = New System.Windows.Forms.Panel()
        Me.WebEmailBlastGridControl = New DevExpress.XtraGrid.GridControl()
        Me.EmailBlastBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.WebEmailBlastGridView = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.colEmailBlastId = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.EmailBlastNameLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit()
        Me.EmailBlastOptionBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.colDaysFromStepGen = New DevExpress.XtraGrid.Columns.GridColumn()
        Me.DaysFromStepGenTextEdit = New DevExpress.XtraEditors.Repository.RepositoryItemTextEdit()
        Me.EmailBlastNameComboBox = New DevExpress.XtraEditors.Repository.RepositoryItemComboBox()
        Me.EmailBlastNameGridLookUpEdit = New DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit()
        Me.RepositoryItemGridLookUpEdit1View = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.WebEmailBlastCheckBox = New System.Windows.Forms.CheckBox()
        Me.WebQuotasGroupBox = New System.Windows.Forms.GroupBox()
        Me.WebReturnsLabel = New System.Windows.Forms.Label()
        Me.WebQuotasStopReturnsTextBox = New System.Windows.Forms.TextBox()
        Me.WebQuotasStopReturnsRadioButton = New System.Windows.Forms.RadioButton()
        Me.WebQuotasAllReturnsRadioButton = New System.Windows.Forms.RadioButton()
        Me.WebDaysInFieldLabel = New System.Windows.Forms.Label()
        Me.WebAcceptPartialCheckBox = New System.Windows.Forms.CheckBox()
        Me.WebDaysInFieldTextBox = New System.Windows.Forms.TextBox()
        Me.MethodologyPropsIVRPanel = New System.Windows.Forms.Panel()
        Me.IVRDaysInFieldLabel = New System.Windows.Forms.Label()
        Me.IVRAcceptPartialCheckBox = New System.Windows.Forms.CheckBox()
        Me.IVRDaysInFieldTextBox = New System.Windows.Forms.TextBox()
        Me.MethodologyPropsPhonePanel = New System.Windows.Forms.Panel()
        Me.PhoneEveningSunCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneDaySunCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneEveningSatCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneDaySatCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneSundayLabel = New System.Windows.Forms.Label()
        Me.PhoneSaturdayLabel = New System.Windows.Forms.Label()
        Me.PhoneMFLabel = New System.Windows.Forms.Label()
        Me.PhoneEveningMFCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneNumberOfAttemptsLabel = New System.Windows.Forms.Label()
        Me.PhoneNumberOfAttemptsTextBox = New System.Windows.Forms.TextBox()
        Me.PhoneTTYCallbackCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneLangCallbackCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneQuotasGroupBox = New System.Windows.Forms.GroupBox()
        Me.PhoneReturnsLabel = New System.Windows.Forms.Label()
        Me.PhoneQuotasStopReturnsTextBox = New System.Windows.Forms.TextBox()
        Me.PhoneQuotasStopReturnsRadioButton = New System.Windows.Forms.RadioButton()
        Me.PhoneQuotasAllReturnsRadioButton = New System.Windows.Forms.RadioButton()
        Me.PhoneDaysInFieldLabel = New System.Windows.Forms.Label()
        Me.PhoneDayMFCheckBox = New System.Windows.Forms.CheckBox()
        Me.PhoneDaysInFieldTextBox = New System.Windows.Forms.TextBox()
        Me.InformationBar = New Nrc.QualiSys.ConfigurationManager.InformationBar()
        Me.MethPropsErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.WebBlastErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.BottomPanel.SuspendLayout()
        Me.SplitContainer.Panel1.SuspendLayout()
        Me.SplitContainer.Panel2.SuspendLayout()
        Me.SplitContainer.SuspendLayout()
        Me.MethSectionPanel.SuspendLayout()
        Me.MethToolStrip.SuspendLayout()
        CType(Me.MethDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MethMenuStrip.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.MethStepSectionPanel.SuspendLayout()
        Me.MethStepToolStrip.SuspendLayout()
        CType(Me.MethStepDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MethStepMenuStrip.SuspendLayout()
        Me.MethPropsSectionPanel.SuspendLayout()
        Me.MethodologyPropsWebPanel.SuspendLayout()
        CType(Me.WebEmailBlastGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.WebEmailBlastGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastOptionBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DaysFromStepGenTextEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameComboBox, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.EmailBlastNameGridLookUpEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.WebQuotasGroupBox.SuspendLayout()
        Me.MethodologyPropsIVRPanel.SuspendLayout()
        Me.MethodologyPropsPhonePanel.SuspendLayout()
        Me.PhoneQuotasGroupBox.SuspendLayout()
        CType(Me.MethPropsErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.WebBlastErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(651, 5)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 0
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(732, 5)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Controls.Add(Me.OKButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 656)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(814, 35)
        Me.BottomPanel.TabIndex = 3
        '
        'SplitContainer
        '
        Me.SplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer.Location = New System.Drawing.Point(0, 20)
        Me.SplitContainer.Name = "SplitContainer"
        Me.SplitContainer.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer.Panel1
        '
        Me.SplitContainer.Panel1.Controls.Add(Me.MethSectionPanel)
        '
        'SplitContainer.Panel2
        '
        Me.SplitContainer.Panel2.Controls.Add(Me.SplitContainer1)
        Me.SplitContainer.Size = New System.Drawing.Size(814, 636)
        Me.SplitContainer.SplitterDistance = 224
        Me.SplitContainer.TabIndex = 4
        '
        'MethSectionPanel
        '
        Me.MethSectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethSectionPanel.Caption = "Survey Methodologies"
        Me.MethSectionPanel.Controls.Add(Me.MethToolStrip)
        Me.MethSectionPanel.Controls.Add(Me.MethDataGrid)
        Me.MethSectionPanel.Location = New System.Drawing.Point(6, 6)
        Me.MethSectionPanel.Name = "MethSectionPanel"
        Me.MethSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethSectionPanel.ShowCaption = True
        Me.MethSectionPanel.Size = New System.Drawing.Size(801, 214)
        Me.MethSectionPanel.TabIndex = 5
        '
        'MethToolStrip
        '
        Me.MethToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethNewTSButton, Me.MethDeleteTSButton, Me.ToolStripSeparator3, Me.MethEditTSButton, Me.ToolStripSeparator1, Me.MethActivateTSButton, Me.ToolStripSeparator5, Me.MethUndoTSButton})
        Me.MethToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MethToolStrip.Name = "MethToolStrip"
        Me.MethToolStrip.Size = New System.Drawing.Size(799, 25)
        Me.MethToolStrip.TabIndex = 3
        Me.MethToolStrip.Text = "ToolStrip1"
        '
        'MethNewTSButton
        '
        Me.MethNewTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.New16
        Me.MethNewTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethNewTSButton.Name = "MethNewTSButton"
        Me.MethNewTSButton.Size = New System.Drawing.Size(126, 22)
        Me.MethNewTSButton.Text = "New Methodology"
        '
        'MethDeleteTSButton
        '
        Me.MethDeleteTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MethDeleteTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethDeleteTSButton.Name = "MethDeleteTSButton"
        Me.MethDeleteTSButton.Size = New System.Drawing.Size(135, 22)
        Me.MethDeleteTSButton.Text = "Delete Methodology"
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(6, 25)
        '
        'MethEditTSButton
        '
        Me.MethEditTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Properties16
        Me.MethEditTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethEditTSButton.Name = "MethEditTSButton"
        Me.MethEditTSButton.Size = New System.Drawing.Size(78, 22)
        Me.MethEditTSButton.Text = "Edit Steps"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'MethActivateTSButton
        '
        Me.MethActivateTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Validation16
        Me.MethActivateTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethActivateTSButton.Name = "MethActivateTSButton"
        Me.MethActivateTSButton.Size = New System.Drawing.Size(145, 22)
        Me.MethActivateTSButton.Text = "Activate Methodology"
        '
        'ToolStripSeparator5
        '
        Me.ToolStripSeparator5.Name = "ToolStripSeparator5"
        Me.ToolStripSeparator5.Size = New System.Drawing.Size(6, 25)
        '
        'MethUndoTSButton
        '
        Me.MethUndoTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Undo16
        Me.MethUndoTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethUndoTSButton.Name = "MethUndoTSButton"
        Me.MethUndoTSButton.Size = New System.Drawing.Size(105, 22)
        Me.MethUndoTSButton.Text = "Undo Changes"
        '
        'MethDataGrid
        '
        Me.MethDataGrid.AllowUserToAddRows = False
        Me.MethDataGrid.AllowUserToDeleteRows = False
        Me.MethDataGrid.AllowUserToResizeRows = False
        Me.MethDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.MethDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.MethActiveColumn, Me.MethNameColumn, Me.MethTypeColumn, Me.MethCreatedColumn})
        Me.MethDataGrid.ContextMenuStrip = Me.MethMenuStrip
        Me.MethDataGrid.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter
        Me.MethDataGrid.Location = New System.Drawing.Point(1, 52)
        Me.MethDataGrid.MultiSelect = False
        Me.MethDataGrid.Name = "MethDataGrid"
        Me.MethDataGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.MethDataGrid.Size = New System.Drawing.Size(799, 161)
        Me.MethDataGrid.TabIndex = 3
        '
        'MethActiveColumn
        '
        Me.MethActiveColumn.HeaderText = "Active"
        Me.MethActiveColumn.MinimumWidth = 25
        Me.MethActiveColumn.Name = "MethActiveColumn"
        Me.MethActiveColumn.ReadOnly = True
        Me.MethActiveColumn.ToolTipText = "Icon is displayed for the Active Methodology"
        Me.MethActiveColumn.Width = 43
        '
        'MethNameColumn
        '
        Me.MethNameColumn.HeaderText = "Name"
        Me.MethNameColumn.MaxInputLength = 42
        Me.MethNameColumn.MinimumWidth = 100
        Me.MethNameColumn.Name = "MethNameColumn"
        Me.MethNameColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        Me.MethNameColumn.Width = 200
        '
        'MethTypeColumn
        '
        Me.MethTypeColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethTypeColumn.HeaderText = "Type"
        Me.MethTypeColumn.MinimumWidth = 50
        Me.MethTypeColumn.Name = "MethTypeColumn"
        Me.MethTypeColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethTypeColumn.Width = 220
        '
        'MethCreatedColumn
        '
        Me.MethCreatedColumn.HeaderText = "Date Created"
        Me.MethCreatedColumn.MinimumWidth = 50
        Me.MethCreatedColumn.Name = "MethCreatedColumn"
        Me.MethCreatedColumn.ReadOnly = True
        Me.MethCreatedColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        Me.MethCreatedColumn.Width = 150
        '
        'MethMenuStrip
        '
        Me.MethMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethNewMenuItem, Me.MethDeleteMenuItem, Me.ToolStripSeparator6, Me.MethEditMenuItem, Me.ToolStripSeparator7, Me.MethActivateMenuItem, Me.ToolStripSeparator8, Me.MethUndoMenuItem})
        Me.MethMenuStrip.Name = "MethMenuStrip"
        Me.MethMenuStrip.Size = New System.Drawing.Size(193, 132)
        '
        'MethNewMenuItem
        '
        Me.MethNewMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.New16
        Me.MethNewMenuItem.Name = "MethNewMenuItem"
        Me.MethNewMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.MethNewMenuItem.Text = "New Methodology"
        '
        'MethDeleteMenuItem
        '
        Me.MethDeleteMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MethDeleteMenuItem.Name = "MethDeleteMenuItem"
        Me.MethDeleteMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.MethDeleteMenuItem.Text = "Delete Methodology"
        '
        'ToolStripSeparator6
        '
        Me.ToolStripSeparator6.Name = "ToolStripSeparator6"
        Me.ToolStripSeparator6.Size = New System.Drawing.Size(189, 6)
        '
        'MethEditMenuItem
        '
        Me.MethEditMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Properties16
        Me.MethEditMenuItem.Name = "MethEditMenuItem"
        Me.MethEditMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.MethEditMenuItem.Text = "Edit Steps"
        '
        'ToolStripSeparator7
        '
        Me.ToolStripSeparator7.Name = "ToolStripSeparator7"
        Me.ToolStripSeparator7.Size = New System.Drawing.Size(189, 6)
        '
        'MethActivateMenuItem
        '
        Me.MethActivateMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Validation16
        Me.MethActivateMenuItem.Name = "MethActivateMenuItem"
        Me.MethActivateMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.MethActivateMenuItem.Text = "Activate Methodology"
        '
        'ToolStripSeparator8
        '
        Me.ToolStripSeparator8.Name = "ToolStripSeparator8"
        Me.ToolStripSeparator8.Size = New System.Drawing.Size(189, 6)
        '
        'MethUndoMenuItem
        '
        Me.MethUndoMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Undo16
        Me.MethUndoMenuItem.Name = "MethUndoMenuItem"
        Me.MethUndoMenuItem.Size = New System.Drawing.Size(192, 22)
        Me.MethUndoMenuItem.Text = "Undo Changes"
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SplitContainer1.Location = New System.Drawing.Point(0, 0)
        Me.SplitContainer1.Name = "SplitContainer1"
        Me.SplitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.MethStepSectionPanel)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.MethPropsSectionPanel)
        Me.SplitContainer1.Panel2.Enabled = False
        Me.SplitContainer1.Size = New System.Drawing.Size(814, 408)
        Me.SplitContainer1.SplitterDistance = 211
        Me.SplitContainer1.TabIndex = 6
        '
        'MethStepSectionPanel
        '
        Me.MethStepSectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethStepSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethStepSectionPanel.Caption = "Methodology Steps"
        Me.MethStepSectionPanel.Controls.Add(Me.MethStepToolStrip)
        Me.MethStepSectionPanel.Controls.Add(Me.MethStepDataGrid)
        Me.MethStepSectionPanel.Location = New System.Drawing.Point(6, 6)
        Me.MethStepSectionPanel.Name = "MethStepSectionPanel"
        Me.MethStepSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethStepSectionPanel.ShowCaption = True
        Me.MethStepSectionPanel.Size = New System.Drawing.Size(800, 202)
        Me.MethStepSectionPanel.TabIndex = 6
        '
        'MethStepToolStrip
        '
        Me.MethStepToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethStepNewTSButton, Me.MethStepDeleteTSButton, Me.ToolStripSeparator4, Me.MethStepMoveUpTSButton, Me.MethStepMoveDownTSButton, Me.ToolStripSeparator2, Me.MethStepApplyTSButton, Me.MethStepUndoTSButton})
        Me.MethStepToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.MethStepToolStrip.Name = "MethStepToolStrip"
        Me.MethStepToolStrip.Size = New System.Drawing.Size(798, 25)
        Me.MethStepToolStrip.TabIndex = 5
        Me.MethStepToolStrip.Text = "ToolStrip1"
        '
        'MethStepNewTSButton
        '
        Me.MethStepNewTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.New16
        Me.MethStepNewTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepNewTSButton.Name = "MethStepNewTSButton"
        Me.MethStepNewTSButton.Size = New System.Drawing.Size(77, 22)
        Me.MethStepNewTSButton.Text = "New Step"
        '
        'MethStepDeleteTSButton
        '
        Me.MethStepDeleteTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MethStepDeleteTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepDeleteTSButton.Name = "MethStepDeleteTSButton"
        Me.MethStepDeleteTSButton.Size = New System.Drawing.Size(86, 22)
        Me.MethStepDeleteTSButton.Text = "Delete Step"
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(6, 25)
        '
        'MethStepMoveUpTSButton
        '
        Me.MethStepMoveUpTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.UpArrow16
        Me.MethStepMoveUpTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepMoveUpTSButton.Name = "MethStepMoveUpTSButton"
        Me.MethStepMoveUpTSButton.Size = New System.Drawing.Size(75, 22)
        Me.MethStepMoveUpTSButton.Text = "Move Up"
        '
        'MethStepMoveDownTSButton
        '
        Me.MethStepMoveDownTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DownArrow16
        Me.MethStepMoveDownTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepMoveDownTSButton.Name = "MethStepMoveDownTSButton"
        Me.MethStepMoveDownTSButton.Size = New System.Drawing.Size(91, 22)
        Me.MethStepMoveDownTSButton.Text = "Move Down"
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(6, 25)
        '
        'MethStepApplyTSButton
        '
        Me.MethStepApplyTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Save16
        Me.MethStepApplyTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepApplyTSButton.Name = "MethStepApplyTSButton"
        Me.MethStepApplyTSButton.Size = New System.Drawing.Size(107, 22)
        Me.MethStepApplyTSButton.Text = "Apply Changes"
        '
        'MethStepUndoTSButton
        '
        Me.MethStepUndoTSButton.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Undo16
        Me.MethStepUndoTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MethStepUndoTSButton.Name = "MethStepUndoTSButton"
        Me.MethStepUndoTSButton.Size = New System.Drawing.Size(105, 22)
        Me.MethStepUndoTSButton.Text = "Undo Changes"
        '
        'MethStepDataGrid
        '
        Me.MethStepDataGrid.AllowUserToAddRows = False
        Me.MethStepDataGrid.AllowUserToDeleteRows = False
        Me.MethStepDataGrid.AllowUserToResizeRows = False
        Me.MethStepDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethStepDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.MethStepDataGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.MethStepTypeTextBoxColumn, Me.MethStepTypeComboBoxColumn, Me.MethStepDaysSincePrevColumn, Me.MethStepCoverLetterColumn, Me.MethStepLanguageColumn, Me.MethStepIncludeWithPrevColumn, Me.MethStepExpirationDaysColumn, Me.MethStepExpireFromStepColumn})
        Me.MethStepDataGrid.ContextMenuStrip = Me.MethStepMenuStrip
        Me.MethStepDataGrid.EditMode = System.Windows.Forms.DataGridViewEditMode.EditOnEnter
        Me.MethStepDataGrid.Location = New System.Drawing.Point(1, 52)
        Me.MethStepDataGrid.MultiSelect = False
        Me.MethStepDataGrid.Name = "MethStepDataGrid"
        Me.MethStepDataGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.MethStepDataGrid.Size = New System.Drawing.Size(798, 149)
        Me.MethStepDataGrid.TabIndex = 2
        '
        'MethStepTypeTextBoxColumn
        '
        Me.MethStepTypeTextBoxColumn.HeaderText = "Step Type"
        Me.MethStepTypeTextBoxColumn.MaxInputLength = 20
        Me.MethStepTypeTextBoxColumn.MinimumWidth = 50
        Me.MethStepTypeTextBoxColumn.Name = "MethStepTypeTextBoxColumn"
        Me.MethStepTypeTextBoxColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        Me.MethStepTypeTextBoxColumn.Visible = False
        Me.MethStepTypeTextBoxColumn.Width = 170
        '
        'MethStepTypeComboBoxColumn
        '
        Me.MethStepTypeComboBoxColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethStepTypeComboBoxColumn.HeaderText = "Step Type"
        Me.MethStepTypeComboBoxColumn.MinimumWidth = 50
        Me.MethStepTypeComboBoxColumn.Name = "MethStepTypeComboBoxColumn"
        Me.MethStepTypeComboBoxColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethStepTypeComboBoxColumn.Width = 170
        '
        'MethStepDaysSincePrevColumn
        '
        Me.MethStepDaysSincePrevColumn.HeaderText = "Days Since Previous Step"
        Me.MethStepDaysSincePrevColumn.MaxInputLength = 2
        Me.MethStepDaysSincePrevColumn.MinimumWidth = 80
        Me.MethStepDaysSincePrevColumn.Name = "MethStepDaysSincePrevColumn"
        Me.MethStepDaysSincePrevColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethStepDaysSincePrevColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        Me.MethStepDaysSincePrevColumn.Width = 80
        '
        'MethStepCoverLetterColumn
        '
        Me.MethStepCoverLetterColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethStepCoverLetterColumn.HeaderText = "Cover Letter"
        Me.MethStepCoverLetterColumn.MinimumWidth = 50
        Me.MethStepCoverLetterColumn.Name = "MethStepCoverLetterColumn"
        Me.MethStepCoverLetterColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethStepCoverLetterColumn.Width = 150
        '
        'MethStepLanguageColumn
        '
        Me.MethStepLanguageColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethStepLanguageColumn.HeaderText = "Language"
        Me.MethStepLanguageColumn.MinimumWidth = 50
        Me.MethStepLanguageColumn.Name = "MethStepLanguageColumn"
        Me.MethStepLanguageColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        '
        'MethStepIncludeWithPrevColumn
        '
        Me.MethStepIncludeWithPrevColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethStepIncludeWithPrevColumn.HeaderText = "Include With Previous Step"
        Me.MethStepIncludeWithPrevColumn.MinimumWidth = 80
        Me.MethStepIncludeWithPrevColumn.Name = "MethStepIncludeWithPrevColumn"
        Me.MethStepIncludeWithPrevColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethStepIncludeWithPrevColumn.Width = 80
        '
        'MethStepExpirationDaysColumn
        '
        Me.MethStepExpirationDaysColumn.HeaderText = "Days Until Expiration"
        Me.MethStepExpirationDaysColumn.MaxInputLength = 3
        Me.MethStepExpirationDaysColumn.MinimumWidth = 50
        Me.MethStepExpirationDaysColumn.Name = "MethStepExpirationDaysColumn"
        Me.MethStepExpirationDaysColumn.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        Me.MethStepExpirationDaysColumn.Width = 80
        '
        'MethStepExpireFromStepColumn
        '
        Me.MethStepExpireFromStepColumn.DisplayStyle = System.Windows.Forms.DataGridViewComboBoxDisplayStyle.ComboBox
        Me.MethStepExpireFromStepColumn.HeaderText = "Expire From Step"
        Me.MethStepExpireFromStepColumn.MinimumWidth = 50
        Me.MethStepExpireFromStepColumn.Name = "MethStepExpireFromStepColumn"
        Me.MethStepExpireFromStepColumn.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.MethStepExpireFromStepColumn.Width = 120
        '
        'MethStepMenuStrip
        '
        Me.MethStepMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MethStepNewMenuItem, Me.MethStepDeleteMenuItem, Me.ToolStripSeparator9, Me.MethStepMoveUpMenuItem, Me.MethStepMoveDownMenuItem, Me.ToolStripSeparator10, Me.MethStepApplyMenuItem, Me.MethStepUndoMenuItem})
        Me.MethStepMenuStrip.Name = "MethStepMenuStrip"
        Me.MethStepMenuStrip.Size = New System.Drawing.Size(155, 148)
        '
        'MethStepNewMenuItem
        '
        Me.MethStepNewMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.New16
        Me.MethStepNewMenuItem.Name = "MethStepNewMenuItem"
        Me.MethStepNewMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepNewMenuItem.Text = "New Step"
        '
        'MethStepDeleteMenuItem
        '
        Me.MethStepDeleteMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MethStepDeleteMenuItem.Name = "MethStepDeleteMenuItem"
        Me.MethStepDeleteMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepDeleteMenuItem.Text = "Delete Step"
        '
        'ToolStripSeparator9
        '
        Me.ToolStripSeparator9.Name = "ToolStripSeparator9"
        Me.ToolStripSeparator9.Size = New System.Drawing.Size(151, 6)
        '
        'MethStepMoveUpMenuItem
        '
        Me.MethStepMoveUpMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.UpArrow16
        Me.MethStepMoveUpMenuItem.Name = "MethStepMoveUpMenuItem"
        Me.MethStepMoveUpMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepMoveUpMenuItem.Text = "Move Up"
        '
        'MethStepMoveDownMenuItem
        '
        Me.MethStepMoveDownMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.DownArrow16
        Me.MethStepMoveDownMenuItem.Name = "MethStepMoveDownMenuItem"
        Me.MethStepMoveDownMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepMoveDownMenuItem.Text = "Move Down"
        '
        'ToolStripSeparator10
        '
        Me.ToolStripSeparator10.Name = "ToolStripSeparator10"
        Me.ToolStripSeparator10.Size = New System.Drawing.Size(151, 6)
        '
        'MethStepApplyMenuItem
        '
        Me.MethStepApplyMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Save16
        Me.MethStepApplyMenuItem.Name = "MethStepApplyMenuItem"
        Me.MethStepApplyMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepApplyMenuItem.Text = "Apply Changes"
        '
        'MethStepUndoMenuItem
        '
        Me.MethStepUndoMenuItem.Image = Global.Nrc.QualiSys.ConfigurationManager.My.Resources.Resources.Undo16
        Me.MethStepUndoMenuItem.Name = "MethStepUndoMenuItem"
        Me.MethStepUndoMenuItem.Size = New System.Drawing.Size(154, 22)
        Me.MethStepUndoMenuItem.Text = "Undo Changes"
        '
        'MethPropsSectionPanel
        '
        Me.MethPropsSectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethPropsSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MethPropsSectionPanel.Caption = "Methodology Step Properties"
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsWebPanel)
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsIVRPanel)
        Me.MethPropsSectionPanel.Controls.Add(Me.MethodologyPropsPhonePanel)
        Me.MethPropsSectionPanel.Location = New System.Drawing.Point(6, 6)
        Me.MethPropsSectionPanel.Name = "MethPropsSectionPanel"
        Me.MethPropsSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethPropsSectionPanel.ShowCaption = True
        Me.MethPropsSectionPanel.Size = New System.Drawing.Size(801, 181)
        Me.MethPropsSectionPanel.TabIndex = 7
        '
        'MethodologyPropsWebPanel
        '
        Me.MethodologyPropsWebPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebEmailBlastGridControl)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebEmailBlastCheckBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebQuotasGroupBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebDaysInFieldLabel)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebAcceptPartialCheckBox)
        Me.MethodologyPropsWebPanel.Controls.Add(Me.WebDaysInFieldTextBox)
        Me.MethodologyPropsWebPanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsWebPanel.Name = "MethodologyPropsWebPanel"
        Me.MethodologyPropsWebPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsWebPanel.Size = New System.Drawing.Size(793, 150)
        Me.MethodologyPropsWebPanel.TabIndex = 10
        Me.MethodologyPropsWebPanel.Visible = False
        '
        'WebEmailBlastGridControl
        '
        Me.WebEmailBlastGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.WebEmailBlastGridControl.DataSource = Me.EmailBlastBindingSource
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.EndEdit.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.First.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Last.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Next.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.NextPage.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.Prev.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.Buttons.PrevPage.Visible = False
        Me.WebEmailBlastGridControl.EmbeddedNavigator.TextStringFormat = ""
        Me.WebEmailBlastGridControl.Enabled = False
        Me.WebEmailBlastGridControl.Location = New System.Drawing.Point(388, 35)
        Me.WebEmailBlastGridControl.MainView = Me.WebEmailBlastGridView
        Me.WebEmailBlastGridControl.Name = "WebEmailBlastGridControl"
        Me.WebEmailBlastGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.EmailBlastNameComboBox, Me.EmailBlastNameGridLookUpEdit, Me.DaysFromStepGenTextEdit, Me.EmailBlastNameLookUpEdit})
        Me.WebEmailBlastGridControl.Size = New System.Drawing.Size(401, 111)
        Me.WebEmailBlastGridControl.TabIndex = 15
        Me.WebEmailBlastGridControl.UseEmbeddedNavigator = True
        Me.WebEmailBlastGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.WebEmailBlastGridView})
        '
        'EmailBlastBindingSource
        '
        Me.EmailBlastBindingSource.AllowNew = True
        Me.EmailBlastBindingSource.DataSource = GetType(Nrc.QualiSys.Library.EmailBlast)
        '
        'WebEmailBlastGridView
        '
        Me.WebEmailBlastGridView.ActiveFilterEnabled = False
        Me.WebEmailBlastGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colEmailBlastId, Me.colDaysFromStepGen})
        Me.WebEmailBlastGridView.GridControl = Me.WebEmailBlastGridControl
        Me.WebEmailBlastGridView.Name = "WebEmailBlastGridView"
        Me.WebEmailBlastGridView.NewItemRowText = "Click Here to Add a New Email Blast Record"
        Me.WebEmailBlastGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.WebEmailBlastGridView.OptionsView.NewItemRowPosition = DevExpress.XtraGrid.Views.Grid.NewItemRowPosition.Top
        Me.WebEmailBlastGridView.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.WebEmailBlastGridView.OptionsView.ShowGroupPanel = False
        Me.WebEmailBlastGridView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colDaysFromStepGen, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colEmailBlastId
        '
        Me.colEmailBlastId.Caption = "Blast Name"
        Me.colEmailBlastId.ColumnEdit = Me.EmailBlastNameLookUpEdit
        Me.colEmailBlastId.FieldName = "EmailBlastId"
        Me.colEmailBlastId.Name = "colEmailBlastId"
        Me.colEmailBlastId.Visible = True
        Me.colEmailBlastId.VisibleIndex = 0
        '
        'EmailBlastNameLookUpEdit
        '
        Me.EmailBlastNameLookUpEdit.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.EmailBlastNameLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameLookUpEdit.DataSource = Me.EmailBlastOptionBindingSource
        Me.EmailBlastNameLookUpEdit.DisplayMember = "Value"
        Me.EmailBlastNameLookUpEdit.Name = "EmailBlastNameLookUpEdit"
        Me.EmailBlastNameLookUpEdit.NullText = ""
        Me.EmailBlastNameLookUpEdit.ValueMember = "EmailBlastId"
        '
        'EmailBlastOptionBindingSource
        '
        Me.EmailBlastOptionBindingSource.DataSource = GetType(Nrc.QualiSys.Library.EmailBlastOption)
        '
        'colDaysFromStepGen
        '
        Me.colDaysFromStepGen.Caption = "Days From Step Gen"
        Me.colDaysFromStepGen.ColumnEdit = Me.DaysFromStepGenTextEdit
        Me.colDaysFromStepGen.FieldName = "DaysFromStepGen"
        Me.colDaysFromStepGen.Name = "colDaysFromStepGen"
        Me.colDaysFromStepGen.SortMode = DevExpress.XtraGrid.ColumnSortMode.Value
        Me.colDaysFromStepGen.Visible = True
        Me.colDaysFromStepGen.VisibleIndex = 1
        '
        'DaysFromStepGenTextEdit
        '
        Me.DaysFromStepGenTextEdit.AutoHeight = False
        Me.DaysFromStepGenTextEdit.Mask.MaskType = DevExpress.XtraEditors.Mask.MaskType.Numeric
        Me.DaysFromStepGenTextEdit.Name = "DaysFromStepGenTextEdit"
        '
        'EmailBlastNameComboBox
        '
        Me.EmailBlastNameComboBox.AllowNullInput = DevExpress.Utils.DefaultBoolean.[False]
        Me.EmailBlastNameComboBox.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameComboBox.Name = "EmailBlastNameComboBox"
        '
        'EmailBlastNameGridLookUpEdit
        '
        Me.EmailBlastNameGridLookUpEdit.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.EmailBlastNameGridLookUpEdit.DataSource = Me.EmailBlastOptionBindingSource
        Me.EmailBlastNameGridLookUpEdit.DisplayMember = "Value"
        Me.EmailBlastNameGridLookUpEdit.Name = "EmailBlastNameGridLookUpEdit"
        Me.EmailBlastNameGridLookUpEdit.ValueMember = "EmailBlastId"
        Me.EmailBlastNameGridLookUpEdit.View = Me.RepositoryItemGridLookUpEdit1View
        '
        'RepositoryItemGridLookUpEdit1View
        '
        Me.RepositoryItemGridLookUpEdit1View.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.RepositoryItemGridLookUpEdit1View.Name = "RepositoryItemGridLookUpEdit1View"
        Me.RepositoryItemGridLookUpEdit1View.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.RepositoryItemGridLookUpEdit1View.OptionsView.ShowGroupPanel = False
        '
        'WebEmailBlastCheckBox
        '
        Me.WebEmailBlastCheckBox.AutoSize = True
        Me.WebEmailBlastCheckBox.Location = New System.Drawing.Point(388, 9)
        Me.WebEmailBlastCheckBox.Name = "WebEmailBlastCheckBox"
        Me.WebEmailBlastCheckBox.Size = New System.Drawing.Size(76, 17)
        Me.WebEmailBlastCheckBox.TabIndex = 4
        Me.WebEmailBlastCheckBox.Text = "Email Blast"
        Me.WebEmailBlastCheckBox.UseVisualStyleBackColor = True
        '
        'WebQuotasGroupBox
        '
        Me.WebQuotasGroupBox.Controls.Add(Me.WebReturnsLabel)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasStopReturnsTextBox)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasStopReturnsRadioButton)
        Me.WebQuotasGroupBox.Controls.Add(Me.WebQuotasAllReturnsRadioButton)
        Me.WebQuotasGroupBox.Location = New System.Drawing.Point(31, 57)
        Me.WebQuotasGroupBox.Name = "WebQuotasGroupBox"
        Me.WebQuotasGroupBox.Size = New System.Drawing.Size(304, 64)
        Me.WebQuotasGroupBox.TabIndex = 3
        Me.WebQuotasGroupBox.TabStop = False
        Me.WebQuotasGroupBox.Text = "Quotas"
        '
        'WebReturnsLabel
        '
        Me.WebReturnsLabel.AutoSize = True
        Me.WebReturnsLabel.Location = New System.Drawing.Point(176, 43)
        Me.WebReturnsLabel.Name = "WebReturnsLabel"
        Me.WebReturnsLabel.Size = New System.Drawing.Size(101, 13)
        Me.WebReturnsLabel.TabIndex = 3
        Me.WebReturnsLabel.Text = "Returns Per Sample"
        '
        'WebQuotasStopReturnsTextBox
        '
        Me.WebQuotasStopReturnsTextBox.Enabled = False
        Me.WebQuotasStopReturnsTextBox.Location = New System.Drawing.Point(130, 37)
        Me.WebQuotasStopReturnsTextBox.Name = "WebQuotasStopReturnsTextBox"
        Me.WebQuotasStopReturnsTextBox.Size = New System.Drawing.Size(43, 21)
        Me.WebQuotasStopReturnsTextBox.TabIndex = 2
        '
        'WebQuotasStopReturnsRadioButton
        '
        Me.WebQuotasStopReturnsRadioButton.AutoSize = True
        Me.WebQuotasStopReturnsRadioButton.Location = New System.Drawing.Point(20, 41)
        Me.WebQuotasStopReturnsRadioButton.Name = "WebQuotasStopReturnsRadioButton"
        Me.WebQuotasStopReturnsRadioButton.Size = New System.Drawing.Size(110, 17)
        Me.WebQuotasStopReturnsRadioButton.TabIndex = 1
        Me.WebQuotasStopReturnsRadioButton.Text = "Stop Collection At"
        Me.WebQuotasStopReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'WebQuotasAllReturnsRadioButton
        '
        Me.WebQuotasAllReturnsRadioButton.AutoSize = True
        Me.WebQuotasAllReturnsRadioButton.Checked = True
        Me.WebQuotasAllReturnsRadioButton.Location = New System.Drawing.Point(20, 20)
        Me.WebQuotasAllReturnsRadioButton.Name = "WebQuotasAllReturnsRadioButton"
        Me.WebQuotasAllReturnsRadioButton.Size = New System.Drawing.Size(113, 17)
        Me.WebQuotasAllReturnsRadioButton.TabIndex = 0
        Me.WebQuotasAllReturnsRadioButton.TabStop = True
        Me.WebQuotasAllReturnsRadioButton.Text = "Accept All Returns"
        Me.WebQuotasAllReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'WebDaysInFieldLabel
        '
        Me.WebDaysInFieldLabel.AutoSize = True
        Me.WebDaysInFieldLabel.Location = New System.Drawing.Point(29, 11)
        Me.WebDaysInFieldLabel.Name = "WebDaysInFieldLabel"
        Me.WebDaysInFieldLabel.Size = New System.Drawing.Size(69, 13)
        Me.WebDaysInFieldLabel.TabIndex = 2
        Me.WebDaysInFieldLabel.Text = "Days In Field"
        Me.WebDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'WebAcceptPartialCheckBox
        '
        Me.WebAcceptPartialCheckBox.AutoSize = True
        Me.WebAcceptPartialCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.WebAcceptPartialCheckBox.Location = New System.Drawing.Point(27, 35)
        Me.WebAcceptPartialCheckBox.Name = "WebAcceptPartialCheckBox"
        Me.WebAcceptPartialCheckBox.Size = New System.Drawing.Size(92, 17)
        Me.WebAcceptPartialCheckBox.TabIndex = 1
        Me.WebAcceptPartialCheckBox.Text = "Accept Partial"
        Me.WebAcceptPartialCheckBox.UseVisualStyleBackColor = True
        '
        'WebDaysInFieldTextBox
        '
        Me.WebDaysInFieldTextBox.Location = New System.Drawing.Point(104, 7)
        Me.WebDaysInFieldTextBox.Name = "WebDaysInFieldTextBox"
        Me.WebDaysInFieldTextBox.Size = New System.Drawing.Size(64, 21)
        Me.WebDaysInFieldTextBox.TabIndex = 0
        '
        'MethodologyPropsIVRPanel
        '
        Me.MethodologyPropsIVRPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRDaysInFieldLabel)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRAcceptPartialCheckBox)
        Me.MethodologyPropsIVRPanel.Controls.Add(Me.IVRDaysInFieldTextBox)
        Me.MethodologyPropsIVRPanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsIVRPanel.Name = "MethodologyPropsIVRPanel"
        Me.MethodologyPropsIVRPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsIVRPanel.Size = New System.Drawing.Size(793, 150)
        Me.MethodologyPropsIVRPanel.TabIndex = 7
        Me.MethodologyPropsIVRPanel.Visible = False
        '
        'IVRDaysInFieldLabel
        '
        Me.IVRDaysInFieldLabel.AutoSize = True
        Me.IVRDaysInFieldLabel.Location = New System.Drawing.Point(29, 15)
        Me.IVRDaysInFieldLabel.Name = "IVRDaysInFieldLabel"
        Me.IVRDaysInFieldLabel.Size = New System.Drawing.Size(69, 13)
        Me.IVRDaysInFieldLabel.TabIndex = 2
        Me.IVRDaysInFieldLabel.Text = "Days In Field"
        Me.IVRDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'IVRAcceptPartialCheckBox
        '
        Me.IVRAcceptPartialCheckBox.AutoSize = True
        Me.IVRAcceptPartialCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.IVRAcceptPartialCheckBox.Location = New System.Drawing.Point(27, 39)
        Me.IVRAcceptPartialCheckBox.Name = "IVRAcceptPartialCheckBox"
        Me.IVRAcceptPartialCheckBox.Size = New System.Drawing.Size(92, 17)
        Me.IVRAcceptPartialCheckBox.TabIndex = 1
        Me.IVRAcceptPartialCheckBox.Text = "Accept Partial"
        Me.IVRAcceptPartialCheckBox.UseVisualStyleBackColor = True
        '
        'IVRDaysInFieldTextBox
        '
        Me.IVRDaysInFieldTextBox.Location = New System.Drawing.Point(104, 11)
        Me.IVRDaysInFieldTextBox.Name = "IVRDaysInFieldTextBox"
        Me.IVRDaysInFieldTextBox.Size = New System.Drawing.Size(64, 21)
        Me.IVRDaysInFieldTextBox.TabIndex = 0
        '
        'MethodologyPropsPhonePanel
        '
        Me.MethodologyPropsPhonePanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningSunCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaySunCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningSatCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaySatCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneSundayLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneSaturdayLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneMFLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneEveningMFCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneNumberOfAttemptsLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneNumberOfAttemptsTextBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneTTYCallbackCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneLangCallbackCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneQuotasGroupBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaysInFieldLabel)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDayMFCheckBox)
        Me.MethodologyPropsPhonePanel.Controls.Add(Me.PhoneDaysInFieldTextBox)
        Me.MethodologyPropsPhonePanel.Location = New System.Drawing.Point(4, 27)
        Me.MethodologyPropsPhonePanel.Name = "MethodologyPropsPhonePanel"
        Me.MethodologyPropsPhonePanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MethodologyPropsPhonePanel.Size = New System.Drawing.Size(793, 150)
        Me.MethodologyPropsPhonePanel.TabIndex = 12
        Me.MethodologyPropsPhonePanel.Visible = False
        '
        'PhoneEveningSunCheckBox
        '
        Me.PhoneEveningSunCheckBox.AutoSize = True
        Me.PhoneEveningSunCheckBox.Location = New System.Drawing.Point(205, 97)
        Me.PhoneEveningSunCheckBox.Name = "PhoneEveningSunCheckBox"
        Me.PhoneEveningSunCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneEveningSunCheckBox.TabIndex = 7
        Me.PhoneEveningSunCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaySunCheckBox
        '
        Me.PhoneDaySunCheckBox.AutoSize = True
        Me.PhoneDaySunCheckBox.Location = New System.Drawing.Point(205, 78)
        Me.PhoneDaySunCheckBox.Name = "PhoneDaySunCheckBox"
        Me.PhoneDaySunCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneDaySunCheckBox.TabIndex = 4
        Me.PhoneDaySunCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneEveningSatCheckBox
        '
        Me.PhoneEveningSatCheckBox.AutoSize = True
        Me.PhoneEveningSatCheckBox.Location = New System.Drawing.Point(182, 97)
        Me.PhoneEveningSatCheckBox.Name = "PhoneEveningSatCheckBox"
        Me.PhoneEveningSatCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneEveningSatCheckBox.TabIndex = 6
        Me.PhoneEveningSatCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaySatCheckBox
        '
        Me.PhoneDaySatCheckBox.AutoSize = True
        Me.PhoneDaySatCheckBox.Location = New System.Drawing.Point(182, 78)
        Me.PhoneDaySatCheckBox.Name = "PhoneDaySatCheckBox"
        Me.PhoneDaySatCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.PhoneDaySatCheckBox.TabIndex = 3
        Me.PhoneDaySatCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneSundayLabel
        '
        Me.PhoneSundayLabel.AutoSize = True
        Me.PhoneSundayLabel.Location = New System.Drawing.Point(204, 62)
        Me.PhoneSundayLabel.Name = "PhoneSundayLabel"
        Me.PhoneSundayLabel.Size = New System.Drawing.Size(25, 13)
        Me.PhoneSundayLabel.TabIndex = 21
        Me.PhoneSundayLabel.Text = "Sun"
        '
        'PhoneSaturdayLabel
        '
        Me.PhoneSaturdayLabel.AutoSize = True
        Me.PhoneSaturdayLabel.Location = New System.Drawing.Point(181, 62)
        Me.PhoneSaturdayLabel.Name = "PhoneSaturdayLabel"
        Me.PhoneSaturdayLabel.Size = New System.Drawing.Size(23, 13)
        Me.PhoneSaturdayLabel.TabIndex = 20
        Me.PhoneSaturdayLabel.Text = "Sat"
        '
        'PhoneMFLabel
        '
        Me.PhoneMFLabel.AutoSize = True
        Me.PhoneMFLabel.Location = New System.Drawing.Point(148, 62)
        Me.PhoneMFLabel.Name = "PhoneMFLabel"
        Me.PhoneMFLabel.Size = New System.Drawing.Size(31, 13)
        Me.PhoneMFLabel.TabIndex = 19
        Me.PhoneMFLabel.Text = "M - F"
        '
        'PhoneEveningMFCheckBox
        '
        Me.PhoneEveningMFCheckBox.AutoSize = True
        Me.PhoneEveningMFCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.PhoneEveningMFCheckBox.Location = New System.Drawing.Point(9, 96)
        Me.PhoneEveningMFCheckBox.Name = "PhoneEveningMFCheckBox"
        Me.PhoneEveningMFCheckBox.Size = New System.Drawing.Size(163, 17)
        Me.PhoneEveningMFCheckBox.TabIndex = 5
        Me.PhoneEveningMFCheckBox.Text = "Evening (5:00 PM - 9:00 PM)"
        Me.PhoneEveningMFCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneNumberOfAttemptsLabel
        '
        Me.PhoneNumberOfAttemptsLabel.AutoSize = True
        Me.PhoneNumberOfAttemptsLabel.Location = New System.Drawing.Point(29, 38)
        Me.PhoneNumberOfAttemptsLabel.Name = "PhoneNumberOfAttemptsLabel"
        Me.PhoneNumberOfAttemptsLabel.Size = New System.Drawing.Size(106, 13)
        Me.PhoneNumberOfAttemptsLabel.TabIndex = 17
        Me.PhoneNumberOfAttemptsLabel.Text = "Number Of Attempts"
        Me.PhoneNumberOfAttemptsLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneNumberOfAttemptsTextBox
        '
        Me.PhoneNumberOfAttemptsTextBox.Location = New System.Drawing.Point(156, 33)
        Me.PhoneNumberOfAttemptsTextBox.Name = "PhoneNumberOfAttemptsTextBox"
        Me.PhoneNumberOfAttemptsTextBox.Size = New System.Drawing.Size(64, 21)
        Me.PhoneNumberOfAttemptsTextBox.TabIndex = 1
        '
        'PhoneTTYCallbackCheckBox
        '
        Me.PhoneTTYCallbackCheckBox.AutoSize = True
        Me.PhoneTTYCallbackCheckBox.Location = New System.Drawing.Point(308, 96)
        Me.PhoneTTYCallbackCheckBox.Name = "PhoneTTYCallbackCheckBox"
        Me.PhoneTTYCallbackCheckBox.Size = New System.Drawing.Size(208, 17)
        Me.PhoneTTYCallbackCheckBox.TabIndex = 10
        Me.PhoneTTYCallbackCheckBox.Text = "Callback Using TTY (Hearing Impaired)"
        Me.PhoneTTYCallbackCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneLangCallbackCheckBox
        '
        Me.PhoneLangCallbackCheckBox.AutoSize = True
        Me.PhoneLangCallbackCheckBox.Location = New System.Drawing.Point(308, 77)
        Me.PhoneLangCallbackCheckBox.Name = "PhoneLangCallbackCheckBox"
        Me.PhoneLangCallbackCheckBox.Size = New System.Drawing.Size(159, 17)
        Me.PhoneLangCallbackCheckBox.TabIndex = 9
        Me.PhoneLangCallbackCheckBox.Text = "Callback In Other Language"
        Me.PhoneLangCallbackCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneQuotasGroupBox
        '
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneReturnsLabel)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasStopReturnsTextBox)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasStopReturnsRadioButton)
        Me.PhoneQuotasGroupBox.Controls.Add(Me.PhoneQuotasAllReturnsRadioButton)
        Me.PhoneQuotasGroupBox.Location = New System.Drawing.Point(288, 3)
        Me.PhoneQuotasGroupBox.Name = "PhoneQuotasGroupBox"
        Me.PhoneQuotasGroupBox.Size = New System.Drawing.Size(304, 64)
        Me.PhoneQuotasGroupBox.TabIndex = 8
        Me.PhoneQuotasGroupBox.TabStop = False
        Me.PhoneQuotasGroupBox.Text = "Quotas"
        '
        'PhoneReturnsLabel
        '
        Me.PhoneReturnsLabel.AutoSize = True
        Me.PhoneReturnsLabel.Location = New System.Drawing.Point(176, 43)
        Me.PhoneReturnsLabel.Name = "PhoneReturnsLabel"
        Me.PhoneReturnsLabel.Size = New System.Drawing.Size(101, 13)
        Me.PhoneReturnsLabel.TabIndex = 3
        Me.PhoneReturnsLabel.Text = "Returns Per Sample"
        '
        'PhoneQuotasStopReturnsTextBox
        '
        Me.PhoneQuotasStopReturnsTextBox.Enabled = False
        Me.PhoneQuotasStopReturnsTextBox.Location = New System.Drawing.Point(130, 37)
        Me.PhoneQuotasStopReturnsTextBox.Name = "PhoneQuotasStopReturnsTextBox"
        Me.PhoneQuotasStopReturnsTextBox.Size = New System.Drawing.Size(43, 21)
        Me.PhoneQuotasStopReturnsTextBox.TabIndex = 2
        '
        'PhoneQuotasStopReturnsRadioButton
        '
        Me.PhoneQuotasStopReturnsRadioButton.AutoSize = True
        Me.PhoneQuotasStopReturnsRadioButton.Location = New System.Drawing.Point(20, 41)
        Me.PhoneQuotasStopReturnsRadioButton.Name = "PhoneQuotasStopReturnsRadioButton"
        Me.PhoneQuotasStopReturnsRadioButton.Size = New System.Drawing.Size(110, 17)
        Me.PhoneQuotasStopReturnsRadioButton.TabIndex = 1
        Me.PhoneQuotasStopReturnsRadioButton.Text = "Stop Collection At"
        Me.PhoneQuotasStopReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'PhoneQuotasAllReturnsRadioButton
        '
        Me.PhoneQuotasAllReturnsRadioButton.AutoSize = True
        Me.PhoneQuotasAllReturnsRadioButton.Checked = True
        Me.PhoneQuotasAllReturnsRadioButton.Location = New System.Drawing.Point(20, 20)
        Me.PhoneQuotasAllReturnsRadioButton.Name = "PhoneQuotasAllReturnsRadioButton"
        Me.PhoneQuotasAllReturnsRadioButton.Size = New System.Drawing.Size(113, 17)
        Me.PhoneQuotasAllReturnsRadioButton.TabIndex = 0
        Me.PhoneQuotasAllReturnsRadioButton.TabStop = True
        Me.PhoneQuotasAllReturnsRadioButton.Text = "Accept All Returns"
        Me.PhoneQuotasAllReturnsRadioButton.UseVisualStyleBackColor = True
        '
        'PhoneDaysInFieldLabel
        '
        Me.PhoneDaysInFieldLabel.AutoSize = True
        Me.PhoneDaysInFieldLabel.Location = New System.Drawing.Point(29, 11)
        Me.PhoneDaysInFieldLabel.Name = "PhoneDaysInFieldLabel"
        Me.PhoneDaysInFieldLabel.Size = New System.Drawing.Size(69, 13)
        Me.PhoneDaysInFieldLabel.TabIndex = 2
        Me.PhoneDaysInFieldLabel.Text = "Days In Field"
        Me.PhoneDaysInFieldLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PhoneDayMFCheckBox
        '
        Me.PhoneDayMFCheckBox.AutoSize = True
        Me.PhoneDayMFCheckBox.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.PhoneDayMFCheckBox.Location = New System.Drawing.Point(27, 77)
        Me.PhoneDayMFCheckBox.Name = "PhoneDayMFCheckBox"
        Me.PhoneDayMFCheckBox.Size = New System.Drawing.Size(145, 17)
        Me.PhoneDayMFCheckBox.TabIndex = 2
        Me.PhoneDayMFCheckBox.Text = "Day (9:00 AM - 5:00 PM)"
        Me.PhoneDayMFCheckBox.UseVisualStyleBackColor = True
        '
        'PhoneDaysInFieldTextBox
        '
        Me.PhoneDaysInFieldTextBox.Location = New System.Drawing.Point(156, 7)
        Me.PhoneDaysInFieldTextBox.Name = "PhoneDaysInFieldTextBox"
        Me.PhoneDaysInFieldTextBox.Size = New System.Drawing.Size(64, 21)
        Me.PhoneDaysInFieldTextBox.TabIndex = 0
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = "Information Bar"
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(814, 20)
        Me.InformationBar.TabIndex = 2
        '
        'MethPropsErrorProvider
        '
        Me.MethPropsErrorProvider.ContainerControl = Me
        '
        'WebBlastErrorProvider
        '
        Me.WebBlastErrorProvider.ContainerControl = Me
        '
        'MethodologyEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitContainer)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "MethodologyEditor"
        Me.Size = New System.Drawing.Size(814, 691)
        Me.BottomPanel.ResumeLayout(False)
        Me.SplitContainer.Panel1.ResumeLayout(False)
        Me.SplitContainer.Panel2.ResumeLayout(False)
        Me.SplitContainer.ResumeLayout(False)
        Me.MethSectionPanel.ResumeLayout(False)
        Me.MethSectionPanel.PerformLayout()
        Me.MethToolStrip.ResumeLayout(False)
        Me.MethToolStrip.PerformLayout()
        CType(Me.MethDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MethMenuStrip.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.MethStepSectionPanel.ResumeLayout(False)
        Me.MethStepSectionPanel.PerformLayout()
        Me.MethStepToolStrip.ResumeLayout(False)
        Me.MethStepToolStrip.PerformLayout()
        CType(Me.MethStepDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MethStepMenuStrip.ResumeLayout(False)
        Me.MethPropsSectionPanel.ResumeLayout(False)
        Me.MethodologyPropsWebPanel.ResumeLayout(False)
        Me.MethodologyPropsWebPanel.PerformLayout()
        CType(Me.WebEmailBlastGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.WebEmailBlastGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastOptionBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DaysFromStepGenTextEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameComboBox, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.EmailBlastNameGridLookUpEdit, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemGridLookUpEdit1View, System.ComponentModel.ISupportInitialize).EndInit()
        Me.WebQuotasGroupBox.ResumeLayout(False)
        Me.WebQuotasGroupBox.PerformLayout()
        Me.MethodologyPropsIVRPanel.ResumeLayout(False)
        Me.MethodologyPropsIVRPanel.PerformLayout()
        Me.MethodologyPropsPhonePanel.ResumeLayout(False)
        Me.MethodologyPropsPhonePanel.PerformLayout()
        Me.PhoneQuotasGroupBox.ResumeLayout(False)
        Me.PhoneQuotasGroupBox.PerformLayout()
        CType(Me.MethPropsErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.WebBlastErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents SplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents MethSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents MethToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MethNewTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethEditTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethActivateTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator5 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethUndoTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MethNewMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethDeleteMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator6 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethEditMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator7 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethActivateMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator8 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethUndoMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MethStepNewMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepDeleteMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepMoveUpMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepMoveDownMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepApplyMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MethStepUndoMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator9 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ToolStripSeparator10 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents MethStepSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethStepToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MethStepNewTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethStepMoveUpTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepMoveDownTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents MethStepApplyTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepUndoTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MethStepDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents MethPropsSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents MethodologyPropsIVRPanel As System.Windows.Forms.Panel
    Friend WithEvents IVRAcceptPartialCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents IVRDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents IVRDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents MethodologyPropsWebPanel As System.Windows.Forms.Panel
    Friend WithEvents WebDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents WebAcceptPartialCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents WebDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WebQuotasGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents WebQuotasStopReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents WebQuotasAllReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents WebReturnsLabel As System.Windows.Forms.Label
    Friend WithEvents WebQuotasStopReturnsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents WebEmailBlastGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents WebEmailBlastGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents WebEmailBlastCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents MethodologyPropsPhonePanel As System.Windows.Forms.Panel
    Friend WithEvents PhoneTTYCallbackCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneLangCallbackCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneQuotasGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents PhoneReturnsLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneQuotasStopReturnsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PhoneQuotasStopReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PhoneQuotasAllReturnsRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PhoneDaysInFieldLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneDayMFCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaysInFieldTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PhoneNumberOfAttemptsLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneNumberOfAttemptsTextBox As System.Windows.Forms.TextBox
    Friend WithEvents PhoneEveningMFCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneEveningSunCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaySunCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneEveningSatCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneDaySatCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PhoneSundayLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneSaturdayLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneMFLabel As System.Windows.Forms.Label
    Friend WithEvents MethPropsErrorProvider As System.Windows.Forms.ErrorProvider
    Friend WithEvents EmailBlastBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents EmailBlastOptionBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colEmailBlastId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDaysFromStepGen As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents EmailBlastNameComboBox As DevExpress.XtraEditors.Repository.RepositoryItemComboBox
    Friend WithEvents EmailBlastNameGridLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemGridLookUpEdit
    Friend WithEvents RepositoryItemGridLookUpEdit1View As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents DaysFromStepGenTextEdit As DevExpress.XtraEditors.Repository.RepositoryItemTextEdit
    Friend WithEvents EmailBlastNameLookUpEdit As DevExpress.XtraEditors.Repository.RepositoryItemLookUpEdit
    Friend WithEvents WebBlastErrorProvider As System.Windows.Forms.ErrorProvider
    Friend WithEvents MethStepTypeTextBoxColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MethStepTypeComboBoxColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethStepDaysSincePrevColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MethStepCoverLetterColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethStepLanguageColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethStepIncludeWithPrevColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethStepExpirationDaysColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MethStepExpireFromStepColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethActiveColumn As System.Windows.Forms.DataGridViewImageColumn
    Friend WithEvents MethNameColumn As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents MethTypeColumn As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MethCreatedColumn As System.Windows.Forms.DataGridViewTextBoxColumn

End Class
