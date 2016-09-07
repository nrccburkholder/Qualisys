Imports Log = NRC.NRCAuthLib.SecurityLog
Imports Nrc.NRCAuthLib.FormsAuth
Imports NRC.DataLoader.WebErrorLogClass
Imports NRC.DataLoader.ExceptionManager
Imports NRC.Framework.Notification
Imports System.IO

Public Class WebErrorTrappingBaseClass
    Inherits System.Web.UI.Page

#Region " Private Properties "
    Private ReadOnly Property LogEvents() As Boolean
        Get
            Return True
        End Get
    End Property

    Private ReadOnly Property SiteName() As String
        Get
            Return Context.Request.Url.Scheme & "://" & Context.Request.Url.Host & Context.Request.ApplicationPath
        End Get
    End Property
#End Region

#Region " Protected Properties "
    Protected Overridable ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return False
        End Get
    End Property
    Protected Overridable ReadOnly Property RequiresDataSelection() As Boolean
        Get
            Return False
        End Get
    End Property
    Protected Overridable ReadOnly Property LogPageRequest() As Boolean
        Get
            Return True
        End Get
    End Property
    Protected Overridable ReadOnly Property LogPageExceptions() As Boolean
        Get
            Return True
        End Get
    End Property
#End Region


#Region " Action "
    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        'SessionInfo.LastPage = Me.PageName
        If Not Page.IsPostBack Then
            If Me.LogPageRequest Then
                Try
                    'logs into the event log 
                    LogPageEvent("Page Request", Request.QueryString.ToString)
                Catch ex As Exception
                    DoPublish(ex)
                End Try
            End If
        End If

        'Finish processing
        MyBase.OnLoad(e)
    End Sub

    Protected Overrides Sub OnError(ByVal e As System.EventArgs)
        If Me.LogPageExceptions Then
            'Store the exception object into the session
            Dim ex As Exception = Server.GetLastError
            Server.ClearError()
            SessionInformation.LastException = ex
            'Create List to get return pass or fail of loggin and emailing
            Dim EmailLogList As New List(Of String)
            'send info of to be published in below function
            EmailLogList = DoPublish(ex)
            'on error repeat this Sub
            MyBase.OnError(e)

            'this is where you put the object that determines which error page the error goes too 
            'if you want it to go to the default then use no symbol. if you want it to go to the 
            'custom page that is built add ~ to the beginning of the ex.message change the page 
            'you wnat the custom redirection to go by changing the RedirectToCustomPage property
            'in the PublicMemberLibrary
            Dim redirectpage As String = ""
            If Mid(ex.Message.ToString, ex.Message.ToString.IndexOf(":") + 2, 1) = "~" Then
                redirectpage = RedirectToCustomPage
                mHandled = True
            Else
                redirectpage = "ErrorTrap/StaticError.aspx"
                mHandled = False
            End If

            'the following if then else will log return error if the logging or email fails
            'To turn off this functionality change the property LogReturnExceptions to false
            'in the Public Member Library class file 
            'and the client will simply go to the static errorpage

            'logging will send back the word logged if success 
            If EmailLogList(0) <> "Logged" And LogReturnExceptions Then
                Dim objReader As System.IO.StreamWriter
                objReader = New System.IO.StreamWriter(Server.MapPath("~/ErrorTrap/log.txt"))
                objReader.Write("Logging Failed - " & DateTime.Now.ToShortDateString & " - " & _
                  DateTime.Now.ToLongTimeString & " - " & _
                   EmailLogList(0) & vbCrLf)
                objReader.Close()
                objReader.Dispose()
                'transfer to error page with variable 1 in case the error 
                'page ever needs to be altered to support logging issues 
                Response.Redirect(redirectpage & "?NewE=1")
            ElseIf EmailLogList(1) <> "Emailed" And LogReturnExceptions Then
                Dim objReader As System.IO.StreamWriter
                objReader = New System.IO.StreamWriter(Server.MapPath("~/ErrorTrap/log.txt"))
                objReader.Write("Email Failed - " & DateTime.Now.ToShortDateString & " - " & _
                  DateTime.Now.ToLongTimeString & " - " & _
                   EmailLogList(1) & vbCrLf)
                objReader.Close()
                objReader.Dispose()
                'transfer to error page with variable 1 in case the error 
                'page ever needs to be altered to support emailing issues 
                Response.Redirect(redirectpage & "?NewE=2")
            Else
                'All is well just transfer main error 
                Response.Redirect(redirectpage)
            End If
            EmailLogList.Clear()
            EmailLogList = Nothing
            ex = Nothing
        Else
            'Trigger events
            MyBase.OnError(e)
        End If
    End Sub


    Private Function DoPublish(ByVal Exc As Exception)
        'fill all the variables for the email and the logging 
        Dim parts As String() = Request.Url.Segments
        Dim NewReturnList As New List(Of String)
        mSiteFriendlyNames = FriendlySiteName
        mSiteNames = Me.SiteName
        mUserName = Name
        mPageName = parts(parts.Length - 1)
        mServerNames = Request.ServerVariables("SERVER_NAME")
        mURL = Request.Url.ToString
        mIPAddress = Request.ServerVariables("Remote_ADDR")
        mBrowser = Request.Browser.Browser & " " & Request.Browser.Version
        mSessionID = Session.SessionID
        mAdditionalWarning = "None"
        'attempt to log and email. if success logging will return logged and email will return emailed
        'else they will return the stack trace
        NewReturnList.Add(StartLog(Exc))
        NewReturnList.Add(StartEmail(Exc))
        'Dim newObj As New Framework.Notification.MessageTypes
        'Dim newobj As New Framework.Notification.Message(MessageTypes.Template, "", "")
        parts = Nothing
        Return NewReturnList
        NewReturnList.Clear()
        NewReturnList = Nothing
    End Function

    Protected Sub LogPageEvent(ByVal strEventType As String, ByVal strEventData As String)
        'Logs a page event if logging is enabled
        If Me.LogEvents Then
            If CurrentUser.IsAuthenticated Then
                Log.LogWebEvent(CurrentUser.Name, Session.SessionID, FriendlySiteName, "StaticError.aspx", strEventType, strEventData)
            Else
                Log.LogWebEvent("", Session.SessionID, FriendlySiteName, "StaticError.aspx", strEventType, strEventData)
            End If

        End If
    End Sub

#End Region

End Class
