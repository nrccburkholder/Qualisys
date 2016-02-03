Imports DMI.clsUtil

Partial Class frmRespondentDetails
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
    Private Const EVENTLOG_LAST_SORT_KEY As String = "LastSort"
    Private Const RESPONDENT_ID_KEY As String = "RespondentID"
    Private Const SURVEYINSTANCE_ID_KEY As String = "SurveyInstanceID"
    Private Const INPUTMODE_ID_KEY As String = "InputMode"
    Public Const REQUEST_RESPONDENT_ID_KEY As String = "rid"
    Public Const REQUEST_SURVEYINSTANCE_ID_KEY As String = "siid"
    Public Const REQUEST_INPUTMODE_ID_KEY As String = "input"

    Private m_oRespondentDetails As QMS.clsRespondentDetails
    Private m_oRespondent As QMS.clsRespondents
    Private m_oRespondentProperties As QMS.clsRespondentProperties
    Private m_oHousehold As QMS.clsHouseholds
    Private m_oEventLog As QMS.clsEventLog
    Private m_IInputMode As QMS.IInputMode
    Private m_oConn As SqlClient.SqlConnection
    Private m_sDSName As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            m_oConn = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            m_oRespondentDetails = New QMS.clsRespondentDetails(m_oConn)
            m_oRespondentDetails.UserID = CInt(HttpContext.Current.User.Identity.Name)
            m_oRespondent = m_oRespondentDetails.Respondent
            m_oRespondentProperties = m_oRespondentDetails.RespondentProperties
            m_oHousehold = m_oRespondentDetails.Household
            m_oEventLog = m_oRespondentDetails.EventLog
            m_sDSName = Request.Url.AbsolutePath
            Session.Remove("ds")

            'Determine whether page setup is required:
            'user has posted back to same page
            If Not Page.IsPostBack Then
                PageLoad()
            Else
                m_IInputMode = QMS.clsInputMode.Create(ViewState(INPUTMODE_ID_KEY))
                'retrieve search row
                LoadDataSet()
            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "Page_Load", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")

        End Try

    End Sub

    Private Sub PageLoad()
        'set input mode
        If IsNumeric(Request.QueryString(REQUEST_INPUTMODE_ID_KEY)) Then
            ViewState(INPUTMODE_ID_KEY) = CInt(Request.QueryString(REQUEST_INPUTMODE_ID_KEY))
        Else
            ViewState(INPUTMODE_ID_KEY) = QMS.qmsInputMode.READ_ONLY
        End If

        m_IInputMode = QMS.clsInputMode.Create(ViewState(INPUTMODE_ID_KEY))

        'security check
        If m_IInputMode.AllowUser(CType(Session("Privledges"), ArrayList)) Then
            PageSetup()
            SecuritySetup()
            PageCleanUp()

        Else
            'User cannot access this page in current input mode, reflect
            Response.Redirect(QMS.clsQMSSecurity.NonPrivAccess(Request, Session))

        End If

        If CType(ViewState(INPUTMODE_ID_KEY), QMS.qmsInputMode) = QMS.qmsInputMode.READ_ONLY Then
            'ltBackground.Text = "<STYLE type=""text/css"">BODY { background-color: pink }</STYLE>"
        End If

    End Sub

    Private Sub PageSetup()
        Dim RespondentID As Integer

        'setup view state variables
        ViewState(EVENTLOG_LAST_SORT_KEY) = "EventDate DESC"
        ViewState(RESPONDENT_ID_KEY) = ""
        ViewState(SURVEYINSTANCE_ID_KEY) = ""

        'If IsNumeric(Session("rid")) Then
        '    ViewState(RESPONDENT_ID_KEY) = Session("rid")
        If IsNumeric(Request.QueryString(REQUEST_RESPONDENT_ID_KEY)) Then
            'get respondent id
            ViewState(RESPONDENT_ID_KEY) = CInt(Request.QueryString(REQUEST_RESPONDENT_ID_KEY))
        ElseIf IsNumeric(Request.QueryString(Me.REQUEST_SURVEYINSTANCE_ID_KEY)) Then
            'new respondent, get survey instance id
            ViewState(SURVEYINSTANCE_ID_KEY) = CInt(Request.QueryString(Me.REQUEST_SURVEYINSTANCE_ID_KEY))
        End If

        'get datset
        LoadDataSet()

        'setup form
        LoadDetailsForm()

        'setup datagrids
        dgHousehold.DataKeyField = "RespondentID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgHousehold)
        dgRespondentProperties.DataKeyField = "RespondentPropertyID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgRespondentProperties)
        dgRespondentEvents.DataKeyField = "EventLogID"
        QMS.clsQMSTools.FormatQMSDataGrid(dgRespondentEvents)

        PropertiesGridBind()
        EventLogGridBind()
        SetUpHousehold()

    End Sub

    Private Sub LoadDataSet()
        'get row for respondent
        If IsNumeric(ViewState(RESPONDENT_ID_KEY)) Then
            'get existing respondent
            m_oRespondentDetails.Fill(CInt(ViewState(RESPONDENT_ID_KEY)))

        ElseIf IsNumeric(ViewState(SURVEYINSTANCE_ID_KEY)) Then
            'fill the simple tables
            m_oRespondentDetails.FillLookups()
            'create new respondent
            m_oRespondent.SurveyInstanceID = CInt(ViewState(SURVEYINSTANCE_ID_KEY))
            m_oRespondent.AddMainRow()

        End If

    End Sub

    Private Sub PageCleanUp()
        If Not IsNothing(m_oConn) Then
            m_oConn.Close()
            m_oConn.Dispose()
            m_oConn = Nothing
        End If
        m_oRespondent = Nothing
        m_oRespondentProperties = Nothing
        m_oHousehold = Nothing
        m_oEventLog = Nothing
        If Not IsNothing(m_oRespondentDetails) Then
            m_oRespondentDetails.Close()
            m_oRespondentDetails = Nothing
        End If
        m_IInputMode = Nothing

    End Sub

    Private Sub LoadDetailsForm()
        Dim dr As QMS.dsRespondentDetails.RespondentsRow = CType(m_oRespondent.MainDataTable.Rows(0), QMS.dsRespondentDetails.RespondentsRow)
        Dim sqlDR As SqlClient.SqlDataReader

        'setup state ddl
        sqlDR = QMS.clsQMSTools.GetStatesDataSource(m_oConn)
        ddlState.DataSource = sqlDR
        ddlState.DataTextField = "StateName"
        ddlState.DataValueField = "State"
        ddlState.DataBind()
        ddlState.Items.Insert(0, New ListItem("None", ""))
        sqlDR.Close()
        sqlDR = Nothing

        'set id
        If dr.RowState = DataRowState.Added Then
            'new respondent
            ltRespondentID.Text = "NEW"
            ltSurveyInstanceName.Visible = False

            ibUpdateResp.Visible = False
            ibUpdateHousehold.Visible = False
            ibAddProperty.Visible = False
            ibDeleteProperty.Visible = False
            ibClearResponses.Visible = False
            hlResponseHistory.Visible = False
            pnlDetails.Visible = False

            sqlDR = QMS.clsSurveyInstances.GetSurveyInstanceDataSource(m_oConn)
            ddlSurveyInstanceID.DataSource = sqlDR
            ddlSurveyInstanceID.DataTextField = "SurveyInstanceName"
            ddlSurveyInstanceID.DataValueField = "SurveyInstanceID"
            ddlSurveyInstanceID.DataBind()
            sqlDR.Close()
            sqlDR = Nothing

            If IsNumeric(ViewState(SURVEYINSTANCE_ID_KEY)) Then
                ddlSurveyInstanceID.SelectedIndex = ddlSurveyInstanceID.Items.IndexOf(ddlSurveyInstanceID.Items.FindByValue(ViewState(SURVEYINSTANCE_ID_KEY).ToString))

            End If

        Else
            'existing respondent
            ltRespondentID.Text = dr.Item("RespondentID")
            ddlSurveyInstanceID.Visible = False
            ltSurveyInstanceName.Text = String.Format("{0}: {1}: {2}", dr.SurveyName, dr.ClientName, dr.SurveyInstanceName)
            hlResponseHistory.NavigateUrl = String.Format("responses.aspx?{0}={1}", frmResponses.RESPONDENT_ID_KEY, dr.Item("RespondentID"))
            'set controls for existing respondent
            InitOutcomeControls()
            CheckFinal()
            UpdateScriptLink()
            lblInputOutcome.Text = String.Format("{0} Outcome", m_IInputMode.InputModeName)

        End If

        If Not dr.IsFirstNameNull Then tbFirstName.Text = dr.FirstName
        tbLastName.Text = dr.LastName
        If Not dr.IsMiddleInitialNull Then tbMiddleInitial.Text = dr.MiddleInitial
        If Not dr.IsAddress1Null Then tbAddress1.Text = dr.Address1
        If Not dr.IsAddress2Null Then tbAddress2.Text = dr.Address2
        If Not dr.IsCityNull Then tbCity.Text = dr.City
        If Not dr.IsStateNull Then ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(dr.State))
        If Not dr.IsPostalCodeNull Then tbPostalCode.Text = dr.PostalCode
        If Not dr.IsTelephoneDayNull Then tbTelephoneDay.Text = DMI.clsUtil.FormatTelephone(dr.TelephoneDay)
        If Not dr.IsTelephoneEveningNull Then tbTelephoneEvening.Text = DMI.clsUtil.FormatTelephone(dr.TelephoneEvening)
        If Not dr.IsEmailNull Then tbEmail.Text = dr.Email
        If Not dr.IsGenderNull Then ddlGender.SelectedIndex = ddlGender.Items.IndexOf(ddlGender.Items.FindByValue(dr.Gender.ToUpper))
        'Hide the SSN and DOB for SecurityTP
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_ADMIN) Then
            If Not dr.IsSSNNull Then tbSSN.Text = dr.SSN
            If Not dr.IsDOBNull Then tbDOB.Text = String.Format("{0:d}", dr.DOB)
            If Not dr.IsClientRespondentIDNull Then tbClientRespondentID.Text = dr.ClientRespondentID
        Else
            If Not dr.IsSSNNull Then
                tbSSN.Text = CommonTools.clsSecurity.Encrypt(dr.SSN)            
            End If
            If Not dr.IsDOBNull Then
                tbDOB.Text = CommonTools.clsSecurity.Encrypt(dr.DOB.ToShortDateString)
            End If
            If Not dr.IsClientRespondentIDNull Then tbClientRespondentID.Text = CommonTools.clsSecurity.Encrypt(dr.ClientRespondentID)
            tbSSN.Visible = False
            tbDOB.Visible = False
            cvDOB.Enabled = False
            tbClientRespondentID.Visible = False
        End If


        If Not dr.IsBatchIDNull Then tbBatchID.Text = dr.BatchID
        'If Not dr.IsDOBNull Then tbDOB.Text = String.Format("{0:d}", dr.DOB)
        If Not dr.IsNextContactNull And dr.Final = 0 Then
            ltNextContact.Text = dr.NextContact
        ElseIf dr.Final = 1 Then
            ltNextContact.Text = "FINAL"
        Else
            ltNextContact.Text = Now()
        End If
        ltCallsMade.Text = dr.CallsMade
        If Not dr.IsPostalCodeExtNull Then tbPostalCodeExt.Text = dr.PostalCodeExt

        'set done link
        DMI.WebFormTools.SetReferingURL(Request, hlDone, "(/operations/scriptscreen\.aspx|/operations/interview\.aspx|/respondents/respondentdetails\.aspx|/operations/interviewLite\.aspx)", Session)

    End Sub

    Private Sub HouseholdGridBind()
        Dim iRowCount As Integer
        iRowCount = m_oHousehold.DataGridBind(dgHousehold, "LastName, FirstName")
        ltResultsFoundHousehold.Text = String.Format("{0} Members", iRowCount)

    End Sub

    Private Sub PropertiesGridBind()
        Dim iRowCount As Integer
        iRowCount = m_oRespondentProperties.DataGridBind(dgRespondentProperties, "PropertyName")

    End Sub

    Private Sub EventLogGridBind()
        Dim iRowCount As Integer
        iRowCount = m_oEventLog.DataGridBind(dgRespondentEvents, ViewState(EVENTLOG_LAST_SORT_KEY).ToString)
        ltResultsFoundEvents.Text = String.Format("{0} Events", iRowCount)

    End Sub

    Private Sub SecuritySetup()
        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_EDIT) Then
            'must have edit respondent rights to update respondent details
            ibUpdateResp.Visible = False
            ibUpdateHousehold.Visible = False
            ibAddProperty.Visible = False
            ibDeleteProperty.Visible = False

        End If

        If Not QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENTEVENTS_EDIT) Then
            'must have edit respondent events rights to delete respondent events
            ibDeleteEvent.Visible = False
            ibOverride.Visible = False
            ibClearResponses.Visible = False
            hlResponseHistory.Visible = False

        End If

        If ViewState(INPUTMODE_ID_KEY) = QMS.qmsInputMode.READ_ONLY Then
            ibDeleteEvent.Visible = False
            ibOverride.Visible = False
            ibClearResponses.Visible = False
            hlResponseHistory.Visible = False
            ibSchedule.Visible = False
            ibUpdateHousehold.Visible = False
            ibUpdateResp.Visible = False
            ibSubmitHousehold.Visible = False
            ibSubmitResp.Visible = False
            ibSubmitNote.Visible = False
            ibAddProperty.Visible = False
            ibDeleteProperty.Visible = False
            dgRespondentProperties.Columns(3).Visible = False
            hlStartScript.Visible = False
            pnlActions.Visible = False
            pnlChangeInputMode.Visible = True
            InitChangeModePanel()
        End If
    End Sub

    Private Sub UpdateRespondent(Optional ByVal bHousehold As Boolean = False)
        Dim dr As QMS.dsRespondentDetails.RespondentsRow = CType(m_oRespondent.MainDataTable.Rows(0), QMS.dsRespondentDetails.RespondentsRow)
        Dim bNew As Boolean = False

        If dr.RowState = DataRowState.Added Then
            'identitied new respondent
            If IsNumeric(ViewState(SURVEYINSTANCE_ID_KEY)) Then dr.SurveyInstanceID = CInt(ViewState(SURVEYINSTANCE_ID_KEY))
            bNew = True
        End If

        'copy detail field values into datarow
        If tbFirstName.Text.Length > 0 Then
            dr.FirstName = tbFirstName.Text
        Else
            dr.SetFirstNameNull()
        End If
        dr.MiddleInitial = tbMiddleInitial.Text
        dr.LastName = tbLastName.Text
        If tbAddress1.Text.Length > 0 Then
            dr.Address1 = tbAddress1.Text
        Else
            dr.SetAddress1Null()
        End If
        If tbAddress2.Text.Length > 0 Then
            dr.Address2 = tbAddress2.Text
        Else
            dr.SetAddress2Null()
        End If
        If tbCity.Text.Length > 0 Then
            dr.City = tbCity.Text
        Else
            dr.SetCityNull()
        End If
        If ddlState.SelectedIndex > 0 Then
            dr.State = ddlState.SelectedItem.Value
        Else
            dr.SetStateNull()
        End If
        If tbPostalCode.Text.Length > 0 Then
            dr.PostalCode = tbPostalCode.Text
        Else
            dr.SetPostalCodeNull()
        End If
        If tbPostalCodeExt.Text.Length > 0 Then
            dr.PostalCodeExt = tbPostalCodeExt.Text
        Else
            dr.SetPostalCodeExtNull()
        End If
        If tbTelephoneDay.Text.Length > 0 Then
            dr.TelephoneDay = DMI.clsUtil.RemoveTelephoneFormat(tbTelephoneDay.Text)
        Else
            dr.SetTelephoneDayNull()
        End If
        If tbTelephoneEvening.Text.Length > 0 Then
            dr.TelephoneEvening = DMI.clsUtil.RemoveTelephoneFormat(tbTelephoneEvening.Text)
        Else
            dr.SetTelephoneEveningNull()
        End If
        If tbEmail.Text.Length > 0 Then
            dr.Email = tbEmail.Text
        Else
            dr.SetEmailNull()
        End If
        If ddlGender.SelectedIndex > 0 Then
            dr.Gender = ddlGender.SelectedItem.Value
        Else
            dr.SetGenderNull()
        End If        
        If tbBatchID.Text.Length > 0 Then
            dr.BatchID = CInt(tbBatchID.Text)
        Else
            dr.SetBatchIDNull()
        End If
        'TP Put in for Security
        If QMS.clsQMSSecurity.CheckPrivledge(CType(Session("Privledges"), ArrayList), QMS.qmsSecurity.RESPONDENT_ADMIN) Then
            If tbSSN.Text.Length > 0 Then
                dr.SSN = tbSSN.Text
            Else
                dr.SetSSNNull()
            End If
            If IsDate(tbDOB.Text) Then
                dr.DOB = CDate(tbDOB.Text)
            Else
                dr.SetDOBNull()
            End If
            If tbClientRespondentID.Text.Length > 0 Then
                dr.ClientRespondentID = tbClientRespondentID.Text
            Else
                dr.SetClientRespondentIDNull()
            End If
        Else
            If tbSSN.Text.Length > 0 Then
                dr.SSN = CommonTools.clsSecurity.Decrypt(tbSSN.Text)
            Else
                dr.SetSSNNull()
            End If
            Dim dteString As String = tbDOB.Text
            If dteString.Length > 0 Then dteString = CommonTools.clsSecurity.Decrypt(tbDOB.Text)
            If IsDate(dteString) Then
                dr.DOB = CDate(dteString)
            Else
                dr.SetDOBNull()
            End If
            If tbClientRespondentID.Text.Length > 0 Then
                dr.ClientRespondentID = CommonTools.clsSecurity.Decrypt(tbClientRespondentID.Text)
            Else
                dr.SetClientRespondentIDNull()
            End If
        End If
        
        m_oRespondent.Save()

        If bNew Then
            PageCleanUp()
            Response.Redirect(String.Format("respondentdetails.aspx?{1}={0}", dr.RespondentID, REQUEST_RESPONDENT_ID_KEY))

        ElseIf bHousehold Then
            If m_oRespondent.ChangedAddress Then m_oHousehold.UpdateAddress(dr)
            If m_oRespondent.ChangedTelephone Then m_oHousehold.UpdateTelephone(dr)

        End If

        'update respondent details
        m_oRespondentDetails.Refresh()
        LoadDetailsForm()
        EventLogGridBind()

    End Sub

    Private Sub dgRespondentEvents_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgRespondentEvents.PageIndexChanged
        Try
            m_oEventLog.DataGridPageChange(dgRespondentEvents, e, ViewState(EVENTLOG_LAST_SORT_KEY).ToString)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentEvents_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try


    End Sub

    Private Sub dgRespondentEvents_SortCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs) Handles dgRespondentEvents.SortCommand
        Try
            ViewState(EVENTLOG_LAST_SORT_KEY) = m_oEventLog.DataGridSort(dgRespondentEvents, e, ViewState(EVENTLOG_LAST_SORT_KEY).ToString)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentEvents_SortCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibDeleteEvent_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDeleteEvent.Click
        Try
            m_oEventLog.DataGridDelete(dgRespondentEvents, ViewState(EVENTLOG_LAST_SORT_KEY).ToString)
            ltResultsFoundEvents.Text = String.Format("{0} Events", m_oEventLog.MainDataTable.Rows.Count)
            m_oRespondentDetails.Refresh()
            LoadDetailsForm()

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibDeleteEvent_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondentProperties_EditCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgRespondentProperties.EditCommand
        Try
            m_oRespondentProperties.DataGridEditItem(dgRespondentProperties, e, "PropertyName")

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentProperties_EditCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondentProperties_CancelCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgRespondentProperties.CancelCommand
        Try
            m_oRespondentProperties.DataGridCancel(dgRespondentProperties, "PropertyName")

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentProperties_CancelCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondentProperties_UpdateCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs) Handles dgRespondentProperties.UpdateCommand
        Try
            Dim dr As QMS.dsRespondentDetails.RespondentPropertiesRow

            If Page.IsValid Then
                'get existing datarow or create new datarow
                dr = CType(m_oRespondentProperties.SelectRow(String.Format("RespondentPropertyID = {0}", dgRespondentProperties.DataKeys(e.Item.ItemIndex))), QMS.dsRespondentDetails.RespondentPropertiesRow)
                If IsNothing(dr) Then
                    m_oRespondentProperties.RespondentID = CInt(ViewState(RESPONDENT_ID_KEY))
                    dr = CType(m_oRespondentProperties.AddMainRow, QMS.dsRespondentDetails.RespondentPropertiesRow)

                End If

                'copy form values into datarow
                With e.Item
                    dr.PropertyName = CType(.FindControl("tbPropertyName"), TextBox).Text
                    dr.PropertyValue = CType(.FindControl("tbPropertyValue"), TextBox).Text

                End With

                'commit changes to database
                m_oRespondentProperties.Save()

                'check for save errors
                If m_oRespondentProperties.ErrMsg.Length = 0 Then
                    'exit edit mode and rebind datagrid
                    dgRespondentProperties.EditItemIndex = -1
                    PropertiesGridBind()

                Else
                    'display save errors
                    DMI.WebFormTools.Msgbox(Page, m_oRespondentProperties.ErrMsg)

                End If

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentProperties_UpdateCommand", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibDeleteProperty_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibDeleteProperty.Click
        Try
            m_oRespondentProperties.DataGridDelete(dgRespondentProperties, "PropertyName")

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibDeleteProperty_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibAddProperty_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibAddProperty.Click
        Try
            m_oRespondentProperties.DataGridNewItem(dgRespondentProperties, "RespondentPropertyID")
        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibAddProperty_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub InitOutcomeControls()
        Dim sqlDR As SqlClient.SqlDataReader
        Dim im As QMS.qmsInputMode = CType(ViewState("InputMode"), QMS.qmsInputMode)
        Dim respondentID As Integer = CInt(m_oRespondent.MainDataTable.Rows(0).Item("RespondentID"))

        If im = QMS.qmsInputMode.VERIFY Then
            QMS.clsQMSTools.SetVerifyScriptDDL(m_oConn, ddlScriptID, respondentID)
        Else
            sqlDR = QMS.clsScripts.GetInputScriptsForRespondent(m_oConn, im, respondentID)
            ddlScriptID.DataValueField = "ScriptID"
            ddlScriptID.DataTextField = "Name"
            ddlScriptID.DataSource = sqlDR
            ddlScriptID.DataBind()
            If ddlScriptID.Items.Count = 0 Then
                ddlScriptID.Items.Insert(0, New ListItem("No scripts available", 0))
            End If
            sqlDR.Close()
        End If

        sqlDR = QMS.clsEvents.GetSurveyInstanceEventDataSource(m_oConn, _
            CInt(m_oRespondent.MainDataTable.Rows(0).Item("SurveyInstanceID")), _
            m_IInputMode.EventTypeIDList)
        ddlEventID.DataValueField = "EventID"
        ddlEventID.DataTextField = "Name"
        ddlEventID.DataSource = sqlDR
        ddlEventID.DataBind()
        ddlEventID.Items.Insert(0, New ListItem("Select Outcome", 0))
        sqlDR.Close()
        sqlDR = Nothing

    End Sub

    Private Sub ddlScriptID_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlScriptID.SelectedIndexChanged
        Try
            UpdateScriptLink()
        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ddlScriptID_SelectedIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub UpdateScriptLink()
        If ddlScriptID.Items.Count > 0 AndAlso IsNumeric(ddlScriptID.SelectedItem.Value) AndAlso CType(ddlScriptID.SelectedItem.Value, Integer) > 0 Then
            'hlStartScript.NavigateUrl = String.Format("../operations/scriptscreen.aspx?scrid={0}&rid={1}&input={2}", _
            'ddlScriptID.SelectedItem.Value, _
            'ltRespondentID.Text, _
            'ViewState(INPUTMODE_ID_KEY))
            Dim interviewPage As String = "interviewLite.aspx"
            hlStartScript.Visible = True
            hlStartScript.NavigateUrl = String.Format("../operations/{6}?{0}={1}&{2}={3}&{4}={5}", _
                frmInterview.SCRIPT_ID_KEY, ddlScriptID.SelectedItem.Value, _
                frmInterview.RESPONDENT_ID_KEY, ltRespondentID.Text, _
                frmInterview.INPUTMODE_ID_KEY, ViewState(INPUTMODE_ID_KEY), _
                interviewPage)
            hlStartScriptReadOnly.Visible = True
            hlStartScriptReadOnly.NavigateUrl = String.Format("../operations/{6}?{0}={1}&{2}={3}&{4}={5}", _
                frmInterview.SCRIPT_ID_KEY, ddlScriptID.SelectedItem.Value, _
                frmInterview.RESPONDENT_ID_KEY, ltRespondentID.Text, _
                frmInterview.INPUTMODE_ID_KEY, 9, _
                interviewPage)

        Else
            hlStartScript.Visible = False
            hlStartScript.NavigateUrl = ""
            hlStartScriptReadOnly.Visible = True
            hlStartScriptReadOnly.NavigateUrl = ""

        End If

    End Sub

    Private Sub LogOutcome(Optional ByVal bHousehold As Boolean = False)
        'check that outcome was selected
        If ddlEventID.SelectedIndex > 0 Then
            'check if respondent was selected from call list
            If Not Session(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY) Is Nothing AndAlso IsNumeric(Session(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY)) Then
                m_oRespondent.InsertEvent(CInt(ddlEventID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name), "", frmCallList.ExtractProtocolStepID(Session(frmCallList.SESSION_PROTOCOLSTEP_ID_KEY).ToString()))
            Else
                m_oRespondent.InsertEvent(CInt(ddlEventID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name), "")
            End If

            If bHousehold Then m_oHousehold.LogEvent(CInt(ddlEventID.SelectedItem.Value), CInt(HttpContext.Current.User.Identity.Name), "")

            'update event datagrid
            m_oRespondentDetails.Refresh()
            LoadDetailsForm()
            EventLogGridBind()

            ddlEventID.SelectedIndex = 0

        Else
            DMI.WebFormTools.Msgbox(Me, "Please select an outcome")

        End If

    End Sub

    Private Sub SetUpHousehold()
        If m_oHousehold.MainDataTable.Rows.Count > 0 Then
            'show household grid
            pnlHousehold.Visible = True
            HouseholdGridBind()

        Else
            'hide household controls
            pnlHousehold.Visible = False
            ibUpdateHousehold.Visible = False
            ibSubmitHousehold.Visible = False

        End If

    End Sub

    Private Sub ibSchedule_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSchedule.Click
        Try
            If IsDate(tbAppointmentDate.Text) Then
                m_oRespondent.ScheduleAppointment(CDate(tbAppointmentDate.Text), tbAppointmentTime.Text, CInt(HttpContext.Current.User.Identity.Name))
                'update respondent details
                m_oRespondentDetails.Refresh()
                LoadDetailsForm()
                EventLogGridBind()

                If m_oRespondent.ErrMsg.Length > 0 Then
                    DMI.WebFormTools.Msgbox(Page, m_oRespondent.ErrMsg)

                End If

            Else
                DMI.WebFormTools.Msgbox(Me, "Please provide appointment date in mm/dd/yyyy format")

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibSchedule_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibUpdateHousehold_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateHousehold.Click
        Try
            UpdateRespondent(True)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibUpdateHousehold_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibUpdateResp_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibUpdateResp.Click
        Try
            UpdateRespondent()

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibUpdateResp_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibSubmitHousehold_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSubmitHousehold.Click
        Try
            LogOutcome(True)

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibSubmitHousehold_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibSubmitResp_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSubmitResp.Click
        Try
            LogOutcome()

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibSubmitResp_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondentEvents_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.DataGridItemEventArgs) Handles dgRespondentEvents.ItemDataBound
        Dim drv As DataRowView

        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            drv = CType(e.Item.DataItem, DataRowView)

            CType(e.Item.FindControl("ltEvent"), Literal).Text = String.Format("<b>{0}: {1}</b><br><i>{2}</i>", _
                drv.Item("EventID"), drv.Row.GetParentRow("tblEventsEventLog").Item("Name"), _
                drv.Row.GetParentRow("tblEventsEventLog").Item("Description"))

            If Not IsDBNull(drv.Item("EventParameters")) Then
                CType(e.Item.FindControl("ltEventParameters"), Literal).Text = drv.Item("EventParameters")

            End If

            CType(e.Item.FindControl("ltUsername"), Literal).Text = drv.Row.GetParentRow("UsersEventLog").Item("Username")

        End If

    End Sub

    Private Sub CheckFinal()
        If m_oRespondent.IsFinal Then
            If IsNothing(ddlScriptID.Items.FindByText("RESPONDENT IS FINAL")) Then ddlScriptID.Items.Insert(0, New ListItem("RESPONDENT IS FINAL", 0))
            If Not IsNothing(ddlScriptID.Items.FindByText("No scripts available")) Then ddlScriptID.Items.Remove(ddlScriptID.Items.FindByText("No scripts available"))
            If IsNothing(ddlEventID.Items.FindByText("RESPONDENT IS FINAL")) Then ddlEventID.Items.Insert(0, New ListItem("RESPONDENT IS FINAL", 0))
            If Not IsNothing(ddlEventID.Items.FindByText("Select Outcome")) Then ddlEventID.Items.Remove(ddlScriptID.Items.FindByText("Select Outcome"))
            ddlScriptID.SelectedIndex = 0
            ddlEventID.SelectedIndex = 0

        End If
        lblIsFinal.Visible = m_oRespondent.IsFinal

    End Sub

    Private Sub ibClearResponses_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibClearResponses.Click
        Try
            m_oRespondent.ClearResponses()

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibClearResponses_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibSubmitNote_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibSubmitNote.Click
        Try
            m_oRespondent.SaveNote(tbNotes.Text, CInt(HttpContext.Current.User.Identity.Name))
            If m_oRespondent.ErrMsg.Length > 0 Then
                'error occured in saving note
                DMI.WebFormTools.Msgbox(Page, m_oRespondent.ErrMsg)

            Else
                'clear notes
                tbNotes.Text = ""
                'update respondent details
                m_oRespondentDetails.Refresh()
                EventLogGridBind()

            End If

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibSubmitNote_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub dgRespondentProperties_PageIndexChanged(ByVal source As Object, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs) Handles dgRespondentProperties.PageIndexChanged
        Try
            m_oRespondentProperties.DataGridPageChange(dgRespondentProperties, e, "PropertyName")

        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "dgRespondentProperties_PageIndexChanged", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try

    End Sub

    Private Sub ibOverride_Click(ByVal sender As System.Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ibOverride.Click
        Try
            If dgRespondentEvents.EditItemIndex = -1 Then
                For Each dgi As DataGridItem In dgRespondentEvents.Items
                    If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                        Dim dr As DataRow = m_oRespondentDetails.EventLog.SelectRow(CInt(dgRespondentEvents.DataKeys(dgi.ItemIndex)))
                        Dim eventID As Integer = CInt(dr.Item("EventID"))
                        If eventID = 3040 Or eventID = 3041 Or eventID = 3042 Then
                            dr.Item("EventID") = CInt(QMS.qmsEvents.OVERRIDE_SURVEY_AUDIT)
                            dr.Item("UserID") = CInt(HttpContext.Current.User.Identity.Name)

                        End If
                    End If
                Next
                m_oRespondentDetails.EventLog.Save()
                EventLogGridBind()
            End If
        Catch ex As Exception
            clsLog.LogError(GetType(frmRespondentDetails), "ibOverride_Click", ex)
            DMI.WebFormTools.Msgbox(Me.Page, "Sorry an error occured.\nError has been logged, please report to administrator.")
        Finally
            PageCleanUp()
        End Try
    End Sub

    Private Sub InitChangeModePanel()
        Dim url As String = "selectrespondent.aspx?rid={0}&input={1}"
        Dim iRespondentID As Integer = CInt(ViewState(RESPONDENT_ID_KEY))
        hlChangeDE.NavigateUrl = String.Format(url, iRespondentID, 1)
        hlChangeVerfication.NavigateUrl = String.Format(url, iRespondentID, 2)
        hlChangeCati.NavigateUrl = String.Format(url, iRespondentID, 3)
        hlChangeReminder.NavigateUrl = String.Format(url, iRespondentID, 4)
        hlChangeIncoming.NavigateUrl = String.Format(url, iRespondentID, 8)
        hlChangeReadOnly.NavigateUrl = String.Format(url, iRespondentID, 9)

    End Sub
End Class
