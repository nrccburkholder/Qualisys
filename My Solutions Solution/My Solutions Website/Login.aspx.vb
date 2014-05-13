Public Partial Class Login
    Inherits MySolutionsPage

    'Private Enum LoginViewIndex
    '    LoggedIn = 0
    '    LoggedOut = 1
    'End Enum
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Redirect("~/Default.aspx")
        'If Context.User.Identity.IsAuthenticated Then
        '    Me.MultiView1.ActiveViewIndex = LoginViewIndex.LoggedIn
        'Else
        '    Me.MultiView1.ActiveViewIndex = LoginViewIndex.LoggedOut
        'End If
        'If Not Page.IsPostBack Then
        '    Me.Login1.Focus()
        'End If

        ''Set the default button for the login control
        ''This is kinda a hack but MS didn't do a good job of supporting
        ''default button on login control
        'Dim ctrl As Control = Login1.FindControl("LoginButton")
        'If ctrl IsNot Nothing AndAlso TypeOf (ctrl) Is IButtonControl Then
        '    Login1.Attributes.Add("onkeypress", String.Format("javascript:return WebForm_FireDefaultButton(event, '{0}')", ctrl.ClientID))
        'End If
    End Sub

End Class