Imports NRC.Data

''' <summary>
''' Represents a Member user account
''' </summary>
''' <summary></summary>
''' <CreateBy>mhammons</CreateBy>
''' <RevisionList>‘<list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list>’</RevisionList>
<AutoPopulate(), Serializable()> _
Public Class Member
    Implements System.Security.Principal.IIdentity

#Region " Enums / Constants "
    Public Enum MemberTypeEnum
        NRC_Admin = 1
        Administrator = 2
        Super_User = 3
        User = 4
        Registration_Account = 5
    End Enum

    Friend Const PASSWORD_EXPIRES_DAYS As Integer = 120
#End Region

#Region " Private Members "
    Protected mMemberId As Integer
    Protected mOrgUnitId As Integer
    Protected mCreatorMemberId As Integer
    Protected mDateCreated As DateTime
    Protected mLastLoginDate As DateTime
    Protected mDateLocked As DateTime
    Protected mDateRetired As DateTime
    Protected mUserName As String
    Protected mNTLoginName As String
    Protected mPasswordHash As String
    Protected mPasswordSalt As String
    Protected mLastPasswordChangeDate As DateTime
    Protected mSecretQuestion As String
    Protected mSecretAnswerHash As String
    Protected mPasswordChangeInterval As Integer
    Protected mMemberType As MemberTypeEnum
    Protected mEmailAddress As String
    Protected mFirstName As String
    Protected mLastName As String
    Protected mOccupationalTitle As String
    Protected mPhonenumber As String
    Protected mCity As String
    Protected mState As String
    Protected mFacility As String

    Private mOrgUnit As OrgUnit
    Private mApplications As ApplicationCollection
    Private mGroups As GroupCollection

    Private mAllOtherUserNames As Collections.ArrayList

#End Region

#Region " Public Properties "
    Public ReadOnly Property MemberId() As Integer
        Get
            Return mMemberId
        End Get
    End Property
    Public ReadOnly Property OrgUnitId() As Integer
        Get
            Return mOrgUnitId
        End Get
    End Property
    Public ReadOnly Property CreatorMemberId() As Integer
        Get
            Return mCreatorMemberId
        End Get
    End Property
    ''' <summary>
    ''' The date that this account was created
    ''' </summary>
    Public ReadOnly Property DateCreated() As DateTime
        Get
            Return mDateCreated
        End Get
    End Property
    ''' <summary>
    ''' The date on which the user last logged in
    ''' </summary>
    Public ReadOnly Property LastLoginDate() As DateTime
        Get
            Return mLastLoginDate
        End Get
    End Property
    Public ReadOnly Property DateLocked() As DateTime
        Get
            Return mDateLocked
        End Get
    End Property
    ''' <summary>
    ''' Indicates that the account has been locked and must be unlocked by an administrator before use
    ''' </summary>
    Public ReadOnly Property IsAccountLocked() As Boolean
        Get
            Return Not mDateLocked.Equals(NRC.Data.Null.NullDate)
        End Get
    End Property
    Public Property DateRetired() As DateTime
        Get
            Return mDateRetired
        End Get
        Set(ByVal Value As DateTime)
            mDateRetired = Value
        End Set
    End Property
    Public ReadOnly Property IsAccountRetired() As Boolean
        Get
            Return Not mDateRetired.Equals(NRC.Data.Null.NullDate)
        End Get
    End Property
    ''' <summary>
    ''' The User Name of the account
    ''' </summary>
    Public Property UserName() As String
        Get
            Return mUserName
        End Get
        Set(ByVal Value As String)
            mUserName = Value
        End Set
    End Property

    ''' <summary>
    ''' The NRC Windows NT User Name of the account
    ''' </summary>
    Public Property NTLoginName() As String
        Get
            Return mNTLoginName
        End Get
        Set(ByVal Value As String)
            mNTLoginName = Value
        End Set
    End Property

    ''' <summary>
    ''' The date on which the user last changed their password
    ''' </summary>
    Public ReadOnly Property LastPasswordChangeDate() As DateTime
        Get
            Return mLastPasswordChangeDate
        End Get
    End Property
    ''' <summary>
    ''' Indicates that the password has expired and needs to be changed
    ''' </summary>
    Public ReadOnly Property IsPasswordExpired() As Boolean
        Get
            Return (mLastPasswordChangeDate.AddDays(mPasswordChangeInterval) < DateTime.Now)
        End Get
    End Property

    Public ReadOnly Property DaysUntillPasswordExpires() As Integer
        Get
            Return mLastPasswordChangeDate.AddDays(mPasswordChangeInterval).Subtract(DateTime.Now).Days
        End Get
    End Property
    Public ReadOnly Property IsProfileIncomplete() As Boolean
        Get
            If mFirstName Is Nothing OrElse mFirstName = "" Then
                Return True
            End If
            If mLastName Is Nothing OrElse mLastName = "" Then
                Return True
            End If
            If mEmailAddress Is Nothing OrElse mEmailAddress = "" Then
                Return True
            End If

            Return False
        End Get
    End Property
    
    ''' <summary>
    ''' Indicates what type of member this is
    ''' </summary>
    Public ReadOnly Property MemberType() As MemberTypeEnum
        Get
            Return mMemberType
        End Get
    End Property
    ''' <summary>
    ''' The organizational unit for which this user is a member of
    ''' </summary>
    Public ReadOnly Property OrgUnit() As OrgUnit
        Get
            If mOrgUnit Is Nothing Then
                mOrgUnit = NRCAuthLib.OrgUnit.GetOrgUnit(mOrgUnitId)
            End If

            Return mOrgUnit
        End Get
    End Property

    Public ReadOnly Property Groups() As GroupCollection
        Get
            If mGroups Is Nothing Then
                mGroups = GroupCollection.GetMemberGroups(mMemberId)
            End If
            Return mGroups
        End Get
    End Property

    

    Public ReadOnly Property MemberApplications() As ApplicationCollection
        Get
            If mApplications Is Nothing Then
                mApplications = ApplicationCollection.GetMemberApplications(mMemberId)
            End If
            Return mApplications
        End Get
    End Property

    Public ReadOnly Property HasAccessToMultipleGroups() As Boolean
        Get
            If (mMemberType = MemberTypeEnum.User AndAlso Groups.Count = 1) Then
                Return False
            Else
                Return True
            End If
        End Get
    End Property

    ''' <summary>
    ''' The label that should be displayed for this user in the UI
    ''' </summary>
    Public ReadOnly Property DisplayLabel() As String
        Get
            If mMemberType = MemberTypeEnum.Registration_Account Then
                Return String.Format("*{0}", mUserName)
            Else
                Return String.Format("{0} {1} ({2})", mFirstName, mLastName, mUserName)
            End If
        End Get
    End Property

#Region " Profile Properties "
    ''' <summary>
    ''' The user's first name
    ''' </summary>
    Public Property FirstName() As String
        Get
            Return mFirstName
        End Get
        Set(ByVal value As String)
            mFirstName = value
        End Set
    End Property
    ''' <summary>
    ''' The user's last name
    ''' </summary>
    Public Property LastName() As String
        Get
            Return mLastName
        End Get
        Set(ByVal value As String)
            mLastName = value
        End Set
    End Property
    ''' <summary>
    ''' The user's full name
    ''' </summary>
    Public ReadOnly Property FullName() As String
        Get
            Return Me.mFirstName + " " + Me.mLastName
        End Get
    End Property
    ''' <summary>
    ''' The user's title
    ''' </summary>
    Public Property OccupationalTitle() As String
        Get
            Return mOccupationalTitle
        End Get
        Set(ByVal value As String)
            mOccupationalTitle = value
        End Set
    End Property
    ''' <summary>
    ''' The user's facility
    ''' </summary>
    Public Property Facility() As String
        Get
            Return mFacility
        End Get
        Set(ByVal value As String)
            mFacility = value
        End Set
    End Property
    ''' <summary>
    ''' The user's email address
    ''' </summary>
    Public Property EmailAddress() As String
        Get
            Return mEmailAddress
        End Get
        Set(ByVal value As String)
            mEmailAddress = value
        End Set
    End Property
    ''' <summary>
    ''' The user's phone number
    ''' </summary>
    Public Property PhoneNumber() As String
        Get
            Return mPhonenumber
        End Get
        Set(ByVal value As String)
            mPhonenumber = value
        End Set
    End Property
    ''' <summary>
    ''' The user's city
    ''' </summary>
    Public Property City() As String
        Get
            Return mCity
        End Get
        Set(ByVal value As String)
            mCity = value
        End Set
    End Property
    ''' <summary>
    ''' The user's state
    ''' </summary>
    Public Property State() As String
        Get
            Return mState
        End Get
        Set(ByVal value As String)
            mState = value
        End Set
    End Property
#End Region

#End Region

#Region " Constructors "
    ''' <summary>
    ''' Default constructor
    ''' </summary>
    Public Sub New()
    End Sub

    Protected Sub New(ByVal userName As String)
        Me.New(userName, False)
    End Sub

    Protected Sub New(ByVal memberId As Integer)
        Dim rdr As IDataReader
        rdr = DAL.SelectMember(memberId)
        Try
            If rdr.Read Then
                Me.LoadFromReader(rdr)
            End If
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try
    End Sub

    Protected Sub New(ByVal userName As String, ByVal isNTLoginName As Boolean)
        Dim rdr As IDataReader
        If isNTLoginName Then
            rdr = DAL.SelectNTMember(userName)
        Else
            rdr = DAL.SelectMember(userName)
        End If

        Try
            If rdr.Read Then
                Me.LoadFromReader(rdr)
            End If
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try
    End Sub

    Friend Sub New(ByVal rdr As IDataReader)
        Me.LoadFromReader(rdr)
    End Sub

    Protected Sub LoadFromReader(ByVal rdr As IDataReader)
        If rdr Is Nothing OrElse rdr.IsClosed Then
            Throw New ArgumentException("DataReader is NULL or Closed.", "rdr")
        End If
        Me.mMemberId = NRC.Data.DBNull.GetInteger(rdr("Member_id"))
        Me.mOrgUnitId = NRC.Data.DBNull.GetInteger(rdr("OrgUnit_id"))
        Me.mCreatorMemberId = NRC.Data.DBNull.GetInteger(rdr("CreatorMember_id"))
        Me.mDateCreated = NRC.Data.DBNull.GetDate(rdr("datCreated"))
        Me.mLastLoginDate = NRC.Data.DBNull.GetDate(rdr("datLastLogin"))
        Me.mDateLocked = NRC.Data.DBNull.GetDate(rdr("datLocked"))
        Me.mDateRetired = NRC.Data.DBNull.GetDate(rdr("datRetired"))
        Me.mUserName = NRC.Data.DBNull.GetString(rdr("strMember_nm"))
        Me.mNTLoginName = NRC.Data.DBNull.GetString(rdr("NTLogin_nm"))
        Me.mPasswordHash = NRC.Data.DBNull.GetString(rdr("strPassword"))
        Me.mLastPasswordChangeDate = NRC.Data.DBNull.GetDate(rdr("datPasswordChanged"))
        Me.mSecretQuestion = NRC.Data.DBNull.GetString(rdr("strHint"))
        Me.mSecretAnswerHash = NRC.Data.DBNull.GetString(rdr("strHintAnswer"))
        Me.mPasswordChangeInterval = NRC.Data.DBNull.GetInteger(rdr("DaysTilPasswordExpires"))
        Me.mMemberType = CType(NRC.Data.DBNull.GetInteger(rdr("MemberType_id")), MemberTypeEnum)
        Me.mPasswordSalt = NRC.Data.DBNull.GetString(rdr("SaltValue"))
        Me.mEmailAddress = NRC.Data.DBNull.GetString(rdr("strEmail"))
        Me.mFirstName = NRC.Data.DBNull.GetString(rdr("strFName"))
        Me.mLastName = NRC.Data.DBNull.GetString(rdr("strLName"))
        Me.mOccupationalTitle = NRC.Data.DBNull.GetString(rdr("strTitle"))
        Me.mPhonenumber = NRC.Data.DBNull.GetString(rdr("strPhone"))
        Me.mCity = NRC.Data.DBNull.GetString(rdr("strCity"))
        Me.mState = NRC.Data.DBNull.GetString(rdr("strState"))
        Me.mFacility = NRC.Data.DBNull.GetString(rdr("strFacility_nm"))
    End Sub
#End Region

#Region " Public Shared Members "
    ''' <summary>
    ''' Verifies that a user name and password are correct for the user account
    ''' </summary>
    ''' <remarks>Returns true if the user name and password password match
    ''' Returns false otherwise</remarks>
    ''' <param name="userName">The account user name</param>
    ''' <param name="password">The user's password</param>
    Public Shared Function Authenticate(ByVal userName As String, ByVal password As String) As Boolean
        Return Authenticate(userName, password, Nothing)
    End Function

    ''' <summary>
    ''' Verifies that a user name and password are correct for the user account
    ''' </summary>
    ''' <remarks>Returns true if the user name and password password match
    ''' Returns false otherwise</remarks>
    ''' <param name="userName">The account user name</param>
    ''' <param name="password">The user's password</param>
    Public Shared Function Authenticate(ByVal userName As String, ByVal password As String, ByRef memberObject As Member) As Boolean
        If userName Is Nothing OrElse userName = "" Then
            Throw New ArgumentNullException("userName")
        End If
        If password Is Nothing OrElse password = "" Then
            Throw New ArgumentNullException("password")
        End If

        Dim mbr As Member = Member.GetMember(userName)
        If mbr Is Nothing Then
            Return False
        Else
            memberObject = mbr
            Return (Not mbr.IsAccountLocked AndAlso mbr.VerifyPassword(password))
        End If
    End Function

    Public Shared Function CreateNewMember(ByVal creatorMemberId As Integer, ByVal orgUnitId As Integer, ByVal userName As String, ByVal eMailAddress As String, ByVal memberType As MemberTypeEnum, ByVal sendEmail As Boolean) As Member
        Return CreateNewMember(creatorMemberId, orgUnitId, userName, eMailAddress, memberType, sendEmail, PasswordHelper.GeneratePassword)
    End Function
    Public Shared Function CreateNewMember(ByVal creatorMemberId As Integer, ByVal orgUnitId As Integer, ByVal userName As String, ByVal eMailAddress As String, ByVal memberType As MemberTypeEnum) As Member
        Return CreateNewMember(creatorMemberId, orgUnitId, userName, eMailAddress, memberType, True, PasswordHelper.GeneratePassword)
    End Function
    ''' <summary>
    ''' Creates a new user account
    ''' </summary>
    ''' <param name="orgUnitId">The ID of the organizational unit that the new user will belong to</param>
    ''' <param name="userName">The User Name of the new account</param>
    ''' <param name="eMailAddress">The e-mail address of the new user</param>
    ''' <param name="memberType">The type of user account that should be created</param>
    Public Shared Function CreateNewMember(ByVal creatorMemberId As Integer, ByVal orgUnitId As Integer, ByVal userName As String, ByVal eMailAddress As String, ByVal memberType As MemberTypeEnum, ByVal sendEmail As Boolean, ByVal password As String) As Member
        If Not IsUserNameAvailable(userName) Then
            Throw New CreateUserAccountException(String.Format("The user account could not be created because the User Name '{0}' is not unique.", userName))
        End If
        Dim plainTextPassword As String = password
        Dim passwordSalt As String = PasswordHelper.GenerateSalt()
        Dim passwordHash As String = PasswordHelper.HashPassword(plainTextPassword, passwordSalt)
        DAL.InsertMember(creatorMemberId, orgUnitId, userName, eMailAddress, passwordHash, passwordSalt, memberType)
        Dim usr As New Member(userName)
        If sendEmail Then
            usr.EmailPasswordToUser(plainTextPassword, False)
        End If
        Return usr
    End Function

    ''' <summary>
    ''' Deletes a user account from the database
    ''' </summary>
    ''' <param name="userName">The User Name of the account to be deleted</param>
    Public Shared Sub DeleteMember(ByVal memberId As Integer, ByVal authorMemberId As Integer)
        DAL.RetireMember(memberId, authorMemberId)
    End Sub

    Public Shared Sub DeleteMember(ByVal memberId As Integer, ByVal retireDate As Date, ByVal authorMemberId As Integer)
        DAL.RetireMember(memberId, retireDate, authorMemberId)
    End Sub

    ''' <summary>
    ''' Checks if a particular string is available for use as a User Name
    ''' </summary>
    Public Shared Function IsUserNameAvailable(ByVal userName As String) As Boolean
        Return Not DAL.UserNameExists(userName)
    End Function

    ''' <summary>
    ''' Returns an instance of Member for the specified User Name
    ''' </summary>
    ''' <param name="userName">The User Name for the member that should be retrieved</param>
    Public Shared Function GetMember(ByVal userName As String) As Member
        Dim mbr As New Member(userName)
        If mbr.MemberId <= 0 Then
            Return Nothing
        Else
            Return mbr
        End If
    End Function






    ''' <summary>
    ''' Returns an instance of Member for the specified memberID
    ''' </summary>
    ''' <param name="userName">The User Name for the member that should be retrieved</param>
    Public Shared Function GetMember(ByVal memberId As Integer) As Member
        Dim mbr As New Member(memberId)
        If mbr.MemberId <= 0 Then
            Return Nothing
        Else
            Return mbr
        End If
    End Function

    ''' <summary>
    ''' Returns an instance of Member for the specified NT Login User Name
    ''' </summary>
    ''' <param name="userName">The User Name for the member that should be retrieved</param>
    Public Shared Function GetNTLoginMember(ByVal NTLogin As String) As Member
        'Dim rdr As IDataReader = DAL.SelectNTMember(NTLogin)
        ''Dim mbr As Member = DirectCast(NRC.Data.CBO.FillObject(rdr, GetType(Member)), Member)
        'Dim mbr As Member = DirectCast(Populator.FillObject(rdr, GetType(Member)), Member)

        'Return mbr
        Dim mbr As New Member
        Dim rdr As IDataReader = DAL.SelectNTMember(NTLogin)
        Try
            If rdr.Read Then
                mbr.LoadFromReader(rdr)
            End If
        Finally
            If Not rdr Is Nothing AndAlso Not rdr.IsClosed Then
                rdr.Dispose()
            End If
        End Try

        If mbr.MemberId <= 0 Then
            Return Nothing
        Else
            Return mbr
        End If
    End Function

    Public Shared Function IsStrongPassword(ByVal password As String) As Boolean
        Return PasswordHelper.IsStrongPassword(password)
    End Function
    Public Shared Function IsValidUserName(ByVal userName As String) As Boolean
        If userName.IndexOf(" ") >= 0 Then
            Return False
        End If

        Return True
    End Function


    Public Shared Function SendUserLoginHelp(ByVal emailAddress As String) As Boolean

        ''' 08/24/2008 SK Get a collection of usernames associated with the provided email address
        Dim otherUsernames As System.Collections.ArrayList = GetAllOtherUserNames(emailAddress)
        If otherUsernames.Count < 1 Then ' email address invalid
            Return False
        ElseIf otherUsernames.Count > 1 Then ' multiple users found
            SendUserListToEmail(emailAddress, EmailFormatter.GetUserListEmail(otherUsernames))
        Else 'only 1 user found
            SendPasswordResetToUser(otherUsernames(0).ToString())
        End If
        Return True

    End Function

    Public Shared Function SendPasswordResetToUser(ByVal userName As String) As Boolean

        Dim tempMember As Member = Member.GetMember(userName)
        If Not tempMember Is Nothing Then
            tempMember.ResetPassword(True, tempMember.MemberId)

            Return True
        End If

        Return False

    End Function


    ''' <summary>Emails the user a listing of their NRC accounts to their email
    ''' address</summary>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK - 08/24/2008 - Initial Creation</revision>
    Public Shared Function SendUserListToEmail(ByVal emailAddress As String, ByVal emailBody As String) As Boolean

        'Create Initial Mail Object, with Body Msg
        Dim mail As New System.Web.Mail.MailMessage
        mail.To = emailAddress
        mail.Bcc = AppConfig.Instance.MailFromAccount 'BCC logonsupport
        mail.Subject = "NRC Picker My Solutions Log On Information"
        mail.From = AppConfig.Instance.MailFromAccount
        mail.BodyFormat = System.Web.Mail.MailFormat.Html
        mail.Body = emailBody

        System.Web.Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer
        System.Web.Mail.SmtpMail.Send(mail)
        Return True

    End Function

#End Region

#Region " Public Members "


    

    Public Sub ResetPassword(ByVal sendEmail As Boolean, ByVal authorMemberId As Integer)
        ResetPassword(sendEmail, authorMemberId, PasswordHelper.GeneratePassword())
    End Sub


    ''' <summary>
    ''' Resets the user's password to random value
    ''' </summary>
    ''' <param name="sendEmail">Indicates if an email should be sent to the user indicating the new password.</param>
    Public Sub ResetPassword(ByVal sendEmail As Boolean, ByVal authorMemberId As Integer, ByVal password As String)
        'Generate a random password 
        Dim pass As String = password

        'Hash the password
        Me.mPasswordHash = PasswordHelper.HashPassword(pass, mPasswordSalt)

        'Store password
        DAL.UpdatePassword(mMemberId, mPasswordHash, True, authorMemberId)

        'Send email
        If sendEmail Then
            EmailPasswordToUser(pass, True)
        End If
    End Sub

    ''' <summary>
    ''' Resets the user's password to random value
    ''' </summary>
    ''' <param name="sendEmail">Indicates if an email should be sent to the user indicating the new password.</param>
    Public Function ChangePassword(ByVal newPassword As String, ByVal authorMemberId As Integer) As Boolean
        'Hash the password
        Dim passHash As String = PasswordHelper.HashPassword(newPassword, mPasswordSalt)

        'Try to change the password.  Could return false if the password has already been used
        Dim success As Boolean = DAL.UpdatePassword(mMemberId, passHash, False, authorMemberId)

        'If successful then store the new password hash in this object
        If success Then
            Me.mPasswordHash = passHash
        End If

        Return success
    End Function

    ''' <summary>
    ''' Stores a secret question for the user
    ''' </summary>
    ''' <param name="secretQuestionId">The ID of the secret question that the user has chosen</param>
    ''' <param name="secretAnswer">The plain-text answer that the user provided for the secret question</param>
    Public Sub SetSecretQuestion(ByVal secretQuestionId As Integer, ByVal secretAnswer As String, ByVal authorMemberId As Integer)
        For Each q As SecretQuestion In NRC.NRCAuthLib.SecretQuestion.GetSecretQuestions
            If q.SecretQuestionId = secretQuestionId Then
                Me.mSecretQuestion = q.SecretQuestionText
            End If
        Next
        Me.mSecretAnswerHash = PasswordHelper.HashString(secretAnswer)
        DAL.UpdateSecretQuestion(mMemberId, secretQuestionId, mSecretAnswerHash, authorMemberId)
    End Sub

    ''' <summary>
    ''' Persists all of the user profile information to the data store
    ''' </summary>
    Public Sub UpdateProfile(ByVal authorMemberId As Integer)
        DAL.UpdateProfile(mMemberId, mFirstName, mLastName, mEmailAddress, mFacility, mOccupationalTitle, mPhonenumber, mCity, mState, authorMemberId)
    End Sub

    Public Sub UpdateRetireDate(ByVal authorMemberId As Integer)
        DAL.UpdateRetireDate(mMemberId, Me.mDateRetired, authorMemberId)
    End Sub

    Public Sub UpdateNTLogin()
        DAL.UpdateNTLogin(mMemberId, mNTLoginName)
    End Sub

    Public Sub ChangeMemberType(ByVal memberType As MemberTypeEnum, ByVal authorMemberId As Integer)
        DAL.UpdateMemberType(mMemberId, memberType, authorMemberId)
    End Sub

    ''' <summary>
    ''' Verifies that a particular string matches the stored secret answer
    ''' </summary>
    ''' <param name="answer">The plain-text answer to be verified</param>
    Public Function VerifySecretAnswer(ByVal answer As String) As Boolean
        Return (PasswordHelper.HashString(answer) = mSecretAnswerHash)
    End Function

    ''' <summary>
    ''' Verifies that a string matches the stored password
    ''' </summary>
    ''' <param name="password">The plain-text password to verify</param>
    Public Function VerifyPassword(ByVal password As String) As Boolean
        Return (PasswordHelper.HashPassword(password, mPasswordSalt) = mPasswordHash)
    End Function

    '''' <summary>
    '''' Returns true if the user has access to any privileges within the specified application
    '''' </summary>
    '''' <param name="applicationName">The name of the application</param>
    'Public Function HasPrivilege(ByVal applicationName As String) As Boolean
    '    Return (Not Applications(applicationName) Is Nothing)
    'End Function

    '''' <summary>
    '''' Return true if the user has been granted a particular privilege to a given application
    '''' </summary>
    '''' <param name="applicationName">The name of the application</param>
    '''' <param name="privilegeName">The name of the privilege</param>
    'Public Function HasPrivilege(ByVal applicationName As String, ByVal privilegeName As String) As Boolean
    '    Dim app As Application = Applications(applicationName)
    '    If app Is Nothing Then
    '        Return False
    '    Else
    '        If Not app.Privileges(privilegeName) Is Nothing Then
    '            Return True
    '        End If
    '    End If

    '    Return False
    'End Function

    Public Function HasAccessToApplication(ByVal applicationName As String) As Boolean
        For Each app As Application In MemberApplications
            If applicationName.ToLower = app.Name.ToLower Then
                Return True
            End If
        Next
        For Each grp As Group In Groups
            If grp.HasPrivilege(applicationName) Then
                Return True
            End If
        Next

        Return False
    End Function

    ''' <summary>
    ''' Return true if the user has been granted a particular privilege to a given application
    ''' </summary>
    ''' <param name="applicationName">The name of the application</param>
    ''' <param name="privilegeName">The name of the privilege</param>
    Public Function HasMemberPrivilege(ByVal applicationName As String, ByVal privilegeName As String) As Boolean
        Dim app As Application = MemberApplications(applicationName)
        If app Is Nothing Then
            Return False
        Else
            If Not app.Privileges(privilegeName) Is Nothing Then
                Return True
            End If
        End If

        Return False
    End Function

    Public Sub GrantMemberPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal dateRevoked As Date, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToMember(orgUnitPrivilegeId, mMemberId, dateRevoked, authorMemberId)
        'Refresh application list
        Me.mApplications = Nothing
    End Sub

    Public Sub GrantMemberPrivilege(ByVal orgUnitPrivilegeId As Integer, ByVal authorMemberId As Integer)
        'Grant the privilege
        Privilege.GrantPrivilegeToMember(orgUnitPrivilegeId, mMemberId, authorMemberId)
        'Refresh application list
        Me.mApplications = Nothing
    End Sub

    Public Sub RevokeMemberPrivilege(ByVal memberPrivilegeId As Integer, ByVal authorMemberId As Integer)
        'Revoke the privilege
        Privilege.RevokePrivilegeFromMember(memberPrivilegeId, authorMemberId)

        'Refresh the application list
        Me.mApplications = Nothing
    End Sub

    ''' <summary>
    ''' Returns a string indicating all of the users roles for Forms based authentication
    ''' </summary>
    Public Function GetWebRoles() As String
        Return GetWebRoles(-1)
    End Function


    ''' <summary>
    ''' Returns a string indicating all of the users roles for Forms based authentication
    ''' </summary>
    Public Function GetWebRoles(ByVal selectedGroupId As Integer) As String
        Dim roles As String = ""

        'Get the initial role type
        Select Case Me.mMemberType
            Case MemberTypeEnum.NRC_Admin
                roles = "NRCAdmin"
            Case MemberTypeEnum.Administrator
                roles = "Admin"
            Case MemberTypeEnum.Super_User
                roles = "SuperUser"
            Case Else
                roles = "User"
        End Select

        'Determine if this is an NRC user or not
        If OrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.NrcOU OrElse OrgUnit.OrgUnitType = OrgUnit.OrgUnitTypeEnum.TeamOU Then
            roles &= ",NRCUser"
        End If

        'Make a list of applications and admin privileges they have in any of their groups
        Dim roleList As New ArrayList
        Dim roleName As String
        If selectedGroupId = -1 Then
            For Each grp As Group In Groups
                For Each app As Application In grp.Applications
                    If Not app.IsInternalOnly Then
                        roleName = String.Format("{0}User", app.Name.Replace(" ", ""))
                        If Not roleList.Contains(roleName) Then
                            roleList.Add(roleName)
                        End If
                        For Each priv As Privilege In app.Privileges
                            If priv.Name.ToLower.IndexOf("admin") >= 0 Then
                                roleName = priv.Name.Replace(" ", "")
                                If Not roleList.Contains(roleName) Then
                                    roleList.Add(roleName)
                                End If
                            End If
                        Next
                    End If
                Next
            Next
        Else
            For Each app As Application In Group.GetGroup(selectedGroupId).Applications
                If Not app.IsInternalOnly Then
                    roleName = String.Format("{0}User", app.Name.Replace(" ", ""))
                    If Not roleList.Contains(roleName) Then
                        roleList.Add(roleName)
                    End If
                    For Each priv As Privilege In app.Privileges
                        If priv.Name.ToLower.IndexOf("admin") >= 0 Then
                            roleName = priv.Name.Replace(" ", "")
                            If Not roleList.Contains(roleName) Then
                                roleList.Add(roleName)
                            End If
                        End If
                    Next
                End If
            Next
        End If

        'Now make a list of the member level application roles
        For Each app As Application In Me.MemberApplications
            If Not app.IsInternalOnly Then
                roleName = String.Format("{0}User", app.Name.Replace(" ", ""))
                If Not roleList.Contains(roleName) Then
                    roleList.Add(roleName)
                End If
                For Each priv As Privilege In app.Privileges
                    If priv.Name.ToLower.IndexOf("admin") >= 0 Then
                        roleName = priv.Name.Replace(" ", "")
                        If Not roleList.Contains(roleName) Then
                            roleList.Add(roleName)
                        End If
                    End If
                Next
            End If
        Next

        'Now append them all to the role list
        For Each roleName In roleList
            roles = String.Format("{0},{1}", roles, roleName)
        Next

        'Make sure we didn't end with a ","
        If roles.EndsWith(",") Then
            roles = roles.Substring(0, roles.Length - 1)
        End If

        Return roles
    End Function

    Public Function IsInGroup(ByVal groupName As String) As Boolean
        Return (Not Groups.FindByName(groupName) Is Nothing)
    End Function

    Public Sub AddToGroup(ByVal groupId As Integer, ByVal authorMemberId As Integer)
        Dim grp As Group = Group.GetGroup(groupId)
        grp.AddMemberToGroup(mMemberId, authorMemberId)
        Groups.Add(grp)
    End Sub
#End Region

#Region " Private Functions "

    ''' <summary>
    ''' Sends a password notification email to the user
    ''' </summary>
    Private Sub EmailPasswordToUser(ByVal plainTextPassword As String, ByVal isReset As Boolean)
        Dim mail As New System.Web.Mail.MailMessage
        Dim url As String = AppConfig.Instance.WWWNRCPickerUrl & "Pages/MySolutions.aspx"

        mail.To = Me.mEmailAddress
        mail.Bcc = AppConfig.Instance.MailFromAccount
        mail.Subject = "NRC Picker My Solutions Log On Information"
        mail.From = AppConfig.Instance.MailFromAccount
        mail.BodyFormat = System.Web.Mail.MailFormat.Html
        If isReset Then
            mail.Body = EmailFormatter.GetResetPasswordEmail(mUserName, plainTextPassword, url)
        Else
            mail.Body = EmailFormatter.GetNewAccountEmail(mUserName, plainTextPassword, url)
        End If
        System.Web.Mail.SmtpMail.SmtpServer = AppConfig.Instance.SMTPServer

        Try
            System.Web.Mail.SmtpMail.Send(mail)
        Catch ex As Exception
            Try
                SecurityLog.LogWebException(mUserName, System.Web.HttpContext.Current.Session.SessionID, "My Account", System.Web.HttpContext.Current.Request.Url.ToString, FormsAuth.PageName, True, "Resending email: " & ex.ToString, ex.GetType.ToString, ex.StackTrace)
            Catch
            End Try
            Threading.Thread.Sleep(3000)
            System.Web.Mail.SmtpMail.Send(mail)
        End Try
    End Sub
    ''' <summary>Returns a collection of usernames associated with the provided email
    ''' address</summary>
    ''' <author>Steve Kennedy</author>
    ''' <revision>SK - Initial Creation</revision>
    Private Shared Function GetAllOtherUserNames(ByVal emailAddress As String) As Collections.ArrayList

        Dim UserNames As New Collections.ArrayList
        For Each tempmember As Member In MemberCollection.GetMembersByEmailAddress(emailAddress)
            UserNames.Add(tempmember.UserName)
        Next
        Return UserNames

    End Function

#End Region

        'Temporary code for hashing passwords already in the database
        'Public Sub HashCurrentPassword()
        '    If mPasswordSalt = "" Then
        '        mPasswordSalt = PasswordHelper.GenerateSalt()
        '        mPasswordHash = PasswordHelper.HashPassword(mPasswordHash, mPasswordSalt)
        '        DAL.SetPassword(mMemberId, mPasswordHash, mPasswordSalt)
        '    End If
        'End Sub

    Public ReadOnly Property AuthenticationType() As String Implements System.Security.Principal.IIdentity.AuthenticationType
        Get
            Return "NRCAuth"
        End Get
    End Property

    Public ReadOnly Property IsAuthenticated() As Boolean Implements System.Security.Principal.IIdentity.IsAuthenticated
        Get
            Return True
        End Get
    End Property

    Public ReadOnly Property Name() As String Implements System.Security.Principal.IIdentity.Name
        Get
            Return mUserName
        End Get
    End Property
End Class

