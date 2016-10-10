Imports System.Web.Mail
Public Class Feedback
    Inherits System.Web.UI.Page
    Protected WithEvents txtComment As System.Web.UI.WebControls.TextBox
    Protected WithEvents btnSend As System.Web.UI.WebControls.Button

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
        'Put user code to initialize the page here
        If Not Page.IsPostBack Then
            Session("LastPage") = Request.UrlReferrer.ToString
        End If
    End Sub

    Private Sub btnSend_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSend.Click
        Dim objUploadServer As UploadServer = Session("UploadServer")
        objUploadServer.EmailFeedBack(txtComment.Text.Replace(vbCrLf, "<br>"))
        Response.Redirect(Session("LastPage"))
    End Sub
End Class
