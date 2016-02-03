<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportDefinitionStatusDialog
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
        Me.cmdClose = New System.Windows.Forms.Button
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.Label1 = New System.Windows.Forms.Label
        Me.GridControl1 = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.bsExportMessages = New System.Windows.Forms.BindingSource(Me.components)
        Me.colExportObjectMessageID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMessageType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colErrorNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStackTrace = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMessageTitle = New DevExpress.XtraGrid.Columns.GridColumn
        Me.ToolStripProgressBar1 = New System.Windows.Forms.ToolStripProgressBar
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel
        Me.StatusStrip1.SuspendLayout()
        CType(Me.GridControl1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsExportMessages, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Export Definition Run Status"
        Me.mPaneCaption.Size = New System.Drawing.Size(684, 26)
        Me.mPaneCaption.Text = "Export Definition Run Status"
        '
        'cmdClose
        '
        Me.cmdClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdClose.Location = New System.Drawing.Point(607, 414)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(75, 23)
        Me.cmdClose.TabIndex = 2
        Me.cmdClose.Text = "&Close"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripProgressBar1, Me.ToolStripStatusLabel1})
        Me.StatusStrip1.Location = New System.Drawing.Point(1, 440)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(684, 22)
        Me.StatusStrip1.TabIndex = 3
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(4, 30)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(40, 13)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "Status:"
        '
        'GridControl1
        '
        Me.GridControl1.DataSource = Me.bsExportMessages
        Me.GridControl1.EmbeddedNavigator.Name = ""
        Me.GridControl1.Location = New System.Drawing.Point(7, 46)
        Me.GridControl1.MainView = Me.GridView1
        Me.GridControl1.Name = "GridControl1"
        Me.GridControl1.Size = New System.Drawing.Size(675, 362)
        Me.GridControl1.TabIndex = 5
        Me.GridControl1.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colExportObjectMessageID, Me.colMessageType, Me.colMessage, Me.colErrorNumber, Me.colStackTrace, Me.colMessageTitle})
        Me.GridView1.GridControl = Me.GridControl1
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsCustomization.AllowColumnMoving = False
        Me.GridView1.OptionsCustomization.AllowFilter = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsCustomization.AllowSort = False
        Me.GridView1.OptionsFilter.AllowFilterEditor = False
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'bsExportMessages
        '
        Me.bsExportMessages.DataSource = GetType(Nrc.SurveyPoint.Library.ExportObjectMessage)
        '
        'colExportObjectMessageID
        '
        Me.colExportObjectMessageID.Caption = "ExportObjectMessageID"
        Me.colExportObjectMessageID.FieldName = "ExportObjectMessageID"
        Me.colExportObjectMessageID.Name = "colExportObjectMessageID"
        Me.colExportObjectMessageID.OptionsColumn.ReadOnly = True
        '
        'colMessageType
        '
        Me.colMessageType.Caption = "Message Type"
        Me.colMessageType.FieldName = "MessageType"
        Me.colMessageType.Name = "colMessageType"
        Me.colMessageType.OptionsColumn.ReadOnly = True
        Me.colMessageType.Visible = True
        Me.colMessageType.VisibleIndex = 0
        Me.colMessageType.Width = 175
        '
        'colMessage
        '
        Me.colMessage.Caption = "Message"
        Me.colMessage.FieldName = "Message"
        Me.colMessage.Name = "colMessage"
        Me.colMessage.OptionsColumn.ReadOnly = True
        Me.colMessage.Visible = True
        Me.colMessage.VisibleIndex = 1
        Me.colMessage.Width = 277
        '
        'colErrorNumber
        '
        Me.colErrorNumber.Caption = "ErrorNumber"
        Me.colErrorNumber.FieldName = "ErrorNumber"
        Me.colErrorNumber.Name = "colErrorNumber"
        Me.colErrorNumber.OptionsColumn.ReadOnly = True
        '
        'colStackTrace
        '
        Me.colStackTrace.Caption = "StackTrace"
        Me.colStackTrace.FieldName = "StackTrace"
        Me.colStackTrace.Name = "colStackTrace"
        Me.colStackTrace.OptionsColumn.ReadOnly = True
        Me.colStackTrace.Visible = True
        Me.colStackTrace.VisibleIndex = 2
        Me.colStackTrace.Width = 202
        '
        'colMessageTitle
        '
        Me.colMessageTitle.Caption = "MessageTitle"
        Me.colMessageTitle.FieldName = "MessageTitle"
        Me.colMessageTitle.Name = "colMessageTitle"
        Me.colMessageTitle.OptionsColumn.ReadOnly = True
        '
        'ToolStripProgressBar1
        '
        Me.ToolStripProgressBar1.Name = "ToolStripProgressBar1"
        Me.ToolStripProgressBar1.Size = New System.Drawing.Size(100, 16)
        Me.ToolStripProgressBar1.Value = 1
        Me.ToolStripProgressBar1.Visible = False
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(111, 17)
        Me.ToolStripStatusLabel1.Text = "ToolStripStatusLabel1"
        '
        'ExportDefinitionStatusDialog
        '
        Me.Caption = "Export Definition Run Status"
        Me.ClientSize = New System.Drawing.Size(686, 463)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.GridControl1)
        Me.Controls.Add(Me.StatusStrip1)
        Me.Controls.Add(Me.cmdClose)
        Me.Name = "ExportDefinitionStatusDialog"
        Me.Controls.SetChildIndex(Me.cmdClose, 0)
        Me.Controls.SetChildIndex(Me.StatusStrip1, 0)
        Me.Controls.SetChildIndex(Me.GridControl1, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        CType(Me.GridControl1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsExportMessages, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cmdClose As System.Windows.Forms.Button
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents GridControl1 As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents bsExportMessages As System.Windows.Forms.BindingSource
    Friend WithEvents colExportObjectMessageID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessageType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colErrorNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStackTrace As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessageTitle As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents ToolStripProgressBar1 As System.Windows.Forms.ToolStripProgressBar
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel

End Class
