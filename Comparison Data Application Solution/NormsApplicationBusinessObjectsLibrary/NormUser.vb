Public Class NormUser
#Region "private members"
    Private mMemberID As Integer
    Private mUserName As String
#End Region

#Region "Public Properties"
    Public ReadOnly Property MemberID() As Integer
        Get
            Return mMemberID
        End Get
    End Property

    Public ReadOnly Property Name() As String
        Get
            Return mUserName
        End Get
    End Property
#End Region

#Region "Public Methods"

    Public Shared Function getUserfromDataRow(ByVal row As DataRow) As NormUser
        Dim User As New NormUser

        User.mUserName = row("UserName")
        If Not row.IsNull("member_ID") Then
            User.mMemberID = row("member_ID")
        End If

        Return User
    End Function
#End Region
End Class
