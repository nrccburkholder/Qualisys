<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class VendorFileValidationSection
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
        Me.VendorFileSectionPanel = New Nrc.Framework.WinForms.SectionPanel()
        Me.VendorFilePanel = New System.Windows.Forms.Panel()
        Me.ResendToTelematchButton = New System.Windows.Forms.Button()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.VendorFileRollbackButton = New System.Windows.Forms.Button()
        Me.VendorFileTabControl = New System.Windows.Forms.TabControl()
        Me.VendorFileValidationTabPage = New System.Windows.Forms.TabPage()
        Me.VendorFileValidationReportViewer = New Microsoft.Reporting.WinForms.ReportViewer()
        Me.VendorFileDataTabPage = New System.Windows.Forms.TabPage()
        Me.VendorFileDataGridControl = New DevExpress.XtraGrid.GridControl()
        Me.VendorFileDataGridView = New DevExpress.XtraGrid.Views.Grid.GridView()
        Me.VendorFileRemakeButton = New System.Windows.Forms.Button()
        Me.VendorFileApproveButton = New System.Windows.Forms.Button()
        Me.DateFileCreatedDateTimePicker = New System.Windows.Forms.DateTimePicker()
        Me.VendorFileSectionPanel.SuspendLayout()
        Me.VendorFilePanel.SuspendLayout()
        Me.VendorFileTabControl.SuspendLayout()
        Me.VendorFileValidationTabPage.SuspendLayout()
        Me.VendorFileDataTabPage.SuspendLayout()
        CType(Me.VendorFileDataGridControl, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.VendorFileDataGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'VendorFileSectionPanel
        '
        Me.VendorFileSectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.VendorFileSectionPanel.Caption = "File Validation"
        Me.VendorFileSectionPanel.Controls.Add(Me.VendorFilePanel)
        Me.VendorFileSectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.VendorFileSectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.VendorFileSectionPanel.Name = "VendorFileSectionPanel"
        Me.VendorFileSectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.VendorFileSectionPanel.ShowCaption = True
        Me.VendorFileSectionPanel.Size = New System.Drawing.Size(809, 734)
        Me.VendorFileSectionPanel.TabIndex = 1
        '
        'VendorFilePanel
        '
        Me.VendorFilePanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFilePanel.Controls.Add(Me.ResendToTelematchButton)
        Me.VendorFilePanel.Controls.Add(Me.DateFileCreatedDateTimePicker)
        Me.VendorFilePanel.Controls.Add(Me.Label1)
        Me.VendorFilePanel.Controls.Add(Me.VendorFileRollbackButton)
        Me.VendorFilePanel.Controls.Add(Me.VendorFileTabControl)
        Me.VendorFilePanel.Controls.Add(Me.VendorFileRemakeButton)
        Me.VendorFilePanel.Controls.Add(Me.VendorFileApproveButton)
        Me.VendorFilePanel.Location = New System.Drawing.Point(4, 30)
        Me.VendorFilePanel.Name = "VendorFilePanel"
        Me.VendorFilePanel.Size = New System.Drawing.Size(801, 700)
        Me.VendorFilePanel.TabIndex = 0
        Me.VendorFilePanel.Visible = False
        '
        'ResendToTelematchButton
        '
        Me.ResendToTelematchButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ResendToTelematchButton.Location = New System.Drawing.Point(4, 674)
        Me.ResendToTelematchButton.Name = "ResendToTelematchButton"
        Me.ResendToTelematchButton.Size = New System.Drawing.Size(148, 23)
        Me.ResendToTelematchButton.TabIndex = 10
        Me.ResendToTelematchButton.Text = "Resend to Telematch"
        Me.ResendToTelematchButton.UseVisualStyleBackColor = True
        '
        'DateFileCreatedDateTimePicker
        '
        Me.DateFileCreatedDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DateFileCreatedDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.DateFileCreatedDateTimePicker.Location = New System.Drawing.Point(376, 674)
        Me.DateFileCreatedDateTimePicker.Name = "DateFileCreatedDateTimePicker"
        Me.DateFileCreatedDateTimePicker.Size = New System.Drawing.Size(100, 21)
        Me.DateFileCreatedDateTimePicker.TabIndex = 9
        '
        'Label1
        '
        Me.Label1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.Location = New System.Drawing.Point(292, 679)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(78, 13)
        Me.Label1.TabIndex = 8
        Me.Label1.Text = "Date File Sent:"
        '
        'VendorFileRollbackButton
        '
        Me.VendorFileRollbackButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileRollbackButton.Location = New System.Drawing.Point(482, 674)
        Me.VendorFileRollbackButton.Name = "VendorFileRollbackButton"
        Me.VendorFileRollbackButton.Size = New System.Drawing.Size(100, 23)
        Me.VendorFileRollbackButton.TabIndex = 4
        Me.VendorFileRollbackButton.Text = "Rollback"
        Me.VendorFileRollbackButton.UseVisualStyleBackColor = True
        '
        'VendorFileTabControl
        '
        Me.VendorFileTabControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileTabControl.Controls.Add(Me.VendorFileValidationTabPage)
        Me.VendorFileTabControl.Controls.Add(Me.VendorFileDataTabPage)
        Me.VendorFileTabControl.Location = New System.Drawing.Point(4, 4)
        Me.VendorFileTabControl.Name = "VendorFileTabControl"
        Me.VendorFileTabControl.SelectedIndex = 0
        Me.VendorFileTabControl.Size = New System.Drawing.Size(794, 664)
        Me.VendorFileTabControl.TabIndex = 1
        '
        'VendorFileValidationTabPage
        '
        Me.VendorFileValidationTabPage.Controls.Add(Me.VendorFileValidationReportViewer)
        Me.VendorFileValidationTabPage.Location = New System.Drawing.Point(4, 22)
        Me.VendorFileValidationTabPage.Name = "VendorFileValidationTabPage"
        Me.VendorFileValidationTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.VendorFileValidationTabPage.Size = New System.Drawing.Size(786, 638)
        Me.VendorFileValidationTabPage.TabIndex = 0
        Me.VendorFileValidationTabPage.Text = "Validation Report"
        Me.VendorFileValidationTabPage.UseVisualStyleBackColor = True
        '
        'VendorFileValidationReportViewer
        '
        Me.VendorFileValidationReportViewer.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileValidationReportViewer.Location = New System.Drawing.Point(6, 6)
        Me.VendorFileValidationReportViewer.Name = "VendorFileValidationReportViewer"
        Me.VendorFileValidationReportViewer.ProcessingMode = Microsoft.Reporting.WinForms.ProcessingMode.Remote
        Me.VendorFileValidationReportViewer.ServerReport.DisplayName = "Vendor File Validation"
        Me.VendorFileValidationReportViewer.ServerReport.ReportPath = "/Pages/ReportViewer.aspx?%2fAlternativeMethodology%2fVendor+Outgoing+File+Validat" & _
    "ion&rs%3aCommand=Render&VendorFile_ID=7"
        Me.VendorFileValidationReportViewer.ServerReport.ReportServerUrl = New System.Uri("http://ironman/ReportServer", System.UriKind.Absolute)
        Me.VendorFileValidationReportViewer.ShowBackButton = False
        Me.VendorFileValidationReportViewer.ShowDocumentMapButton = False
        Me.VendorFileValidationReportViewer.ShowPromptAreaButton = False
        Me.VendorFileValidationReportViewer.ShowStopButton = False
        Me.VendorFileValidationReportViewer.Size = New System.Drawing.Size(774, 626)
        Me.VendorFileValidationReportViewer.TabIndex = 2
        '
        'VendorFileDataTabPage
        '
        Me.VendorFileDataTabPage.Controls.Add(Me.VendorFileDataGridControl)
        Me.VendorFileDataTabPage.Location = New System.Drawing.Point(4, 22)
        Me.VendorFileDataTabPage.Name = "VendorFileDataTabPage"
        Me.VendorFileDataTabPage.Padding = New System.Windows.Forms.Padding(3)
        Me.VendorFileDataTabPage.Size = New System.Drawing.Size(786, 638)
        Me.VendorFileDataTabPage.TabIndex = 1
        Me.VendorFileDataTabPage.Text = "File Data"
        Me.VendorFileDataTabPage.UseVisualStyleBackColor = True
        '
        'VendorFileDataGridControl
        '
        Me.VendorFileDataGridControl.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
            Or System.Windows.Forms.AnchorStyles.Left) _
            Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileDataGridControl.EmbeddedNavigator.Name = ""
        Me.VendorFileDataGridControl.Location = New System.Drawing.Point(7, 7)
        Me.VendorFileDataGridControl.MainView = Me.VendorFileDataGridView
        Me.VendorFileDataGridControl.Name = "VendorFileDataGridControl"
        Me.VendorFileDataGridControl.Size = New System.Drawing.Size(773, 625)
        Me.VendorFileDataGridControl.TabIndex = 3
        Me.VendorFileDataGridControl.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.VendorFileDataGridView})
        '
        'VendorFileDataGridView
        '
        Me.VendorFileDataGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.VendorFileDataGridView.GridControl = Me.VendorFileDataGridControl
        Me.VendorFileDataGridView.Name = "VendorFileDataGridView"
        Me.VendorFileDataGridView.OptionsBehavior.Editable = False
        Me.VendorFileDataGridView.OptionsView.ColumnAutoWidth = False
        Me.VendorFileDataGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.VendorFileDataGridView.OptionsView.EnableAppearanceOddRow = True
        Me.VendorFileDataGridView.OptionsView.ShowAutoFilterRow = True
        '
        'VendorFileRemakeButton
        '
        Me.VendorFileRemakeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileRemakeButton.Location = New System.Drawing.Point(588, 674)
        Me.VendorFileRemakeButton.Name = "VendorFileRemakeButton"
        Me.VendorFileRemakeButton.Size = New System.Drawing.Size(100, 23)
        Me.VendorFileRemakeButton.TabIndex = 5
        Me.VendorFileRemakeButton.Text = "Reject && Remake"
        Me.VendorFileRemakeButton.UseVisualStyleBackColor = True
        '
        'VendorFileApproveButton
        '
        Me.VendorFileApproveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.VendorFileApproveButton.Location = New System.Drawing.Point(694, 674)
        Me.VendorFileApproveButton.Name = "VendorFileApproveButton"
        Me.VendorFileApproveButton.Size = New System.Drawing.Size(100, 23)
        Me.VendorFileApproveButton.TabIndex = 6
        Me.VendorFileApproveButton.Text = "Approve && Send"
        Me.VendorFileApproveButton.UseVisualStyleBackColor = True
        '
        'DateFileCreatedDateTimePicker
        '
        Me.DateFileCreatedDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DateFileCreatedDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.[Short]
        Me.DateFileCreatedDateTimePicker.Location = New System.Drawing.Point(376, 674)
        Me.DateFileCreatedDateTimePicker.Name = "DateFileCreatedDateTimePicker"
        Me.DateFileCreatedDateTimePicker.Size = New System.Drawing.Size(100, 21)
        Me.DateFileCreatedDateTimePicker.TabIndex = 9
        '
        'VendorFileValidationSection
        '
        Me.Controls.Add(Me.VendorFileSectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "VendorFileValidationSection"
        Me.Size = New System.Drawing.Size(809, 734)
        Me.VendorFileSectionPanel.ResumeLayout(False)
        Me.VendorFilePanel.ResumeLayout(False)
        Me.VendorFileTabControl.ResumeLayout(False)
        Me.VendorFileValidationTabPage.ResumeLayout(False)
        Me.VendorFileDataTabPage.ResumeLayout(False)
        CType(Me.VendorFileDataGridControl, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.VendorFileDataGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
    End Sub

    Friend WithEvents VendorFileSectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents VendorFilePanel As System.Windows.Forms.Panel
    Friend WithEvents VendorFileRemakeButton As System.Windows.Forms.Button
    Friend WithEvents VendorFileApproveButton As System.Windows.Forms.Button
    Friend WithEvents VendorFileTabControl As System.Windows.Forms.TabControl
    Friend WithEvents VendorFileValidationTabPage As System.Windows.Forms.TabPage
    Friend WithEvents VendorFileDataTabPage As System.Windows.Forms.TabPage
    Friend WithEvents VendorFileValidationReportViewer As Microsoft.Reporting.WinForms.ReportViewer
    Friend WithEvents VendorFileDataGridControl As DevExpress.XtraGrid.GridControl
    Friend WithEvents VendorFileDataGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents VendorFileRollbackButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents DateFileCreatedDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents ResendToTelematchButton As System.Windows.Forms.Button

End Class
