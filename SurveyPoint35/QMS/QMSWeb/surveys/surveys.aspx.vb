Partial Class frmSurveys
    Inherits System.Web.UI.Page

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

    Private m_oSurveys As QMS.clsSurveys
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oSurveys = New QMS.clsSurveys(m_oConn)
        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'Survey has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub PageLoad()
        'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        ViewState("LastSort") = "Active DESC, Name"
        ViewState("search") = ""

        'fill main table
        BuildSearch()
        LoadDataSet()

        'format datagrid
        dgSurveys.DataKeyField = "SurveyID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveys)
        SurveysGridBind()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveys) Then
            m_oSurveys.Close()
            m_oSurveys = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oSurveys.RestoreSearch(ViewState("search").ToString, m_sDSName)
        m_oSurveys.FillUsers()
        m_oSurveys.FillMain(drCriteria)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsSurveys.SearchRow

        dr = CType(m_oSurveys.NewSearchRow, QMS.dsSurveys.SearchRow)

        If IsNumeric(tbSurveyID.Text) Then dr.SurveyID = CInt(tbSurveyID.Text)
        If tbKeywordSearch.Text <> "" Then dr.Keyword = String.Format("%{0}%", tbKeywordSearch.Text)
        If cbActive.Checked Then dr.Active = 1

        ViewState("search") = m_oSurveys.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub SurveysGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oSurveys.DataGridBind(dgSurveys, ViewState("LastSort").ToString)
        ltResultsFound.Text = String.Format("{0} Surveys", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SURVEY_DESIGNER) Then
            'must be survey designer to add questions to a survey
            hlAdd.Visible = False
            ibDelete.Visible = False

        End If

    End Sub

    Private Sub dgSurveys_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgSurveys.PageIndexChanged
        LoadDataSet()
        m_oSurveys.DataGridPageChange(dgSurveys, e, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub dgSurveys_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgSurveys.SortCommand
        LoadDataSet()
        Viewstate("LastSort") = m_oSurveys.DataGridSort(dgSurveys, e, Viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        LoadDataSet()
        m_oSurveys.DataGridDelete(dgSurveys, viewstate("LastSort").ToString)
        PageCleanUp()

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        BuildSearch()
        LoadDataSet()
        dgSurveys.CurrentPageIndex = 0
        SurveysGridBind()
        PageCleanUp()

    End Sub

    Private Sub dgSurveys_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgSurveys.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set survey name column
            CType(e.Item.FindControl("ltSurveyName"), Literal).Text = String.Format("<b>{0}</b><br>{1}", drv.Item("Name"), drv.Item("Description"))
            'set author name column
            CType(e.Item.FindControl("ltAuthorName"), Literal).Text = drv.Row.GetParentRow("UsersSurveys").Item("Username")

        End If

    End Sub

End Class
