<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportDefQMSDeDupRule
    Inherits Nrc.Framework.WinForms.DialogForm

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
        Me.cmdOK = New System.Windows.Forms.Button
        Me.cmdCancel = New System.Windows.Forms.Button
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.lstClients = New System.Windows.Forms.ListBox
        Me.txtRuleName = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.chkActiveSIOnly = New System.Windows.Forms.CheckBox
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.grdColumnMaps = New DevExpress.XtraGrid.GridControl
        Me.bsColMap = New System.Windows.Forms.BindingSource(Me.components)
        Me.grdColMapsView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDeDupRuleID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colQMSColumnName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFileTemplateColumnName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.cboTemplateColumns = New System.Windows.Forms.ComboBox
        Me.cboQMSColumn = New System.Windows.Forms.ComboBox
        Me.cmdRemoveMapping = New System.Windows.Forms.Button
        Me.cmdAddMapping = New System.Windows.Forms.Button
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        CType(Me.grdColumnMaps, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsColMap, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdColMapsView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "QMS De-Dep Rule"
        Me.mPaneCaption.Size = New System.Drawing.Size(560, 26)
        Me.mPaneCaption.Text = "QMS De-Dep Rule"
        '
        'cmdOK
        '
        Me.cmdOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdOK.Location = New System.Drawing.Point(402, 563)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(75, 23)
        Me.cmdOK.TabIndex = 1
        Me.cmdOK.Text = "&Ok"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.Location = New System.Drawing.Point(483, 563)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 2
        Me.cmdCancel.Text = "&Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.lstClients)
        Me.GroupBox1.Controls.Add(Me.txtRuleName)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Controls.Add(Me.Label2)
        Me.GroupBox1.Controls.Add(Me.chkActiveSIOnly)
        Me.GroupBox1.Location = New System.Drawing.Point(4, 33)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(550, 272)
        Me.GroupBox1.TabIndex = 3
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Rule Configuration"
        '
        'lstClients
        '
        Me.lstClients.FormattingEnabled = True
        Me.lstClients.Location = New System.Drawing.Point(9, 89)
        Me.lstClients.Name = "lstClients"
        Me.lstClients.SelectionMode = System.Windows.Forms.SelectionMode.MultiSimple
        Me.lstClients.Size = New System.Drawing.Size(528, 173)
        Me.lstClients.TabIndex = 7
        '
        'txtRuleName
        '
        Me.txtRuleName.Location = New System.Drawing.Point(75, 27)
        Me.txtRuleName.Name = "txtRuleName"
        Me.txtRuleName.Size = New System.Drawing.Size(462, 20)
        Me.txtRuleName.TabIndex = 6
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(6, 27)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(63, 13)
        Me.Label3.TabIndex = 5
        Me.Label3.Text = "Rule Name:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(7, 73)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(38, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Clients"
        '
        'chkActiveSIOnly
        '
        Me.chkActiveSIOnly.AutoSize = True
        Me.chkActiveSIOnly.Checked = True
        Me.chkActiveSIOnly.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkActiveSIOnly.Location = New System.Drawing.Point(10, 53)
        Me.chkActiveSIOnly.Name = "chkActiveSIOnly"
        Me.chkActiveSIOnly.Size = New System.Drawing.Size(165, 17)
        Me.chkActiveSIOnly.TabIndex = 0
        Me.chkActiveSIOnly.Text = "Active Survey Instances Only"
        Me.chkActiveSIOnly.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.grdColumnMaps)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.Label4)
        Me.GroupBox2.Controls.Add(Me.cboTemplateColumns)
        Me.GroupBox2.Controls.Add(Me.cboQMSColumn)
        Me.GroupBox2.Controls.Add(Me.cmdRemoveMapping)
        Me.GroupBox2.Controls.Add(Me.cmdAddMapping)
        Me.GroupBox2.Location = New System.Drawing.Point(4, 311)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(550, 246)
        Me.GroupBox2.TabIndex = 4
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Rule Mapping"
        '
        'grdColumnMaps
        '
        Me.grdColumnMaps.DataSource = Me.bsColMap
        Me.grdColumnMaps.EmbeddedNavigator.Name = ""
        Me.grdColumnMaps.Location = New System.Drawing.Point(10, 88)
        Me.grdColumnMaps.MainView = Me.grdColMapsView
        Me.grdColumnMaps.Name = "grdColumnMaps"
        Me.grdColumnMaps.Size = New System.Drawing.Size(527, 152)
        Me.grdColumnMaps.TabIndex = 6
        Me.grdColumnMaps.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.grdColMapsView})
        '
        'bsColMap
        '
        Me.bsColMap.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_DeDupRuleColumnMap)
        '
        'grdColMapsView
        '
        Me.grdColMapsView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colID, Me.colDeDupRuleID, Me.colQMSColumnName, Me.colFileTemplateColumnName})
        Me.grdColMapsView.GridControl = Me.grdColumnMaps
        Me.grdColMapsView.Name = "grdColMapsView"
        Me.grdColMapsView.OptionsBehavior.Editable = False
        Me.grdColMapsView.OptionsCustomization.AllowColumnMoving = False
        Me.grdColMapsView.OptionsCustomization.AllowFilter = False
        Me.grdColMapsView.OptionsCustomization.AllowGroup = False
        Me.grdColMapsView.OptionsCustomization.AllowSort = False
        Me.grdColMapsView.OptionsFilter.AllowColumnMRUFilterList = False
        Me.grdColMapsView.OptionsFilter.AllowFilterEditor = False
        Me.grdColMapsView.OptionsFilter.AllowMRUFilterList = False
        '
        'colID
        '
        Me.colID.Caption = "ID"
        Me.colID.FieldName = "ID"
        Me.colID.Name = "colID"
        Me.colID.OptionsColumn.ReadOnly = True
        '
        'colDeDupRuleID
        '
        Me.colDeDupRuleID.Caption = "DeDupRuleID"
        Me.colDeDupRuleID.FieldName = "DeDupRuleID"
        Me.colDeDupRuleID.Name = "colDeDupRuleID"
        '
        'colQMSColumnName
        '
        Me.colQMSColumnName.Caption = "QMS Column Name"
        Me.colQMSColumnName.FieldName = "QMSColumnName"
        Me.colQMSColumnName.Name = "colQMSColumnName"
        Me.colQMSColumnName.Visible = True
        Me.colQMSColumnName.VisibleIndex = 0
        '
        'colFileTemplateColumnName
        '
        Me.colFileTemplateColumnName.Caption = "File Template Column Name"
        Me.colFileTemplateColumnName.FieldName = "FileTemplateColumnName"
        Me.colFileTemplateColumnName.Name = "colFileTemplateColumnName"
        Me.colFileTemplateColumnName.Visible = True
        Me.colFileTemplateColumnName.VisibleIndex = 1
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(280, 45)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(92, 13)
        Me.Label5.TabIndex = 5
        Me.Label5.Text = "Template Column:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(13, 45)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(72, 13)
        Me.Label4.TabIndex = 4
        Me.Label4.Text = "QMS Column:"
        '
        'cboTemplateColumns
        '
        Me.cboTemplateColumns.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboTemplateColumns.FormattingEnabled = True
        Me.cboTemplateColumns.Location = New System.Drawing.Point(283, 61)
        Me.cboTemplateColumns.Name = "cboTemplateColumns"
        Me.cboTemplateColumns.Size = New System.Drawing.Size(254, 21)
        Me.cboTemplateColumns.TabIndex = 3
        '
        'cboQMSColumn
        '
        Me.cboQMSColumn.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboQMSColumn.FormattingEnabled = True
        Me.cboQMSColumn.Location = New System.Drawing.Point(16, 61)
        Me.cboQMSColumn.Name = "cboQMSColumn"
        Me.cboQMSColumn.Size = New System.Drawing.Size(247, 21)
        Me.cboQMSColumn.TabIndex = 2
        '
        'cmdRemoveMapping
        '
        Me.cmdRemoveMapping.Location = New System.Drawing.Point(91, 19)
        Me.cmdRemoveMapping.Name = "cmdRemoveMapping"
        Me.cmdRemoveMapping.Size = New System.Drawing.Size(75, 23)
        Me.cmdRemoveMapping.TabIndex = 1
        Me.cmdRemoveMapping.Text = "&Remove"
        Me.cmdRemoveMapping.UseVisualStyleBackColor = True
        '
        'cmdAddMapping
        '
        Me.cmdAddMapping.Location = New System.Drawing.Point(10, 19)
        Me.cmdAddMapping.Name = "cmdAddMapping"
        Me.cmdAddMapping.Size = New System.Drawing.Size(75, 23)
        Me.cmdAddMapping.TabIndex = 0
        Me.cmdAddMapping.Text = "&Add"
        Me.cmdAddMapping.UseVisualStyleBackColor = True
        '
        'ExportDefQMSDeDupRule
        '
        Me.Caption = "QMS De-Dep Rule"
        Me.ClientSize = New System.Drawing.Size(562, 605)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.cmdOK)
        Me.Name = "ExportDefQMSDeDupRule"
        Me.Controls.SetChildIndex(Me.cmdOK, 0)
        Me.Controls.SetChildIndex(Me.cmdCancel, 0)
        Me.Controls.SetChildIndex(Me.GroupBox2, 0)
        Me.Controls.SetChildIndex(Me.GroupBox1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        CType(Me.grdColumnMaps, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsColMap, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdColMapsView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents cmdOK As System.Windows.Forms.Button
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents chkActiveSIOnly As System.Windows.Forms.CheckBox
    Friend WithEvents txtRuleName As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents cboQMSColumn As System.Windows.Forms.ComboBox
    Friend WithEvents cmdRemoveMapping As System.Windows.Forms.Button
    Friend WithEvents cmdAddMapping As System.Windows.Forms.Button
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents cboTemplateColumns As System.Windows.Forms.ComboBox
    Friend WithEvents lstClients As System.Windows.Forms.ListBox
    Friend WithEvents bsColMap As System.Windows.Forms.BindingSource
    Friend WithEvents grdColumnMaps As DevExpress.XtraGrid.GridControl
    Friend WithEvents grdColMapsView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDeDupRuleID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colQMSColumnName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFileTemplateColumnName As DevExpress.XtraGrid.Columns.GridColumn

End Class
