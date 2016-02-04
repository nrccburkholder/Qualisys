<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportGroupRunLog
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
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.StatusStrip1 = New System.Windows.Forms.StatusStrip
        Me.ToolStripStatusLabel1 = New System.Windows.Forms.ToolStripStatusLabel
        Me.ToolStripProgressBar1 = New System.Windows.Forms.ToolStripProgressBar
        Me.ObjectMessageGrid = New DevExpress.XtraGrid.GridControl
        Me.ObjectMessageBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colMessageTitle = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMessageType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colErrorNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStackTrace = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportObjectMessageID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.cmdClose = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.StatusStrip1.SuspendLayout()
        CType(Me.ObjectMessageGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ObjectMessageBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "File Export"
        Me.mPaneCaption.Size = New System.Drawing.Size(597, 26)
        Me.mPaneCaption.Text = "File Export"
        '
        'Panel1
        '
        Me.Panel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel1.AutoScroll = True
        Me.Panel1.Controls.Add(Me.StatusStrip1)
        Me.Panel1.Controls.Add(Me.ObjectMessageGrid)
        Me.Panel1.Controls.Add(Me.cmdClose)
        Me.Panel1.Location = New System.Drawing.Point(4, 33)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(591, 548)
        Me.Panel1.TabIndex = 1
        '
        'StatusStrip1
        '
        Me.StatusStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripStatusLabel1, Me.ToolStripProgressBar1})
        Me.StatusStrip1.Location = New System.Drawing.Point(0, 526)
        Me.StatusStrip1.Name = "StatusStrip1"
        Me.StatusStrip1.Size = New System.Drawing.Size(591, 22)
        Me.StatusStrip1.TabIndex = 2
        Me.StatusStrip1.Text = "StatusStrip1"
        '
        'ToolStripStatusLabel1
        '
        Me.ToolStripStatusLabel1.Name = "ToolStripStatusLabel1"
        Me.ToolStripStatusLabel1.Size = New System.Drawing.Size(0, 17)
        '
        'ToolStripProgressBar1
        '
        Me.ToolStripProgressBar1.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ToolStripProgressBar1.Name = "ToolStripProgressBar1"
        Me.ToolStripProgressBar1.Size = New System.Drawing.Size(100, 16)
        Me.ToolStripProgressBar1.Value = 1
        Me.ToolStripProgressBar1.Visible = False
        '
        'ObjectMessageGrid
        '
        Me.ObjectMessageGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ObjectMessageGrid.DataSource = Me.ObjectMessageBindingSource
        Me.ObjectMessageGrid.EmbeddedNavigator.Name = ""
        Me.ObjectMessageGrid.Location = New System.Drawing.Point(3, 3)
        Me.ObjectMessageGrid.MainView = Me.GridView1
        Me.ObjectMessageGrid.Name = "ObjectMessageGrid"
        Me.ObjectMessageGrid.Size = New System.Drawing.Size(577, 470)
        Me.ObjectMessageGrid.TabIndex = 1
        Me.ObjectMessageGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'ObjectMessageBindingSource
        '
        Me.ObjectMessageBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.ExportObjectMessage)
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colMessageTitle, Me.colMessageType, Me.colMessage, Me.colErrorNumber, Me.colStackTrace, Me.colExportObjectMessageID})
        Me.GridView1.GridControl = Me.ObjectMessageGrid
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsCustomization.AllowColumnMoving = False
        Me.GridView1.OptionsCustomization.AllowFilter = False
        Me.GridView1.OptionsCustomization.AllowGroup = False
        Me.GridView1.OptionsView.ColumnAutoWidth = False
        Me.GridView1.OptionsView.EnableAppearanceEvenRow = True
        Me.GridView1.OptionsView.EnableAppearanceOddRow = True
        Me.GridView1.OptionsView.ShowAutoFilterRow = True
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'colMessageTitle
        '
        Me.colMessageTitle.Caption = "Message Title"
        Me.colMessageTitle.FieldName = "MessageTitle"
        Me.colMessageTitle.Name = "colMessageTitle"
        Me.colMessageTitle.OptionsColumn.ReadOnly = True
        Me.colMessageTitle.Visible = True
        Me.colMessageTitle.VisibleIndex = 0
        Me.colMessageTitle.Width = 111
        '
        'colMessageType
        '
        Me.colMessageType.Caption = "Message Type"
        Me.colMessageType.FieldName = "MessageType"
        Me.colMessageType.Name = "colMessageType"
        Me.colMessageType.OptionsColumn.ReadOnly = True
        Me.colMessageType.Visible = True
        Me.colMessageType.VisibleIndex = 1
        Me.colMessageType.Width = 111
        '
        'colMessage
        '
        Me.colMessage.Caption = "Message"
        Me.colMessage.FieldName = "Message"
        Me.colMessage.Name = "colMessage"
        Me.colMessage.OptionsColumn.ReadOnly = True
        Me.colMessage.Visible = True
        Me.colMessage.VisibleIndex = 2
        Me.colMessage.Width = 312
        '
        'colErrorNumber
        '
        Me.colErrorNumber.Caption = "Error Number"
        Me.colErrorNumber.FieldName = "ErrorNumber"
        Me.colErrorNumber.Name = "colErrorNumber"
        Me.colErrorNumber.OptionsColumn.ReadOnly = True
        Me.colErrorNumber.Visible = True
        Me.colErrorNumber.VisibleIndex = 4
        Me.colErrorNumber.Width = 44
        '
        'colStackTrace
        '
        Me.colStackTrace.Caption = "Stack Trace"
        Me.colStackTrace.FieldName = "StackTrace"
        Me.colStackTrace.Name = "colStackTrace"
        Me.colStackTrace.OptionsColumn.ReadOnly = True
        Me.colStackTrace.Visible = True
        Me.colStackTrace.VisibleIndex = 3
        Me.colStackTrace.Width = 94
        '
        'colExportObjectMessageID
        '
        Me.colExportObjectMessageID.Caption = "ExportObjectMessageID"
        Me.colExportObjectMessageID.FieldName = "ExportObjectMessageID"
        Me.colExportObjectMessageID.Name = "colExportObjectMessageID"
        Me.colExportObjectMessageID.OptionsColumn.ReadOnly = True
        '
        'cmdClose
        '
        Me.cmdClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdClose.Enabled = False
        Me.cmdClose.Location = New System.Drawing.Point(513, 500)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(75, 23)
        Me.cmdClose.TabIndex = 0
        Me.cmdClose.Text = "OK"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'ExportGroupRunLog
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Caption = "File Export"
        Me.ClientSize = New System.Drawing.Size(599, 585)
        Me.ControlBox = False
        Me.Controls.Add(Me.Panel1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.Name = "ExportGroupRunLog"
        Me.Controls.SetChildIndex(Me.Panel1, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Panel1.ResumeLayout(False)
        Me.Panel1.PerformLayout()
        Me.StatusStrip1.ResumeLayout(False)
        Me.StatusStrip1.PerformLayout()
        CType(Me.ObjectMessageGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ObjectMessageBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents ObjectMessageGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents ObjectMessageBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colStackTrace As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessageType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportObjectMessageID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colMessageTitle As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colErrorNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents StatusStrip1 As System.Windows.Forms.StatusStrip
    Friend WithEvents ToolStripStatusLabel1 As System.Windows.Forms.ToolStripStatusLabel
    Friend WithEvents ToolStripProgressBar1 As System.Windows.Forms.ToolStripProgressBar
    Friend WithEvents cmdClose As System.Windows.Forms.Button

End Class
