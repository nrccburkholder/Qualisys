<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ValidationDialog
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
        Me.btnOK = New System.Windows.Forms.Button
        Me.grdValidationErrors = New DevExpress.XtraGrid.GridControl
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.bsValidation = New System.Windows.Forms.BindingSource(Me.components)
        CType(Me.grdValidationErrors, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsValidation, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Message Validation"
        Me.mPaneCaption.Size = New System.Drawing.Size(571, 26)
        Me.mPaneCaption.TabStop = True
        Me.mPaneCaption.Text = "Message Validation"
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Location = New System.Drawing.Point(494, 453)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(75, 23)
        Me.btnOK.TabIndex = 1
        Me.btnOK.Text = "&OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'grdValidationErrors
        '
        Me.grdValidationErrors.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdValidationErrors.DataSource = Me.bsValidation
        Me.grdValidationErrors.EmbeddedNavigator.Name = ""
        Me.grdValidationErrors.Location = New System.Drawing.Point(4, 33)
        Me.grdValidationErrors.MainView = Me.GridView1
        Me.grdValidationErrors.Name = "grdValidationErrors"
        Me.grdValidationErrors.Size = New System.Drawing.Size(565, 414)
        Me.grdValidationErrors.TabIndex = 2
        Me.grdValidationErrors.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'GridView1
        '
        Me.GridView1.GridControl = Me.grdValidationErrors
        Me.GridView1.Name = "GridView1"
        '
        'ValidationDialog
        '
        Me.Caption = "Message Validation"
        Me.ClientSize = New System.Drawing.Size(573, 480)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.grdValidationErrors)
        Me.Name = "ValidationDialog"
        Me.Controls.SetChildIndex(Me.grdValidationErrors, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        CType(Me.grdValidationErrors, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsValidation, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents grdValidationErrors As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents bsValidation As System.Windows.Forms.BindingSource

End Class
