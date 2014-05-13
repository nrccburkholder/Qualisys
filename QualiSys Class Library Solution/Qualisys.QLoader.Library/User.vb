Public Class User

#Region " Private Members "

    Private mLoginName As String
    Private mMemberId As Integer
    Private mIsAdministrator As Boolean
    Private mIsPackageAdmin As Boolean
    Private mIsPackageCreator As Boolean
    Private mIsFunctionAuthor As Boolean
    Private mIsFileLoader As Boolean
    Private mIsLoadApplier As Boolean

#End Region

#Region " Public Properties "

    Public ReadOnly Property LoginName() As String
        Get
            Return mLoginName
        End Get
    End Property

    Public ReadOnly Property MemberId() As Integer
        Get
            Return mMemberId
        End Get
    End Property

    Public ReadOnly Property IsAdministrator() As Boolean
        Get
            Return mIsAdministrator
        End Get
    End Property

    Public ReadOnly Property IsPackageAdmin() As Boolean
        Get
            Return mIsPackageAdmin
        End Get
    End Property

    Public ReadOnly Property IsPackageCreator() As Boolean
        Get
            Return mIsPackageCreator
        End Get
    End Property

    Public ReadOnly Property IsFileLoader() As Boolean
        Get
            Return mIsFileLoader
        End Get
    End Property

    Public ReadOnly Property IsFunctionAuthor() As Boolean
        Get
            Return mIsFunctionAuthor
        End Get
    End Property

    Public ReadOnly Property IsLoadApplier() As Boolean
        Get
            Return mIsLoadApplier
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal loginName As String)

        mLoginName = loginName
        mMemberId = -1
        mIsAdministrator = False
        mIsPackageAdmin = False
        mIsPackageCreator = False
        mIsFileLoader = False
        mIsFunctionAuthor = False
        mIsLoadApplier = False

    End Sub

#End Region

#Region " Public Methods "

    Public Function Authenticate() As NRCAuthResult

        'Create a WebAccount object
        Dim mbr As Nrc.NRCAuthLib.Member = Nrc.NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)

        'Try to authenicate the user
        If mbr Is Nothing OrElse Not mbr.HasAccessToApplication("QLoader") Then
            Return NRCAuthResult.AccessDenied
        Else
            mMemberId = mbr.MemberId
            mIsAdministrator = mbr.HasMemberPrivilege("QLoader", "QLoader Admin")
            mIsPackageAdmin = mbr.HasMemberPrivilege("QLoader", "Package Admin")
            mIsPackageCreator = (mIsAdministrator OrElse mbr.HasMemberPrivilege("QLoader", "Package Creator"))
            mIsFunctionAuthor = (mIsAdministrator OrElse mbr.HasMemberPrivilege("QLoader", "Global Function Author"))
            mIsFileLoader = (mIsAdministrator OrElse mbr.HasMemberPrivilege("QLoader", "File Loader"))
            mIsLoadApplier = (mIsAdministrator OrElse mbr.HasMemberPrivilege("QLoader", "Load Applier"))

            'They must be okay to access...
            Return NRCAuthResult.Success
        End If

    End Function

#End Region

End Class
