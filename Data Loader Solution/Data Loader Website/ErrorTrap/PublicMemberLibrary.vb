Imports System.Net.Mail
Imports Nrc.NrcAuthLib

Public Class PublicMemberLibrary

#Region "Private Members"
#End Region

#Region "Public Members"

    Public Shared mSiteFriendlyNames As String   'Friendly Name of the current site
    Public Shared mSiteNames As String           'Name of the current site
    Public Shared mServerNames As String         'Name of the current server
    Public Shared mURL As String                 'Current page URL
    Public Shared mIPAddress As String           'IP Address of the current user
    Public Shared mBrowser As String             'Browser of the user 
    Public Shared mSessionID As String           'Current User session ID
    Public Shared mUserName As String            'Current User name
    Public Shared mPageName As String            'Current page Name
    Public Shared mHandled As Boolean            'Was the error handled true or false
    Public Shared mAdditionalWarning As String   'any additional warnings that need to be posted  

    Public Shared ReadOnly Property LogReturnExceptions() As Boolean
        Get
            Return False
        End Get
    End Property

    Public Shared ReadOnly Property RedirectToCustomPage() As String
        Get
            Return "~/Error.aspx"
        End Get
    End Property

    Public Shared ReadOnly Property SmtpServer() As SmtpClient
        Get
            Return New SmtpClient(Config.SmtpServer)
        End Get
    End Property

    Public Shared ReadOnly Property ExceptionFromAddress() As String
        Get
            Return Config.ExceptionFromAddress
        End Get
    End Property

    Public Shared ReadOnly Property ExceptionToAddress() As String
        Get
            Return Config.ExceptionToAddress
        End Get
    End Property

    Public Shared ReadOnly Property FriendlySiteName() As String
        Get
            Return System.Reflection.Assembly.GetExecutingAssembly.GetName.Name.ToString.Replace("NRC.", "")
        End Get
    End Property

    Public Shared ReadOnly Property IsAuthenticated() As Boolean
        Get
            Return HttpContext.Current.User.Identity.IsAuthenticated
        End Get
    End Property

    Public Shared ReadOnly Property Name() As String
        Get
            Return HttpContext.Current.User.Identity.Name
        End Get
    End Property

    Public Shared ReadOnly Property Member() As Member
        Get
            Return NRCPrincipal.Current.Member
        End Get
    End Property

#End Region

End Class
