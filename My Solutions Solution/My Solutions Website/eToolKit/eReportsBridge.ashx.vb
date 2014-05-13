Imports System.Web
Imports System.Web.Services
Imports Nrc.DataMart.MySolutions.Library.Legacy

Public Class eToolKit_eReportsBridge
    Implements System.Web.IHttpHandler
    Implements IReadOnlySessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest
        Dim type As String = context.Request.QueryString("Type")
        Dim questionId As Integer = SessionInfo.SelectedQuestionId
        Dim reportId As Integer
        Select Case type.ToLower
            Case "trend"
                reportId = SessionInfo.EToolKitServer.RegisterReport(questionId, ToolkitServer.EReportsChartType.TrendChart)
            Case "control"
                reportId = SessionInfo.EToolKitServer.RegisterReport(questionId, ToolkitServer.EReportsChartType.ControlChart)
        End Select
        Dim url As String = Config.eReportsUrl & "/" & String.Format(Config.eReportsLinkPage, reportId)
        context.Response.Redirect(url)
    End Sub

    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class