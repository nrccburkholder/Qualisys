<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DataEntryVerifySection
    Inherits QualiSys_Scanner_Interface.Section

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
        Me.DataEntryVerifySectionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.BottomPanel = New System.Windows.Forms.Panel
        Me.CancelButton = New System.Windows.Forms.Button
        Me.NextButton = New System.Windows.Forms.Button
        Me.QuestionGroupPanel = New DevExpress.XtraEditors.XtraScrollableControl
        Me.DataEntryVerifySectionPanel.SuspendLayout()
        Me.BottomPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'DataEntryVerifySectionPanel
        '
        Me.DataEntryVerifySectionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.DataEntryVerifySectionPanel.Caption = ""
        Me.DataEntryVerifySectionPanel.Controls.Add(Me.BottomPanel)
        Me.DataEntryVerifySectionPanel.Controls.Add(Me.QuestionGroupPanel)
        Me.DataEntryVerifySectionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.DataEntryVerifySectionPanel.Location = New System.Drawing.Point(0, 0)
        Me.DataEntryVerifySectionPanel.Name = "DataEntryVerifySectionPanel"
        Me.DataEntryVerifySectionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.DataEntryVerifySectionPanel.ShowCaption = True
        Me.DataEntryVerifySectionPanel.Size = New System.Drawing.Size(645, 514)
        Me.DataEntryVerifySectionPanel.TabIndex = 1
        '
        'BottomPanel
        '
        Me.BottomPanel.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.BottomPanel.Controls.Add(Me.CancelButton)
        Me.BottomPanel.Controls.Add(Me.NextButton)
        Me.BottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.BottomPanel.Location = New System.Drawing.Point(1, 478)
        Me.BottomPanel.Name = "BottomPanel"
        Me.BottomPanel.Size = New System.Drawing.Size(643, 35)
        Me.BottomPanel.TabIndex = 5
        Me.BottomPanel.Visible = False
        '
        'CancelButton
        '
        Me.CancelButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CancelButton.Location = New System.Drawing.Point(559, 5)
        Me.CancelButton.Name = "CancelButton"
        Me.CancelButton.Size = New System.Drawing.Size(75, 23)
        Me.CancelButton.TabIndex = 1
        Me.CancelButton.Text = "Cancel"
        Me.CancelButton.UseVisualStyleBackColor = True
        '
        'NextButton
        '
        Me.NextButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NextButton.Location = New System.Drawing.Point(478, 5)
        Me.NextButton.Name = "NextButton"
        Me.NextButton.Size = New System.Drawing.Size(75, 23)
        Me.NextButton.TabIndex = 0
        Me.NextButton.Text = "Next Litho"
        Me.NextButton.UseVisualStyleBackColor = True
        '
        'QuestionGroupPanel
        '
        Me.QuestionGroupPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.QuestionGroupPanel.Appearance.BackColor = System.Drawing.SystemColors.Control
        Me.QuestionGroupPanel.Appearance.BorderColor = System.Drawing.Color.Black
        Me.QuestionGroupPanel.Appearance.Options.UseBackColor = True
        Me.QuestionGroupPanel.Appearance.Options.UseBorderColor = True
        Me.QuestionGroupPanel.Location = New System.Drawing.Point(1, 28)
        Me.QuestionGroupPanel.LookAndFeel.Style = DevExpress.LookAndFeel.LookAndFeelStyle.Office2003
        Me.QuestionGroupPanel.LookAndFeel.UseDefaultLookAndFeel = False
        Me.QuestionGroupPanel.LookAndFeel.UseWindowsXPTheme = True
        Me.QuestionGroupPanel.Name = "QuestionGroupPanel"
        Me.QuestionGroupPanel.Size = New System.Drawing.Size(643, 450)
        Me.QuestionGroupPanel.TabIndex = 1
        Me.QuestionGroupPanel.Visible = False
        '
        'DataEntryVerifySection
        '
        Me.Controls.Add(Me.DataEntryVerifySectionPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "DataEntryVerifySection"
        Me.Size = New System.Drawing.Size(645, 514)
        Me.DataEntryVerifySectionPanel.ResumeLayout(False)
        Me.BottomPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents DataEntryVerifySectionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents QuestionGroupPanel As DevExpress.XtraEditors.XtraScrollableControl
    Friend WithEvents BottomPanel As System.Windows.Forms.Panel
    Friend WithEvents CancelButton As System.Windows.Forms.Button
    Friend WithEvents NextButton As System.Windows.Forms.Button

End Class
