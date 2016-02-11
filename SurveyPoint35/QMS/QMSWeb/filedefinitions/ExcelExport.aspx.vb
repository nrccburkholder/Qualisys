Partial Class ExcelExport
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Public Const EXPORT_FILE_KEY As String = "file"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Request.QueryString(EXPORT_FILE_KEY).Length > 0 Then
            Dim filepath As String = Server.MapPath(Request.QueryString(EXPORT_FILE_KEY).ToString)
            If FileExists(filepath) Then
                StreamFile(filepath)
            End If
        End If
    End Sub

    Public Shared Function GetURL(ByVal filepath As String) As String
        Return String.Format("{0}/filedefinitions/ExcelExport.aspx?{1}={2}", System.Web.HttpContext.Current.Request.ApplicationPath, EXPORT_FILE_KEY, HttpUtility.UrlEncode(filepath))
    End Function

    Private Function FileExists(ByVal filepath As String) As Boolean
        Dim fa As New System.IO.FileInfo(filepath)
        Return fa.Exists
    End Function

    Private Sub StreamFile(ByVal filepath As String)
        Dim sr As New IO.StreamReader(filepath)
        Dim line As String
        Response.ContentType = "application/vnd.ms-excel"
        Try
            Do
                line = sr.ReadLine
                If Not (line Is Nothing) Then Response.Write(line)
            Loop Until line Is Nothing
        Finally
            sr.Close()
            Response.End()
        End Try

    End Sub

End Class
