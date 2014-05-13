Imports NRC.NRCAuthLib
'------------------------SessionInfo Class------------------------'
'
'   This class is used as a wrapper around the Session object so 
'   that we can strongly type session objects and keep track of
'   them better.
'
'   All Members of this class are defined as Shared (Static) so this
'   class is never instantiated.
'
'   Most methods simply place/retrieve objects from the Session
'   object associated with the current HTTPContext.
'
'-----------------------------------------------------------------'
Public Class SessionInfo
    'Public Shared Property ScoreServer() As NRC.ScoreServer.ScoreServer
    '    Get
    '        Return Session("ScoreServer")
    '    End Get
    '    Set(ByVal Value As ScoreServer.ScoreServer)
    '        Session("ScoreServer") = Value
    '    End Set
    'End Property



    Public Shared ReadOnly Property UserName() As String
        Get
            Return HttpContext.Current.User.Identity.Name
        End Get
    End Property

    Public Shared ReadOnly Property [Member]() As Member
        Get
            Return NRCPrincipal.Current.Member
        End Get
    End Property

    Public Shared ReadOnly Property Principal() As NRCPrincipal
        Get
            Return NRCPrincipal.Current
        End Get
    End Property

    Public Shared ReadOnly Property SelectedGroup() As NRCAuthLib.Group
        Get
            Return NRCPrincipal.Current.SelectedGroup
        End Get
    End Property

    Public Shared Property SASQueryString() As System.Collections.Specialized.NameValueCollection
        Get
            Return Session("SASQueryString")
        End Get
        Set(ByVal Value As System.Collections.Specialized.NameValueCollection)
            Session("SASQueryString") = Value
        End Set
    End Property

    Public Shared Property ExceptionMessage()
        Get
            Return Session("ExceptionMessage")
        End Get
        Set(ByVal Value)
            Session("ExceptionMessage") = Value
        End Set
    End Property

    Public Shared Property ExceptionStack()
        Get
            Return Session("ExceptionStack")
        End Get
        Set(ByVal Value)
            Session("ExceptionStack") = Value
        End Set
    End Property

    Public Shared Property LastPage() As String
        Get
            Return Session("LastPage")
        End Get
        Set(ByVal Value As String)
            Session("LastPage") = Value
        End Set
    End Property

    Public Shared ReadOnly Property BrowserIsUpLevel() As Boolean
        Get
            'Returns true if browser is IE 5+ or Netscape 5+
            Dim strBrowser As String = HttpContext.Current.Request.Browser.Browser.ToUpper
            Dim dblVersion As Double = HttpContext.Current.Request.Browser.Version
            Dim bolReturn As Boolean = False

            If strBrowser = "IE" Or strBrowser = "NETSCAPE" Then
                If dblVersion >= 5 Then
                    bolReturn = True
                End If
            End If

            Return bolReturn
        End Get
    End Property

    Public Shared Property OneClickDS() As DataSet
        Get
            Return Session("OneClickDS")
        End Get
        Set(ByVal Value As DataSet)
            Session("OneClickDS") = Value
        End Set
    End Property

    Public Shared Property RequestedURL() As String
        Get
            Return Session("RequestedURL")
        End Get
        Set(ByVal Value As String)
            Session("RequestedURL") = Value
        End Set
    End Property

    'Public Shared ReadOnly Property IsVACustomUser(ByVal strID As String) As Boolean
    '    Get
    '        If Session("IsVACustomUser") Is Nothing Then
    '            Session("IsVACustomUser") = AppConfig.Instance.IsVACustomUser(strID)
    '        End If

    '        Return Session("IsVACustomUser")
    '    End Get
    'End Property

    Public Shared Property VACustomSetting() As String
        Get
            Return Session("VACustomSetting")
        End Get
        Set(ByVal Value As String)
            Session("VACustomSetting") = Value
        End Set
    End Property

    Public Shared ReadOnly Property IsInternalUser() As Boolean
        Get
            Dim strIPAddr As String = HttpContext.Current.Request.ServerVariables("REMOTE_ADDR")
            Return (strIPAddr.StartsWith("10.10.") Or strIPAddr.StartsWith("127.0.0.1"))
        End Get
    End Property

    Public Shared Property LastDocumentDownload() As Integer
        Get
            If Session("LastDocDownload") Is Nothing Then
                Return -1
            Else
                Return Session("LastDocDownload")
            End If
        End Get
        Set(ByVal Value As Integer)
            Session("LastDocDownload") = Value
        End Set
    End Property

    '------------------------------------------------------------
    Private Shared Property Session(ByVal name As String) As Object
        Get
            Return HttpContext.Current.Session(name)
        End Get
        Set(ByVal Value As Object)
            HttpContext.Current.Session(name) = Value
        End Set
    End Property
End Class
