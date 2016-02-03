<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ValidationErrorsDialog
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
        Me.grdErrors = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.cmdClose = New System.Windows.Forms.Button
        Me.bsBrokenRules = New System.Windows.Forms.BindingSource(Me.components)
        Me.colRuleName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDescription = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colProperty = New DevExpress.XtraGrid.Columns.GridColumn
        CType(Me.grdErrors, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsBrokenRules, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Validation Errors"
        Me.mPaneCaption.Size = New System.Drawing.Size(680, 26)
        Me.mPaneCaption.Text = "Validation Errors"
        '
        'grdErrors
        '
        Me.grdErrors.DataSource = Me.bsBrokenRules
        Me.grdErrors.EmbeddedNavigator.Name = ""
        Me.grdErrors.Location = New System.Drawing.Point(4, 33)
        Me.grdErrors.MainView = Me.GridView1
        Me.grdErrors.Name = "grdErrors"
        Me.grdErrors.Size = New System.Drawing.Size(674, 265)
        Me.grdErrors.TabIndex = 1
        Me.grdErrors.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colRuleName, Me.colDescription, Me.colProperty})
        Me.GridView1.GridControl = Me.grdErrors
        Me.GridView1.Name = "GridView1"
        Me.GridView1.OptionsBehavior.Editable = False
        Me.GridView1.OptionsView.ShowColumnHeaders = False
        Me.GridView1.OptionsView.ShowGroupPanel = False
        '
        'cmdClose
        '
        Me.cmdClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdClose.Location = New System.Drawing.Point(603, 304)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.Size = New System.Drawing.Size(75, 23)
        Me.cmdClose.TabIndex = 2
        Me.cmdClose.Text = "Close"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'bsBrokenRules
        '
        Me.bsBrokenRules.DataSource = GetType(Nrc.Framework.BusinessLogic.Validation.BrokenRule)
        '
        'colRuleName
        '
        Me.colRuleName.Caption = "RuleName"
        Me.colRuleName.FieldName = "RuleName"
        Me.colRuleName.Name = "colRuleName"
        Me.colRuleName.OptionsColumn.ReadOnly = True
        '
        'colDescription
        '
        Me.colDescription.Caption = "Description"
        Me.colDescription.FieldName = "Description"
        Me.colDescription.Name = "colDescription"
        Me.colDescription.OptionsColumn.ReadOnly = True
        Me.colDescription.Visible = True
        Me.colDescription.VisibleIndex = 0
        '
        'colProperty
        '
        Me.colProperty.Caption = "Property"
        Me.colProperty.FieldName = "Property"
        Me.colProperty.Name = "colProperty"
        Me.colProperty.OptionsColumn.ReadOnly = True
        '
        'ValidationErrorsDialog
        '
        Me.Caption = "Validation Errors"
        Me.ClientSize = New System.Drawing.Size(682, 341)
        Me.Controls.Add(Me.grdErrors)
        Me.Controls.Add(Me.cmdClose)
        Me.Name = "ValidationErrorsDialog"
        Me.Controls.SetChildIndex(Me.cmdClose, 0)
        Me.Controls.SetChildIndex(Me.grdErrors, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.grdErrors, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsBrokenRules, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents grdErrors As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents cmdClose As System.Windows.Forms.Button
    Friend WithEvents bsBrokenRules As System.Windows.Forms.BindingSource
    Friend WithEvents colRuleName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDescription As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colProperty As DevExpress.XtraGrid.Columns.GridColumn

End Class
