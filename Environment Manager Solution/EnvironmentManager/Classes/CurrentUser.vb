Imports System.DirectoryServices
Imports Nrc.NRCAuthLib

Public NotInheritable Class CurrentUser

    Private Shared mADEntry As DirectoryEntry
    Private Shared mNrcMember As Member
    Private Shared ReadOnly Property NrcMember() As Member
        Get
            If mNrcMember Is Nothing Then
                'mNrcMember = Member.GetNTLoginMember("developer")
                mNrcMember = Member.GetNTLoginMember(Environment.UserName)
            End If

            Return mNrcMember
        End Get
    End Property

    Public Shared ReadOnly Property DisplayName() As String
        Get
            Return NrcMember.DisplayLabel
        End Get
    End Property
    Public Shared ReadOnly Property Email() As String
        Get
            Try
                Return NrcMember.EmailAddress
            Catch ex As Exception
                Return UserName & "@NationalResearch.com"
            End Try
        End Get
    End Property
    Public Shared ReadOnly Property UserName() As String
        Get
            Return Environment.UserName
        End Get
    End Property
    Public Shared ReadOnly Property HasApplicationAccess() As Boolean
        Get
            If NrcMember Is Nothing Then Return False
            If IsSuperAdmin Then Return True
            If CanEditSettings Then Return True
            Return NrcMember.HasAccessToApplication("Environment Manager")
        End Get
    End Property

    Public Shared ReadOnly Property CanEditSettings() As Boolean
        Get
            If IsSuperAdmin Then
                Return True
            ElseIf NrcMember Is Nothing Then
                Return False
            End If
            Return NrcMember.MemberType = Member.MemberTypeEnum.NRC_Admin OrElse _
                    NrcMember.HasMemberPrivilege("Environment Manager", "Edit Settings")
        End Get
    End Property
    Public Shared ReadOnly Property IsSuperAdmin() As Boolean
        Get
            If NrcMember Is Nothing Then Return False
            For Each user As SuperAdmin In Config.SuperAdminUsers
                If String.Equals(user.SuperAdminUserName, System.Environment.UserName, StringComparison.CurrentCultureIgnoreCase) Then
                    Return True
                End If
            Next
            Return NrcMember.HasMemberPrivilege("Environment Manager", "SuperAdmin")
        End Get
    End Property

    Private Sub New()
    End Sub

End Class

