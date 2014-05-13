Public Class ucKeyVerification
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
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
    Friend WithEvents spnKeyVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnAdvanceKeyVerify As System.Windows.Forms.Button
    Friend WithEvents txtKeyVerify As System.Windows.Forms.TextBox
    Friend WithEvents shdKeyVerify As SectionHeader
    Friend WithEvents lblQstnCountKeyVerify As System.Windows.Forms.Label
    Friend WithEvents btnNextQstnKeyVerify As System.Windows.Forms.Button
    Friend WithEvents btnPrevQstnKeyVerify As System.Windows.Forms.Button
    Friend WithEvents lblCurQstnKeyVerify As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaptionKeyVerify As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnKeyVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.btnAdvanceKeyVerify = New System.Windows.Forms.Button
        Me.txtKeyVerify = New System.Windows.Forms.TextBox
        Me.shdKeyVerify = New SectionHeader
        Me.lblQstnCountKeyVerify = New System.Windows.Forms.Label
        Me.btnNextQstnKeyVerify = New System.Windows.Forms.Button
        Me.btnPrevQstnKeyVerify = New System.Windows.Forms.Button
        Me.lblCurQstnKeyVerify = New System.Windows.Forms.Label
        Me.lblCurQstnCaptionKeyVerify = New System.Windows.Forms.Label
        Me.spnKeyVerify.SuspendLayout()
        Me.shdKeyVerify.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnKeyVerify
        '
        Me.spnKeyVerify.BackColor = System.Drawing.SystemColors.Control
        Me.spnKeyVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnKeyVerify.Caption = "Key Verification - 1441C01 - 12345678"
        Me.spnKeyVerify.Controls.Add(Me.btnAdvanceKeyVerify)
        Me.spnKeyVerify.Controls.Add(Me.txtKeyVerify)
        Me.spnKeyVerify.Controls.Add(Me.shdKeyVerify)
        Me.spnKeyVerify.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnKeyVerify.DockPadding.All = 1
        Me.spnKeyVerify.Location = New System.Drawing.Point(0, 0)
        Me.spnKeyVerify.Name = "spnKeyVerify"
        Me.spnKeyVerify.ShowCaption = True
        Me.spnKeyVerify.Size = New System.Drawing.Size(504, 472)
        Me.spnKeyVerify.TabIndex = 2
        '
        'btnAdvanceKeyVerify
        '
        Me.btnAdvanceKeyVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvanceKeyVerify.Location = New System.Drawing.Point(8, 440)
        Me.btnAdvanceKeyVerify.Name = "btnAdvanceKeyVerify"
        Me.btnAdvanceKeyVerify.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvanceKeyVerify.TabIndex = 7
        Me.btnAdvanceKeyVerify.Text = "Advance (F10)"
        '
        'txtKeyVerify
        '
        Me.txtKeyVerify.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtKeyVerify.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtKeyVerify.Location = New System.Drawing.Point(8, 64)
        Me.txtKeyVerify.MaxLength = 12000
        Me.txtKeyVerify.Multiline = True
        Me.txtKeyVerify.Name = "txtKeyVerify"
        Me.txtKeyVerify.Size = New System.Drawing.Size(488, 368)
        Me.txtKeyVerify.TabIndex = 6
        Me.txtKeyVerify.Text = ""
        '
        'shdKeyVerify
        '
        Me.shdKeyVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdKeyVerify.Controls.Add(Me.lblQstnCountKeyVerify)
        Me.shdKeyVerify.Controls.Add(Me.btnNextQstnKeyVerify)
        Me.shdKeyVerify.Controls.Add(Me.btnPrevQstnKeyVerify)
        Me.shdKeyVerify.Controls.Add(Me.lblCurQstnKeyVerify)
        Me.shdKeyVerify.Controls.Add(Me.lblCurQstnCaptionKeyVerify)
        Me.shdKeyVerify.Location = New System.Drawing.Point(1, 27)
        Me.shdKeyVerify.Name = "shdKeyVerify"
        Me.shdKeyVerify.Size = New System.Drawing.Size(502, 28)
        Me.shdKeyVerify.TabIndex = 5
        '
        'lblQstnCountKeyVerify
        '
        Me.lblQstnCountKeyVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCountKeyVerify.Location = New System.Drawing.Point(408, 8)
        Me.lblQstnCountKeyVerify.Name = "lblQstnCountKeyVerify"
        Me.lblQstnCountKeyVerify.Size = New System.Drawing.Size(52, 16)
        Me.lblQstnCountKeyVerify.TabIndex = 4
        Me.lblQstnCountKeyVerify.Text = "1 of 3"
        Me.lblQstnCountKeyVerify.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnNextQstnKeyVerify
        '
        Me.btnNextQstnKeyVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNextQstnKeyVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnNextQstnKeyVerify.Location = New System.Drawing.Point(460, 8)
        Me.btnNextQstnKeyVerify.Name = "btnNextQstnKeyVerify"
        Me.btnNextQstnKeyVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnNextQstnKeyVerify.TabIndex = 3
        Me.btnNextQstnKeyVerify.Text = ">"
        '
        'btnPrevQstnKeyVerify
        '
        Me.btnPrevQstnKeyVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPrevQstnKeyVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnPrevQstnKeyVerify.Location = New System.Drawing.Point(384, 8)
        Me.btnPrevQstnKeyVerify.Name = "btnPrevQstnKeyVerify"
        Me.btnPrevQstnKeyVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnPrevQstnKeyVerify.TabIndex = 2
        Me.btnPrevQstnKeyVerify.Text = "<"
        '
        'lblCurQstnKeyVerify
        '
        Me.lblCurQstnKeyVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblCurQstnKeyVerify.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstnKeyVerify.Name = "lblCurQstnKeyVerify"
        Me.lblCurQstnKeyVerify.Size = New System.Drawing.Size(260, 16)
        Me.lblCurQstnKeyVerify.TabIndex = 1
        Me.lblCurQstnKeyVerify.Text = "What would you change about your stay?"
        '
        'lblCurQstnCaptionKeyVerify
        '
        Me.lblCurQstnCaptionKeyVerify.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaptionKeyVerify.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaptionKeyVerify.Name = "lblCurQstnCaptionKeyVerify"
        Me.lblCurQstnCaptionKeyVerify.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaptionKeyVerify.TabIndex = 0
        Me.lblCurQstnCaptionKeyVerify.Text = "Current Question:"
        '
        'ucKeyVerification
        '
        Me.Controls.Add(Me.spnKeyVerify)
        Me.Name = "ucKeyVerification"
        Me.Size = New System.Drawing.Size(504, 472)
        Me.spnKeyVerify.ResumeLayout(False)
        Me.shdKeyVerify.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

End Class
