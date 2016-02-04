Partial Class frmLogin
    Inherits System.Web.UI.Page

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

    Public Const PRIVLEDGES_SESSION_KEY As String = "Privledges"
    Private m_iUserID As Integer = 0

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Request.QueryString("signout") <> "" Then
            System.Web.Security.FormsAuthentication.SignOut()
            Session.Abandon()
            Response.Redirect("default.aspx")

        End If

    End Sub

    Public Sub ValidateLogin(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim oConn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Dim oUser As New QMS.clsUsers(oConn)

        Try
            If oUser.SignInUser(tbEmail.Text, tbPassword.Text, Session.SessionID) Then
                m_iUserID = CInt(oUser.MainDataTable.Rows(0).Item("UserID"))
                Session(PRIVLEDGES_SESSION_KEY) = oUser.Privledges()

                If CType(Session(PRIVLEDGES_SESSION_KEY), ArrayList).Count > 0 Then
                    args.IsValid = True

                Else

                    cuvValidateLogin.ErrorMessage = "Cannot login, account has no privledges. Please contact the administrator."
                    args.IsValid = False

                End If

            Else
                cuvValidateLogin.ErrorMessage = "Incorrect username password combination. Try again or contact the administrator."
                args.IsValid = False

            End If
            If oUser.MainDataTable IsNot Nothing AndAlso oUser.MainDataTable.Rows.Count > 0 Then
                Session("WelcomeText") = "Welcome " & CStr(oUser.MainDataTable.Rows(0).Item("UserName")) & "!  You are logged into " & ConfigurationManager.AppSettings("EnvironmentName")
            End If
        Catch ex As Exception
            clsLog.LogError(GetType(frmEvents), "ValidateLogin", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        Finally
            oUser = Nothing
            If Not IsNothing(oConn) Then
                oConn.Close()
                oConn.Dispose()
                oConn = Nothing
            End If
        End Try


    End Sub

    Private Sub cmdSignin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdSignin.Click
        If Page.IsValid Then            
            System.Web.Security.FormsAuthentication.RedirectFromLoginPage(m_iUserID, False)
        End If


    End Sub

End Class
