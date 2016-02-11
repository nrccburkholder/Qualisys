Imports System.DirectoryServices
Imports Nrc.NRCAuthLib

''' <summary>Class of Static methods and properties containing various appliaction user information.</summary>
''' <Creator>Jeff Fleming</Creator>
''' <DateCreated>11/8/2007</DateCreated>
''' <DateModified>11/8/2007</DateModified>
''' <ModifiedBy>Tony Piccoli</ModifiedBy>
Public NotInheritable Class CurrentUser

    Private Shared mADEntry As DirectoryEntry
    Private Shared mMember As Member

    ''' <summary>Returns the NTLoginMember for the logged in user.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Private Shared ReadOnly Property Member() As Member
        Get
            If mMember Is Nothing Then
                mMember = NRCAuthLib.Member.GetNTLoginMember(Environment.UserName)
            End If

            Return mMember
        End Get
    End Property
    Public Shared ReadOnly Property AppName() As String
        Get
            Return My.Application.Info.Title
        End Get
    End Property
    ''' <summary>Retrieves the AD entry for the logged in user.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
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

    ''' <summary>Active directory display name</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property DisplayName() As String
        Get
            Return ADEntry.Properties("displayName")(0).ToString
        End Get
    End Property

    ''' <summary>UserName of logged in user.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property UserName() As String
        Get
            Return Environment.UserName
        End Get
    End Property

    ''' <summary>AD email address or email address based on logged in user name.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property Email() As String
        Get
            Try
                Return ADEntry.Properties("mail")(0).ToString
            Catch ex As Exception
                Return Environment.UserName & "@NationalResearch.com"
            End Try
        End Get
    End Property


    ''' <summary>NRC Auth Permission that tells whether a user has access to this application.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property HasApplicationAccess() As Boolean
        Get            
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasMemberPrivilege(AppName, "Access Template Imports")
            End If
        End Get
    End Property
    ''' <summary>This is an example of an NRC Auth permission you can set.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property FileTemplateAccess() As Boolean        
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasMemberPrivilege(AppName, "File Template Access")
            End If
        End Get        
    End Property

    Public Shared ReadOnly Property ImportExportAccess() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else : Return Member.HasMemberPrivilege(AppName, "Import Export Access")
            End If
        End Get
    End Property

    ''' <summary>This is an example of an NRC Auth permission you can set.</summary>
    ''' <value></value>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
    Public Shared ReadOnly Property IsAdministrator() As Boolean
        Get
            If Member Is Nothing Then
                Return False
            Else
                Return Member.HasMemberPrivilege(AppName, "Administrator")
            End If
        End Get
    End Property


    Private Sub New()
    End Sub

    ''' <summary>Get the AD entry for the logged in user.</summary>
    ''' <returns></returns>
    ''' <Creator>Jeff Fleming</Creator>
    ''' <DateCreated>11/8/2007</DateCreated>
    ''' <DateModified>11/8/2007</DateModified>
    ''' <ModifiedBy>Tony Piccoli</ModifiedBy>
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
