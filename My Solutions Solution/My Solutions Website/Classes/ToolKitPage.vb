Imports Nrc.DataMart.MySolutions.Library.Legacy
Imports Nrc.DataMart.MySolutions.Library
Imports Log = NRC.NRCAuthLib.SecurityLog
Imports Nrc.NRCAuthLib.FormsAuth

Public Class ToolKitPage
    Inherits MySolutionsPage

#Region " Private Members "
    Private mPageName As String     'Name of the current page
    Private mUserName As String     'Name of the current user
    Private mSiteName As String     'URL of site
#End Region

#Region " Private Properties "
    Private ReadOnly Property LogEvents() As Boolean
        Get
            Return True
        End Get
    End Property

    Private Property UserName() As String
        Get
            Return mUserName
        End Get

        Set(ByVal Value As String)
            mUserName = Value
        End Set
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
 
    Protected Overridable ReadOnly Property PageName() As String
        Get
            Dim parts As String() = Request.Url.Segments
            Return parts(parts.Length - 1)
        End Get
    End Property


    Protected ReadOnly Property ToolKitServer() As ToolkitServer
        Get
            Return SessionInfo.EToolKitServer
        End Get
    End Property

    Protected ReadOnly Property MemberPreference() As MemberReportPreference
        Get
            Return ToolKitServer.MemberPreference
        End Get
    End Property

    Protected ReadOnly Property MemberGroupPreference() As MemberGroupReportPreference
        Get
            Return ToolKitServer.MemberGroupPreference
        End Get
    End Property

#End Region

#Region " Page Events "

#End Region

    Protected Overrides Sub OnPreInit(ByVal e As System.EventArgs)
        If Me.RequiresInitialize Then
            If Not CurrentUser.IsAuthenticated Then
                Response.Redirect("~/eToolKit/Default.aspx")
            End If

            If Not CurrentUser.HasSelectedGroup Then
                Response.Redirect(Config.GroupSelectorUrl(Me))
            End If

            If Not SessionInfo.IsAppInitialized(ApplicationEnum.eToolKit) Then
                SessionInfo.InitializeApp(ApplicationEnum.eToolKit)

            End If

            'If RequiresDataSelection AndAlso Not IsSelectionInitialized() AndAlso Not String.Equals(Request.AppRelativeCurrentExecutionFilePath, dataSelection, StringComparison.CurrentCultureIgnoreCase) Then
            If RequiresDataSelection AndAlso Not IsSelectionInitialized() Then
                Const dataSelection As String = "~/eToolKit/DataSelection.aspx"
                Response.Redirect(dataSelection)
            End If

        End If

        'Finish processing
        MyBase.OnPreInit(e)
    End Sub

    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        'SessionInfo.LastPage = Me.PageName

        If Not Page.IsPostBack Then
            If Me.LogPageRequest Then
                Try
                    LogPageEvent("Page Request", Request.QueryString.ToString)
                Catch ex As Exception
                    PublishException(ex, True)
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
            SessionInfo.LastException = ex

            'Publish the exception
            Me.PublishException(ex)

            'Trigger events
            MyBase.OnError(e)

            Response.Redirect("~/Error/Error.aspx")
        Else
            'Trigger events
            MyBase.OnError(e)
        End If
    End Sub

#Region " Protected Members "

    'Publishes an exception to the Exception Manager.
    Protected Sub PublishException(ByVal ex As Exception, Optional ByVal bolHandled As Boolean = False, Optional ByVal strWarning As String = "")
        'Create a NV Collection of "Additional Info."
        Dim nvcInfo As New NameValueCollection
        nvcInfo.Add("Time Stamp", DateTime.Now.ToString)
        nvcInfo.Add("Server Name", Request.ServerVariables("SERVER_NAME"))
        nvcInfo.Add("Site", Me.SiteName)
        nvcInfo.Add("URL", Request.Url.ToString)
        nvcInfo.Add("Page Name", Me.PageName)
        nvcInfo.Add("User Name", Me.UserName)
        nvcInfo.Add("IP Address", Request.ServerVariables("Remote_ADDR"))
        nvcInfo.Add("Broswer", Request.Browser.Browser & " " & Request.Browser.Version)
        nvcInfo.Add("Session ID", Session.SessionID)

        'If the exception was handled but still should be published then bolHandled = true
        nvcInfo.Add("Handled", bolHandled.ToString)

        'If an additional warning was passed in then add it
        If strWarning.Length > 0 Then
            nvcInfo.Add("Warning", strWarning)
        End If

        'Publish exception to any publisher activated in the web.config
        ExceptionManager.Publish(ex, nvcInfo)
        If CurrentUser.IsAuthenticated Then
            Log.LogWebException(CurrentUser.Name, Session.SessionID, "eToolKit", Request.Url.ToString, Me.PageName, bolHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        Else
            Log.LogWebException("", Session.SessionID, "eToolKit", Request.Url.ToString, Me.PageName, bolHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        End If
    End Sub

    'This is a SHARED version of the previous method.  It is used to publish exceptions from pages not inheriting from EReportsPage
    'Publishes an exception to the Exception Manager.
    Friend Shared Sub PublishException(ByVal ex As Exception, ByVal PageName As String, Optional ByVal bolHandled As Boolean = False, Optional ByVal strWarning As String = "")
        'Create a NV Collection of "Additional Info."
        Dim request As HttpRequest = HttpContext.Current.Request
        Dim nvcInfo As New System.Collections.Specialized.NameValueCollection
        nvcInfo.Add("Time Stamp", DateTime.Now.ToString)
        nvcInfo.Add("Server Name", request.ServerVariables("SERVER_NAME"))
        nvcInfo.Add("Site", request.Url.Scheme & "://" & request.Url.Host & request.ApplicationPath)
        nvcInfo.Add("URL", request.Url.ToString)
        nvcInfo.Add("Page Name", PageName)
        nvcInfo.Add("User Name", HttpContext.Current.User.Identity.Name)
        nvcInfo.Add("IP Address", request.ServerVariables("Remote_ADDR"))
        nvcInfo.Add("Broswer", request.Browser.Browser & " " & request.Browser.Version)
        nvcInfo.Add("Session ID", HttpContext.Current.Session.SessionID)

        'If the exception was handled but still should be published then bolHandled = true
        nvcInfo.Add("Handled", bolHandled.ToString)

        'If an additional warning was passed in then add it
        If strWarning.Length > 0 Then
            nvcInfo.Add("Warning", strWarning)
        End If

        'Publish exception to any publisher activated in the web.config
        ExceptionManager.Publish(ex, nvcInfo)

        'Log the exception 
        If CurrentUser.IsAuthenticated Then
            Log.LogWebException(CurrentUser.Name, HttpContext.Current.Session.SessionID, "eToolKit", request.Url.ToString, PageName, bolHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        Else
            Log.LogWebException("", HttpContext.Current.Session.SessionID, "eToolKit", request.Url.ToString, PageName, bolHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        End If
        'If Not SessionInfo.WebAccount Is Nothing Then
        '    SessionInfo.WebAccount.LogException("eToolKit", request.Url.ToString, PageName, bolHandled, ex.Message, ex.GetType.ToString, ex.StackTrace)
        'End If
    End Sub

    Protected Sub LogPageEvent(ByVal strEventType As String, ByVal strEventData As String)
        'Logs a page event if logging is enabled
        If Me.LogEvents Then
            If CurrentUser.IsAuthenticated Then
                Log.LogWebEvent(CurrentUser.Name, Session.SessionID, "eToolkit", Me.PageName, strEventType, strEventData)
            Else
                Log.LogWebEvent("", Session.SessionID, "eToolkit", Me.PageName, strEventType, strEventData)
            End If

        End If
    End Sub

#End Region

    Protected Overridable Function IsSelectionInitialized() As Boolean

        If Not IsServiceTypeSelected() Then Return False

        If Not IsUnitSelected() Then Return False

        If Not IsViewSelected() Then Return False

        Return True

    End Function

    Private Function IsServiceTypeSelected() As Boolean
        If MemberGroupPreference.ServiceTypeId = 0 Then Return False
        Dim tblServiceTypes As DataTable = Me.ToolKitServer.ServiceTypes.Tables(0)
        For Each row As DataRow In tblServiceTypes.Rows
            If CInt(row!TKDimension_ID) = MemberGroupPreference.ServiceTypeId Then
                If CBool(row!bitHasQuestions) = False Then Exit For
                Return True
            End If
        Next
        MemberGroupPreference.ServiceTypeId = 0
        Return False
    End Function

    Private Function IsUnitSelected() As Boolean
        If String.IsNullOrEmpty(MemberGroupPreference.SelectedUnit) Then Return False
        Dim suNodes As List(Of SampleUnitTreeNode) = ToolKitServer.GetUnitTree()
        Dim valuePath As String = SampleUnitTreeNode.FindNodeByUniqueId(suNodes, MemberGroupPreference.SelectedUnit)
        If valuePath IsNot Nothing Then
            SessionInfo.SelectedUnitValuePath = valuePath
            Return True
        Else
            MemberGroupPreference.SelectedUnit = ""
            Return False
        End If
    End Function

    Private Function IsViewSelected() As Boolean
        If MemberGroupPreference.SelectedViewId = 0 Then Return False
        If MemberGroupPreference.IsChooseQuestionSelected Then
            SessionInfo.SelectedViewName = "Choose a question"
            Return True ' Choose a question...
        End If
        Dim treeData As DataSet = ToolKitServer.GetTreeData(MemberGroupPreference.ServiceTypeId)
        For Each row As DataRow In treeData.Tables(0).Rows
            If CInt(row!Dimension_id) = MemberGroupPreference.SelectedViewId Then
                If (CBool(row!bitHasChild) = False AndAlso CBool(row!HasResults) = False) Then Exit For
                SessionInfo.SelectedViewName = CStr(row!strDimension_nm)
                Return True
            End If
        Next
        MemberGroupPreference.SelectedViewId = 0
        Return False
    End Function

    Public Sub SavePreferences()
        MemberPreference.Save()
        MemberGroupPreference.Save()
    End Sub

End Class
