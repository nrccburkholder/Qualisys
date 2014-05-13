Public Partial Class Error_Error
    Inherits ToolKitPage

    Private ReadOnly Property IsInternalRequest() As Boolean
        Get
            Dim strIPAddr As String = HttpContext.Current.Request.ServerVariables("REMOTE_ADDR")
            Return (strIPAddr.StartsWith("10.10.") Or strIPAddr.StartsWith("127.0.0.1"))
        End Get
    End Property

    Protected Overrides ReadOnly Property LogPageExceptions() As Boolean
        Get
            Return False
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim showStack As Boolean = False
        If CurrentUser.IsAuthenticated Then
            showStack = CurrentUser.Principal.IsInRole("NRCUser")
        Else
            showStack = Me.IsInternalRequest
        End If

        If showStack Then
            Me.StackTraceDiv.Visible = True
            If Not SessionInfo.LastException Is Nothing Then
                Try
                    Dim errorText As String = SessionInfo.LastException.ToString
                    Dim parts() As String = errorText.Split(New String() {vbCrLf}, StringSplitOptions.RemoveEmptyEntries)
                    Me.StackTraceLiteral.Text = parts(0)
                    Me.StackTraceLiteral.Text &= "<ul>"
                    For i As Integer = 1 To parts.Length - 1
                        Me.StackTraceLiteral.Text &= "<li>" & parts(i) & "</li>"
                    Next
                    Me.StackTraceLiteral.Text &= "</ul>"
                Catch ex As Exception
                    Me.StackTraceLiteral.Text = "Exception information not available."
                End Try
            Else
                Me.StackTraceLiteral.Text = "Exception information not available."
            End If

        End If
    End Sub

End Class