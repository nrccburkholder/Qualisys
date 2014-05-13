<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MassEmailSection
    Inherits NrcAuthAdmin.Section

    'UserControl overrides dispose to clean up the component list.
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MassEmailSection))
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.GrdMember = New Nrc.NrcAuthAdmin.MemberGrid
        Me.grdGroup = New Nrc.NrcAuthAdmin.GroupGrid
        Me.Splitter2 = New System.Windows.Forms.Splitter
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.pnlCustomBody = New System.Windows.Forms.Panel
        Me.imgHelp = New System.Windows.Forms.PictureBox
        Me.gbFrom = New System.Windows.Forms.GroupBox
        Me.rbFromCurrentUser = New System.Windows.Forms.RadioButton
        Me.rbFromDefault = New System.Windows.Forms.RadioButton
        Me.btnSend = New System.Windows.Forms.Button
        Me.Label3 = New System.Windows.Forms.Label
        Me.btnSendTest = New System.Windows.Forms.Button
        Me.gbTemplate = New System.Windows.Forms.GroupBox
        Me.btnSaveTemplate = New System.Windows.Forms.Button
        Me.btnLoadTemplate = New System.Windows.Forms.Button
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.rbPlainText = New System.Windows.Forms.RadioButton
        Me.rbHTML = New System.Windows.Forms.RadioButton
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtSubject = New System.Windows.Forms.TextBox
        Me.HTMLBody = New WinFormWysiwyg.Editor
        Me.txtBody = New System.Windows.Forms.TextBox
        Me.Panel1.SuspendLayout()
        Me.pnlCustomBody.SuspendLayout()
        CType(Me.imgHelp, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.gbFrom.SuspendLayout()
        Me.gbTemplate.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'Splitter1
        '
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Splitter1.Location = New System.Drawing.Point(0, 125)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(891, 5)
        Me.Splitter1.TabIndex = 4
        Me.Splitter1.TabStop = False
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.GrdMember)
        Me.Panel1.Controls.Add(Me.Splitter1)
        Me.Panel1.Controls.Add(Me.grdGroup)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(891, 440)
        Me.Panel1.TabIndex = 2
        '
        'GrdMember
        '
        Me.GrdMember.AllowCreateNewMember = False
        Me.GrdMember.Dock = System.Windows.Forms.DockStyle.Fill
        Me.GrdMember.IsAbbreviated = False
        Me.GrdMember.Location = New System.Drawing.Point(0, 130)
        Me.GrdMember.MultiSelect = True
        Me.GrdMember.Name = "GrdMember"
        Me.GrdMember.ShowGroupingFilter = False
        Me.GrdMember.ShowToolStrip = False
        Me.GrdMember.Size = New System.Drawing.Size(891, 310)
        Me.GrdMember.TabIndex = 5
        '
        'grdGroup
        '
        Me.grdGroup.AllowCreateNewGroup = True
        Me.grdGroup.Dock = System.Windows.Forms.DockStyle.Top
        Me.grdGroup.IsAbbreviated = False
        Me.grdGroup.Location = New System.Drawing.Point(0, 0)
        Me.grdGroup.MultiSelect = True
        Me.grdGroup.Name = "grdGroup"
        Me.grdGroup.ShowGroupingFilter = False
        Me.grdGroup.ShowToolStrip = False
        Me.grdGroup.Size = New System.Drawing.Size(891, 125)
        Me.grdGroup.TabIndex = 1
        '
        'Splitter2
        '
        Me.Splitter2.Dock = System.Windows.Forms.DockStyle.Top
        Me.Splitter2.Location = New System.Drawing.Point(0, 440)
        Me.Splitter2.Name = "Splitter2"
        Me.Splitter2.Size = New System.Drawing.Size(891, 5)
        Me.Splitter2.TabIndex = 3
        Me.Splitter2.TabStop = False
        '
        'pnlCustomBody
        '
        Me.pnlCustomBody.Controls.Add(Me.imgHelp)
        Me.pnlCustomBody.Controls.Add(Me.gbFrom)
        Me.pnlCustomBody.Controls.Add(Me.btnSend)
        Me.pnlCustomBody.Controls.Add(Me.Label3)
        Me.pnlCustomBody.Controls.Add(Me.btnSendTest)
        Me.pnlCustomBody.Controls.Add(Me.gbTemplate)
        Me.pnlCustomBody.Controls.Add(Me.GroupBox2)
        Me.pnlCustomBody.Controls.Add(Me.Label2)
        Me.pnlCustomBody.Controls.Add(Me.Label1)
        Me.pnlCustomBody.Controls.Add(Me.txtSubject)
        Me.pnlCustomBody.Controls.Add(Me.HTMLBody)
        Me.pnlCustomBody.Controls.Add(Me.txtBody)
        Me.pnlCustomBody.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlCustomBody.Location = New System.Drawing.Point(0, 445)
        Me.pnlCustomBody.MinimumSize = New System.Drawing.Size(400, 200)
        Me.pnlCustomBody.Name = "pnlCustomBody"
        Me.pnlCustomBody.Size = New System.Drawing.Size(891, 284)
        Me.pnlCustomBody.TabIndex = 24
        '
        'imgHelp
        '
        Me.imgHelp.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.imgHelp.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.qmark
        Me.imgHelp.Location = New System.Drawing.Point(697, 65)
        Me.imgHelp.Name = "imgHelp"
        Me.imgHelp.Size = New System.Drawing.Size(25, 26)
        Me.imgHelp.TabIndex = 6
        Me.imgHelp.TabStop = False
        '
        'gbFrom
        '
        Me.gbFrom.Controls.Add(Me.rbFromCurrentUser)
        Me.gbFrom.Controls.Add(Me.rbFromDefault)
        Me.gbFrom.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.gbFrom.Location = New System.Drawing.Point(67, 21)
        Me.gbFrom.Name = "gbFrom"
        Me.gbFrom.Size = New System.Drawing.Size(247, 33)
        Me.gbFrom.TabIndex = 32
        Me.gbFrom.TabStop = False
        '
        'rbFromCurrentUser
        '
        Me.rbFromCurrentUser.AutoSize = True
        Me.rbFromCurrentUser.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.rbFromCurrentUser.Location = New System.Drawing.Point(129, 11)
        Me.rbFromCurrentUser.Name = "rbFromCurrentUser"
        Me.rbFromCurrentUser.Size = New System.Drawing.Size(81, 17)
        Me.rbFromCurrentUser.TabIndex = 1
        Me.rbFromCurrentUser.Text = "current user"
        Me.rbFromCurrentUser.UseVisualStyleBackColor = True
        '
        'rbFromDefault
        '
        Me.rbFromDefault.AutoSize = True
        Me.rbFromDefault.Checked = True
        Me.rbFromDefault.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.rbFromDefault.Location = New System.Drawing.Point(6, 11)
        Me.rbFromDefault.Name = "rbFromDefault"
        Me.rbFromDefault.Size = New System.Drawing.Size(57, 17)
        Me.rbFromDefault.TabIndex = 0
        Me.rbFromDefault.TabStop = True
        Me.rbFromDefault.Text = "default"
        Me.rbFromDefault.UseVisualStyleBackColor = True
        '
        'btnSend
        '
        Me.btnSend.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSend.Location = New System.Drawing.Point(782, 246)
        Me.btnSend.Name = "btnSend"
        Me.btnSend.Size = New System.Drawing.Size(94, 26)
        Me.btnSend.TabIndex = 22
        Me.btnSend.Text = "Send To Users"
        Me.btnSend.UseVisualStyleBackColor = True
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(23, 35)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(33, 13)
        Me.Label3.TabIndex = 32
        Me.Label3.Text = "From:"
        '
        'btnSendTest
        '
        Me.btnSendTest.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSendTest.Location = New System.Drawing.Point(623, 27)
        Me.btnSendTest.Name = "btnSendTest"
        Me.btnSendTest.Size = New System.Drawing.Size(82, 26)
        Me.btnSendTest.TabIndex = 21
        Me.btnSendTest.Text = "Send Test"
        Me.btnSendTest.UseVisualStyleBackColor = True
        '
        'gbTemplate
        '
        Me.gbTemplate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.gbTemplate.Controls.Add(Me.btnSaveTemplate)
        Me.gbTemplate.Controls.Add(Me.btnLoadTemplate)
        Me.gbTemplate.Location = New System.Drawing.Point(728, 6)
        Me.gbTemplate.Name = "gbTemplate"
        Me.gbTemplate.Size = New System.Drawing.Size(148, 48)
        Me.gbTemplate.TabIndex = 31
        Me.gbTemplate.TabStop = False
        Me.gbTemplate.Text = "Template"
        '
        'btnSaveTemplate
        '
        Me.btnSaveTemplate.Location = New System.Drawing.Point(82, 15)
        Me.btnSaveTemplate.Name = "btnSaveTemplate"
        Me.btnSaveTemplate.Size = New System.Drawing.Size(54, 23)
        Me.btnSaveTemplate.TabIndex = 8
        Me.btnSaveTemplate.Text = "Save"
        Me.btnSaveTemplate.UseVisualStyleBackColor = True
        '
        'btnLoadTemplate
        '
        Me.btnLoadTemplate.Location = New System.Drawing.Point(12, 15)
        Me.btnLoadTemplate.Name = "btnLoadTemplate"
        Me.btnLoadTemplate.Size = New System.Drawing.Size(54, 23)
        Me.btnLoadTemplate.TabIndex = 7
        Me.btnLoadTemplate.Text = "Load"
        Me.btnLoadTemplate.UseVisualStyleBackColor = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.rbPlainText)
        Me.GroupBox2.Controls.Add(Me.rbHTML)
        Me.GroupBox2.Location = New System.Drawing.Point(728, 55)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(148, 37)
        Me.GroupBox2.TabIndex = 28
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Format"
        '
        'rbPlainText
        '
        Me.rbPlainText.AutoSize = True
        Me.rbPlainText.Location = New System.Drawing.Point(67, 13)
        Me.rbPlainText.Name = "rbPlainText"
        Me.rbPlainText.Size = New System.Drawing.Size(72, 17)
        Me.rbPlainText.TabIndex = 1
        Me.rbPlainText.Text = "Plain Text"
        Me.rbPlainText.UseVisualStyleBackColor = True
        '
        'rbHTML
        '
        Me.rbHTML.AutoSize = True
        Me.rbHTML.Checked = True
        Me.rbHTML.Location = New System.Drawing.Point(6, 13)
        Me.rbHTML.Name = "rbHTML"
        Me.rbHTML.Size = New System.Drawing.Size(55, 17)
        Me.rbHTML.TabIndex = 0
        Me.rbHTML.TabStop = True
        Me.rbHTML.Text = "HTML"
        Me.rbHTML.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(22, 98)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(34, 13)
        Me.Label2.TabIndex = 26
        Me.Label2.Text = "Body:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(10, 68)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(46, 13)
        Me.Label1.TabIndex = 25
        Me.Label1.Text = "Subject:"
        '
        'txtSubject
        '
        Me.txtSubject.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSubject.Location = New System.Drawing.Point(67, 65)
        Me.txtSubject.Name = "txtSubject"
        Me.txtSubject.Size = New System.Drawing.Size(624, 20)
        Me.txtSubject.TabIndex = 24
        '
        'HTMLBody
        '
        Me.HTMLBody.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.HTMLBody.BodyHtml = Nothing
        Me.HTMLBody.BodyText = Nothing
        Me.HTMLBody.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.HTMLBody.DocumentText = resources.GetString("HTMLBody.DocumentText")
        Me.HTMLBody.EditorBackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer), CType(CType(255, Byte), Integer))
        Me.HTMLBody.EditorForeColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer), CType(CType(0, Byte), Integer))
        Me.HTMLBody.FontSize = WinFormWysiwyg.FontSize.Three
        Me.HTMLBody.Location = New System.Drawing.Point(67, 98)
        Me.HTMLBody.Name = "HTMLBody"
        Me.HTMLBody.Size = New System.Drawing.Size(821, 143)
        Me.HTMLBody.TabIndex = 27
        '
        'txtBody
        '
        Me.txtBody.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtBody.Location = New System.Drawing.Point(67, 98)
        Me.txtBody.Multiline = True
        Me.txtBody.Name = "txtBody"
        Me.txtBody.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtBody.Size = New System.Drawing.Size(821, 143)
        Me.txtBody.TabIndex = 29
        Me.txtBody.Visible = False
        '
        'MassEmailSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.pnlCustomBody)
        Me.Controls.Add(Me.Splitter2)
        Me.Controls.Add(Me.Panel1)
        Me.Name = "MassEmailSection"
        Me.Size = New System.Drawing.Size(891, 729)
        Me.Panel1.ResumeLayout(False)
        Me.pnlCustomBody.ResumeLayout(False)
        Me.pnlCustomBody.PerformLayout()
        CType(Me.imgHelp, System.ComponentModel.ISupportInitialize).EndInit()
        Me.gbFrom.ResumeLayout(False)
        Me.gbFrom.PerformLayout()
        Me.gbTemplate.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents grdGroup As Nrc.NrcAuthAdmin.GroupGrid
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents GrdMember As Nrc.NrcAuthAdmin.MemberGrid
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Splitter2 As System.Windows.Forms.Splitter
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Friend WithEvents pnlCustomBody As System.Windows.Forms.Panel
    Friend WithEvents gbFrom As System.Windows.Forms.GroupBox
    Friend WithEvents rbFromCurrentUser As System.Windows.Forms.RadioButton
    Friend WithEvents rbFromDefault As System.Windows.Forms.RadioButton
    Friend WithEvents btnSend As System.Windows.Forms.Button
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents btnSendTest As System.Windows.Forms.Button
    Friend WithEvents gbTemplate As System.Windows.Forms.GroupBox
    Friend WithEvents btnSaveTemplate As System.Windows.Forms.Button
    Friend WithEvents btnLoadTemplate As System.Windows.Forms.Button
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents rbPlainText As System.Windows.Forms.RadioButton
    Friend WithEvents rbHTML As System.Windows.Forms.RadioButton
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtSubject As System.Windows.Forms.TextBox
    Friend WithEvents HTMLBody As WinFormWysiwyg.Editor
    Friend WithEvents txtBody As System.Windows.Forms.TextBox
    Friend WithEvents imgHelp As System.Windows.Forms.PictureBox

End Class
