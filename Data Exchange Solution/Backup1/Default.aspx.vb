Imports System.IO
Imports System.Xml
Imports System.Web.Security.FormsAuthentication
Imports System.Web.Security
Public Class _Default
    Inherits System.Web.UI.Page
    Protected WithEvents lblMessage As System.Web.UI.WebControls.Label
    Protected WithEvents txtUserName As System.Web.UI.WebControls.TextBox
    Protected WithEvents vldUserName As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents ltlVerisign As System.Web.UI.WebControls.Literal
    Protected WithEvents ltlScanAlert As System.Web.UI.WebControls.Literal
    Protected WithEvents txtEMail As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtPassword As System.Web.UI.WebControls.TextBox
    Protected WithEvents imgDataExchange As System.Web.UI.HtmlControls.HtmlImage
    Protected WithEvents vldEmail As System.Web.UI.WebControls.RegularExpressionValidator
    Protected WithEvents btnLogin As System.Web.UI.WebControls.Button

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
        If Not Page.IsPostBack Then
            Me.txtUserName.Attributes.Add("onblur", "UserNameChanged(this.value);")
            Me.txtEMail.Style.Add("display", "none")
            Me.btnLogin.Style.Add("Border", "Solid 1px #CCCCCC")
            Me.btnLogin.Style.Add("Color", "#284775")
            Me.btnLogin.Style.Add("BACKGROUND-COLOR", "#fffbff")

            Select Case AppConfig.Instance.Locale
                Case AppConfig.LocaleEnum.USA
                    Me.imgDataExchange.Src = "Img/TOCDataExchangeUS.jpg"
                Case AppConfig.LocaleEnum.Canada
                    Me.imgDataExchange.Src = "Img/TOCDataExchangeCA.jpg"
            End Select
        End If
    End Sub

    Private Sub btnLogin_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        If Page.IsValid Then
            If txtUserName.Text = "" Then
                lblMessage.Text = "You must enter a valid user name!"
            ElseIf txtUserName.Text.ToLower = "anonymous" AndAlso txtEMail.Text = "" Then
                lblMessage.Text = "You must enter a valid password!"
            ElseIf Not txtUserName.Text.ToLower = "anonymous" AndAlso txtPassword.Text = "" Then
                lblMessage.Text = "You must enter a valid password!"
            Else
                If txtUserName.Text.ToLower = "anonymous" Then
                    AuthenticateUser(txtUserName.Text, txtEMail.Text)
                Else
                    AuthenticateUser(txtUserName.Text, txtPassword.Text)
                End If
            End If
        End If
    End Sub

    Private Sub AuthenticateUser(ByVal UserName As String, ByVal Password As String)
        Dim UploadServer As New UploadServer
        Dim strRole(0) As String

        If UploadServer.Authenticate(UserName, Password) Then
            Session("UploadServer") = UploadServer
            SetAuthCookie(UserName, False)

            Dim objTicket As New FormsAuthenticationTicket(1, UserName, DateTime.Now, DateTime.Now.AddHours(60), False, UploadServer.User.Roles)
            Dim strEncrypted As String = Encrypt(objTicket)
            Dim objCookie As New HttpCookie(FormsCookieName, strEncrypted)
            Response.Cookies.Add(objCookie)

            If Not UploadServer.User.Roles.IndexOf("AdminUser") = -1 Then
                If Not UploadServer.User.Password = AppConfig.Instance.DefaultPassword Then
                    Response.Redirect("Admin.aspx", False)
                Else
                    Response.Redirect("changePassword.aspx?msg=pw")
                End If
            ElseIf Not UploadServer.User.Roles.IndexOf("PostUser") = -1 Then
                If Not UploadServer.User.Password = AppConfig.Instance.DefaultPassword Then
                    Response.Redirect("PostFile.aspx", False)
                Else
                    Response.Redirect("changePassword.aspx?msg=pw")
                End If

            ElseIf Not UploadServer.User.Roles.IndexOf("UploadUser") = -1 Then
                Response.Redirect("Upload.aspx", False)
            ElseIf Not UploadServer.User.Roles.IndexOf("DownloadUser") = -1 Then
                Response.Redirect("Download.aspx", False)
            End If
        Else
            lblMessage.Text = "Access denied.  You must enter a vaild user name and password."
        End If
    End Sub
End Class
