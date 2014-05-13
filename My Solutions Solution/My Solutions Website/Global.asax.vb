Imports System.Web.SessionState

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Private Delegate Sub CleanUpMethod()
    Private mCleanUpMethod As New CleanUpMethod(AddressOf FolderCleanup)

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        SharedMethods.SetupNrcAuthSettings()
        SharedMethods.SetupWebDocSettings()
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
        mCleanUpMethod.BeginInvoke(Nothing, Nothing)
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires at the beginning of each request
        If Config.UseSsl Then
            If Not Request.Url.Port = 443 AndAlso Not Request.Url.ToString.ToLower.Contains("movieplayer.aspx") Then
                Response.Redirect(Request.Url.ToString.Replace("http:", "https:"))
            End If
        End If
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)

    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
    End Sub

    Private Sub FolderCleanup()
        SharedMethods.TempFolderCleanUp("eToolKit/temp_img", "*.png")
    End Sub

End Class