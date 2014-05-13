<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ViewCommentForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ViewCommentForm))
        Me.CloseButton = New System.Windows.Forms.Button
        Me.PrintingSystem1 = New DevExpress.XtraPrinting.PrintingSystem(Me.components)
        Me.CommentTextBoxLink = New DevExpress.XtraPrintingLinks.RichTextBoxLink
        Me.CommentTextBox = New System.Windows.Forms.RichTextBox
        Me.ToolStrip1 = New System.Windows.Forms.ToolStrip
        Me.ExportToPDFToolStripButton = New System.Windows.Forms.ToolStripButton
        Me.PrintToolStripButton = New System.Windows.Forms.ToolStripButton
        CType(Me.PrintingSystem1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ToolStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.Location = New System.Drawing.Point(441, 407)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(75, 23)
        Me.CloseButton.TabIndex = 1
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = True
        '
        'PrintingSystem1
        '
        Me.PrintingSystem1.Links.AddRange(New Object() {Me.CommentTextBoxLink})
        '
        'CommentTextBoxLink
        '
        Me.CommentTextBoxLink.CustomPaperSize = New System.Drawing.Size(0, 0)
        Me.CommentTextBoxLink.ImageStream = CType(resources.GetObject("CommentTextBoxLink.ImageStream"), DevExpress.Utils.ImageCollectionStreamer)
        Me.CommentTextBoxLink.PrintingSystem = Me.PrintingSystem1
        Me.CommentTextBoxLink.RichTextBox = Me.CommentTextBox
        Me.CommentTextBoxLink.VerticalContentSplitting = DevExpress.XtraPrinting.VerticalContentSplitting.Smart
        '
        'CommentTextBox
        '
        Me.CommentTextBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CommentTextBox.BackColor = System.Drawing.SystemColors.Control
        Me.CommentTextBox.Location = New System.Drawing.Point(13, 36)
        Me.CommentTextBox.Name = "CommentTextBox"
        Me.CommentTextBox.ReadOnly = True
        Me.CommentTextBox.Size = New System.Drawing.Size(503, 361)
        Me.CommentTextBox.TabIndex = 3
        Me.CommentTextBox.Text = ""
        '
        'ToolStrip1
        '
        Me.ToolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.ToolStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ExportToPDFToolStripButton, Me.PrintToolStripButton})
        Me.ToolStrip1.Location = New System.Drawing.Point(0, 0)
        Me.ToolStrip1.Name = "ToolStrip1"
        Me.ToolStrip1.Size = New System.Drawing.Size(528, 25)
        Me.ToolStrip1.TabIndex = 4
        Me.ToolStrip1.Text = "ToolStrip1"
        '
        'ExportToPDFToolStripButton
        '
        Me.ExportToPDFToolStripButton.Image = Global.Nrc.QualiSys_Scanner_Interface.My.Resources.Resources.pdf_16x16
        Me.ExportToPDFToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.ExportToPDFToolStripButton.Margin = New System.Windows.Forms.Padding(5, 1, 0, 2)
        Me.ExportToPDFToolStripButton.Name = "ExportToPDFToolStripButton"
        Me.ExportToPDFToolStripButton.Size = New System.Drawing.Size(96, 22)
        Me.ExportToPDFToolStripButton.Text = "Export To PDF"
        Me.ExportToPDFToolStripButton.ToolTipText = "Export to PDF file"
        '
        'PrintToolStripButton
        '
        Me.PrintToolStripButton.Image = CType(resources.GetObject("PrintToolStripButton.Image"), System.Drawing.Image)
        Me.PrintToolStripButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.PrintToolStripButton.Name = "PrintToolStripButton"
        Me.PrintToolStripButton.Size = New System.Drawing.Size(49, 22)
        Me.PrintToolStripButton.Text = "&Print"
        '
        'ViewCommentForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(528, 441)
        Me.ControlBox = False
        Me.Controls.Add(Me.ToolStrip1)
        Me.Controls.Add(Me.CommentTextBox)
        Me.Controls.Add(Me.CloseButton)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ViewCommentForm"
        Me.ShowInTaskbar = False
        Me.Text = "View Comment"
        CType(Me.PrintingSystem1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ToolStrip1.ResumeLayout(False)
        Me.ToolStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents PrintingSystem1 As DevExpress.XtraPrinting.PrintingSystem
    Friend WithEvents CommentTextBoxLink As DevExpress.XtraPrintingLinks.RichTextBoxLink
    Friend WithEvents CommentTextBox As System.Windows.Forms.RichTextBox
    Friend WithEvents ToolStrip1 As System.Windows.Forms.ToolStrip
    Friend WithEvents ExportToPDFToolStripButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents PrintToolStripButton As System.Windows.Forms.ToolStripButton
End Class
