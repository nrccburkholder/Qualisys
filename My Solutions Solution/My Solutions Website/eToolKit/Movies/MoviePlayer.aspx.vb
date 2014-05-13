Public Partial Class eToolKit_Movies_MoviePlayer
    Inherits ToolKitPage


    Protected ReadOnly Property MoviePath() As String
        Get
            Return Me.ResolveUrl("~/eToolKit/Movies/" & MovieTitle & ".wmv")
        End Get
    End Property

    Private ReadOnly Property MovieTitle() As String
        Get
            If Not Request.QueryString("MovieTitle") = "" Then
                Return Request.QueryString("MovieTitle")
            Else
                Return "Access"
            End If
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Request.Url.Port = 443 Then
            Response.Redirect(Request.Url.ToString.Replace("https:", "http:"))
        End If
    End Sub

End Class