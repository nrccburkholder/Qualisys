<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NotesSection
    Inherits DataLoaderAdmin.Section

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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(NotesSection))
        Me.spnlUploadedFiles = New Nrc.WinForms.SectionPanel
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.UploadedFilesGrid = New DevExpress.XtraGrid.GridControl
        Me.cmnAddNote = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.tsmiAddNote = New System.Windows.Forms.ToolStripMenuItem
        Me.UploadFilePackageDisplayBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UploadedFilesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.coluploadfileId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUploadDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colfileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colpackageId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colpackageName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.coluploadstateName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colstudyId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridView2 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.EndDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.StartDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.AddNewNoteButton = New System.Windows.Forms.ToolStripButton
        Me.ToolStripLabel2 = New System.Windows.Forms.ToolStripLabel
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.ExportToXLSToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.spnlUploadFileNotes = New Nrc.WinForms.SectionPanel
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.UploadedFileNotesGrid = New DevExpress.XtraGrid.GridControl
        Me.UploadedFileNotesDisplayBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UploadedFileNotesGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colUploadFileId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPackageId1 = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNote = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUsername = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNoteId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colUploadFilePackageId = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GridView3 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.ToolStrip2 = New System.Windows.Forms.ToolStrip
        Me.ExportNotesToXLSToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.SplitContainer1 = New System.Windows.Forms.SplitContainer
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        Me.spnlUploadedFiles.SuspendLayout()
        Me.Panel1.SuspendLayout()
        CType(Me.UploadedFilesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.cmnAddNote.SuspendLayout()
        CType(Me.UploadFilePackageDisplayBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UploadedFilesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.spnlUploadFileNotes.SuspendLayout()
        Me.Panel2.SuspendLayout()
        CType(Me.UploadedFileNotesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UploadedFileNotesDisplayBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UploadedFileNotesGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip2.SuspendLayout()
        Me.SplitContainer1.Panel1.SuspendLayout()
        Me.SplitContainer1.Panel2.SuspendLayout()
        Me.SplitContainer1.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnlUploadedFiles
        '
        Me.spnlUploadedFiles.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.spnlUploadedFiles.Caption = "Uploaded Files"
        Me.spnlUploadedFiles.Controls.Add(Me.Panel1)
        Me.spnlUploadedFiles.Controls.Add(Me.EndDateTimePicker)
        Me.spnlUploadedFiles.Controls.Add(Me.StartDateTimePicker)
        Me.spnlUploadedFiles.Controls.Add(Me.ToolStrip1)
        Me.spnlUploadedFiles.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnlUploadedFiles.Location = New System.Drawing.Point(0, 0)
        Me.spnlUploadedFiles.Name = "spnlUploadedFiles"
        Me.spnlUploadedFiles.Padding = New System.Windows.Forms.Padding(1)
        Me.spnlUploadedFiles.ShowCaption = True
        Me.spnlUploadedFiles.Size = New System.Drawing.Size(874, 326)
        Me.spnlUploadedFiles.TabIndex = 0
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.UploadedFilesGrid)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(1, 52)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(872, 273)
        Me.Panel1.TabIndex = 9
        '
        'UploadedFilesGrid
        '
        Me.UploadedFilesGrid.ContextMenuStrip = Me.cmnAddNote
        Me.UploadedFilesGrid.DataSource = Me.UploadFilePackageDisplayBindingSource
        Me.UploadedFilesGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.UploadedFilesGrid.EmbeddedNavigator.Name = ""
        Me.UploadedFilesGrid.Location = New System.Drawing.Point(0, 0)
        Me.UploadedFilesGrid.MainView = Me.UploadedFilesGridView
        Me.UploadedFilesGrid.Name = "UploadedFilesGrid"
        Me.UploadedFilesGrid.Size = New System.Drawing.Size(872, 273)
        Me.UploadedFilesGrid.TabIndex = 1
        Me.UploadedFilesGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UploadedFilesGridView, Me.GridView2})
        '
        'cmnAddNote
        '
        Me.cmnAddNote.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.tsmiAddNote})
        Me.cmnAddNote.Name = "cmnAddNote"
        Me.cmnAddNote.Size = New System.Drawing.Size(144, 26)
        '
        'tsmiAddNote
        '
        Me.tsmiAddNote.Name = "tsmiAddNote"
        Me.tsmiAddNote.Size = New System.Drawing.Size(143, 22)
        Me.tsmiAddNote.Text = "Add New Note"
        '
        'UploadFilePackageDisplayBindingSource
        '
        Me.UploadFilePackageDisplayBindingSource.DataSource = GetType(Nrc.DataLoader.Library.UploadFilePackageDisplay)
        '
        'UploadedFilesGridView
        '
        Me.UploadedFilesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.coluploadfileId, Me.colUploadDate, Me.colfileName, Me.colpackageId, Me.colpackageName, Me.coluploadstateName, Me.colstudyId})
        Me.UploadedFilesGridView.GridControl = Me.UploadedFilesGrid
        Me.UploadedFilesGridView.Name = "UploadedFilesGridView"
        Me.UploadedFilesGridView.OptionsBehavior.Editable = False
        Me.UploadedFilesGridView.OptionsSelection.MultiSelect = True
        '
        'coluploadfileId
        '
        Me.coluploadfileId.Caption = "Upload File ID"
        Me.coluploadfileId.FieldName = "uploadfileId"
        Me.coluploadfileId.Name = "coluploadfileId"
        Me.coluploadfileId.Visible = True
        Me.coluploadfileId.VisibleIndex = 1
        Me.coluploadfileId.Width = 87
        '
        'colUploadDate
        '
        Me.colUploadDate.Caption = "Date"
        Me.colUploadDate.FieldName = "Date"
        Me.colUploadDate.Name = "colUploadDate"
        Me.colUploadDate.Visible = True
        Me.colUploadDate.VisibleIndex = 6
        '
        'colfileName
        '
        Me.colfileName.Caption = "File Name"
        Me.colfileName.FieldName = "fileName"
        Me.colfileName.Name = "colfileName"
        Me.colfileName.Visible = True
        Me.colfileName.VisibleIndex = 2
        Me.colfileName.Width = 232
        '
        'colpackageId
        '
        Me.colpackageId.Caption = "Package ID"
        Me.colpackageId.FieldName = "packageId"
        Me.colpackageId.Name = "colpackageId"
        Me.colpackageId.Visible = True
        Me.colpackageId.VisibleIndex = 4
        Me.colpackageId.Width = 77
        '
        'colpackageName
        '
        Me.colpackageName.Caption = "Package Name"
        Me.colpackageName.FieldName = "packageName"
        Me.colpackageName.Name = "colpackageName"
        Me.colpackageName.Visible = True
        Me.colpackageName.VisibleIndex = 3
        Me.colpackageName.Width = 268
        '
        'coluploadstateName
        '
        Me.coluploadstateName.Caption = "Upload State"
        Me.coluploadstateName.FieldName = "uploadstateName"
        Me.coluploadstateName.Name = "coluploadstateName"
        Me.coluploadstateName.Visible = True
        Me.coluploadstateName.VisibleIndex = 5
        Me.coluploadstateName.Width = 126
        '
        'colstudyId
        '
        Me.colstudyId.Caption = "Study ID"
        Me.colstudyId.FieldName = "studyId"
        Me.colstudyId.Name = "colstudyId"
        Me.colstudyId.Visible = True
        Me.colstudyId.VisibleIndex = 0
        Me.colstudyId.Width = 61
        '
        'GridView2
        '
        Me.GridView2.GridControl = Me.UploadedFilesGrid
        Me.GridView2.Name = "GridView2"
        '
        'EndDateTimePicker
        '
        Me.EndDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EndDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.EndDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.EndDateTimePicker.Location = New System.Drawing.Point(763, 27)
        Me.EndDateTimePicker.Name = "EndDateTimePicker"
        Me.EndDateTimePicker.Size = New System.Drawing.Size(110, 20)
        Me.EndDateTimePicker.TabIndex = 7
        Me.EndDateTimePicker.Value = New Date(9998, 12, 31, 0, 0, 0, 0)
        '
        'StartDateTimePicker
        '
        Me.StartDateTimePicker.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.StartDateTimePicker.CustomFormat = "MM/dd/yyyy"
        Me.StartDateTimePicker.Format = System.Windows.Forms.DateTimePickerFormat.Custom
        Me.StartDateTimePicker.Location = New System.Drawing.Point(561, 27)
        Me.StartDateTimePicker.Name = "StartDateTimePicker"
        Me.StartDateTimePicker.Size = New System.Drawing.Size(121, 20)
        Me.StartDateTimePicker.TabIndex = 7
        Me.StartDateTimePicker.Value = New Date(2008, 7, 1, 0, 0, 0, 0)
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AddNewNoteButton, Me.ToolStripLabel2, Me.ToolStripLabel1, Me.ExportToXLSToolStripButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(1, 27)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(872, 25)
        Me.ToolStrip1.TabIndex = 3
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'AddNewNoteButton
        '
        Me.AddNewNoteButton.Image = CType(resources.GetObject("AddNewNoteButton.Image"), System.Drawing.Image)
        Me.AddNewNoteButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.AddNewNoteButton.Name = "AddNewNoteButton"
        Me.AddNewNoteButton.Size = New System.Drawing.Size(96, 22)
        Me.AddNewNoteButton.Text = "&Add New Note"
        '
        'ToolStripLabel2
        '
        Me.ToolStripLabel2.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel2.Margin = New System.Windows.Forms.Padding(0, 1, 110, 2)
        Me.ToolStripLabel2.Name = "ToolStripLabel2"
        Me.ToolStripLabel2.Size = New System.Drawing.Size(51, 22)
        Me.ToolStripLabel2.Text = "End Date"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripLabel1.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Text
        Me.ToolStripLabel1.Margin = New System.Windows.Forms.Padding(0, 1, 150, 2)
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(57, 22)
        Me.ToolStripLabel1.Text = "Start Date"
        '
        'ExportToXLSToolStripButton
        '
        Me.ExportToXLSToolStripButton.Image = CType(resources.GetObject("ExportToXLSToolStripButton.Image"), System.Drawing.Image)
        Me.ExportToXLSToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportToXLSToolStripButton.Name = "ExportToXLSToolStripButton"
        Me.ExportToXLSToolStripButton.Size = New System.Drawing.Size(102, 22)
        Me.ExportToXLSToolStripButton.Text = "Export To Excel"
        '
        'spnlUploadFileNotes
        '
        Me.spnlUploadFileNotes.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.spnlUploadFileNotes.Caption = "Uploaded File Notes"
        Me.spnlUploadFileNotes.Controls.Add(Me.Panel2)
        Me.spnlUploadFileNotes.Controls.Add(Me.ToolStrip2)
        Me.spnlUploadFileNotes.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnlUploadFileNotes.Location = New System.Drawing.Point(0, 0)
        Me.spnlUploadFileNotes.Name = "spnlUploadFileNotes"
        Me.spnlUploadFileNotes.Padding = New System.Windows.Forms.Padding(1)
        Me.spnlUploadFileNotes.ShowCaption = True
        Me.spnlUploadFileNotes.Size = New System.Drawing.Size(874, 364)
        Me.spnlUploadFileNotes.TabIndex = 1
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.UploadedFileNotesGrid)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel2.Location = New System.Drawing.Point(1, 52)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(872, 311)
        Me.Panel2.TabIndex = 6
        '
        'UploadedFileNotesGrid
        '
        Me.UploadedFileNotesGrid.DataSource = Me.UploadedFileNotesDisplayBindingSource
        Me.UploadedFileNotesGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.UploadedFileNotesGrid.EmbeddedNavigator.Name = ""
        Me.UploadedFileNotesGrid.Location = New System.Drawing.Point(0, 0)
        Me.UploadedFileNotesGrid.MainView = Me.UploadedFileNotesGridView
        Me.UploadedFileNotesGrid.Name = "UploadedFileNotesGrid"
        Me.UploadedFileNotesGrid.Size = New System.Drawing.Size(872, 311)
        Me.UploadedFileNotesGrid.TabIndex = 1
        Me.UploadedFileNotesGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UploadedFileNotesGridView, Me.GridView3})
        '
        'UploadedFileNotesDisplayBindingSource
        '
        Me.UploadedFileNotesDisplayBindingSource.DataSource = GetType(Nrc.DataLoader.Library.UploadFilePackageNoteDisplay)
        '
        'UploadedFileNotesGridView
        '
        Me.UploadedFileNotesGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colUploadFileId1, Me.colPackageId1, Me.colDateCreated, Me.colNote, Me.colUsername, Me.colNoteId, Me.colUploadFilePackageId})
        Me.UploadedFileNotesGridView.GridControl = Me.UploadedFileNotesGrid
        Me.UploadedFileNotesGridView.Name = "UploadedFileNotesGridView"
        Me.UploadedFileNotesGridView.OptionsBehavior.Editable = False
        Me.UploadedFileNotesGridView.OptionsCustomization.AllowRowSizing = True
        Me.UploadedFileNotesGridView.OptionsView.ShowAutoFilterRow = True
        '
        'colUploadFileId1
        '
        Me.colUploadFileId1.Caption = "Upload File ID"
        Me.colUploadFileId1.FieldName = "UploadFileId"
        Me.colUploadFileId1.Name = "colUploadFileId1"
        Me.colUploadFileId1.Visible = True
        Me.colUploadFileId1.VisibleIndex = 0
        Me.colUploadFileId1.Width = 89
        '
        'colPackageId1
        '
        Me.colPackageId1.Caption = "Package ID"
        Me.colPackageId1.FieldName = "PackageId"
        Me.colPackageId1.Name = "colPackageId1"
        Me.colPackageId1.Visible = True
        Me.colPackageId1.VisibleIndex = 1
        Me.colPackageId1.Width = 77
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "Note Date"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 2
        Me.colDateCreated.Width = 65
        '
        'colNote
        '
        Me.colNote.AppearanceCell.Options.UseTextOptions = True
        Me.colNote.AppearanceCell.TextOptions.WordWrap = DevExpress.Utils.WordWrap.Wrap
        Me.colNote.Caption = "Note"
        Me.colNote.FieldName = "Note"
        Me.colNote.Name = "colNote"
        Me.colNote.Visible = True
        Me.colNote.VisibleIndex = 3
        Me.colNote.Width = 317
        '
        'colUsername
        '
        Me.colUsername.Caption = "User"
        Me.colUsername.FieldName = "Username"
        Me.colUsername.Name = "colUsername"
        Me.colUsername.Visible = True
        Me.colUsername.VisibleIndex = 4
        Me.colUsername.Width = 327
        '
        'colNoteId
        '
        Me.colNoteId.Caption = "NoteId"
        Me.colNoteId.FieldName = "NoteId"
        Me.colNoteId.Name = "colNoteId"
        Me.colNoteId.OptionsColumn.ReadOnly = True
        '
        'colUploadFilePackageId
        '
        Me.colUploadFilePackageId.Caption = "UploadFilePackageId"
        Me.colUploadFilePackageId.FieldName = "UploadFilePackageId"
        Me.colUploadFilePackageId.Name = "colUploadFilePackageId"
        '
        'GridView3
        '
        Me.GridView3.GridControl = Me.UploadedFileNotesGrid
        Me.GridView3.Name = "GridView3"
        '
        'ToolStrip2
        '
        Me.ToolStrip2.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportNotesToXLSToolStripButton})
        Me.ToolStrip2.Location = New System.Drawing.Point(1, 27)
        Me.ToolStrip2.Name = "ToolStrip2"
        Me.ToolStrip2.Size = New System.Drawing.Size(872, 25)
        Me.ToolStrip2.TabIndex = 4
        Me.ToolStrip2.Text = "ToolStrip2"
        '
        'ExportNotesToXLSToolStripButton
        '
        Me.ExportNotesToXLSToolStripButton.Image = CType(resources.GetObject("ExportNotesToXLSToolStripButton.Image"), System.Drawing.Image)
        Me.ExportNotesToXLSToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportNotesToXLSToolStripButton.Name = "ExportNotesToXLSToolStripButton"
        Me.ExportNotesToXLSToolStripButton.Size = New System.Drawing.Size(102, 22)
        Me.ExportNotesToXLSToolStripButton.Text = "Export To Excel"
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
        Me.SplitContainer1.Panel1.Controls.Add(Me.spnlUploadedFiles)
        '
        'SplitContainer1.Panel2
        '
        Me.SplitContainer1.Panel2.Controls.Add(Me.spnlUploadFileNotes)
        Me.SplitContainer1.Size = New System.Drawing.Size(874, 694)
        Me.SplitContainer1.SplitterDistance = 326
        Me.SplitContainer1.TabIndex = 2
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(0, 0)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 2
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20.0!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(200, 100)
        Me.TableLayoutPanel1.TabIndex = 0
        '
        'NotesSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.SplitContainer1)
        Me.Name = "NotesSection"
        Me.Size = New System.Drawing.Size(874, 694)
        Me.spnlUploadedFiles.ResumeLayout(False)
        Me.spnlUploadedFiles.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        CType(Me.UploadedFilesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.cmnAddNote.ResumeLayout(False)
        CType(Me.UploadFilePackageDisplayBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UploadedFilesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.spnlUploadFileNotes.ResumeLayout(False)
        Me.spnlUploadFileNotes.PerformLayout()
        Me.Panel2.ResumeLayout(False)
        CType(Me.UploadedFileNotesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UploadedFileNotesDisplayBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UploadedFileNotesGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView3, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip2.ResumeLayout(False)
        Me.ToolStrip2.PerformLayout()
        Me.SplitContainer1.Panel1.ResumeLayout(False)
        Me.SplitContainer1.Panel2.ResumeLayout(False)
        Me.SplitContainer1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents spnlUploadedFiles As Nrc.WinForms.SectionPanel
    Friend WithEvents spnlUploadFileNotes As Nrc.WinForms.SectionPanel
    Friend WithEvents SplitContainer1 As System.Windows.Forms.SplitContainer
    Friend WithEvents UploadedFilesGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UploadedFilesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridView2 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents UploadedFileNotesGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UploadedFileNotesGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridView3 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents UploadedFileNotesDisplayBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents AddNewNoteButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UploadFilePackageDisplayBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents coluploadfileId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colfileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colpackageId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colpackageName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents coluploadstateName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colstudyId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUploadFileId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPackageId1 As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNote As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUsername As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNoteId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colUploadFilePackageId As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents ToolStripLabel2 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents StartDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents EndDateTimePicker As System.Windows.Forms.DateTimePicker
    Friend WithEvents ExportToXLSToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog
    Friend WithEvents ToolStrip2 As System.Windows.Forms.ToolStrip
    Friend WithEvents ExportNotesToXLSToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents colUploadDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents cmnAddNote As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents tsmiAddNote As System.Windows.Forms.ToolStripMenuItem

End Class
