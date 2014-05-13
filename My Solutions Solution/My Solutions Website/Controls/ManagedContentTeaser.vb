Imports System
Imports System.Collections.Generic
Imports System.ComponentModel
Imports System.Text
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.Framework.BusinessLogic

<DefaultProperty("DetailPageUrl"), ToolboxData("<{0}:ManagedContentTeaser runat=server></{0}:ManagedContentTeaser>")> _
Public Class ManagedContentTeaser
    Inherits WebControl

    Public Enum TeaserSelectionMode
        Random = 0
        LeastRecentlyCreated = 1
        MostRecentlyCreated = 2
        MostRecentlyModified = 3
    End Enum

    Private Shared mRand As Random
    Private Shared ReadOnly Property Rand() As Random
        Get

            If mRand Is Nothing Then
                mRand = New Random
            End If
            Return mRand
        End Get
    End Property

#Region " Public Properties "
    <Bindable(True), Category("Content"), DefaultValue(""), Localizable(True), UrlProperty()> _
    Property DetailPageUrl() As String
        Get
            Dim url As String = CStr(ViewState("DetailPageUrl"))
            If url Is Nothing Then
                Return String.Empty
            Else
                Return url
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("DetailPageUrl") = Value
        End Set
    End Property

    <Bindable(True), Category("Content"), DefaultValue("View More"), Localizable(True)> _
    Property DetailLinkText() As String
        Get
            Dim value As String = CStr(ViewState("DetailLinkText"))
            If value Is Nothing Then
                Return "View More"
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("DetailLinkText") = Value
        End Set
    End Property

    <Bindable(True), Category("Content"), DefaultValue(""), Localizable(True)> _
    Property ContentCategory() As String
        Get
            Dim value As String = CStr(ViewState("ContentCategory"))
            If value Is Nothing Then
                Return String.Empty
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("ContentCategory") = Value
        End Set
    End Property

    <Bindable(True), Category("Content"), DefaultValue(""), Localizable(True)> _
    Property ContentKey() As String
        Get
            Dim value As String = CStr(ViewState("ContentKey"))
            If value Is Nothing Then
                Return String.Empty
            Else
                Return value
            End If
        End Get

        Set(ByVal Value As String)
            ViewState("ContentKey") = Value
        End Set
    End Property

    <Bindable(True), Category("Content"), DefaultValue(TeaserSelectionMode.Random), Localizable(True)> _
          Property SelectionMode() As TeaserSelectionMode
        Get
            If ViewState("SelectionMode") Is Nothing Then
                Return TeaserSelectionMode.Random
            Else
                Return CType(ViewState("SelectionMode"), TeaserSelectionMode)
            End If
        End Get

        Set(ByVal Value As TeaserSelectionMode)
            ViewState("SelectionMode") = Value
        End Set
    End Property
#End Region


    Protected Overrides ReadOnly Property TagKey() As System.Web.UI.HtmlTextWriterTag
        Get
            Return HtmlTextWriterTag.Div
        End Get
    End Property

    Protected Overrides Sub RenderContents(ByVal output As HtmlTextWriter)
        If HttpContext.Current Is Nothing Then
            RenderDesignHtml(output)
        Else
            RenderHtml(output)
        End If
    End Sub

    Private Sub RenderDesignHtml(ByVal output As HtmlTextWriter)
        output.Write("<div style=""margin:25px;color:c7c7c7;"">Managed Content...</div>")
    End Sub

    Private Sub RenderHtml(ByVal output As HtmlTextWriter)
        Dim html As String
        Dim contentSet As ManagedContentCollection = GetContentSet()
        html = GetHtml(contentSet)

        output.Write(html)
    End Sub

    Private Function GetContentSet() As ManagedContentCollection
        Dim cache As System.Web.Caching.Cache = HttpContext.Current.Cache
        Dim returnList As ManagedContentCollection
        Dim cacheKey As String = "Rscm:" & Me.ContentCategory
        returnList = TryCast(cache(cachekey), ManagedContentCollection)

        If returnList Is Nothing Then
            returnList = ManagedContent.GetByCategory(Me.ContentCategory, False)
            cache(cacheKey) = returnList
        End If

        Return returnList
    End Function

    Private Function GetHtml(ByVal contentSet As ManagedContentCollection) As String
        Dim html As String = ""
        Dim href As String
        Dim anchorOpen As String
        Dim anchorClose As String = "</a>"
        Dim mc As ManagedContent = Nothing

        If Not String.IsNullOrEmpty(Me.ContentKey) Then
            mc = contentSet.Find(Me.ContentCategory, Me.ContentKey)
            If mc Is Nothing Then
                Return "No Content"
            End If
        Else
            If contentSet.Count = 0 Then
                Return "No Content"
            Else
                Select Case Me.SelectionMode
                    Case TeaserSelectionMode.Random
                        mc = contentSet(Rand.Next(0, contentSet.Count))
                    Case TeaserSelectionMode.LeastRecentlyCreated
                        Dim sortedContent As New SortedBindingList(Of ManagedContent)(contentSet)
                        sortedContent.ApplySort("DateCreated", ListSortDirection.Ascending)
                        mc = sortedContent(0)
                    Case TeaserSelectionMode.MostRecentlyCreated
                        Dim sortedContent As New SortedBindingList(Of ManagedContent)(contentSet)
                        sortedContent.ApplySort("DateCreated", ListSortDirection.Descending)
                        mc = sortedContent(0)
                    Case TeaserSelectionMode.MostRecentlyModified
                        Dim sortedContent As New SortedBindingList(Of ManagedContent)(contentSet)
                        sortedContent.ApplySort("DateModified", ListSortDirection.Descending)
                        mc = sortedContent(0)
                End Select
            End If
        End If

        If mc Is Nothing Then
            Return "No Content"
        Else
            html = mc.Teaser
        End If

        href = String.Format(Me.DetailPageUrl, HttpContext.Current.Server.UrlEncode(mc.Category), HttpContext.Current.Server.UrlEncode(mc.Key))
        href = Page.ResolveClientUrl(href)
        anchorOpen = String.Format("<a href='{0}'>", href)
        If html.Contains("<more>") Then
            html = html.Replace("<more>", anchorOpen)
            html = html.Replace("</more>", anchorClose)
        ElseIf html.Contains("<MORE>") Then
            html = html.Replace("<MORE>", anchorOpen)
            html = html.Replace("</MORE>", anchorClose)
        Else

            html &= String.Format("<div style='text-align: right'><a href='{0}'>{1}</a></div>", href, Me.DetailLinkText)
        End If

        Return html
    End Function

End Class
