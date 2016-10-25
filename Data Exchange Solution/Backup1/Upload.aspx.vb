Imports System.IO
Imports System.Text
Imports System.Web.Mail
Public Class Upload
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "
    Protected WithEvents txtFName As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtLName As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtBeginDate As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtEndDate As System.Web.UI.WebControls.TextBox
    Protected WithEvents ddlFileType As System.Web.UI.WebControls.DropDownList
    Protected WithEvents inpFile As System.Web.UI.HtmlControls.HtmlInputFile
    Protected WithEvents vldFName As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents vldLName As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents txtDescription As System.Web.UI.WebControls.TextBox
    Protected WithEvents btnUpload As System.Web.UI.HtmlControls.HtmlInputButton
    Protected WithEvents rbUpload As System.Web.UI.WebControls.RadioButtonList
    Protected WithEvents tdUploadMethod As System.Web.UI.HtmlControls.HtmlTableCell
    Protected WithEvents txtStudyID As System.Web.UI.WebControls.TextBox
    Protected WithEvents txtFacility As System.Web.UI.WebControls.TextBox
    Protected WithEvents RequiredFieldValidator1 As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents lblEmail As System.Web.UI.WebControls.Label
    Protected WithEvents pnlUserInfo As NRC.Web.CollapsePanel
    Protected WithEvents vldBeginDate As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents vldEndDate As System.Web.UI.WebControls.RequiredFieldValidator
    Protected WithEvents pnlFileInfo As NRC.Web.CollapsePanel

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Protected ReadOnly Property BrandName() As String
        Get
            Return AppConfig.Instance.BrandName
        End Get
    End Property

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            lblEmail.Text = "<b>Current User:</b> " & UploadServer.User.Email
            ddlFileType.SelectedValue = 1
            RestoreUserSettings()
            tdUploadMethod.Visible = False

            'Select Case AppConfig.Instance.Locale
            '    Case AppConfig.LocaleEnum.USA
            '        Me.lnkInstructions.HRef = "InstructionsUS.pdf"
            '    Case AppConfig.LocaleEnum.Canada
            '        Me.lnkInstructions.HRef = "InstructionsCA.pdf"

            'End Select
        End If
    End Sub

    Private Sub btnUpload_ServerClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpload.ServerClick
        Page.Validate()
        If Page.IsValid Then
            If Not inpFile.PostedFile.FileName = "" Then
                StoreUserSettings(txtFName.Text, txtLName.Text, txtFacility.Text, txtStudyID.Text, txtDescription.Text, txtBeginDate.Text, txtEndDate.Text, ddlFileType.SelectedValue)
                UploadServer.User.FirstName = txtFName.Text
                UploadServer.User.LastName = txtLName.Text
                UploadServer.FileToUpload.FacilityName = txtFacility.Text
                UploadServer.FileToUpload.StudyID = txtStudyID.Text
                UploadServer.FileToUpload.Description = IIf(txtDescription.Text = "", "<no description>", txtDescription.Text)
                UploadServer.FileToUpload.BeginDate = txtBeginDate.Text
                UploadServer.FileToUpload.EndDate = txtEndDate.Text
                UploadServer.FileToUpload.FileType = ddlFileType.SelectedItem.Text
                SaveFile()
                Response.Redirect("Thankyou.aspx")
            End If
        End If
    End Sub

    Private Const SETTINGSCOOKIE = "DataExchangeSettings"
    Private Const SERIALSTRING = "<FName>{0}</FName><LName>{1}</LName><FacName>{2}</FacName><Study>{3}</Study><Desc>{4}</Desc><Begin>{5}</Begin><End>{6}</End><Type>{7}</Type>"

    Private Sub StoreUserSettings(ByVal fName As String, ByVal lName As String, ByVal facility As String, ByVal studyId As String, ByVal description As String, ByVal beginDate As String, ByVal endDate As String, ByVal fileType As String)
        Try
            Dim settings As New HttpCookie(SETTINGSCOOKIE)
            settings.Path = "/"
            settings.Value = HttpUtility.UrlEncode(String.Format(SERIALSTRING, fName, lName, facility, studyId, description, beginDate, endDate, fileType))
            settings.Expires = DateTime.Now.AddYears(1)
            Response.Cookies.Add(settings)
        Catch ex As Exception
        End Try
    End Sub
    Private Sub RestoreUserSettings()
        Dim settings As HttpCookie = Request.Cookies(SETTINGSCOOKIE)
        If Not settings Is Nothing Then
            Try
                Dim regExString As String = String.Format(SERIALSTRING, "(.*)", "(.*)", "(.*)", "(.*)", "(.*)", "(.*)", "(.*)", "(.*)")
                Dim regEx As New System.Text.RegularExpressions.Regex(regExString, RegularExpressions.RegexOptions.IgnoreCase)
                Dim match As System.Text.RegularExpressions.Match

                match = regEx.Match(HttpUtility.UrlDecode(settings.Value))

                txtFName.Text = match.Groups(1).Value
                txtLName.Text = match.Groups(2).Value
                txtFacility.Text = match.Groups(3).Value
                txtStudyID.Text = match.Groups(4).Value
                txtDescription.Text = match.Groups(5).Value
                txtBeginDate.Text = match.Groups(6).Value
                txtEndDate.Text = match.Groups(7).Value
                ddlFileType.SelectedValue = match.Groups(8).Value
            Catch ex As Exception
            End Try

        End If

    End Sub

    Private Sub SaveFile()
        Dim strOldFileName As String = inpFile.PostedFile.FileName
        Dim strNewFileName As String
        Dim strNewFilePath As String

        UploadServer.GetNewFileName(UploadServer.Role.UploadUser, strOldFileName, strNewFilePath, strNewFileName)

        UploadServer.FileToUpload.FileNameOld = strOldFileName
        UploadServer.FileToUpload.FileNameNew = strNewFileName
        UploadServer.FileToUpload.FileSize = inpFile.PostedFile.ContentLength

        'Select Case rbUpload.SelectedItem.Value
        '    Case 1 '.NET Upload
        '        inpFile.PostedFile.SaveAs(UploadServer.FileSaveLocation & UploadServer.FileNewName)
        '        'inpFile.PostedFile.SaveAs(UploadServer.FileBkupLocation & UploadServer.FileNewName)
        '    Case 2 'ABCUpload

        Dim objUpload As New WebSupergoo.ABCUpload5.Upload
        Dim objFile As WebSupergoo.ABCUpload5.UploadedFile
        objFile = objUpload.Files(inpFile.UniqueID)
        If objFile Is Nothing OrElse Not objFile.Exists Then Exit Sub
        If objFile.ContentLength > 0 Then
            If objFile.TempFile = "" Or objFile.MacBinary Then
                objFile.SaveAs(strNewFilePath & strNewFileName)
            Else
                Dim Path As String = strNewFilePath * strNewFileName
                System.IO.File.Move(objFile.Detach, Path)
            End If
        End If
        'End Select

        UploadServer.LogUpload()
        UploadServer.EmailUploadNotification()
        UploadServer.EmailUploadReceipt()
    End Sub

    Friend Function UploadServer() As UploadServer
        If Not Session("UploadServer") Is Nothing Then
            Return CType(Session("UploadServer"), UploadServer)
        End If
    End Function

End Class
