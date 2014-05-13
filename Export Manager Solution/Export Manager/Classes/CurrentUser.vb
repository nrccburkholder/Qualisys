Imports System.DirectoryServices
Imports Nrc.NRCAuthLib

Public NotInheritable Class CurrentUser

#Region " Private Members "

    Private Shared mADEntry As DirectoryEntry
    Private Shared mMember As Member

#End Region

#Region " Public Properties "

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

    Public Shared ReadOnly Property HasApplicationAccess() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasAccessToApplication("Export Manager")
            End If
        End Get
    End Property

    Public Shared ReadOnly Property IsAdministrator() As Boolean
        Get
            Return Member.HasMemberPrivilege("Export Manager", "Administrator") OrElse Member.HasMemberPrivilege("Export Manager", "Administrator")
        End Get
    End Property

    Public Shared ReadOnly Property IsMedicareOverride() As Boolean
        Get
            Return Member.HasMemberPrivilege("Export Manager", "Medicare Override") OrElse Member.HasMemberPrivilege("Export Manager", "Administrator")
        End Get
    End Property

    Public Shared ReadOnly Property IsTPSOverride() As Boolean
        Get
            Return Member.HasMemberPrivilege("Export Manager", "TPS Override") OrElse Member.HasMemberPrivilege("Export Manager", "Administrator")
        End Get
    End Property

    Public Shared ReadOnly Property IsSpecialUpdates() As Boolean
        Get
            Return Member.HasMemberPrivilege("Export Manager", "Special Updates") OrElse Member.HasMemberPrivilege("Export Manager", "Administrator")
        End Get
    End Property

    Public Shared ReadOnly Property IsOryxUser() As Boolean
        Get
            Return Member.HasMemberPrivilege("Export Manager", "ORYX") OrElse Member.HasMemberPrivilege("Export Manager", "Administrator")
        End Get
    End Property

#End Region

#Region " Private Properties "

    Private Shared ReadOnly Property Member() As Member
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
                    Throw New NullReferenceException(String.Format("Could not retrieve the Active Directory entry for user '{0}'", Environment.UserName))
                End If
            End If

            Return mADEntry
        End Get
    End Property

#End Region

#Region " Constructors "

    Private Sub New()

    End Sub

#End Region

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

