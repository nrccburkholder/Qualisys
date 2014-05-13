Public Class UploadLog
    Inherits System.Web.UI.Page
    Protected WithEvents btnExport As System.Web.UI.WebControls.ImageButton
    Protected WithEvents StartDate As eWorld.UI.CalendarPopup
    Protected WithEvents trDateSelection As System.Web.UI.HtmlControls.HtmlTableRow
    Protected WithEvents EndDate As eWorld.UI.CalendarPopup
    Protected WithEvents btnGo As System.Web.UI.WebControls.ImageButton
    Protected WithEvents dgLog As System.Web.UI.WebControls.DataGrid

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

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load    
        If Not Page.IsPostBack Then
            Me.StartDate.SelectedDate = Date.Now.AddDays(-7)
            Me.EndDate.SelectedDate = Date.Now
            BindGrid()
        End If
    End Sub

    Friend Function UploadServer() As UploadServer
        If Not Session("UploadServer") Is Nothing Then
            Return CType(Session("UploadServer"), UploadServer)
        End If
    End Function

    Private Sub btnExport_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnExport.Click
        Response.ContentType = "application/vnd.ms-excel"
        Response.Charset = ""
        EnableViewState = False
        Me.btnExport.Visible = False
        Me.trDateSelection.Visible = False
        dgLog.AllowPaging = False
        BindGrid()
    End Sub

    Private Sub dgLog_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgLog.PageIndexChanged
        dgLog.CurrentPageIndex = e.NewPageIndex
        BindGrid()
    End Sub

    Private Sub BindGrid()
        dgLog.DataSource = UploadServer.GetUploadLog(StartDate.SelectedDate, EndDate.SelectedDate)
        dgLog.DataBind()
    End Sub

    Private Overloads Sub btnGo_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnGo.Click
        dgLog.CurrentPageIndex = 0
        BindGrid()
    End Sub
End Class
