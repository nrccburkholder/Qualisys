Imports Nrc.DataMart.MySolutions.Library
Imports Nrc.DataMart.MySolutions.Library.Legacy
Imports Nrc.NRCAuthLib

Partial Public Class eToolKit_Admin_ResourceManagerSelection
    Inherits ToolKitPage

    Protected Overrides Sub OnLoad(ByVal e As System.EventArgs)
        MyBase.OnLoad(e)
        If Not Page.IsPostBack Then
            BindDataSource()
        End If
    End Sub

    Protected Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        BindDataSource()
    End Sub

    Protected Sub AddLinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddLinkButton.Click
        Server.Transfer("ResourceManager.aspx")
    End Sub

    Protected Sub ResultsPerPage1_PageSizeChanged(ByVal sender As Object, ByVal e As PageSizeChangedEventArgs) Handles ResultsPerPage1.PageSizeChanged
        ResourceGridView.AllowPaging = e.AllowPaging
        ResourceGridView.PageSize = e.PageSize
        BindDataSource()
    End Sub

    Private Sub ResourceGridView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResourceGridView.PageIndexChanging
        ResourceGridView.PageIndex = e.NewPageIndex
        BindDataSource()
    End Sub

    Private Sub BindDataSource()
        Dim user As Member = Member.GetMember(Page.User.Identity.Name)

        Dim tkServer As ToolkitServer = SessionInfo.EToolKitServer
        Dim serviceTypeId As Integer = 0
        If tkServer IsNot Nothing Then
            serviceTypeId = tkServer.MemberGroupPreference.ServiceTypeId
        End If

        '   Rick Christenham (09/10/2007):  NRC eToolkit Enhancement II:
        '                                   Added two additional parameters for the 
        '                                   GetSearchMemberResourcesText function.
        Dim groupId As Integer = -1
        ResourceGridView.DataSource = MemberResource.GetSearchMemberResourcesText(Guid.Empty, SearchTextBox.Text, serviceTypeId, groupId)
        ResourceGridView.DataBind()
    End Sub

    Protected Sub ResourceGridView_RowCommand(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles ResourceGridView.RowCommand

        If e.CommandName = "EditSelect" Then
            Context.Items.Add("ResourceKey", ResourceGridView.DataKeys(CInt(e.CommandArgument)).Value)
            Server.Transfer("ResourceManager.aspx")
        End If
    End Sub

End Class