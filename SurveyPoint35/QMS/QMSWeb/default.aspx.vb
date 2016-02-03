Option Explicit On 
Option Strict On

Partial Class frmMain
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

    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String
    Private m_oSurveyTasks As QMS.clsSurveyTasks

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        m_oSurveyTasks = New QMS.clsSurveyTasks(m_oConn)
        m_sDSName = Request.Url.AbsolutePath

        'Determine whether page setup is required:
        'user has posted back to same page
        If Not Page.IsPostBack Then PageLoad()

    End Sub

    Private Sub PageLoad()
        'run page setup
        PageSetup()
        'set controls for security privledges
        SecuritySetup()
        'clean up page objects
        PageCleanup()

    End Sub

    Private Sub PageSetup()
        'setup sort variable
        ViewState(LAST_SORT_KEY) = "ProtocolStepDate DESC"
        ViewState(SEARCH_KEY) = ""

        'fill main table
        InitSearchForm()
        BuildSearch()
        LoadDataSet()

        'format datagrid
        dgSurveyTasks.DataKeyField = "RowID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveyTasks)
        SurveyTasksGridBind()

    End Sub

    Private Sub PageCleanup()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oSurveyTasks) Then
            m_oSurveyTasks.Close()
            m_oSurveyTasks = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        drCriteria = m_oSurveyTasks.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oSurveyTasks.FillLookups(drCriteria)
        m_oSurveyTasks.FillMain(drCriteria)

    End Sub

    Private Sub SurveyTasksGridBind()
        Dim iRowCount As Integer = m_oSurveyTasks.DataGridBind(dgSurveyTasks, ViewState(LAST_SORT_KEY).ToString)
    End Sub

    Private Sub InitSearchForm()
        Dim sqlDR As SqlClient.SqlDataReader

        ibClear.Attributes.Add("onClick", "javascript:return confirm('Are You Sure You Want To Clear These Tasks?');")

        tbBeginDate.Text = String.Format("{0:d}", DateAdd(DateInterval.Day, -7, Now()))
        tbEndDate.Text = String.Format("{0:d}", Now())

        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
        ddlSurveyInstanceID.DataValueField = "SurveyInstanceID"
        ddlSurveyInstanceID.DataTextField = "Name"
        ddlSurveyInstanceID.DataSource = sqlDR
        ddlSurveyInstanceID.DataBind()
        ddlSurveyInstanceID.Items.Insert(0, New ListItem("Select Survey Instance", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsProtocolSteps.GetProtocolStepTypesDataSource(m_oConn)
        ddlProtocolStepTypeID.DataValueField = "ProtocolStepTypeID"
        ddlProtocolStepTypeID.DataTextField = "Name"
        ddlProtocolStepTypeID.DataSource = sqlDR
        ddlProtocolStepTypeID.DataBind()
        ddlProtocolStepTypeID.Items.Insert(0, New ListItem("Select Step Type", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        dgSurveyTasks.DataKeyField = "RowID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgSurveyTasks)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsSurveyTasks.SearchRow

        dr = CType(m_oSurveyTasks.NewSearchRow, QMS.dsSurveyTasks.SearchRow)

        If ddlProtocolStepTypeID.SelectedIndex > 0 Then dr.ProtocolStepTypeID = CInt(ddlProtocolStepTypeID.SelectedItem.Value)
        If ddlSurveyInstanceID.SelectedIndex > 0 Then dr.SurveyInstanceID = CInt(ddlSurveyInstanceID.SelectedItem.Value)
        If tbBeginDate.Text.Length > 0 Then dr.StartDateRange = CDate(tbBeginDate.Text)
        If tbEndDate.Text.Length > 0 Then dr.EndDateRange = CDate(String.Format("{0:d} 23:59:59", tbEndDate.Text))
        dr.Cleared = 0
        dr.Active = 1

        ViewState(SEARCH_KEY) = m_oSurveyTasks.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub SecuritySetup()

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.SIPS_ADMIN) Then
            ibClear.Visible = False

        End If

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        If Page.IsValid Then
            BuildSearch()
            LoadDataSet()
            dgSurveyTasks.CurrentPageIndex = 0
            SurveyTasksGridBind()
            PageCleanup()

        End If

    End Sub

    Private Sub ibClear_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibClear.Click
        LoadDataSet()
        m_oSurveyTasks.UserID = CInt(HttpContext.Current.User.Identity.Name)
        m_oSurveyTasks.DataGridDelete(dgSurveyTasks, viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()

    End Sub

    Private Sub dgSurveyTasks_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgSurveyTasks.PageIndexChanged
        LoadDataSet()
        m_oSurveyTasks.DataGridPageChange(dgSurveyTasks, e, viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()

    End Sub

    Private Sub dgSurveyTasks_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgSurveyTasks.SortCommand
        LoadDataSet()
        Viewstate(LAST_SORT_KEY) = m_oSurveyTasks.DataGridSort(dgSurveyTasks, e, Viewstate(LAST_SORT_KEY).ToString)
        PageCleanup()

    End Sub
End Class
