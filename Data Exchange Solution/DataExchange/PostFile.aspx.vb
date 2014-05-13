Public Class PostFile
    Inherits System.Web.UI.Page
    Protected WithEvents txtFName As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtLName As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtEmail As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtDescription As System.Web.UI.WebControls.TextBox
    Protected WithEvents inpFile As System.Web.UI.HtmlControls.HtmlInputFile
    Protected WithEvents lblMessage As System.Web.UI.WebControls.Label
    Protected WithEvents txtNotes As System.Web.UI.WebControls.TextBox
    Protected WithEvents btnUpload As System.Web.UI.WebControls.Button

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
        lblMessage.Text = ""
    End Sub

    Private Sub btnUpload_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpload.Click
        Dim strOldFileName As String = inpFile.PostedFile.FileName
        Dim strNewFilePath As String
        Dim strNewFileName As String
        Dim strFName As String
        Dim strLName As String
        Dim strEmail As String
        Dim strDescription As String
        Dim strNotes As String
        Dim intDownloadUser_id As Integer

        strFName = txtFName.Text
        strLName = txtLName.Text
        strEmail = txtEmail.Text
        strDescription = txtDescription.Text
        strNotes = txtNotes.Text

        If Not strOldFileName = "" Then
            UploadServer.GetNewFileName(UploadServer.Role.PostUser, strOldFileName, strNewFilePath, strNewFileName)
            intDownloadUser_id = UploadServer.CreateNewDownloadUser(strFName, strLName, strEmail)
            UploadServer.PostNewFile(intDownloadUser_id, strOldFileName, strNewFilePath, strNewFileName, strDescription, strNotes)
            inpFile.PostedFile.SaveAs(strNewFilePath & strNewFileName)
            lblMessage.Text = "<script language=""javascript"">alert('Your file has been uploaded successfully.');</script>"
        Else
            lblMessage.Text = "You must select a file to upload!"
        End If
    End Sub

    Private Function UploadServer() As UploadServer
        Return Session("UploadServer")
    End Function
End Class
