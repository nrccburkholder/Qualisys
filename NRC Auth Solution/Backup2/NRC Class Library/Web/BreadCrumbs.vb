Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web

Namespace Web

    ''' -----------------------------------------------------------------------------
    ''' Project	 : NRC_Common_Classes
    ''' Class	 : Web.BreadCrumbs
    ''' 
    ''' -----------------------------------------------------------------------------
    ''' <summary>
    ''' Renders a series of links on the page that represent parent documents
    ''' in a website hiararchy defined in the NRC.Configuration.SiteMap
    ''' </summary>
    ''' <remarks>
    ''' </remarks>
    ''' <history>
    ''' 	[JCamp]	11/12/2004	Created
    ''' </history>
    ''' -----------------------------------------------------------------------------
    <DefaultProperty("Separator"), ToolboxData("<{0}:BreadCrumbs runat=server></{0}:BreadCrumbs>")> _
    Public Class BreadCrumbs
        Inherits System.Web.UI.WebControls.WebControl

#Region " Private Members "
        Private mSeparator = "&nbsp;|&nbsp;"
        Private mCssClass As String
#End Region

#Region " Properties "
        ''' -----------------------------------------------------------------------------
        ''' <summary>
        ''' The string that will be used to delimit different pages in the 
        ''' breadcrumb links.
        ''' </summary>
        ''' <returns>The delimiter</returns>
        ''' <remarks>
        ''' </remarks>
        ''' <history>
        ''' 	[JCamp]	11/12/2004	Created
        ''' </history>
        ''' -----------------------------------------------------------------------------
        <Bindable(True), Category("Appearance"), DefaultValue("&nbsp;|&nbsp;")> _
        Public Property Separator() As String
            Get
                Return mSeparator
            End Get
            Set(ByVal Value As String)
                mSeparator = Value
            End Set
        End Property

        Private Property QSHistory() As Hashtable
            Get
                Dim hist As Hashtable = Session("QueryStringHistory")
                If hist Is Nothing Then
                    hist = New Hashtable
                    Session("QueryStringHistory") = hist
                End If
                Return hist
            End Get
            Set(ByVal Value As Hashtable)
                Session("QueryStringHistory") = Value
            End Set
        End Property
        Private ReadOnly Property Session() As SessionState.HttpSessionState
            Get
                Return HttpContext.Current.Session
            End Get
        End Property

#End Region

        Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)
            'output.WriteLine("NRC.Web.BreadCrumbs Control")
            If HttpContext.Current Is Nothing Then
                output.Write(GetDesignHtml)
            Else
                output.Write(GetCrumbHtml)
            End If


        End Sub

        Private Function GetDesignHtml() As String
            If Me.CssClass.Length > 0 Then
                Return String.Format("<a class='{1}' href='#'>Home</a><span class='{1}'>{0}</span><a class='{1}' href='#'>Products</a><span class='{1}'>{0}</span><a class='{1}' href='#'>Web Controls</a><span class='{1}'>{0}BreadCrumbs</span>", mSeparator, CssClass)
            Else
                Return String.Format("<a href='#'>Home</a>{0}<a href='#'>Products</a>{0}<a href='#'>Web Controls</a>{0}BreadCrumbs", mSeparator)
            End If
        End Function

        Private Function GetCrumbHtml() As String
            Dim Request As HttpRequest = HttpContext.Current.Request
            Dim path As String = Request.Path.ToLower
            Dim page As Configuration.SitePage
            Dim isFirst As Boolean = True
            Dim histNew As New Hashtable
            Dim oldQS As String
            Dim crumbHtml As String = ""

            'If there is a Url Referrer then store their query string
            If Not Request.UrlReferrer Is Nothing Then
                If QSHistory(Request.UrlReferrer.LocalPath.ToLower) Is Nothing Then
                    QSHistory.Add(Request.UrlReferrer.LocalPath.ToLower, Request.UrlReferrer.Query)
                Else
                    QSHistory(Request.UrlReferrer.LocalPath.ToLower) = Request.UrlReferrer.Query
                End If
            End If

            'Store this page's query string
            If QSHistory(path) Is Nothing Then
                QSHistory.Add(path, Request.Url.Query)
            Else
                QSHistory(path) = Request.Url.Query
            End If

            'Find the current page in the sitemap
            page = Configuration.SiteMap.Instance.GetPage(path)
            'Loop through this page and all of it's predecessors
            While Not page Is Nothing
                'Get a history query string for this page if it exists
                oldQS = QSHistory(page.Path.ToLower)
                If oldQS Is Nothing Then oldQS = ""
                'Store the history query string for this page
                histNew.Add(page.Path.ToLower, oldQS)

                If isFirst Then
                    'If this is the first one then just print the name
                    If Me.CssClass.Length > 0 Then
                        crumbHtml = String.Format("<span class='{1}'>{0}<span>", page.Name, CssClass)
                    Else
                        crumbHtml = String.Format("{0}", page.Name)
                    End If
                    isFirst = False
                Else
                    'If it is not the first one then render a hyperlink
                    If Me.CssClass.Length > 0 Then
                        crumbHtml = String.Format("<a class='{5}' href='{0}{1}'>{2}</a><span class='{5}'>{3}</span>{4}", page.Path, histNew(page.Path.ToLower), page.Name, mSeparator, crumbHtml, CssClass)
                    Else
                        crumbHtml = String.Format("<a href='{0}{1}'>{2}</a>{3}{4}", page.Path, histNew(page.Path.ToLower), page.Name, mSeparator, crumbHtml)
                    End If
                End If

                'Move to the next predecessor
                page = page.Parent
            End While

            'Overwrite the old history of query strings with the newly created one.
            'This will get rid of stored query strings not in the current site map path
            QSHistory = histNew

            Return crumbHtml
        End Function

    End Class

End Namespace
