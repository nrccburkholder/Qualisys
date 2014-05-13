Imports System.Web
Imports System.Web.Services

Public Class eToolKit_eCommentsBridge
    Implements System.Web.IHttpHandler
    Implements IReadOnlySessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        context.Response.ContentType = "text/html"
        Me.WriteResponse(context.Response.Output)
    End Sub

    Private Sub WriteResponse(ByVal writer As IO.TextWriter)
        writer.WriteLine("<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">")
        writer.WriteLine("<html>")
        writer.WriteLine("<head>")
        writer.WriteLine("<script type=""text/javascript"">")
        writer.WriteLine("function LoadComments(){")
        writer.WriteLine("var theForm = document.forms['Form1'];")
        writer.WriteLine("if (!theForm) {theForm = document.Form1;}")
        writer.WriteLine("theForm.submit();")
        writer.WriteLine("}")
        writer.WriteLine("</script>")
        writer.WriteLine("</head>")

        writer.WriteLine("<body>")
        Me.WriteForm(writer)
        writer.WriteLine("</body>")

        writer.WriteLine("</html>")
    End Sub

    Private Sub WriteForm(ByVal writer As IO.TextWriter)
        Dim commentsUrl As String = Config.eCommentsUrl & "/" & Config.eCommentsLinkPage
        Dim strDateField As String
        Dim strStartDate As String
        Dim strEndDate As String
        Dim strUnits As String
        Dim strCodes As String

        'Setup the report
        strDateField = "CutoffDate"
        Dim preference As Nrc.DataMart.MySolutions.Library.MemberGroupReportPreference = SessionInfo.EToolKitServer.MemberGroupPreference
        strStartDate = preference.ReportStartDate.ToShortDateString
        strEndDate = preference.ReportEndDate.ToShortDateString

        Dim arrValues As String() = SessionInfo.EToolKitServer.GetCommentsUnits
        Dim strValues As String = ""
        Dim i As Integer
        For i = 0 To arrValues.Length - 1
            strValues &= arrValues(i) & "|"
        Next
        strValues = strValues.Substring(0, strValues.Length - 1)
        strUnits = strValues

        strValues = ""
        arrValues = SessionInfo.EToolKitServer.GetCommentsCodedAs
        For i = 0 To arrValues.Length - 1
            strValues &= arrValues(i) & "|"
        Next
        strValues = strValues.Substring(0, strValues.Length - 1)
        strCodes = strValues


        writer.WriteLine("<form id=""Form1"" name=""Form1"" action=""" & commentsUrl & """ method=""post"">")
        writer.WriteLine("<input type=""hidden"" id=""hdnDateField"" name=""hdnDateField"" value=""" & strDateField & """>")
        writer.WriteLine("<input type=""hidden"" id=""hdnStartDate"" name=""hdnStartDate"" value=""" & strStartDate & """>")
        writer.WriteLine("<input type=""hidden"" id=""hdnEndDate"" name=""hdnEndDate"" value=""" & strEndDate & """>")
        writer.WriteLine("<input type=""hidden"" id=""hdnUnits"" name=""hdnUnits"" value=""" & strUnits & """>")
        writer.WriteLine("<input type=""hidden"" id=""hdnCodes"" name=""hdnCodes"" value=""" & strCodes & """>")
        writer.WriteLine("<script type=""text/javascript"">")
        writer.WriteLine("LoadComments();")
        writer.WriteLine("</script>")
        writer.WriteLine("</form>")
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class