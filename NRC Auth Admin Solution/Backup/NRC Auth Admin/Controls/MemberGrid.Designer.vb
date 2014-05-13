<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MemberGrid
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
        Dim StyleFormatCondition1 As DevExpress.XtraGrid.StyleFormatCondition = New DevExpress.XtraGrid.StyleFormatCondition
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MemberGrid))
        Me.colIsAccountLocked = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemCheckEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
        Me.MemberMenu = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.EditProfileMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.EditPrivilegesMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator2 = New System.Windows.Forms.ToolStripSeparator
        Me.ResetPasswordMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.ToolStripSeparator3 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteMemberMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MemberTools = New System.Windows.Forms.ToolStrip
        Me.NewMemberButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator1 = New System.Windows.Forms.ToolStripSeparator
        Me.EditProfileButton = New System.Windows.Forms.ToolStripButton
        Me.EditPrivilegesButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripSeparator4 = New System.Windows.Forms.ToolStripSeparator
        Me.DeleteMemberButton = New System.Windows.Forms.ToolStripButton
        Me.ExportButton = New System.Windows.Forms.ToolStripButton
        Me.MemberBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MemberGridControl = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colLastName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFirstName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUserName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colOccupationalTitle = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEmailAddress = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colLastLoginDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.RepositoryItemDateEdit1 = New DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
        Me.colFacility = New DevExpress.XtraGrid.Columns.GridColumn
        Me.LockStatusImages = New System.Windows.Forms.ImageList(Me.components)
        Me.FileDialog = New System.Windows.Forms.SaveFileDialog
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MemberMenu.SuspendLayout()
        Me.MemberTools.SuspendLayout()
        CType(Me.MemberBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MemberGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemDateEdit1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RepositoryItemDateEdit1.VistaTimeProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'colIsAccountLocked
        '
        Me.colIsAccountLocked.ColumnEdit = Me.RepositoryItemCheckEdit1
        Me.colIsAccountLocked.FieldName = "IsAccountLocked"
        Me.colIsAccountLocked.Name = "colIsAccountLocked"
        Me.colIsAccountLocked.OptionsColumn.AllowSize = False
        Me.colIsAccountLocked.OptionsColumn.FixedWidth = True
        Me.colIsAccountLocked.OptionsColumn.ReadOnly = True
        Me.colIsAccountLocked.Visible = True
        Me.colIsAccountLocked.VisibleIndex = 0
        Me.colIsAccountLocked.Width = 20
        '
        'RepositoryItemCheckEdit1
        '
        Me.RepositoryItemCheckEdit1.AutoHeight = False
        Me.RepositoryItemCheckEdit1.CheckStyle = DevExpress.XtraEditors.Controls.CheckStyles.UserDefined
        Me.RepositoryItemCheckEdit1.Name = "RepositoryItemCheckEdit1"
        Me.RepositoryItemCheckEdit1.PictureChecked = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Lock16
        '
        'MemberMenu
        '
        Me.MemberMenu.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.EditProfileMenuItem, Me.EditPrivilegesMenuItem, Me.ToolStripSeparator2, Me.ResetPasswordMenuItem, Me.ToolStripSeparator3, Me.DeleteMemberMenuItem})
        Me.MemberMenu.Name = "GroupMenu"
        Me.MemberMenu.Size = New System.Drawing.Size(164, 104)
        '
        'EditProfileMenuItem
        '
        Me.EditProfileMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Profile16
        Me.EditProfileMenuItem.Name = "EditProfileMenuItem"
        Me.EditProfileMenuItem.Size = New System.Drawing.Size(163, 22)
        Me.EditProfileMenuItem.Text = "Edit Profile..."
        '
        'EditPrivilegesMenuItem
        '
        Me.EditPrivilegesMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.EditPrivilegesMenuItem.Name = "EditPrivilegesMenuItem"
        Me.EditPrivilegesMenuItem.Size = New System.Drawing.Size(163, 22)
        Me.EditPrivilegesMenuItem.Text = "Edit Privileges..."
        '
        'ToolStripSeparator2
        '
        Me.ToolStripSeparator2.Name = "ToolStripSeparator2"
        Me.ToolStripSeparator2.Size = New System.Drawing.Size(160, 6)
        '
        'ResetPasswordMenuItem
        '
        Me.ResetPasswordMenuItem.Name = "ResetPasswordMenuItem"
        Me.ResetPasswordMenuItem.Size = New System.Drawing.Size(163, 22)
        Me.ResetPasswordMenuItem.Text = "Reset Password..."
        '
        'ToolStripSeparator3
        '
        Me.ToolStripSeparator3.Name = "ToolStripSeparator3"
        Me.ToolStripSeparator3.Size = New System.Drawing.Size(160, 6)
        '
        'DeleteMemberMenuItem
        '
        Me.DeleteMemberMenuItem.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteMemberMenuItem.Name = "DeleteMemberMenuItem"
        Me.DeleteMemberMenuItem.Size = New System.Drawing.Size(163, 22)
        Me.DeleteMemberMenuItem.Text = "Delete Member"
        '
        'MemberTools
        '
        Me.MemberTools.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.MemberTools.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.NewMemberButton, Me.ToolStripSeparator1, Me.EditProfileButton, Me.EditPrivilegesButton, Me.ToolStripSeparator4, Me.DeleteMemberButton, Me.ExportButton})
        Me.MemberTools.Location = New System.Drawing.Point(0, 0)
        Me.MemberTools.Name = "MemberTools"
        Me.MemberTools.Size = New System.Drawing.Size(613, 25)
        Me.MemberTools.TabIndex = 4
        Me.MemberTools.Text = "ToolStrip1"
        '
        'NewMemberButton
        '
        Me.NewMemberButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.NewMember16
        Me.NewMemberButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.NewMemberButton.Name = "NewMemberButton"
        Me.NewMemberButton.Size = New System.Drawing.Size(124, 22)
        Me.NewMemberButton.Text = "Create New Member"
        '
        'ToolStripSeparator1
        '
        Me.ToolStripSeparator1.Name = "ToolStripSeparator1"
        Me.ToolStripSeparator1.Size = New System.Drawing.Size(6, 25)
        '
        'EditProfileButton
        '
        Me.EditProfileButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Profile16
        Me.EditProfileButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.EditProfileButton.Name = "EditProfileButton"
        Me.EditProfileButton.Size = New System.Drawing.Size(56, 22)
        Me.EditProfileButton.Text = "Profile"
        '
        'EditPrivilegesButton
        '
        Me.EditPrivilegesButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Privileges16
        Me.EditPrivilegesButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.EditPrivilegesButton.Name = "EditPrivilegesButton"
        Me.EditPrivilegesButton.Size = New System.Drawing.Size(72, 22)
        Me.EditPrivilegesButton.Text = "Privileges"
        '
        'ToolStripSeparator4
        '
        Me.ToolStripSeparator4.Name = "ToolStripSeparator4"
        Me.ToolStripSeparator4.Size = New System.Drawing.Size(6, 25)
        '
        'DeleteMemberButton
        '
        Me.DeleteMemberButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Delete16
        Me.DeleteMemberButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteMemberButton.Name = "DeleteMemberButton"
        Me.DeleteMemberButton.Size = New System.Drawing.Size(58, 22)
        Me.DeleteMemberButton.Text = "Delete"
        '
        'ExportButton
        '
        Me.ExportButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ExportButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image
        Me.ExportButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Excel16
        Me.ExportButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportButton.Name = "ExportButton"
        Me.ExportButton.Size = New System.Drawing.Size(23, 22)
        Me.ExportButton.Text = "Export List"
        '
        'MemberBindingSource
        '
        Me.MemberBindingSource.DataSource = GetType(Nrc.NRCAuthLib.Member)
        '
        'MemberGridControl
        '
        Me.MemberGridControl.ContextMenuStrip = Me.MemberMenu
        Me.MemberGridControl.DataSource = Me.MemberBindingSource
        Me.MemberGridControl.Dock = System.Windows.Forms.DockStyle.Fill
        Me.MemberGridControl.EmbeddedNavigator.Name = ""
        Me.MemberGridControl.Location = New System.Drawing.Point(0, 25)
        Me.MemberGridControl.MainView = Me.GridView1
        Me.MemberGridControl.Name = "MemberGridControl"
        Me.MemberGridControl.RepositoryItems.AddRange(New DevExpress.XtraEditors.Repository.RepositoryItem() {Me.RepositoryItemCheckEdit1, Me.RepositoryItemDateEdit1})
        Me.MemberGridControl.Size = New System.Drawing.Size(613, 127)
        Me.MemberGridControl.TabIndex = 5
        Me.MemberGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Appearance.Empty.BackColor = System.Drawing.SystemColors.Control
        Me.GridView1.Appearance.Empty.Options.UseBackColor = True
        Me.GridView1.Appearance.EvenRow.BackColor = System.Drawing.Color.Gainsboro
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colIsAccountLocked, Me.colLastName, Me.colFirstName, Me.colUserName, Me.colOccupationalTitle, Me.colEmailAddress, Me.colDateCreated, Me.colLastLoginDate, Me.colFacility})
        StyleFormatCondition1.Appearance.BackColor = System.Drawing.Color.White
        StyleFormatCondition1.Appearance.BackColor2 = System.Drawing.Color.MistyRose
        StyleFormatCondition1.Appearance.GradientMode = System.Drawing.Drawing2D.LinearGradientMode.Vertical
        StyleFormatCondition1.Appearance.Options.UseBackColor = True
        StyleFormatCondition1.ApplyToRow = True
        StyleFormatCondition1.Column = Me.colIsAccountLocked
        StyleFormatCondition1.Condition = DevExpress.XtraGrid.FormatConditionEnum.Equal
        StyleFormatCondition1.Value1 = True
        Me.GridView1.FormatConditions.AddRange(New DevExpress.XtraGrid.StyleFormatCondition() {StyleFormatCondition1})
        Me.GridView1.GridControl = Me.MemberGridControl
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsDetail.AllowZoomDetail = False
        Me.GridView1.OptionsDetail.EnableMasterViewMode = False
        Me.GridView1.OptionsDetail.ShowDetailTabs = False
        Me.GridView1.OptionsSelection.EnableAppearanceFocusedCell = False
        Me.GridView1.OptionsView.EnableAppearanceEvenRow = True
        Me.GridView1.OptionsView.ShowAutoFilterRow = True
        Me.GridView1.OptionsView.ShowDetailButtons = False
        Me.GridView1.SortInfo.AddRange(New DevExpress.XtraGrid.Columns.GridColumnSortInfo() {New DevExpress.XtraGrid.Columns.GridColumnSortInfo(Me.colLastName, DevExpress.Data.ColumnSortOrder.Ascending)})
        '
        'colLastName
        '
        Me.colLastName.Caption = "Last Name"
        Me.colLastName.FieldName = "LastName"
        Me.colLastName.Name = "colLastName"
        Me.colLastName.Visible = True
        Me.colLastName.VisibleIndex = 1
        Me.colLastName.Width = 76
        '
        'colFirstName
        '
        Me.colFirstName.Caption = "First Name"
        Me.colFirstName.FieldName = "FirstName"
        Me.colFirstName.Name = "colFirstName"
        Me.colFirstName.Visible = True
        Me.colFirstName.VisibleIndex = 2
        Me.colFirstName.Width = 76
        '
        'colUserName
        '
        Me.colUserName.Caption = "User Name"
        Me.colUserName.FieldName = "UserName"
        Me.colUserName.Name = "colUserName"
        Me.colUserName.Visible = True
        Me.colUserName.VisibleIndex = 3
        Me.colUserName.Width = 76
        '
        'colOccupationalTitle
        '
        Me.colOccupationalTitle.Caption = "Title"
        Me.colOccupationalTitle.FieldName = "OccupationalTitle"
        Me.colOccupationalTitle.Name = "colOccupationalTitle"
        Me.colOccupationalTitle.Visible = True
        Me.colOccupationalTitle.VisibleIndex = 4
        '
        'colEmailAddress
        '
        Me.colEmailAddress.Caption = "Email"
        Me.colEmailAddress.FieldName = "EmailAddress"
        Me.colEmailAddress.Name = "colEmailAddress"
        Me.colEmailAddress.Visible = True
        Me.colEmailAddress.VisibleIndex = 5
        Me.colEmailAddress.Width = 76
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "Date Created"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.OptionsColumn.ReadOnly = True
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 6
        Me.colDateCreated.Width = 104
        '
        'colLastLoginDate
        '
        Me.colLastLoginDate.Caption = "Last Login"
        Me.colLastLoginDate.ColumnEdit = Me.RepositoryItemDateEdit1
        Me.colLastLoginDate.FieldName = "LastLoginDate"
        Me.colLastLoginDate.Name = "colLastLoginDate"
        Me.colLastLoginDate.OptionsColumn.ReadOnly = True
        Me.colLastLoginDate.Visible = True
        Me.colLastLoginDate.VisibleIndex = 7
        Me.colLastLoginDate.Width = 76
        '
        'RepositoryItemDateEdit1
        '
        Me.RepositoryItemDateEdit1.AllowNullInput = DevExpress.Utils.DefaultBoolean.[True]
        Me.RepositoryItemDateEdit1.AutoHeight = False
        Me.RepositoryItemDateEdit1.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RepositoryItemDateEdit1.Name = "RepositoryItemDateEdit1"
        Me.RepositoryItemDateEdit1.NullDate = New Date(2006, 7, 19, 8, 33, 46, 0)
        Me.RepositoryItemDateEdit1.NullText = "Never"
        Me.RepositoryItemDateEdit1.VistaTimeProperties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton})
        '
        'colFacility
        '
        Me.colFacility.Caption = "Facility"
        Me.colFacility.FieldName = "Facility"
        Me.colFacility.Name = "colFacility"
        Me.colFacility.Visible = True
        Me.colFacility.VisibleIndex = 8
        Me.colFacility.Width = 88
        '
        'LockStatusImages
        '
        Me.LockStatusImages.ImageStream = CType(resources.GetObject("LockStatusImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.LockStatusImages.TransparentColor = System.Drawing.Color.Transparent
        Me.LockStatusImages.Images.SetKeyName(0, "Lock16.png")
        '
        'FileDialog
        '
        Me.FileDialog.Filter = "Excel Files|*.xls|HTML Files|*.html|Text Files|*.txt"
        Me.FileDialog.Title = "Export Data to File"
        '
        'MemberGrid
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.MemberGridControl)
        Me.Controls.Add(Me.MemberTools)
        Me.Name = "MemberGrid"
        Me.Size = New System.Drawing.Size(613, 152)
        CType(Me.RepositoryItemCheckEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MemberMenu.ResumeLayout(False)
        Me.MemberTools.ResumeLayout(False)
        Me.MemberTools.PerformLayout()
        CType(Me.MemberBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MemberGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemDateEdit1.VistaTimeProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RepositoryItemDateEdit1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MemberMenu As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents EditPrivilegesMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditProfileMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MemberTools As System.Windows.Forms.ToolStrip
    Friend WithEvents NewMemberButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator1 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents EditProfileButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents EditPrivilegesButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents ToolStripSeparator2 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents ResetPasswordMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator3 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteMemberMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ToolStripSeparator4 As System.Windows.Forms.ToolStripSeparator
    Friend WithEvents DeleteMemberButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MemberBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents MemberGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents LockStatusImages As System.Windows.Forms.ImageList
    Friend WithEvents RepositoryItemCheckEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemCheckEdit
    Friend WithEvents RepositoryItemDateEdit1 As DevExpress.XtraEditors.Repository.RepositoryItemDateEdit
    Friend WithEvents ExportButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents FileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents colIsAccountLocked As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLastName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFirstName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUserName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colOccupationalTitle As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEmailAddress As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colLastLoginDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFacility As DevExpress.XtraGrid.Columns.GridColumn
    Public WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView

End Class
