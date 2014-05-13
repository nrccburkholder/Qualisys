Imports Nrc.Framework.BusinessLogic
Imports Nrc.DataMart.MySolutions.Library

Partial Public Class eToolKit_Public_WhatsNew
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim content As ManagedContent = ManagedContent.GetByKey("News", Request.QueryString("Key"))
        If Not content Is Nothing Then
            litNews.Text = content.Content
        End If

        Dim historicContent As ManagedContentCollection = ManagedContent.GetByCategory("News", False)
        Dim items As New SortedBindingList(Of ManagedContent)(historicContent)
        items.ApplySort("DateCreated", ComponentModel.ListSortDirection.Descending)
        'Create the url for the links
        Dim url As String = Request.Path & "?Key={0}"

        For Each mc As ManagedContent In items
            Dim link As New MenuBoxLink
            link.Text = mc.Key
            link.NavigateUrl = String.Format(url, mc.Key)
            Me.HistoryMenu.Controls.Add(link)
        Next
    End Sub

End Class