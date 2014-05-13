Option Strict On

Imports System.ComponentModel
Imports System.Web.UI
Imports System.Web

Namespace Web


    <DefaultProperty("DetailPage"), ToolboxData("<{0}:Teaser runat=server></{0}:Teaser>")> _
    Public Class Teaser
        Inherits System.Web.UI.WebControls.WebControl

        Public Enum Selection
            Random = 0
            MostRecentlyCreated = 1
            MostRecentlyModified = 2
        End Enum

#Region " Private Members "
        Private mDetailPage As String = "Details.aspx?Category={0}&Key={1}"
        Private mDetailLinkText As String = "Learn More"
        Private mContentCategory As String
        Private mIsStaticInSession As Boolean = False
        Private mSelectionType As Selection = Selection.Random

#End Region

#Region " Public Properties "
        <Bindable(True), Category("Data")> _
        Public Property DetailPage() As String
            Get
                Return mDetailPage
            End Get

            Set(ByVal Value As String)
                mDetailPage = Value
            End Set
        End Property

        <Bindable(True), Category("Data")> _
        Public Property DetailLinkText() As String
            Get
                Return mDetailLinkText
            End Get

            Set(ByVal Value As String)
                mDetailLinkText = Value
            End Set
        End Property

        <Bindable(True), Category("Data")> _
        Public Property ContentCategory() As String
            Get
                Return mContentCategory
            End Get

            Set(ByVal Value As String)
                mContentCategory = Value
            End Set
        End Property

        <Bindable(True), Category("Data")> _
        Public Property IsStaticInSession() As Boolean
            Get
                Return mIsStaticInSession
            End Get
            Set(ByVal Value As Boolean)
                mIsStaticInSession = Value
            End Set
        End Property

        <Bindable(True), Category("Data")> _
        Public Property SelectionMode() As Selection
            Get
                Return mSelectionType
            End Get
            Set(ByVal Value As Selection)
                mSelectionType = Value
            End Set
        End Property
#End Region

        Protected Overrides Sub Render(ByVal output As System.Web.UI.HtmlTextWriter)
            If HttpContext.Current Is Nothing Then
                RenderDesignHtml(output)
            Else
                RenderHtml(output)
            End If
        End Sub

        Private Sub RenderDesignHtml(ByVal output As HtmlTextWriter)
            output.Write("<font face='Verdana' size='1'>RSCM Teaser</font>")
        End Sub

        Private Function GetHtml(ByVal contentSet As ManagedContentCollection) As String
            Dim rand As New Random
            Dim index As Integer
            Dim html As String
            Dim href As String
            Dim anchorOpen As String
            Dim anchorClose As String = "</A>"

            If contentSet.Count = 0 Then
                Return "No Content"
            Else
                Select Case mSelectionType
                    Case Selection.Random
                        index = rand.Next(0, contentSet.Count)
                    Case Selection.MostRecentlyCreated
                        index = FindMostRecentCreated(contentSet)
                    Case Selection.MostRecentlyModified
                        index = FindMostRecentModified(contentSet)
                End Select

                html = contentSet(index).Teaser
                href = String.Format(mDetailPage, HttpContext.Current.Server.UrlEncode(contentSet(index).Category), HttpContext.Current.Server.UrlEncode(contentSet(index).Key))
                anchorOpen = String.Format("<a href='{0}'>", href)
                If html.IndexOf("<more>") > -1 Then
                    html = html.Replace("<more>", anchorOpen)
                    html = html.Replace("</more>", anchorClose)
                Else
                    html &= String.Format("<BR><span style='width:100%;TEXT-ALIGN: right'><a href='{0}'>{1}</a></span>", href, mDetailLinkText)
                End If

                If mIsStaticInSession Then
                    HttpContext.Current.Session("TeaserCache" & ID) = html
                End If

                Return html
            End If
        End Function

        Private Sub RenderHtml(ByVal output As HtmlTextWriter)
            Dim html As String
            If mIsStaticInSession AndAlso Not HttpContext.Current.Session("TeaserCache" & ID) Is Nothing Then
                html = CType(HttpContext.Current.Session("TeaserCache" & ID), String)
            Else
                Dim contentSet As ManagedContentCollection = GetContentSet()
                html = GetHtml(contentSet)
            End If

            output.Write(html)
        End Sub

        Private Function FindMostRecentCreated(ByVal contentSet As ManagedContentCollection) As Integer
            Dim maxDate As DateTime = DateTime.MinValue
            Dim maxIndex As Integer
            Dim i As Integer = 0
            For Each content As ManagedContent In contentSet
                If content.DateCreated > maxDate Then
                    maxDate = content.DateCreated
                    maxIndex = i
                    i += 1
                End If
            Next

            Return maxIndex
        End Function
        Private Function FindMostRecentModified(ByVal contentSet As ManagedContentCollection) As Integer
            Dim maxDate As DateTime = DateTime.MinValue
            Dim maxIndex As Integer
            Dim i As Integer = 0
            For Each content As ManagedContent In contentSet
                If content.DateModified > maxDate Then
                    maxDate = content.DateCreated
                    maxIndex = i
                    i += 1
                End If
            Next

            Return maxIndex
        End Function


        Private Function GetContentSet() As ManagedContentCollection
            Dim cache As System.Web.Caching.Cache = HttpContext.Current.Cache
            Dim returnList As ManagedContentCollection
            returnList = CType(cache("RSCM:" & Me.mContentCategory), ManagedContentCollection)

            If returnList Is Nothing Then
                returnList = ManagedContent.SelectFromDB(mContentCategory, False, ManagedContent.SelectOrder.Alpha)
                cache("RSCM:" & mContentCategory) = returnList
            End If

            Return returnList
        End Function

    End Class
End Namespace