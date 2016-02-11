Option Explicit On 
Option Strict On

Partial Class frmCallList
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
    Private Const INPUTMODE_KEY As String = "InputMode"
    Private Const MAX_CALLIST_ROWS As Integer = 100
    Public Const REQUEST_SURVEYINSTANCE_ID_KEY As String = "siid"
    Public Const REQUEST_SURVEY_ID_KEY As String = "sid"
    Public Const REQUEST_CLIENT_ID_KEY As String = "cid"
    Public Const REQUEST_PROTOCOLSTEP_ID_KEY As String = "psid"
    Public Const REQUEST_INPUTMODE_KEY As String = "input"
    Public Const SESSION_PROTOCOLSTEP_ID_KEY As String = "psid"

    Private m_oCallList As QMS.clsCallList
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oCallList = New QMS.clsCallList(m_oConn)
            m_sDSName = Request.Url.AbsolutePath

            'Determine whether page setup is required:
            'SurveyInstance has posted back to same page
            If Not Page.IsPostBack Then PageLoad()

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "Page_Load", ex)
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
        Dim iInputMode As QMS.IInputMode

        'setup sort variable
        Viewstate(LAST_SORT_KEY) = ""
        ViewState(SEARCH_KEY) = ""
        If IsNumeric(Request.QueryString(REQUEST_INPUTMODE_KEY)) Then
            ViewState(INPUTMODE_KEY) = CInt(Request.QueryString(REQUEST_INPUTMODE_KEY))
        Else
            ViewState(INPUTMODE_KEY) = 0
        End If
        iInputMode = QMS.clsInputMode.Create(CType(ViewState(INPUTMODE_KEY), QMS.qmsInputMode))

        'setup page controls
        'Fill survey instance protocol step list
        sqlDR = QMS.clsProtocolSteps.GetSurveyInstanceProtocolSteps(m_oConn, iInputMode.ProtocolStepTypeID)
        ddlProtocolSteps.DataSource = sqlDR
        ddlProtocolSteps.DataValueField = "RowID"
        ddlProtocolSteps.DataTextField = "Name"
        ddlProtocolSteps.DataBind()
        ddlProtocolSteps.Items.Insert(0, New ListItem("Call For Protocol Steps", "0"))
        sqlDR.Close()

        'Fill survey instance drop down list
        sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
        ddlSurveyInstanceID.DataValueField = "SurveyInstanceID"
        ddlSurveyInstanceID.DataTextField = "Name"
        ddlSurveyInstanceID.DataSource = sqlDR
        ddlSurveyInstanceID.DataBind()
        ddlSurveyInstanceID.Items.Insert(0, New ListItem("Select Survey Instance", "0"))
        sqlDR.Close()

        'Fill survey drop down list
        sqlDR = QMS.clsSurveys.GetSurveyList(m_oConn)
        ddlSurveyID.DataValueField = "SurveyID"
        ddlSurveyID.DataTextField = "Name"
        ddlSurveyID.DataSource = sqlDR
        ddlSurveyID.DataBind()
        ddlSurveyID.Items.Insert(0, New ListItem("Select Survey", "0"))
        sqlDR.Close()

        'Fill client drop down list
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

        'Fill file def filter drop down list
        sqlDR = QMS.clsFileDefs.GetFileDefFilterDataSource(m_oConn)
        ddlFileDefFilterID.DataValueField = "FileDefFilterID"
        ddlFileDefFilterID.DataTextField = "FilterName"
        ddlFileDefFilterID.DataSource = sqlDR
        ddlFileDefFilterID.DataBind()
        ddlFileDefFilterID.Items.Insert(0, New ListItem("None", "0"))
        sqlDR.Close()
        sqlDR = Nothing

        'Set page title
        lblTitle.Text = String.Format("Call List: {0}", iInputMode.InputModeName)

        'format datagrid
        dgCallList.DataKeyField = "RespondentID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgCallList)

        SetQuerySearch()
        iInputMode = Nothing

    End Sub

    Private Sub PageCleanUp()
        'clean up page objects
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        If Not IsNothing(m_oCallList) Then
            m_oCallList.Close()
            m_oCallList = Nothing
        End If

    End Sub

    Private Sub LoadDataSet()
        Dim drCriteria As DataRow

        If ViewState(SEARCH_KEY).ToString.Length > 0 Then
            drCriteria = m_oCallList.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
            m_oCallList.FillMain(drCriteria)

        End If

    End Sub

    Private Sub SetQuerySearch()
        'Set survey instance drop down list
        If IsNumeric(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)) Then
            ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)))

        End If

        'Set survey drop down list
        If IsNumeric(Request.QueryString(REQUEST_SURVEY_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(Request.QueryString(REQUEST_SURVEY_ID_KEY)))

        End If

        'Set client drop down list
        If IsNumeric(Request.QueryString(REQUEST_CLIENT_ID_KEY)) Then
            ddlSurveyID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(Request.QueryString(REQUEST_CLIENT_ID_KEY)))

        End If

        'Get protocol step parameters
        If IsNumeric(Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY)) And IsNumeric(Request.QueryString(REQUEST_PROTOCOLSTEP_ID_KEY)) Then
            ddlProtocolSteps.SelectedIndex = ddlProtocolSteps.Items.IndexOf(ddlProtocolSteps.Items.FindByValue(String.Format("{0},{1}", Request.QueryString(REQUEST_SURVEYINSTANCE_ID_KEY), Request.QueryString(REQUEST_PROTOCOLSTEP_ID_KEY))))

        ElseIf Not Session(SESSION_PROTOCOLSTEP_ID_KEY) Is Nothing Then
            ddlProtocolSteps.SelectedIndex = ddlProtocolSteps.Items.IndexOf(ddlProtocolSteps.Items.FindByValue(Session(SESSION_PROTOCOLSTEP_ID_KEY).ToString))

        End If


        tbEarliestTime.Text = "9:00 AM"
        tbLatestTime.Text = "9:00 PM"
        tbCallAttempts.Text = "0"

        If ddlProtocolSteps.SelectedIndex > 0 Then
            SetProtocolStep(ddlProtocolSteps.SelectedItem.Value)
            BuildSearch()
            LoadDataSet()
            dgCallList.CurrentPageIndex = 0
            CallListGridBind()

        Else
            SetupProtocolStepParameters(0, 0)
            btnGetNext.Visible = False

        End If

    End Sub

    Public Shared Function ExtractProtocolStepID(ByVal sProtocolStepSessionValue As String) As Integer
        If sProtocolStepSessionValue.IndexOf(",") > -1 Then
            Dim arValue() As String = sProtocolStepSessionValue.Split(",".ToCharArray())
            If IsNumeric(arValue(1)) Then Return CInt(arValue(1))
        End If
        Return -1
    End Function

    Private Sub SetupProtocolStepParameters(ByVal iSIID As Integer, ByVal iPSID As Integer)
        Dim psp As QMS.clsProtocolStepParameters
        Dim si As QMS.clsSurveyInstances
        Dim dr As DataRow
        Dim iCalls As Integer = 0
        Dim sFileDefFilterID As String = "0"
        Dim iGroupBySI As Integer = 0
        Dim iGroupBySurvey As Integer = 0
        Dim iGroupByClient As Integer = 0
        Dim sStartTime As String = "9:00 am"
        Dim sEndTime As String = "9:00 pm"

        Session(SESSION_PROTOCOLSTEP_ID_KEY) = String.Format("{0},{1}", iSIID, iPSID)

        If iPSID > 0 Then
            'get protocol step parameter values
            psp = New QMS.clsProtocolStepParameters(m_oConn)
            psp.EnforceConstraints = False
            dr = psp.NewSearchRow
            dr.Item("ProtocolStepID") = iPSID
            psp.FillMain(dr)

            'iCalls = QMS.clsProtocols.ProtocolStepCallAttempts(m_oConn, iPSID)
            iCalls = CInt(DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 8 OR ProtocolStepTypeParamID = 10"))
            sFileDefFilterID = DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 20 OR ProtocolStepTypeParamID = 21").ToString
            iGroupBySI = CInt(DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 62 OR ProtocolStepTypeParamID = 72"))
            iGroupBySurvey = CInt(DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 61 OR ProtocolStepTypeParamID = 71"))
            iGroupByClient = CInt(DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 60 OR ProtocolStepTypeParamID = 70"))
            sStartTime = DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 64 OR ProtocolStepTypeParamID = 74").ToString
            sEndTime = DMI.DataHandler.GetRSValue(psp.DataSet, "SELECT ProtocolStepParamValue FROM ProtocolStepParameters WHERE ProtocolStepTypeParamID = 65 OR ProtocolStepTypeParamID = 75").ToString

            psp.Close()
            psp = Nothing

        End If

        iGroupBySI *= iSIID
        If iSIID > 0 Then
            'get group by ids
            si = New QMS.clsSurveyInstances(m_oConn)
            si.EnforceConstraints = False
            si.FillMain(iSIID)

            iGroupBySurvey *= CInt(si.MainDataTable.Rows(0).Item("SurveyID"))
            iGroupByClient *= CInt(si.MainDataTable.Rows(0).Item("ClientID"))

            si.Close()
            si = Nothing

        End If

        'set form controls:
        'survey, client, survey instance, event code dropdowns, and call attempts
        ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(iGroupBySI.ToString))
        ddlSurveyID.SelectedIndex = ddlSurveyID.Items.IndexOf(ddlSurveyID.Items.FindByValue(iGroupBySurvey.ToString))
        ddlClientID.SelectedIndex = ddlClientID.Items.IndexOf(ddlClientID.Items.FindByValue(iGroupByClient.ToString))
        ddlFileDefFilterID.SelectedValue = sFileDefFilterID
        tbCallAttempts.Text = iCalls.ToString
        tbEarliestTime.Text = sStartTime
        tbLatestTime.Text = sEndTime

    End Sub

    Private Sub CallListGridBind(Optional ByVal sSortBy As String = "")
        Dim iRowCount As Integer

        iRowCount = m_oCallList.DataGridBind(dgCallList, ViewState(LAST_SORT_KEY).ToString)
        If iRowCount = 0 Then
            lbSearchResults.Text = "No Respondents"
            btnGetNext.Visible = False

        ElseIf iRowCount < MAX_CALLIST_ROWS Then
            lbSearchResults.Text = String.Format("{0} Respondents", iRowCount)
            btnGetNext.Visible = True

        Else
            lbSearchResults.Text = String.Format("{0}+ Respondents", iRowCount)
            btnGetNext.Visible = True

        End If

    End Sub

    Private Sub BuildSearch()
        Dim dr As QMS.dsCallList.SearchRow
        Dim bSearchSet As Boolean = False

        dr = CType(m_oCallList.NewSearchRow, QMS.dsCallList.SearchRow)

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

        If IsNumeric(tbCallAttempts.Text) Then dr.CallAttemptsMade = CInt(tbCallAttempts.Text)
        If ddlFileDefFilterID.SelectedIndex > 0 Then dr.FileDefFilterID = CInt(ddlFileDefFilterID.SelectedItem.Value)
        If IsDate(tbEarliestTime.Text) Then dr.LocalTimeStartRange = CDate(tbEarliestTime.Text)
        If IsDate(tbLatestTime.Text) Then dr.LocalTimeEndRange = CDate(tbLatestTime.Text)
        If CInt(ddlTimeZone.SelectedItem.Value) > -99 Then dr.TimeZoneDifference = CInt(dr.TimeZoneDifference)
        If ddlState.SelectedItem.Value.Length > 0 Then dr.State = ddlState.SelectedItem.Value
        dr.Top = MAX_CALLIST_ROWS

        If Not bSearchSet Then dr.RespondentID = 0

        ViewState(SEARCH_KEY) = m_oCallList.SaveSearch(dr, m_sDSName)

    End Sub


    Private Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Try
            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgCallList.CurrentPageIndex = 0
                CallListGridBind()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "btnSearch_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub btnGetNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGetNext.Click
        Try
            Dim iRespondentID As Integer
            Dim drCriteria As DataRow

            If Page.IsValid Then
                drCriteria = m_oCallList.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
                iRespondentID = m_oCallList.GetRespondent(CInt(HttpContext.Current.User.Identity.Name), CType(ViewState("InputMode"), QMS.qmsInputMode), drCriteria)

                If iRespondentID > 0 Then
                    PageCleanUp()
                    'Session("rid") = iRespondentID
                    Response.Redirect(String.Format("../respondents/respondentdetails.aspx?rid={0}&input={1}", _
                                                iRespondentID, _
                                                ViewState("InputMode")))

                Else
                    DMI.WebFormTools.Msgbox(Page, m_oCallList.ErrMsg)

                End If

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "btnGetNext_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Public Sub ValidateCallList(ByVal source As Object, ByVal args As ServerValidateEventArgs)

        'Search must include one or more of the following filters
        If ddlSurveyInstanceID.SelectedIndex = 0 Then
            If ddlSurveyID.SelectedIndex = 0 Then
                If ddlClientID.SelectedIndex = 0 Then
                    cuvValidateCallList.ErrorMessage = "Please filter call list by survey instance, survey, and/or client."
                    args.IsValid = False
                    Exit Sub

                End If
            End If
        End If

        args.IsValid = True

    End Sub

    Private Sub ibAdvanced_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAdvanced.Click
        Try
            DMI.WebFormTools.ShowHidePanel(ibAdvanced, pnlAdvanced)

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "ibAdvanced_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ddlProtocolSteps_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlProtocolSteps.SelectedIndexChanged
        Try
            SetProtocolStep(ddlProtocolSteps.SelectedItem.Value)

            Page.Validate()

            If Page.IsValid Then
                BuildSearch()
                LoadDataSet()
                dgCallList.CurrentPageIndex = 0
                CallListGridBind()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "ddlProtocolSteps_SelectedIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub SetProtocolStep(ByVal sProtocolStep As String)
        Dim sID() As String

        sID = Split(sProtocolStep, ",")

        If sID.Length = 2 Then
            SetupProtocolStepParameters(CInt(sID(0)), CInt(sID(1)))

        End If

    End Sub

    Private Sub lbSearchResults_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lbSearchResults.Click
        Try
            Dim iCount As Integer
            Dim drCriteria As DataRow

            If ViewState(SEARCH_KEY).ToString.Length > 0 Then
                drCriteria = m_oCallList.RestoreSearch(ViewState(SEARCH_KEY).ToString, m_sDSName)
                iCount = m_oCallList.CallListCount(drCriteria)
                DMI.WebFormTools.Msgbox(Page, String.Format("{0} Total respondents", iCount))

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "lbSearchResults_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgCallList_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgCallList.PageIndexChanged
        Try
            BuildSearch()
            LoadDataSet()
            dgCallList.CurrentPageIndex = e.NewPageIndex
            CallListGridBind()
        Catch ex As Exception
            clsLog.LogError(GetType(frmCallList), "dgCallList_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub
End Class
