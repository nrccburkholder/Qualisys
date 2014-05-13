<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportHistoryDialog
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ExportHistoryDialog))
        Me.TableLayoutPanel1 = New System.Windows.Forms.TableLayoutPanel
        Me.OK_Button = New System.Windows.Forms.Button
        Me.ExportSetList = New System.Windows.Forms.ListView
        Me.ClientColumn = New System.Windows.Forms.ColumnHeader
        Me.StudyColumn = New System.Windows.Forms.ColumnHeader
        Me.SurveyColumn = New System.Windows.Forms.ColumnHeader
        Me.SampleUnitColumn = New System.Windows.Forms.ColumnHeader
        Me.NameColumn = New System.Windows.Forms.ColumnHeader
        Me.CreationDateColumn = New System.Windows.Forms.ColumnHeader
        Me.StartDateColumn = New System.Windows.Forms.ColumnHeader
        Me.EndDateColumn = New System.Windows.Forms.ColumnHeader
        Me.ExportSetTypeColumn = New System.Windows.Forms.ColumnHeader
        Me.ExportFileList = New System.Windows.Forms.ListView
        Me.ColumnHeader1 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader4 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader5 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader6 = New System.Windows.Forms.ColumnHeader
        Me.ListViewImageList = New System.Windows.Forms.ImageList(Me.components)
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader7 = New System.Windows.Forms.ColumnHeader
        Me.ColumnHeader8 = New System.Windows.Forms.ColumnHeader
        Me.TableLayoutPanel1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Export History"
        Me.mPaneCaption.Size = New System.Drawing.Size(753, 26)
        Me.mPaneCaption.Text = "Export History"
        '
        'TableLayoutPanel1
        '
        Me.TableLayoutPanel1.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel1.ColumnCount = 2
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.Controls.Add(Me.OK_Button, 1, 0)
        Me.TableLayoutPanel1.Location = New System.Drawing.Point(597, 555)
        Me.TableLayoutPanel1.Name = "TableLayoutPanel1"
        Me.TableLayoutPanel1.RowCount = 1
        Me.TableLayoutPanel1.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel1.Size = New System.Drawing.Size(146, 29)
        Me.TableLayoutPanel1.TabIndex = 0
        '
        'OK_Button
        '
        Me.OK_Button.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.OK_Button.Location = New System.Drawing.Point(76, 3)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(67, 23)
        Me.OK_Button.TabIndex = 0
        Me.OK_Button.Text = "OK"
        '
        'ExportSetList
        '
        Me.ExportSetList.AllowColumnReorder = True
        Me.ExportSetList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportSetList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ClientColumn, Me.StudyColumn, Me.SurveyColumn, Me.SampleUnitColumn, Me.NameColumn, Me.CreationDateColumn, Me.StartDateColumn, Me.EndDateColumn, Me.ExportSetTypeColumn})
        Me.ExportSetList.FullRowSelect = True
        Me.ExportSetList.GridLines = True
        Me.ExportSetList.HideSelection = False
        Me.ExportSetList.Location = New System.Drawing.Point(6, 19)
        Me.ExportSetList.MultiSelect = False
        Me.ExportSetList.Name = "ExportSetList"
        Me.ExportSetList.OwnerDraw = True
        Me.ExportSetList.Size = New System.Drawing.Size(726, 195)
        Me.ExportSetList.TabIndex = 9
        Me.ExportSetList.UseCompatibleStateImageBehavior = False
        Me.ExportSetList.View = System.Windows.Forms.View.Details
        '
        'ClientColumn
        '
        Me.ClientColumn.Text = "Client"
        '
        'StudyColumn
        '
        Me.StudyColumn.Text = "Study"
        '
        'SurveyColumn
        '
        Me.SurveyColumn.Text = "Survey"
        '
        'SampleUnitColumn
        '
        Me.SampleUnitColumn.Text = "Unit"
        '
        'NameColumn
        '
        Me.NameColumn.Text = "Name"
        Me.NameColumn.Width = 96
        '
        'CreationDateColumn
        '
        Me.CreationDateColumn.Text = "Creation Date"
        Me.CreationDateColumn.Width = 164
        '
        'StartDateColumn
        '
        Me.StartDateColumn.Text = "Start Date"
        Me.StartDateColumn.Width = 130
        '
        'EndDateColumn
        '
        Me.EndDateColumn.Text = "End Date"
        Me.EndDateColumn.Width = 132
        '
        'ExportSetTypeColumn
        '
        Me.ExportSetTypeColumn.Text = "Type"
        '
        'ExportFileList
        '
        Me.ExportFileList.AllowColumnReorder = True
        Me.ExportFileList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExportFileList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader1, Me.ColumnHeader2, Me.ColumnHeader4, Me.ColumnHeader8, Me.ColumnHeader5, Me.ColumnHeader6, Me.ColumnHeader3, Me.ColumnHeader7})
        Me.ExportFileList.FullRowSelect = True
        Me.ExportFileList.GridLines = True
        Me.ExportFileList.HideSelection = False
        Me.ExportFileList.Location = New System.Drawing.Point(6, 19)
        Me.ExportFileList.MultiSelect = False
        Me.ExportFileList.Name = "ExportFileList"
        Me.ExportFileList.OwnerDraw = True
        Me.ExportFileList.Size = New System.Drawing.Size(726, 251)
        Me.ExportFileList.TabIndex = 9
        Me.ExportFileList.UseCompatibleStateImageBehavior = False
        Me.ExportFileList.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader1
        '
        Me.ColumnHeader1.Text = "Created Date"
        Me.ColumnHeader1.Width = 86
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Created By"
        Me.ColumnHeader2.Width = 87
        '
        'ColumnHeader4
        '
        Me.ColumnHeader4.Text = "File Type"
        Me.ColumnHeader4.Width = 64
        '
        'ColumnHeader5
        '
        Me.ColumnHeader5.Text = "File Path"
        Me.ColumnHeader5.Width = 259
        '
        'ColumnHeader6
        '
        Me.ColumnHeader6.Text = "File Parts"
        Me.ColumnHeader6.Width = 130
        '
        'ListViewImageList
        '
        Me.ListViewImageList.ImageStream = CType(resources.GetObject("ListViewImageList.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ListViewImageList.TransparentColor = System.Drawing.Color.Transparent
        Me.ListViewImageList.Images.SetKeyName(0, "Ascending")
        Me.ListViewImageList.Images.SetKeyName(1, "Descending")
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.ExportFileList)
        Me.GroupBox1.Location = New System.Drawing.Point(4, 33)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(738, 276)
        Me.GroupBox1.TabIndex = 10
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Files Exported"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.ExportSetList)
        Me.GroupBox2.Location = New System.Drawing.Point(4, 325)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(738, 220)
        Me.GroupBox2.TabIndex = 11
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Export definitions included in file"
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Directs Only"
        '
        'ColumnHeader7
        '
        Me.ColumnHeader7.Text = "Returns Only"
        '
        'ColumnHeader8
        '
        Me.ColumnHeader8.Text = "Record Count"
        Me.ColumnHeader8.Width = 88
        '
        'ExportHistoryDialog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Caption = "Export History"
        Me.ClientSize = New System.Drawing.Size(755, 596)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.TableLayoutPanel1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ExportHistoryDialog"
        Me.Text = "ExportHistoryDialog"
        Me.Controls.SetChildIndex(Me.TableLayoutPanel1, 0)
        Me.Controls.SetChildIndex(Me.GroupBox1, 0)
        Me.Controls.SetChildIndex(Me.GroupBox2, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.TableLayoutPanel1.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents TableLayoutPanel1 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Private WithEvents ExportSetList As System.Windows.Forms.ListView
    Friend WithEvents ClientColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents StudyColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents SurveyColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents NameColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents CreationDateColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents StartDateColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents EndDateColumn As System.Windows.Forms.ColumnHeader
    Private WithEvents ExportFileList As System.Windows.Forms.ListView
    Friend WithEvents ColumnHeader1 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader4 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader5 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader6 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ListViewImageList As System.Windows.Forms.ImageList
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents SampleUnitColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents ExportSetTypeColumn As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader7 As System.Windows.Forms.ColumnHeader
    Friend WithEvents ColumnHeader8 As System.Windows.Forms.ColumnHeader

End Class
