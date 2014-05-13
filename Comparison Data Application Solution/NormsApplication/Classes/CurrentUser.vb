Imports System.DirectoryServices
Imports Nrc.NRCAuthLib

Public Class CurrentUser

#Region " Public Fields"

    Public Enum AuthResult
        ErrorOccurred = 0
        AccessDenied = 1
        GeneralAccess = 2
        CanadianAccess = 3
        AdministrativeAccess = 4
    End Enum

#End Region
#Region " Private Fields"

#End Region
    Private Shared mADEntry As DirectoryEntry
    Private Shared mMember As Member
    Public Shared ReadOnly Property Member() As Member
        Get
            If mMember Is Nothing Then
                mMember = NRC.NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)
            End If

            Return mMember
        End Get
    End Property

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

    Public Shared ReadOnly Property DisplayName() As String
        Get
            Return ADEntry.Properties("displayName")(0).ToString
        End Get
    End Property
    Public Shared ReadOnly Property Email() As String
        Get
            Try
                Return ADEntry.Properties("mail")(0).ToString
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
    Public Shared ReadOnly Property isGeneral() As Boolean
        Get
            If Member.HasAccessToApplication("Comparison Data Application") And _
                Not IsAdmin And Not IsCanadian Then Return True
        End Get
    End Property
    Public Shared ReadOnly Property IsAdmin() As Boolean
        Get
            Return Member.HasMemberPrivilege("Comparison Data Application", "Administrative Access Comparison Data Application")
        End Get
    End Property

    Public Shared ReadOnly Property IsCanadian() As Boolean
        Get
            Return Member.HasMemberPrivilege("Comparison Data Application", "Canadian Access Comparison Data Application")
        End Get
    End Property

    'Public ReadOnly Property LoginName() As String
    '    Get
    '        Return mMember.NTLoginName
    '    End Get
    'End Property

    '    Public ReadOnly Property Member() As NRCAuthLib.Member
    '        Get
    '            Return mMember
    '        End Get
    '    End Property
    '#End Region

    'Public Shared Function getUser(ByVal ntLogin As String) As CurrentUser
    '    Dim newMember As New CurrentUser
    '    newMember.mMember = NRCAuthLib.Member.GetNTLoginMember(ntLogin)
    '    Return newMember
    'End Function
    'Public Shared ReadOnly Property HasApplicationAccess() As AuthResult
    '    Get
    '        If Member Is Nothing Then
    '            Return False
    '        End If
    '        If Not mMember.HasAccessToApplication("Comparison Data Application") Then
    '            Return AuthResult.AccessDenied
    '        ElseIf IsAdmin Then
    '            Return AuthResult.AdministrativeAccess
    '        ElseIf IsCanadian Then
    '            Return AuthResult.CanadianAccess
    '        Else
    '            Return AuthResult.GeneralAccess
    '        End If
    '    End Get
    'End Property
    Public Shared Function Authenticate() As AuthResult
        If Not Member.HasAccessToApplication("Comparison Data Application") Then
            Return AuthResult.AccessDenied
        ElseIf IsAdmin Then
            Return AuthResult.AdministrativeAccess
        ElseIf IsCanadian Then
            Return AuthResult.CanadianAccess
        Else
            Return AuthResult.GeneralAccess
        End If
    End Function

    Private Shared Function GetUserADEntry() As DirectoryEntry
        Dim userName As String = Environment.UserName
        Dim searchFilter As String = String.Format("(&(objectCategory=person)(sAMAccountName={0}))", userName)

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
