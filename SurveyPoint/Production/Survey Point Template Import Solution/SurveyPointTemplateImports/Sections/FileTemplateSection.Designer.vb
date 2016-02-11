<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FileTemplateSection
    Inherits Section

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.panelFileTemplate = New Nrc.Framework.WinForms.SectionPanel
        Me.cmdOK = New System.Windows.Forms.Button
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.TabControl1 = New System.Windows.Forms.TabControl
        Me.tabTemplateDefinition = New System.Windows.Forms.TabPage
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.grdSampleTemplate = New DevExpress.XtraGrid.GridControl
        Me.bsColumnDefinitions = New System.Windows.Forms.BindingSource(Me.components)
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colColumnDefID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileTemplateID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOrdinal = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFixedStringLength = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateTypeID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colActive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colArchive = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDataType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRule = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDataTypeName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRuleName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRuleID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.cboDelimeterType = New System.Windows.Forms.ComboBox
        Me.chkUseQuotedIdentifier = New System.Windows.Forms.CheckBox
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.cboEncodingType = New System.Windows.Forms.ComboBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.chkTrimStrings = New System.Windows.Forms.CheckBox
        Me.chkImportAsString = New System.Windows.Forms.CheckBox
        Me.chkFixedLength = New System.Windows.Forms.CheckBox
        Me.lblTemplateID = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.txtTemplateName = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.tabColumnDefinitions = New System.Windows.Forms.TabPage
        Me.GroupBox4 = New System.Windows.Forms.GroupBox
        Me.cboFormatingRules = New System.Windows.Forms.ComboBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.txtFixedLengthStringLength = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.txtColumnName = New System.Windows.Forms.TextBox
        Me.cboDataTypes = New System.Windows.Forms.ComboBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.cmdMoveDown = New System.Windows.Forms.Button
        Me.cmdMoveUp = New System.Windows.Forms.Button
        Me.cmdCopyColumn = New System.Windows.Forms.Button
        Me.cmdRemoveColumn = New System.Windows.Forms.Button
        Me.cmdEditColumn = New System.Windows.Forms.Button
        Me.cmdAddColumn = New System.Windows.Forms.Button
        Me.GroupBox3 = New System.Windows.Forms.GroupBox
        Me.grdColumns = New DevExpress.XtraGrid.GridControl
        Me.grdColumnsView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colColumnDefID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileTemplateID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOrdinal1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFixedStringLength1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateTypeID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colActive1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colArchive1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDataType1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRule1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDataTypeName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRuleName1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFormatingRuleID1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.panelFileTemplate.SuspendLayout()
        Me.TabControl1.SuspendLayout()
        Me.tabTemplateDefinition.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.grdSampleTemplate, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsColumnDefinitions, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox1.SuspendLayout()
        Me.tabColumnDefinitions.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        CType(Me.grdColumns, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdColumnsView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'panelFileTemplate
        '
        Me.panelFileTemplate.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.panelFileTemplate.Caption = "File Templates"
        Me.panelFileTemplate.Controls.Add(Me.cmdOK)
        Me.panelFileTemplate.Controls.Add(Me.cmdCancel)
        Me.panelFileTemplate.Controls.Add(Me.TabControl1)
        Me.panelFileTemplate.Dock = System.Windows.Forms.DockStyle.Fill
        Me.panelFileTemplate.Location = New System.Drawing.Point(0, 0)
        Me.panelFileTemplate.Name = "panelFileTemplate"
        Me.panelFileTemplate.Padding = New System.Windows.Forms.Padding(1)
        Me.panelFileTemplate.ShowCaption = True
        Me.panelFileTemplate.Size = New System.Drawing.Size(792, 708)
        Me.panelFileTemplate.TabIndex = 0
        '
        'cmdOK
        '
        Me.cmdOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdOK.Location = New System.Drawing.Point(615, 670)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(75, 23)
        Me.cmdOK.TabIndex = 22
        Me.cmdOK.Text = "&OK"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.Location = New System.Drawing.Point(696, 670)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 23
        Me.cmdCancel.Text = "&Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'TabControl1
        '
        Me.TabControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TabControl1.Controls.Add(Me.tabTemplateDefinition)
        Me.TabControl1.Controls.Add(Me.tabColumnDefinitions)
        Me.TabControl1.Location = New System.Drawing.Point(13, 40)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(762, 624)
        Me.TabControl1.TabIndex = 10
        '
        'tabTemplateDefinition
        '
        Me.tabTemplateDefinition.Controls.Add(Me.GroupBox2)
        Me.tabTemplateDefinition.Controls.Add(Me.GroupBox1)
        Me.tabTemplateDefinition.Location = New System.Drawing.Point(4, 22)
        Me.tabTemplateDefinition.Name = "tabTemplateDefinition"
        Me.tabTemplateDefinition.Padding = New System.Windows.Forms.Padding(3)
        Me.tabTemplateDefinition.Size = New System.Drawing.Size(754, 598)
        Me.tabTemplateDefinition.TabIndex = 0
        Me.tabTemplateDefinition.Text = "Template Definition"
        Me.tabTemplateDefinition.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.grdSampleTemplate)
        Me.GroupBox2.Location = New System.Drawing.Point(6, 294)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(742, 262)
        Me.GroupBox2.TabIndex = 1
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Column Definitions"
        '
        'grdSampleTemplate
        '
        Me.grdSampleTemplate.DataSource = Me.bsColumnDefinitions
        Me.grdSampleTemplate.EmbeddedNavigator.Name = ""
        Me.grdSampleTemplate.Location = New System.Drawing.Point(6, 19)
        Me.grdSampleTemplate.MainView = Me.GridView1
        Me.grdSampleTemplate.Name = "grdSampleTemplate"
        Me.grdSampleTemplate.Size = New System.Drawing.Size(730, 227)
        Me.grdSampleTemplate.TabIndex = 9
        Me.grdSampleTemplate.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'bsColumnDefinitions
        '
        Me.bsColumnDefinitions.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_ColumnDefinition)
        Me.bsColumnDefinitions.Sort = ""
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colColumnDefID, Me.colFileTemplateID, Me.colName, Me.colOrdinal, Me.colFixedStringLength, Me.colDateTypeID, Me.colDateCreated, Me.colActive, Me.colArchive, Me.colDataType, Me.colFormatingRule, Me.colDataTypeName, Me.colFormatingRuleName, Me.colFormatingRuleID})
        Me.GridView1.GridControl = Me.grdSampleTemplate
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsCustomization.AllowColumnMoving = False
        Me.GridView1.OptionsCustomization.AllowFilter = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsFilter.AllowFilterEditor = False
        Me.GridView1.OptionsView.ShowGroupPanel = False
        Me.GridView1.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colOrdinal, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colColumnDefID
        '
        Me.colColumnDefID.Caption = "ColumnDefID"
        Me.colColumnDefID.FieldName = "ColumnDefID"
        Me.colColumnDefID.Name = "colColumnDefID"
        Me.colColumnDefID.OptionsColumn.ReadOnly = True
        '
        'colFileTemplateID
        '
        Me.colFileTemplateID.Caption = "FileTemplateID"
        Me.colFileTemplateID.FieldName = "FileTemplateID"
        Me.colFileTemplateID.Name = "colFileTemplateID"
        '
        'colName
        '
        Me.colName.Caption = "Column Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        Me.colName.Width = 220
        '
        'colOrdinal
        '
        Me.colOrdinal.Caption = "Ordinal"
        Me.colOrdinal.FieldName = "Ordinal"
        Me.colOrdinal.Name = "colOrdinal"
        Me.colOrdinal.Visible = True
        Me.colOrdinal.VisibleIndex = 3
        Me.colOrdinal.Width = 120
        '
        'colFixedStringLength
        '
        Me.colFixedStringLength.Caption = "Fixed String Length"
        Me.colFixedStringLength.FieldName = "FixedStringLength"
        Me.colFixedStringLength.Name = "colFixedStringLength"
        Me.colFixedStringLength.Visible = True
        Me.colFixedStringLength.VisibleIndex = 4
        Me.colFixedStringLength.Width = 129
        '
        'colDateTypeID
        '
        Me.colDateTypeID.Caption = "DateTypeID"
        Me.colDateTypeID.FieldName = "DateTypeID"
        Me.colDateTypeID.Name = "colDateTypeID"
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "DateCreated"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        '
        'colActive
        '
        Me.colActive.Caption = "Active"
        Me.colActive.FieldName = "Active"
        Me.colActive.Name = "colActive"
        '
        'colArchive
        '
        Me.colArchive.Caption = "Archive"
        Me.colArchive.FieldName = "Archive"
        Me.colArchive.Name = "colArchive"
        '
        'colDataType
        '
        Me.colDataType.Caption = "DataType"
        Me.colDataType.FieldName = "DataType"
        Me.colDataType.Name = "colDataType"
        '
        'colFormatingRule
        '
        Me.colFormatingRule.Caption = "FormatingRule"
        Me.colFormatingRule.FieldName = "FormatingRule"
        Me.colFormatingRule.Name = "colFormatingRule"
        '
        'colDataTypeName
        '
        Me.colDataTypeName.Caption = "Data Type"
        Me.colDataTypeName.FieldName = "DataTypeName"
        Me.colDataTypeName.Name = "colDataTypeName"
        Me.colDataTypeName.OptionsColumn.ReadOnly = True
        Me.colDataTypeName.Visible = True
        Me.colDataTypeName.VisibleIndex = 1
        Me.colDataTypeName.Width = 120
        '
        'colFormatingRuleName
        '
        Me.colFormatingRuleName.Caption = "Format Rule"
        Me.colFormatingRuleName.FieldName = "FormatingRuleName"
        Me.colFormatingRuleName.Name = "colFormatingRuleName"
        Me.colFormatingRuleName.OptionsColumn.ReadOnly = True
        Me.colFormatingRuleName.Visible = True
        Me.colFormatingRuleName.VisibleIndex = 2
        Me.colFormatingRuleName.Width = 120
        '
        'colFormatingRuleID
        '
        Me.colFormatingRuleID.Caption = "FormatingRuleID"
        Me.colFormatingRuleID.FieldName = "FormatingRuleID"
        Me.colFormatingRuleID.Name = "colFormatingRuleID"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.Label9)
        Me.GroupBox1.Controls.Add(Me.cboDelimeterType)
        Me.GroupBox1.Controls.Add(Me.chkUseQuotedIdentifier)
        Me.GroupBox1.Controls.Add(Me.txtDescription)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.cboEncodingType)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.chkTrimStrings)
        Me.GroupBox1.Controls.Add(Me.chkImportAsString)
        Me.GroupBox1.Controls.Add(Me.chkFixedLength)
        Me.GroupBox1.Controls.Add(Me.lblTemplateID)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.txtTemplateName)
        Me.GroupBox1.Controls.Add(Me.Label1)
        Me.GroupBox1.Location = New System.Drawing.Point(6, 6)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(742, 274)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(435, 45)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(81, 13)
        Me.Label9.TabIndex = 13
        Me.Label9.Text = "Delimeter Type:"
        '
        'cboDelimeterType
        '
        Me.cboDelimeterType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDelimeterType.FormattingEnabled = True
        Me.cboDelimeterType.Location = New System.Drawing.Point(522, 42)
        Me.cboDelimeterType.Name = "cboDelimeterType"
        Me.cboDelimeterType.Size = New System.Drawing.Size(198, 21)
        Me.cboDelimeterType.TabIndex = 2
        '
        'chkUseQuotedIdentifier
        '
        Me.chkUseQuotedIdentifier.AutoSize = True
        Me.chkUseQuotedIdentifier.Enabled = False
        Me.chkUseQuotedIdentifier.Location = New System.Drawing.Point(336, 108)
        Me.chkUseQuotedIdentifier.Name = "chkUseQuotedIdentifier"
        Me.chkUseQuotedIdentifier.Size = New System.Drawing.Size(126, 17)
        Me.chkUseQuotedIdentifier.TabIndex = 7
        Me.chkUseQuotedIdentifier.Text = "Use Quoted Identifier"
        Me.chkUseQuotedIdentifier.UseVisualStyleBackColor = True
        '
        'txtDescription
        '
        Me.txtDescription.Location = New System.Drawing.Point(20, 173)
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtDescription.Size = New System.Drawing.Size(700, 79)
        Me.txtDescription.TabIndex = 8
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(17, 157)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(110, 13)
        Me.Label4.TabIndex = 10
        Me.Label4.Text = "Template Description:"
        '
        'cboEncodingType
        '
        Me.cboEncodingType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboEncodingType.FormattingEnabled = True
        Me.cboEncodingType.Location = New System.Drawing.Point(125, 72)
        Me.cboEncodingType.Name = "cboEncodingType"
        Me.cboEncodingType.Size = New System.Drawing.Size(281, 21)
        Me.cboEncodingType.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(17, 72)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(82, 13)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Encoding Type:"
        '
        'chkTrimStrings
        '
        Me.chkTrimStrings.AutoSize = True
        Me.chkTrimStrings.Checked = True
        Me.chkTrimStrings.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkTrimStrings.Location = New System.Drawing.Point(249, 108)
        Me.chkTrimStrings.Name = "chkTrimStrings"
        Me.chkTrimStrings.Size = New System.Drawing.Size(81, 17)
        Me.chkTrimStrings.TabIndex = 6
        Me.chkTrimStrings.Text = "Trim Strings"
        Me.chkTrimStrings.UseVisualStyleBackColor = True
        '
        'chkImportAsString
        '
        Me.chkImportAsString.AutoSize = True
        Me.chkImportAsString.Enabled = False
        Me.chkImportAsString.Location = New System.Drawing.Point(143, 108)
        Me.chkImportAsString.Name = "chkImportAsString"
        Me.chkImportAsString.Size = New System.Drawing.Size(100, 17)
        Me.chkImportAsString.TabIndex = 5
        Me.chkImportAsString.Text = "Import As String"
        Me.chkImportAsString.UseVisualStyleBackColor = True
        '
        'chkFixedLength
        '
        Me.chkFixedLength.AutoSize = True
        Me.chkFixedLength.Location = New System.Drawing.Point(20, 108)
        Me.chkFixedLength.Name = "chkFixedLength"
        Me.chkFixedLength.Size = New System.Drawing.Size(117, 17)
        Me.chkFixedLength.TabIndex = 4
        Me.chkFixedLength.Text = "Is Fixed Length File"
        Me.chkFixedLength.UseVisualStyleBackColor = True
        '
        'lblTemplateID
        '
        Me.lblTemplateID.AutoSize = True
        Me.lblTemplateID.Location = New System.Drawing.Point(122, 16)
        Me.lblTemplateID.Name = "lblTemplateID"
        Me.lblTemplateID.Size = New System.Drawing.Size(39, 13)
        Me.lblTemplateID.TabIndex = 3
        Me.lblTemplateID.Text = "Label3"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(17, 16)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(68, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Template ID:"
        '
        'txtTemplateName
        '
        Me.txtTemplateName.Location = New System.Drawing.Point(125, 42)
        Me.txtTemplateName.Name = "txtTemplateName"
        Me.txtTemplateName.Size = New System.Drawing.Size(281, 20)
        Me.txtTemplateName.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(17, 42)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(85, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Template Name:"
        '
        'tabColumnDefinitions
        '
        Me.tabColumnDefinitions.Controls.Add(Me.GroupBox4)
        Me.tabColumnDefinitions.Controls.Add(Me.GroupBox3)
        Me.tabColumnDefinitions.Location = New System.Drawing.Point(4, 22)
        Me.tabColumnDefinitions.Name = "tabColumnDefinitions"
        Me.tabColumnDefinitions.Padding = New System.Windows.Forms.Padding(3)
        Me.tabColumnDefinitions.Size = New System.Drawing.Size(754, 598)
        Me.tabColumnDefinitions.TabIndex = 1
        Me.tabColumnDefinitions.Text = "Column Definitions"
        Me.tabColumnDefinitions.UseVisualStyleBackColor = True
        '
        'GroupBox4
        '
        Me.GroupBox4.Controls.Add(Me.cboFormatingRules)
        Me.GroupBox4.Controls.Add(Me.Label8)
        Me.GroupBox4.Controls.Add(Me.txtFixedLengthStringLength)
        Me.GroupBox4.Controls.Add(Me.Label7)
        Me.GroupBox4.Controls.Add(Me.txtColumnName)
        Me.GroupBox4.Controls.Add(Me.cboDataTypes)
        Me.GroupBox4.Controls.Add(Me.Label6)
        Me.GroupBox4.Controls.Add(Me.Label5)
        Me.GroupBox4.Controls.Add(Me.cmdMoveDown)
        Me.GroupBox4.Controls.Add(Me.cmdMoveUp)
        Me.GroupBox4.Controls.Add(Me.cmdCopyColumn)
        Me.GroupBox4.Controls.Add(Me.cmdRemoveColumn)
        Me.GroupBox4.Controls.Add(Me.cmdEditColumn)
        Me.GroupBox4.Controls.Add(Me.cmdAddColumn)
        Me.GroupBox4.Location = New System.Drawing.Point(6, 6)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.Size = New System.Drawing.Size(742, 184)
        Me.GroupBox4.TabIndex = 1
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Column Actions"
        '
        'cboFormatingRules
        '
        Me.cboFormatingRules.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboFormatingRules.FormattingEnabled = True
        Me.cboFormatingRules.ItemHeight = 13
        Me.cboFormatingRules.Location = New System.Drawing.Point(526, 51)
        Me.cboFormatingRules.Name = "cboFormatingRules"
        Me.cboFormatingRules.Size = New System.Drawing.Size(121, 21)
        Me.cboFormatingRules.TabIndex = 13
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(439, 54)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(81, 13)
        Me.Label8.TabIndex = 12
        Me.Label8.Text = "Formating Rule:"
        '
        'txtFixedLengthStringLength
        '
        Me.txtFixedLengthStringLength.Location = New System.Drawing.Point(160, 51)
        Me.txtFixedLengthStringLength.Name = "txtFixedLengthStringLength"
        Me.txtFixedLengthStringLength.Size = New System.Drawing.Size(100, 20)
        Me.txtFixedLengthStringLength.TabIndex = 13
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(6, 51)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(137, 13)
        Me.Label7.TabIndex = 10
        Me.Label7.Text = "Fixed Length String Length:"
        '
        'txtColumnName
        '
        Me.txtColumnName.Location = New System.Drawing.Point(160, 17)
        Me.txtColumnName.Name = "txtColumnName"
        Me.txtColumnName.Size = New System.Drawing.Size(271, 20)
        Me.txtColumnName.TabIndex = 11
        '
        'cboDataTypes
        '
        Me.cboDataTypes.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboDataTypes.FormattingEnabled = True
        Me.cboDataTypes.Location = New System.Drawing.Point(526, 16)
        Me.cboDataTypes.Name = "cboDataTypes"
        Me.cboDataTypes.Size = New System.Drawing.Size(121, 21)
        Me.cboDataTypes.TabIndex = 12
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(460, 20)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(60, 13)
        Me.Label6.TabIndex = 7
        Me.Label6.Text = "Data Type:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(6, 20)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(76, 13)
        Me.Label5.TabIndex = 6
        Me.Label5.Text = "Column Name:"
        '
        'cmdMoveDown
        '
        Me.cmdMoveDown.Location = New System.Drawing.Point(526, 96)
        Me.cmdMoveDown.Name = "cmdMoveDown"
        Me.cmdMoveDown.Size = New System.Drawing.Size(98, 23)
        Me.cmdMoveDown.TabIndex = 20
        Me.cmdMoveDown.Text = "Move Down"
        Me.cmdMoveDown.UseVisualStyleBackColor = True
        '
        'cmdMoveUp
        '
        Me.cmdMoveUp.Location = New System.Drawing.Point(422, 96)
        Me.cmdMoveUp.Name = "cmdMoveUp"
        Me.cmdMoveUp.Size = New System.Drawing.Size(98, 23)
        Me.cmdMoveUp.TabIndex = 19
        Me.cmdMoveUp.Text = "Move Up"
        Me.cmdMoveUp.UseVisualStyleBackColor = True
        '
        'cmdCopyColumn
        '
        Me.cmdCopyColumn.Location = New System.Drawing.Point(318, 95)
        Me.cmdCopyColumn.Name = "cmdCopyColumn"
        Me.cmdCopyColumn.Size = New System.Drawing.Size(98, 23)
        Me.cmdCopyColumn.TabIndex = 18
        Me.cmdCopyColumn.Text = "Copy Column"
        Me.cmdCopyColumn.UseVisualStyleBackColor = True
        '
        'cmdRemoveColumn
        '
        Me.cmdRemoveColumn.Location = New System.Drawing.Point(6, 96)
        Me.cmdRemoveColumn.Name = "cmdRemoveColumn"
        Me.cmdRemoveColumn.Size = New System.Drawing.Size(98, 23)
        Me.cmdRemoveColumn.TabIndex = 15
        Me.cmdRemoveColumn.Text = "Remove Column"
        Me.cmdRemoveColumn.UseVisualStyleBackColor = True
        '
        'cmdEditColumn
        '
        Me.cmdEditColumn.Location = New System.Drawing.Point(214, 95)
        Me.cmdEditColumn.Name = "cmdEditColumn"
        Me.cmdEditColumn.Size = New System.Drawing.Size(98, 23)
        Me.cmdEditColumn.TabIndex = 17
        Me.cmdEditColumn.Text = "Edit Column"
        Me.cmdEditColumn.UseVisualStyleBackColor = True
        '
        'cmdAddColumn
        '
        Me.cmdAddColumn.Location = New System.Drawing.Point(110, 96)
        Me.cmdAddColumn.Name = "cmdAddColumn"
        Me.cmdAddColumn.Size = New System.Drawing.Size(98, 23)
        Me.cmdAddColumn.TabIndex = 16
        Me.cmdAddColumn.Text = "Add Column"
        Me.cmdAddColumn.UseVisualStyleBackColor = True
        '
        'GroupBox3
        '
        Me.GroupBox3.Controls.Add(Me.grdColumns)
        Me.GroupBox3.Location = New System.Drawing.Point(6, 209)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.Size = New System.Drawing.Size(742, 335)
        Me.GroupBox3.TabIndex = 0
        Me.GroupBox3.TabStop = False
        Me.GroupBox3.Text = "Current Column Definitions"
        '
        'grdColumns
        '
        Me.grdColumns.DataSource = Me.bsColumnDefinitions
        Me.grdColumns.EmbeddedNavigator.Name = ""
        Me.grdColumns.Location = New System.Drawing.Point(6, 19)
        Me.grdColumns.MainView = Me.grdColumnsView
        Me.grdColumns.Name = "grdColumns"
        Me.grdColumns.Size = New System.Drawing.Size(730, 302)
        Me.grdColumns.TabIndex = 21
        Me.grdColumns.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdColumnsView})
        '
        'grdColumnsView
        '
        Me.grdColumnsView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colColumnDefID1, Me.colFileTemplateID1, Me.colName1, Me.colOrdinal1, Me.colFixedStringLength1, Me.colDateTypeID1, Me.colDateCreated1, Me.colActive1, Me.colArchive1, Me.colDataType1, Me.colFormatingRule1, Me.colDataTypeName1, Me.colFormatingRuleName1, Me.colFormatingRuleID1})
        Me.grdColumnsView.GridControl = Me.grdColumns
        Me.grdColumnsView.Name = "grdColumnsView"
        Me.grdColumnsView.OptionsBehavior.Editable = False
        Me.grdColumnsView.OptionsCustomization.AllowColumnMoving = False
        Me.grdColumnsView.OptionsCustomization.AllowFilter = False
        Me.grdColumnsView.OptionsCustomization.AllowGroup = False
        Me.grdColumnsView.OptionsCustomization.AllowSort = False
        Me.grdColumnsView.OptionsFilter.AllowFilterEditor = False
        Me.grdColumnsView.OptionsView.ShowGroupPanel = False
        Me.grdColumnsView.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colOrdinal1, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colColumnDefID1
        '
        Me.colColumnDefID1.Caption = "ColumnDefID"
        Me.colColumnDefID1.FieldName = "ColumnDefID"
        Me.colColumnDefID1.Name = "colColumnDefID1"
        Me.colColumnDefID1.OptionsColumn.ReadOnly = True
        '
        'colFileTemplateID1
        '
        Me.colFileTemplateID1.Caption = "FileTemplateID"
        Me.colFileTemplateID1.FieldName = "FileTemplateID"
        Me.colFileTemplateID1.Name = "colFileTemplateID1"
        '
        'colName1
        '
        Me.colName1.Caption = "Column Name"
        Me.colName1.FieldName = "Name"
        Me.colName1.Name = "colName1"
        Me.colName1.Visible = True
        Me.colName1.VisibleIndex = 0
        Me.colName1.Width = 222
        '
        'colOrdinal1
        '
        Me.colOrdinal1.Caption = "Ordinal"
        Me.colOrdinal1.FieldName = "Ordinal"
        Me.colOrdinal1.Name = "colOrdinal1"
        Me.colOrdinal1.Visible = True
        Me.colOrdinal1.VisibleIndex = 3
        Me.colOrdinal1.Width = 120
        '
        'colFixedStringLength1
        '
        Me.colFixedStringLength1.Caption = "Fixed String Length"
        Me.colFixedStringLength1.FieldName = "FixedStringLength"
        Me.colFixedStringLength1.Name = "colFixedStringLength1"
        Me.colFixedStringLength1.Visible = True
        Me.colFixedStringLength1.VisibleIndex = 4
        Me.colFixedStringLength1.Width = 127
        '
        'colDateTypeID1
        '
        Me.colDateTypeID1.Caption = "DateTypeID"
        Me.colDateTypeID1.FieldName = "DateTypeID"
        Me.colDateTypeID1.Name = "colDateTypeID1"
        '
        'colDateCreated1
        '
        Me.colDateCreated1.Caption = "DateCreated"
        Me.colDateCreated1.FieldName = "DateCreated"
        Me.colDateCreated1.Name = "colDateCreated1"
        '
        'colActive1
        '
        Me.colActive1.Caption = "Active"
        Me.colActive1.FieldName = "Active"
        Me.colActive1.Name = "colActive1"
        '
        'colArchive1
        '
        Me.colArchive1.Caption = "Archive"
        Me.colArchive1.FieldName = "Archive"
        Me.colArchive1.Name = "colArchive1"
        '
        'colDataType1
        '
        Me.colDataType1.Caption = "DataType"
        Me.colDataType1.FieldName = "DataType"
        Me.colDataType1.Name = "colDataType1"
        '
        'colFormatingRule1
        '
        Me.colFormatingRule1.Caption = "FormatingRule"
        Me.colFormatingRule1.FieldName = "FormatingRule"
        Me.colFormatingRule1.Name = "colFormatingRule1"
        '
        'colDataTypeName1
        '
        Me.colDataTypeName1.Caption = "Data Type"
        Me.colDataTypeName1.FieldName = "DataTypeName"
        Me.colDataTypeName1.Name = "colDataTypeName1"
        Me.colDataTypeName1.OptionsColumn.ReadOnly = True
        Me.colDataTypeName1.Visible = True
        Me.colDataTypeName1.VisibleIndex = 1
        Me.colDataTypeName1.Width = 120
        '
        'colFormatingRuleName1
        '
        Me.colFormatingRuleName1.Caption = "Format Rule"
        Me.colFormatingRuleName1.FieldName = "FormatingRuleName"
        Me.colFormatingRuleName1.Name = "colFormatingRuleName1"
        Me.colFormatingRuleName1.OptionsColumn.ReadOnly = True
        Me.colFormatingRuleName1.Visible = True
        Me.colFormatingRuleName1.VisibleIndex = 2
        Me.colFormatingRuleName1.Width = 120
        '
        'colFormatingRuleID1
        '
        Me.colFormatingRuleID1.Caption = "FormatingRuleID"
        Me.colFormatingRuleID1.FieldName = "FormatingRuleID"
        Me.colFormatingRuleID1.Name = "colFormatingRuleID1"
        '
        'FileTemplateSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.panelFileTemplate)
        Me.Name = "FileTemplateSection"
        Me.Size = New System.Drawing.Size(792, 708)
        Me.panelFileTemplate.ResumeLayout(False)
        Me.TabControl1.ResumeLayout(False)
        Me.tabTemplateDefinition.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        CType(Me.grdSampleTemplate, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsColumnDefinitions, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.tabColumnDefinitions.ResumeLayout(False)
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        Me.GroupBox3.ResumeLayout(False)
        CType(Me.grdColumns, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdColumnsView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents panelFileTemplate As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents tabTemplateDefinition As System.Windows.Forms.TabPage
    Friend WithEvents tabColumnDefinitions As System.Windows.Forms.TabPage
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents lblTemplateID As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtTemplateName As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents cboEncodingType As System.Windows.Forms.ComboBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents chkTrimStrings As System.Windows.Forms.CheckBox
    Friend WithEvents chkImportAsString As System.Windows.Forms.CheckBox
    Friend WithEvents chkFixedLength As System.Windows.Forms.CheckBox
    Friend WithEvents cmdOK As System.Windows.Forms.Button
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents grdSampleTemplate As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Friend WithEvents cmdCopyColumn As System.Windows.Forms.Button
    Friend WithEvents cmdRemoveColumn As System.Windows.Forms.Button
    Friend WithEvents cmdEditColumn As System.Windows.Forms.Button
    Friend WithEvents cmdAddColumn As System.Windows.Forms.Button
    Friend WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Friend WithEvents cmdMoveDown As System.Windows.Forms.Button
    Friend WithEvents cmdMoveUp As System.Windows.Forms.Button
    Friend WithEvents grdColumns As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdColumnsView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents bsColumnDefinitions As System.Windows.Forms.BindingSource
    Friend WithEvents txtColumnName As System.Windows.Forms.TextBox
    Friend WithEvents cboDataTypes As System.Windows.Forms.ComboBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents txtFixedLengthStringLength As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents cboFormatingRules As System.Windows.Forms.ComboBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents colColumnDefID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileTemplateID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOrdinal As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFixedStringLength As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateTypeID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colActive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colArchive As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDataType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRule As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDataTypeName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRuleName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRuleID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colColumnDefID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileTemplateID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOrdinal1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFixedStringLength1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateTypeID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colActive1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colArchive1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDataType1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRule1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDataTypeName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRuleName1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFormatingRuleID1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents cboDelimeterType As System.Windows.Forms.ComboBox
    Friend WithEvents chkUseQuotedIdentifier As System.Windows.Forms.CheckBox

End Class
