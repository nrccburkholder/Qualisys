Option Strict On

Option Explicit On

Imports System.IO
Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.DataMart.MySolutions.Library.Legacy
Imports Nrc.NRCAuthLib

Partial Public Class eToolKit_ResourceSearch
    Inherits ToolKitPage

    Protected Overrides ReadOnly Property RequiresInitialize() As Boolean
        Get
            Return True
        End Get
    End Property

    Public ReadOnly Property DocumentId() As Integer
        Get
            Dim value As String = Me.Request.Params!Id
            Dim id As Integer
            If Integer.TryParse(value, id) Then
                Return id
            Else
                Return 0
            End If
        End Get
    End Property

    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        If Not Page.IsPostBack Then
            If DocumentId > 0 Then
                BindDocument()
            Else
                BindDataSource()
            End If
        End If
    End Sub

    Private Sub buttonSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ButtonSearch.Click
        BindDataSource()
    End Sub

    Protected Sub ResultsPerPage1_PageSizeChanged(ByVal sender As Object, ByVal e As PageSizeChangedEventArgs) Handles ResultsPerPage1.PageSizeChanged
        MemberResourcesSearchList.AllowPaging = e.AllowPaging
        MemberResourcesSearchList.PageSize = e.PageSize
        BindDataSource()
    End Sub

    Private Sub MemberResourcesSearchList_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles MemberResourcesSearchList.PageIndexChanging
        MemberResourcesSearchList.PageIndex = e.NewPageIndex
        BindDataSource()
    End Sub

    Private Sub BindDocument()
        MemberResourcesSearchList.DataSource = New MemberResource() {MemberResource.GetMemberResource(DocumentId)}
        MemberResourcesSearchList.DataBind()
        MemberResourcesSearchList.PageIndex = 0
    End Sub

    Private Sub BindDataSource()
        Dim resultSet As Guid = Guid.NewGuid()
        Dim text As String = TextSearch.Text.Trim()

        '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
        '                                   Added two additional search parameters to the
        '                                   GetSearchMemberResourcesText function.
        Dim tkServer As ToolkitServer = SessionInfo.EToolKitServer
        Dim serviceTypeId As Integer = 0
        Dim groupId As Integer
        If tkServer IsNot Nothing Then
            serviceTypeId = tkServer.MemberGroupPreference.ServiceTypeId
            groupId = tkServer.MemberGroupPreference.GroupId
        End If

        Dim user As Member = Member.GetMember(Page.User.Identity.Name)

        SaveIndexServerSearchResults(resultSet, text)
        MemberResourcesSearchList.DataSource = MemberResource.GetSearchMemberResourcesText(resultSet, text, serviceTypeId, groupId)
        MemberResourcesSearchList.DataBind()
        MemberResourcesSearchList.PageIndex = 0
        IndexSearchResult.ClearIndexSearchResult(resultSet)
    End Sub

    Private Sub SaveIndexServerSearchResults(ByVal resultSet As Guid, ByRef text As String)
        If String.IsNullOrEmpty(text) Then Return
        Dim list As IndexSearchResultCollection = Nothing
        list = IndexSearchResult.GetIndexServerSearchResults(resultSet, text)
        For Each result As IndexSearchResult In list
            result.Save()
        Next
    End Sub

    Protected Sub Repeater1_ItemCommand(ByVal source As Object, ByVal e As CommandEventArgs)
        TextSearch.Text = DirectCast(e.CommandArgument, String)
        buttonSearch_Click(Me, EventArgs.Empty)
    End Sub

End Class