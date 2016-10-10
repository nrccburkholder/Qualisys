Imports System.Web
Imports System.Web.SessionState
Imports System.Security.Principal
Imports System.Web.Security

Public Class Global
    Inherits System.Web.HttpApplication

#Region " Component Designer Generated Code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Component Designer
    'It can be modified using the Component Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container()
    End Sub

#End Region

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application is started
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires at the beginning of each request
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
        Dim strCookieName As String = FormsAuthentication.FormsCookieName
        Dim objCookie As HttpCookie = Context.Request.Cookies(strCookieName)

        If objCookie Is Nothing Then
            Exit Sub
        End If

        Dim objTicket As FormsAuthenticationTicket = Nothing
        Try
            objTicket = FormsAuthentication.Decrypt(objCookie.Value)
        Catch
            Exit Sub
        End Try

        If objTicket Is Nothing Then
            Exit Sub
        End If

        Dim strRoles As String() = objTicket.UserData.Split("|")
        Dim objFormID As New FormsIdentity(objTicket)

        'This principal will flow throughout the request.
        Dim objPrincipal As New GenericPrincipal(objFormID, strRoles)
        'Attach the new principal object to the current HttpContext object
        Context.User = objPrincipal
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs
        Try
            Dim objUploadServer As UploadServer = Session("UploadServer")
            objUploadServer.LastException = HttpContext.Current.Server.GetLastError
        Catch
        End Try
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session ends

        'Delete all the expired files
        UploadServer.DeleteExpiredFiles()
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
    End Sub

    Private Sub Global_BeginRequest(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.BeginRequest
        If Not Request.Url.Port = 443 AndAlso AppConfig.Instance.UseSSL Then
            Response.Redirect(Request.Url.ToString.Replace("http:", "https:"), False)
        End If
    End Sub
End Class
