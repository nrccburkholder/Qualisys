Public Class Admin
    Inherits System.Web.UI.Page
    Protected WithEvents txtFName As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtLName As System.Web.UI.WebControls.TextBox
    Protected WithEvents btnSubmit As System.Web.UI.WebControls.Button
    Protected WithEvents rbUserType As System.Web.UI.WebControls.RadioButtonList
    Protected WithEvents lblNewUserMessage As System.Web.UI.WebControls.Label
    Protected WithEvents txtPassword As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtPasswordConfirm As System.Web.UI.WebControls.TextBox
    Protected WithEvents lblDefaultPassword As System.Web.UI.WebControls.Label
    Protected WithEvents txtEmail As System.Web.UI.WebControls.TextBox

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
        lblNewUserMessage.Text = ""
        lblDefaultPassword.Text = AppConfig.Instance.DefaultPassword
    End Sub

    Private Sub btnSubmit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        If txtFName.Text = "" Or txtLName.Text = "" Or txtEmail.Text = "" Or txtPassword.Text = "" Or txtPasswordConfirm.Text = "" Then
            lblNewUserMessage.Text = "You must complete all fields!"
            Exit Sub
        End If
        If Not txtPassword.Text = txtPasswordConfirm.Text Then
            lblNewUserMessage.Text = "The passwords do not match, please try again!"
            Exit Sub
        End If

        Dim UploadServer As UploadServer = Session("UploadServer")

        Select Case rbUserType.SelectedItem.Value
            Case "Post User"
                UploadServer.CreateNewPostUser(txtFName.Text, txtLName.Text, txtEmail.Text, txtPassword.Text)
            Case "Admin User"
                UploadServer.CreateNewAdminUser(txtFName.Text, txtLName.Text, txtEmail.Text, txtPassword.Text)
        End Select
        lblNewUserMessage.Text = "User created successfully."
    End Sub
End Class
