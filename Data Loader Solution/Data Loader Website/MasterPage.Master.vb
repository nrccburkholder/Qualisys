Imports System.Web.UI.UserControl

Partial Public Class MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Context.Response.Cache.SetCacheability(HttpCacheability.NoCache)
        If Me.Page.Request.Url.AbsolutePath <> "/DataLoader/SignIn.aspx" Then
            If Not CurrentUser.HasDataLoaderAccess Then
                NRC.NRCAuthLib.FormsAuth.SignOut("~/")
                Response.Redirect("~/Signin.aspx")
            End If
        End If
        If Not IsPostBack Then
            datCopyRight.Text = Now.Year.ToString
        End If
    End Sub

    Protected Sub DataloaderVersionLabelLoad(ByVal sender As Object, ByVal e As System.EventArgs) Handles DataLoaderVersionNumber.Load
        DataLoaderVersionNumber.Text = System.Reflection.Assembly.GetExecutingAssembly.GetName.Version.ToString
    End Sub

End Class
