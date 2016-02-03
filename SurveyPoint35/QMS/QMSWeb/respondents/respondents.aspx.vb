Option Explicit On 
Option Strict On

Imports SurveyPointClasses
Imports QMS

Partial Class frmRespondents
    Inherits System.Web.UI.Page
    Protected WithEvents vsRespondents As System.Web.UI.WebControls.ValidationSummary
    Protected WithEvents dgRespondents1 As System.Web.UI.WebControls.DataGrid

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
    Public Const REQUEST_SURVEYINSTANCE_ID_KEY As String = "siid"
    Public Const REQUEST_SURVEY_ID_KEY As String = "sid"
    Public Const REQUEST_CLIENT_ID_KEY As String = "cid"
    Public Const REQUEST_BATCH_ID_KEY As String = "bid"

    Private m_oRespondents As QMS.clsRespondents
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.AppendConnStringConnectionTimeOut(DMI.DataHandler.sConnection, 300))
            m_oRespondents = New QMS.clsRespondents(m_oConn)
            m_sDSName = Request.Url.AbsolutePath
            Session.Remove("ds")
            Session.Remove(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY)
            'TP Security Check
            If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_ADMIN) Then                
                dgRespondents.Columns(5).Visible = True
            Else
                dgRespondents.Columns(5).Visible = False
            End If
            'Determine whether page setup is required:
            'Posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        'run page setup
        PageSetup()
        'set controls for security privledges
        SecuritySetup()
        'clean up page objects
        PageCleanUp()

    End Sub

    Private Sub PageSetup()
        Dim sqlDR As SqlClient.SqlDataReader

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = "LastName, FirstName"
        ViewState(SEARCH_KEY) = ""

        'setup page controls
        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
        ddlSurveyInstanceID.DataValueField = "SurveyInstanceID"
        ddlSurveyInstanceID.DataTextField = "Name"
        ddlSurveyInstanceID.DataSource = sqlDR
        ddlSurveyInstanceID.DataBind()
        ddlSurveyInstanceID.Items.Insert(0, New ListItem("Select Survey Instance", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
        ddlMoveToSurveyInstanceID.DataValueField = "SurveyInstanceID"
        ddlMoveToSurveyInstanceID.DataTextField = "Name"
        ddlMoveToSurveyInstanceID.DataSource = sqlDR
        ddlMoveToSurveyInstanceID.DataBind()
        ddlMoveToSurveyInstanceID.Items.Insert(0, New ListItem("Select Survey Instance", "0"))
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

        'Fill state drop down list
        sqlDR = QMS.clsQMSTools.GetStatesDataSource(m_oConn)
        ddlState.DataValueField = "State"
        ddlState.DataTextField = "StateName"
        ddlState.DataSource = sqlDR
        ddlState.DataBind()
        ddlState.Items.Insert(0, New ListItem("Select State", ""))
        sqlDR.Close()

        sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "2,3,4,5")
        ddlEventID.DataValueField = "EventID"
        ddlEventID.DataTextField = "Name"
        ddlEventID.DataSource = sqlDR
        ddlEventID.DataBind()
        ddlEventID.Items.Insert(0, New ListItem("Select Event", "0"))
        ddlEventID.Items.Add(New ListItem("ANY FINAL CODE", CInt(QMS.qmsEvents.FINAL_CODE).ToString))
        sqlDR.Close()

        sqlDR = QMS.clsEvents.GetEventDataSource(m_oConn, "2,3,4,5")
        ddlLogEventID.DataValueField = "EventID"
        ddlLogEventID.DataTextField = "Name"
        ddlLogEventID.DataSource = sqlDR
        ddlLogEventID.DataBind()
        ddlLogEventID.Items.Insert(0, New ListItem("Select Event", "0"))
        sqlDR.Close()

        sqlDR = QMS.clsFileDefs.GetFileDefFilterDataSource(m_oConn)
        ddlFileDefFilterID.DataSource = sqlDR
        ddlFileDefFilterID.DataTextField = "FilterName"
        ddlFileDefFilterID.DataValueField = "FileDefFilterID"
        ddlFileDefFilterID.DataBind()
        ddlFileDefFilterID.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        QMS.clsQMSTools.SetProcessorDDL(m_oConn, CType(ddlProcessorID, ListControl))
        SurveyPointClasses.clsWebTools.fillTriggerDDL(CType(ddlTriggers, ListControl), "Select Trigger")

        ddlTriggers.Items.Add(New ListItem("", ""))

        'format datagrid
        dgRespondents.DataKeyField = "RespondentID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgRespondents)

        QueryStringSearch()

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oRespondents) Then
            m_oRespondents.Close()
            m_oRespondents = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oRespondents.FillMain(drCriteria)

        End If

    End Sub

    Private Sub SecuritySetup()
        'If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_ADMIN) Then
        '    'must be respondent administrator access move, delete, and log functions
        '    ibMove.Visible = False
        '    ddlMoveToSurveyInstanceID.Visible = False
        '    cbMoveAll.Visible = False
        '    ibDelete.Visible = False
        '    cbDeleteAll.Visible = False
        '    ddlLogEventID.Visible = False
        '    ibLog.Visible = False
        '    cbLogAll.Visible = False
        '    ibScore.Visible = False
        '    tbScoreScriptID.Visible = False
        '    cbScoreAll.Visible = False

        'End If

    End Sub

    Private Sub QueryStringSearch()
        Dim bSearch As Boolean = False

        If IsNumeric(Request.QueryString(REQUEST_BATCH_ID_KEY)) Then
            tbBatchID.Text = Request.QueryString(REQUEST_BATCH_ID_KEY)
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_SURVEY_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(Request.QueryString(REQUEST_SURVEY_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_CLIENT_ID_KEY)) Then
            ddlClientID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(Request.QueryString(REQUEST_CLIENT_ID_KEY)))
            bSearch = True

        End If

        If IsNumeric(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)) Then
            ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)))
            bSearch = True

        End If

        If bSearch Then
            BuildSearch()
            LoadDataSet()
            dgRespondents.CurrentPageIndex = 0
            RespondentsGridBind(Viewstate(LAST_SORT_KEY).ToString)

        End If

    End Sub

    Private Sub RespondentsGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        iRowCount = DMI.clsDataGridTools.DataGridBind(dgRespondents, CType(m_oRespondents, DMI.clsDBEntity2), sSortBy)
        lblSearchResults.Text = String.Format("{0} Respondents", iRowCount)

        If m_oRespondents.MainDataTable.Rows.Count > 0 Then
            If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_ADMIN) Then
                pnlActions.Visible = True
            End If
        Else
            pnlActions.Visible = False
        End If

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsRespondents.SearchRow
        dr = CType(m_oRespondents.NewSearchRow, QMS.dsRespondents.SearchRow)

        'dr.BeginEdit()

        If IsNumeric(tbBatchID.Text) Then dr.BatchID = CInt(tbBatchID.Text)
        If IsNumeric(tbRespondentID.Text) Then dr.RespondentID = CInt(tbRespondentID.Text)
        If tbClientRespondentID.Text.Length > 0 Then dr.ClientRespondentID = tbClientRespondentID.Text
        If ddlSurveyID.SelectedIndex > 0 Then dr.SurveyID = CInt(ddlSurveyID.SelectedItem.Value)
        If ddlClientID.SelectedIndex > 0 Then dr.ClientID = CInt(ddlClientID.SelectedItem.Value)
        If ddlSurveyInstanceID.SelectedIndex > 0 Then dr.SurveyInstanceID = CInt(ddlSurveyInstanceID.SelectedItem.Value)
        If tbLastName.Text.Length > 0 Then dr.LastName = String.Format("{0}%", tbLastName.Text)
        If tbFirstName.Text.Length > 0 Then dr.FirstName = String.Format("{0}%", tbFirstName.Text)
        If tbCity.Text.Length > 0 Then dr.City = String.Format("{0}%", tbCity.Text)
        If ddlState.SelectedItem.Value.Length > 0 Then dr.State = ddlState.SelectedItem.Value
        If tbPostalCode.Text.Length > 0 Then dr.PostalCode = String.Format("{0}%", tbPostalCode.Text)
        If tbTelephone.Text.Length > 0 Then dr.Telephone = String.Format("{0}%", DMI.clsUtil.RemoveTelephoneFormat(tbTelephone.Text))
        If ddlEventID.SelectedIndex > 0 Then dr.EventID = CInt(ddlEventID.SelectedItem.Value)
        If tbEventLogAfter.Text.Length > 0 Then dr.EventStartRange = CDate(tbEventLogAfter.Text)
        If tbEventLogBefore.Text.Length > 0 Then dr.EventEndRange = CDate(tbEventLogBefore.Text)
        If ddlGender.SelectedIndex > 0 Then dr.Gender = ddlGender.SelectedItem.Value
        If tbDOBAfter.Text.Length > 0 Then dr.DOBStartRange = CDate(tbDOBAfter.Text)
        If tbDOBBefore.Text.Length > 0 Then dr.DOBEndRange = CDate(tbDOBBefore.Text)
        If tbPropertyName.Text.Length > 0 Then dr.PropertyName = tbPropertyName.Text
        If tbPropertyValue.Text.Length > 0 Then dr.PropertyValue = tbPropertyValue.Text
        If ddlFileDefFilterID.SelectedIndex > 0 Then dr.FileDefFilterID = CInt(ddlFileDefFilterID.SelectedValue)
        If cbActive.Checked Then dr.Active = 1

        'dr.EndEdit()

        ViewState(SEARCH_KEY) = m_oRespondents.SaveSearch(dr, m_sDSName)

    End Sub

    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgRespondents.CurrentPageIndex = 0
                RespondentsGridBind(Viewstate(LAST_SORT_KEY).ToString)
                SetTriggerDDL()
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondents_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgRespondents.PageIndexChanged
        Try
            LoadDataSet()
            DMI.clsDataGridTools.DataGridPageChange(dgRespondents, CType(m_oRespondents, DMI.clsDBEntity2), e, viewstate(LAST_SORT_KEY).ToString)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "dgRespondents_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try


    End Sub

    Private Sub dgRespondents_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgRespondents.SortCommand
        Try
            LoadDataSet()
            Viewstate(LAST_SORT_KEY) = DMI.clsDataGridTools.DataGridSort(dgRespondents, CType(m_oRespondents, DMI.clsDBEntity2), e, Viewstate(LAST_SORT_KEY).ToString)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "dgRespondents_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Public Sub ValidateSearch(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim bValid As Boolean = False

        If IsNumeric(tbBatchID.Text) Then bValid = True
        If IsNumeric(tbRespondentID.Text) Then bValid = True
        If ddlSurveyID.SelectedIndex > 0 Then bValid = True
        If ddlClientID.SelectedIndex > 0 Then bValid = True
        If ddlSurveyInstanceID.SelectedIndex > 0 Then bValid = True
        If tbClientRespondentID.Text.Length > 0 Then bValid = True
        If tbLastName.Text.Length > 0 Then bValid = True
        If tbTelephone.Text.Length > 0 Then bValid = True


        args.IsValid = bValid

    End Sub

    Private Sub ibAdvanced_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdvanced.Click
        Try
            'LoadDataSet()
            DMI.WebFormTools.ShowHidePanel(ibAdvanced, pnlAdvanced)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibMove_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibMove.Click
        Try
            If ddlMoveToSurveyInstanceID.SelectedIndex > 0 Then
                If cbMoveAll.Checked Then
                    MoveAll()

                Else
                    LoadDataSet()
                    m_oRespondents.DataGridMove(dgRespondents, CInt(ddlMoveToSurveyInstanceID.SelectedValue), CInt(HttpContext.Current.User.Identity.Name), ViewState(LAST_SORT_KEY).ToString)

                End If

            Else
                LoadDataSet()
                DMI.WebFormTools.Msgbox(Page, "Please select a survey instance")

            End If
            RespondentsGridBind()

            ddlMoveToSurveyInstanceID.SelectedIndex = 0
            cbMoveAll.Checked = False

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibMove_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub MoveAll()
        Dim drCriteria As DataRow

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.MoveAll(drCriteria, CInt(ddlMoveToSurveyInstanceID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name))
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        DMI.WebFormTools.Msgbox(Page, "Moving Respondents")

    End Sub

    Private Sub ibDelete_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDelete.Click
        Try
            If cbDeleteAll.Checked Then
                DeleteAll()

            Else
                LoadDataSet()
                m_oRespondents.DataGridDelete(dgRespondents, ViewState(LAST_SORT_KEY).ToString)

            End If
            cbDeleteAll.Checked = False

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibDelete_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub DeleteAll()
        Dim drCriteria As DataRow

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.DeleteAll(drCriteria)
        m_oRespondents.FillMain(drCriteria)
        dgRespondents.CurrentPageIndex = 0
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        If m_oRespondents.ErrMsg.Length > 0 Then DMI.WebFormTools.Msgbox(Page, m_oRespondents.ErrMsg)

    End Sub

    Private Sub dgRespondents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgRespondents.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)
            'set name column
            CType(e.Item.FindControl("ltRespondentName"), Literal).Text = String.Format("{1}, {0}", drv.Item("FirstName"), drv.Item("LastName"))
            'set address column
            CType(e.Item.FindControl("ltAddress"), Literal).Text = DMI.clsUtil.FormatHTMLAddress(drv.Item("Address1"), drv.Item("Address2"), drv.Item("City"), drv.Item("State"), drv.Item("PostalCode"), drv.Item("PostalCodeExt"))
            'set survey instance column
            CType(e.Item.FindControl("ltSurveyInstanceName"), Literal).Text = String.Format("{0}: {1}: {2}", drv.Item("SurveyName"), drv.Item("ClientName"), drv.Item("SurveyInstanceName"))

        End If

    End Sub

    Private Sub ibLog_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibLog.Click
        Try
            ValidateLogEvent()
            LoadDataSet()
            If cbLogAll.Checked Then
                LogAll()
                Exit Sub
            Else
                Dim eventDate As DateTime = DMI.clsUtil.NULLDATE
                If IsDate(tbEventDate.Text) Then eventDate = CDate(tbEventDate.Text)
                m_oRespondents.DataGridLogEvent(dgRespondents, CInt(ddlLogEventID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name), ViewState(LAST_SORT_KEY).ToString, eventDate)
                ddlLogEventID.SelectedIndex = 0
            End If
            cbLogAll.Checked = False

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibLog_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        Finally
            PageCleanUp()

        End Try

    End Sub

    Private Sub ValidateLogEvent()
        If ddlLogEventID.SelectedIndex = 0 Then
            Throw New ApplicationException("Please select an event to log")
        End If

        If tbEventDate.Text.Length > 0 AndAlso Not IsDate(tbEventDate.Text) Then
            Throw New ApplicationException("Event date must in date format (mm/dd/yyyy)")
        End If

    End Sub

    Private Sub LogAll()
        Dim drCriteria As DataRow
        Dim eventDate As DateTime = DMI.clsUtil.NULLDATE
        If IsDate(tbEventDate.Text) Then eventDate = CDate(tbEventDate.Text)

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.LogAll(drCriteria, CInt(ddlLogEventID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name), eventDate)
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        DMI.WebFormTools.Msgbox(Page, String.Format("{0} Respondents Logged", m_oRespondents.MainDataTable.Rows.Count))

    End Sub

    Private Sub ibScore_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibScore.Click
        Try
            ValidateScoring()

            Dim ScriptID As Integer
            ScriptID = CInt(tbScoreScriptID.Text)
            LoadDataSet()
            If cbScoreAll.Checked Then
                ScoreAll(ScriptID)

            Else
                m_oRespondents.DataGridScore(dgRespondents, ScriptID, CInt(HttpContext.Current.User.Identity.Name), ViewState(LAST_SORT_KEY).ToString)

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibScore_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ValidateScoring()
        If tbScoreScriptID.Text.TrimEnd.Length > 0 Then
            If Not IsNumeric(tbScoreScriptID.Text) Then
                Throw New ApplicationException("Script ID must be numeric")
            End If
        Else
            Throw New ApplicationException("Please provide Script ID to score against")
        End If

    End Sub
    Private Sub ScoreAll(ByVal ScriptID As Integer)
        Dim drCriteria As DataRow

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.ScoreAll(drCriteria, ScriptID, CInt(HttpContext.Current.User.Identity.Name), True)
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        DMI.WebFormTools.Msgbox(Page, String.Format("Scoring {0} Respondents", m_oRespondents.MainDataTable.Rows.Count))

    End Sub

    Private Sub ibProcess_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibProcess.Click
        Try
            ValidateProcessor()

            Dim processorCode As String = QMS.clsQMSTools.GetProcessorCode(m_oConn, CInt(ddlProcessorID.SelectedValue))
            LoadDataSet()
            If cbProcessAll.Checked Then
                ProcessAll(processorCode)
            Else
                m_oRespondents.DataGridProcessorCode(dgRespondents, CInt(HttpContext.Current.User.Identity.Name), processorCode, ViewState(LAST_SORT_KEY).ToString)
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibProcess_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ValidateProcessor()
        If Not IsNumeric(ddlProcessorID.SelectedValue) Then
            Throw New ApplicationException("Please select a valid processor")
        End If
    End Sub

    Private Sub ProcessAll(ByVal processorCode As String)
        Dim drCriteria As DataRow

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.RunProcessorAll(drCriteria, CInt(HttpContext.Current.User.Identity.Name), processorCode)
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        DMI.WebFormTools.Msgbox(Page, String.Format("Scoring {0} Respondents", m_oRespondents.MainDataTable.Rows.Count))

    End Sub

    Private Sub ibExecuteTrigger_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibExecuteTrigger.Click
        Try
            If ddlTriggers.SelectedIndex > 0 Then
                If cbExecuteTriggerAll.Checked Then
                    ExecuteTriggerAll()

                Else
                    LoadDataSet()
                    m_oRespondents.DataGridTrigger(dgRespondents, CInt(ddlTriggers.SelectedValue), CInt(HttpContext.Current.User.Identity.Name), ViewState(LAST_SORT_KEY).ToString)

                End If

            Else
                LoadDataSet()
                DMI.WebFormTools.Msgbox(Page, "Please select a trigger")

            End If
            RespondentsGridBind()

            ddlTriggers.SelectedIndex = 0
            cbExecuteTriggerAll.Checked = False

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondents), "ibExecuteTrigger_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try
    End Sub

    Private Sub ExecuteTriggerAll()
        Dim drCriteria As DataRow

        drCriteria = m_oRespondents.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
        m_oRespondents.ExecuteTriggerAll(drCriteria, CInt(HttpContext.Current.User.Identity.Name), CInt(ddlTriggers.SelectedValue))
        RespondentsGridBind(viewstate(LAST_SORT_KEY).ToString)
        DMI.WebFormTools.Msgbox(Page, String.Format("Executing trigger on {0} respondents", m_oRespondents.MainDataTable.Rows.Count))

    End Sub

    Private Sub SetTriggerDDL()
        Dim iSurveyID As Integer = -1
        If (ddlSurveyID.SelectedIndex > 0) Then
            iSurveyID = CInt(ddlSurveyID.SelectedValue)
        ElseIf (ddlSurveyInstanceID.SelectedIndex > 0) Then
            Dim iSurveyInstanceID As Integer = CInt(ddlSurveyInstanceID.SelectedValue)
            iSurveyID = clsSurveyInstances.GetSurveyID(m_oConn, iSurveyInstanceID)
        End If

        ddlTriggers.Items.Clear()
        clsWebTools.fillTriggerDDL(ddlTriggers, "", iSurveyID, -1, -1)

    End Sub

End Class