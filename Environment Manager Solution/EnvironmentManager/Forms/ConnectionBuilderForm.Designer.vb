<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ConnectionBuilderForm
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(ConnectionBuilderForm))
        Me.cboServers = New System.Windows.Forms.ComboBox
        Me.lblServers = New System.Windows.Forms.Label
        Me.gbAuthentication = New System.Windows.Forms.GroupBox
        Me.rbSQLAuth = New System.Windows.Forms.RadioButton
        Me.rbWindowsAuth = New System.Windows.Forms.RadioButton
        Me.pnlCredentials = New System.Windows.Forms.Panel
        Me.txtPassword = New System.Windows.Forms.TextBox
        Me.txtUserName = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.cboDatabases = New System.Windows.Forms.ComboBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.btnTest = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.gbAuthentication.SuspendLayout()
        Me.pnlCredentials.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboServers
        '
        Me.cboServers.FormattingEnabled = True
        Me.cboServers.Items.AddRange(New Object() {"Cyclone,5678", "Hulk,5678", "Jayhawk,5678", "LongHorn,5678", "Mars", "Medusa", "Mercury", "NRC10", "Spiderman,5678", "Tiger,5678", "WonderWoman,5678"})
        Me.cboServers.Location = New System.Drawing.Point(34, 52)
        Me.cboServers.Name = "cboServers"
        Me.cboServers.Size = New System.Drawing.Size(376, 21)
        Me.cboServers.TabIndex = 0
        '
        'lblServers
        '
        Me.lblServers.AutoSize = True
        Me.lblServers.Location = New System.Drawing.Point(31, 36)
        Me.lblServers.Name = "lblServers"
        Me.lblServers.Size = New System.Drawing.Size(69, 13)
        Me.lblServers.TabIndex = 1
        Me.lblServers.Text = "S&erver Name"
        '
        'gbAuthentication
        '
        Me.gbAuthentication.Controls.Add(Me.rbSQLAuth)
        Me.gbAuthentication.Controls.Add(Me.rbWindowsAuth)
        Me.gbAuthentication.Controls.Add(Me.pnlCredentials)
        Me.gbAuthentication.Enabled = False
        Me.gbAuthentication.Location = New System.Drawing.Point(34, 101)
        Me.gbAuthentication.Name = "gbAuthentication"
        Me.gbAuthentication.Size = New System.Drawing.Size(376, 153)
        Me.gbAuthentication.TabIndex = 2
        Me.gbAuthentication.TabStop = False
        Me.gbAuthentication.Text = "Log on to the server"
        '
        'rbSQLAuth
        '
        Me.rbSQLAuth.AutoSize = True
        Me.rbSQLAuth.Location = New System.Drawing.Point(26, 42)
        Me.rbSQLAuth.Name = "rbSQLAuth"
        Me.rbSQLAuth.Size = New System.Drawing.Size(151, 17)
        Me.rbSQLAuth.TabIndex = 1
        Me.rbSQLAuth.TabStop = True
        Me.rbSQLAuth.Text = "S&QL Server Authentication"
        Me.rbSQLAuth.UseVisualStyleBackColor = True
        '
        'rbWindowsAuth
        '
        Me.rbWindowsAuth.AutoSize = True
        Me.rbWindowsAuth.Location = New System.Drawing.Point(26, 19)
        Me.rbWindowsAuth.Name = "rbWindowsAuth"
        Me.rbWindowsAuth.Size = New System.Drawing.Size(140, 17)
        Me.rbWindowsAuth.TabIndex = 0
        Me.rbWindowsAuth.TabStop = True
        Me.rbWindowsAuth.Text = "&Windows Authentication"
        Me.rbWindowsAuth.UseVisualStyleBackColor = True
        '
        'pnlCredentials
        '
        Me.pnlCredentials.Controls.Add(Me.txtPassword)
        Me.pnlCredentials.Controls.Add(Me.txtUserName)
        Me.pnlCredentials.Controls.Add(Me.Label2)
        Me.pnlCredentials.Controls.Add(Me.Label1)
        Me.pnlCredentials.Enabled = False
        Me.pnlCredentials.Location = New System.Drawing.Point(58, 74)
        Me.pnlCredentials.Name = "pnlCredentials"
        Me.pnlCredentials.Size = New System.Drawing.Size(312, 56)
        Me.pnlCredentials.TabIndex = 2
        '
        'txtPassword
        '
        Me.txtPassword.Location = New System.Drawing.Point(84, 29)
        Me.txtPassword.Name = "txtPassword"
        Me.txtPassword.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.txtPassword.Size = New System.Drawing.Size(222, 20)
        Me.txtPassword.TabIndex = 1
        Me.txtPassword.Text = "qpsa"
        '
        'txtUserName
        '
        Me.txtUserName.Location = New System.Drawing.Point(84, 3)
        Me.txtUserName.Name = "txtUserName"
        Me.txtUserName.Size = New System.Drawing.Size(222, 20)
        Me.txtUserName.TabIndex = 0
        Me.txtUserName.Text = "qpsa"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 36)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(53, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "&Password"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 10)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(55, 13)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "&Username"
        '
        'cboDatabases
        '
        Me.cboDatabases.Enabled = False
        Me.cboDatabases.FormattingEnabled = True
        Me.cboDatabases.Location = New System.Drawing.Point(15, 40)
        Me.cboDatabases.Name = "cboDatabases"
        Me.cboDatabases.Size = New System.Drawing.Size(340, 21)
        Me.cboDatabases.TabIndex = 0
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 24)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(84, 13)
        Me.Label3.TabIndex = 1
        Me.Label3.Text = "&Database Name"
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.cboDatabases)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Location = New System.Drawing.Point(34, 270)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(376, 87)
        Me.GroupBox1.TabIndex = 3
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Connect to a database"
        '
        'btnTest
        '
        Me.btnTest.Enabled = False
        Me.btnTest.Location = New System.Drawing.Point(34, 387)
        Me.btnTest.Name = "btnTest"
        Me.btnTest.Size = New System.Drawing.Size(116, 23)
        Me.btnTest.TabIndex = 1
        Me.btnTest.Text = "&Test Connection"
        Me.btnTest.UseVisualStyleBackColor = True
        '
        'btnOK
        '
        Me.btnOK.Enabled = False
        Me.btnOK.Location = New System.Drawing.Point(245, 427)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(77, 23)
        Me.btnOK.TabIndex = 4
        Me.btnOK.Text = "OK"
        Me.btnOK.UseVisualStyleBackColor = True
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(335, 427)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 4
        Me.btnCancel.Text = "Cancel"
        Me.btnCancel.UseVisualStyleBackColor = True
        '
        'ConnectionBuilderForm
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(442, 471)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnTest)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.gbAuthentication)
        Me.Controls.Add(Me.lblServers)
        Me.Controls.Add(Me.cboServers)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "ConnectionBuilderForm"
        Me.Text = "Create Connection String"
        Me.gbAuthentication.ResumeLayout(False)
        Me.gbAuthentication.PerformLayout()
        Me.pnlCredentials.ResumeLayout(False)
        Me.pnlCredentials.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cboServers As System.Windows.Forms.ComboBox
    Friend WithEvents lblServers As System.Windows.Forms.Label
    Friend WithEvents gbAuthentication As System.Windows.Forms.GroupBox
    Friend WithEvents txtPassword As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtUserName As System.Windows.Forms.TextBox
    Friend WithEvents rbSQLAuth As System.Windows.Forms.RadioButton
    Friend WithEvents rbWindowsAuth As System.Windows.Forms.RadioButton
    Friend WithEvents cboDatabases As System.Windows.Forms.ComboBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents btnTest As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents pnlCredentials As System.Windows.Forms.Panel
End Class
