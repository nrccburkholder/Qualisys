Option Explicit On 
Option Strict On

Public Class frmDataGrid
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal table As DataTable)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.mTable = table
    End Sub


    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents btnExport As System.Windows.Forms.Button
    Friend WithEvents dgData As DevExpress.XtraGrid.GridControl
    Friend WithEvents dgDataGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents sfdSave As System.Windows.Forms.SaveFileDialog
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnClose = New System.Windows.Forms.Button
        Me.sfdSave = New System.Windows.Forms.SaveFileDialog
        Me.btnExport = New System.Windows.Forms.Button
        Me.dgData = New DevExpress.XtraGrid.GridControl
        Me.dgDataGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        CType(Me.dgData, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.dgDataGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Skipped Records"
        Me.mPaneCaption.Size = New System.Drawing.Size(622, 26)
        Me.mPaneCaption.Text = "Skipped Records"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnClose.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(8, 512)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(75, 23)
        Me.btnClose.TabIndex = 1
        Me.btnClose.Text = "Close"
        '
        'sfdSave
        '
        Me.sfdSave.DefaultExt = "xls"
        Me.sfdSave.Filter = "Excel Files|.xls"
        '
        'btnExport
        '
        Me.btnExport.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnExport.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExport.Location = New System.Drawing.Point(96, 512)
        Me.btnExport.Name = "btnExport"
        Me.btnExport.Size = New System.Drawing.Size(96, 23)
        Me.btnExport.TabIndex = 2
        Me.btnExport.Text = "Export To Excel"
        '
        'dgData
        '
        Me.dgData.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.dgData.EmbeddedNavigator.Name = ""
        Me.dgData.Location = New System.Drawing.Point(4, 33)
        Me.dgData.MainView = Me.dgDataGridView
        Me.dgData.Name = "dgData"
        Me.dgData.Size = New System.Drawing.Size(616, 473)
        Me.dgData.TabIndex = 3
        Me.dgData.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.dgDataGridView})
        '
        'dgDataGridView
        '
        Me.dgDataGridView.GridControl = Me.dgData
        Me.dgDataGridView.HorzScrollVisibility = DevExpress.XtraGrid.Views.Base.ScrollVisibility.Always
        Me.dgDataGridView.Name = "dgDataGridView"
        Me.dgDataGridView.OptionsBehavior.Editable = False
        Me.dgDataGridView.OptionsView.ColumnAutoWidth = False
        '
        'frmDataGrid
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.CancelButton = Me.btnClose
        Me.Caption = "Skipped Records"
        Me.ClientSize = New System.Drawing.Size(624, 544)
        Me.Controls.Add(Me.btnExport)
        Me.Controls.Add(Me.dgData)
        Me.Controls.Add(Me.btnClose)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmDataGrid"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.dgData, 0)
        Me.Controls.SetChildIndex(Me.btnExport, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.dgData, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.dgDataGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private mTable As DataTable

#End Region

#Region " Event Handlers "

    Private Sub frmSourceViewer_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If (Not Me.mTable Is Nothing) Then
            Me.dgData.DataSource = mTable
        End If
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClose.Click
        Me.dgData.Dispose()
        Me.Close()
    End Sub

    ''' <summary>
    ''' Exports Contents of Grid to Excel document
    ''' </summary>
    ''' <remarks>SK 08-27-2008 Changed from NRC framework's write excel function to built-in DevX export to excel</remarks>
    Private Sub btnExport_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExport.Click
        'Prompt user for filename
        If sfdSave.ShowDialog = Windows.Forms.DialogResult.OK Then
            dgDataGridView.ExportToXls(sfdSave.FileName)
        End If
    End Sub

#End Region

End Class
