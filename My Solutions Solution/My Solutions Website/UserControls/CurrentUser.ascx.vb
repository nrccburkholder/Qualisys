Public Partial Class UserControls_CurrentUser
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
 
    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If CurrentUser.IsAuthenticated Then
            Dim userLabel As Label = TryCast(Me.LoginView1.FindControl("UserNameLabel"), Label)
            If userLabel IsNot Nothing Then
                Dim profilePageUrl As String = String.Format("{0}/Profile.aspx", Config.MyAccountUrl)
                userLabel.Text = String.Format("Welcome <strong><a href=""{0}"">{1}</a></strong>", profilePageUrl, CurrentUser.Member.FullName)

                If CurrentUser.Member.HasAccessToMultipleGroups AndAlso CurrentUser.Principal.HasSelectedGroup Then
                    Dim groupSelectorPageUrl As String = Config.GroupSelectorUrl(Me.Page)
                    userLabel.Text &= String.Format(" (<a href=""{0}"">{1}</a>)", groupSelectorPageUrl, CurrentUser.Principal.SelectedGroup.Name)
                End If
            End If

            If CurrentUser.HasSelectedGroup Then
                Dim groupLink As HyperLink = TryCast(Me.LoginView1.FindControl("GroupSelectionLink"), HyperLink)
                If groupLink IsNot Nothing Then
                    groupLink.Text = CurrentUser.SelectedGroup.Name
                    groupLink.NavigateUrl = Config.GroupSelectorUrl(Me.Page)
                End If
            End If
        Else
        End If
    End Sub
End Class