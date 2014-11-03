'Public Class User
'    Inherits NRC.NRCAuthLib.Member

'#Region " Private Members "
'    Private mHasAccess As Boolean
'    Private mIsAdministrator As Boolean
'    Private mIsRole1 As Boolean
'    Private mIsRole2 As Boolean
'    Private mIsRole3 As Boolean
'#End Region

'#Region " Public Properties "
'    Public ReadOnly Property HasAccess() As Boolean
'        Get
'            Return Me.mHasAccess
'        End Get
'    End Property
'    Public ReadOnly Property IsAdministrator() As Boolean
'        Get
'            Return Me.mIsAdministrator
'        End Get
'    End Property
'    Public ReadOnly Property IsRole1() As Boolean
'        Get
'            Return Me.mIsRole1
'        End Get
'    End Property
'    Public ReadOnly Property IsRole2() As Boolean
'        Get
'            Return Me.mIsRole2
'        End Get
'    End Property
'    Public ReadOnly Property IsRole3() As Boolean
'        Get
'            Return Me.mIsRole3
'        End Get
'    End Property

'#End Region


'    'Constructor
'    Public Sub New(ByVal loginName As String)
'        MyBase.New(loginName, True)

'        Dim appName As String = "Comparison Data Application"

'        mHasAccess = Me.HasAccessToApplication(appName)
'        mIsAdministrator = Me.HasMemberPrivilege(appName, "Administrative Access Comparison Data Application")
'        mIsRole1 = (mIsAdministrator OrElse Me.HasMemberPrivilege(appName, "Access Comparison Data Application"))
'        mIsRole2 = (mIsAdministrator OrElse Me.HasMemberPrivilege(appName, "Canadian Access Comparison Data Application"))
'    End Sub

'End Class

Public Class User

    Private mUserName As String

    Public ReadOnly Property UserName() As String
        Get
            Return mUserName
        End Get
    End Property
    Public ReadOnly Property HasAccess() As Boolean
        Get
            Return True
        End Get
    End Property


    Sub New(ByVal loginName As String)
        mUserName = loginName
    End Sub
End Class