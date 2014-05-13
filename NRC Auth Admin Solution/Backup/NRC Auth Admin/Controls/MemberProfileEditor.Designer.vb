<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MemberProfileEditor
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.FlowLayoutPanel1 = New System.Windows.Forms.FlowLayoutPanel
        Me.AccountGroupBox = New System.Windows.Forms.GroupBox
        Me.UserNameLabel = New System.Windows.Forms.Label
        Me.Username = New System.Windows.Forms.TextBox
        Me.MemberTypeLabel = New System.Windows.Forms.Label
        Me.MemberTypeList = New System.Windows.Forms.ComboBox
        Me.NTLogin = New System.Windows.Forms.TextBox
        Me.NTLoginLabel = New System.Windows.Forms.Label
        Me.RetireDate = New DevExpress.XtraEditors.DateEdit
        Me.RetireDateLabel = New System.Windows.Forms.Label
        Me.SecurityGroupBox = New System.Windows.Forms.GroupBox
        Me.SendEmailNotification = New System.Windows.Forms.CheckBox
        Me.Password = New System.Windows.Forms.TextBox
        Me.PasswordLabel = New System.Windows.Forms.Label
        Me.AutoGenPassword = New System.Windows.Forms.CheckBox
        Me.UserGroupBox = New System.Windows.Forms.GroupBox
        Me.State = New System.Windows.Forms.TextBox
        Me.StateLabel = New System.Windows.Forms.Label
        Me.CityLabel = New System.Windows.Forms.Label
        Me.City = New System.Windows.Forms.TextBox
        Me.Email = New System.Windows.Forms.TextBox
        Me.EmailLabel = New System.Windows.Forms.Label
        Me.PhoneLabel = New System.Windows.Forms.Label
        Me.FacilityLabel = New System.Windows.Forms.Label
        Me.LastName = New System.Windows.Forms.TextBox
        Me.TitleLabel = New System.Windows.Forms.Label
        Me.Phone = New System.Windows.Forms.TextBox
        Me.Title = New System.Windows.Forms.TextBox
        Me.Facility = New System.Windows.Forms.TextBox
        Me.FirstName = New System.Windows.Forms.TextBox
        Me.LastNameLabel = New System.Windows.Forms.Label
        Me.FirstNameLabel = New System.Windows.Forms.Label
        Me.ErrorProvider = New System.Windows.Forms.ErrorProvider(Me.components)
        Me.FlowLayoutPanel1.SuspendLayout()
        Me.AccountGroupBox.SuspendLayout()
        CType(Me.RetireDate.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.RetireDate.Properties, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SecurityGroupBox.SuspendLayout()
        Me.UserGroupBox.SuspendLayout()
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'FlowLayoutPanel1
        '
        Me.FlowLayoutPanel1.AutoSize = True
        Me.FlowLayoutPanel1.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.FlowLayoutPanel1.Controls.Add(Me.AccountGroupBox)
        Me.FlowLayoutPanel1.Controls.Add(Me.SecurityGroupBox)
        Me.FlowLayoutPanel1.Controls.Add(Me.UserGroupBox)
        Me.FlowLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FlowLayoutPanel1.FlowDirection = System.Windows.Forms.FlowDirection.TopDown
        Me.FlowLayoutPanel1.Location = New System.Drawing.Point(0, 0)
        Me.FlowLayoutPanel1.Name = "FlowLayoutPanel1"
        Me.FlowLayoutPanel1.Size = New System.Drawing.Size(442, 450)
        Me.FlowLayoutPanel1.TabIndex = 2
        Me.FlowLayoutPanel1.WrapContents = False
        '
        'AccountGroupBox
        '
        Me.AccountGroupBox.Controls.Add(Me.UserNameLabel)
        Me.AccountGroupBox.Controls.Add(Me.Username)
        Me.AccountGroupBox.Controls.Add(Me.MemberTypeLabel)
        Me.AccountGroupBox.Controls.Add(Me.MemberTypeList)
        Me.AccountGroupBox.Controls.Add(Me.NTLogin)
        Me.AccountGroupBox.Controls.Add(Me.NTLoginLabel)
        Me.AccountGroupBox.Controls.Add(Me.RetireDate)
        Me.AccountGroupBox.Controls.Add(Me.RetireDateLabel)
        Me.AccountGroupBox.Location = New System.Drawing.Point(3, 3)
        Me.AccountGroupBox.Name = "AccountGroupBox"
        Me.AccountGroupBox.Size = New System.Drawing.Size(436, 125)
        Me.AccountGroupBox.TabIndex = 0
        Me.AccountGroupBox.TabStop = False
        Me.AccountGroupBox.Text = "Account Information"
        '
        'UserNameLabel
        '
        Me.UserNameLabel.AutoSize = True
        Me.UserNameLabel.Location = New System.Drawing.Point(5, 22)
        Me.UserNameLabel.Name = "UserNameLabel"
        Me.UserNameLabel.Size = New System.Drawing.Size(58, 13)
        Me.UserNameLabel.TabIndex = 4
        Me.UserNameLabel.Text = "User name"
        '
        'Username
        '
        Me.Username.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Username.Location = New System.Drawing.Point(83, 18)
        Me.Username.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.Username.Name = "Username"
        Me.Username.Size = New System.Drawing.Size(333, 20)
        Me.Username.TabIndex = 0
        '
        'MemberTypeLabel
        '
        Me.MemberTypeLabel.AutoSize = True
        Me.MemberTypeLabel.Location = New System.Drawing.Point(5, 49)
        Me.MemberTypeLabel.Name = "MemberTypeLabel"
        Me.MemberTypeLabel.Size = New System.Drawing.Size(68, 13)
        Me.MemberTypeLabel.TabIndex = 5
        Me.MemberTypeLabel.Text = "Member type"
        '
        'MemberTypeList
        '
        Me.MemberTypeList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MemberTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.MemberTypeList.FormattingEnabled = True
        Me.MemberTypeList.Location = New System.Drawing.Point(83, 45)
        Me.MemberTypeList.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.MemberTypeList.Name = "MemberTypeList"
        Me.MemberTypeList.Size = New System.Drawing.Size(333, 21)
        Me.MemberTypeList.TabIndex = 1
        '
        'NTLogin
        '
        Me.NTLogin.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NTLogin.Location = New System.Drawing.Point(83, 72)
        Me.NTLogin.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.NTLogin.Name = "NTLogin"
        Me.NTLogin.Size = New System.Drawing.Size(333, 20)
        Me.NTLogin.TabIndex = 2
        '
        'NTLoginLabel
        '
        Me.NTLoginLabel.AutoSize = True
        Me.NTLoginLabel.Location = New System.Drawing.Point(5, 76)
        Me.NTLoginLabel.Name = "NTLoginLabel"
        Me.NTLoginLabel.Size = New System.Drawing.Size(76, 13)
        Me.NTLoginLabel.TabIndex = 6
        Me.NTLoginLabel.Text = "Windows login"
        '
        'RetireDate
        '
        Me.RetireDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RetireDate.EditValue = New Date(2006, 2, 20, 0, 0, 0, 0)
        Me.RetireDate.Location = New System.Drawing.Point(83, 99)
        Me.RetireDate.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.RetireDate.Name = "RetireDate"
        Me.RetireDate.Properties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton(DevExpress.XtraEditors.Controls.ButtonPredefines.Combo)})
        Me.RetireDate.Properties.VistaTimeProperties.Buttons.AddRange(New DevExpress.XtraEditors.Controls.EditorButton() {New DevExpress.XtraEditors.Controls.EditorButton})
        Me.RetireDate.Size = New System.Drawing.Size(333, 20)
        Me.RetireDate.TabIndex = 3
        '
        'RetireDateLabel
        '
        Me.RetireDateLabel.AutoSize = True
        Me.RetireDateLabel.Location = New System.Drawing.Point(5, 102)
        Me.RetireDateLabel.Name = "RetireDateLabel"
        Me.RetireDateLabel.Size = New System.Drawing.Size(59, 13)
        Me.RetireDateLabel.TabIndex = 7
        Me.RetireDateLabel.Text = "Retire date"
        '
        'SecurityGroupBox
        '
        Me.SecurityGroupBox.Controls.Add(Me.SendEmailNotification)
        Me.SecurityGroupBox.Controls.Add(Me.Password)
        Me.SecurityGroupBox.Controls.Add(Me.PasswordLabel)
        Me.SecurityGroupBox.Controls.Add(Me.AutoGenPassword)
        Me.SecurityGroupBox.Location = New System.Drawing.Point(3, 134)
        Me.SecurityGroupBox.Name = "SecurityGroupBox"
        Me.SecurityGroupBox.Size = New System.Drawing.Size(436, 65)
        Me.SecurityGroupBox.TabIndex = 1
        Me.SecurityGroupBox.TabStop = False
        Me.SecurityGroupBox.Text = "Security Information"
        '
        'SendEmailNotification
        '
        Me.SendEmailNotification.AutoSize = True
        Me.SendEmailNotification.Location = New System.Drawing.Point(8, 43)
        Me.SendEmailNotification.Name = "SendEmailNotification"
        Me.SendEmailNotification.Size = New System.Drawing.Size(132, 17)
        Me.SendEmailNotification.TabIndex = 2
        Me.SendEmailNotification.Text = "Send email notification"
        Me.SendEmailNotification.UseVisualStyleBackColor = True
        '
        'Password
        '
        Me.Password.Location = New System.Drawing.Point(230, 18)
        Me.Password.Name = "Password"
        Me.Password.Size = New System.Drawing.Size(186, 20)
        Me.Password.TabIndex = 1
        '
        'PasswordLabel
        '
        Me.PasswordLabel.AutoSize = True
        Me.PasswordLabel.Location = New System.Drawing.Point(171, 22)
        Me.PasswordLabel.Name = "PasswordLabel"
        Me.PasswordLabel.Size = New System.Drawing.Size(53, 13)
        Me.PasswordLabel.TabIndex = 3
        Me.PasswordLabel.Text = "Password"
        '
        'AutoGenPassword
        '
        Me.AutoGenPassword.AutoSize = True
        Me.AutoGenPassword.Location = New System.Drawing.Point(8, 20)
        Me.AutoGenPassword.Name = "AutoGenPassword"
        Me.AutoGenPassword.Size = New System.Drawing.Size(141, 17)
        Me.AutoGenPassword.TabIndex = 0
        Me.AutoGenPassword.Text = "Auto-generate password"
        Me.AutoGenPassword.UseVisualStyleBackColor = True
        '
        'UserGroupBox
        '
        Me.UserGroupBox.Controls.Add(Me.State)
        Me.UserGroupBox.Controls.Add(Me.StateLabel)
        Me.UserGroupBox.Controls.Add(Me.CityLabel)
        Me.UserGroupBox.Controls.Add(Me.City)
        Me.UserGroupBox.Controls.Add(Me.Email)
        Me.UserGroupBox.Controls.Add(Me.EmailLabel)
        Me.UserGroupBox.Controls.Add(Me.PhoneLabel)
        Me.UserGroupBox.Controls.Add(Me.FacilityLabel)
        Me.UserGroupBox.Controls.Add(Me.LastName)
        Me.UserGroupBox.Controls.Add(Me.TitleLabel)
        Me.UserGroupBox.Controls.Add(Me.Phone)
        Me.UserGroupBox.Controls.Add(Me.Title)
        Me.UserGroupBox.Controls.Add(Me.Facility)
        Me.UserGroupBox.Controls.Add(Me.FirstName)
        Me.UserGroupBox.Controls.Add(Me.LastNameLabel)
        Me.UserGroupBox.Controls.Add(Me.FirstNameLabel)
        Me.UserGroupBox.Location = New System.Drawing.Point(3, 205)
        Me.UserGroupBox.Name = "UserGroupBox"
        Me.UserGroupBox.Size = New System.Drawing.Size(436, 242)
        Me.UserGroupBox.TabIndex = 2
        Me.UserGroupBox.TabStop = False
        Me.UserGroupBox.Text = "User Information"
        '
        'State
        '
        Me.State.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.State.Location = New System.Drawing.Point(83, 211)
        Me.State.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.State.Name = "State"
        Me.State.Size = New System.Drawing.Size(333, 20)
        Me.State.TabIndex = 7
        '
        'StateLabel
        '
        Me.StateLabel.AutoSize = True
        Me.StateLabel.Location = New System.Drawing.Point(5, 215)
        Me.StateLabel.Name = "StateLabel"
        Me.StateLabel.Size = New System.Drawing.Size(32, 13)
        Me.StateLabel.TabIndex = 15
        Me.StateLabel.Text = "State"
        '
        'CityLabel
        '
        Me.CityLabel.AutoSize = True
        Me.CityLabel.Location = New System.Drawing.Point(5, 188)
        Me.CityLabel.Name = "CityLabel"
        Me.CityLabel.Size = New System.Drawing.Size(24, 13)
        Me.CityLabel.TabIndex = 14
        Me.CityLabel.Text = "City"
        '
        'City
        '
        Me.City.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.City.Location = New System.Drawing.Point(83, 184)
        Me.City.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.City.Name = "City"
        Me.City.Size = New System.Drawing.Size(333, 20)
        Me.City.TabIndex = 6
        '
        'Email
        '
        Me.Email.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Email.Location = New System.Drawing.Point(83, 103)
        Me.Email.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.Email.Name = "Email"
        Me.Email.Size = New System.Drawing.Size(333, 20)
        Me.Email.TabIndex = 3
        '
        'EmailLabel
        '
        Me.EmailLabel.AutoSize = True
        Me.EmailLabel.Location = New System.Drawing.Point(5, 107)
        Me.EmailLabel.Name = "EmailLabel"
        Me.EmailLabel.Size = New System.Drawing.Size(32, 13)
        Me.EmailLabel.TabIndex = 11
        Me.EmailLabel.Text = "Email"
        '
        'PhoneLabel
        '
        Me.PhoneLabel.AutoSize = True
        Me.PhoneLabel.Location = New System.Drawing.Point(5, 161)
        Me.PhoneLabel.Name = "PhoneLabel"
        Me.PhoneLabel.Size = New System.Drawing.Size(76, 13)
        Me.PhoneLabel.TabIndex = 13
        Me.PhoneLabel.Text = "Phone number"
        '
        'FacilityLabel
        '
        Me.FacilityLabel.AutoSize = True
        Me.FacilityLabel.Location = New System.Drawing.Point(5, 134)
        Me.FacilityLabel.Name = "FacilityLabel"
        Me.FacilityLabel.Size = New System.Drawing.Size(39, 13)
        Me.FacilityLabel.TabIndex = 12
        Me.FacilityLabel.Text = "Facility"
        '
        'LastName
        '
        Me.LastName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LastName.Location = New System.Drawing.Point(83, 47)
        Me.LastName.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.LastName.Name = "LastName"
        Me.LastName.Size = New System.Drawing.Size(333, 20)
        Me.LastName.TabIndex = 1
        '
        'TitleLabel
        '
        Me.TitleLabel.AutoSize = True
        Me.TitleLabel.Location = New System.Drawing.Point(5, 80)
        Me.TitleLabel.Name = "TitleLabel"
        Me.TitleLabel.Size = New System.Drawing.Size(27, 13)
        Me.TitleLabel.TabIndex = 10
        Me.TitleLabel.Text = "Title"
        '
        'Phone
        '
        Me.Phone.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Phone.Location = New System.Drawing.Point(83, 157)
        Me.Phone.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.Phone.Name = "Phone"
        Me.Phone.Size = New System.Drawing.Size(333, 20)
        Me.Phone.TabIndex = 5
        '
        'Title
        '
        Me.Title.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Title.Location = New System.Drawing.Point(83, 76)
        Me.Title.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.Title.Name = "Title"
        Me.Title.Size = New System.Drawing.Size(333, 20)
        Me.Title.TabIndex = 2
        '
        'Facility
        '
        Me.Facility.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Facility.Location = New System.Drawing.Point(83, 130)
        Me.Facility.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.Facility.Name = "Facility"
        Me.Facility.Size = New System.Drawing.Size(333, 20)
        Me.Facility.TabIndex = 4
        '
        'FirstName
        '
        Me.FirstName.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FirstName.Location = New System.Drawing.Point(83, 20)
        Me.FirstName.Margin = New System.Windows.Forms.Padding(3, 3, 25, 3)
        Me.FirstName.Name = "FirstName"
        Me.FirstName.Size = New System.Drawing.Size(333, 20)
        Me.FirstName.TabIndex = 0
        '
        'LastNameLabel
        '
        Me.LastNameLabel.AutoSize = True
        Me.LastNameLabel.Location = New System.Drawing.Point(5, 51)
        Me.LastNameLabel.Name = "LastNameLabel"
        Me.LastNameLabel.Size = New System.Drawing.Size(56, 13)
        Me.LastNameLabel.TabIndex = 9
        Me.LastNameLabel.Text = "Last name"
        '
        'FirstNameLabel
        '
        Me.FirstNameLabel.AutoSize = True
        Me.FirstNameLabel.Location = New System.Drawing.Point(5, 24)
        Me.FirstNameLabel.Name = "FirstNameLabel"
        Me.FirstNameLabel.Size = New System.Drawing.Size(55, 13)
        Me.FirstNameLabel.TabIndex = 8
        Me.FirstNameLabel.Text = "First name"
        '
        'ErrorProvider
        '
        Me.ErrorProvider.ContainerControl = Me
        '
        'MemberProfileEditor
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoSize = True
        Me.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink
        Me.Controls.Add(Me.FlowLayoutPanel1)
        Me.Name = "MemberProfileEditor"
        Me.Size = New System.Drawing.Size(442, 450)
        Me.FlowLayoutPanel1.ResumeLayout(False)
        Me.AccountGroupBox.ResumeLayout(False)
        Me.AccountGroupBox.PerformLayout()
        CType(Me.RetireDate.Properties.VistaTimeProperties, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.RetireDate.Properties, System.ComponentModel.ISupportInitialize).EndInit()
        Me.SecurityGroupBox.ResumeLayout(False)
        Me.SecurityGroupBox.PerformLayout()
        Me.UserGroupBox.ResumeLayout(False)
        Me.UserGroupBox.PerformLayout()
        CType(Me.ErrorProvider, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents FlowLayoutPanel1 As System.Windows.Forms.FlowLayoutPanel
    Friend WithEvents AccountGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents UserNameLabel As System.Windows.Forms.Label
    Friend WithEvents Username As System.Windows.Forms.TextBox
    Friend WithEvents MemberTypeLabel As System.Windows.Forms.Label
    Friend WithEvents MemberTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents NTLogin As System.Windows.Forms.TextBox
    Friend WithEvents NTLoginLabel As System.Windows.Forms.Label
    Friend WithEvents RetireDate As DevExpress.XtraEditors.DateEdit
    Friend WithEvents RetireDateLabel As System.Windows.Forms.Label
    Friend WithEvents SecurityGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents SendEmailNotification As System.Windows.Forms.CheckBox
    Friend WithEvents Password As System.Windows.Forms.TextBox
    Friend WithEvents PasswordLabel As System.Windows.Forms.Label
    Friend WithEvents AutoGenPassword As System.Windows.Forms.CheckBox
    Friend WithEvents UserGroupBox As System.Windows.Forms.GroupBox
    Friend WithEvents State As System.Windows.Forms.TextBox
    Friend WithEvents StateLabel As System.Windows.Forms.Label
    Friend WithEvents CityLabel As System.Windows.Forms.Label
    Friend WithEvents City As System.Windows.Forms.TextBox
    Friend WithEvents Email As System.Windows.Forms.TextBox
    Friend WithEvents EmailLabel As System.Windows.Forms.Label
    Friend WithEvents PhoneLabel As System.Windows.Forms.Label
    Friend WithEvents FacilityLabel As System.Windows.Forms.Label
    Friend WithEvents LastName As System.Windows.Forms.TextBox
    Friend WithEvents TitleLabel As System.Windows.Forms.Label
    Friend WithEvents Phone As System.Windows.Forms.TextBox
    Friend WithEvents Title As System.Windows.Forms.TextBox
    Friend WithEvents Facility As System.Windows.Forms.TextBox
    Friend WithEvents FirstName As System.Windows.Forms.TextBox
    Friend WithEvents LastNameLabel As System.Windows.Forms.Label
    Friend WithEvents FirstNameLabel As System.Windows.Forms.Label
    Friend WithEvents ErrorProvider As System.Windows.Forms.ErrorProvider

End Class
