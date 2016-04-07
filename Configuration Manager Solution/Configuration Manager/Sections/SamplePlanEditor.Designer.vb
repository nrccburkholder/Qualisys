<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SamplePlanEditor
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(SamplePlanEditor))
        Me.WorkTabControl = New System.Windows.Forms.TabControl()
        Me.PropertyTabPage = New System.Windows.Forms.TabPage()
        Me.PropertySplitContainer = New System.Windows.Forms.SplitContainer()
        Me.SampleUnitTreeView = New System.Windows.Forms.TreeView()
        Me.UnitTreeContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.AddUnitMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeleteUnitMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.PropertyCommandPanel = New System.Windows.Forms.Panel()
        Me.DeleteUnitButton = New System.Windows.Forms.Button()
        Me.AddUnitButton = New System.Windows.Forms.Button()
        Me.CAHPSTypeLabel = New System.Windows.Forms.Label()
        Me.CAHPSTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.RespRateTextBox = New System.Windows.Forms.TextBox()
        Me.RespRatePercentLabel = New System.Windows.Forms.Label()
        Me.InitRespRateNumeric = New System.Windows.Forms.NumericUpDown()
        Me.InitRespRatePercentLabel = New System.Windows.Forms.Label()
        Me.ApplyServiceLinkLabel = New System.Windows.Forms.LinkLabel()
        Me.FacilityComboBox = New System.Windows.Forms.ComboBox()
        Me.SampleUnitIdTextBox = New System.Windows.Forms.TextBox()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.ServiceSubtypeListBox = New System.Windows.Forms.CheckedListBox()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.ServiceTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.SampleUnitNameTextBox = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.TargetTypeLabel = New System.Windows.Forms.Label()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.SampleMethodTextBox = New System.Windows.Forms.TextBox()
        Me.PriorityTextBox = New System.Windows.Forms.TextBox()
        Me.DontSampleCheckBox = New System.Windows.Forms.CheckBox()
        Me.SampleSelectionTypeComboBox = New System.Windows.Forms.ComboBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.SuppressReportCheckBox = New System.Windows.Forms.CheckBox()
        Me.StateTextBox = New System.Windows.Forms.TextBox()
        Me.MedicareIdTextBox = New System.Windows.Forms.TextBox()
        Me.TargetReturnNumeric = New System.Windows.Forms.NumericUpDown()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.PriorityTabPage = New System.Windows.Forms.TabPage()
        Me.BottomPanel = New System.Windows.Forms.Panel()
        Me.ApplyButton = New System.Windows.Forms.Button()
        Me.OkButton = New System.Windows.Forms.Button()
        Me.CnclButton = New System.Windows.Forms.Button()
        Me.responseRateNumericUpDownR = New System.Windows.Forms.NumericUpDown()
        Me.toolTip = New System.Windows.Forms.ToolTip(Me.components)
        Me.ToolStripButton1 = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripButton2 = New System.Windows.Forms.ToolStripButton()
        Me.ToolStripButton3 = New System.Windows.Forms.ToolStripButton()
        Me.LowVolumeUnitCheckBox = New System.Windows.Forms.CheckBox()
        Me.CriteriaEditorControl = New Nrc.Qualisys.ConfigurationManager.CriteriaEditor()
        Me.UnitPrioritizer = New Nrc.Qualisys.ConfigurationManager.SampleUnitPrioritizer()
        Me.InformationBar = New Nrc.Qualisys.ConfigurationManager.InformationBar()
        Me.SchedulerControl = New Nrc.Qualisys.ConfigurationManager.Scheduler()
        Me.WorkTabControl.SuspendLayout()
        Me.PropertyTabPage.SuspendLayout()
        Me.PropertySplitContainer.Panel1.SuspendLayout()
        Me.PropertySplitContainer.Panel2.SuspendLayout()
        Me.PropertySplitContainer.SuspendLayout()
        Me.UnitTreeContextMenu.SuspendLayout()
        Me.PropertyCommandPanel.SuspendLayout()
        CType(Me.InitRespRateNumeric, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.TargetReturnNumeric, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.PriorityTabPage.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        CType(Me.responseRateNumericUpDownR, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'WorkTabControl
        '
        Me.WorkTabControl.Controls.Add(Me.PropertyTabPage)
        Me.WorkTabControl.Controls.Add(Me.PriorityTabPage)
        Me.WorkTabControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.WorkTabControl.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.WorkTabControl.Location = New System.Drawing.Point(0, 0)
        Me.WorkTabControl.Name = "WorkTabControl"
        Me.WorkTabControl.SelectedIndex = 0
        Me.WorkTabControl.Size = New System.Drawing.Size(1070, 575)
        Me.WorkTabControl.TabIndex = 0
        '
        'PropertyTabPage
        '
        Me.PropertyTabPage.Controls.Add(Me.PropertySplitContainer)
        Me.PropertyTabPage.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PropertyTabPage.Location = New System.Drawing.Point(4, 22)
        Me.PropertyTabPage.Name = "PropertyTabPage"
        Me.PropertyTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.PropertyTabPage.Size = New System.Drawing.Size(1062, 549)
        Me.PropertyTabPage.TabIndex = 0
        Me.PropertyTabPage.Text = "Properties"
        Me.PropertyTabPage.UseVisualStyleBackColor = True
        '
        'PropertySplitContainer
        '
        Me.PropertySplitContainer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PropertySplitContainer.Location = New System.Drawing.Point(3, 3)
        Me.PropertySplitContainer.Margin = New System.Windows.Forms.Padding(0)
        Me.PropertySplitContainer.Name = "PropertySplitContainer"
        '
        'PropertySplitContainer.Panel1
        '
        Me.PropertySplitContainer.Panel1.Controls.Add(Me.SampleUnitTreeView)
        Me.PropertySplitContainer.Panel1.Controls.Add(Me.PropertyCommandPanel)
        '
        'PropertySplitContainer.Panel2
        '
        Me.PropertySplitContainer.Panel2.AutoScroll = True
        Me.PropertySplitContainer.Panel2.AutoScrollMinSize = New System.Drawing.Size(575, 490)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.LowVolumeUnitCheckBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.CAHPSTypeLabel)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.CAHPSTypeComboBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.RespRateTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.RespRatePercentLabel)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.InitRespRateNumeric)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.InitRespRatePercentLabel)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.ApplyServiceLinkLabel)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.CriteriaEditorControl)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.FacilityComboBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.SampleUnitIdTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label13)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.ServiceSubtypeListBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label11)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.ServiceTypeComboBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label4)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label2)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.SampleUnitNameTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label1)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.TargetTypeLabel)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label12)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label3)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.SampleMethodTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.PriorityTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.DontSampleCheckBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.SampleSelectionTypeComboBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label5)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.SuppressReportCheckBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.StateTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.MedicareIdTextBox)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.TargetReturnNumeric)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label10)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label9)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label7)
        Me.PropertySplitContainer.Panel2.Controls.Add(Me.Label8)
        Me.PropertySplitContainer.Size = New System.Drawing.Size(1056, 543)
        Me.PropertySplitContainer.SplitterDistance = 271
        Me.PropertySplitContainer.TabIndex = 28
        '
        'SampleUnitTreeView
        '
        Me.SampleUnitTreeView.ContextMenuStrip = Me.UnitTreeContextMenu
        Me.SampleUnitTreeView.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SampleUnitTreeView.HideSelection = False
        Me.SampleUnitTreeView.Location = New System.Drawing.Point(0, 0)
        Me.SampleUnitTreeView.Name = "SampleUnitTreeView"
        Me.SampleUnitTreeView.Size = New System.Drawing.Size(271, 510)
        Me.SampleUnitTreeView.TabIndex = 0
        '
        'UnitTreeContextMenu
        '
        Me.UnitTreeContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddUnitMenuItem, Me.DeleteUnitMenuItem})
        Me.UnitTreeContextMenu.Name = "UnitTreeContextMenu"
        Me.UnitTreeContextMenu.Size = New System.Drawing.Size(175, 48)
        '
        'AddUnitMenuItem
        '
        Me.AddUnitMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.New16
        Me.AddUnitMenuItem.Name = "AddUnitMenuItem"
        Me.AddUnitMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.AddUnitMenuItem.Text = "New Sample Unit"
        '
        'DeleteUnitMenuItem
        '
        Me.DeleteUnitMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.DeleteUnitMenuItem.Name = "DeleteUnitMenuItem"
        Me.DeleteUnitMenuItem.Size = New System.Drawing.Size(174, 22)
        Me.DeleteUnitMenuItem.Text = "Delete Sample Unit"
        '
        'PropertyCommandPanel
        '
        Me.PropertyCommandPanel.Controls.Add(Me.DeleteUnitButton)
        Me.PropertyCommandPanel.Controls.Add(Me.AddUnitButton)
        Me.PropertyCommandPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.PropertyCommandPanel.Location = New System.Drawing.Point(0, 510)
        Me.PropertyCommandPanel.Name = "PropertyCommandPanel"
        Me.PropertyCommandPanel.Size = New System.Drawing.Size(271, 33)
        Me.PropertyCommandPanel.TabIndex = 1
        '
        'DeleteUnitButton
        '
        Me.DeleteUnitButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DeleteUnitButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.DeleteUnitButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.DeleteUnitButton.Location = New System.Drawing.Point(209, 5)
        Me.DeleteUnitButton.Name = "DeleteUnitButton"
        Me.DeleteUnitButton.Size = New System.Drawing.Size(61, 23)
        Me.DeleteUnitButton.TabIndex = 1
        Me.DeleteUnitButton.Text = "Delete"
        Me.DeleteUnitButton.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.toolTip.SetToolTip(Me.DeleteUnitButton, "Delete selected sample unit")
        Me.DeleteUnitButton.UseVisualStyleBackColor = True
        '
        'AddUnitButton
        '
        Me.AddUnitButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AddUnitButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.New16
        Me.AddUnitButton.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.AddUnitButton.Location = New System.Drawing.Point(150, 5)
        Me.AddUnitButton.Name = "AddUnitButton"
        Me.AddUnitButton.Size = New System.Drawing.Size(53, 23)
        Me.AddUnitButton.TabIndex = 0
        Me.AddUnitButton.Text = "New"
        Me.AddUnitButton.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.toolTip.SetToolTip(Me.AddUnitButton, "Create a new sample unit")
        Me.AddUnitButton.UseVisualStyleBackColor = True
        '
        'CAHPSTypeLabel
        '
        Me.CAHPSTypeLabel.AutoSize = True
        Me.CAHPSTypeLabel.Location = New System.Drawing.Point(5, 136)
        Me.CAHPSTypeLabel.Name = "CAHPSTypeLabel"
        Me.CAHPSTypeLabel.Size = New System.Drawing.Size(73, 13)
        Me.CAHPSTypeLabel.TabIndex = 35
        Me.CAHPSTypeLabel.Text = "CAHPS Type:"
        '
        'CAHPSTypeComboBox
        '
        Me.CAHPSTypeComboBox.DisplayMember = "Label"
        Me.CAHPSTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.CAHPSTypeComboBox.FormattingEnabled = True
        Me.CAHPSTypeComboBox.Location = New System.Drawing.Point(124, 133)
        Me.CAHPSTypeComboBox.Name = "CAHPSTypeComboBox"
        Me.CAHPSTypeComboBox.Size = New System.Drawing.Size(142, 21)
        Me.CAHPSTypeComboBox.TabIndex = 10
        Me.CAHPSTypeComboBox.ValueMember = "Value"
        '
        'RespRateTextBox
        '
        Me.RespRateTextBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RespRateTextBox.Location = New System.Drawing.Point(124, 213)
        Me.RespRateTextBox.Name = "RespRateTextBox"
        Me.RespRateTextBox.ReadOnly = True
        Me.RespRateTextBox.Size = New System.Drawing.Size(64, 20)
        Me.RespRateTextBox.TabIndex = 16
        Me.RespRateTextBox.TabStop = False
        '
        'RespRatePercentLabel
        '
        Me.RespRatePercentLabel.AutoSize = True
        Me.RespRatePercentLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.RespRatePercentLabel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.RespRatePercentLabel.Location = New System.Drawing.Point(189, 216)
        Me.RespRatePercentLabel.Name = "RespRatePercentLabel"
        Me.RespRatePercentLabel.Size = New System.Drawing.Size(15, 13)
        Me.RespRatePercentLabel.TabIndex = 17
        Me.RespRatePercentLabel.Text = "%"
        '
        'InitRespRateNumeric
        '
        Me.InitRespRateNumeric.BackColor = System.Drawing.SystemColors.Window
        Me.InitRespRateNumeric.Location = New System.Drawing.Point(124, 187)
        Me.InitRespRateNumeric.Name = "InitRespRateNumeric"
        Me.InitRespRateNumeric.Size = New System.Drawing.Size(64, 20)
        Me.InitRespRateNumeric.TabIndex = 13
        '
        'InitRespRatePercentLabel
        '
        Me.InitRespRatePercentLabel.AutoSize = True
        Me.InitRespRatePercentLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.InitRespRatePercentLabel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.InitRespRatePercentLabel.Location = New System.Drawing.Point(189, 189)
        Me.InitRespRatePercentLabel.Name = "InitRespRatePercentLabel"
        Me.InitRespRatePercentLabel.Size = New System.Drawing.Size(15, 13)
        Me.InitRespRatePercentLabel.TabIndex = 14
        Me.InitRespRatePercentLabel.Text = "%"
        '
        'ApplyServiceLinkLabel
        '
        Me.ApplyServiceLinkLabel.AutoSize = True
        Me.ApplyServiceLinkLabel.Location = New System.Drawing.Point(507, 232)
        Me.ApplyServiceLinkLabel.Name = "ApplyServiceLinkLabel"
        Me.ApplyServiceLinkLabel.Size = New System.Drawing.Size(133, 13)
        Me.ApplyServiceLinkLabel.TabIndex = 32
        Me.ApplyServiceLinkLabel.TabStop = True
        Me.ApplyServiceLinkLabel.Text = "Apply to Descendant Units"
        Me.toolTip.SetToolTip(Me.ApplyServiceLinkLabel, "Apply the service type and subtypes that you are using\nfor this sample unit to a" & _
        "ll the  descendant sample units")
        Me.ApplyServiceLinkLabel.VisitedLinkColor = System.Drawing.Color.Blue
        '
        'FacilityComboBox
        '
        Me.FacilityComboBox.DisplayMember = "DisplayLabel"
        Me.FacilityComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.FacilityComboBox.FormattingEnabled = True
        Me.FacilityComboBox.Location = New System.Drawing.Point(124, 54)
        Me.FacilityComboBox.Name = "FacilityComboBox"
        Me.FacilityComboBox.Size = New System.Drawing.Size(346, 21)
        Me.FacilityComboBox.TabIndex = 5
        Me.FacilityComboBox.ValueMember = "Id"
        '
        'SampleUnitIdTextBox
        '
        Me.SampleUnitIdTextBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SampleUnitIdTextBox.Location = New System.Drawing.Point(594, 1)
        Me.SampleUnitIdTextBox.Name = "SampleUnitIdTextBox"
        Me.SampleUnitIdTextBox.ReadOnly = True
        Me.SampleUnitIdTextBox.Size = New System.Drawing.Size(64, 20)
        Me.SampleUnitIdTextBox.TabIndex = 21
        Me.SampleUnitIdTextBox.TabStop = False
        '
        'Label13
        '
        Me.Label13.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label13.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label13.Location = New System.Drawing.Point(501, 4)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(101, 13)
        Me.Label13.TabIndex = 20
        Me.Label13.Text = "Sample Unit ID:"
        '
        'ServiceSubtypeListBox
        '
        Me.ServiceSubtypeListBox.CheckOnClick = True
        Me.ServiceSubtypeListBox.FormattingEnabled = True
        Me.ServiceSubtypeListBox.Location = New System.Drawing.Point(594, 126)
        Me.ServiceSubtypeListBox.Name = "ServiceSubtypeListBox"
        Me.ServiceSubtypeListBox.Size = New System.Drawing.Size(160, 94)
        Me.ServiceSubtypeListBox.TabIndex = 31
        '
        'Label11
        '
        Me.Label11.Location = New System.Drawing.Point(501, 129)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(101, 13)
        Me.Label11.TabIndex = 30
        Me.Label11.Text = "Service Subtypes:"
        '
        'ServiceTypeComboBox
        '
        Me.ServiceTypeComboBox.DisplayMember = "DisplayLabel"
        Me.ServiceTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ServiceTypeComboBox.FormattingEnabled = True
        Me.ServiceTypeComboBox.Location = New System.Drawing.Point(594, 86)
        Me.ServiceTypeComboBox.Name = "ServiceTypeComboBox"
        Me.ServiceTypeComboBox.Size = New System.Drawing.Size(160, 21)
        Me.ServiceTypeComboBox.TabIndex = 29
        Me.ServiceTypeComboBox.ValueMember = "Value"
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(501, 89)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(101, 13)
        Me.Label4.TabIndex = 28
        Me.Label4.Text = "Service Type:"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(5, 57)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(113, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Facility Name:"
        '
        'SampleUnitNameTextBox
        '
        Me.SampleUnitNameTextBox.BackColor = System.Drawing.SystemColors.Window
        Me.SampleUnitNameTextBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SampleUnitNameTextBox.Location = New System.Drawing.Point(124, 1)
        Me.SampleUnitNameTextBox.MaxLength = 42
        Me.SampleUnitNameTextBox.Name = "SampleUnitNameTextBox"
        Me.SampleUnitNameTextBox.Size = New System.Drawing.Size(346, 20)
        Me.SampleUnitNameTextBox.TabIndex = 1
        Me.SampleUnitNameTextBox.Text = "Sample Name"
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(5, 4)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(113, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Sample Unit Name:"
        '
        'TargetTypeLabel
        '
        Me.TargetTypeLabel.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TargetTypeLabel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.TargetTypeLabel.Location = New System.Drawing.Point(5, 163)
        Me.TargetTypeLabel.Name = "TargetTypeLabel"
        Me.TargetTypeLabel.Size = New System.Drawing.Size(113, 13)
        Me.TargetTypeLabel.TabIndex = 10
        Me.TargetTypeLabel.Text = "Target Return:"
        '
        'Label12
        '
        Me.Label12.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label12.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label12.Location = New System.Drawing.Point(5, 216)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(113, 13)
        Me.Label12.TabIndex = 15
        Me.Label12.Text = "Response Rate:"
        '
        'Label3
        '
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(5, 189)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(113, 13)
        Me.Label3.TabIndex = 12
        Me.Label3.Text = "Initial Response Rate:"
        '
        'SampleMethodTextBox
        '
        Me.SampleMethodTextBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SampleMethodTextBox.Location = New System.Drawing.Point(594, 53)
        Me.SampleMethodTextBox.Name = "SampleMethodTextBox"
        Me.SampleMethodTextBox.ReadOnly = True
        Me.SampleMethodTextBox.Size = New System.Drawing.Size(160, 20)
        Me.SampleMethodTextBox.TabIndex = 25
        Me.SampleMethodTextBox.TabStop = False
        '
        'PriorityTextBox
        '
        Me.PriorityTextBox.Location = New System.Drawing.Point(594, 27)
        Me.PriorityTextBox.Name = "PriorityTextBox"
        Me.PriorityTextBox.ReadOnly = True
        Me.PriorityTextBox.Size = New System.Drawing.Size(64, 20)
        Me.PriorityTextBox.TabIndex = 23
        Me.PriorityTextBox.TabStop = False
        '
        'DontSampleCheckBox
        '
        Me.DontSampleCheckBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DontSampleCheckBox.Location = New System.Drawing.Point(153, 239)
        Me.DontSampleCheckBox.Name = "DontSampleCheckBox"
        Me.DontSampleCheckBox.Size = New System.Drawing.Size(91, 17)
        Me.DontSampleCheckBox.TabIndex = 18
        Me.DontSampleCheckBox.Text = "Don't Sample"
        Me.DontSampleCheckBox.TextAlign = System.Drawing.ContentAlignment.TopLeft
        Me.DontSampleCheckBox.UseVisualStyleBackColor = True
        '
        'SampleSelectionTypeComboBox
        '
        Me.SampleSelectionTypeComboBox.DisplayMember = "Label"
        Me.SampleSelectionTypeComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.SampleSelectionTypeComboBox.FormattingEnabled = True
        Me.SampleSelectionTypeComboBox.Location = New System.Drawing.Point(124, 27)
        Me.SampleSelectionTypeComboBox.Name = "SampleSelectionTypeComboBox"
        Me.SampleSelectionTypeComboBox.Size = New System.Drawing.Size(346, 21)
        Me.SampleSelectionTypeComboBox.TabIndex = 3
        Me.SampleSelectionTypeComboBox.ValueMember = "Value"
        '
        'Label5
        '
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(501, 56)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(101, 13)
        Me.Label5.TabIndex = 24
        Me.Label5.Text = "Sample Method:"
        '
        'SuppressReportCheckBox
        '
        Me.SuppressReportCheckBox.AutoSize = True
        Me.SuppressReportCheckBox.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SuppressReportCheckBox.Location = New System.Drawing.Point(281, 239)
        Me.SuppressReportCheckBox.Name = "SuppressReportCheckBox"
        Me.SuppressReportCheckBox.Size = New System.Drawing.Size(127, 17)
        Me.SuppressReportCheckBox.TabIndex = 19
        Me.SuppressReportCheckBox.Text = "Suppress in eReports"
        Me.SuppressReportCheckBox.UseVisualStyleBackColor = True
        '
        'StateTextBox
        '
        Me.StateTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.StateTextBox.Location = New System.Drawing.Point(124, 82)
        Me.StateTextBox.Name = "StateTextBox"
        Me.StateTextBox.ReadOnly = True
        Me.StateTextBox.Size = New System.Drawing.Size(64, 20)
        Me.StateTextBox.TabIndex = 9
        Me.StateTextBox.TabStop = False
        '
        'MedicareIdTextBox
        '
        Me.MedicareIdTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.MedicareIdTextBox.Location = New System.Drawing.Point(124, 107)
        Me.MedicareIdTextBox.MaxLength = 20
        Me.MedicareIdTextBox.Name = "MedicareIdTextBox"
        Me.MedicareIdTextBox.ReadOnly = True
        Me.MedicareIdTextBox.Size = New System.Drawing.Size(142, 20)
        Me.MedicareIdTextBox.TabIndex = 9
        Me.MedicareIdTextBox.TabStop = False
        '
        'TargetReturnNumeric
        '
        Me.TargetReturnNumeric.Location = New System.Drawing.Point(124, 161)
        Me.TargetReturnNumeric.Maximum = New Decimal(New Integer() {999999, 0, 0, 0})
        Me.TargetReturnNumeric.Name = "TargetReturnNumeric"
        Me.TargetReturnNumeric.Size = New System.Drawing.Size(64, 20)
        Me.TargetReturnNumeric.TabIndex = 11
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(501, 30)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(101, 13)
        Me.Label10.TabIndex = 22
        Me.Label10.Text = "Priority:"
        '
        'Label9
        '
        Me.Label9.Location = New System.Drawing.Point(5, 30)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(120, 13)
        Me.Label9.TabIndex = 2
        Me.Label9.Text = "Sample Selection Type:"
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(5, 110)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(113, 13)
        Me.Label7.TabIndex = 8
        Me.Label7.Text = "CCN:"
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(5, 82)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(101, 13)
        Me.Label8.TabIndex = 26
        Me.Label8.Text = "State:"
        '
        'PriorityTabPage
        '
        Me.PriorityTabPage.Controls.Add(Me.UnitPrioritizer)
        Me.PriorityTabPage.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PriorityTabPage.Location = New System.Drawing.Point(4, 22)
        Me.PriorityTabPage.Margin = New System.Windows.Forms.Padding(0)
        Me.PriorityTabPage.Name = "PriorityTabPage"
        Me.PriorityTabPage.Padding = New System.Windows.Forms.Padding(0, 3, 0, 3)
        Me.PriorityTabPage.Size = New System.Drawing.Size(1062, 549)
        Me.PriorityTabPage.TabIndex = 1
        Me.PriorityTabPage.Text = "Priority Setup"
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.ApplyButton)
        Me.BottomPanel.Controls.Add(Me.OkButton)
        Me.BottomPanel.Controls.Add(Me.CnclButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(0, 575)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(1070, 35)
        Me.BottomPanel.TabIndex = 1
        '
        'ApplyButton
        '
        Me.ApplyButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplyButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.ApplyButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ApplyButton.Location = New System.Drawing.Point(794, 5)
        Me.ApplyButton.Name = "ApplyButton"
        Me.ApplyButton.Size = New System.Drawing.Size(75, 23)
        Me.ApplyButton.TabIndex = 0
        Me.ApplyButton.Text = "Apply"
        Me.ApplyButton.UseVisualStyleBackColor = True
        '
        'OkButton
        '
        Me.OkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OkButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.OkButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.OkButton.Location = New System.Drawing.Point(907, 5)
        Me.OkButton.Name = "OkButton"
        Me.OkButton.Size = New System.Drawing.Size(75, 23)
        Me.OkButton.TabIndex = 1
        Me.OkButton.Text = "OK"
        Me.OkButton.UseVisualStyleBackColor = True
        '
        'CnclButton
        '
        Me.CnclButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CnclButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.CnclButton.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CnclButton.Location = New System.Drawing.Point(988, 5)
        Me.CnclButton.Name = "CnclButton"
        Me.CnclButton.Size = New System.Drawing.Size(75, 23)
        Me.CnclButton.TabIndex = 2
        Me.CnclButton.Text = "Cancel"
        Me.CnclButton.UseVisualStyleBackColor = True
        '
        'responseRateNumericUpDownR
        '
        Me.responseRateNumericUpDownR.Location = New System.Drawing.Point(143, 139)
        Me.responseRateNumericUpDownR.Name = "responseRateNumericUpDownR"
        Me.responseRateNumericUpDownR.Size = New System.Drawing.Size(64, 20)
        Me.responseRateNumericUpDownR.TabIndex = 26
        '
        'ToolStripButton1
        '
        Me.ToolStripButton1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ToolStripButton1.Image = CType(resources.GetObject("ToolStripButton1.Image"), System.Drawing.Image)
        Me.ToolStripButton1.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ToolStripButton1.Name = "ToolStripButton1"
        Me.ToolStripButton1.Size = New System.Drawing.Size(23, 22)
        Me.ToolStripButton1.Text = "Add Unit"
        '
        'ToolStripButton2
        '
        Me.ToolStripButton2.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ToolStripButton2.Image = CType(resources.GetObject("ToolStripButton2.Image"), System.Drawing.Image)
        Me.ToolStripButton2.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ToolStripButton2.Name = "ToolStripButton2"
        Me.ToolStripButton2.Size = New System.Drawing.Size(23, 22)
        Me.ToolStripButton2.Text = "Edit Unit"
        '
        'ToolStripButton3
        '
        Me.ToolStripButton3.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ToolStripButton3.Image = CType(resources.GetObject("ToolStripButton3.Image"), System.Drawing.Image)
        Me.ToolStripButton3.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ToolStripButton3.Name = "ToolStripButton3"
        Me.ToolStripButton3.Size = New System.Drawing.Size(23, 22)
        Me.ToolStripButton3.Text = "Delete Unit"
        '
        'LowVolumeUnitCheckBox
        '
        Me.LowVolumeUnitCheckBox.AutoSize = True
        Me.LowVolumeUnitCheckBox.Location = New System.Drawing.Point(8, 239)
        Me.LowVolumeUnitCheckBox.Name = "LowVolumeUnitCheckBox"
        Me.LowVolumeUnitCheckBox.Size = New System.Drawing.Size(106, 17)
        Me.LowVolumeUnitCheckBox.TabIndex = 14
        Me.LowVolumeUnitCheckBox.Text = "Low Volume Unit"
        Me.LowVolumeUnitCheckBox.UseVisualStyleBackColor = True
        '
        'CriteriaEditorControl
        '
        Me.CriteriaEditorControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CriteriaEditorControl.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.CriteriaEditorControl.CriteriaStmt = Nothing
        Me.CriteriaEditorControl.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CriteriaEditorControl.Location = New System.Drawing.Point(8, 257)
        Me.CriteriaEditorControl.Name = "CriteriaEditorControl"
        Me.CriteriaEditorControl.ShowCriteriaStatement = True
        Me.CriteriaEditorControl.ShowRuleName = False
        Me.CriteriaEditorControl.Size = New System.Drawing.Size(770, 286)
        Me.CriteriaEditorControl.TabIndex = 33
        '
        'UnitPrioritizer
        '
        Me.UnitPrioritizer.BackColor = System.Drawing.Color.Transparent
        Me.UnitPrioritizer.Dock = System.Windows.Forms.DockStyle.Fill
        Me.UnitPrioritizer.Enable = True
        Me.UnitPrioritizer.Location = New System.Drawing.Point(0, 3)
        Me.UnitPrioritizer.Margin = New System.Windows.Forms.Padding(0)
        Me.UnitPrioritizer.Name = "UnitPrioritizer"
        Me.UnitPrioritizer.SampleUnits = Nothing
        Me.UnitPrioritizer.Size = New System.Drawing.Size(1062, 543)
        Me.UnitPrioritizer.TabIndex = 0
        Me.UnitPrioritizer.ViewMode = Nrc.Qualisys.ConfigurationManager.SampleUnitPrioritizer.DataViewMode.TreeAndList
        '
        'InformationBar
        '
        Me.InformationBar.BackColor = System.Drawing.SystemColors.Info
        Me.InformationBar.Dock = System.Windows.Forms.DockStyle.Top
        Me.InformationBar.Information = ""
        Me.InformationBar.Location = New System.Drawing.Point(0, 0)
        Me.InformationBar.Name = "InformationBar"
        Me.InformationBar.Padding = New System.Windows.Forms.Padding(1)
        Me.InformationBar.Size = New System.Drawing.Size(907, 20)
        Me.InformationBar.TabIndex = 5
        '
        'SamplePlanEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.WorkTabControl)
        Me.Controls.Add(Me.BottomPanel)
        Me.Controls.Add(Me.InformationBar)
        Me.Name = "SamplePlanEditor"
        Me.Size = New System.Drawing.Size(1070, 610)
        Me.WorkTabControl.ResumeLayout(False)
        Me.PropertyTabPage.ResumeLayout(False)
        Me.PropertySplitContainer.Panel1.ResumeLayout(False)
        Me.PropertySplitContainer.Panel2.ResumeLayout(False)
        Me.PropertySplitContainer.Panel2.PerformLayout()
        Me.PropertySplitContainer.ResumeLayout(False)
        Me.UnitTreeContextMenu.ResumeLayout(False)
        Me.PropertyCommandPanel.ResumeLayout(False)
        CType(Me.InitRespRateNumeric, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.TargetReturnNumeric, System.ComponentModel.ISupportInitialize).EndInit()
        Me.PriorityTabPage.ResumeLayout(False)
        Me.BottomPanel.ResumeLayout(False)
        CType(Me.responseRateNumericUpDownR, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents OkButton As System.Windows.Forms.Button
    Friend WithEvents CnclButton As System.Windows.Forms.Button
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents WorkTabControl As System.Windows.Forms.TabControl
    Friend WithEvents PropertyTabPage As System.Windows.Forms.TabPage
    Friend WithEvents PriorityTabPage As System.Windows.Forms.TabPage
    Friend WithEvents SampleMethodTextBox As System.Windows.Forms.TextBox
    Friend WithEvents SampleUnitNameTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents TargetTypeLabel As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ToolStripButton1 As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripButton2 As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripButton3 As System.Windows.Forms.ToolStripButton
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents SuppressReportCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents TargetReturnNumeric As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents PriorityTextBox As System.Windows.Forms.TextBox
    Friend WithEvents SampleSelectionTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents MedicareIdTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents responseRateNumericUpDownR As System.Windows.Forms.NumericUpDown
    Friend WithEvents toolTip As System.Windows.Forms.ToolTip
    Friend WithEvents InformationBar As Nrc.Qualisys.ConfigurationManager.InformationBar
    Friend WithEvents PropertySplitContainer As System.Windows.Forms.SplitContainer
    Friend WithEvents ServiceTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents RespRateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents InitRespRateNumeric As System.Windows.Forms.NumericUpDown
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents ServiceSubtypeListBox As System.Windows.Forms.CheckedListBox
    Friend WithEvents SampleUnitIdTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents FacilityComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents PropertyCommandPanel As System.Windows.Forms.Panel
    Friend WithEvents SampleUnitTreeView As System.Windows.Forms.TreeView
    Friend WithEvents DeleteUnitButton As System.Windows.Forms.Button
    Friend WithEvents AddUnitButton As System.Windows.Forms.Button
    Friend WithEvents UnitPrioritizer As Nrc.Qualisys.ConfigurationManager.SampleUnitPrioritizer
    Friend WithEvents CriteriaEditorControl As Nrc.Qualisys.ConfigurationManager.CriteriaEditor
    Friend WithEvents SchedulerControl As Nrc.Qualisys.ConfigurationManager.Scheduler
    Friend WithEvents ApplyServiceLinkLabel As System.Windows.Forms.LinkLabel
    Friend WithEvents RespRatePercentLabel As System.Windows.Forms.Label
    Friend WithEvents InitRespRatePercentLabel As System.Windows.Forms.Label
    Friend WithEvents ApplyButton As System.Windows.Forms.Button
    Friend WithEvents UnitTreeContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents AddUnitMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeleteUnitMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents StateTextBox As System.Windows.Forms.TextBox
    Friend WithEvents DontSampleCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents CAHPSTypeComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents CAHPSTypeLabel As System.Windows.Forms.Label
    Friend WithEvents LowVolumeUnitCheckBox As System.Windows.Forms.CheckBox

End Class
