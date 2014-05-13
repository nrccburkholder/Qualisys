Partial Public Class _Error
    Inherits System.Web.UI.Page

    Private ReadOnly Property IsInternalRequest() As Boolean
        Get
            Dim strIPAddr As String = HttpContext.Current.Request.ServerVariables("REMOTE_ADDR")
            Return (strIPAddr.StartsWith("10.10.") Or strIPAddr.StartsWith("127.0.0.1"))
        End Get
    End Property


    ''' <summary>When error page loads, page_loads fires. Duh.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    ''' 

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            'set the uploads to state of upload abandoned
            Dim myUploads = TryCast(Context.Session("MyUploads"), NRC.DataLoader.Library.UploadFileCollection)
            For Each TempUpload As NRC.DataLoader.Library.UploadFile In myUploads
                TempUpload.UploadFileState.StateOfUpload = NRC.DataLoader.Library.UploadState.GetByName(NRC.DataLoader.Library.UploadState.AvailableStates.UploadAbandoned)
            Next
        Catch ex As Exception
        Finally
            'Clear the local context.session variables; Toni P provided the code.
            Context.Session("MyUploads") = Nothing
            Context.Session("UploadStates") = Nothing
            Context.Session("DTSPackages") = Nothing
        End Try

        Dim showStack As Boolean = False
        If CurrentUser.IsAuthenticated Then
            showStack = CurrentUser.Principal.IsInRole("NRCUser")
        Else
            showStack = Me.IsInternalRequest
        End If
        If showStack Then
            Me.StackTraceDiv.Visible = True
            If Not SessionInformation.LastException Is Nothing Then
                Try
                    Dim errorText As String = SessionInformation.LastException.ToString
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