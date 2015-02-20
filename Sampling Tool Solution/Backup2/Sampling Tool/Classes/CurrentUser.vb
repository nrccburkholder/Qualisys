Imports System.DirectoryServices
Imports Nrc.Qualisys.Library
Imports Nrc.NRCAuthLib

Public NotInheritable Class CurrentUser

    Private Shared mADEntry As DirectoryEntry
    Private Shared mEmployee As Employee
    Private Shared mMember As Member

    Public Shared ReadOnly Property Employee() As Employee
        Get
            If mEmployee Is Nothing Then
                mEmployee = Nrc.Qualisys.Library.Employee.GetEmployeeByLoginName(Environment.UserName)
            End If
            Return mEmployee
        End Get
    End Property

    Public Shared ReadOnly Property Member() As Member
        Get
            If mMember Is Nothing Then
                mMember = NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)
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

    Public Shared ReadOnly Property HasSamplingToolAccess() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasAccessToApplication("Sampling Tool")
            End If
        End Get
    End Property
    Public Shared ReadOnly Property CanOversampleHCAHPS() As Boolean
        Get
            Return Member.HasMemberPrivilege("Sampling Tool", "Can Oversample HCAHPS")
        End Get
    End Property

    Public Shared ReadOnly Property CanSpecifyStaticPlusSeed() As Boolean
        Get
            Return Member.HasMemberPrivilege("Sampling Tool", "Can Specify StaticPlus Seed")
        End Get
    End Property

    Private Sub New()

    End Sub

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
