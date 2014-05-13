Imports System.Web
Imports System.Web.Security

Public Class NRCAuthHttpModule
    Implements System.Web.IHttpModule

    Public Sub Dispose() Implements System.Web.IHttpModule.Dispose

    End Sub

    Public Sub Init(ByVal context As System.Web.HttpApplication) Implements System.Web.IHttpModule.Init
        AddHandler context.AuthenticateRequest, AddressOf OnAuthenticate
    End Sub

    Private Sub OnAuthenticate(ByVal sender As Object, ByVal e As EventArgs)
        FormsAuth.AttachUserPrincipal()
    End Sub
End Class
