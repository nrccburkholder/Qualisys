Imports System.Web
Imports System.Web.Security

Public Class NRCPrincipal
    Implements System.Security.Principal.IPrincipal


#Region " Private Members "
    Private mMember As Member = Nothing
    Private mUserName As String
    Private mUserRoles As String = ""
    Private mSelectedGroupId As Integer = 0
    Private mInitFlags As FormsAuth.ApplicationEnum = 0
    Private mGroupRoles As String = ""
#End Region

#Region " Public Properties "
    Public ReadOnly Property UserRoles() As String
        Get
            Return mUserRoles
        End Get
    End Property

    Public ReadOnly Property GroupRoles() As String
        Get
            Return mGroupRoles
        End Get

    End Property

    Public Property SelectedGroupId() As Integer
        Get
            Return mSelectedGroupId
        End Get
        Set(ByVal Value As Integer)
            If Not mSelectedGroupId = Value Then
                mSelectedGroupId = Value
                mGroupRoles = mMember.GetWebRoles(mSelectedGroupId)
                mInitFlags = 0
                FormsAuth.ResetAuthCookie(Me)
            End If
        End Set
    End Property

    Public ReadOnly Property HasSelectedGroup() As Boolean
        Get
            Return (Not mSelectedGroupId = 0)
        End Get
    End Property

    Public Property InitFlags() As FormsAuth.ApplicationEnum
        Get
            Return mInitFlags
        End Get
        Set(ByVal Value As FormsAuth.ApplicationEnum)
            If Not mInitFlags = Value Then
                mInitFlags = Value
                FormsAuth.ResetAuthCookie(Me)
            End If
        End Set
    End Property

    Public ReadOnly Property IsInitialized(ByVal app As FormsAuth.ApplicationEnum) As Boolean
        Get
            Return ((mInitFlags And app) = app)
        End Get
    End Property

    Public ReadOnly Property Identity() As System.Security.Principal.IIdentity Implements System.Security.Principal.IPrincipal.Identity
        Get
            Return Me.Member
        End Get
    End Property

    Public ReadOnly Property [Member]() As Member
        Get
            If mMember Is Nothing Then
                Return CachedMember(mUserName)
            End If
            Return mMember
        End Get
    End Property

    Public ReadOnly Property SelectedGroup() As NRCAuthLib.Group
        Get
            If Not Me.HasSelectedGroup Then
                Return Nothing
            End If
            Dim grp As NRCAuthLib.Group = CachedGroup(mSelectedGroupId)
            Return grp
        End Get
    End Property

    Public Shared ReadOnly Property Current() As NRCPrincipal
        Get
            If Not HttpContext.Current.User Is Nothing Then
                If TypeOf HttpContext.Current.User Is NRCPrincipal Then
                    Return DirectCast(HttpContext.Current.User, NRCPrincipal)
                End If
            End If

            Return Nothing
        End Get
    End Property
#End Region

#Region " Private Properties "
    Private Shared ReadOnly Property CachedMember(ByVal userName As String) As Member
        Get
            If userName Is Nothing OrElse userName = "" Then
                Throw New ArgumentNullException("userName")
            End If
            Dim user As Member
            user = DirectCast(HttpContext.Current.Cache("Member" & userName.ToLower), Member)
            If user Is Nothing Then
                user = NRCAuthLib.Member.GetMember(userName)
                HttpContext.Current.Cache.Add("Member" & userName.ToLower, user, Nothing, DateTime.MaxValue, New TimeSpan(0, 10, 0), Caching.CacheItemPriority.AboveNormal, Nothing)
            End If
            Return user
        End Get
    End Property
    Private Shared ReadOnly Property CachedGroup(ByVal groupId As Integer) As Group
        Get
            If groupId = 0 Then
                Throw New ArgumentNullException("groupId")
            End If
            Dim grp As Group
            grp = DirectCast(HttpContext.Current.Cache("Group" & groupId), Group)
            If grp Is Nothing Then
                grp = Group.GetGroup(groupId)
                HttpContext.Current.Cache.Add("Group" & groupId, grp, Nothing, DateTime.MaxValue, New TimeSpan(0, 10, 0), Caching.CacheItemPriority.AboveNormal, Nothing)
            End If
            Return grp
        End Get
    End Property
#End Region

#Region " Constructors "

    Private Sub New()
    End Sub

    Public Sub New(ByVal user As Member)
        mMember = user
        mUserName = user.UserName

        'Get the roles
        mUserRoles = user.GetWebRoles
        mSelectedGroupId = 0
        mInitFlags = 0

        If Not user.HasAccessToMultipleGroups Then
            mSelectedGroupId = user.Groups(0).GroupId
            mGroupRoles = user.GetWebRoles(mSelectedGroupId)
        End If
    End Sub

#End Region

#Region " Public Methods "

    Public Function IsInRole(ByVal role As String) As Boolean Implements System.Security.Principal.IPrincipal.IsInRole
        If HasSelectedGroup Then
            Return ContainsRole(GroupRoles, role)
        Else
            Return ContainsRole(UserRoles, role)
        End If
    End Function

    Public Sub InitializeApplication(ByVal app As FormsAuth.ApplicationEnum)
        InitFlags = (InitFlags Or app)
    End Sub

#End Region

#Region " Friend Methods "

    Friend Function Serialize() As String
        Dim xml As String = "<UR>{0}</UR><GrpId>{1}</GrpId><Init>{2}</Init><GR>{3}</GR><UN>{4}</UN>"
        Return String.Format(xml, mUserRoles, mSelectedGroupId, CType(mInitFlags, Integer), mGroupRoles, mUserName)
    End Function

    Friend Shared Function Deserialize(ByVal xml As String) As NRCPrincipal
        Dim user As NRCPrincipal
        Dim userName As String
        Dim regex As New System.Text.RegularExpressions.Regex("<UR>(.*)</UR><GrpId>(.*)</GrpId><Init>(.*)</Init><GR>(.*)</GR><UN>(.*)</UN>", Text.RegularExpressions.RegexOptions.IgnoreCase)
        Dim match As System.Text.RegularExpressions.Match
        Try
            match = regex.Match(xml)
            userName = match.Groups(5).Value
            user = New NRCPrincipal
            user.mUserName = userName
            user.mMember = CachedMember(userName)
            user.mUserRoles = match.Groups(1).Value
            user.mSelectedGroupId = CType(match.Groups(2).Value, Integer)
            user.mInitFlags = CType(match.Groups(3).Value, FormsAuth.ApplicationEnum)
            user.mGroupRoles = match.Groups(4).Value
        Catch ex As Exception
            Return Nothing
        End Try

        Return user
    End Function

#End Region

#Region " Private Methods "

    Private Function ContainsRole(ByVal roleList As String, ByVal searchRole As String) As Boolean
        Dim roles() As String = roleList.Split(Convert.ToChar(","))
        For Each role As String In roles
            If role.ToLower = searchRole.ToLower Then
                Return True
            End If
        Next
        Return False
    End Function

#End Region

End Class
