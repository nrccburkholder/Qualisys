Public Class ucHandVerification
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
    Friend WithEvents spnHandVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents lblRangeHandVerify As System.Windows.Forms.Label
    Friend WithEvents lblRangeCaptionHandVerify As System.Windows.Forms.Label
    Friend WithEvents txtHandVerify As System.Windows.Forms.TextBox
    Friend WithEvents btnAdvanceHandVerify As System.Windows.Forms.Button
    Friend WithEvents shdHandVerify As SectionHeader
    Friend WithEvents lblQstnCountHandVerify As System.Windows.Forms.Label
    Friend WithEvents btnNextQstnHandVerify As System.Windows.Forms.Button
    Friend WithEvents btnPrevQstnHandVerify As System.Windows.Forms.Button
    Friend WithEvents lblCurQstnHandVerify As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaptionHandVerify As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnHandVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.lblRangeHandVerify = New System.Windows.Forms.Label
        Me.lblRangeCaptionHandVerify = New System.Windows.Forms.Label
        Me.txtHandVerify = New System.Windows.Forms.TextBox
        Me.btnAdvanceHandVerify = New System.Windows.Forms.Button
        Me.shdHandVerify = New SectionHeader
        Me.lblQstnCountHandVerify = New System.Windows.Forms.Label
        Me.btnNextQstnHandVerify = New System.Windows.Forms.Button
        Me.btnPrevQstnHandVerify = New System.Windows.Forms.Button
        Me.lblCurQstnHandVerify = New System.Windows.Forms.Label
        Me.lblCurQstnCaptionHandVerify = New System.Windows.Forms.Label
        Me.spnHandVerify.SuspendLayout()
        Me.shdHandVerify.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnHandVerify
        '
        Me.spnHandVerify.BackColor = System.Drawing.SystemColors.Control
        Me.spnHandVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnHandVerify.Caption = "Handwritten Verification - 1441C01 - 12345678"
        Me.spnHandVerify.Controls.Add(Me.lblRangeHandVerify)
        Me.spnHandVerify.Controls.Add(Me.lblRangeCaptionHandVerify)
        Me.spnHandVerify.Controls.Add(Me.txtHandVerify)
        Me.spnHandVerify.Controls.Add(Me.btnAdvanceHandVerify)
        Me.spnHandVerify.Controls.Add(Me.shdHandVerify)
        Me.spnHandVerify.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnHandVerify.DockPadding.All = 1
        Me.spnHandVerify.Location = New System.Drawing.Point(0, 0)
        Me.spnHandVerify.Name = "spnHandVerify"
        Me.spnHandVerify.ShowCaption = True
        Me.spnHandVerify.Size = New System.Drawing.Size(696, 600)
        Me.spnHandVerify.TabIndex = 6
        '
        'lblRangeHandVerify
        '
        Me.lblRangeHandVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRangeHandVerify.Location = New System.Drawing.Point(96, 92)
        Me.lblRangeHandVerify.Name = "lblRangeHandVerify"
        Me.lblRangeHandVerify.Size = New System.Drawing.Size(592, 16)
        Me.lblRangeHandVerify.TabIndex = 14
        Me.lblRangeHandVerify.Text = "42 characters"
        '
        'lblRangeCaptionHandVerify
        '
        Me.lblRangeCaptionHandVerify.Location = New System.Drawing.Point(12, 92)
        Me.lblRangeCaptionHandVerify.Name = "lblRangeCaptionHandVerify"
        Me.lblRangeCaptionHandVerify.Size = New System.Drawing.Size(84, 16)
        Me.lblRangeCaptionHandVerify.TabIndex = 13
        Me.lblRangeCaptionHandVerify.Text = "Valid Range Is:"
        '
        'txtHandVerify
        '
        Me.txtHandVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtHandVerify.Location = New System.Drawing.Point(8, 64)
        Me.txtHandVerify.Name = "txtHandVerify"
        Me.txtHandVerify.Size = New System.Drawing.Size(680, 20)
        Me.txtHandVerify.TabIndex = 12
        Me.txtHandVerify.Text = ""
        '
        'btnAdvanceHandVerify
        '
        Me.btnAdvanceHandVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvanceHandVerify.Location = New System.Drawing.Point(8, 568)
        Me.btnAdvanceHandVerify.Name = "btnAdvanceHandVerify"
        Me.btnAdvanceHandVerify.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvanceHandVerify.TabIndex = 11
        Me.btnAdvanceHandVerify.Text = "Advance (F10)"
        '
        'shdHandVerify
        '
        Me.shdHandVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdHandVerify.Controls.Add(Me.lblQstnCountHandVerify)
        Me.shdHandVerify.Controls.Add(Me.btnNextQstnHandVerify)
        Me.shdHandVerify.Controls.Add(Me.btnPrevQstnHandVerify)
        Me.shdHandVerify.Controls.Add(Me.lblCurQstnHandVerify)
        Me.shdHandVerify.Controls.Add(Me.lblCurQstnCaptionHandVerify)
        Me.shdHandVerify.Location = New System.Drawing.Point(1, 27)
        Me.shdHandVerify.Name = "shdHandVerify"
        Me.shdHandVerify.Size = New System.Drawing.Size(694, 28)
        Me.shdHandVerify.TabIndex = 10
        '
        'lblQstnCountHandVerify
        '
        Me.lblQstnCountHandVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCountHandVerify.Location = New System.Drawing.Point(600, 8)
        Me.lblQstnCountHandVerify.Name = "lblQstnCountHandVerify"
        Me.lblQstnCountHandVerify.Size = New System.Drawing.Size(52, 16)
        Me.lblQstnCountHandVerify.TabIndex = 4
        Me.lblQstnCountHandVerify.Text = "1 of 3"
        Me.lblQstnCountHandVerify.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnNextQstnHandVerify
        '
        Me.btnNextQstnHandVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNextQstnHandVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnNextQstnHandVerify.Location = New System.Drawing.Point(652, 8)
        Me.btnNextQstnHandVerify.Name = "btnNextQstnHandVerify"
        Me.btnNextQstnHandVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnNextQstnHandVerify.TabIndex = 3
        Me.btnNextQstnHandVerify.Text = ">"
        '
        'btnPrevQstnHandVerify
        '
        Me.btnPrevQstnHandVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPrevQstnHandVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnPrevQstnHandVerify.Location = New System.Drawing.Point(576, 8)
        Me.btnPrevQstnHandVerify.Name = "btnPrevQstnHandVerify"
        Me.btnPrevQstnHandVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnPrevQstnHandVerify.TabIndex = 2
        Me.btnPrevQstnHandVerify.Text = "<"
        '
        'lblCurQstnHandVerify
        '
        Me.lblCurQstnHandVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblCurQstnHandVerify.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstnHandVerify.Name = "lblCurQstnHandVerify"
        Me.lblCurQstnHandVerify.Size = New System.Drawing.Size(452, 16)
        Me.lblCurQstnHandVerify.TabIndex = 1
        Me.lblCurQstnHandVerify.Text = "What would you change about your stay? - Other"
        '
        'lblCurQstnCaptionHandVerify
        '
        Me.lblCurQstnCaptionHandVerify.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaptionHandVerify.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaptionHandVerify.Name = "lblCurQstnCaptionHandVerify"
        Me.lblCurQstnCaptionHandVerify.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaptionHandVerify.TabIndex = 0
        Me.lblCurQstnCaptionHandVerify.Text = "Current Question:"
        '
        'ucHandWrittenVerification
        '
        Me.Controls.Add(Me.spnHandVerify)
        Me.Name = "ucHandWrittenVerification"
        Me.Size = New System.Drawing.Size(696, 600)
        Me.spnHandVerify.ResumeLayout(False)
        Me.shdHandVerify.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

End Class
