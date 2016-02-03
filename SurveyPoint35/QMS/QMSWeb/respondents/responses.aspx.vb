Partial Class frmResponses
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub
    Protected WithEvents hlDone As System.Web.UI.WebControls.HyperLink

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Public Const RESPONDENT_ID_KEY As String = "id"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then InitPage()
    End Sub

    Private Sub InitPage()

        If IsNumeric(Request.QueryString(RESPONDENT_ID_KEY)) Then
            Dim respondentID As Integer = CInt(Request.QueryString(RESPONDENT_ID_KEY))
            Dim conn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

            QMS.clsQMSTools.SetResponsesPointInTimeControl(conn, CType(ddlPointInTime, ListControl), respondentID)
            ddlPointInTime.Items.Insert(0, New ListItem("Now", DMI.clsUtil.DBNow(conn).ToString))
            ddlPointInTime.Items.Insert(0, New ListItem("All Entries", DMI.clsUtil.NULLDATE.ToString))

            QMS.clsQMSTools.FormatQMSDataGrid(dgReport)
            BindDataGrid(QMS.clsResponses.GetHistoricalResponses(conn, respondentID))
            conn.Dispose()

        Else
            DMI.WebFormTools.Msgbox(Page, "No respondent id specified")

        End If

    End Sub

    Private Sub BindDataGrid(ByVal dt As DataTable)
        Dim rowCount As Integer

        rowCount = DMI.clsDataGridTools.DataGridBind(dgReport, dt)
        lblResults.Text = String.Format("{0} entries found", rowCount)

    End Sub


    Private Sub ddlPointInTime_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPointInTime.SelectedIndexChanged
        Dim respondentID As Integer = CInt(Request.QueryString(RESPONDENT_ID_KEY))
        Dim conn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Dim pointInTime As DateTime
        Dim sort As String

        If ddlPointInTime.SelectedIndex > 0 Then
            pointInTime = CDate(ddlPointInTime.SelectedValue)
            sort = "SurveyQuestions.ItemOrder"
        Else
            pointInTime = DMI.clsUtil.NULLDATE
            sort = "Responses_jn.jn_datetime"
        End If

        BindDataGrid(QMS.clsResponses.GetHistoricalResponses(conn, respondentID, pointInTime, sort))
        If Not IsNothing(conn) Then
            conn.Close()
            conn.Dispose()
        End If

    End Sub
End Class
