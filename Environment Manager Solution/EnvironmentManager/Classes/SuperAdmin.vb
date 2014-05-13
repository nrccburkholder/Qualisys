Public Class SuperAdmin
    Private mSuperAdminUsername As String
    Public Property SuperAdminUserName() As String
        Get
            Return mSuperAdminUsername
        End Get
        Set(ByVal value As String)
            mSuperAdminUsername = value
        End Set
    End Property
    Public Sub New(ByVal pUsername As String)
        mSuperAdminUsername = pUsername
    End Sub
    Public Sub New()
    End Sub
End Class
