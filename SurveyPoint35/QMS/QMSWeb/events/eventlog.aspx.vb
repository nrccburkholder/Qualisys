Partial Class frmEventLog
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

    Private m_oEventLog As QMS.clsEventLog
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oEventLog = New QMS.clsEventLog(m_oConn)
            m_sDSName = Request.Url.AbsolutePath

            'Determine whether page setup is required:
            'SurveyInstance has posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEventLog), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured loading page.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EVENTLOG_VIEWER) Then
            'run page setup
            PageSetup()
            'set controls for security privledges
            SecuritySetup()
            'clean up page objects
            PageCleanUp()

        Else
            'user does not have event log viewing privledges, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = "EventDate DESC"
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

        sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "")
        ddlEventID.DataValueField = "EventID"
        ddlEventID.DataTextField = "Name"
        ddlEventID.DataSource = sqlDR
        ddlEventID.DataBind()
        ddlEventID.Items.Insert(0, New ListItem("Select Event", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsEvents.GetEventTypesDataSource(m_oConn)
        ddlEventTypeID.DataSource = sqlDR
        ddlEventTypeID.DataTextField = "Name"
        ddlEventTypeID.DataValueField = "EventTypeID"
        ddlEventTypeID.DataBind()
        ddlEventTypeID.Items.Insert(0, New ListItem("Select Event Type", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsUsers.GetUsersDataSource(m_oConn)
        ddlUserID.DataSource = sqlDR
        ddlUserID.DataTextField = "Username"
        ddlUserID.DataValueField = "UserID"
        ddlUserID.DataBind()
        ddlUserID.Items.Insert(0, New ListItem("Select User", "0"))
        sqlDR.Close()

        'format datagrid
        dgEventLog.DataKeyField = "EventLogID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgEventLog)

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oEventLog) Then
            m_oEventLog.Close()
            m_oEventLog = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oEventLog.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oEventLog.FillMain(drCriteria)

        End If

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EVENTLOG_EDIT) Then
            'must be instance administrator to edit instance events
            ibDelete.Visible = False
            cbDeleteAll.Visible = False

        End If

    End Sub

    Private Sub EventLogGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        iRowCount = m_oEventLog.DataGridBind(dgEventLog, ViewState(LAST_SORT_KEY).ToString)
        lblSearchResults.Text = String.Format("{0} Events", iRowCount)
        'display event log action controls if there are rows
        If iRowCount = 0 Then
            pnlEventLogActions.Visible = False
        Else
            pnlEventLogActions.Visible = True
        End If

        'display Delete All checkbox if MaxRows is not set, and if user has privledges
        If tbMaxRows.Text.Length = 0 AndAlso QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.EVENTLOG_EDIT) Then
            cbDeleteAll.Visible = True
        Else
            cbDeleteAll.Visible = False
        End If

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsEventLog.SearchRow = CType(m_oEventLog.NewSearchRow, QMS.dsEventLog.SearchRow)

        If IsNumeric(tbRespondentID.Text) Then dr.RespondentID = CInt(tbRespondentID.Text)
        If IsDate(tbEventDateBegin.Text) Then dr.EventStartRange = CDate(tbEventDateBegin.Text)
        If IsDate(tbEventDateEnd.Text) Then dr.EventEndRange = CDate(tbEventDateEnd.Text)
        If ddlSurveyID.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
        If ddlClientID.SelectedIndex > 0 Then dr.ClientID = CInt(ddlClientID.SelectedItem.Value)
        If ddlSurveyInstanceID.SelectedIndex > 0 Then dr.SurveyInstanceID = CInt(ddlSurveyInstanceID.SelectedItem.Value)
        If ddlEventID.SelectedIndex > 0 Then dr.EventID = CInt(ddlEventID.SelectedItem.Value)
        If ddlEventTypeID.SelectedIndex > 0 Then dr.EventTypeID = CInt(ddlEventTypeID.SelectedItem.Value)
        If ddlUserID.SelectedIndex > 0 Then dr.UserID = CInt(ddlUserID.SelectedItem.Value)
        If cbActive.Checked Then dr.Active = 1
        If IsNumeric(tbMaxRows.Text) Then dr.Top = Math.Abs(CInt(tbMaxRows.Text))

        ViewState(SEARCH_KEY) = m_oEventLog.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub dgEventLog_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgEventLog.PageIndexChanged
        Try
            LoadDataSet()
            m_oEventLog.DataGridPageChange(dgEventLog, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEventLog), "dgEventLog_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured paging grid.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub dgEventLog_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgEventLog.SortCommand
        Try
            LoadDataSet()
            m_oEventLog.DataGridSort(dgEventLog, e, ViewState(LAST_SORT_KEY).ToString)
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEventLog), "dgEventLog_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured sorting grid.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            If cbDeleteAll.Checked Then
                DeleteAll()
                lblSearchResults.Text = "0 Events"
                DMI.WebFormTools.Msgbox(Page, "Processing deletes")

            Else
                LoadDataSet()
                m_oEventLog.DataGridDelete(dgEventLog, ViewState(LAST_SORT_KEY).ToString)
                PageCleanUp()

            End If
            cbDeleteAll.Checked = False

        Catch ex As Exception
            clsLog.LogError(GetType(frmEventLog), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured deleting.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub DeleteAll()
        Dim drCriteria As DataRow

        drCriteria = m_oEventLog.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oEventLog.DeleteAll(drCriteria)
        'm_oEventLog.FillMain(drCriteria)
        EventLogGridBind(viewstate(LAST_SORT_KEY).ToString)
        If m_oEventLog.ErrMsg.Length > 0 Then DMI.WebFormTools.Msgbox(Page, m_oEventLog.ErrMsg)

    End Sub

    Private Sub btnSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgEventLog.CurrentPageIndex = 0
                EventLogGridBind()

            End If
            PageCleanUp()

        Catch ex As Exception
            clsLog.LogError(GetType(frmEventLog), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured searching.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Public Sub ValidateSearch(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim bValid As Boolean = False

        If IsNumeric(tbRespondentID.Text) Then bValid = True
        If ddlSurveyID.SelectedIndex > 0 Then bValid = True
        If ddlClientID.SelectedIndex > 0 Then bValid = True
        If ddlSurveyInstanceID.SelectedIndex > 0 Then bValid = True
        If ddlUserID.SelectedIndex > 0 Then bValid = True
        If ddlEventID.SelectedIndex > 0 Then bValid = True
        If ddlEventTypeID.SelectedIndex > 0 Then bValid = True

        args.IsValid = bValid

    End Sub

End Class
