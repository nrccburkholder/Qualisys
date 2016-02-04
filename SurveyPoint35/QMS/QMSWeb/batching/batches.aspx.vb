Option Explicit On 
Option Strict On

Partial Class frmBatchDetails
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
    Public Const REQUEST_BATCH_ID_KEY As String = "id"
    Public Const REQUEST_SURVEYINSTANCE_ID_KEY As String = "siid"
    Public Const REQUEST_SURVEY_ID_KEY As String = "sid"
    Public Const REQUEST_CLIENT_ID_KEY As String = "cid"

    Private m_oBatches As QMS.clsBatches
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oBatches = New QMS.clsBatches(m_oConn)
            m_sDSName = Request.Url.AbsolutePath

            'Determine whether page setup is required:
            'SurveyInstance has posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchDetails), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading this page.\nError has been logged, please report to administrator.")
        End Try

    End Sub

    Private Sub PageLoad()
        'run page setup
        PageSetup()
        'clean up page objects
        PageCleanUp()

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = "BatchID"
        ViewState(SEARCH_KEY) = ""

        'setup page controls
        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
        ddlSurveyInstanceID.DataValueField = "SurveyInstanceID"
        ddlSurveyInstanceID.DataTextField = "Name"
        ddlSurveyInstanceID.DataSource = sqlDR
        ddlSurveyInstanceID.DataBind()
        ddlSurveyInstanceID.Items.Insert(0, New ListItem("Select Survey Instance", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
        ddlSurveyID.DataValueField = "SurveyID"
        ddlSurveyID.DataTextField = "Name"
        ddlSurveyID.DataSource = sqlDR
        ddlSurveyID.DataBind()
        ddlSurveyID.Items.Insert(0, New ListItem("Select Survey", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsClients.GetClientList(m_oConn)
        ddlClientID.DataValueField = "ClientID"
        ddlClientID.DataTextField = "Name"
        ddlClientID.DataSource = sqlDR
        ddlClientID.DataBind()
        ddlClientID.Items.Insert(0, New ListItem("Select Client", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        'format datagrid
        dgBatches.DataKeyField = "BatchID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgBatches)

        SetQuerySearch()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oBatches) Then
            m_oBatches.Close()
            m_oBatches = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oBatches.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oBatches.FillMain(drCriteria)

        End If

    End Sub

    Private Sub SetQuerySearch()
        Dim bSearch As Boolean = False

        If IsNumeric(Request.QueryString(REQUEST_BATCH_ID_KEY)) Then
            tbBatchID.Text = Request.QueryString(REQUEST_BATCH_ID_KEY)
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)) Then
            ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_SURVEY_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(Request.QueryString(REQUEST_SURVEY_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_CLIENT_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(Request.QueryString(REQUEST_CLIENT_ID_KEY)))
            bSearch = True

        End If

        If bSearch Then
            BuildSearch()
            LoadDataSet()
            dgBatches.CurrentPageIndex = 0
            BatchesGridBind()
        End If

    End Sub


    Private Sub BatchesGridBind(Optional ByVal sSortBy As String = "")
        Dim iRows As Integer = m_oBatches.DataGridBind(dgBatches, ViewState(LAST_SORT_KEY).ToString)
        ltResultsFound.Text = String.Format("{0} Batches Found", iRows)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsBatches.SearchRow
        Dim bSearchSet As Boolean = False

        dr = CType(m_oBatches.NewSearchRow, QMS.dsBatches.SearchRow)

        If IsNumeric(tbBatchID.Text) Then
            dr.BatchID = CInt(tbBatchID.Text)
            bSearchSet = True

        End If

        If ddlSurveyID.SelectedIndex > 0 Then
            dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
            bSearchSet = True

        End If

        If ddlClientID.SelectedIndex > 0 Then
            dr.ClientID = CInt(ddlClientID.SelectedItem.Value)
            bSearchSet = True

        End If

        If ddlSurveyInstanceID.SelectedIndex > 0 Then
            dr.SurveyInstanceID = CInt(ddlSurveyInstanceID.SelectedItem.Value)
            bSearchSet = True

        End If

        If Not bSearchSet Then dr.BatchID = 0

        ViewState(SEARCH_KEY) = m_oBatches.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgBatches.CurrentPageIndex = 0
                BatchesGridBind()

            End If
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchDetails), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured performing the search.\nError has been logged, please report to administrator.")
        End Try
    End Sub

    Private Sub dgBatches_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgBatches.PageIndexChanged
        Try
            LoadDataSet()
            m_oBatches.DataGridPageChange(dgBatches, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchDetails), "dgBatches_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured changing grid index.\nError has been logged, please report to administrator.")
        End Try

    End Sub

    Private Sub dgBatches_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgBatches.SortCommand
        Try
            LoadDataSet()
            m_oBatches.DataGridSort(dgBatches, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmBatchDetails), "dgBatches_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured sorting grid.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgBatches_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgBatches.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set survey name column
            CType(e.Item.FindControl("hlDetails"), HyperLink).NavigateUrl = _
                String.Format("../respondents/respondents.aspx?{0}={4}&{1}={5}&{2}={6}&{3}={7}", _
                    frmRespondents.REQUEST_BATCH_ID_KEY, frmRespondents.REQUEST_SURVEY_ID_KEY, frmRespondents.REQUEST_CLIENT_ID_KEY, frmRespondents.REQUEST_SURVEYINSTANCE_ID_KEY, _
                    drv.Item("BatchID"), drv.Item("SurveyID"), drv.Item("ClientID"), drv.Item("SurveyInstanceID"))
        End If

    End Sub

End Class
