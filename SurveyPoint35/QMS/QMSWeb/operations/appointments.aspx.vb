Partial Class appointments
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
    Public Const SURVEYINSTANCE_ID_KEY As String = "siid"
    Public Const SURVEY_ID_KEY As String = "sid"
    Public Const CLIENT_ID_KEY As String = "cid"

    Private m_oAppointments As QMS.clsTelephoneAppointment
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oAppointments = New QMS.clsTelephoneAppointment(m_oConn)
            m_sDSName = Request.Url.AbsolutePath
            Session.Remove("ds")

            'Determine whether page setup is required:
            'Posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(appointments), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

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
        Viewstate(LAST_SORT_KEY) = "LastName, FirstName"
        ViewState(SEARCH_KEY) = ""

        tbStartDate.Text = String.Format("{0:d}", Now())
        tbEndDate.Text = String.Format("{0:d}", Now())

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

        'format datagrid
        dgAppointments.DataKeyField = "RespondentID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgAppointments)

        QueryStringSearch()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oAppointments) Then
            m_oAppointments.Close()
            m_oAppointments = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oAppointments.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oAppointments.FillMain(drCriteria)

        End If

    End Sub

    Private Sub QueryStringSearch()
        Dim bSearch As Boolean = False

        If IsNumeric(Request.QueryString(SURVEY_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(Request.QueryString(SURVEY_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(CLIENT_ID_KEY)) Then
            ddlClientID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(Request.QueryString(CLIENT_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(SURVEYINSTANCE_ID_KEY)) Then
            ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(Request.QueryString(SURVEYINSTANCE_ID_KEY)))
            bSearch = True

        End If

        If bSearch Then
            BuildSearch()
            LoadDataSet()
            dgAppointments.CurrentPageIndex = 0
            AppointmentsGridBind()

        End If

    End Sub

    Private Sub AppointmentsGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        iRowCount = DMI.clsDataGridTools.DataGridBind(dgAppointments, CType(m_oAppointments, DMI.clsDBEntity2), sSortBy)
        ltResultsFound.Text = String.Format("{0} Appointments", iRowCount)

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsTelephoneAppointments.SearchRow = CType(m_oAppointments.NewSearchRow, QMS.dsTelephoneAppointments.SearchRow)

        dr.BeginEdit()
        If IsDate(tbStartDate.Text) Then dr.AppointmentDateStart = tbStartDate.Text
        If IsDate(tbEndDate.Text) Then dr.AppointmentDateEnd = String.Format("{0:d} 23:59:59", tbEndDate.Text)
        If ddlSurveyID.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
        If ddlClientID.SelectedIndex > 0 Then dr.ClientID = CInt(ddlClientID.SelectedItem.Value)
        If ddlSurveyInstanceID.SelectedIndex > 0 Then dr.SurveyInstanceID = CInt(ddlSurveyInstanceID.SelectedItem.Value)
        dr.EndEdit()

        ViewState(SEARCH_KEY) = m_oAppointments.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub dgAppointments_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgAppointments.SortCommand
        Try
            LoadDataSet()
            Viewstate(LAST_SORT_KEY) = DMI.clsDataGridTools.DataGridSort(dgAppointments, CType(m_oAppointments, DMI.clsDBEntity2), e, Viewstate(LAST_SORT_KEY).ToString)

        Catch ex As Exception
            clsLog.LogError(GetType(appointments), "dgAppointments_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()

        End Try

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgAppointments.CurrentPageIndex = 0
                AppointmentsGridBind()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(appointments), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        Finally
            PageCleanUp()

        End Try

    End Sub

End Class
