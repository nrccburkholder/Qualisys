<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UpdateExceptionsDialog
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
        Me.UpdateExceptionsGrid = New DevExpress.XtraGrid.GridControl
        Me.UpdateExceptionsBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.UpdateExceptionsGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colFileName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.UpdateExceptionsToolStrip = New System.Windows.Forms.ToolStrip
        Me.UpdateExceptionsExcelTSButton = New System.Windows.Forms.ToolStripButton
        Me.UpdateExceptionsPrintTSButton = New System.Windows.Forms.ToolStripButton
        Me.OK_Button = New System.Windows.Forms.Button
        Me.SaveFileDialog = New System.Windows.Forms.SaveFileDialog
        CType(Me.UpdateExceptionsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateExceptionsBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.UpdateExceptionsGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.UpdateExceptionsToolStrip.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Update Exceptions"
        Me.mPaneCaption.Size = New System.Drawing.Size(463, 26)
        Me.mPaneCaption.Text = "Update Exceptions"
        '
        'UpdateExceptionsGrid
        '
        Me.UpdateExceptionsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateExceptionsGrid.DataSource = Me.UpdateExceptionsBindingSource
        Me.UpdateExceptionsGrid.EmbeddedNavigator.Name = ""
        Me.UpdateExceptionsGrid.Location = New System.Drawing.Point(6, 58)
        Me.UpdateExceptionsGrid.MainView = Me.UpdateExceptionsGridView
        Me.UpdateExceptionsGrid.Name = "UpdateExceptionsGrid"
        Me.UpdateExceptionsGrid.Size = New System.Drawing.Size(455, 263)
        Me.UpdateExceptionsGrid.TabIndex = 1
        Me.UpdateExceptionsGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.UpdateExceptionsGridView})
        '
        'UpdateExceptionsBindingSource
        '
        Me.UpdateExceptionsBindingSource.DataSource = GetType(Nrc.SurveyPoint.Library.UpdateFile)
        '
        'UpdateExceptionsGridView
        '
        Me.UpdateExceptionsGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colFileName})
        Me.UpdateExceptionsGridView.GridControl = Me.UpdateExceptionsGrid
        Me.UpdateExceptionsGridView.Name = "UpdateExceptionsGridView"
        Me.UpdateExceptionsGridView.OptionsBehavior.Editable = False
        Me.UpdateExceptionsGridView.OptionsCustomization.AllowColumnMoving = False
        Me.UpdateExceptionsGridView.OptionsCustomization.AllowFilter = False
        Me.UpdateExceptionsGridView.OptionsCustomization.AllowGroup = False
        Me.UpdateExceptionsGridView.OptionsFilter.AllowFilterEditor = False
        Me.UpdateExceptionsGridView.OptionsPrint.EnableAppearanceEvenRow = True
        Me.UpdateExceptionsGridView.OptionsPrint.EnableAppearanceOddRow = True
        Me.UpdateExceptionsGridView.OptionsPrint.ExpandAllDetails = True
        Me.UpdateExceptionsGridView.OptionsPrint.PrintDetails = True
        Me.UpdateExceptionsGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.UpdateExceptionsGridView.OptionsView.EnableAppearanceOddRow = True
        Me.UpdateExceptionsGridView.OptionsView.ShowGroupPanel = False
        '
        'colFileName
        '
        Me.colFileName.Caption = "File Name"
        Me.colFileName.FieldName = "FileName"
        Me.colFileName.Name = "colFileName"
        Me.colFileName.Visible = True
        Me.colFileName.VisibleIndex = 0
        '
        'UpdateExceptionsToolStrip
        '
        Me.UpdateExceptionsToolStrip.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UpdateExceptionsToolStrip.AutoSize = False
        Me.UpdateExceptionsToolStrip.Dock = System.Windows.Forms.DockStyle.None
        Me.UpdateExceptionsToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.UpdateExceptionsToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.UpdateExceptionsExcelTSButton, Me.UpdateExceptionsPrintTSButton})
        Me.UpdateExceptionsToolStrip.Location = New System.Drawing.Point(1, 27)
        Me.UpdateExceptionsToolStrip.Name = "UpdateExceptionsToolStrip"
        Me.UpdateExceptionsToolStrip.Size = New System.Drawing.Size(463, 25)
        Me.UpdateExceptionsToolStrip.TabIndex = 2
        '
        'UpdateExceptionsExcelTSButton
        '
        Me.UpdateExceptionsExcelTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.Excel16
        Me.UpdateExceptionsExcelTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateExceptionsExcelTSButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.UpdateExceptionsExcelTSButton.Name = "UpdateExceptionsExcelTSButton"
        Me.UpdateExceptionsExcelTSButton.Size = New System.Drawing.Size(100, 22)
        Me.UpdateExceptionsExcelTSButton.Text = "Export to Excel"
        '
        'UpdateExceptionsPrintTSButton
        '
        Me.UpdateExceptionsPrintTSButton.Image = Global.Nrc.SurveyPointUtilities.My.Resources.Resources.TestPrint16
        Me.UpdateExceptionsPrintTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.UpdateExceptionsPrintTSButton.Name = "UpdateExceptionsPrintTSButton"
        Me.UpdateExceptionsPrintTSButton.Size = New System.Drawing.Size(49, 22)
        Me.UpdateExceptionsPrintTSButton.Text = "Print"
        '
        'OK_Button
        '
        Me.OK_Button.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OK_Button.Location = New System.Drawing.Point(368, 327)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(93, 28)
        Me.OK_Button.TabIndex = 3
        Me.OK_Button.Text = "OK"
        Me.OK_Button.UseVisualStyleBackColor = True
        '
        'SaveFileDialog
        '
        Me.SaveFileDialog.DefaultExt = "xls"
        Me.SaveFileDialog.Filter = "Excel Files|*.xls"
        Me.SaveFileDialog.Title = "Update Exceptions"
        '
        'UpdateExceptionsDialog
        '
        Me.AcceptButton = Me.OK_Button
        Me.Caption = "Update Exceptions"
        Me.ClientSize = New System.Drawing.Size(465, 359)
        Me.ControlBox = False
        Me.Controls.Add(Me.OK_Button)
        Me.Controls.Add(Me.UpdateExceptionsToolStrip)
        Me.Controls.Add(Me.UpdateExceptionsGrid)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "UpdateExceptionsDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.UpdateExceptionsGrid, 0)
        Me.Controls.SetChildIndex(Me.UpdateExceptionsToolStrip, 0)
        Me.Controls.SetChildIndex(Me.OK_Button, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.UpdateExceptionsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateExceptionsBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.UpdateExceptionsGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.UpdateExceptionsToolStrip.ResumeLayout(False)
        Me.UpdateExceptionsToolStrip.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents UpdateExceptionsGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents UpdateExceptionsGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents UpdateExceptionsToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents UpdateExceptionsExcelTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateExceptionsPrintTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents UpdateExceptionsBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colFileName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents SaveFileDialog As System.Windows.Forms.SaveFileDialog

End Class
