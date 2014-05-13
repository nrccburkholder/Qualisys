''' <summary>
''' Represents a user of the QualiSys Data Entry Application.
''' </summary>
''' <remarks>
''' This class is mainly a wrapper around web accounts information for a QDE User.
''' </remarks>
''' <history>
''' 	[JCamp]	7/30/2004	Created
''' </history>
''' -----------------------------------------------------------------------------
Public Class User

    Private Const AppID As Integer = 11
#Region " Private Members "
    Private mLoginName As String
    Private mIsSuperAdmin As Boolean
    Private mIsKeyer As Boolean
    Private mIsKeyVerifier As Boolean
    Private mIsCoder As Boolean
    Private mIsCodeVerifier As Boolean
    Private mIsHandEntryOperator As Boolean
    Private mIsHandVerifier As Boolean
    Private mIsUserAdministrator As Boolean
    Private mIsFileImporter As Boolean
    Private mIsCommentModifier As Boolean
    Private mIsFinalizer As Boolean

#End Region

#Region " Public Properties "
    ''' <summary>The login name of the user</summary>
    Public ReadOnly Property LoginName() As String
        Get
            Return Me.mLoginName
        End Get
    End Property

    ''' <summary>Returns True if this user is a Super Administrator</summary>
    Public ReadOnly Property IsSuperAdmin() As Boolean
        Get
            Return Me.mIsSuperAdmin
        End Get
    End Property

    ''' <summary>Returns True if this user has the keying privilege</summary>
    Public ReadOnly Property IsKeyer() As Boolean
        Get
            Return Me.mIsKeyer
        End Get
    End Property

    ''' <summary>Returns True if this user has the key verification privilege</summary>
    Public ReadOnly Property IsKeyVerifier() As Boolean
        Get
            Return Me.mIsKeyVerifier
        End Get
    End Property

    ''' <summary>Returns True if this user has the coding privilege</summary>
    Public ReadOnly Property IsCoder() As Boolean
        Get
            Return Me.mIsCoder
        End Get
    End Property

    ''' <summary>Returns True if this user has the code verification privilege</summary>
    Public ReadOnly Property IsCodeVerifier() As Boolean
        Get
            Return Me.mIsCodeVerifier
        End Get
    End Property

    ''' <summary>Returns True if this user has the hand entry privilege</summary>
    Public ReadOnly Property IsHandwrittenOperator() As Boolean
        Get
            Return Me.mIsHandEntryOperator
        End Get
    End Property

    ''' <summary>Returns True if this user has the hand entry verification privilege</summary>
    Public ReadOnly Property IsHandwrittenVerifier() As Boolean
        Get
            Return Me.mIsHandVerifier
        End Get
    End Property

    ''' <summary>Returns True if this user has the any administrative privilege</summary>
    Public ReadOnly Property IsAdministrator() As Boolean
        Get
            Return (mIsSuperAdmin OrElse mIsUserAdministrator OrElse mIsFileImporter OrElse mIsCommentModifier OrElse mIsFinalizer)
        End Get
    End Property

    ''' <summary>Returns True if this user has the administer users privilege</summary>
    Public ReadOnly Property IsUserAdministrator() As Boolean
        Get
            Return mIsUserAdministrator
        End Get
    End Property

    ''' <summary>Returns True if this user has the file importer privilege</summary>
    Public ReadOnly Property IsFileImporter() As Boolean
        Get
            Return mIsFileImporter
        End Get
    End Property

    ''' <summary>Returns True if this user has the modify comments privilege</summary>
    Public ReadOnly Property IsCommentModifier() As Boolean
        Get
            Return mIsCommentModifier
        End Get
    End Property

    ''' <summary>Returns True if this user has the finalize privilege</summary>
    Public ReadOnly Property IsFinalizer() As Boolean
        Get
            Return mIsFinalizer
        End Get
    End Property
#End Region

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Represents the result of an authentication request
    ''' </summary>
    Public Enum AuthResult
        ErrorOccurred = 0
        AccessDenied = 1
        Success = 2
    End Enum

#Region " Constructors "
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Constructor that initializes the login name.
    ''' </summary>
    ''' <param name="loginName"></param>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Sub New(ByVal loginName As String)
        Me.mLoginName = loginName
        'Me.mClientUserID = -1

        mIsSuperAdmin = False
        mIsKeyer = False
        mIsKeyVerifier = False
        mIsCoder = False
        mIsCodeVerifier = False
        mIsHandEntryOperator = False
        mIsHandVerifier = False
        mIsUserAdministrator = False
        mIsFileImporter = False
        mIsCommentModifier = False
        mIsFinalizer = False

    End Sub
#End Region

#Region " Public Methods "

    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Attempts get authorization to the QDE application and sets up privileges.
    ''' </summary>
    ''' <returns></returns>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	7/30/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    Public Function Authenticate() As AuthResult
        'Create a WebAccount object
        Dim member As NRCAuthLib.Member = NRCAuthLib.Member.GetNTLoginMember(mLoginName)
        If member Is Nothing Then
            Return AuthResult.AccessDenied
        Else
            'If the account exists then check to see if they have privileges for DTSBuilder
            If Not member.HasAccessToApplication("QualiSys Data Entry") Then
                Return AuthResult.AccessDenied
            Else
                'mClientUserID = account.ClientUserID

                'Setup all the privileges
                mIsSuperAdmin = member.HasMemberPrivilege("QualiSys Data Entry", "Administrator")
                mIsKeyer = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Keyer"))
                mIsKeyVerifier = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Key Verifier"))
                mIsCoder = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Coder"))
                mIsCodeVerifier = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Code Verifier"))
                mIsHandEntryOperator = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Hand Entry Operator"))
                mIsHandVerifier = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Hand Entry Verifier"))
                mIsUserAdministrator = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "User Administrator"))
                mIsFileImporter = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Import External File"))
                mIsCommentModifier = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Modify Transferred Comments"))
                mIsFinalizer = (mIsSuperAdmin OrElse member.HasMemberPrivilege("QualiSys Data Entry", "Finalize"))

                'They must be okay to access...
                Return AuthResult.Success
            End If
        End If
    End Function

    'Public Shared Function GetAppUsers() As DataTable
    '    Return SqlHelper.ExecuteDataset(WACon, "SP_Admin_SelectClientUsers", 1).Tables(0)
    'End Function

    'Public Shared Function GetUserPrivileges(ByVal clientUserID As Integer) As DataView
    '    Dim tbl As DataTable = SqlHelper.ExecuteDataset(WACon, "SP_Admin_SelectUserPrivileges", clientUserID).Tables(0)

    '    Dim dv As New DataView(tbl)
    '    dv.RowFilter = String.Format("Application_id = {0}", AppID.ToString)

    '    Return dv
    'End Function

    'Public Shared Sub GrantPrivilege(ByVal clientUserID As Integer, ByVal privilegeID As Integer)
    '    SqlHelper.ExecuteNonQuery(WACon, "sp_Admin_GrantPrivilege", clientUserID, privilegeID, DBNull.Value, DBNull.Value)
    'End Sub

    'Public Shared Sub RevokePrivilege(ByVal clientUserID As Integer, ByVal privilegeID As Integer)
    '    SqlHelper.ExecuteNonQuery(WACon, "sp_Admin_RevokePrivilege", clientUserID, privilegeID, DBNull.Value, DBNull.Value)
    'End Sub

#End Region

End Class
