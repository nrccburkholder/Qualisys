Partial Public Class _Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Response.Redirect("Upload.aspx")

        If Not SessionInfo.Principal.HasSelectedGroup Then
            Response.Redirect(Config.GroupSelectorUrl(Me), False)
            Exit Sub
        Else
            Response.Redirect("~/upload.aspx")
        End If



    End Sub

End Class