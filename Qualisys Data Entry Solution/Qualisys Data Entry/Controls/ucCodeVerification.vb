Public Class ucCodeVerification
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
    Friend WithEvents spnCodeVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents spnCodesCodeVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents clbCodesCodeVerify As System.Windows.Forms.CheckedListBox
    Friend WithEvents shdCodesCodeVerify As SectionHeader
    Friend WithEvents cboCodesSubHeaderCodeVerify As System.Windows.Forms.ComboBox
    Friend WithEvents lblCodesSubHeaderCodeVerify As System.Windows.Forms.Label
    Friend WithEvents cboCodesHeaderCodeVerify As System.Windows.Forms.ComboBox
    Friend WithEvents lblCodesHeaderCodeVerify As System.Windows.Forms.Label
    Friend WithEvents spnValenceCodeVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents optValNeutralCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents optValBothCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents optValNegativeCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents optValPositiveCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents spnTypeCodeVerify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents optTypeSACodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents optTypeContactCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents optTypeGeneralCodeVerify As System.Windows.Forms.RadioButton
    Friend WithEvents btnAdvanceCodeVerify As System.Windows.Forms.Button
    Friend WithEvents txtCodeVerify As System.Windows.Forms.TextBox
    Friend WithEvents shdCodeVerify As SectionHeader
    Friend WithEvents lblQstnCountCodeVerify As System.Windows.Forms.Label
    Friend WithEvents btnNextQstnCodeVerify As System.Windows.Forms.Button
    Friend WithEvents btnPrevQstnCodeVerify As System.Windows.Forms.Button
    Friend WithEvents lblCurQstnCodeVerify As System.Windows.Forms.Label
    Friend WithEvents lblCurQstnCaptionCodeVerify As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnCodeVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.spnCodesCodeVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.clbCodesCodeVerify = New System.Windows.Forms.CheckedListBox
        Me.shdCodesCodeVerify = New SectionHeader
        Me.cboCodesSubHeaderCodeVerify = New System.Windows.Forms.ComboBox
        Me.lblCodesSubHeaderCodeVerify = New System.Windows.Forms.Label
        Me.cboCodesHeaderCodeVerify = New System.Windows.Forms.ComboBox
        Me.lblCodesHeaderCodeVerify = New System.Windows.Forms.Label
        Me.spnValenceCodeVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.optValNeutralCodeVerify = New System.Windows.Forms.RadioButton
        Me.optValBothCodeVerify = New System.Windows.Forms.RadioButton
        Me.optValNegativeCodeVerify = New System.Windows.Forms.RadioButton
        Me.optValPositiveCodeVerify = New System.Windows.Forms.RadioButton
        Me.spnTypeCodeVerify = New Nrc.Framework.WinForms.SectionPanel
        Me.optTypeSACodeVerify = New System.Windows.Forms.RadioButton
        Me.optTypeContactCodeVerify = New System.Windows.Forms.RadioButton
        Me.optTypeGeneralCodeVerify = New System.Windows.Forms.RadioButton
        Me.btnAdvanceCodeVerify = New System.Windows.Forms.Button
        Me.txtCodeVerify = New System.Windows.Forms.TextBox
        Me.shdCodeVerify = New SectionHeader
        Me.lblQstnCountCodeVerify = New System.Windows.Forms.Label
        Me.btnNextQstnCodeVerify = New System.Windows.Forms.Button
        Me.btnPrevQstnCodeVerify = New System.Windows.Forms.Button
        Me.lblCurQstnCodeVerify = New System.Windows.Forms.Label
        Me.lblCurQstnCaptionCodeVerify = New System.Windows.Forms.Label
        Me.spnCodeVerify.SuspendLayout()
        Me.spnCodesCodeVerify.SuspendLayout()
        Me.shdCodesCodeVerify.SuspendLayout()
        Me.spnValenceCodeVerify.SuspendLayout()
        Me.spnTypeCodeVerify.SuspendLayout()
        Me.shdCodeVerify.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnCodeVerify
        '
        Me.spnCodeVerify.BackColor = System.Drawing.SystemColors.Control
        Me.spnCodeVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnCodeVerify.Caption = "Code Verification - 1441C01 - 12345678"
        Me.spnCodeVerify.Controls.Add(Me.spnCodesCodeVerify)
        Me.spnCodeVerify.Controls.Add(Me.spnValenceCodeVerify)
        Me.spnCodeVerify.Controls.Add(Me.spnTypeCodeVerify)
        Me.spnCodeVerify.Controls.Add(Me.btnAdvanceCodeVerify)
        Me.spnCodeVerify.Controls.Add(Me.txtCodeVerify)
        Me.spnCodeVerify.Controls.Add(Me.shdCodeVerify)
        Me.spnCodeVerify.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnCodeVerify.DockPadding.All = 1
        Me.spnCodeVerify.Location = New System.Drawing.Point(0, 0)
        Me.spnCodeVerify.Name = "spnCodeVerify"
        Me.spnCodeVerify.ShowCaption = True
        Me.spnCodeVerify.Size = New System.Drawing.Size(720, 528)
        Me.spnCodeVerify.TabIndex = 4
        '
        'spnCodesCodeVerify
        '
        Me.spnCodesCodeVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.spnCodesCodeVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnCodesCodeVerify.Caption = "Codes"
        Me.spnCodesCodeVerify.Controls.Add(Me.clbCodesCodeVerify)
        Me.spnCodesCodeVerify.Controls.Add(Me.shdCodesCodeVerify)
        Me.spnCodesCodeVerify.DockPadding.All = 1
        Me.spnCodesCodeVerify.Location = New System.Drawing.Point(128, 260)
        Me.spnCodesCodeVerify.Name = "spnCodesCodeVerify"
        Me.spnCodesCodeVerify.ShowCaption = True
        Me.spnCodesCodeVerify.Size = New System.Drawing.Size(584, 228)
        Me.spnCodesCodeVerify.TabIndex = 19
        '
        'clbCodesCodeVerify
        '
        Me.clbCodesCodeVerify.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.clbCodesCodeVerify.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.clbCodesCodeVerify.CheckOnClick = True
        Me.clbCodesCodeVerify.IntegralHeight = False
        Me.clbCodesCodeVerify.Location = New System.Drawing.Point(8, 64)
        Me.clbCodesCodeVerify.MultiColumn = True
        Me.clbCodesCodeVerify.Name = "clbCodesCodeVerify"
        Me.clbCodesCodeVerify.Size = New System.Drawing.Size(568, 156)
        Me.clbCodesCodeVerify.TabIndex = 2
        '
        'shdCodesCodeVerify
        '
        Me.shdCodesCodeVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdCodesCodeVerify.Controls.Add(Me.cboCodesSubHeaderCodeVerify)
        Me.shdCodesCodeVerify.Controls.Add(Me.lblCodesSubHeaderCodeVerify)
        Me.shdCodesCodeVerify.Controls.Add(Me.cboCodesHeaderCodeVerify)
        Me.shdCodesCodeVerify.Controls.Add(Me.lblCodesHeaderCodeVerify)
        Me.shdCodesCodeVerify.Location = New System.Drawing.Point(1, 27)
        Me.shdCodesCodeVerify.Name = "shdCodesCodeVerify"
        Me.shdCodesCodeVerify.Size = New System.Drawing.Size(582, 28)
        Me.shdCodesCodeVerify.TabIndex = 1
        '
        'cboCodesSubHeaderCodeVerify
        '
        Me.cboCodesSubHeaderCodeVerify.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCodesSubHeaderCodeVerify.Location = New System.Drawing.Point(356, 4)
        Me.cboCodesSubHeaderCodeVerify.Name = "cboCodesSubHeaderCodeVerify"
        Me.cboCodesSubHeaderCodeVerify.Size = New System.Drawing.Size(216, 21)
        Me.cboCodesSubHeaderCodeVerify.TabIndex = 4
        '
        'lblCodesSubHeaderCodeVerify
        '
        Me.lblCodesSubHeaderCodeVerify.BackColor = System.Drawing.Color.Transparent
        Me.lblCodesSubHeaderCodeVerify.Location = New System.Drawing.Point(288, 8)
        Me.lblCodesSubHeaderCodeVerify.Name = "lblCodesSubHeaderCodeVerify"
        Me.lblCodesSubHeaderCodeVerify.Size = New System.Drawing.Size(72, 16)
        Me.lblCodesSubHeaderCodeVerify.TabIndex = 3
        Me.lblCodesSubHeaderCodeVerify.Text = "SubHeader:"
        '
        'cboCodesHeaderCodeVerify
        '
        Me.cboCodesHeaderCodeVerify.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cboCodesHeaderCodeVerify.Location = New System.Drawing.Point(64, 4)
        Me.cboCodesHeaderCodeVerify.Name = "cboCodesHeaderCodeVerify"
        Me.cboCodesHeaderCodeVerify.Size = New System.Drawing.Size(212, 21)
        Me.cboCodesHeaderCodeVerify.TabIndex = 2
        '
        'lblCodesHeaderCodeVerify
        '
        Me.lblCodesHeaderCodeVerify.BackColor = System.Drawing.Color.Transparent
        Me.lblCodesHeaderCodeVerify.Location = New System.Drawing.Point(12, 8)
        Me.lblCodesHeaderCodeVerify.Name = "lblCodesHeaderCodeVerify"
        Me.lblCodesHeaderCodeVerify.Size = New System.Drawing.Size(52, 16)
        Me.lblCodesHeaderCodeVerify.TabIndex = 1
        Me.lblCodesHeaderCodeVerify.Text = "Header:"
        '
        'spnValenceCodeVerify
        '
        Me.spnValenceCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.spnValenceCodeVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnValenceCodeVerify.Caption = "Valence"
        Me.spnValenceCodeVerify.Controls.Add(Me.optValNeutralCodeVerify)
        Me.spnValenceCodeVerify.Controls.Add(Me.optValBothCodeVerify)
        Me.spnValenceCodeVerify.Controls.Add(Me.optValNegativeCodeVerify)
        Me.spnValenceCodeVerify.Controls.Add(Me.optValPositiveCodeVerify)
        Me.spnValenceCodeVerify.DockPadding.All = 1
        Me.spnValenceCodeVerify.Location = New System.Drawing.Point(8, 368)
        Me.spnValenceCodeVerify.Name = "spnValenceCodeVerify"
        Me.spnValenceCodeVerify.ShowCaption = True
        Me.spnValenceCodeVerify.Size = New System.Drawing.Size(112, 120)
        Me.spnValenceCodeVerify.TabIndex = 18
        '
        'optValNeutralCodeVerify
        '
        Me.optValNeutralCodeVerify.Location = New System.Drawing.Point(12, 96)
        Me.optValNeutralCodeVerify.Name = "optValNeutralCodeVerify"
        Me.optValNeutralCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optValNeutralCodeVerify.TabIndex = 7
        Me.optValNeutralCodeVerify.Text = "Neutral"
        '
        'optValBothCodeVerify
        '
        Me.optValBothCodeVerify.Location = New System.Drawing.Point(12, 76)
        Me.optValBothCodeVerify.Name = "optValBothCodeVerify"
        Me.optValBothCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optValBothCodeVerify.TabIndex = 6
        Me.optValBothCodeVerify.Text = "Both"
        '
        'optValNegativeCodeVerify
        '
        Me.optValNegativeCodeVerify.Location = New System.Drawing.Point(12, 56)
        Me.optValNegativeCodeVerify.Name = "optValNegativeCodeVerify"
        Me.optValNegativeCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optValNegativeCodeVerify.TabIndex = 5
        Me.optValNegativeCodeVerify.Text = "Negative"
        '
        'optValPositiveCodeVerify
        '
        Me.optValPositiveCodeVerify.Location = New System.Drawing.Point(12, 36)
        Me.optValPositiveCodeVerify.Name = "optValPositiveCodeVerify"
        Me.optValPositiveCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optValPositiveCodeVerify.TabIndex = 4
        Me.optValPositiveCodeVerify.Text = "Positive"
        '
        'spnTypeCodeVerify
        '
        Me.spnTypeCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.spnTypeCodeVerify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnTypeCodeVerify.Caption = "Type"
        Me.spnTypeCodeVerify.Controls.Add(Me.optTypeSACodeVerify)
        Me.spnTypeCodeVerify.Controls.Add(Me.optTypeContactCodeVerify)
        Me.spnTypeCodeVerify.Controls.Add(Me.optTypeGeneralCodeVerify)
        Me.spnTypeCodeVerify.DockPadding.All = 1
        Me.spnTypeCodeVerify.Location = New System.Drawing.Point(8, 260)
        Me.spnTypeCodeVerify.Name = "spnTypeCodeVerify"
        Me.spnTypeCodeVerify.ShowCaption = True
        Me.spnTypeCodeVerify.Size = New System.Drawing.Size(112, 100)
        Me.spnTypeCodeVerify.TabIndex = 17
        '
        'optTypeSACodeVerify
        '
        Me.optTypeSACodeVerify.Location = New System.Drawing.Point(12, 76)
        Me.optTypeSACodeVerify.Name = "optTypeSACodeVerify"
        Me.optTypeSACodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optTypeSACodeVerify.TabIndex = 3
        Me.optTypeSACodeVerify.Text = "Service Alert"
        '
        'optTypeContactCodeVerify
        '
        Me.optTypeContactCodeVerify.Location = New System.Drawing.Point(12, 56)
        Me.optTypeContactCodeVerify.Name = "optTypeContactCodeVerify"
        Me.optTypeContactCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optTypeContactCodeVerify.TabIndex = 2
        Me.optTypeContactCodeVerify.Text = "Contact"
        '
        'optTypeGeneralCodeVerify
        '
        Me.optTypeGeneralCodeVerify.Location = New System.Drawing.Point(12, 36)
        Me.optTypeGeneralCodeVerify.Name = "optTypeGeneralCodeVerify"
        Me.optTypeGeneralCodeVerify.Size = New System.Drawing.Size(88, 16)
        Me.optTypeGeneralCodeVerify.TabIndex = 1
        Me.optTypeGeneralCodeVerify.Text = "General"
        '
        'btnAdvanceCodeVerify
        '
        Me.btnAdvanceCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnAdvanceCodeVerify.Location = New System.Drawing.Point(8, 496)
        Me.btnAdvanceCodeVerify.Name = "btnAdvanceCodeVerify"
        Me.btnAdvanceCodeVerify.Size = New System.Drawing.Size(88, 24)
        Me.btnAdvanceCodeVerify.TabIndex = 16
        Me.btnAdvanceCodeVerify.Text = "Advance (F10)"
        '
        'txtCodeVerify
        '
        Me.txtCodeVerify.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtCodeVerify.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtCodeVerify.Location = New System.Drawing.Point(8, 64)
        Me.txtCodeVerify.MaxLength = 12000
        Me.txtCodeVerify.Multiline = True
        Me.txtCodeVerify.Name = "txtCodeVerify"
        Me.txtCodeVerify.Size = New System.Drawing.Size(704, 188)
        Me.txtCodeVerify.TabIndex = 15
        Me.txtCodeVerify.Text = ""
        '
        'shdCodeVerify
        '
        Me.shdCodeVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.shdCodeVerify.Controls.Add(Me.lblQstnCountCodeVerify)
        Me.shdCodeVerify.Controls.Add(Me.btnNextQstnCodeVerify)
        Me.shdCodeVerify.Controls.Add(Me.btnPrevQstnCodeVerify)
        Me.shdCodeVerify.Controls.Add(Me.lblCurQstnCodeVerify)
        Me.shdCodeVerify.Controls.Add(Me.lblCurQstnCaptionCodeVerify)
        Me.shdCodeVerify.Location = New System.Drawing.Point(1, 27)
        Me.shdCodeVerify.Name = "shdCodeVerify"
        Me.shdCodeVerify.Size = New System.Drawing.Size(718, 28)
        Me.shdCodeVerify.TabIndex = 14
        '
        'lblQstnCountCodeVerify
        '
        Me.lblQstnCountCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblQstnCountCodeVerify.Location = New System.Drawing.Point(624, 8)
        Me.lblQstnCountCodeVerify.Name = "lblQstnCountCodeVerify"
        Me.lblQstnCountCodeVerify.Size = New System.Drawing.Size(52, 16)
        Me.lblQstnCountCodeVerify.TabIndex = 4
        Me.lblQstnCountCodeVerify.Text = "1 of 3"
        Me.lblQstnCountCodeVerify.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'btnNextQstnCodeVerify
        '
        Me.btnNextQstnCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNextQstnCodeVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnNextQstnCodeVerify.Location = New System.Drawing.Point(676, 8)
        Me.btnNextQstnCodeVerify.Name = "btnNextQstnCodeVerify"
        Me.btnNextQstnCodeVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnNextQstnCodeVerify.TabIndex = 3
        Me.btnNextQstnCodeVerify.Text = ">"
        '
        'btnPrevQstnCodeVerify
        '
        Me.btnPrevQstnCodeVerify.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnPrevQstnCodeVerify.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnPrevQstnCodeVerify.Location = New System.Drawing.Point(600, 8)
        Me.btnPrevQstnCodeVerify.Name = "btnPrevQstnCodeVerify"
        Me.btnPrevQstnCodeVerify.Size = New System.Drawing.Size(24, 16)
        Me.btnPrevQstnCodeVerify.TabIndex = 2
        Me.btnPrevQstnCodeVerify.Text = "<"
        '
        'lblCurQstnCodeVerify
        '
        Me.lblCurQstnCodeVerify.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblCurQstnCodeVerify.Location = New System.Drawing.Point(112, 8)
        Me.lblCurQstnCodeVerify.Name = "lblCurQstnCodeVerify"
        Me.lblCurQstnCodeVerify.Size = New System.Drawing.Size(476, 16)
        Me.lblCurQstnCodeVerify.TabIndex = 1
        Me.lblCurQstnCodeVerify.Text = "What would you change about your stay?"
        '
        'lblCurQstnCaptionCodeVerify
        '
        Me.lblCurQstnCaptionCodeVerify.BackColor = System.Drawing.Color.Transparent
        Me.lblCurQstnCaptionCodeVerify.Location = New System.Drawing.Point(12, 8)
        Me.lblCurQstnCaptionCodeVerify.Name = "lblCurQstnCaptionCodeVerify"
        Me.lblCurQstnCaptionCodeVerify.Size = New System.Drawing.Size(96, 16)
        Me.lblCurQstnCaptionCodeVerify.TabIndex = 0
        Me.lblCurQstnCaptionCodeVerify.Text = "Current Question:"
        '
        'ucCodeVerification
        '
        Me.Controls.Add(Me.spnCodeVerify)
        Me.Name = "ucCodeVerification"
        Me.Size = New System.Drawing.Size(720, 528)
        Me.spnCodeVerify.ResumeLayout(False)
        Me.spnCodesCodeVerify.ResumeLayout(False)
        Me.shdCodesCodeVerify.ResumeLayout(False)
        Me.spnValenceCodeVerify.ResumeLayout(False)
        Me.spnTypeCodeVerify.ResumeLayout(False)
        Me.shdCodeVerify.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

End Class
