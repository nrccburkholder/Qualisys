<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class PrivilegeEditor
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
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(PrivilegeEditor))
        Me.PrivilegeTree = New DevExpress.XtraTreeList.TreeList
        Me.colApplication = New DevExpress.XtraTreeList.Columns.TreeListColumn
        Me.colAllow = New DevExpress.XtraTreeList.Columns.TreeListColumn
        Me.RepositoryItemCheckEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.colDateRevoked = New DevExpress.XtraTreeList.Columns.TreeListColumn
        Me.RepositoryItemDateEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
        Me.CheckBoxImages = New System.Windows.Forms.ImageList(Me.components)
        Me.ToolTipController1 = New DevExpress.Utils.ToolTipController(Me.components)
        Me.WarningLabel = New System.Windows.Forms.Label
        Me.BulkEditOptionsPanel = New System.Windows.Forms.Panel
        Me.BulkEditOptionList = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        CType(Me.PrivilegeTree, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemDateEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.BulkEditOptionsPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'PrivilegeTree
        '
        Me.PrivilegeTree.Appearance.Empty.BackColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.Empty.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.EvenRow.BackColor = System.Drawing.Color.FromArgb(CType(CType(231, Byte), Integer), CType(CType(242, Byte), Integer), CType(CType(254, Byte), Integer))
        Me.PrivilegeTree.Appearance.EvenRow.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.EvenRow.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.EvenRow.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.FocusedCell.BackColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.FocusedCell.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.FocusedCell.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.FocusedCell.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.FocusedRow.BackColor = System.Drawing.Color.FromArgb(CType(CType(49, Byte), Integer), CType(CType(106, Byte), Integer), CType(CType(197, Byte), Integer))
        Me.PrivilegeTree.Appearance.FocusedRow.ForeColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.FocusedRow.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.FocusedRow.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.FooterPanel.BackColor = System.Drawing.Color.FromArgb(CType(CType(221, Byte), Integer), CType(CType(236, Byte), Integer), CType(CType(254, Byte), Integer))
        Me.PrivilegeTree.Appearance.FooterPanel.BackColor2 = System.Drawing.Color.FromArgb(CType(CType(132, Byte), Integer), CType(CType(171, Byte), Integer), CType(CType(228, Byte), Integer))
        Me.PrivilegeTree.Appearance.FooterPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(221, Byte), Integer), CType(CType(236, Byte), Integer), CType(CType(254, Byte), Integer))
        Me.PrivilegeTree.Appearance.FooterPanel.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.FooterPanel.GradientMode = System.Drawing.Drawing2D.LinearGradientMode.Vertical
        Me.PrivilegeTree.Appearance.FooterPanel.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.FooterPanel.Options.UseBorderColor = True
        Me.PrivilegeTree.Appearance.FooterPanel.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.GroupButton.BackColor = System.Drawing.Color.FromArgb(CType(CType(193, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(247, Byte), Integer))
        Me.PrivilegeTree.Appearance.GroupButton.BorderColor = System.Drawing.Color.FromArgb(CType(CType(193, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(247, Byte), Integer))
        Me.PrivilegeTree.Appearance.GroupButton.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.GroupButton.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.GroupButton.Options.UseBorderColor = True
        Me.PrivilegeTree.Appearance.GroupButton.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.GroupFooter.BackColor = System.Drawing.Color.FromArgb(CType(CType(193, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(247, Byte), Integer))
        Me.PrivilegeTree.Appearance.GroupFooter.BorderColor = System.Drawing.Color.FromArgb(CType(CType(193, Byte), Integer), CType(CType(216, Byte), Integer), CType(CType(247, Byte), Integer))
        Me.PrivilegeTree.Appearance.GroupFooter.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.GroupFooter.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.GroupFooter.Options.UseBorderColor = True
        Me.PrivilegeTree.Appearance.GroupFooter.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.HeaderPanel.BackColor = System.Drawing.Color.FromArgb(CType(CType(221, Byte), Integer), CType(CType(236, Byte), Integer), CType(CType(254, Byte), Integer))
        Me.PrivilegeTree.Appearance.HeaderPanel.BackColor2 = System.Drawing.Color.FromArgb(CType(CType(132, Byte), Integer), CType(CType(171, Byte), Integer), CType(CType(228, Byte), Integer))
        Me.PrivilegeTree.Appearance.HeaderPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(221, Byte), Integer), CType(CType(236, Byte), Integer), CType(CType(254, Byte), Integer))
        Me.PrivilegeTree.Appearance.HeaderPanel.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.HeaderPanel.GradientMode = System.Drawing.Drawing2D.LinearGradientMode.Vertical
        Me.PrivilegeTree.Appearance.HeaderPanel.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.HeaderPanel.Options.UseBorderColor = True
        Me.PrivilegeTree.Appearance.HeaderPanel.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.HideSelectionRow.BackColor = System.Drawing.Color.FromArgb(CType(CType(106, Byte), Integer), CType(CType(153, Byte), Integer), CType(CType(228, Byte), Integer))
        Me.PrivilegeTree.Appearance.HideSelectionRow.ForeColor = System.Drawing.Color.FromArgb(CType(CType(208, Byte), Integer), CType(CType(224, Byte), Integer), CType(CType(251, Byte), Integer))
        Me.PrivilegeTree.Appearance.HideSelectionRow.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.HideSelectionRow.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.HorzLine.BackColor = System.Drawing.Color.FromArgb(CType(CType(99, Byte), Integer), CType(CType(127, Byte), Integer), CType(CType(196, Byte), Integer))
        Me.PrivilegeTree.Appearance.HorzLine.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.OddRow.BackColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.OddRow.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.OddRow.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.OddRow.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.Preview.BackColor = System.Drawing.Color.FromArgb(CType(CType(249, Byte), Integer), CType(CType(252, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.PrivilegeTree.Appearance.Preview.ForeColor = System.Drawing.Color.FromArgb(CType(CType(88, Byte), Integer), CType(CType(129, Byte), Integer), CType(CType(185, Byte), Integer))
        Me.PrivilegeTree.Appearance.Preview.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.Preview.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.Row.BackColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.Row.ForeColor = System.Drawing.Color.Black
        Me.PrivilegeTree.Appearance.Row.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.Row.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.SelectedRow.BackColor = System.Drawing.Color.FromArgb(CType(CType(69, Byte), Integer), CType(CType(126, Byte), Integer), CType(CType(217, Byte), Integer))
        Me.PrivilegeTree.Appearance.SelectedRow.ForeColor = System.Drawing.Color.White
        Me.PrivilegeTree.Appearance.SelectedRow.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.SelectedRow.Options.UseForeColor = True
        Me.PrivilegeTree.Appearance.TreeLine.BackColor = System.Drawing.Color.FromArgb(CType(CType(59, Byte), Integer), CType(CType(97, Byte), Integer), CType(CType(156, Byte), Integer))
        Me.PrivilegeTree.Appearance.TreeLine.Options.UseBackColor = True
        Me.PrivilegeTree.Appearance.VertLine.BackColor = System.Drawing.Color.FromArgb(CType(CType(99, Byte), Integer), CType(CType(127, Byte), Integer), CType(CType(196, Byte), Integer))
        Me.PrivilegeTree.Appearance.VertLine.Options.UseBackColor = True
        Me.PrivilegeTree.Columns.AddRange(New DevExpress.XtraTreeList.Columns.TreeListColumn() {Me.colApplication, Me.colAllow, Me.colDateRevoked})
        Me.PrivilegeTree.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PrivilegeTree.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PrivilegeTree.Location = New System.Drawing.Point(0, 46)
        Me.PrivilegeTree.LookAndFeel.Style = DevExpress.LookAndFeel.LookAndFeelStyle.Office2003
        Me.PrivilegeTree.LookAndFeel.UseDefaultLookAndFeel = False
        Me.PrivilegeTree.Name = "PrivilegeTree"
        Me.PrivilegeTree.OptionsView.EnableAppearanceEvenRow = True
        Me.PrivilegeTree.OptionsView.EnableAppearanceOddRow = True
        Me.PrivilegeTree.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemCheckEdit1, Me.RepositoryItemDateEdit1})
        Me.PrivilegeTree.RootValue = "0"
        Me.PrivilegeTree.Size = New System.Drawing.Size(419, 287)
        Me.PrivilegeTree.StateImageList = Me.CheckBoxImages
        Me.PrivilegeTree.TabIndex = 3
        Me.PrivilegeTree.ToolTipController = Me.ToolTipController1
        '
        'colApplication
        '
        Me.colApplication.Caption = "Application Privilege"
        Me.colApplication.FieldName = "Application"
        Me.colApplication.MinWidth = 27
        Me.colApplication.Name = "colApplication"
        Me.colApplication.VisibleIndex = 0
        Me.colApplication.Width = 294
        '
        'colAllow
        '
        Me.colAllow.Caption = "Allow"
        Me.colAllow.ColumnEdit = Me.RepositoryItemCheckEdit1
        Me.colAllow.FieldName = "Allow"
        Me.colAllow.Name = "colAllow"
        Me.colAllow.Width = 32
        '
        'RepositoryItemCheckEdit1
        '
        Me.RepositoryItemCheckEdit1.AllowGrayed = True
        Me.RepositoryItemCheckEdit1.AutoHeight = False
        Me.RepositoryItemCheckEdit1.Name = "RepositoryItemCheckEdit1"
        Me.RepositoryItemCheckEdit1.ValueChecked = 1
        Me.RepositoryItemCheckEdit1.ValueGrayed = 2
        Me.RepositoryItemCheckEdit1.ValueUnchecked = 0
        '
        'colDateRevoked
        '
        Me.colDateRevoked.Caption = "Revoke On"
        Me.colDateRevoked.FieldName = "DateRevoked"
        Me.colDateRevoked.Name = "colDateRevoked"
        Me.colDateRevoked.VisibleIndex = 1
        Me.colDateRevoked.Width = 76
        '
        'RepositoryItemDateEdit1
        '
        Me.RepositoryItemDateEdit1.AutoHeight = False
        Me.RepositoryItemDateEdit1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemDateEdit1.Name = "RepositoryItemDateEdit1"
        Me.RepositoryItemDateEdit1.NullText = "Never"
        '
        'CheckBoxImages
        '
        Me.CheckBoxImages.ImageStream = CType(resources.GetObject("CheckBoxImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.CheckBoxImages.TransparentColor = System.Drawing.Color.Transparent
        Me.CheckBoxImages.Images.SetKeyName(0, "Unchecked")
        Me.CheckBoxImages.Images.SetKeyName(1, "Checked")
        Me.CheckBoxImages.Images.SetKeyName(2, "Indeterminate")
        '
        'WarningLabel
        '
        Me.WarningLabel.BackColor = System.Drawing.Color.LemonChiffon
        Me.WarningLabel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.WarningLabel.Dock = System.Windows.Forms.DockStyle.Top
        Me.WarningLabel.Location = New System.Drawing.Point(0, 0)
        Me.WarningLabel.Name = "WarningLabel"
        Me.WarningLabel.Size = New System.Drawing.Size(419, 20)
        Me.WarningLabel.TabIndex = 4
        Me.WarningLabel.Text = "Warning Message"
        Me.WarningLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.WarningLabel.Visible = False
        '
        'BulkEditOptionsPanel
        '
        Me.BulkEditOptionsPanel.Controls.Add(Me.BulkEditOptionList)
        Me.BulkEditOptionsPanel.Controls.Add(Me.Label1)
        Me.BulkEditOptionsPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.BulkEditOptionsPanel.Location = New System.Drawing.Point(0, 20)
        Me.BulkEditOptionsPanel.Name = "BulkEditOptionsPanel"
        Me.BulkEditOptionsPanel.Size = New System.Drawing.Size(419, 26)
        Me.BulkEditOptionsPanel.TabIndex = 5
        Me.BulkEditOptionsPanel.Visible = False
        '
        'BulkEditOptionList
        '
        Me.BulkEditOptionList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.BulkEditOptionList.FormattingEnabled = True
        Me.BulkEditOptionList.Items.AddRange(New Object() {"Grant additional privileges", "Specify all privileges"})
        Me.BulkEditOptionList.Location = New System.Drawing.Point(101, 2)
        Me.BulkEditOptionList.Name = "BulkEditOptionList"
        Me.BulkEditOptionList.Size = New System.Drawing.Size(168, 21)
        Me.BulkEditOptionList.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(4, 6)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(91, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Bulk Edit Options:"
        '
        'PrivilegeEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.PrivilegeTree)
        Me.Controls.Add(Me.BulkEditOptionsPanel)
        Me.Controls.Add(Me.WarningLabel)
        Me.Name = "PrivilegeEditor"
        Me.Size = New System.Drawing.Size(419, 333)
        CType(Me.PrivilegeTree, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemDateEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.BulkEditOptionsPanel.ResumeLayout(False)
        Me.BulkEditOptionsPanel.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents PrivilegeTree As DevExpress.XtraTreeList.TreeList
    Friend WithEvents colApplication As DevExpress.XtraTreeList.Columns.TreeListColumn
    Friend WithEvents colAllow As DevExpress.XtraTreeList.Columns.TreeListColumn
    Friend WithEvents RepositoryItemCheckEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents RepositoryItemDateEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
    Friend WithEvents ToolTipController1 As DevExpress.Utils.ToolTipController
    Friend WithEvents colDateRevoked As DevExpress.XtraTreeList.Columns.TreeListColumn
    Friend WithEvents CheckBoxImages As System.Windows.Forms.ImageList
    Friend WithEvents WarningLabel As System.Windows.Forms.Label
    Friend WithEvents BulkEditOptionsPanel As System.Windows.Forms.Panel
    Friend WithEvents BulkEditOptionList As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label

End Class
