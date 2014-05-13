Imports NRC.Framework.Configuration
Imports System.Configuration
Public Class Config

#Region " EnvironmentSettings Properties "
    Private Shared ReadOnly Property Settings() As EnvironmentSettings
        Get
            Return EnvironmentSettings.LoadFromConfig
        End Get
    End Property
    Public Shared ReadOnly Property EnvironmentType() As EnvironmentType
        Get
            Return Settings.CurrentEnvironment.EnvironmentType
        End Get
    End Property

    Public Shared ReadOnly Property EnvironmentName() As String
        Get
            Return Settings.CurrentEnvironment.Name
        End Get
    End Property

#End Region

#Region " Custom Configuration Properties "

    Public Shared ReadOnly Property UseSsl() As Boolean
        Get
            Return (Settings("UseSsl").ToUpper = "TRUE")
        End Get
    End Property

    Public Shared ReadOnly Property SmtpServer() As String
        Get
            Return Settings("SmtpServer")
        End Get
    End Property

    Public Shared ReadOnly Property NrcPickerUrl() As String
        Get
            Return Settings("NrcPickerUrl")
        End Get
    End Property
    Public Shared ReadOnly Property WWWNrcPickerUrl() As String
        Get
            Return Settings("WWWNrcPickerUrl")
        End Get
    End Property

    Public Shared ReadOnly Property NrcAuthConnection() As String
        Get
            Return Settings("NrcAuthConnection")
        End Get
    End Property

    Public Shared ReadOnly Property GroupSelectorUrl(ByVal currentPage As Page) As String
        Get
            Return String.Format("{0}/GroupSelector.aspx?App=eToolKit&ReturnURL={1}", MyAccountUrl, HttpUtility.UrlEncode(currentPage.Request.Url.PathAndQuery))
        End Get
    End Property

    Public Shared ReadOnly Property eReportsUrl() As String
        Get
            Return Settings("eReportsUrl")
        End Get
    End Property

    Public Shared ReadOnly Property eCommentsUrl() As String
        Get
            Return Settings("eCommentsUrl")
        End Get
    End Property

    Public Shared ReadOnly Property MyAccountUrl() As String
        Get
            Return Settings("MyAccountUrl")
        End Get
    End Property

    Public Shared ReadOnly Property eReportsLinkPage() As String
        Get
            Return Settings("eReportsLinkPage")
        End Get
    End Property

    Public Shared ReadOnly Property eCommentsLinkPage() As String
        Get
            Return Settings("eCommentsLinkPage")
        End Get
    End Property

    Public Shared ReadOnly Property ContactToAddress() As String
        Get
            Return Settings("ContactToAddress")
        End Get
    End Property

    Public Shared ReadOnly Property ResearchInquiryEmail() As String
        Get
            Return Settings("ResearchInquiryEmail")
        End Get
    End Property

    Public Shared ReadOnly Property ResourcesEmail() As String
        Get
            Return Settings("ResourcesEmail")
        End Get
    End Property

    Public Shared ReadOnly Property ExceptionFromAddress() As String
        Get
            Return Settings("ExceptionFromAddress")
        End Get
    End Property

    Public Shared ReadOnly Property ExceptionToAddress() As String
        Get
            Return Settings("ExceptionToAddress")
        End Get
    End Property

    Public Shared ReadOnly Property WebDocumentPath() As String
        Get
            Dim path As String = Settings("WebDocumentPath")
            If Not path.EndsWith("\") Then
                path = path & "\"
            End If
            Return path
        End Get
    End Property

    Public Shared ReadOnly Property MemberResourcePath() As String
        Get
            Dim path As String = Settings("MemberResourcePath")
            If Not path.EndsWith("\") Then
                path = path & "\"
            End If
            Return path
        End Get
    End Property

#End Region

#Region " Learning Network Links "
    Public Class LNForumUrls
        Public Shared ReadOnly Property ForumLink(ByVal dimensionName As String) As String
            Get
                Return Links(dimensionName)
            End Get
        End Property

        Private Shared ReadOnly Property Links(ByVal key As String) As String
            Get
                Return CType(ConfigurationManager.GetSection("LNForumLinks"), System.Collections.Specialized.NameValueCollection)(key)
            End Get
        End Property
    End Class

    Public Class LNArchiveUrls
        Public Shared ReadOnly Property ArchiveLink(ByVal dimensionName As String) As String
            Get
                Return Links(dimensionName)
            End Get
        End Property

        Private Shared ReadOnly Property Links(ByVal key As String) As String
            Get
                Return CType(ConfigurationManager.GetSection("LNArchiveLinks"), System.Collections.Specialized.NameValueCollection)(key)
            End Get
        End Property
    End Class

    Public Class DimensionMovieAliases
        Public Shared ReadOnly Property MovieAlias(ByVal dimensionName As String) As String
            Get
                Return Links(dimensionName)
            End Get
        End Property

        Private Shared ReadOnly Property Links(ByVal key As String) As String
            Get
                Return CType(ConfigurationManager.GetSection("DimensionMovies"), System.Collections.Specialized.NameValueCollection)(key)
            End Get
        End Property
    End Class

#End Region

End Class
