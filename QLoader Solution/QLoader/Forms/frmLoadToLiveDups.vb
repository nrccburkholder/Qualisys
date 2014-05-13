Option Explicit On 
Option Strict On

Imports Nrc.Qualisys.QLoader.Library20

Public Class frmLoadToLiveDups
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal tableName As String, ByVal duplicatesTable As DataTable, ByVal package As DTSPackage, ByVal dataFileID As Integer, ByVal definitions As LoadToLiveDefinitionCollection)

        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mTableName = tableName
        mDuplicatesTable = duplicatesTable
        mPackage = package
        mDataFileID = dataFileID
        mDefinitions = definitions

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
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents OKButton As System.Windows.Forms.Button
    Friend WithEvents DuplicatesGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents DuplicatesDataGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents DuplicatesToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents ExportToExcelToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents DeleteToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents sfdSave As System.Windows.Forms.SaveFileDialog
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.CloseButton = New System.Windows.Forms.Button
        Me.sfdSave = New System.Windows.Forms.SaveFileDialog
        Me.OKButton = New System.Windows.Forms.Button
        Me.DuplicatesGrid = New DevExpress.XtraGrid.GridControl
        Me.DuplicatesDataGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.DuplicatesToolStrip = New System.Windows.Forms.ToolStrip
        Me.ExportToExcelToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.DeleteToolStripButton = New System.Windows.Forms.ToolStripButton
        CType(Me.DuplicatesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.DuplicatesDataGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.DuplicatesToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Load To Live Duplicates"
        Me.mPaneCaption.Size = New System.Drawing.Size(582, 26)
        Me.mPaneCaption.Text = "Load To Live Duplicates"
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.CloseButton.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.CloseButton.Location = New System.Drawing.Point(501, 445)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(75, 23)
        Me.CloseButton.TabIndex = 4
        Me.CloseButton.Text = "Close"
        '
        'sfdSave
        '
        Me.sfdSave.DefaultExt = "xls"
        Me.sfdSave.Filter = "Excel Files|.xls"
        '
        'OKButton
        '
        Me.OKButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OKButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.OKButton.Location = New System.Drawing.Point(420, 445)
        Me.OKButton.Name = "OKButton"
        Me.OKButton.Size = New System.Drawing.Size(75, 23)
        Me.OKButton.TabIndex = 3
        Me.OKButton.Text = "OK"
        '
        'DuplicatesGrid
        '
        Me.DuplicatesGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DuplicatesGrid.EmbeddedNavigator.Name = ""
        Me.DuplicatesGrid.Location = New System.Drawing.Point(6, 55)
        Me.DuplicatesGrid.LookAndFeel.UseWindowsXPTheme = True
        Me.DuplicatesGrid.MainView = Me.DuplicatesDataGridView
        Me.DuplicatesGrid.Name = "DuplicatesGrid"
        Me.DuplicatesGrid.Size = New System.Drawing.Size(570, 380)
        Me.DuplicatesGrid.TabIndex = 2
        Me.DuplicatesGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.DuplicatesDataGridView})
        '
        'DuplicatesDataGridView
        '
        Me.DuplicatesDataGridView.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus
        Me.DuplicatesDataGridView.GridControl = Me.DuplicatesGrid
        Me.DuplicatesDataGridView.HorzScrollVisibility = DevExpress.XtraGrid.Views.Base.ScrollVisibility.Always
        Me.DuplicatesDataGridView.Name = "DuplicatesDataGridView"
        Me.DuplicatesDataGridView.OptionsBehavior.Editable = False
        Me.DuplicatesDataGridView.OptionsCustomization.AllowFilter = False
        Me.DuplicatesDataGridView.OptionsCustomization.AllowGroup = False
        Me.DuplicatesDataGridView.OptionsView.ColumnAutoWidth = False
        Me.DuplicatesDataGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.DuplicatesDataGridView.OptionsView.EnableAppearanceOddRow = True
        Me.DuplicatesDataGridView.OptionsView.ShowGroupPanel = False
        '
        'DuplicatesToolStrip
        '
        Me.DuplicatesToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportToExcelToolStripButton, Me.DeleteToolStripButton})
        Me.DuplicatesToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.DuplicatesToolStrip.Name = "DuplicatesToolStrip"
        Me.DuplicatesToolStrip.Size = New System.Drawing.Size(582, 25)
        Me.DuplicatesToolStrip.TabIndex = 1
        Me.DuplicatesToolStrip.Text = "ToolStrip1"
        '
        'ExportToExcelToolStripButton
        '
        Me.ExportToExcelToolStripButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.ExportToExcelToolStripButton.Image = Global.Nrc.Qualisys.QLoader.My.Resources.Resources.Excel16
        Me.ExportToExcelToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportToExcelToolStripButton.Name = "ExportToExcelToolStripButton"
        Me.ExportToExcelToolStripButton.Size = New System.Drawing.Size(103, 22)
        Me.ExportToExcelToolStripButton.Text = "Export to Excel"
        '
        'DeleteToolStripButton
        '
        Me.DeleteToolStripButton.Image = Global.Nrc.Qualisys.QLoader.My.Resources.Resources.DeleteRed16
        Me.DeleteToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.DeleteToolStripButton.Name = "DeleteToolStripButton"
        Me.DeleteToolStripButton.Size = New System.Drawing.Size(133, 22)
        Me.DeleteToolStripButton.Text = "Delete Selected Row"
        '
        'frmLoadToLiveDups
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.CancelButton = Me.CloseButton
        Me.Caption = "Load To Live Duplicates"
        Me.ClientSize = New System.Drawing.Size(584, 476)
        Me.ControlBox = False
        Me.Controls.Add(Me.DuplicatesGrid)
        Me.Controls.Add(Me.DuplicatesToolStrip)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.OKButton)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MinimumSize = New System.Drawing.Size(507, 492)
        Me.Name = "frmLoadToLiveDups"
        Me.ShowIcon = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Controls.SetChildIndex(Me.OKButton, 0)
        Me.Controls.SetChildIndex(Me.CloseButton, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.DuplicatesToolStrip, 0)
        Me.Controls.SetChildIndex(Me.DuplicatesGrid, 0)
        CType(Me.DuplicatesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.DuplicatesDataGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.DuplicatesToolStrip.ResumeLayout(False)
        Me.DuplicatesToolStrip.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

#Region " Private Members "

    Private mDuplicatesTable As DataTable
    Private mTableName As String = String.Empty
    Private mPackage As DTSPackage
    Private mDataFileID As Integer
    Private mDefinitions As LoadToLiveDefinitionCollection

#End Region

#Region " Event Handlers "

    Private Sub frmLoadToLiveDups_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        DuplicatesGrid.DataSource = mDuplicatesTable
        Caption = String.Format("Load To Live Duplicates [{0}]", mTableName)
        OKButton.Enabled = False

    End Sub

    Private Sub ExportToExcelToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportToExcelToolStripButton.Click

        'Prompt user for filename
        If sfdSave.ShowDialog = Windows.Forms.DialogResult.OK Then
            DuplicatesDataGridView.ExportToXls(sfdSave.FileName)
        End If

    End Sub

    Private Sub DeleteToolStripButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteToolStripButton.Click

        'Loop through all of the selected rows
        For Each rowHandle As Integer In DuplicatesDataGridView.GetSelectedRows
            'Get the data row related to this rowHandle
            Dim row As DataRow = DuplicatesDataGridView.GetDataRow(rowHandle)

            'Execute the delete from the database
            LoadToLiveDefinition.LoadToLiveDeleteDuplicate(row, mDataFileID, mTableName, mPackage)

            'Remove this row from the grid
            DuplicatesGrid.DataSource = LoadToLiveDefinition.LoadToLiveDuplicateCheck(mDataFileID, mTableName, mPackage, mDefinitions)

            'Determine if the OK button is available
            OKButton.Enabled = (DuplicatesDataGridView.DataRowCount = 0)
        Next

    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click

        DialogResult = Windows.Forms.DialogResult.OK
        Close()

    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click

        Close()

    End Sub

#End Region

#Region " Private Methods "

#End Region

End Class
