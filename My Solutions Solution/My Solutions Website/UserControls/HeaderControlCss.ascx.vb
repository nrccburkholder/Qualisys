Partial Public Class HeaderControlCss
    Inherits System.Web.UI.UserControl
    ''' <summary>
    '''     ''' 
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <remarks>2008-04-07 - Steve Kennedy - Changed all four links to point to WWW version per Ted. Also changed page location for ContactUs and Sitemap per Ted on 4/7</remarks>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Me.LogoLink.NavigateUrl = Config.WWWNrcPickerUrl
            Me.HomeLink.NavigateUrl = Config.WWWNrcPickerUrl
            Me.ContactLink.NavigateUrl = Config.WWWNrcPickerUrl & "Pages/ContactUs.aspx"
            Me.SiteMapLink.NavigateUrl = Config.WWWNrcPickerUrl & "Pages/SiteMap.aspx"
        End If
    End Sub

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender
        If Context.User.Identity.IsAuthenticated Then
            Me.TopNavGeneral1.ShowEReports = CurrentUser.Member.HasAccessToApplication("eReports")
            Me.TopNavGeneral1.ShowEComments = CurrentUser.Member.HasAccessToApplication("eComments")
            Me.TopNavGeneral1.ShowEToolKit = CurrentUser.Member.HasAccessToApplication("eToolKit")
            Me.TopNavGeneral1.ShowMyAccount = CurrentUser.Member.HasAccessToApplication("My Account")
        End If
    End Sub
End Class