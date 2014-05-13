Imports System.Web
Imports System.Web.Security

''' <summary>
''' A helper class for implementing ASP.NET forms authentication
''' </summary>
Public Class FormsAuth

#Region " NRCPrincipal Class "
    
#End Region

#Region " Public Enumerations "
    'All of the posible authentication results
    Public Enum AuthResult As Short
        AccountLocked = -4
        UnauthorizedRequest = -3
        InvalidIPAddress = -2
        InvalidUserOrPassword = -1
        Success = 1
    End Enum

    <Flags()> _
    Public Enum ApplicationEnum
        eReports = 1
        eComments = 2
        eToolKit = 4
        MyTeam = 8
        ProjectUpdates = 16
        MyAccount = 32
    End Enum

#End Region

#Region " Private Members "
    Private Const TEMP_COOKIE_NAME As String = "NRCTempTkt"
    Private Const GROUP_COOKIE_NAME As String = "GroupAccount"
#End Region

#Region " Shared Properties "
    Public Shared ReadOnly Property IsInternalUser() As Boolean
        Get
            Dim strIPAddr As String = UserIP
            Return (strIPAddr.StartsWith("10.10.") Or strIPAddr.StartsWith("127.0.0.1"))
        End Get
    End Property

    Public Shared ReadOnly Property PageName() As String
        Get
            Dim page As String = HttpContext.Current.Request.Path
            Return page.Remove(0, page.LastIndexOf(Convert.ToChar("/")) + 1)
        End Get
    End Property

    Public Shared ReadOnly Property PageNameAndQuery() As String
        Get
            Return PageName & HttpContext.Current.Request.Url.Query
        End Get
    End Property

    Private Shared ReadOnly Property Session() As SessionState.HttpSessionState
        Get
            Return HttpContext.Current.Session
        End Get
    End Property

    Private Shared ReadOnly Property Request() As HttpRequest
        Get
            Return HttpContext.Current.Request
        End Get
    End Property

    Private Shared ReadOnly Property Response() As HttpResponse
        Get
            Return HttpContext.Current.Response
        End Get
    End Property

    Private Shared ReadOnly Property UserIP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("REMOTE_ADDR")
        End Get
    End Property

    'Public Shared Function IsExpiredSession() As Boolean
    '    Return IsExpiredSession(Nothing)
    'End Function
#End Region

    'To determine if a session has expired we can check for the existence
    'of the auth cookie.  If it exists, then this user has signed in before
    'in the lifetime of this browser.  This would mean that they are back
    'to the sign on screen because they have requested a resource for which
    'they do not have privileges OR the authentication ticket has expired.
    'The auth ticket is intentionally set to expire with the session so
    'that both the user and the application can be aware of expiring sessions
    Public Shared Function IsExpiredSession(ByRef ticket As FormsAuthenticationTicket) As Boolean
        Dim authTicket As FormsAuthenticationTicket

        Try
            'Check for the exisitence of the authentication cookie
            If Not Request.Headers("Cookie") Is Nothing AndAlso Request.Headers("Cookie").IndexOf(FormsAuthentication.FormsCookieName) >= 0 Then
                'Find the auth cookie
                Dim cookies() As String = Request.Headers("Cookie").Split(Char.Parse(";"))
                Dim cookieParts() As String
                For Each cookie As String In cookies
                    cookieParts = cookie.Split(Char.Parse("="))
                    If cookieParts(0).Trim = FormsAuthentication.FormsCookieName Then

                        'Get the auth ticket
                        authTicket = FormsAuthentication.Decrypt(cookieParts(1))
                        ticket = authTicket

                        'Check if it is retired
                        Return authTicket.Expired
                    End If
                Next
            End If

            Return False
        Catch ex As System.Security.Cryptography.CryptographicException
            'Catch crypto exceptions and treat this as a brand new sign in
            'This can happen if encryption key is not static
            Session.Clear()
            Session.Abandon()
            Response.Cookies("ASP.NET_SessionId").Value = ""
            Response.Cookies("NRCWebAuth").Value = ""
            FormsAuthentication.SignOut()
            'Redirect so we can try again
            Response.Redirect(Request.Url.ToString)
            Return False
        End Try
    End Function

    Private Shared ReadOnly Property Browser() As String
        Get
            Return Request.Browser.Browser
        End Get
    End Property
    Public Shared Function SignIn(ByVal userName As String, ByVal password As String, ByVal applicationName As String) As AuthResult
        Return SignIn(userName, password, applicationName, Nothing)
    End Function
    Public Shared Function SignIn(ByVal userName As String, ByVal password As String, ByVal applicationName As String, ByRef memberObject As Member) As AuthResult
        Dim user As Member
        Dim result As Short

        ' remove invalid characters from login name
        'userName = RemoveInvalidChars(userName)

        'Try to authenticate username/password
        If Not Member.Authenticate(userName, password, user) Then
            SecurityLog.LogSignInFailure(userName, Session.SessionID, Request.ServerVariables("REMOTE_ADDR"), Request.Browser.Browser, Request.Browser.Version, Request.UserAgent, applicationName, Request.Url.Host, Environment.MachineName, PageNameAndQuery)
            If Not user Is Nothing AndAlso user.IsAccountLocked Then
                Return AuthResult.AccountLocked
            Else
                Return AuthResult.InvalidUserOrPassword
            End If
        End If

        If user.IsAccountLocked Then
            SecurityLog.LogWebEvent(user.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Account Locked Login Failure", userName)
            Return AuthResult.AccountLocked
        End If

        If Not user.HasAccessToApplication(applicationName) Then
            SecurityLog.LogWebEvent(user.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Application Access Denied", userName)
            Return AuthResult.UnauthorizedRequest
        End If

        If Not IsInternalUser AndAlso Not user.OrgUnit.IPAddressFilter = "" Then
            If user.OrgUnit.IPAddressFilter.IndexOf(UserIP) < 0 Then
                SecurityLog.LogWebEvent(user.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Invalid IP Address", String.Format("app:{0} u:{1}", applicationName, userName))
                Return AuthResult.InvalidIPAddress
            End If
        End If

        memberObject = user
        SecurityLog.LogSignInSuccess(userName, Session.SessionID, Request.ServerVariables("REMOTE_ADDR"), Request.Browser.Browser, Request.Browser.Version, Request.UserAgent, applicationName, Request.Url.Host, Environment.MachineName, PageNameAndQuery)
        Return AuthResult.Success
    End Function

    Public Shared Function Impersonate(ByVal impersonator As Member, ByVal userName As String, ByVal applicationName As String, ByRef memberObject As Member) As AuthResult
        Dim user As Member
        Dim result As Short

        'Try to authenticate username/password
        user = Member.GetMember(userName)
        If user Is Nothing Then
            SecurityLog.LogWebEvent(impersonator.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Impersonation Failure", userName)
            Return AuthResult.InvalidUserOrPassword
        End If
        If user.MemberType = Member.MemberTypeEnum.Registration_Account Then
            SecurityLog.LogWebEvent(impersonator.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Impersonation Failure", userName)
            Return AuthResult.InvalidUserOrPassword
        End If
        If impersonator.MemberType = Member.MemberTypeEnum.Super_User And (user.MemberType = Member.MemberTypeEnum.NRC_Admin Or user.MemberType = Member.MemberTypeEnum.Administrator) Then
            SecurityLog.LogWebEvent(impersonator.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Impersonation Failure", userName)
            Return AuthResult.InvalidUserOrPassword
        End If
        If impersonator.MemberType = Member.MemberTypeEnum.Administrator And user.MemberType = Member.MemberTypeEnum.NRC_Admin Then
            SecurityLog.LogWebEvent(impersonator.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Impersonation Failure", userName)
            Return AuthResult.InvalidUserOrPassword
        End If

        memberObject = user

        Session.Clear()
        Session.Abandon()
        System.Web.Security.FormsAuthentication.SignOut()

        SecurityLog.LogWebEvent(impersonator.UserName, Session.SessionID, applicationName, PageNameAndQuery, "Impersonation Success", String.Format("{0} impersonating {1}", impersonator.UserName, userName))
        FormsAuth.SetAuthCookie(user)
        SecurityLog.LogSignInSuccess(userName, Session.SessionID, Request.ServerVariables("REMOTE_ADDR"), Request.Browser.Browser, Request.Browser.Version, Request.UserAgent, applicationName, Request.Url.Host, Environment.MachineName, PageNameAndQuery)
        Return AuthResult.Success
    End Function


    Public Shared Sub AttachUserPrincipal()
        If Not HttpContext.Current.User Is Nothing Then
            If HttpContext.Current.User.Identity.IsAuthenticated Then
                If TypeOf (HttpContext.Current.User.Identity) Is FormsIdentity Then
                    Dim ID As FormsIdentity = DirectCast(HttpContext.Current.User.Identity, FormsIdentity)
                    Dim AuthTicket As FormsAuthenticationTicket = ID.Ticket
                    Dim ud As NRCPrincipal = NRCPrincipal.Deserialize(AuthTicket.UserData)
                    HttpContext.Current.User = ud
                End If
            End If
        End If
    End Sub

    'Public Shared Property CurrentUserData() As UserData
    '    Get
    '        If HttpContext.Current Is Nothing Then
    '            Return Nothing
    '        End If
    '        If HttpContext.Current.Items("UserData") Is Nothing Then
    '            Return Nothing
    '        End If
    '        Return DirectCast(HttpContext.Current.Items("UserData"), UserData)
    '    End Get
    '    Set(ByVal Value As UserData)
    '        If HttpContext.Current.Items("UserData") Is Nothing Then
    '            HttpContext.Current.Items.Remove("UserData")
    '        End If
    '        HttpContext.Current.Items.Add("UserData", Value)
    '    End Set
    'End Property

    Public Shared Sub SetAuthCookie(ByVal user As Member)
        Dim authCookie As HttpCookie
        Dim authTicket As FormsAuthenticationTicket
        Dim ud As New NRCPrincipal(user)

        'Create the Authentication Ticket/Cookie
        authCookie = FormsAuthentication.GetAuthCookie(user.UserName, False)
        authTicket = FormsAuthentication.Decrypt(authCookie.Value)
        Dim newAuthTicket As New FormsAuthenticationTicket(authTicket.Version, authTicket.Name, authTicket.IssueDate, authTicket.Expiration, authTicket.IsPersistent, ud.Serialize)
        authCookie.Value = FormsAuthentication.Encrypt(newAuthTicket)

        'Set the Auth Cookie
        HttpContext.Current.Response.Cookies.Add(authCookie)
    End Sub

    Friend Shared Sub ResetAuthCookie(ByVal principal As NRCPrincipal)
        Dim authCookie As HttpCookie = Request.Cookies(FormsAuthentication.FormsCookieName)
        Dim authTicket As FormsAuthenticationTicket

        'Create the Authentication Ticket/Cookie
        authTicket = FormsAuthentication.Decrypt(authCookie.Value)

        Dim newAuthTicket As New FormsAuthenticationTicket(authTicket.Version, authTicket.Name, authTicket.IssueDate, authTicket.Expiration, authTicket.IsPersistent, principal.Serialize)
        authCookie.Value = FormsAuthentication.Encrypt(newAuthTicket)

        'Set the Auth Cookie
        HttpContext.Current.Response.Cookies.Add(authCookie)
    End Sub

    Public Shared Sub SetTemporaryTicket(ByVal user As Member, ByVal destinationUrl As String)
        Dim authCookie As HttpCookie
        Dim authTicket As FormsAuthenticationTicket
        Dim tempTicket As FormsAuthenticationTicket
        Dim tempCookie As HttpCookie

        'Create the Authentication Ticket/Cookie
        authCookie = FormsAuthentication.GetAuthCookie(user.UserName, False)
        authTicket = FormsAuthentication.Decrypt(authCookie.Value)
        tempTicket = New FormsAuthenticationTicket(authTicket.Version, authTicket.Name, authTicket.IssueDate, authTicket.Expiration, authTicket.IsPersistent, destinationUrl)
        tempCookie = New HttpCookie(TEMP_COOKIE_NAME)
        tempCookie.Value = FormsAuthentication.Encrypt(tempTicket)

        'Set the Temp Cookie
        HttpContext.Current.Response.Cookies.Add(tempCookie)
    End Sub

    Public Shared Function GetTemporaryTicket() As FormsAuthenticationTicket
        Dim tempTicket As FormsAuthenticationTicket
        Dim tempCookie As HttpCookie = Request.Cookies(TEMP_COOKIE_NAME)

        tempTicket = FormsAuthentication.Decrypt(tempCookie.Value)
        Return tempTicket
    End Function

    Public Shared Sub RemoveTemporaryTicket()
        'Response.Cookies(TEMP_COOKIE_NAME).Value = ""
        'Response.Cookies.Remove(TEMP_COOKIE_NAME)
    End Sub

    Public Shared Sub SignOut()
        SignOut("")
    End Sub
    Public Shared Sub SignOut(ByVal redirectUrl As String)
        Session.Clear()
        Session.Abandon()
        Response.Cookies(GROUP_COOKIE_NAME).Value = ""
        Response.Cookies("ASP.NET_SessionId").Value = ""
        System.Web.Security.FormsAuthentication.SignOut()
        If Not redirectUrl = "" Then
            Response.Redirect(redirectUrl)
        End If
    End Sub

    'Public Shared Function GetSelectedGroup() As Group
    '    Dim ud As UserData = CurrentUserData
    '    If ud Is Nothing Then
    '        Return Nothing
    '    End If
    '    If ud.SelectedGroupId = 0 Then
    '        Return Nothing
    '    End If
    '    Return Group.GetGroup(ud.SelectedGroupId)
    'End Function

    'Public Shared ReadOnly Property IsApplicationInitialized(ByVal app As ApplicationEnum) As Boolean
    '    Get
    '        Dim ud As UserData = CurrentUserData
    '        If ud Is Nothing Then
    '            Return False
    '        End If

    '        Return ud.IsInitialized(app)
    '    End Get
    'End Property

    'Public Shared Sub InitializeApplication(ByVal app As ApplicationEnum)
    '    Dim ud As NRCPrincipal = DirectCast(HttpContext.Current.User, NRCPrincipal)
    '    If Not ud Is Nothing Then
    '        ud.InitializeApplication(app)
    '        ResetAuthCookie(ud.SelectedGroupId, ud.GroupRoles, ud.InitFlags)
    '    End If
    'End Sub

    'Public Shared Function HasSelectedGroupChanged(ByVal oldGroupId As Integer) As Boolean
    '    Dim grp As NRCAuthLib.Group
    '    Dim ud As UserData = UserData.Deserialize(GROUP_COOKIE_NAME)
    '    If ud Is Nothing Then
    '        Return True
    '    ElseIf ud.SelectedGroupId < 0 Then
    '        Return True
    '    Else
    '        Return (Not ud.SelectedGroupId = oldGroupId)
    '    End If
    'End Function

    ' removes invalid characters from a string
    Private Shared Function RemoveInvalidChars(ByVal str As String) As String
        ' remove any invalid characters from the username and password
        Dim invalidChars() As String = {"&", "`", "'", """", "%"}            ' array of invalid characters, currently ampersand, backward tick, tick, double quote and percent sign
        For Each val As String In invalidChars
            str = str.Replace(val, "")
        Next
        Return str
    End Function

    '<Serializable()> _
    'Public Class UserData
    '    Private mUserRoles As String = ""
    '    Private mSelectedGroupId As Integer = 0
    '    Private mInitFlags As ApplicationEnum = 0
    '    Private mGroupRoles As String = ""

    '    Public Property UserRoles() As String
    '        Get
    '            Return mUserRoles
    '        End Get
    '        Set(ByVal Value As String)
    '            mUserRoles = Value
    '        End Set
    '    End Property

    '    Public Property GroupRoles() As String
    '        Get
    '            Return mGroupRoles
    '        End Get
    '        Set(ByVal Value As String)
    '            mGroupRoles = Value
    '        End Set
    '    End Property

    '    Public Property SelectedGroupId() As Integer
    '        Get
    '            Return mSelectedGroupId
    '        End Get
    '        Set(ByVal Value As Integer)
    '            mSelectedGroupId = Value
    '        End Set
    '    End Property

    '    Public ReadOnly Property HasSelectedGroup() As Boolean
    '        Get
    '            Return (Not mSelectedGroupId = 0)
    '        End Get
    '    End Property

    '    Public Property InitFlags() As ApplicationEnum
    '        Get
    '            Return mInitFlags
    '        End Get
    '        Set(ByVal Value As ApplicationEnum)
    '            mInitFlags = Value
    '        End Set
    '    End Property

    '    Friend Sub New()
    '    End Sub

    '    Public ReadOnly Property IsInitialized(ByVal app As ApplicationEnum) As Boolean
    '        Get
    '            Return ((mInitFlags And app) = app)
    '        End Get
    '    End Property

    '    Public Sub InitializeApplication(ByVal app As ApplicationEnum)
    '        mInitFlags = (mInitFlags Or app)
    '    End Sub

    '    Public Sub New(ByVal roles As String, ByVal groupId As Integer)
    '        Me.mUserRoles = roles
    '        Me.mSelectedGroupId = groupId
    '    End Sub

    '    Friend Function Serialize() As String
    '        Dim xml As String = "<UR>{0}</UR><GrpId>{1}</GrpId><Init>{2}</Init><GR>{3}</GR>"
    '        Return String.Format(xml, mUserRoles, mSelectedGroupId, CType(mInitFlags, Integer), mGroupRoles)
    '    End Function

    '    Friend Shared Function Deserialize(ByVal xml As String) As UserData
    '        Dim Ud As New UserData
    '        Dim regex As New System.Text.RegularExpressions.Regex("<UR>(.*)</UR><GrpId>(.*)</GrpId><Init>(.*)</Init><GR>(.*)</GR>", Text.RegularExpressions.RegexOptions.IgnoreCase)
    '        Dim match As System.Text.RegularExpressions.Match
    '        Try
    '            match = regex.Match(xml)
    '            Ud.mUserRoles = match.Groups(1).Value
    '            Ud.mSelectedGroupId = CType(match.Groups(2).Value, Integer)
    '            Ud.mInitFlags = CType(match.Groups(3).Value, ApplicationEnum)
    '            Ud.mGroupRoles = match.Groups(4).Value
    '        Catch ex As Exception
    '            Return Nothing
    '        End Try

    '        Return Ud
    '    End Function

    'End Class
End Class
