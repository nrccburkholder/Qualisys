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

    Public Shared ReadOnly Property UserName() As String
        Get
            Return Environment.UserName
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

    Public Shared ReadOnly Property HasApplicationAccess() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasAccessToApplication("Configuration Manager")
            End If
        End Get
    End Property

    Public Shared ReadOnly Property IsFacilityManager() As Boolean
        Get
            Return Member.HasMemberPrivilege("Configuration Manager", "Facility Manager")
        End Get
    End Property

    ''' <summary>Need the member Id for Propportional Calc logging.</summary>
    ''' <value></value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property MemberID() As Integer
        Get
            Return Member.MemberId
        End Get
    End Property
    ''' <summary>New flag for HCAHPS tab-section in configuration manager.</summary>
    ''' <value>true if has access to this tab.</value>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property IsHCAHPSManager() As Boolean
        Get
            Return Member.HasMemberPrivilege("Configuration Manager", "HCAHPS Manager")
        End Get
    End Property

    ''' <summary>New flag for Medicare tab-section in configuration manager.</summary>
    ''' <value>true if has access to this tab.</value>
    ''' <CreatedBy>Jeffrey J. Fleming</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Shared ReadOnly Property IsMedicareManager() As Boolean
        Get
            Return Member.HasMemberPrivilege("Configuration Manager", "Medicare Manager")
        End Get
    End Property

    Public Shared ReadOnly Property IsCopyDataStructure() As Boolean
        Get
            Return Member.HasMemberPrivilege("Configuration Manager", "Copy Data Structure")
        End Get
    End Property
    Public Shared ReadOnly Property MayDeleteGroupsAndSites() As Boolean
        Get
            Return Member.HasMemberPrivilege("Configuration Manager", "Delete Sites And Groups")
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
