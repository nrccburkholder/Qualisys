Public Partial Class eToolKit_SiteRequirements
    Inherits ToolKitPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.CautionDiv.Visible = False
        Me.JavascriptDiv.Visible = False
        Me.CookiesDiv.Visible = False

        If Request.QueryString("cookies") = "false" Then
            Me.CautionDiv.Visible = True
            Me.CookiesDiv.Visible = True
        End If
        If Request.QueryString("java") = "false" Then
            Me.CautionDiv.Visible = True
            Me.JavascriptDiv.Visible = True
        End If
    End Sub

End Class