<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class BarcodeSearchSection
    Inherits QualiSys_Scanner_Interface.Section

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
        Me.components = New System.ComponentModel.Container
        Me.SearchCriteriaSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.SearchCriteriaToolStrip = New System.Windows.Forms.ToolStrip
        Me.SearchCriteriaClearTSButton = New System.Windows.Forms.ToolStripButton
        Me.SearchCriteriaSearchTSButton = New System.Windows.Forms.ToolStripButton
        Me.LocationInfoGroupBox = New System.Windows.Forms.GroupBox
        Me.PartialStartingPositionNumericUpDown = New System.Windows.Forms.NumericUpDown
        Me.PartialAfterRadioButton = New System.Windows.Forms.RadioButton
        Me.PartialExactRadioButton = New System.Windows.Forms.RadioButton
        Me.PartialBarcodeCheckBox = New System.Windows.Forms.CheckBox
        Me.BarcodeInfoGroupBox = New System.Windows.Forms.GroupBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.BarcodePasteButton = New System.Windows.Forms.Button
        Me.BarcodeAddButton = New System.Windows.Forms.Button
        Me.BarcodeTextBox = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.BarcodeListBox = New System.Windows.Forms.ListBox
        Me.BarcodeListBoxContextMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.BarcodeListBoxEditTSMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.BarcodeListBoxRemoveTSMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.BarcodeListBoxClearTSMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.PathInfoGroupBox = New System.Windows.Forms.GroupBox
        Me.FAQSSLocationArchiveComboBox = New System.Windows.Forms.ComboBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.BatchDateRangeCheckBox = New System.Windows.Forms.CheckBox
        Me.BatchDateRangeToDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.BatchDateRangeFromDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.BatchDateRangeToLabel = New System.Windows.Forms.Label
        Me.BatchDateRangeFromLabel = New System.Windows.Forms.Label
        Me.TemplatePatternTextBox = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.FAQSSLocationArchiveRadioButton = New System.Windows.Forms.RadioButton
        Me.FAQSSLocationProductionRadioButton = New System.Windows.Forms.RadioButton
        Me.SearchResultsSectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.SearchResultsToolStrip = New System.Windows.Forms.ToolStrip
        Me.SearchResultsCheckTSButton = New System.Windows.Forms.ToolStripButton
        Me.SearchResultsUncheckTSButton = New System.Windows.Forms.ToolStripButton
        Me.SearchResultsCreateStrTSButton = New System.Windows.Forms.ToolStripButton
        Me.SearchResultsExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.SearchResultsGridControl = New DevExpress.XtraGrid.GridControl
        Me.BarcodeSearchResultBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.SearchResultsGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colSelected = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemCheckEdit = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.colSearchString = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colBarcode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colBarcodeFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colBarcodeFileLineNum = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStringFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStringFileLineNum = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStringFileLine = New DevExpress.XtraGrid.Columns.GridColumn
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.SearchCriteriaSectionPanel.SuspendLayout()
        Me.SearchCriteriaToolStrip.SuspendLayout()
        Me.LocationInfoGroupBox.SuspendLayout()
        CType(Me.PartialStartingPositionNumericUpDown, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BarcodeInfoGroupBox.SuspendLayout()
        Me.BarcodeListBoxContextMenu.SuspendLayout()
        Me.PathInfoGroupBox.SuspendLayout()
        Me.SearchResultsSectionPanel.SuspendLayout()
        Me.SearchResultsToolStrip.SuspendLayout()
        CType(Me.SearchResultsGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.BarcodeSearchResultBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.SearchResultsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SearchCriteriaSectionPanel
        '
        Me.SearchCriteriaSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SearchCriteriaSectionPanel.Caption = "Barcode Search Criteria"
        Me.SearchCriteriaSectionPanel.Controls.Add(Me.SearchCriteriaToolStrip)
        Me.SearchCriteriaSectionPanel.Controls.Add(Me.LocationInfoGroupBox)
        Me.SearchCriteriaSectionPanel.Controls.Add(Me.BarcodeInfoGroupBox)
        Me.SearchCriteriaSectionPanel.Controls.Add(Me.PathInfoGroupBox)
        Me.SearchCriteriaSectionPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.SearchCriteriaSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.SearchCriteriaSectionPanel.MinimumSize = New System.Drawing.Size(542, 0)
        Me.SearchCriteriaSectionPanel.Name = "SearchCriteriaSectionPanel"
        Me.SearchCriteriaSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.SearchCriteriaSectionPanel.ShowCaption = True
        Me.SearchCriteriaSectionPanel.Size = New System.Drawing.Size(542, 315)
        Me.SearchCriteriaSectionPanel.TabIndex = 0
        '
        'SearchCriteriaToolStrip
        '
        Me.SearchCriteriaToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.SearchCriteriaToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SearchCriteriaClearTSButton, Me.SearchCriteriaSearchTSButton})
        Me.SearchCriteriaToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.SearchCriteriaToolStrip.Name = "SearchCriteriaToolStrip"
        Me.SearchCriteriaToolStrip.Size = New System.Drawing.Size(540, 25)
        Me.SearchCriteriaToolStrip.TabIndex = 15
        Me.SearchCriteriaToolStrip.Text = "ToolStrip1"
        '
        'SearchCriteriaClearTSButton
        '
        Me.SearchCriteriaClearTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.DeleteRed16
        Me.SearchCriteriaClearTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SearchCriteriaClearTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchCriteriaClearTSButton.Name = "SearchCriteriaClearTSButton"
        Me.SearchCriteriaClearTSButton.Size = New System.Drawing.Size(88, 22)
        Me.SearchCriteriaClearTSButton.Text = "Clear Search"
        '
        'SearchCriteriaSearchTSButton
        '
        Me.SearchCriteriaSearchTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Search
        Me.SearchCriteriaSearchTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.SearchCriteriaSearchTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchCriteriaSearchTSButton.Name = "SearchCriteriaSearchTSButton"
        Me.SearchCriteriaSearchTSButton.Size = New System.Drawing.Size(60, 22)
        Me.SearchCriteriaSearchTSButton.Text = "Search"
        '
        'LocationInfoGroupBox
        '
        Me.LocationInfoGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LocationInfoGroupBox.Controls.Add(Me.PartialStartingPositionNumericUpDown)
        Me.LocationInfoGroupBox.Controls.Add(Me.PartialAfterRadioButton)
        Me.LocationInfoGroupBox.Controls.Add(Me.PartialExactRadioButton)
        Me.LocationInfoGroupBox.Controls.Add(Me.PartialBarcodeCheckBox)
        Me.LocationInfoGroupBox.Location = New System.Drawing.Point(193, 230)
        Me.LocationInfoGroupBox.Name = "LocationInfoGroupBox"
        Me.LocationInfoGroupBox.Size = New System.Drawing.Size(335, 71)
        Me.LocationInfoGroupBox.TabIndex = 20
        Me.LocationInfoGroupBox.TabStop = False
        Me.LocationInfoGroupBox.Text = " Location Information "
        '
        'PartialStartingPositionNumericUpDown
        '
        Me.PartialStartingPositionNumericUpDown.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PartialStartingPositionNumericUpDown.Enabled = False
        Me.PartialStartingPositionNumericUpDown.Location = New System.Drawing.Point(264, 20)
        Me.PartialStartingPositionNumericUpDown.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.PartialStartingPositionNumericUpDown.Name = "PartialStartingPositionNumericUpDown"
        Me.PartialStartingPositionNumericUpDown.Size = New System.Drawing.Size(58, 21)
        Me.PartialStartingPositionNumericUpDown.TabIndex = 22
        Me.PartialStartingPositionNumericUpDown.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'PartialAfterRadioButton
        '
        Me.PartialAfterRadioButton.AutoSize = True
        Me.PartialAfterRadioButton.Enabled = False
        Me.PartialAfterRadioButton.Location = New System.Drawing.Point(130, 44)
        Me.PartialAfterRadioButton.Name = "PartialAfterRadioButton"
        Me.PartialAfterRadioButton.Size = New System.Drawing.Size(102, 17)
        Me.PartialAfterRadioButton.TabIndex = 24
        Me.PartialAfterRadioButton.TabStop = True
        Me.PartialAfterRadioButton.Text = "Anywhere After"
        Me.PartialAfterRadioButton.UseVisualStyleBackColor = True
        '
        'PartialExactRadioButton
        '
        Me.PartialExactRadioButton.AutoSize = True
        Me.PartialExactRadioButton.Enabled = False
        Me.PartialExactRadioButton.Location = New System.Drawing.Point(29, 44)
        Me.PartialExactRadioButton.Name = "PartialExactRadioButton"
        Me.PartialExactRadioButton.Size = New System.Drawing.Size(95, 17)
        Me.PartialExactRadioButton.TabIndex = 23
        Me.PartialExactRadioButton.TabStop = True
        Me.PartialExactRadioButton.Text = "Exact Location"
        Me.PartialExactRadioButton.UseVisualStyleBackColor = True
        '
        'PartialBarcodeCheckBox
        '
        Me.PartialBarcodeCheckBox.AutoSize = True
        Me.PartialBarcodeCheckBox.Location = New System.Drawing.Point(12, 21)
        Me.PartialBarcodeCheckBox.Name = "PartialBarcodeCheckBox"
        Me.PartialBarcodeCheckBox.Size = New System.Drawing.Size(246, 17)
        Me.PartialBarcodeCheckBox.TabIndex = 21
        Me.PartialBarcodeCheckBox.Text = "Partial Barcodes Provided Starting at Position:"
        Me.PartialBarcodeCheckBox.UseVisualStyleBackColor = True
        '
        'BarcodeInfoGroupBox
        '
        Me.BarcodeInfoGroupBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.Label4)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.BarcodePasteButton)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.BarcodeAddButton)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.BarcodeTextBox)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.Label3)
        Me.BarcodeInfoGroupBox.Controls.Add(Me.BarcodeListBox)
        Me.BarcodeInfoGroupBox.Location = New System.Drawing.Point(193, 58)
        Me.BarcodeInfoGroupBox.Name = "BarcodeInfoGroupBox"
        Me.BarcodeInfoGroupBox.Size = New System.Drawing.Size(335, 168)
        Me.BarcodeInfoGroupBox.TabIndex = 13
        Me.BarcodeInfoGroupBox.TabStop = False
        Me.BarcodeInfoGroupBox.Text = " Barcode Information "
        '
        'Label4
        '
        Me.Label4.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(173, 54)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(128, 13)
        Me.Label4.TabIndex = 17
        Me.Label4.Text = "(no page# or check digit)"
        '
        'BarcodePasteButton
        '
        Me.BarcodePasteButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodePasteButton.Location = New System.Drawing.Point(176, 133)
        Me.BarcodePasteButton.Name = "BarcodePasteButton"
        Me.BarcodePasteButton.Size = New System.Drawing.Size(146, 23)
        Me.BarcodePasteButton.TabIndex = 19
        Me.BarcodePasteButton.Text = "Paste from Clipboard"
        Me.BarcodePasteButton.UseVisualStyleBackColor = True
        '
        'BarcodeAddButton
        '
        Me.BarcodeAddButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeAddButton.Location = New System.Drawing.Point(176, 75)
        Me.BarcodeAddButton.Name = "BarcodeAddButton"
        Me.BarcodeAddButton.Size = New System.Drawing.Size(146, 23)
        Me.BarcodeAddButton.TabIndex = 18
        Me.BarcodeAddButton.Text = "Add to List"
        Me.BarcodeAddButton.UseVisualStyleBackColor = True
        '
        'BarcodeTextBox
        '
        Me.BarcodeTextBox.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.BarcodeTextBox.Location = New System.Drawing.Point(176, 33)
        Me.BarcodeTextBox.Name = "BarcodeTextBox"
        Me.BarcodeTextBox.Size = New System.Drawing.Size(146, 21)
        Me.BarcodeTextBox.TabIndex = 16
        '
        'Label3
        '
        Me.Label3.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(173, 17)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(79, 13)
        Me.Label3.TabIndex = 15
        Me.Label3.Text = "Input Barcode:"
        '
        'BarcodeListBox
        '
        Me.BarcodeListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BarcodeListBox.ContextMenuStrip = Me.BarcodeListBoxContextMenu
        Me.BarcodeListBox.FormattingEnabled = True
        Me.BarcodeListBox.IntegralHeight = False
        Me.BarcodeListBox.Location = New System.Drawing.Point(12, 19)
        Me.BarcodeListBox.Name = "BarcodeListBox"
        Me.BarcodeListBox.Size = New System.Drawing.Size(155, 137)
        Me.BarcodeListBox.TabIndex = 14
        '
        'BarcodeListBoxContextMenu
        '
        Me.BarcodeListBoxContextMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.BarcodeListBoxEditTSMenuItem, Me.BarcodeListBoxRemoveTSMenuItem, Me.BarcodeListBoxClearTSMenuItem})
        Me.BarcodeListBoxContextMenu.Name = "BarcodeListBoxContextMenu"
        Me.BarcodeListBoxContextMenu.Size = New System.Drawing.Size(154, 70)
        '
        'BarcodeListBoxEditTSMenuItem
        '
        Me.BarcodeListBoxEditTSMenuItem.Name = "BarcodeListBoxEditTSMenuItem"
        Me.BarcodeListBoxEditTSMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.BarcodeListBoxEditTSMenuItem.Text = "Edit Entry"
        '
        'BarcodeListBoxRemoveTSMenuItem
        '
        Me.BarcodeListBoxRemoveTSMenuItem.Name = "BarcodeListBoxRemoveTSMenuItem"
        Me.BarcodeListBoxRemoveTSMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.BarcodeListBoxRemoveTSMenuItem.Text = "Remove Entry"
        '
        'BarcodeListBoxClearTSMenuItem
        '
        Me.BarcodeListBoxClearTSMenuItem.Name = "BarcodeListBoxClearTSMenuItem"
        Me.BarcodeListBoxClearTSMenuItem.Size = New System.Drawing.Size(153, 22)
        Me.BarcodeListBoxClearTSMenuItem.Text = "Clear List"
        '
        'PathInfoGroupBox
        '
        Me.PathInfoGroupBox.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.PathInfoGroupBox.Controls.Add(Me.FAQSSLocationArchiveComboBox)
        Me.PathInfoGroupBox.Controls.Add(Me.Label6)
        Me.PathInfoGroupBox.Controls.Add(Me.Label2)
        Me.PathInfoGroupBox.Controls.Add(Me.BatchDateRangeCheckBox)
        Me.PathInfoGroupBox.Controls.Add(Me.BatchDateRangeToDateTimePicker)
        Me.PathInfoGroupBox.Controls.Add(Me.BatchDateRangeFromDateTimePicker)
        Me.PathInfoGroupBox.Controls.Add(Me.BatchDateRangeToLabel)
        Me.PathInfoGroupBox.Controls.Add(Me.BatchDateRangeFromLabel)
        Me.PathInfoGroupBox.Controls.Add(Me.TemplatePatternTextBox)
        Me.PathInfoGroupBox.Controls.Add(Me.Label1)
        Me.PathInfoGroupBox.Controls.Add(Me.FAQSSLocationArchiveRadioButton)
        Me.PathInfoGroupBox.Controls.Add(Me.FAQSSLocationProductionRadioButton)
        Me.PathInfoGroupBox.Location = New System.Drawing.Point(13, 58)
        Me.PathInfoGroupBox.Name = "PathInfoGroupBox"
        Me.PathInfoGroupBox.Size = New System.Drawing.Size(170, 243)
        Me.PathInfoGroupBox.TabIndex = 0
        Me.PathInfoGroupBox.TabStop = False
        Me.PathInfoGroupBox.Text = " Path Information "
        '
        'FAQSSLocationArchiveComboBox
        '
        Me.FAQSSLocationArchiveComboBox.FormattingEnabled = True
        Me.FAQSSLocationArchiveComboBox.Location = New System.Drawing.Point(45, 71)
        Me.FAQSSLocationArchiveComboBox.Name = "FAQSSLocationArchiveComboBox"
        Me.FAQSSLocationArchiveComboBox.Size = New System.Drawing.Size(113, 21)
        Me.FAQSSLocationArchiveComboBox.TabIndex = 4
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(9, 141)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(98, 13)
        Me.Label6.TabIndex = 7
        Me.Label6.Text = "(wildcards allowed)"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(9, 17)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(92, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "FAQSS Locations:"
        '
        'BatchDateRangeCheckBox
        '
        Me.BatchDateRangeCheckBox.AutoSize = True
        Me.BatchDateRangeCheckBox.Location = New System.Drawing.Point(12, 166)
        Me.BatchDateRangeCheckBox.Name = "BatchDateRangeCheckBox"
        Me.BatchDateRangeCheckBox.Size = New System.Drawing.Size(117, 17)
        Me.BatchDateRangeCheckBox.TabIndex = 8
        Me.BatchDateRangeCheckBox.Text = "Batch Date Range:"
        Me.BatchDateRangeCheckBox.UseVisualStyleBackColor = True
        '
        'BatchDateRangeToDateTimePicker
        '
        Me.BatchDateRangeToDateTimePicker.Enabled = False
        Me.BatchDateRangeToDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.BatchDateRangeToDateTimePicker.Location = New System.Drawing.Point(70, 211)
        Me.BatchDateRangeToDateTimePicker.Name = "BatchDateRangeToDateTimePicker"
        Me.BatchDateRangeToDateTimePicker.Size = New System.Drawing.Size(88, 21)
        Me.BatchDateRangeToDateTimePicker.TabIndex = 12
        '
        'BatchDateRangeFromDateTimePicker
        '
        Me.BatchDateRangeFromDateTimePicker.Enabled = False
        Me.BatchDateRangeFromDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.BatchDateRangeFromDateTimePicker.Location = New System.Drawing.Point(70, 184)
        Me.BatchDateRangeFromDateTimePicker.Name = "BatchDateRangeFromDateTimePicker"
        Me.BatchDateRangeFromDateTimePicker.Size = New System.Drawing.Size(88, 21)
        Me.BatchDateRangeFromDateTimePicker.TabIndex = 10
        '
        'BatchDateRangeToLabel
        '
        Me.BatchDateRangeToLabel.AutoSize = True
        Me.BatchDateRangeToLabel.Enabled = False
        Me.BatchDateRangeToLabel.Location = New System.Drawing.Point(29, 215)
        Me.BatchDateRangeToLabel.Name = "BatchDateRangeToLabel"
        Me.BatchDateRangeToLabel.Size = New System.Drawing.Size(23, 13)
        Me.BatchDateRangeToLabel.TabIndex = 11
        Me.BatchDateRangeToLabel.Text = "To:"
        '
        'BatchDateRangeFromLabel
        '
        Me.BatchDateRangeFromLabel.AutoSize = True
        Me.BatchDateRangeFromLabel.Enabled = False
        Me.BatchDateRangeFromLabel.Location = New System.Drawing.Point(29, 188)
        Me.BatchDateRangeFromLabel.Name = "BatchDateRangeFromLabel"
        Me.BatchDateRangeFromLabel.Size = New System.Drawing.Size(35, 13)
        Me.BatchDateRangeFromLabel.TabIndex = 9
        Me.BatchDateRangeFromLabel.Text = "From:"
        '
        'TemplatePatternTextBox
        '
        Me.TemplatePatternTextBox.CharacterCasing = System.Windows.Forms.CharacterCasing.Upper
        Me.TemplatePatternTextBox.Location = New System.Drawing.Point(12, 119)
        Me.TemplatePatternTextBox.Name = "TemplatePatternTextBox"
        Me.TemplatePatternTextBox.Size = New System.Drawing.Size(146, 21)
        Me.TemplatePatternTextBox.TabIndex = 6
        Me.TemplatePatternTextBox.Text = "*"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(9, 103)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(94, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Template Pattern:"
        '
        'FAQSSLocationArchiveRadioButton
        '
        Me.FAQSSLocationArchiveRadioButton.AutoSize = True
        Me.FAQSSLocationArchiveRadioButton.Location = New System.Drawing.Point(29, 54)
        Me.FAQSSLocationArchiveRadioButton.Name = "FAQSSLocationArchiveRadioButton"
        Me.FAQSSLocationArchiveRadioButton.Size = New System.Drawing.Size(61, 17)
        Me.FAQSSLocationArchiveRadioButton.TabIndex = 3
        Me.FAQSSLocationArchiveRadioButton.TabStop = True
        Me.FAQSSLocationArchiveRadioButton.Text = "Archive"
        Me.FAQSSLocationArchiveRadioButton.UseVisualStyleBackColor = True
        '
        'FAQSSLocationProductionRadioButton
        '
        Me.FAQSSLocationProductionRadioButton.AutoSize = True
        Me.FAQSSLocationProductionRadioButton.Location = New System.Drawing.Point(29, 33)
        Me.FAQSSLocationProductionRadioButton.Name = "FAQSSLocationProductionRadioButton"
        Me.FAQSSLocationProductionRadioButton.Size = New System.Drawing.Size(76, 17)
        Me.FAQSSLocationProductionRadioButton.TabIndex = 2
        Me.FAQSSLocationProductionRadioButton.TabStop = True
        Me.FAQSSLocationProductionRadioButton.Text = "Production"
        Me.FAQSSLocationProductionRadioButton.UseVisualStyleBackColor = True
        '
        'SearchResultsSectionPanel
        '
        Me.SearchResultsSectionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchResultsSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SearchResultsSectionPanel.Caption = "Barcode Search Results"
        Me.SearchResultsSectionPanel.Controls.Add(Me.SearchResultsToolStrip)
        Me.SearchResultsSectionPanel.Controls.Add(Me.SearchResultsGridControl)
        Me.SearchResultsSectionPanel.Location = New System.Drawing.Point(0, 321)
        Me.SearchResultsSectionPanel.Name = "SearchResultsSectionPanel"
        Me.SearchResultsSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.SearchResultsSectionPanel.ShowCaption = True
        Me.SearchResultsSectionPanel.Size = New System.Drawing.Size(542, 301)
        Me.SearchResultsSectionPanel.TabIndex = 1
        '
        'SearchResultsToolStrip
        '
        Me.SearchResultsToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.SearchResultsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SearchResultsCheckTSButton, Me.SearchResultsUncheckTSButton, Me.SearchResultsCreateStrTSButton, Me.SearchResultsExcelTSButton})
        Me.SearchResultsToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.SearchResultsToolStrip.Name = "SearchResultsToolStrip"
        Me.SearchResultsToolStrip.Size = New System.Drawing.Size(540, 25)
        Me.SearchResultsToolStrip.TabIndex = 27
        Me.SearchResultsToolStrip.Text = "ToolStrip1"
        '
        'SearchResultsCheckTSButton
        '
        Me.SearchResultsCheckTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Check
        Me.SearchResultsCheckTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.SearchResultsCheckTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchResultsCheckTSButton.Name = "SearchResultsCheckTSButton"
        Me.SearchResultsCheckTSButton.Size = New System.Drawing.Size(70, 22)
        Me.SearchResultsCheckTSButton.Text = "Check All"
        '
        'SearchResultsUncheckTSButton
        '
        Me.SearchResultsUncheckTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.UnCheck
        Me.SearchResultsUncheckTSButton.ImageTransparentColor = System.Drawing.Color.Red
        Me.SearchResultsUncheckTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchResultsUncheckTSButton.Name = "SearchResultsUncheckTSButton"
        Me.SearchResultsUncheckTSButton.Size = New System.Drawing.Size(81, 22)
        Me.SearchResultsUncheckTSButton.Text = "Uncheck All"
        '
        'SearchResultsCreateStrTSButton
        '
        Me.SearchResultsCreateStrTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Document16
        Me.SearchResultsCreateStrTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SearchResultsCreateStrTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchResultsCreateStrTSButton.Name = "SearchResultsCreateStrTSButton"
        Me.SearchResultsCreateStrTSButton.Size = New System.Drawing.Size(101, 22)
        Me.SearchResultsCreateStrTSButton.Text = "Create STR File"
        '
        'SearchResultsExcelTSButton
        '
        Me.SearchResultsExcelTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.SearchResultsExcelTSButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.Excel16
        Me.SearchResultsExcelTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.SearchResultsExcelTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.SearchResultsExcelTSButton.Name = "SearchResultsExcelTSButton"
        Me.SearchResultsExcelTSButton.Size = New System.Drawing.Size(102, 22)
        Me.SearchResultsExcelTSButton.Text = "Export To Excel"
        '
        'SearchResultsGridControl
        '
        Me.SearchResultsGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchResultsGridControl.DataSource = Me.BarcodeSearchResultBindingSource
        Me.SearchResultsGridControl.EmbeddedNavigator.Name = ""
        Me.SearchResultsGridControl.Location = New System.Drawing.Point(4, 59)
        Me.SearchResultsGridControl.MainView = Me.SearchResultsGridView
        Me.SearchResultsGridControl.Name = "SearchResultsGridControl"
        Me.SearchResultsGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemCheckEdit})
        Me.SearchResultsGridControl.Size = New System.Drawing.Size(534, 238)
        Me.SearchResultsGridControl.TabIndex = 25
        Me.SearchResultsGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.SearchResultsGridView})
        '
        'BarcodeSearchResultBindingSource
        '
        Me.BarcodeSearchResultBindingSource.DataSource = GetType(Nrc.QualiSys.Scanning.Library.BarcodeSearchResult)
        '
        'SearchResultsGridView
        '
        Me.SearchResultsGridView.Appearance.HeaderPanel.Options.UseTextOptions = True
        Me.SearchResultsGridView.Appearance.HeaderPanel.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap
        Me.SearchResultsGridView.ColumnPanelRowHeight = 32
        Me.SearchResultsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colSelected, Me.colSearchString, Me.colBarcode, Me.colBarcodeFileName, Me.colBarcodeFileLineNum, Me.colStringFileName, Me.colStringFileLineNum, Me.colStringFileLine})
        Me.SearchResultsGridView.GridControl = Me.SearchResultsGridControl
        Me.SearchResultsGridView.Name = "SearchResultsGridView"
        Me.SearchResultsGridView.OptionsView.ColumnAutoWidth = False
        '
        'colSelected
        '
        Me.colSelected.ColumnEdit = Me.RepositoryItemCheckEdit
        Me.colSelected.FieldName = "Selected"
        Me.colSelected.Name = "colSelected"
        Me.colSelected.Visible = True
        Me.colSelected.VisibleIndex = 0
        Me.colSelected.Width = 25
        '
        'RepositoryItemCheckEdit
        '
        Me.RepositoryItemCheckEdit.AutoHeight = False
        Me.RepositoryItemCheckEdit.Name = "RepositoryItemCheckEdit"
        '
        'colSearchString
        '
        Me.colSearchString.Caption = "Search String"
        Me.colSearchString.FieldName = "SearchString"
        Me.colSearchString.Name = "colSearchString"
        Me.colSearchString.OptionsColumn.AllowEdit = False
        Me.colSearchString.OptionsColumn.ReadOnly = True
        Me.colSearchString.Visible = True
        Me.colSearchString.VisibleIndex = 1
        Me.colSearchString.Width = 96
        '
        'colBarcode
        '
        Me.colBarcode.Caption = "Barcode"
        Me.colBarcode.FieldName = "Barcode"
        Me.colBarcode.Name = "colBarcode"
        Me.colBarcode.OptionsColumn.AllowEdit = False
        Me.colBarcode.OptionsColumn.ReadOnly = True
        Me.colBarcode.Visible = True
        Me.colBarcode.VisibleIndex = 2
        Me.colBarcode.Width = 95
        '
        'colBarcodeFileName
        '
        Me.colBarcodeFileName.Caption = "Barcode FileName"
        Me.colBarcodeFileName.FieldName = "BarcodeFileName"
        Me.colBarcodeFileName.Name = "colBarcodeFileName"
        Me.colBarcodeFileName.OptionsColumn.AllowEdit = False
        Me.colBarcodeFileName.OptionsColumn.ReadOnly = True
        Me.colBarcodeFileName.Visible = True
        Me.colBarcodeFileName.VisibleIndex = 3
        Me.colBarcodeFileName.Width = 134
        '
        'colBarcodeFileLineNum
        '
        Me.colBarcodeFileLineNum.Caption = "Barcode Line#"
        Me.colBarcodeFileLineNum.FieldName = "BarcodeFileLineNum"
        Me.colBarcodeFileLineNum.Name = "colBarcodeFileLineNum"
        Me.colBarcodeFileLineNum.OptionsColumn.AllowEdit = False
        Me.colBarcodeFileLineNum.OptionsColumn.ReadOnly = True
        Me.colBarcodeFileLineNum.Visible = True
        Me.colBarcodeFileLineNum.VisibleIndex = 4
        Me.colBarcodeFileLineNum.Width = 61
        '
        'colStringFileName
        '
        Me.colStringFileName.Caption = "STR FileName"
        Me.colStringFileName.FieldName = "StringFileName"
        Me.colStringFileName.Name = "colStringFileName"
        Me.colStringFileName.OptionsColumn.AllowEdit = False
        Me.colStringFileName.OptionsColumn.ReadOnly = True
        Me.colStringFileName.Visible = True
        Me.colStringFileName.VisibleIndex = 5
        Me.colStringFileName.Width = 141
        '
        'colStringFileLineNum
        '
        Me.colStringFileLineNum.Caption = "STR Line#"
        Me.colStringFileLineNum.FieldName = "StringFileLineNum"
        Me.colStringFileLineNum.Name = "colStringFileLineNum"
        Me.colStringFileLineNum.OptionsColumn.AllowEdit = False
        Me.colStringFileLineNum.OptionsColumn.ReadOnly = True
        Me.colStringFileLineNum.Visible = True
        Me.colStringFileLineNum.VisibleIndex = 6
        Me.colStringFileLineNum.Width = 56
        '
        'colStringFileLine
        '
        Me.colStringFileLine.Caption = "STR Line"
        Me.colStringFileLine.FieldName = "StringFileLine"
        Me.colStringFileLine.Name = "colStringFileLine"
        Me.colStringFileLine.OptionsColumn.AllowEdit = False
        Me.colStringFileLine.OptionsColumn.ReadOnly = True
        Me.colStringFileLine.Visible = True
        Me.colStringFileLine.VisibleIndex = 7
        Me.colStringFileLine.Width = 307
        '
        'SaveFileDialog
        '
        Me.SaveFileDialog.DefaultExt = "xls"
        Me.SaveFileDialog.Filter = "Excel Files|*.xls"
        Me.SaveFileDialog.Title = "Export To Excel"
        '
        'BarcodeSearchSection
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SearchResultsSectionPanel)
        Me.Controls.Add(Me.SearchCriteriaSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "BarcodeSearchSection"
        Me.Size = New System.Drawing.Size(542, 622)
        Me.SearchCriteriaSectionPanel.ResumeLayout(False)
        Me.SearchCriteriaSectionPanel.PerformLayout()
        Me.SearchCriteriaToolStrip.ResumeLayout(False)
        Me.SearchCriteriaToolStrip.PerformLayout()
        Me.LocationInfoGroupBox.ResumeLayout(False)
        Me.LocationInfoGroupBox.PerformLayout()
        CType(Me.PartialStartingPositionNumericUpDown, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BarcodeInfoGroupBox.ResumeLayout(False)
        Me.BarcodeInfoGroupBox.PerformLayout()
        Me.BarcodeListBoxContextMenu.ResumeLayout(False)
        Me.PathInfoGroupBox.ResumeLayout(False)
        Me.PathInfoGroupBox.PerformLayout()
        Me.SearchResultsSectionPanel.ResumeLayout(False)
        Me.SearchResultsSectionPanel.PerformLayout()
        Me.SearchResultsToolStrip.ResumeLayout(False)
        Me.SearchResultsToolStrip.PerformLayout()
        CType(Me.SearchResultsGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.BarcodeSearchResultBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.SearchResultsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckEdit, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SearchCriteriaSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents PathInfoGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents FAQSSLocationArchiveRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents FAQSSLocationProductionRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents BatchDateRangeCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents BatchDateRangeToDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents BatchDateRangeFromDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents BatchDateRangeToLabel As System.Windows.Forms.Label
    Friend WithEvents BatchDateRangeFromLabel As System.Windows.Forms.Label
    Friend WithEvents TemplatePatternTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents BarcodeInfoGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents LocationInfoGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents BarcodeListBox As System.Windows.Forms.ListBox
    Friend WithEvents BarcodePasteButton As System.Windows.Forms.Button
    Friend WithEvents BarcodeAddButton As System.Windows.Forms.Button
    Friend WithEvents BarcodeTextBox As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents PartialAfterRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PartialExactRadioButton As System.Windows.Forms.RadioButton
    Friend WithEvents PartialBarcodeCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents PartialStartingPositionNumericUpDown As System.Windows.Forms.NumericUpDown
    Friend WithEvents SearchCriteriaToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents SearchCriteriaSearchTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SearchResultsSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SearchResultsGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents SearchResultsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents FAQSSLocationArchiveComboBox As System.Windows.Forms.ComboBox
    Friend WithEvents BarcodeSearchResultBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colSearchString As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colBarcode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colBarcodeFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colBarcodeFileLineNum As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStringFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStringFileLineNum As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStringFileLine As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents SearchCriteriaClearTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SearchResultsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents SearchResultsCreateStrTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SearchResultsExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents RepositoryItemCheckEdit As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents colSelected As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents SearchResultsCheckTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SearchResultsUncheckTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents BarcodeListBoxContextMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents BarcodeListBoxEditTSMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents BarcodeListBoxRemoveTSMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents BarcodeListBoxClearTSMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
