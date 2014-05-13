Imports System.Web.SessionState

Public Class Global_asax
    Inherits System.Web.HttpApplication

    ''' <summary>Start event for the web application.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>TP 20080404</term>
    ''' <description>Added call to
    ''' sharedmethods.SetupDatamartSettings.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    ''' 
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application is started
        SharedMethods.SetupNrcAuthSettings()

        'TP 20080404
        SharedMethods.SetupDataMartSettings()        
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the session is started
       
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires at the beginning of each request
        If Config.UseSsl And Request.Url.ToString.ToLower.Contains("http:") Then
            Response.Redirect(Request.Url.ToString.Replace("http:", "https:"))
        End If
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires upon attempting to authenticate the use
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when an error occurs
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("SignIn.aspx")
        ' Fires when the session ends
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Fires when the application ends
    End Sub

End Class