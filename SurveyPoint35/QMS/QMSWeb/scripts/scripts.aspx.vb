Partial Class frmScripts
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

	Private Const LAST_SORT_KEY As String = "LastSort"
	Private Const SEARCH_KEY As String = "search"

	Private m_oScripts As QMS.clsScripts
	Private m_oConn As SqlClient.SqlConnection
	Private m_sDSName As String

	Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
		m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
		m_oScripts = New QMS.clsScripts(m_oConn)
		m_sDSName = Request.Url.AbsolutePath

		'Determine whether page setup is required:
		'user has posted back to same page
		If Not Page.IsPostBack Then PageLoad()
	End Sub

	Private Sub PageLoad()
		'security check
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanup()

        Else
            'Survey does not have Survey viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))
        End If
    End Sub

    Private Sub PageSetup()
        'setup sort variable
        ViewState(LAST_SORT_KEY) = ""
        ViewState(SEARCH_KEY) = ""

        'fill main table
        InitSearchForm()
        BuildSearch()
        LoadDataSet()

        'format datagrid
        dgScripts.DataKeyField = "ScriptID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgScripts)
        ScriptsGridBind()

    End Sub

    Private Sub ScriptsGridBind()
        Dim iRowCount As Integer

        iRowCount = m_oScripts.DataGridBind(dgScripts, ViewState(LAST_SORT_KEY).ToString)
        ltResultsFound.Text = String.Format("{0} Scripts", iRowCount)

    End Sub

    Private Sub PageCleanup()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oScripts) Then
            m_oScripts.Close()
            m_oScripts = Nothing
        End If
    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oScripts.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oScripts.FillLookups(drCriteria)
        m_oScripts.FillMain(drCriteria)
    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsScripts.SearchRow

        dr = CType(m_oScripts.NewSearchRow, QMS.dsScripts.SearchRow)

        If tbScriptIDSearch.Text.Length > 0 Then dr.ScriptID = CInt(tbScriptIDSearch.Text)
        If tbKeywordSearch.Text.Length > 0 Then dr.Keyword = String.Format("%{0}%", tbKeywordSearch.Text)
        If ddlSurveyIDSearch.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyIDSearch.SelectedItem.Value)
        If ddlScriptTypeIDSearch.SelectedIndex > 0 Then dr.ScriptTypeID = CInt(ddlScriptTypeIDSearch.SelectedItem.Value)

        ViewState(SEARCH_KEY) = m_oScripts.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub InitSearchForm()
        Dim iSurveyID As Integer
        Dim qScripts As New QMS.clsScripts(m_oConn)
        qScripts.FillLookups(qScripts.NewSearchRow)

        'setup page controls
        ddlSurveyIDSearch.DataSource = qScripts.SurveysTable   'clsQMSTools.GetSurveyDataSource(True)	 'm_oScripts.SurveyNamesTable
        ddlSurveyIDSearch.DataTextField = "Name"
        ddlSurveyIDSearch.DataValueField = "SurveyID"
        ddlSurveyIDSearch.DataBind()
        ddlSurveyIDSearch.Items.Insert(0, New ListItem("Select Survey", "0"))

        ddlSurveyIDAction.DataSource = qScripts.SurveysTable
        ddlSurveyIDAction.DataTextField = "Name"
        ddlSurveyIDAction.DataValueField = "SurveyID"
        ddlSurveyIDAction.DataBind()
        ddlSurveyIDAction.Items.Insert(0, New ListItem("Select Survey", "0"))

        ddlScriptTypeIDSearch.DataSource = qScripts.ScriptTypesTable
        ddlScriptTypeIDSearch.DataTextField = "Name"
        ddlScriptTypeIDSearch.DataValueField = "ScriptTypeID"
        ddlScriptTypeIDSearch.DataBind()
        ddlScriptTypeIDSearch.Items.Insert(0, New ListItem("Select Type", "0"))

        If IsNumeric(Request.QueryString("sid")) Then
            iSurveyID = Integer.Parse(Request.QueryString("sid"))
            ddlSurveyIDSearch.SelectedIndex = ddlSurveyIDSearch.Items.IndexOf(ddlSurveyIDSearch.Items.FindByValue(iSurveyID.ToString))
            ddlSurveyIDAction.SelectedIndex = ddlSurveyIDAction.Items.IndexOf(ddlSurveyIDAction.Items.FindByValue(iSurveyID.ToString))

        End If

        SetAutoScriptLink()

        qScripts.Close()
        qScripts = Nothing
    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SCRIPT_DESIGNER) Then
            'must be script designer to add or delete scripts
            ddlSurveyIDAction.Enabled = False
            ibDelete.Enabled = False
        End If
    End Sub

    Private Sub dgScripts_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgScripts.PageIndexChanged
        LoadDataSet()
        m_oScripts.DataGridPageChange(dgScripts, e, viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()
    End Sub

    Private Sub dgScripts_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgScripts.SortCommand
        LoadDataSet()
        Viewstate(LAST_SORT_KEY) = m_oScripts.DataGridSort(dgScripts, e, Viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()
    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        LoadDataSet()
        m_oScripts.DataGridDelete(dgScripts, viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()
    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        If Page.IsValid Then
            BuildSearch()
            LoadDataSet()
            dgScripts.CurrentPageIndex = 0
            ScriptsGridBind()

        End If
        PageCleanup()
    End Sub

    Private Sub dgScripts_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgScripts.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set survey name column
            CType(e.Item.FindControl("ltSurveyName"), Literal).Text = drv.Row.GetParentRow("SurveysScripts").Item("Name")
            'set script type name column
            CType(e.Item.FindControl("ltScriptTypeName"), Literal).Text = drv.Row.GetParentRow("ScriptTypesScripts").Item("Name")
        End If

    End Sub

    Private Sub ddlSurveyIDAction_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ddlSurveyIDAction.SelectedIndexChanged
        LoadDataSet()
        ScriptsGridBind()
        SetAutoScriptLink()
        PageCleanup()

    End Sub

    Private Sub SetAutoScriptLink()
        If ddlSurveyIDAction.SelectedIndex > 0 Then
            hlAutoScript.NavigateUrl = String.Format("scriptdetails.aspx?auto={0}", ddlSurveyIDAction.SelectedItem.Value)

        Else
            hlAutoScript.NavigateUrl = "javascript:alert('Please select a survey')"

        End If

    End Sub

End Class
