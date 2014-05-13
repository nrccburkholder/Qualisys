<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ApplicationManagementSection
    Inherits NrcAuthAdmin.Section

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ApplicationManagementSection))
        Me.AppManagementPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.Description = New System.Windows.Forms.TextBox
        Me.ApplicationNameLabel = New System.Windows.Forms.Label
        Me.DeploymentTypeLabel = New System.Windows.Forms.Label
        Me.DescriptionLabel = New System.Windows.Forms.Label
        Me.ApplicationName = New System.Windows.Forms.TextBox
        Me.DeploymentTypeList = New System.Windows.Forms.ComboBox
        Me.ExportImageButton = New System.Windows.Forms.LinkLabel
        Me.ChangeImageButton = New System.Windows.Forms.LinkLabel
        Me.PathLabel = New System.Windows.Forms.Label
        Me.ImageLabel = New System.Windows.Forms.Label
        Me.Category = New System.Windows.Forms.TextBox
        Me.ApplicationImage = New System.Windows.Forms.PictureBox
        Me.CategoryLabel = New System.Windows.Forms.Label
        Me.IsInternalApplication = New System.Windows.Forms.CheckBox
        Me.ApplicationPath = New System.Windows.Forms.TextBox
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.PrivilegeGridControl = New DevExpress.XtraGrid.GridControl
        Me.PrivilegeBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPrivilegeLevel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.PrivilegeBindingNavigator = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.AddGroupPrivilegeButton = New System.Windows.Forms.ToolStripButton
        Me.AddMemberPrivilegeButton = New System.Windows.Forms.ToolStripButton
        Me.OKButton = New System.Windows.Forms.Button
        Me.CancelButton = New System.Windows.Forms.Button
        Me.ImageSelectorDialog = New System.Windows.Forms.OpenFileDialog
        Me.ExportImageDialog = New System.Windows.Forms.SaveFileDialog
        Me.AppManagementPanel.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        CType(Me.ApplicationImage, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SectionPanel1.SuspendLayout()
        CType(Me.PrivilegeGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PrivilegeBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.PrivilegeBindingNavigator, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.PrivilegeBindingNavigator.SuspendLayout()
        Me.SuspendLayout()
        '
        'AppManagementPanel
        '
        Me.AppManagementPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AppManagementPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.AppManagementPanel.Caption = "Application Management"
        Me.AppManagementPanel.Controls.Add(Me.SplitContainer1)
        Me.AppManagementPanel.Location = New System.Drawing.Point(0, 0)
        Me.AppManagementPanel.Name = "AppManagementPanel"
        Me.AppManagementPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.AppManagementPanel.ShowCaption = True
        Me.AppManagementPanel.Size = New System.Drawing.Size(720, 190)
        Me.AppManagementPanel.TabIndex = 0
        '
        'SplitContainer1
        '
        Me.SplitContainer1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SplitContainer1.IsSplitterFixed = True
        Me.SplitContainer1.Location = New System.Drawing.Point(1, 27)
        Me.SplitContainer1.Name = "SplitContainer1"
        '
        'SplitContainer1.Panel1
        '
        Me.SplitContainer1.Panel1.Controls.Add(Me.Description)
        Me.SplitContainer1.Panel1.Controls.Add(Me.ApplicationNameLabel)
        Me.SplitContainer1.Panel1.Controls.Add(Me.DeploymentTypeLabel)
        Me.SplitContainer1.Panel1.Controls.Add(Me.DescriptionLabel)
        Me.SplitContainer1.Panel1.Controls.Add(Me.ApplicationName)
        Me.SplitContainer1.Panel1.Controls.Add(Me.DeploymentTypeList)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.ExportImageButton)
        Me.SplitContainer1.Panel2.Controls.Add(Me.ChangeImageButton)
        Me.SplitContainer1.Panel2.Controls.Add(Me.PathLabel)
        Me.SplitContainer1.Panel2.Controls.Add(Me.ImageLabel)
        Me.SplitContainer1.Panel2.Controls.Add(Me.Category)
        Me.SplitContainer1.Panel2.Controls.Add(Me.ApplicationImage)
        Me.SplitContainer1.Panel2.Controls.Add(Me.CategoryLabel)
        Me.SplitContainer1.Panel2.Controls.Add(Me.IsInternalApplication)
        Me.SplitContainer1.Panel2.Controls.Add(Me.ApplicationPath)
        Me.SplitContainer1.Size = New System.Drawing.Size(718, 159)
        Me.SplitContainer1.SplitterDistance = 356
        Me.SplitContainer1.TabIndex = 0
        '
        'Description
        '
        Me.Description.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Description.Location = New System.Drawing.Point(101, 37)
        Me.Description.Multiline = True
        Me.Description.Name = "Description"
        Me.Description.Size = New System.Drawing.Size(249, 81)
        Me.Description.TabIndex = 1
        '
        'ApplicationNameLabel
        '
        Me.ApplicationNameLabel.AutoSize = True
        Me.ApplicationNameLabel.Location = New System.Drawing.Point(4, 14)
        Me.ApplicationNameLabel.Name = "ApplicationNameLabel"
        Me.ApplicationNameLabel.Size = New System.Drawing.Size(34, 13)
        Me.ApplicationNameLabel.TabIndex = 1
        Me.ApplicationNameLabel.Text = "Name"
        Me.ApplicationNameLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'DeploymentTypeLabel
        '
        Me.DeploymentTypeLabel.AutoSize = True
        Me.DeploymentTypeLabel.Location = New System.Drawing.Point(4, 128)
        Me.DeploymentTypeLabel.Name = "DeploymentTypeLabel"
        Me.DeploymentTypeLabel.Size = New System.Drawing.Size(91, 13)
        Me.DeploymentTypeLabel.TabIndex = 1
        Me.DeploymentTypeLabel.Text = "Deployment Type"
        Me.DeploymentTypeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'DescriptionLabel
        '
        Me.DescriptionLabel.AutoSize = True
        Me.DescriptionLabel.Location = New System.Drawing.Point(4, 37)
        Me.DescriptionLabel.Name = "DescriptionLabel"
        Me.DescriptionLabel.Size = New System.Drawing.Size(60, 13)
        Me.DescriptionLabel.TabIndex = 1
        Me.DescriptionLabel.Text = "Description"
        Me.DescriptionLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ApplicationName
        '
        Me.ApplicationName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplicationName.Location = New System.Drawing.Point(101, 10)
        Me.ApplicationName.Name = "ApplicationName"
        Me.ApplicationName.Size = New System.Drawing.Size(249, 21)
        Me.ApplicationName.TabIndex = 0
        '
        'DeploymentTypeList
        '
        Me.DeploymentTypeList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DeploymentTypeList.FormattingEnabled = True
        Me.DeploymentTypeList.Location = New System.Drawing.Point(101, 124)
        Me.DeploymentTypeList.Name = "DeploymentTypeList"
        Me.DeploymentTypeList.Size = New System.Drawing.Size(249, 21)
        Me.DeploymentTypeList.TabIndex = 2
        '
        'ExportImageButton
        '
        Me.ExportImageButton.AutoSize = True
        Me.ExportImageButton.Location = New System.Drawing.Point(232, 87)
        Me.ExportImageButton.Name = "ExportImageButton"
        Me.ExportImageButton.Size = New System.Drawing.Size(51, 13)
        Me.ExportImageButton.TabIndex = 4
        Me.ExportImageButton.TabStop = True
        Me.ExportImageButton.Text = "Export..."
        '
        'ChangeImageButton
        '
        Me.ChangeImageButton.AutoSize = True
        Me.ChangeImageButton.Location = New System.Drawing.Point(170, 87)
        Me.ChangeImageButton.Name = "ChangeImageButton"
        Me.ChangeImageButton.Size = New System.Drawing.Size(56, 13)
        Me.ChangeImageButton.TabIndex = 3
        Me.ChangeImageButton.TabStop = True
        Me.ChangeImageButton.Text = "Change..."
        '
        'PathLabel
        '
        Me.PathLabel.AutoSize = True
        Me.PathLabel.Location = New System.Drawing.Point(4, 13)
        Me.PathLabel.Name = "PathLabel"
        Me.PathLabel.Size = New System.Drawing.Size(84, 13)
        Me.PathLabel.TabIndex = 1
        Me.PathLabel.Text = "Application Path"
        Me.PathLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ImageLabel
        '
        Me.ImageLabel.AutoSize = True
        Me.ImageLabel.Location = New System.Drawing.Point(4, 87)
        Me.ImageLabel.Name = "ImageLabel"
        Me.ImageLabel.Size = New System.Drawing.Size(92, 13)
        Me.ImageLabel.TabIndex = 1
        Me.ImageLabel.Text = "Application Image"
        Me.ImageLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Category
        '
        Me.Category.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Category.Location = New System.Drawing.Point(132, 37)
        Me.Category.Name = "Category"
        Me.Category.Size = New System.Drawing.Size(220, 21)
        Me.Category.TabIndex = 1
        '
        'ApplicationImage
        '
        Me.ApplicationImage.Location = New System.Drawing.Point(132, 87)
        Me.ApplicationImage.Name = "ApplicationImage"
        Me.ApplicationImage.Size = New System.Drawing.Size(32, 32)
        Me.ApplicationImage.TabIndex = 4
        Me.ApplicationImage.TabStop = False
        '
        'CategoryLabel
        '
        Me.CategoryLabel.AutoSize = True
        Me.CategoryLabel.Location = New System.Drawing.Point(4, 41)
        Me.CategoryLabel.Name = "CategoryLabel"
        Me.CategoryLabel.Size = New System.Drawing.Size(52, 13)
        Me.CategoryLabel.TabIndex = 1
        Me.CategoryLabel.Text = "Category"
        Me.CategoryLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'IsInternalApplication
        '
        Me.IsInternalApplication.AutoSize = True
        Me.IsInternalApplication.CheckAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.IsInternalApplication.Location = New System.Drawing.Point(4, 64)
        Me.IsInternalApplication.Name = "IsInternalApplication"
        Me.IsInternalApplication.Size = New System.Drawing.Size(143, 17)
        Me.IsInternalApplication.TabIndex = 2
        Me.IsInternalApplication.Text = "NRC Internal Application"
        Me.IsInternalApplication.UseVisualStyleBackColor = True
        '
        'ApplicationPath
        '
        Me.ApplicationPath.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ApplicationPath.Location = New System.Drawing.Point(132, 10)
        Me.ApplicationPath.Name = "ApplicationPath"
        Me.ApplicationPath.Size = New System.Drawing.Size(220, 21)
        Me.ApplicationPath.TabIndex = 0
        '
        'SectionPanel1
        '
        Me.SectionPanel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.SectionPanel1.Caption = "Application Privileges"
        Me.SectionPanel1.Controls.Add(Me.PrivilegeGridControl)
        Me.SectionPanel1.Controls.Add(Me.PrivilegeBindingNavigator)
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 196)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Padding = New System.Windows.Forms.Padding(1)
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(720, 264)
        Me.SectionPanel1.TabIndex = 1
        '
        'PrivilegeGridControl
        '
        Me.PrivilegeGridControl.DataSource = Me.PrivilegeBindingSource
        Me.PrivilegeGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.PrivilegeGridControl.EmbeddedNavigator.Name = ""
        Me.PrivilegeGridControl.Location = New System.Drawing.Point(1, 52)
        Me.PrivilegeGridControl.MainView = Me.GridView1
        Me.PrivilegeGridControl.Name = "PrivilegeGridControl"
        Me.PrivilegeGridControl.Size = New System.Drawing.Size(718, 211)
        Me.PrivilegeGridControl.TabIndex = 3
        Me.PrivilegeGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'PrivilegeBindingSource
        '
        Me.PrivilegeBindingSource.DataSource = GetType(Nrc.NRCAuthLib.Privilege)
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colName, Me.colPrivilegeLevel, Me.colDescription})
        Me.GridView1.GridControl = Me.PrivilegeGridControl
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsCustomization.AllowFilter = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsDetail.EnableMasterViewMode = False
        Me.GridView1.OptionsView.EnableAppearanceEvenRow = True
        Me.GridView1.OptionsView.ShowDetailButtons = False
        Me.GridView1.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.Never
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 0
        '
        'colPrivilegeLevel
        '
        Me.colPrivilegeLevel.Caption = "PrivilegeLevel"
        Me.colPrivilegeLevel.FieldName = "PrivilegeLevel"
        Me.colPrivilegeLevel.Name = "colPrivilegeLevel"
        Me.colPrivilegeLevel.OptionsColumn.ReadOnly = True
        Me.colPrivilegeLevel.Visible = True
        Me.colPrivilegeLevel.VisibleIndex = 1
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        Me.colDescription.Visible = True
        Me.colDescription.VisibleIndex = 2
        '
        'PrivilegeBindingNavigator
        '
        Me.PrivilegeBindingNavigator.AddNewItem = Nothing
        Me.PrivilegeBindingNavigator.BindingSource = Me.PrivilegeBindingSource
        Me.PrivilegeBindingNavigator.CountItem = Nothing
        Me.PrivilegeBindingNavigator.DeleteItem = Nothing
        Me.PrivilegeBindingNavigator.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.PrivilegeBindingNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddGroupPrivilegeButton, Me.AddMemberPrivilegeButton})
        Me.PrivilegeBindingNavigator.Location = New System.Drawing.Point(1, 27)
        Me.PrivilegeBindingNavigator.MoveFirstItem = Nothing
        Me.PrivilegeBindingNavigator.MoveLastItem = Nothing
        Me.PrivilegeBindingNavigator.MoveNextItem = Nothing
        Me.PrivilegeBindingNavigator.MovePreviousItem = Nothing
        Me.PrivilegeBindingNavigator.Name = "PrivilegeBindingNavigator"
        Me.PrivilegeBindingNavigator.PositionItem = Nothing
        Me.PrivilegeBindingNavigator.Size = New System.Drawing.Size(718, 25)
        Me.PrivilegeBindingNavigator.TabIndex = 4
        Me.PrivilegeBindingNavigator.Text = "BindingNavigator1"
        '
        'AddGroupPrivilegeButton
        '
        Me.AddGroupPrivilegeButton.Image = CType(resources.GetObject("AddGroupPrivilegeButton.Image"), System.Drawing.Image)
        Me.AddGroupPrivilegeButton.Name = "AddGroupPrivilegeButton"
        Me.AddGroupPrivilegeButton.RightToLeftAutoMirrorImage = True
        Me.AddGroupPrivilegeButton.Size = New System.Drawing.Size(121, 22)
        Me.AddGroupPrivilegeButton.Text = "Add Group Privilege"
        '
        'AddMemberPrivilegeButton
        '
        Me.AddMemberPrivilegeButton.Image = CType(resources.GetObject("AddMemberPrivilegeButton.Image"), System.Drawing.Image)
        Me.AddMemberPrivilegeButton.Name = "AddMemberPrivilegeButton"
        Me.AddMemberPrivilegeButton.RightToLeftAutoMirrorImage = True
        Me.AddMemberPrivilegeButton.Size = New System.Drawing.Size(130, 22)
        Me.AddMemberPrivilegeButton.Text = "Add Member Privilege"
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.Location = New System.Drawing.Point(555, 466)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 2
        Me.OKButton.Text = "OK"
        Me.OKButton.UseVisualStyleBackColor = True
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(638, 466)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 3
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'ImageSelectorDialog
        '
        Me.ImageSelectorDialog.Filter = "Icon Files|*.ico|Image Files|*.gif;*.png;*.jpg;*.bmp|Applications|*.exe"
        Me.ImageSelectorDialog.FilterIndex = 2
        Me.ImageSelectorDialog.Title = "Select an image file"
        '
        'ExportImageDialog
        '
        Me.ExportImageDialog.Filter = "Bitmap|*.bmp|EMF Image|*.emf|GIF Image|*.gif|Icon|*.ico|JPEG Image|*.jpg|PNG Imag" & _
            "e|*.png|TIFF Image|*.tif|WMF Image|*.wmf"
        Me.ExportImageDialog.FilterIndex = 6
        '
        'ApplicationManagementSection
        '
        Me.Controls.Add(Me.CancelButton)
        Me.Controls.Add(Me.OKButton)
        Me.Controls.Add(Me.SectionPanel1)
        Me.Controls.Add(Me.AppManagementPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ApplicationManagementSection"
        Me.Size = New System.Drawing.Size(720, 492)
        Me.AppManagementPanel.ResumeLayout(False)
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel1.PerformLayout()
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.Panel2.PerformLayout()
        Me.SplitContainer1.ResumeLayout(False)
        CType(Me.ApplicationImage, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel1.PerformLayout()
        CType(Me.PrivilegeGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PrivilegeBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.PrivilegeBindingNavigator, System.ComponentModel.ISupportInitialize).EndInit()
        Me.PrivilegeBindingNavigator.ResumeLayout(False)
        Me.PrivilegeBindingNavigator.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents AppManagementPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ApplicationName As System.Windows.Forms.TextBox
    Friend WithEvents ApplicationNameLabel As System.Windows.Forms.Label
    Friend WithEvents DeploymentTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents DescriptionLabel As System.Windows.Forms.Label
    Friend WithEvents ApplicationImage As System.Windows.Forms.PictureBox
    Friend WithEvents IsInternalApplication As System.Windows.Forms.CheckBox
    Friend WithEvents Description As System.Windows.Forms.TextBox
    Friend WithEvents ApplicationPath As System.Windows.Forms.TextBox
    Friend WithEvents Category As System.Windows.Forms.TextBox
    Friend WithEvents DeploymentTypeLabel As System.Windows.Forms.Label
    Friend WithEvents CategoryLabel As System.Windows.Forms.Label
    Friend WithEvents PathLabel As System.Windows.Forms.Label
    Friend WithEvents ImageLabel As System.Windows.Forms.Label
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents ChangeImageButton As System.Windows.Forms.LinkLabel
    Friend WithEvents ImageSelectorDialog As System.Windows.Forms.OpenFileDialog
    Friend WithEvents ExportImageButton As System.Windows.Forms.LinkLabel
    Friend WithEvents ExportImageDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents PrivilegeGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents PrivilegeBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPrivilegeLevel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents PrivilegeBindingNavigator As System.Windows.Forms.BindingNavigator
    Friend WithEvents AddMemberPrivilegeButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents AddGroupPrivilegeButton As System.Windows.Forms.ToolStripButton

End Class
