<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class frmMain
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(frmMain))
        Me.grpCurrentInfo = New System.Windows.Forms.GroupBox
        Me.txtSurvey = New System.Windows.Forms.TextBox
        Me.txtStudy = New System.Windows.Forms.TextBox
        Me.txtClient = New System.Windows.Forms.TextBox
        Me.txtFullName = New System.Windows.Forms.TextBox
        Me.txtLithoCode = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.lblUserName = New System.Windows.Forms.Label
        Me.lblVersion = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.lblEnvironment = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.btnSave = New System.Windows.Forms.Button
        Me.grpBGData = New System.Windows.Forms.GroupBox
        Me.pnlBGData = New System.Windows.Forms.Panel
        Me.Label10 = New System.Windows.Forms.Label
        Me.btnNewLitho = New System.Windows.Forms.Button
        Me.grpCurrentInfo.SuspendLayout()
        Me.grpBGData.SuspendLayout()
        Me.SuspendLayout()
        '
        'grpCurrentInfo
        '
        Me.grpCurrentInfo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpCurrentInfo.Controls.Add(Me.txtSurvey)
        Me.grpCurrentInfo.Controls.Add(Me.txtStudy)
        Me.grpCurrentInfo.Controls.Add(Me.txtClient)
        Me.grpCurrentInfo.Controls.Add(Me.txtFullName)
        Me.grpCurrentInfo.Controls.Add(Me.txtLithoCode)
        Me.grpCurrentInfo.Controls.Add(Me.Label5)
        Me.grpCurrentInfo.Controls.Add(Me.Label4)
        Me.grpCurrentInfo.Controls.Add(Me.Label3)
        Me.grpCurrentInfo.Controls.Add(Me.Label2)
        Me.grpCurrentInfo.Controls.Add(Me.Label1)
        Me.grpCurrentInfo.Location = New System.Drawing.Point(11, 9)
        Me.grpCurrentInfo.Name = "grpCurrentInfo"
        Me.grpCurrentInfo.Size = New System.Drawing.Size(412, 108)
        Me.grpCurrentInfo.TabIndex = 31
        Me.grpCurrentInfo.TabStop = False
        Me.grpCurrentInfo.Text = " Current Information "
        '
        'txtSurvey
        '
        Me.txtSurvey.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtSurvey.Location = New System.Drawing.Point(268, 76)
        Me.txtSurvey.Name = "txtSurvey"
        Me.txtSurvey.ReadOnly = True
        Me.txtSurvey.Size = New System.Drawing.Size(141, 20)
        Me.txtSurvey.TabIndex = 10
        Me.txtSurvey.TabStop = False
        '
        'txtStudy
        '
        Me.txtStudy.Location = New System.Drawing.Point(72, 76)
        Me.txtStudy.Name = "txtStudy"
        Me.txtStudy.ReadOnly = True
        Me.txtStudy.Size = New System.Drawing.Size(132, 20)
        Me.txtStudy.TabIndex = 8
        Me.txtStudy.TabStop = False
        '
        'txtClient
        '
        Me.txtClient.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtClient.Location = New System.Drawing.Point(72, 49)
        Me.txtClient.Name = "txtClient"
        Me.txtClient.ReadOnly = True
        Me.txtClient.Size = New System.Drawing.Size(337, 20)
        Me.txtClient.TabIndex = 6
        Me.txtClient.TabStop = False
        '
        'txtFullName
        '
        Me.txtFullName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtFullName.Location = New System.Drawing.Point(212, 21)
        Me.txtFullName.Name = "txtFullName"
        Me.txtFullName.ReadOnly = True
        Me.txtFullName.Size = New System.Drawing.Size(197, 20)
        Me.txtFullName.TabIndex = 4
        Me.txtFullName.TabStop = False
        '
        'txtLithoCode
        '
        Me.txtLithoCode.Location = New System.Drawing.Point(72, 20)
        Me.txtLithoCode.Name = "txtLithoCode"
        Me.txtLithoCode.ReadOnly = True
        Me.txtLithoCode.Size = New System.Drawing.Size(76, 20)
        Me.txtLithoCode.TabIndex = 2
        Me.txtLithoCode.TabStop = False
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(164, 24)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(48, 16)
        Me.Label5.TabIndex = 3
        Me.Label5.Text = "Name:"
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(220, 80)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(48, 16)
        Me.Label4.TabIndex = 9
        Me.Label4.Text = "Survey:"
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(12, 80)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(60, 16)
        Me.Label3.TabIndex = 7
        Me.Label3.Text = "Study:"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(12, 52)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(60, 16)
        Me.Label2.TabIndex = 5
        Me.Label2.Text = "Client:"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(12, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(60, 16)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "LithoCode:"
        '
        'lblUserName
        '
        Me.lblUserName.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblUserName.Location = New System.Drawing.Point(99, 357)
        Me.lblUserName.Name = "lblUserName"
        Me.lblUserName.Size = New System.Drawing.Size(84, 20)
        Me.lblUserName.TabIndex = 38
        Me.lblUserName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblVersion
        '
        Me.lblVersion.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblVersion.Location = New System.Drawing.Point(15, 357)
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(84, 20)
        Me.lblVersion.TabIndex = 36
        Me.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label8
        '
        Me.Label8.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label8.Location = New System.Drawing.Point(99, 341)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(84, 20)
        Me.Label8.TabIndex = 37
        Me.Label8.Text = "User Name:"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblEnvironment
        '
        Me.lblEnvironment.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lblEnvironment.Location = New System.Drawing.Point(183, 357)
        Me.lblEnvironment.Name = "lblEnvironment"
        Me.lblEnvironment.Size = New System.Drawing.Size(84, 20)
        Me.lblEnvironment.TabIndex = 40
        Me.lblEnvironment.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label6
        '
        Me.Label6.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label6.Location = New System.Drawing.Point(15, 341)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(84, 20)
        Me.Label6.TabIndex = 35
        Me.Label6.Text = "Version:"
        Me.Label6.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnSave
        '
        Me.btnSave.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSave.Location = New System.Drawing.Point(279, 345)
        Me.btnSave.Name = "btnSave"
        Me.btnSave.Size = New System.Drawing.Size(68, 28)
        Me.btnSave.TabIndex = 33
        Me.btnSave.Text = "Save"
        '
        'grpBGData
        '
        Me.grpBGData.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grpBGData.Controls.Add(Me.pnlBGData)
        Me.grpBGData.Location = New System.Drawing.Point(11, 121)
        Me.grpBGData.Name = "grpBGData"
        Me.grpBGData.Size = New System.Drawing.Size(412, 212)
        Me.grpBGData.TabIndex = 32
        Me.grpBGData.TabStop = False
        Me.grpBGData.Text = " Background Data "
        '
        'pnlBGData
        '
        Me.pnlBGData.AutoScroll = True
        Me.pnlBGData.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBGData.Location = New System.Drawing.Point(3, 16)
        Me.pnlBGData.Name = "pnlBGData"
        Me.pnlBGData.Size = New System.Drawing.Size(406, 193)
        Me.pnlBGData.TabIndex = 12
        '
        'Label10
        '
        Me.Label10.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label10.Location = New System.Drawing.Point(183, 341)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(84, 20)
        Me.Label10.TabIndex = 39
        Me.Label10.Text = "Environment:"
        Me.Label10.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnNewLitho
        '
        Me.btnNewLitho.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNewLitho.Location = New System.Drawing.Point(355, 345)
        Me.btnNewLitho.Name = "btnNewLitho"
        Me.btnNewLitho.Size = New System.Drawing.Size(68, 28)
        Me.btnNewLitho.TabIndex = 34
        Me.btnNewLitho.Text = "New Litho"
        '
        'frmMain
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(435, 386)
        Me.Controls.Add(Me.grpCurrentInfo)
        Me.Controls.Add(Me.lblUserName)
        Me.Controls.Add(Me.lblVersion)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.lblEnvironment)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.btnSave)
        Me.Controls.Add(Me.grpBGData)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.btnNewLitho)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "frmMain"
        Me.Text = "Background Data Update System"
        Me.grpCurrentInfo.ResumeLayout(False)
        Me.grpCurrentInfo.PerformLayout()
        Me.grpBGData.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents grpCurrentInfo As System.Windows.Forms.GroupBox
    Friend WithEvents txtSurvey As System.Windows.Forms.TextBox
    Friend WithEvents txtStudy As System.Windows.Forms.TextBox
    Friend WithEvents txtClient As System.Windows.Forms.TextBox
    Friend WithEvents txtFullName As System.Windows.Forms.TextBox
    Friend WithEvents txtLithoCode As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lblUserName As System.Windows.Forms.Label
    Friend WithEvents lblVersion As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents lblEnvironment As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents btnSave As System.Windows.Forms.Button
    Friend WithEvents grpBGData As System.Windows.Forms.GroupBox
    Friend WithEvents pnlBGData As System.Windows.Forms.Panel
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents btnNewLitho As System.Windows.Forms.Button
End Class
