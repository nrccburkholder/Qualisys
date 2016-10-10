Public Class changePassword
    Inherits System.Web.UI.Page
    Protected WithEvents txtPassword As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtConfirmPassword As System.Web.UI.WebControls.TextBox
    Protected WithEvents btnChangePassword As System.Web.UI.WebControls.Button
    Protected WithEvents messageCell As System.Web.UI.HtmlControls.HtmlTableRow
    Protected WithEvents litJScript As System.Web.UI.WebControls.Literal
    Protected WithEvents defaultpword As System.Web.UI.WebControls.Literal
    Protected WithEvents lblMessage As System.Web.UI.WebControls.Label

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        defaultpword.Text = """" & AppConfig.Instance.DefaultPassword.ToLower & """"
        If Not Page.IsPostBack Then
            If (Request.QueryString.Item("msg") = "pw") Then
                lblMessage.Visible = True
                lblMessage.Text = "Thank you for using the file upload system. <br>Please change your password before continuing."
            End If
        End If
    End Sub

    Private Sub btnChangePassword_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnChangePassword.Click
        ' first make sure the new password is NOT the DEFAULT password
        ' update the passwords
        Dim UploadServer As UploadServer = Session("UploadServer")
        UploadServer.changeUserPassword(UploadServer.User.DataUserID, txtPassword.Text)
        ' tell user the update was successful
        litJScript.Visible = True

    End Sub
End Class
