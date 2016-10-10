Imports System.Web.Mail
Public Class _Error
    Inherits System.Web.UI.Page
    Protected WithEvents lblErrorMessage As System.Web.UI.WebControls.Label
    Protected WithEvents lblTryAgain As System.Web.UI.WebControls.Label
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
        'Put user code to initialize the page here
        Dim objUploadServer As UploadServer = Session("UploadServer")

        If Not objUploadServer Is Nothing Then
            objUploadServer.EmailErrorMessage()
        End If

    End Sub


End Class
