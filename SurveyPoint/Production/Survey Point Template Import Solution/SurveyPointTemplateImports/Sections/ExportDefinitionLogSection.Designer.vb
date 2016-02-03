<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ExportDefinitionLogSection
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
        Me.HeaderStrip1 = New Nrc.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.grdExportDefLog = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.GridView2 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.bsExportDefLog = New System.Windows.Forms.BindingSource(Me.components)
        Me.colLogID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colExportDefinitionID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCreated = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDateCompleted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumberFileDupsRemoved = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colErrorMessage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colStackTrace = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colNumberQMSDeDupsRemoved = New DevExpress.XtraGrid.Columns.GridColumn
        Me.HeaderStrip1.SuspendLayout()
        CType(Me.grdExportDefLog, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsExportDefLog, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = Nrc.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(745, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(182, 22)
        Me.ToolStripLabel1.Text = "Export Definition Log"
        '
        'grdExportDefLog
        '
        Me.grdExportDefLog.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdExportDefLog.DataSource = Me.bsExportDefLog
        Me.grdExportDefLog.EmbeddedNavigator.Name = ""
        Me.grdExportDefLog.Location = New System.Drawing.Point(3, 28)
        Me.grdExportDefLog.MainView = Me.GridView1
        Me.grdExportDefLog.Name = "grdExportDefLog"
        Me.grdExportDefLog.Size = New System.Drawing.Size(739, 632)
        Me.grdExportDefLog.TabIndex = 1
        Me.grdExportDefLog.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1, Me.GridView2})
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colLogID, Me.colExportDefinitionID, Me.colDateCreated, Me.colDateCompleted, Me.colNumberFileDupsRemoved, Me.colNumberQMSDeDupsRemoved, Me.colErrorMessage, Me.colStackTrace})
        Me.GridView1.GridControl = Me.grdExportDefLog
        Me.GridView1.Name = "GridView1"
        '
        'GridView2
        '
        Me.GridView2.GridControl = Me.grdExportDefLog
        Me.GridView2.Name = "GridView2"
        '
        'bsExportDefLog
        '
        Me.bsExportDefLog.DataSource = GetType(Nrc.SurveyPoint.Library.SPTI_ExportDefinitionLog)
        '
        'colLogID
        '
        Me.colLogID.Caption = "LogID"
        Me.colLogID.FieldName = "LogID"
        Me.colLogID.Name = "colLogID"
        Me.colLogID.OptionsColumn.ReadOnly = True
        Me.colLogID.Visible = True
        Me.colLogID.VisibleIndex = 0
        Me.colLogID.Width = 50
        '
        'colExportDefinitionID
        '
        Me.colExportDefinitionID.Caption = "ExportDefinitionID"
        Me.colExportDefinitionID.FieldName = "ExportDefinitionID"
        Me.colExportDefinitionID.Name = "colExportDefinitionID"
        Me.colExportDefinitionID.Visible = True
        Me.colExportDefinitionID.VisibleIndex = 1
        Me.colExportDefinitionID.Width = 122
        '
        'colDateCreated
        '
        Me.colDateCreated.Caption = "DateCreated"
        Me.colDateCreated.FieldName = "DateCreated"
        Me.colDateCreated.Name = "colDateCreated"
        Me.colDateCreated.Visible = True
        Me.colDateCreated.VisibleIndex = 2
        Me.colDateCreated.Width = 89
        '
        'colDateCompleted
        '
        Me.colDateCompleted.Caption = "DateCompleted"
        Me.colDateCompleted.FieldName = "DateCompleted"
        Me.colDateCompleted.Name = "colDateCompleted"
        Me.colDateCompleted.Visible = True
        Me.colDateCompleted.VisibleIndex = 3
        Me.colDateCompleted.Width = 94
        '
        'colNumberFileDupsRemoved
        '
        Me.colNumberFileDupsRemoved.Caption = "NumberFileDupsRemoved"
        Me.colNumberFileDupsRemoved.FieldName = "NumberFileDupsRemoved"
        Me.colNumberFileDupsRemoved.Name = "colNumberFileDupsRemoved"
        Me.colNumberFileDupsRemoved.Visible = True
        Me.colNumberFileDupsRemoved.VisibleIndex = 4
        Me.colNumberFileDupsRemoved.Width = 109
        '
        'colErrorMessage
        '
        Me.colErrorMessage.Caption = "ErrorMessage"
        Me.colErrorMessage.FieldName = "ErrorMessage"
        Me.colErrorMessage.Name = "colErrorMessage"
        Me.colErrorMessage.Visible = True
        Me.colErrorMessage.VisibleIndex = 5
        Me.colErrorMessage.Width = 38
        '
        'colStackTrace
        '
        Me.colStackTrace.Caption = "StackTrace"
        Me.colStackTrace.FieldName = "StackTrace"
        Me.colStackTrace.Name = "colStackTrace"
        Me.colStackTrace.Visible = True
        Me.colStackTrace.VisibleIndex = 6
        Me.colStackTrace.Width = 38
        '
        'colNumberQMSDeDupsRemoved
        '
        Me.colNumberQMSDeDupsRemoved.Caption = "NumberQMSDeDupsRemoved"
        Me.colNumberQMSDeDupsRemoved.FieldName = "NumberQMSDeDupsRemoved"
        Me.colNumberQMSDeDupsRemoved.Name = "colNumberQMSDeDupsRemoved"
        Me.colNumberQMSDeDupsRemoved.Visible = True
        Me.colNumberQMSDeDupsRemoved.VisibleIndex = 5
        Me.colNumberQMSDeDupsRemoved.Width = 191
        '
        'ExportDefinitionLogSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.grdExportDefLog)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "ExportDefinitionLogSection"
        Me.Size = New System.Drawing.Size(745, 663)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        CType(Me.grdExportDefLog, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView2, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsExportDefLog, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As Nrc.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents grdExportDefLog As DevExpress.XtraGrid.GridControl
    Friend WithEvents bsExportDefLog As System.Windows.Forms.BindingSource
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents GridView2 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents colLogID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colExportDefinitionID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCreated As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDateCompleted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumberFileDupsRemoved As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colNumberQMSDeDupsRemoved As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colErrorMessage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colStackTrace As DevExpress.XtraGrid.Columns.GridColumn

End Class
