Partial Public Class ucHeader
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Context.User.Identity.IsAuthenticated Then
            Me.lblUserName.Visible = True
            Me.lblUserName.Text = String.Format("Welcome <STRONG><a href=""{0}"">{1}</a></STRONG>", Config.MyAccountUrl() & "/Profile.aspx", Context.User.Identity.Name)
            If SessionInfo.Member.HasAccessToMultipleGroups AndAlso Not SessionInfo.SelectedGroup Is Nothing Then
                Me.lblUserName.Text &= String.Format(" (<a href=""{0}"">{1}</a>)", Config.GroupSelectorUrl(Me.Page), SessionInfo.SelectedGroup.Name)
            End If
        Else
            Me.btnSignOut.Visible = False
            Me.lblUserName.Visible = False
            Me.btnDummy.Visible = False
        End If
        Me.lnkNRCPicker.HRef = Me.ResolveUrl(Config.NrcPickerUrl)
        Me.lnkHome.HRef = Me.ResolveUrl(Config.HomeUrl)
        Me.lnkSiteMap.HRef = Me.ResolveUrl(Config.SiteMapUrl)
        Me.lnkMySolutions.HRef = Me.ResolveUrl(Config.MySolutionsUrl)
        Me.lnkeReports.HRef = Me.ResolveUrl(Config.eReportsUrl)
        Me.lnkeComments.HRef = Me.ResolveUrl(Config.eCommentsUrl)
        Me.lnkeToolKit.HRef = Me.ResolveUrl(Config.eToolKitUrl)
        Me.lnkPCCLN.HRef = Me.ResolveUrl(Config.PCCInstituteUrl)
        Me.lnkGroups.HRef = Me.ResolveUrl(Config.GroupSelectorUrl(Me.Page))
        Me.btnDummy.Attributes.Add("OnClick", "return false;")


        Dim isAuthenticated As Boolean = Context.User.Identity.IsAuthenticated

        If Not isAuthenticated OrElse Not HasAcess("eReports") Then
            spneReports.Visible = False
        End If
        If Not isAuthenticated OrElse Not HasAcess("eComments") Then
            spneComments.Visible = False
        End If
        If Not isAuthenticated OrElse Not HasAcess("eToolKit") Then
            spneToolKit.Visible = False
        End If
        If Not isAuthenticated OrElse Not SessionInfo.Member.HasAccessToMultipleGroups Then
            spnGroups.Visible = False
        End If

    End Sub

    Private ReadOnly Property HasAcess(ByVal applicationName As String) As Boolean
        Get
            If SessionInfo.SelectedGroup Is Nothing Then
                Return SessionInfo.Member.HasAccessToApplication(applicationName)
            Else
                Return SessionInfo.SelectedGroup.HasPrivilege(applicationName)
            End If
        End Get
    End Property

    Private Sub btnSignOut_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnSignOut.Click
        NRC.NRCAuthLib.FormsAuth.SignOut("~/")
    End Sub
End Class