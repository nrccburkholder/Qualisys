Imports Nrc.NRCAuthLib

Public Class MemberProfileEditor

#Region " ListItem Class "
    Private Class ListItem(Of T)
        Private mLabel As String
        Private mValue As T

        Public ReadOnly Property Label() As String
            Get
                Return mLabel
            End Get
        End Property

        Public ReadOnly Property Value() As T
            Get
                Return mValue
            End Get
        End Property

        Public Sub New(ByVal lbl As String, ByVal val As T)
            Me.mLabel = lbl
            Me.mValue = val
        End Sub

    End Class
#End Region

#Region " Private Members "
    Private mOrgUnit As OrgUnit
    Private mMember As Member
    Private mErrorList As New List(Of KeyValuePair(Of Control, String))
    Private mAllowSave As Boolean = True
#End Region

#Region " Public Events "
    Public Event AllowSaveChanged As EventHandler
#End Region

#Region " Public Properties "
    Public Property AllowSave() As Boolean
        Get
            Return Me.mAllowSave
        End Get
        Private Set(ByVal value As Boolean)
            If mAllowSave <> value Then
                mAllowSave = value
                RaiseEvent AllowSaveChanged(Me, EventArgs.Empty)
            End If
        End Set
    End Property
#End Region

#Region " Private Properties "
    Private ReadOnly Property IsNewMember() As Boolean
        Get
            Return (mMember Is Nothing)
        End Get
    End Property

    Private ReadOnly Property SelectedMemberType() As Member.MemberTypeEnum
        Get
            Return DirectCast(Me.MemberTypeList.SelectedValue, Member.MemberTypeEnum)
        End Get
    End Property

    Private ReadOnly Property CanEditMemberType() As Boolean
        Get
            If Me.IsNewMember Then
                Return True
            Else
                'Determine if they can modify member type
                Dim userType As Member.MemberTypeEnum = CurrentUser.Member.MemberType
                Dim acctType As Member.MemberTypeEnum = mMember.MemberType
                Select Case acctType
                    Case Member.MemberTypeEnum.NRC_Admin
                        Return (userType = Member.MemberTypeEnum.NRC_Admin)
                    Case Member.MemberTypeEnum.Administrator
                        Return (userType = Member.MemberTypeEnum.NRC_Admin Or userType = Member.MemberTypeEnum.Administrator)
                    Case Member.MemberTypeEnum.Super_User
                        Return (userType = Member.MemberTypeEnum.NRC_Admin Or userType = Member.MemberTypeEnum.Administrator Or userType = Member.MemberTypeEnum.Super_User)
                    Case Member.MemberTypeEnum.User
                        Return True
                    Case Member.MemberTypeEnum.Registration_Account
                        Return (userType = Member.MemberTypeEnum.NRC_Admin Or userType = Member.MemberTypeEnum.Administrator Or userType = Member.MemberTypeEnum.Super_User)
                End Select
            End If
        End Get
    End Property

    Private ReadOnly Property CanEditNTLogin() As Boolean
        Get
            Return (mOrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.NrcOU _
                    OrElse mOrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.TeamOU)
        End Get
    End Property
#End Region

#Region " Constructors "
    Public Sub New(ByVal org As OrgUnit, ByVal mbr As Member)
        ' This call is required by the Windows Form Designer.
        Me.InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mOrgUnit = org
        Me.mMember = mbr
        Me.Init()
    End Sub

    Public Sub New(ByVal org As OrgUnit)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        Me.mOrgUnit = org
        Me.Init()
    End Sub
#End Region

#Region " Public Method "
    Public Sub SaveProfile()
        If Me.IsNewMember Then
            Me.CreateNewMember()
        Else
            Me.SaveMember(Me.mMember)
        End If
    End Sub
#End Region

#Region " Control Event Handlers "
    Private Sub Username_Validating(ByVal sender As System.Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles Username.Validating
        Me.ValidateForm()
    End Sub

    Private Sub Email_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles Email.Validating
        Me.ValidateForm()
    End Sub

    Private Sub MemberTypeList_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MemberTypeList.Validating
        Me.ValidateForm()
    End Sub

    Private Sub Password_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles Password.Validating
        Me.ValidateForm()
    End Sub

    Private Sub AutoGenPassword_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AutoGenPassword.CheckedChanged
        Me.TogglePasswordEnabled()
    End Sub

#End Region

#Region " Private Methods "
    Private Sub Init()
        Me.PopulateMemberTypeList()
        Me.RetireDate.Text = ""

        If Not Me.IsNewMember Then
            Me.PopulateForm()
            Me.SecurityGroupBox.Visible = False
        Else
            Me.MemberTypeList.SelectedValue = Member.MemberTypeEnum.User
        End If

        Me.MemberTypeList.Enabled = Me.CanEditMemberType
        Me.Username.Enabled = Me.IsNewMember
        Me.NTLogin.Enabled = Me.CanEditNTLogin
        Me.ValidateForm()
    End Sub

    Private Function ValidateUserName(ByRef errorMessage As String) As Boolean
        errorMessage = ""

        If Me.IsNewMember Then
            If Username.Text.Trim.Length = 0 Then
                errorMessage = "You must enter a user name."
                Return False
            End If
            If Not Member.IsUserNameAvailable(Username.Text) Then
                errorMessage = "The user name is not available."
                Return False
            End If
            If Not Member.IsValidUserName(Username.Text) Then
                errorMessage = "The user name is not valid."
                Return False
            End If
        End If

        Return True
    End Function

    Private Function ValidateEmail(ByRef errorMessage As String) As Boolean
        If Me.Email.Text.Trim.Length = 0 Then
            errorMessage = "You must enter an email address."
            Return False
        End If

        Dim pattern As String = "^([0-9a-zA-Z]+['-._+&amp;])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$"
        If Not System.Text.RegularExpressions.Regex.IsMatch(Me.Email.Text, pattern) Then
            errorMessage = "The email address is not valid."
            Return False
        End If

        Return True
    End Function

    Private Function ValidateMemberType(ByRef errorMessage As String) As Boolean
        Dim selectedType As Member.MemberTypeEnum = Me.SelectedMemberType
        Dim allowChange As Boolean = True

        Select Case CurrentUser.Member.MemberType
            Case Member.MemberTypeEnum.Administrator
                If selectedType = Member.MemberTypeEnum.NRC_Admin Then
                    allowChange = False
                End If
            Case Member.MemberTypeEnum.Super_User
                If selectedType = Member.MemberTypeEnum.NRC_Admin _
                    OrElse selectedType = Member.MemberTypeEnum.Administrator _
                    OrElse selectedType = Member.MemberTypeEnum.Registration_Account Then
                    allowChange = False
                End If
            Case Member.MemberTypeEnum.User
                If selectedType <> Member.MemberTypeEnum.User Then
                    allowChange = False
                End If
        End Select

        If Not allowChange Then
            errorMessage = "You are not authorized to assign the selected Member Type."
        End If

        Return allowChange
    End Function

    Private Function ValidatePassword(ByRef errorMessage As String) As Boolean
        '--ko 3/11/2010 Added additional check to verify edit member in comparison to a create member, should fix OK button
        If Me.SecurityGroupBox.Visible Then
            If Not Me.AutoGenPassword.Checked Then
                If Me.Password.Text.Trim.Length = 0 Then
                    errorMessage = "You must enter a password"
                    Return False
                End If

                If Not Member.IsStrongPassword(Me.Password.Text) Then
                    errorMessage = "You must enter an alphanumeric password that is at least 8 characters long"
                    Return False
                End If
            End If
        End If

        Return True
    End Function

    Private Function ValidateForm() As Boolean
        Dim result As Boolean = True
        Dim errorMessage As String = ""

        'Validate user name
        If Not Me.ValidateUserName(errorMessage) Then
            Me.ErrorProvider.SetError(Me.Username, errorMessage)
            result = False
        Else
            Me.ErrorProvider.SetError(Me.Username, "")
        End If

        'Validate email
        If Not Me.ValidateEmail(errorMessage) Then
            Me.ErrorProvider.SetError(Me.Email, errorMessage)
            result = False
        Else
            Me.ErrorProvider.SetError(Me.Email, "")
        End If

        If Not Me.ValidateMemberType(errorMessage) Then
            Me.ErrorProvider.SetError(Me.MemberTypeList, errorMessage)
            result = False
        Else
            Me.ErrorProvider.SetError(Me.MemberTypeList, "")
        End If

        If Not Me.ValidatePassword(errorMessage) Then
            Me.ErrorProvider.SetError(Me.Password, errorMessage)
            result = False
        Else
            Me.ErrorProvider.SetError(Me.Password, "")
        End If

        Me.AllowSave = result
        Return result
    End Function

    Private Sub PopulateMemberTypeList()
        Me.MemberTypeList.Items.Clear()
        Dim items As New List(Of ListItem(Of Member.MemberTypeEnum))

        items.Add(New ListItem(Of Member.MemberTypeEnum)("NRC Administrator", Member.MemberTypeEnum.NRC_Admin))
        items.Add(New ListItem(Of Member.MemberTypeEnum)("Administrator", Member.MemberTypeEnum.Administrator))
        items.Add(New ListItem(Of Member.MemberTypeEnum)("Registration Account", Member.MemberTypeEnum.Registration_Account))
        items.Add(New ListItem(Of Member.MemberTypeEnum)("Super User", Member.MemberTypeEnum.Super_User))
        items.Add(New ListItem(Of Member.MemberTypeEnum)("User", Member.MemberTypeEnum.User))
        Me.MemberTypeList.DataSource = items
        Me.MemberTypeList.DisplayMember = "Label"
        Me.MemberTypeList.ValueMember = "Value"

    End Sub

    Private Sub PopulateForm()
        Me.Username.Text = Me.mMember.UserName
        Me.Email.Text = Me.mMember.EmailAddress
        Me.MemberTypeList.SelectedValue = Me.mMember.MemberType
        Me.FirstName.Text = Me.mMember.FirstName
        Me.LastName.Text = Me.mMember.LastName
        Me.Facility.Text = Me.mMember.Facility
        Me.Title.Text = Me.mMember.OccupationalTitle
        Me.Phone.Text = Me.mMember.PhoneNumber
        Me.City.Text = Me.mMember.City
        Me.State.Text = Me.mMember.State
        Me.NTLogin.Text = Me.mMember.NTLoginName
        If Me.mMember.DateRetired.Equals(Date.MinValue) Then
            Me.RetireDate.Text = ""
        Else
            Me.RetireDate.DateTime = Me.mMember.DateRetired
        End If
    End Sub

    Private Sub SaveMember(ByVal mbr As Member)
        'Save the profile information
        mbr.EmailAddress = Me.Email.Text
        mbr.FirstName = Me.FirstName.Text
        mbr.LastName = Me.LastName.Text
        mbr.Facility = Me.Facility.Text
        mbr.OccupationalTitle = Me.Title.Text
        mbr.PhoneNumber = Me.Phone.Text
        mbr.City = Me.City.Text
        mbr.State = Me.State.Text
        mbr.UpdateProfile(CurrentUser.Member.MemberId)

        'Save the NT Login if needed
        If mbr.NTLoginName <> Me.NTLogin.Text Then
            mbr.NTLoginName = Me.NTLogin.Text
            mbr.UpdateNTLogin()
        End If

        'Save MemberType if needed
        If mbr.MemberType <> Me.SelectedMemberType Then
            mbr.ChangeMemberType(Me.SelectedMemberType, CurrentUser.Member.MemberId)
        End If

        'Set the retire date if needed
        Dim newRetireDate As Date = Date.MinValue
        If Not Me.RetireDate.Text = "" Then
            newRetireDate = Me.RetireDate.DateTime.Date
        End If
        If mbr.DateRetired <> newRetireDate Then
            mbr.DateRetired = newRetireDate
            mbr.UpdateRetireDate(CurrentUser.Member.MemberId)
        End If

    End Sub

    Private Sub CreateNewMember()
        Dim newMember As Member

        If Me.AutoGenPassword.Checked Then
            newMember = Member.CreateNewMember(CurrentUser.Member.MemberId, _
                                                Me.mOrgUnit.OrgUnitId, _
                                                Me.Username.Text, _
                                                Me.Email.Text, _
                                                Me.SelectedMemberType, _
                                                Me.SendEmailNotification.Checked)
        Else
            newMember = Member.CreateNewMember(CurrentUser.Member.MemberId, _
                                                Me.mOrgUnit.OrgUnitId, _
                                                Me.Username.Text, _
                                                Me.Email.Text, _
                                                Me.SelectedMemberType, _
                                                Me.SendEmailNotification.Checked, _
                                                Me.Password.Text)
        End If

        'Now save all the rest of the member info on the form
        Me.SaveMember(newMember)

        'Add the member object to the OrgUnits Member colleciton
        mOrgUnit.Members.Add(newMember)
    End Sub

    Private Sub TogglePasswordEnabled()
        Me.PasswordLabel.Enabled = (Not Me.AutoGenPassword.Checked)
        Me.Password.Enabled = (Not Me.AutoGenPassword.Checked)
        If Me.AutoGenPassword.Checked Then
            Me.Password.Text = ""
        End If
    End Sub
#End Region

End Class
