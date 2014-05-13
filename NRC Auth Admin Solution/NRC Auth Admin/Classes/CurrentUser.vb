Imports System.DirectoryServices
Imports Nrc.NRCAuthLib
Imports Nrc.NRCAuthLib.Member.MemberTypeEnum

Public NotInheritable Class CurrentUser

    Private Shared mADEntry As DirectoryEntry
    Private Shared mMember As Member

    Private Shared ReadOnly Property ADEntry() As DirectoryEntry
        Get
            If mADEntry Is Nothing Then
                mADEntry = GetUserADEntry()
                If mADEntry Is Nothing Then
                    Throw New NullReferenceException("Could not retrieve the Active Directory entry for user '" & Environment.UserName & "'")
                End If
            End If

            Return mADEntry
        End Get
    End Property

    Public Shared ReadOnly Property Member() As Member
        Get
            If mMember Is Nothing Then
                'mMember = NRCAuthLib.Member.GetMember("dpetersen")
                mMember = NRCAuthLib.Member.GetNTLoginMember(UserName)
            End If

            Return mMember
        End Get
    End Property

    Public Shared ReadOnly Property DisplayName() As String
        Get
            Return ADEntry.Properties("displayName")(0).ToString
        End Get
    End Property
    Public Shared ReadOnly Property Email() As String
        Get
            Return ADEntry.Properties("mail")(0).ToString
        End Get
    End Property
    Public Shared ReadOnly Property UserName() As String
        Get
            Return Environment.UserName
        End Get
    End Property

#Region " Permissions Properties "

    Public Shared ReadOnly Property HasNRCAuthAdminAccess() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasAccessToApplication("NRCAuth Admin")
            End If
        End Get
    End Property

    Public Shared ReadOnly Property AllowApplicationManagment() As Boolean
        Get
            Return Member.HasMemberPrivilege("NRCAuth Admin", "Application Administration")
        End Get
    End Property
    Public Shared ReadOnly Property AllowCreateOrgUnit() As Boolean
        Get
            Return (Member.MemberType = Administrator OrElse Member.MemberType = NRC_Admin)
        End Get
    End Property
    Public Shared ReadOnly Property AllowDeleteOrgUnit() As Boolean
        Get
            Return (Member.MemberType = NRC_Admin)
        End Get
    End Property
    Public Shared ReadOnly Property AllowEditOrgUnit() As Boolean
        Get
            Return AllowCreateOrgUnit
        End Get
    End Property
    Public Shared ReadOnly Property AllowCreateGroup() As Boolean
        Get
            Return (Member.MemberType = Administrator OrElse Member.MemberType = NRC_Admin)
        End Get
    End Property

    Public Shared ReadOnly Property AllowEditGroup() As Boolean
        Get
            Return AllowCreateGroup
        End Get
    End Property

    Public Shared ReadOnly Property AllowEReportsCalculatedFieldsAdditions() As Boolean
        Get
            Return Member.HasMemberPrivilege("NRCAuth Admin", "eReports Calculated Fields Administrator")
        End Get
    End Property
    Public Shared ReadOnly Property AllowMassEmail() As Boolean
        Get
            Return (Member.HasMemberPrivilege("NRCAuth Admin", "Send Mass Email") OrElse CurrentUser.Member.MemberType = NRC_Admin)
        End Get
    End Property
#End Region


    Private Sub New()
    End Sub

    Private Shared Function GetUserADEntry() As DirectoryEntry
        Dim searchFilter As String = String.Format("(&(objectCategory=person)(sAMAccountName={0}))", UserName)

        Using domainEntry As DirectoryEntry = ActiveDirectory.Domain.GetCurrentDomain.GetDirectoryEntry
            Using searcher As New DirectorySearcher(domainEntry, searchFilter)
                Using results As SearchResultCollection = searcher.FindAll
                    If results.Count <> 1 Then
                        Return Nothing
                    Else
                        Dim result As SearchResult = results(0)
                        Return result.GetDirectoryEntry
                    End If
                End Using
            End Using
        End Using
    End Function

End Class
