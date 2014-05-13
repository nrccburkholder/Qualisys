Public Partial Class ucSecurity
    Inherits System.Web.UI.UserControl

    ''' <summary>Prevents NrcAuth users that are authenticated in other web applications like eToolkit but
    ''' don't have a permission to Data Loader browse the upload.aspx directly.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Me.Page.Request.Url.AbsolutePath <> "/DataLoader/SignIn.aspx" Then
            If Not CurrentUser.HasDataLoaderAccess Then
                NRC.NRCAuthLib.FormsAuth.SignOut("~/")
                Response.Redirect("~/Signin.aspx")
            End If
        End If
    End Sub

End Class